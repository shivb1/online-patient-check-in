import { NextResponse } from "next/server";
import { pool } from "@/app/lib/db";

type Body = {
  firstName?: string;
  lastName?: string;
  birthDate?: string; // ISO: YYYY-MM-DD
};

const ISO_DATE = /^\d{4}-\d{2}-\d{2}$/;

export async function POST(req: Request) {
  try {
    const body = (await req.json()) as Body;

    const firstName = (body.firstName ?? "").trim();
    const lastName = (body.lastName ?? "").trim();
    const birthDate = (body.birthDate ?? "").trim();

    if (!lastName || !birthDate) {
      return NextResponse.json(
        { ok: false, error: "Nachname und Geburtsdatum sind erforderlich." },
        { status: 400 }
      );
    }

    if (!ISO_DATE.test(birthDate)) {
      return NextResponse.json(
        { ok: false, error: "Geburtsdatum muss im Format YYYY-MM-DD sein." },
        { status: 400 }
      );
    }

    const values: (string)[] = [birthDate, `%${lastName}%`];
    let where = `p.birth_date = $1::date AND p.last_name ILIKE $2`;

    if (firstName) {
      values.push(`%${firstName}%`);
      where += ` AND p.first_name ILIKE $3`;
    }

    const sql = `
      SELECT
        p.id,
        p.first_name,
        p.last_name,
        to_char(p.birth_date, 'YYYY-MM-DD') AS birth_date,
        p.ahv_number,
        p.gender
      FROM patient p
      WHERE ${where}
      ORDER BY p.created_at DESC
      LIMIT 25;
    `;

    const res = await pool.query(sql, values);

    const results = res.rows.map((r) => ({
      id: r.id as string,
      firstName: r.first_name as string,
      lastName: r.last_name as string,
      birthDate: r.birth_date as string,
      ahvNumber: r.ahv_number as string,
      gender: (r.gender ?? null) as "male" | "female" | "other" | null,
    }));

    return NextResponse.json({ ok: true, results });
  } catch (e) {
    console.error("patient/search error:", e);
    return NextResponse.json({ ok: false, error: "DB-Fehler bei patient/search." }, { status: 500 });
  }
}