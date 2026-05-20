import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest) {
  // 1. Barcode aus der URL extrahieren (z.B. ?gtin=7612345678901)
  const searchParams = request.nextUrl.searchParams;
  const gtin = searchParams.get("gtin");

  if (!gtin) {
    return NextResponse.json({ error: "Kein Barcode übergeben." }, { status: 400 });
  }

  // 2. Umgebungsvariablen laden
  const API_URL = process.env.DOCUMEDIS_API_URL;
  const API_KEY = process.env.DOCUMEDIS_API_KEY;

  try {
    // 3. Aufruf exakt wie im Python-Skript der BFH: /products/[barcode]?IdType=Gtin
    const documedisUrl = `${API_URL}/products/${gtin}?IdType=Gtin`;

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
        "Authorization": API_KEY as string 
      },
    });

    if (!documedisResponse.ok) {
      console.error(`Documedis Barcode Fehler (${documedisResponse.status})`);
      return NextResponse.json(
        { error: "Medikament zu diesem Barcode nicht gefunden." },
        { status: documedisResponse.status }
      );
    }

    const data = await documedisResponse.json();

    // 4. Daten für unser Frontend formatieren
    // Laut Python-Skript ist der Name verschachtelt in ['description']['description']
    const medName = data.description?.description || data.description || "Unbekanntes Medikament";

    const formattedResult = {
      id: data.id?.toString() || data.productNumber?.toString() || gtin,
      name: medName,
      description: `Gescannter Barcode: ${gtin}`
    };

    return NextResponse.json(formattedResult);

  } catch (error) {
    console.error("Proxy-Fehler Barcode Search:", error);
    return NextResponse.json({ error: "Server Fehler" }, { status: 500 });
  }
}