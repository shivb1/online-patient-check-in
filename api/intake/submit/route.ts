import { NextResponse } from "next/server";
import { pool } from "@/app/lib/db";

type YesNo = "yes" | "no";
type Gender = "male" | "female" | "other" | "";

type IntakeData = {
  // Case
  caseToken?: string;
  caseNumber?: string;
  casePatientId?: string;

  // Patient
  firstName?: string;
  lastName?: string;
  gender?: Gender;
  birthDate?: string; // YYYY-MM-DD
  ahvNumber?: string;

  // Contact
  address?: string;
  zip?: string;
  city?: string;
  phone?: string;
  phonePrivate?: string;
  email?: string;

  // Emergency
  emergencyFirstName?: string;
  emergencyLastName?: string;
  emergencyAddress?: string;
  emergencyPhone?: string;

  // General
  hospitalized?: YesNo;
  hospitalizedWhen?: string;
  hospitalizedWhere?: string;
  hospitalizedWhy?: string;

  regularGP?: YesNo;
  regularGPWhy?: string;

  regularMedication?: YesNo;
  medications?: string;

  allergiesFlag?: YesNo;
  allergies?: string;

  // Cardio
  bloodPressure?: YesNo;
  exertionPainBreath?: YesNo;
  flatLyingProblem?: YesNo;
  irregularPulse?: YesNo;
  nightSymptoms?: YesNo;
  swollenLegs?: YesNo;
  thrombosis?: YesNo;

  // Lung (in DB aktuell: smoker, dyspnea, asthma)
  smoker?: YesNo;
  dyspnea?: YesNo;
  asthma?: YesNo;

  // Other (in DB aktuell: diabetes, cancer, coagulation)
  diabetes?: YesNo;
  cancer?: YesNo;
  coagulation?: YesNo;

  // Body
  weight?: string; // kg
  height?: string; // cm
};

// ===== CORS (hilft im LAN mit iPad/Handy) =====
function withCors(res: NextResponse) {
  res.headers.set("Access-Control-Allow-Origin", "*");
  res.headers.set("Access-Control-Allow-Methods", "POST, OPTIONS");
  res.headers.set("Access-Control-Allow-Headers", "Content-Type");
  return res;
}

export async function OPTIONS() {
  return withCors(new NextResponse(null, { status: 204 }));
}

// ===== Helpers =====
function t(v: unknown): string {
  return (typeof v === "string" ? v : "").trim();
}

function ynToBool(v: YesNo | undefined): boolean | null {
  if (v === "yes") return true;
  if (v === "no") return false;
  return null;
}

const AHV_REGEX = /^756\.\d{4}\.\d{4}\.\d{2}$/;

function normalizeAhv(raw: string): string {
  const trimmed = (raw ?? "").trim();
  const digits = trimmed.replace(/\D/g, "");
  if (digits.length === 13 && digits.startsWith("756")) {
    return `${digits.slice(0, 3)}.${digits.slice(3, 7)}.${digits.slice(7, 11)}.${digits.slice(11, 13)}`;
  }
  return trimmed;
}

function isValidISODate(dateStr: string): boolean {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(dateStr)) return false;
  const d = new Date(dateStr);
  return !Number.isNaN(d.getTime());
}

function hasEmergency(d: IntakeData): boolean {
  return (
    t(d.emergencyFirstName) !== "" ||
    t(d.emergencyLastName) !== "" ||
    t(d.emergencyAddress) !== "" ||
    t(d.emergencyPhone) !== ""
  );
}

function parseIntOrNull(v: string): number | null {
  const s = t(v);
  if (!s) return null;
  const n = Number(s);
  if (!Number.isFinite(n)) return null;
  const i = Math.trunc(n);
  return i;
}

