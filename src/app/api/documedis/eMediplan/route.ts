import { NextRequest, NextResponse } from "next/server";

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { chmedString } = body;

    if (!chmedString) {
      return NextResponse.json({ error: "Kein eMediplan-String übergeben." }, { status: 400 });
    }

    const API_URL = process.env.DOCUMEDIS_API_URL;
    const API_KEY = process.env.DOCUMEDIS_API_KEY;

    // Documedis API Endpunkt zum Parsen von CHMED-Strings.
    // (Passe diesen Endpunkt an, falls euer BFH-Python-Skript einen anderen Pfad nutzt)
    const documedisUrl = `${API_URL}/chmed/parse`; 

    const documedisResponse = await fetch(documedisUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "HCI-CustomerId": "236342",
        "HCI-Index": "hospindex",
        "HCI-SoftwareOrgId": "236342",
        "HCI-SoftwareOrg": "AcmeCorporation",
        "HCI-Software": "AcmeCorpCisHospitalXy",
        "HCI-SubCatalogId": "D683",
        "HCI-WholesalerGln": "7601001401297",
        "Authorization": API_KEY as string 
      },
      body: JSON.stringify({ chmed: chmedString })
    });

    if (!documedisResponse.ok) {
      console.error(`Documedis eMediplan Fehler (${documedisResponse.status})`);
      return NextResponse.json(
        { error: "eMediplan konnte von Documedis nicht entschlüsselt werden." },
        { status: documedisResponse.status }
      );
    }

    const data = await documedisResponse.json();

    // 4. Daten formatieren
    // HIER fehlte diese Zeile: Wir holen die Liste aus der Documedis-Antwort
    const medicaments = data.medicaments || data.medications || [];

    // Wir definieren kurz, wie ein Medikament von Documedis aussehen kann
    interface DocumedisMed {
      id?: string | number;
      gtin?: string | number;
      name?: string;
      description?: string;
      dosage?: string;
    }

    const formattedResults = medicaments.map((med: DocumedisMed) => ({
      id: med.id?.toString() || med.gtin?.toString() || Math.random().toString(),
      name: med.description || med.name || "Unbekanntes Medikament",
      description: med.dosage ? `Dosierung: ${med.dosage}` : "Vom eMediplan importiert"
    }));

    return NextResponse.json({ medications: formattedResults });

  } catch (error) {
    console.error("Proxy-Fehler eMediplan Parse:", error);
    return NextResponse.json({ error: "Server Fehler beim Parsen" }, { status: 500 });
  }
}