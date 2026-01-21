import { NextResponse } from "next/server";
import { pool } from "@/app/lib/db";

const AHV_REGEX = /^756\.\d{4}\.\d{4}\.\d{2}$/;

function normalizeAhv(raw: string): string {
  const trimmed = (raw ?? "").trim();
  const digits = trimmed.replace(/\D/g, "");
  // Erwartung: 13 Ziffern, beginnt mit 756
  if (digits.length === 13 && digits.startsWith("756")) {
    return `${digits.slice(0, 3)}.${digits.slice(3, 7)}.${digits.slice(7, 11)}.${digits.slice(11, 13)}`;
  }
  return trimmed;
}

function isValidISODate(dateStr: string): boolean {
  // Input type="date" liefert normalerweise YYYY-MM-DD
  if (!/^\d{4}-\d{2}-\d{2}$/.test(dateStr)) return false;
  const d = new Date(dateStr);
  return !Number.isNaN(d.getTime());
}

export async function POST(req: Request) {
  try {
    const body = (await req.json()) as {
      firstName?: string;
      lastName?: string;
      birthDate?: string;
      ahvNumber?: string;
      gender?: string;
    };

    const firstName = (body.firstName ?? "").trim();
    const lastName = (body.lastName ?? "").trim();
    const birthDate = (body.birthDate ?? "").trim();
    const ahvNumber = normalizeAhv(body.ahvNumber ?? "");

    if (!firstName || !lastName || !birthDate || !ahvNumber) {
      return NextResponse.json(
        { ok: false, error: "Vorname, Nachname, Geburtsdatum und AHV-Nummer sind erforderlich." },
        { status: 400 }
      );
    }

    if (!isValidISODate(birthDate)) {
      return NextResponse.json(
        { ok: false, error: "Geburtsdatum muss im Format YYYY-MM-DD sein (Datumsauswahl verwenden)." },
        { status: 400 }
      );
    }

    if (!AHV_REGEX.test(ahvNumber)) {
      return NextResponse.json(
        { ok: false, error: "AHV-Nummer ist ungültig. Erwartet: 756.XXXX.XXXX.XX" },
        { status: 400 }
      );
    }

    // gender ist optional – in DB darf es auch NULL/leer sein
    const gender = (body.gender ?? "").trim() || null;

    const sql = `
      INSERT INTO patient (first_name, last_name, birth_date, ahv_number, gender)
      VALUES ($1, $2, $3::date, $4, $5)
      RETURNING
        id,
        first_name  AS "firstName",
        last_name   AS "lastName",
        birth_date::text AS "birthDate",
        ahv_number  AS "ahvNumber",
        gender      AS "gender"
    `;

    const res = await pool.query(sql, [firstName, lastName, birthDate, ahvNumber, gender]);

    return NextResponse.json({ ok: true, patient: res.rows[0] });
  } catch (e) {
    console.error("patient/create error:", e);
    return NextResponse.json({ ok: false, error: "Serverfehler beim Erstellen des Patienten." }, { status: 500 });
  }
}