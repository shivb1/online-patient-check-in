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
    const body = (await req.json()) as { token?: string };
    const token = (body.token ?? "").trim();

    if (!token) {
      return NextResponse.json({ ok: false, error: "token fehlt" }, { status: 400 });
    }

    const sql = `
      SELECT
        ic.case_number,
        ic.token,
        ic.patient_id,
        p.first_name,
        p.last_name,
        to_char(p.birth_date, 'YYYY-MM-DD') AS birth_date,
        p.ahv_number,
        p.gender
      FROM intake_case ic
      JOIN patient p ON p.id = ic.patient_id
      WHERE ic.token = $1
      LIMIT 1;
    `;

    const res = await pool.query(sql, [token]);

    if (res.rowCount === 0) {
      return NextResponse.json({ ok: false, error: "Fall nicht gefunden" }, { status: 404 });
    }

    const row = res.rows[0];

    return NextResponse.json({
      ok: true,
      caseNumber: row.case_number,
      token: row.token,
      patientId: row.patient_id,
      patient: {
        firstName: row.first_name,
        lastName: row.last_name,
        birthDate: row.birth_date,
        ahvNumber: row.ahv_number,
        gender: row.gender,
      },
    });
  } catch (err: unknown) {
    console.error("case/lookup error:", err);

    if (isPgErrorLike(err) && err.code === "22P02") {
      return NextResponse.json({ ok: false, error: "Ungültige UUID übergeben." }, { status: 400 });
    }

    return NextResponse.json({ ok: false, error: "DB-Fehler" }, { status: 500 });
  }
}