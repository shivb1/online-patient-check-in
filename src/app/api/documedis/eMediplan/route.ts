import { NextRequest, NextResponse } from "next/server";
import zlib from "zlib";

/**
 * Interface für das formatierte Medikament, das an das Frontend gesendet wird.
 */
interface FormattedMedication {
  id: string;
  name: string;
  description: string;
}

/**
 * Erwartete Struktur der Documedis-API-Antwort (Produkte & Substanzen).
 */
interface DocumedisResponse {
  description?: string | { description?: string };
  name?: string; // Fallback für Substanzen-Register
}

/**
 * Sichere Hilfsfunktion: Sucht in einem JSON-Objekt (case-insensitive) nach bestimmten Schlüsseln.
 * Ignoriert explizit Null-Werte, um zu verhindern, dass "null" als ID verwendet wird.
 * * @param obj - Das zu durchsuchende Objekt.
 * @param keysToFind - Array mit den gesuchten Schlüsseln (z.B. ["id", "gtin"]).
 * @returns Den Wert des Schlüssels oder undefined.
 */
function findKey(obj: unknown, keysToFind: string[]): unknown {
  if (!obj || typeof obj !== "object") return undefined;
  
  const record = obj as Record<string, unknown>;
  const lowerKeys = keysToFind.map(k => k.toLowerCase());
  
  for (const [key, value] of Object.entries(record)) {
    if (lowerKeys.includes(key.toLowerCase())) {
      if (value === null || value === "null") return undefined;
      return value;
    }
  }
  return undefined;
}

/**
 * Versucht, den echten Namen eines Produkts über verschiedene ID-Typen aufzulösen.
 */
async function resolveProductName(id: string, apiUrl: string, headers: Record<string, string>): Promise<string> {
  // Wir probieren verschiedene Typen durch, da eMedipläne oft IdType 4 (Proprietär) senden
  const typesToTry = ["Pharmacode", "Gtin", "ProductNumber"];
  const idsToTry = [id];
  
  // Schweizer Pharmacodes sind 7-stellig. Kurze IDs müssen mit Nullen aufgefüllt werden.
  if (id.length <= 7) {
    idsToTry.push(id.padStart(7, "0"));
  }

  for (const idType of typesToTry) {
    for (const queryId of idsToTry) {
      try {
        const res = await fetch(`${apiUrl}/products/${queryId}?IdType=${idType}`, { headers });
        if (res.ok) {
          const data = await res.json() as DocumedisResponse;
          if (data.description && typeof data.description === "object" && data.description.description) {
            return data.description.description;
          } else if (typeof data.description === "string") {
            return data.description;
          }
        }
      } catch (e) {
        // Bei Fehler lautlos ignorieren und nächste Variante versuchen
      }
    }
  }
  return "";
}

/**
 * Versucht, den Namen eines reinen Wirkstoffs (Substance) aufzulösen,
 * falls die ID zu keinem verkaufbaren Produkt gehört.
 */
async function resolveSubstanceName(id: string, apiUrl: string, headers: Record<string, string>): Promise<string> {
  try {
    const res = await fetch(`${apiUrl}/registers/substance/${id}`, { headers });
    if (res.ok) {
      const data = await res.json() as DocumedisResponse;
      if (data.description && typeof data.description === "object" && data.description.description) {
        return data.description.description;
      } else if (typeof data.description === "string") {
        return data.description;
      } else if (data.name && typeof data.name === "string") {
        return data.name;
      }
    }
  } catch (e) {
    // Lautlos ignorieren
  }
  return "";
}

/**
 * POST-Route zur Entschlüsselung und intelligenten Anreicherung von eMediplan-Daten.
 */
