import { NextResponse } from "next/server";

// Für Demo: sehr permissive CORS Header (hilft bei iPad/LAN)
// Für Produktion würdest du das einschränken.
function withCors(res: NextResponse) {
  res.headers.set("Access-Control-Allow-Origin", "*");
  res.headers.set("Access-Control-Allow-Methods", "POST, OPTIONS");
  res.headers.set("Access-Control-Allow-Headers", "Content-Type");
  return res;
}

export async function OPTIONS() {
  return withCors(new NextResponse(null, { status: 204 }));
}

export async function POST(req: Request) {
  try {
    // Debug: zeigt dir im VS Code Terminal, was vom iPad kommt
    const origin = req.headers.get("origin");
    const host = req.headers.get("host");
    const ua = req.headers.get("user-agent");

    const data = await req.json();

    console.log("✅ /intake/submit POST");
    console.log("   host:", host);
    console.log("   origin:", origin);
    console.log("   ua:", ua);
    console.log("📥 Intake-Daten angekommen:", data);

    // TODO: hier später wieder deine DB Inserts rein
    return withCors(NextResponse.json({ ok: true }));
  } catch (err) {
    console.error("❌ submit error:", err);

    const msg = err instanceof Error ? err.message : "Unbekannter Fehler";
    return withCors(
      NextResponse.json({ ok: false, error: msg }, { status: 500 })
    );
  }
}