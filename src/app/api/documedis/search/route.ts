import { NextRequest, NextResponse } from "next/server";

/**
 * Interface für ein einzelnes Medikament, wie es von Documedis kommt
 */
interface DocumedisProduct {
  productNumber?: string | number;
  description?: string;
  id?: string | number;
  name?: string;
}

/**
 * Interface für eine Medikamenten-Marke (Brand), welche eine Liste von Produkten enthält
 */
interface DocumedisBrand {
  products?: DocumedisProduct[];
}

/**
 * Next.js API-Route für die typsichere Documedis Medikamentensuche
 */
export async function GET(request: NextRequest) {
  // 1. Suchbegriff aus der URL extrahieren
  const searchParams = request.nextUrl.searchParams;
  const query = searchParams.get("q");

  if (!query || query.length < 3) {
    return NextResponse.json(
      { error: "Suchbegriff muss mindestens 3 Zeichen lang sein." },
      { status: 400 }
    );
  }

  // 2. Umgebungsvariablen laden
  const API_URL = process.env.DOCUMEDIS_API_URL;
  const API_KEY = process.env.DOCUMEDIS_API_KEY;

  if (!API_URL || !API_KEY) {
    console.error("Documedis API Zugangsdaten fehlen in .env.local");
    return NextResponse.json(
      { error: "Server-Konfigurationsfehler" },
      { status: 500 }
    );
  }

  try {
    // 3. Echten Aufruf an die Documedis API machen (Autocomplete-Endpunkt)
    const documedisUrl = `${API_URL}/products/autocomplete?q=${encodeURIComponent(query)}&limit=50`;

    const documedisResponse = await fetch(documedisUrl, {
      method: "GET",
      headers: {
        "Accept": "application/json",
        "HCI-CustomerId": "236342",
        "HCI-Index": "hospindex",
        "HCI-SoftwareOrgId": "236342",
        "HCI-SoftwareOrg": "AcmeCorporation",
        "HCI-Software": "AcmeCorpCisHospitalXy",
        "HCI-SubCatalogId": "D683",
        "HCI-WholesalerGln": "7601001401297",
        "Authorization": API_KEY 
      },
    });

    // Fehler direkt abfangen und sauber ans Frontend weiterleiten, ohne den Server abzustürzen
    if (!documedisResponse.ok) {
      const errorText = await documedisResponse.text();
      console.error(`Documedis Fehler (${documedisResponse.status}):`, errorText);
      return NextResponse.json(
        { error: `Documedis API antwortete mit Status ${documedisResponse.status}` },
        { status: documedisResponse.status }
      );
    }

    // 4. Daten formatieren (Typsicher!)
    // Wir sagen TypeScript: Vertraue uns hier kurz, wir prüfen die Struktur danach selbst
    const documedisData = (await documedisResponse.json()) as Record<string, unknown>;

    const articlesArray: DocumedisProduct[] = [];

    // Wir prüfen, ob 'brands' existiert und ein Array ist
    if (documedisData && Array.isArray(documedisData.brands)) {
      // Typsicheres Casting des Arrays
      const brands = documedisData.brands as DocumedisBrand[];
      
      for (const brand of brands) {
        if (Array.isArray(brand.products)) {
          // Alle Produkte dieser Marke in unsere Hauptliste einfügen
          articlesArray.push(...brand.products);
        }
      }
    } else {
      console.warn("Documedis-Antwort enthielt kein 'brands' Array.");
      // Wir senden ein leeres Array zurück, anstatt einen Error zu werfen
      return NextResponse.json([]);
    }

    // Mappen der Documedis-Felder auf unser Frontend-Format
    const formattedResults = articlesArray.map((item) => ({
      id: item.productNumber?.toString() || item.id?.toString() || Math.random().toString(),
      name: item.description || item.name || "Unbekanntes Medikament", 
      description: "Aus Documedis API",
    }));

    // 5. Resultate ans Frontend zurücksenden
    return NextResponse.json(formattedResults);

  } catch (error) {
    console.error("Proxy-Fehler Documedis Search:", error);
    return NextResponse.json(
      { error: "Fehler bei der Kommunikation mit dem Medikations-Server." },
      { status: 500 }
    );
  }
}