export async function POST(req: Request) {
  const origin = req.headers.get("origin");
  const host = req.headers.get("host");
  const ua = req.headers.get("user-agent");

  try {
    const data = (await req.json()) as IntakeData;

    console.log("✅ /api/intake/submit POST");
    console.log("   host:", host);
    console.log("   origin:", origin);
    console.log("   ua:", ua);

    // ===== Minimal Validations (server-side) =====
    const firstName = t(data.firstName);
    const lastName = t(data.lastName);
    const birthDate = t(data.birthDate);
    const ahvNumber = normalizeAhv(t(data.ahvNumber));

    const address = t(data.address);
    const zip = t(data.zip);
    const city = t(data.city);
    const phone = t(data.phone);

    if (!firstName || !lastName || !birthDate || !ahvNumber) {
      return withCors(
        NextResponse.json(
          { ok: false, error: "Vorname, Nachname, Geburtsdatum und AHV-Nummer sind erforderlich." },
          { status: 400 }
        )
      );
    }

    if (!isValidISODate(birthDate)) {
      return withCors(
        NextResponse.json({ ok: false, error: "Geburtsdatum muss YYYY-MM-DD sein." }, { status: 400 })
      );
    }

    if (!AHV_REGEX.test(ahvNumber)) {
      return withCors(
        NextResponse.json({ ok: false, error: "AHV-Nummer ist ungültig. Erwartet: 756.XXXX.XXXX.XX" }, { status: 400 })
      );
    }

    if (!address || !zip || !city || !phone) {
      return withCors(
        NextResponse.json({ ok: false, error: "Adresse, PLZ, Ort und Telefon sind erforderlich." }, { status: 400 })
      );
    }

    // Gewicht/Grösse sind bei dir Pflicht im UI – wir prüfen hier auch:
    const weightKg = parseIntOrNull(data.weight ?? "");
    const heightCm = parseIntOrNull(data.height ?? "");

    if (weightKg == null || heightCm == null) {
      return withCors(
        NextResponse.json({ ok: false, error: "Gewicht und Grösse sind erforderlich." }, { status: 400 })
      );
    }
    if (weightKg < 1 || weightKg > 500) {
      return withCors(
        NextResponse.json({ ok: false, error: "Gewicht muss zwischen 1 und 500 kg liegen." }, { status: 400 })
      );
    }
    if (heightCm < 10 || heightCm > 250) {
      return withCors(
        NextResponse.json({ ok: false, error: "Grösse muss zwischen 10 und 250 cm liegen." }, { status: 400 })
      );
    }

    const gender = t(data.gender) || null;
    const phonePrivate = t(data.phonePrivate) || null;
    const email = t(data.email) || null;

    // ===== DB Transaction =====
    const client = await pool.connect();
    try {
      await client.query("BEGIN");

      // 1) Patient bestimmen (normalerweise über casePatientId)
      let patientId = t(data.casePatientId);

      if (patientId) {
        // Patient aktualisieren (falls Tablet etwas korrigiert)
        await client.query(
          `
          UPDATE patient
          SET first_name = $1,
              last_name = $2,
              birth_date = $3::date,
              ahv_number = $4,
              gender = $5
          WHERE id = $6
          `,
          [firstName, lastName, birthDate, ahvNumber, gender, patientId]
        );
      } else {
        // Fallback: Patient via AHV suchen, sonst neu erstellen
        const found = await client.query(`SELECT id FROM patient WHERE ahv_number = $1 LIMIT 1`, [ahvNumber]);
        if ((found.rowCount ?? 0) > 0) {
          patientId = found.rows[0].id as string;
        } else {
          const created = await client.query(
            `
            INSERT INTO patient (first_name, last_name, birth_date, ahv_number, gender)
            VALUES ($1, $2, $3::date, $4, $5)
            RETURNING id
            `,
            [firstName, lastName, birthDate, ahvNumber, gender]
          );
          patientId = created.rows[0].id as string;
        }
      }

      // 2) contact upsert (1:1 über patient_id)
      const existingContact = await client.query(
        `SELECT id FROM contact WHERE patient_id = $1 LIMIT 1`,
        [patientId]
      );

      if ((existingContact.rowCount ?? 0) > 0) {
        await client.query(
          `
          UPDATE contact
          SET address = $2,
              zip = $3,
              city = $4,
              phone = $5,
              phone_private = $6,
              email = $7
          WHERE patient_id = $1
          `,
          [patientId, address, zip, city, phone, phonePrivate, email]
        );
      } else {
        await client.query(
          `
          INSERT INTO contact (patient_id, address, zip, city, phone, phone_private, email)
          VALUES ($1, $2, $3, $4, $5, $6, $7)
          `,
          [patientId, address, zip, city, phone, phonePrivate, email]
        );
      }

      // 3) emergency_contact (optional) – wir halten 1 Datensatz pro Patient
      if (hasEmergency(data)) {
        await client.query(`DELETE FROM emergency_contact WHERE patient_id = $1`, [patientId]);

        await client.query(
          `
          INSERT INTO emergency_contact (patient_id, first_name, last_name, address, phone)
          VALUES ($1, $2, $3, $4, $5)
          `,
          [
            patientId,
            t(data.emergencyFirstName) || null,
            t(data.emergencyLastName) || null,
            t(data.emergencyAddress) || null,
            t(data.emergencyPhone) || null,
          ]
        );
      }

      // 4) medical_general upsert
      const mg = await client.query(`SELECT id FROM medical_general WHERE patient_id = $1 LIMIT 1`, [patientId]);

      const hospitalized = ynToBool(data.hospitalized);
      const regularGp = ynToBool(data.regularGP);
      const regularMedication = ynToBool(data.regularMedication);
      const allergies = ynToBool(data.allergiesFlag);

      if ((mg.rowCount ?? 0) > 0) {
        await client.query(
          `
          UPDATE medical_general
          SET hospitalized = $2,
              hospitalized_when = $3,
              hospitalized_where = $4,
              hospitalized_why = $5,
              regular_gp = $6,
              regular_gp_why = $7,
              regular_medication = $8,
              medications = $9,
              allergies = $10,
              allergies_text = $11,
              weight_kg = $12,
              height_cm = $13
          WHERE patient_id = $1
          `,
          [
            patientId,
            hospitalized,
            t(data.hospitalizedWhen) || null,
            t(data.hospitalizedWhere) || null,
            t(data.hospitalizedWhy) || null,
            regularGp,
            t(data.regularGPWhy) || null,
            regularMedication,
            t(data.medications) || null,
            allergies,
            t(data.allergies) || null,
            weightKg,
            heightCm,
          ]
        );
      } else {
        await client.query(
          `
          INSERT INTO medical_general (
            patient_id,
            hospitalized, hospitalized_when, hospitalized_where, hospitalized_why,
            regular_gp, regular_gp_why,
            regular_medication, medications,
            allergies, allergies_text,
            weight_kg, height_cm
          )
          VALUES (
            $1,
            $2, $3, $4, $5,
            $6, $7,
            $8, $9,
            $10, $11,
            $12, $13
          )
          `,
          [
            patientId,
            hospitalized,
            t(data.hospitalizedWhen) || null,
            t(data.hospitalizedWhere) || null,
            t(data.hospitalizedWhy) || null,
            regularGp,
            t(data.regularGPWhy) || null,
            regularMedication,
            t(data.medications) || null,
            allergies,
            t(data.allergies) || null,
            weightKg,
            heightCm,
          ]
        );
      }

      // 5) medical_cardio upsert
      const mc = await client.query(`SELECT id FROM medical_cardio WHERE patient_id = $1 LIMIT 1`, [patientId]);

      const cardioValues = [
        ynToBool(data.bloodPressure),
        ynToBool(data.exertionPainBreath),
        ynToBool(data.flatLyingProblem),
        ynToBool(data.irregularPulse),
        ynToBool(data.nightSymptoms),
        ynToBool(data.swollenLegs),
        ynToBool(data.thrombosis),
      ];

      if ((mc.rowCount ?? 0) > 0) {
        await client.query(
          `
          UPDATE medical_cardio
          SET blood_pressure = $2,
              exertion_pain_breath = $3,
              flat_lying_problem = $4,
              irregular_pulse = $5,
              night_symptoms = $6,
              swollen_legs = $7,
              thrombosis = $8
          WHERE patient_id = $1
          `,
          [patientId, ...cardioValues]
        );
      } else {
        await client.query(
          `
          INSERT INTO medical_cardio (
            patient_id,
            blood_pressure, exertion_pain_breath, flat_lying_problem,
            irregular_pulse, night_symptoms, swollen_legs, thrombosis
          )
          VALUES ($1,$2,$3,$4,$5,$6,$7,$8)
          `,
          [patientId, ...cardioValues]
        );
      }

      // 6) medical_lung upsert (DB hat: smoker, dyspnea, asthma)
      const ml = await client.query(`SELECT id FROM medical_lung WHERE patient_id = $1 LIMIT 1`, [patientId]);

      const lungValues = [ynToBool(data.smoker), ynToBool(data.dyspnea), ynToBool(data.asthma)];

      if ((ml.rowCount ?? 0) > 0) {
        await client.query(
          `
          UPDATE medical_lung
          SET smoker = $2,
              dyspnea = $3,
              asthma = $4
          WHERE patient_id = $1
          `,
          [patientId, ...lungValues]
        );
      } else {
        await client.query(
          `
          INSERT INTO medical_lung (patient_id, smoker, dyspnea, asthma)
          VALUES ($1,$2,$3,$4)
          `,
          [patientId, ...lungValues]
        );
      }

      // 7) medical_other upsert (DB hat: diabetes, cancer, coagulation)
      const mo = await client.query(`SELECT id FROM medical_other WHERE patient_id = $1 LIMIT 1`, [patientId]);

      const otherValues = [ynToBool(data.diabetes), ynToBool(data.cancer), ynToBool(data.coagulation)];

      if ((mo.rowCount ?? 0) > 0) {
        await client.query(
          `
          UPDATE medical_other
          SET diabetes = $2,
              cancer = $3,
              coagulation = $4
          WHERE patient_id = $1
          `,
          [patientId, ...otherValues]
        );
      } else {
        await client.query(
          `
          INSERT INTO medical_other (patient_id, diabetes, cancer, coagulation)
          VALUES ($1,$2,$3,$4)
          `,
          [patientId, ...otherValues]
        );
      }

      await client.query("COMMIT");

      return withCors(
        NextResponse.json({
          ok: true,
          patientId,
          caseNumber: t(data.caseNumber) || null,
          caseToken: t(data.caseToken) || null,
        })
      );
    } catch (e) {
      await client.query("ROLLBACK");
      console.error("❌ intake/submit db error:", e);
      return withCors(
        NextResponse.json({ ok: false, error: "DB-Fehler beim Speichern der Anmeldung." }, { status: 500 })
      );
    } finally {
      client.release();
    }
  } catch (err) {
    console.error("❌ intake/submit error:", err);
    const msg = err instanceof Error ? err.message : "Unbekannter Fehler";
    return withCors(NextResponse.json({ ok: false, error: msg }, { status: 500 }));
  }
}