export async function POST(request: NextRequest) {
  try {
    const body = await request.json() as { chmedString?: string };
    const { chmedString } = body;

    if (!chmedString || !chmedString.startsWith("CHMED")) {
      return NextResponse.json({ error: "Kein gültiger eMediplan-Code." }, { status: 400 });
    }

    // 1. Dekomprimierung
    const base64Payload = chmedString.substring(9);
    const buffer = Buffer.from(base64Payload, "base64");
    const unzipped = zlib.gunzipSync(buffer).toString("utf-8");
    const eMediplanData = JSON.parse(unzipped) as Record<string, unknown>;

    const rawMedicaments = (eMediplanData.Medicaments || eMediplanData.medicaments || []) as unknown[];
    const uniqueMedsMap = new Map<string, Record<string, unknown>>();
    
    // 2. Deduplizierung und ID-Extraktion
    rawMedicaments.forEach((medItem) => {
      if (!medItem || typeof medItem !== "object") return;
      const med = medItem as Record<string, unknown>;
      
      const art = findKey(med, ["art", "article"]);
      const subs = findKey(med, ["subs", "substances"]);

      const medIdRaw = findKey(med, ["gtin"]) || findKey(med, ["pharmacode"]) || findKey(med, ["id"])
                    || findKey(art, ["gtin", "pharmacode", "id"]);
      
      const medId = medIdRaw ? String(medIdRaw) : "";

      if (medId && !uniqueMedsMap.has(medId)) {
        uniqueMedsMap.set(medId, med);
      } else if (!medId) {
        uniqueMedsMap.set(Math.random().toString(), med); 
      }
    });

    const uniqueMedicaments = Array.from(uniqueMedsMap.values());

    const API_URL = process.env.DOCUMEDIS_API_URL;
    const API_KEY = process.env.DOCUMEDIS_API_KEY;
    const headers = {
      "Accept": "application/json",
      "HCI-CustomerId": "236342",
      "HCI-Index": "hospindex",
      "HCI-SoftwareOrgId": "236342",
      "HCI-SoftwareOrg": "AcmeCorporation",
      "HCI-Software": "AcmeCorpCisHospitalXy",
      "HCI-SubCatalogId": "D683",
      "HCI-WholesalerGln": "7601001401297",
      "Authorization": API_KEY as string
    };

    // 3. Parallele Datenanreicherung (Intelligentes Documedis Fetching)
    const enrichedMedications: FormattedMedication[] = await Promise.all(
      uniqueMedicaments.map(async (med) => {
        let realName = "";
        
        const art = findKey(med, ["art", "article"]);
        const subs = findKey(med, ["subs", "substances"]);

        // A. Lokaler Name aus dem Plan
        const artName = findKey(art, ["dscr", "name"]);
        if (artName) realName = String(artName);

        if (!realName && Array.isArray(subs) && subs.length > 0) {
          const firstSub = subs[0];
          const subName = findKey(firstSub, ["dscr", "name"]);
          if (subName) realName = String(subName);
        }

        if (!realName) {
          const rootName = findKey(med, ["dscr", "name"]);
          if (rootName) realName = String(rootName);
        }

        // B. IDs auslesen (Produkt vs. Substanz)
        const medIdRaw = findKey(med, ["gtin", "pharmacode", "id"]) || findKey(art, ["gtin", "pharmacode", "id"]);
        const medId = medIdRaw ? String(medIdRaw) : "";

        let subId = "";
        if (Array.isArray(subs) && subs.length > 0) {
           const sId = findKey(subs[0], ["id"]);
           if (sId) subId = String(sId);
        }

        // C. API-Brute-Force, falls Name fehlt
        if (API_URL && API_KEY && !realName) {
          // Versuch 1: Als Produkt (Schachtel) suchen
          if (medId) {
            realName = await resolveProductName(medId, API_URL, headers);
          }
          // Versuch 2: Als reine Substanz/Wirkstoff suchen (falls Produkt fehlschlägt)
          if (!realName && subId) {
            realName = await resolveSubstanceName(subId, API_URL, headers);
          }
          // Versuch 3: Vielleicht ist medId eigentlich eine Substanz-ID?
          if (!realName && medId) {
            realName = await resolveSubstanceName(medId, API_URL, headers);
          }
        }

        // D. Fallback UI, falls Test-Umgebung die ID komplett verweigert
        if (!realName) {
            if (medId) {
                realName = `Unbekanntes Produkt (ID: ${medId})`;
            } else if (subId) {
                realName = `Unbekannter Wirkstoff (ID: ${subId})`;
            } else {
                const tkgRsn = findKey(med, ["tkgRsn"]);
                realName = tkgRsn ? `Verordnung: ${String(tkgRsn)}` : "Medikament (Keine IDs hinterlegt)";
            }
        }

        // 4. Dosierung strukturiert auslesen
        let dosageString = "";
        const localDosage = findKey(med, ["dosage", "dosis"]);
        if (localDosage) {
          dosageString = String(localDosage);
        } else {
          const pos = findKey(med, ["pos", "posology"]);
          if (Array.isArray(pos) && pos.length > 0 && typeof pos[0] === "object" && pos[0] !== null) {
            const p = findKey(pos[0], ["p"]);
            if (Array.isArray(p)) dosageString = p.join("-");
          }
        }
        
        const desc = dosageString ? `Dosierung: ${dosageString}` : "Vom eMediplan importiert";

        return {
          id: medId || subId || Math.random().toString(),
          name: realName,
          description: desc
        };
      })
    );

    return NextResponse.json({ medications: enrichedMedications });

  } catch (error) {
    console.error("Fehler beim Verarbeiten des eMediplans:", error);
    return NextResponse.json({ error: "Fehler beim Verarbeiten der eMediplan-Daten." }, { status: 500 });
  }
}