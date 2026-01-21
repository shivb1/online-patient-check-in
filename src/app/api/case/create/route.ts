import { NextResponse } from "next/server";
import { pool } from "@/app/lib/db";

type PgErrorLike = {
  code?: string;
  message?: string;
};

function isPgErrorLike(err: unknown): err is PgErrorLike {
  return typeof err === "object" && err !== null && ("code" in err || "message" in err);
}

export async function POST(req: Request) {
  try {
    const body = (await req.json()) as { patientId?: string };
    const patientId = (body.patientId ?? "").trim();

    if (!patientId) {
      return NextResponse.json({ ok: false, error: "patientId fehlt." }, { status: 400 });
    }

    // Optional: prüfen, ob Patient existiert
    const p = await pool.query(`SELECT id FROM patient WHERE id = $1`, [patientId]);
    if (p.rowCount === 0) {
      return NextResponse.json({ ok: false, error: "Patient nicht gefunden." }, { status: 404 });
    }

    // Fall erstellen (DB-Defaults erzeugen case_number + token + status)
    const res = await pool.query(
      `
      INSERT INTO intake_case (patient_id)
      VALUES ($1)
      RETURNING id, case_number, token, patient_id, status, created_at
      `,
      [patientId]
    );

    const row = res.rows[0];

    return NextResponse.json({
      ok: true,
      caseId: row.id,
      caseNumber: row.case_number,
      token: row.token,
      patientId: row.patient_id,
      status: row.status,
      createdAt: row.created_at,
    });
  } catch (err: unknown) {
    console.error("case/create error:", err);

    if (isPgErrorLike(err) && err.code === "22P02") {
      // z.B. wenn patientId keine gültige UUID ist
      return NextResponse.json({ ok: false, error: "Ungültige UUID übergeben." }, { status: 400 });
    }

    return NextResponse.json({ ok: false, error: "DB-Fehler bei case/create." }, { status: 500 });
  }
}