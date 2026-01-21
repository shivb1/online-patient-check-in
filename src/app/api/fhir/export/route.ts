import { NextResponse } from "next/server";
import { pool } from "@/app/lib/db";

type DbCaseRow = {
  case_number: string;
  token: string;
  patient_id: string;
  status: string;
  created_at: string;
};

type DbPatientRow = {
  id: string;
  first_name: string;
  last_name: string;
  birth_date: string; // YYYY-MM-DD
  ahv_number: string;
  gender: string | null;
  created_at: string;
};

type DbContactRow = {
  id: string;
  patient_id: string;
  address: string;
  zip: string;
  city: string;
  phone: string;
  phone_private: string | null;
  email: string | null;
  created_at: string;
};

type DbEmergencyRow = {
  id: string;
  patient_id: string;
  first_name: string | null;
  last_name: string | null;
  address: string | null;
  phone: string | null;
  created_at: string;
};

type DbMedicalGeneralRow = {
  id: string;
  patient_id: string;

  hospitalized: boolean | null;
  hospitalized_when: string | null;
  hospitalized_where: string | null;
  hospitalized_why: string | null;

  regular_gp: boolean | null;
  regular_gp_why: string | null;

  regular_medication: boolean | null;
  medications: string | null;

  allergies: boolean | null;
  allergies_text: string | null;

  weight_kg: number | null;
  height_cm: number | null;

  created_at: string;
};

type DbMedicalCardioRow = {
  id: string;
  patient_id: string;
  blood_pressure: boolean | null;
  exertion_pain_breath: boolean | null;
  flat_lying_problem: boolean | null;
  irregular_pulse: boolean | null;
  night_symptoms: boolean | null;
  swollen_legs: boolean | null;
  thrombosis: boolean | null;
  created_at: string;
};

type DbMedicalLungRow = {
  id: string;
  patient_id: string;
  smoker: boolean | null;
  dyspnea: boolean | null;
  asthma: boolean | null;
  created_at: string;
};

type DbMedicalOtherRow = {
  id: string;
  patient_id: string;
  diabetes: boolean | null;
  cancer: boolean | null;
  coagulation: boolean | null;
  created_at: string;
};

// ---------- Helpers (FHIR item builders) ----------
type QrAnswer =
  | { valueString: string }
  | { valueBoolean: boolean }
  | { valueInteger: number };

type QrItem = {
  linkId: string;
  text?: string;
  answer?: QrAnswer[];
  item?: QrItem[];
};

function itemStr(linkId: string, text: string, value: string | null | undefined): QrItem | null {
  const v = (value ?? "").toString().trim();
  if (!v) return null;
  return { linkId, text, answer: [{ valueString: v }] };
}

function itemBool(linkId: string, text: string, value: boolean | null | undefined): QrItem | null {
  if (value === null || value === undefined) return null;
  return { linkId, text, answer: [{ valueBoolean: value }] };
}

function itemInt(linkId: string, text: string, value: number | null | undefined): QrItem | null {
  if (value === null || value === undefined) return null;
  return { linkId, text, answer: [{ valueInteger: value }] };
}

function fhirGender(g: string | null): "male" | "female" | "other" | "unknown" {
  if (g === "male") return "male";
  if (g === "female") return "female";
  if (g === "other") return "other";
  return "unknown";
}

export async function GET(req: Request) {
  try {
    const url = new URL(req.url);
    const caseNumber = (url.searchParams.get("caseNumber") ?? "").trim();

    if (!caseNumber) {
      return NextResponse.json(
        { ok: false, error: 'Bitte caseNumber angeben, z.B. /api/fhir/export?caseNumber=20260121-00024' },
        { status: 400 }
      );
    }

    // 1) Case holen
    const caseRes = await pool.query<DbCaseRow>(
      `
      SELECT case_number, token::text, patient_id::text, status, created_at::text
      FROM intake_case
      WHERE case_number = $1
      LIMIT 1
      `,
      [caseNumber]
    );

    if ((caseRes.rowCount ?? 0) === 0) {
      return NextResponse.json(
        { ok: false, error: `Kein Fall gefunden für caseNumber=${caseNumber}` },
        { status: 404 }
      );
    }

    const c = caseRes.rows[0];

    // 2) Patient holen
    const pRes = await pool.query<DbPatientRow>(
      `
      SELECT id::text, first_name, last_name, birth_date::text, ahv_number, gender, created_at::text
      FROM patient
      WHERE id = $1
      LIMIT 1
      `,
      [c.patient_id]
    );

    if ((pRes.rowCount ?? 0) === 0) {
      return NextResponse.json({ ok: false, error: "Patient zum Fall nicht gefunden." }, { status: 404 });
    }
    const p = pRes.rows[0];

    // 3) Contact (optional, aber in deinem System praktisch immer vorhanden)
    const contactRes = await pool.query<DbContactRow>(
      `
      SELECT id::text, patient_id::text, address, zip, city, phone, phone_private, email, created_at::text
      FROM contact
      WHERE patient_id = $1
      ORDER BY created_at DESC
      LIMIT 1
      `,
      [p.id]
    );
    const contact = (contactRes.rowCount ?? 0) > 0 ? contactRes.rows[0] : null;

    // 4) Emergency contact (optional)
    const ecRes = await pool.query<DbEmergencyRow>(
      `
      SELECT id::text, patient_id::text, first_name, last_name, address, phone, created_at::text
      FROM emergency_contact
      WHERE patient_id = $1
      ORDER BY created_at DESC
      LIMIT 1
      `,
      [p.id]
    );
    const emergency = (ecRes.rowCount ?? 0) > 0 ? ecRes.rows[0] : null;

    // 5) Medical Tables (optional)
    const mgRes = await pool.query<DbMedicalGeneralRow>(
      `
      SELECT
        id::text, patient_id::text,
        hospitalized, hospitalized_when, hospitalized_where, hospitalized_why,
        regular_gp, regular_gp_why,
        regular_medication, medications,
        allergies, allergies_text,
        weight_kg, height_cm,
        created_at::text
      FROM medical_general
      WHERE patient_id = $1
      ORDER BY created_at DESC
      LIMIT 1
      `,
      [p.id]
    );
    const medicalGeneral = (mgRes.rowCount ?? 0) > 0 ? mgRes.rows[0] : null;

    const mcRes = await pool.query<DbMedicalCardioRow>(
      `
      SELECT
        id::text, patient_id::text,
        blood_pressure, exertion_pain_breath, flat_lying_problem,
        irregular_pulse, night_symptoms, swollen_legs, thrombosis,
        created_at::text
      FROM medical_cardio
      WHERE patient_id = $1
      ORDER BY created_at DESC
      LIMIT 1
      `,
      [p.id]
    );
    const medicalCardio = (mcRes.rowCount ?? 0) > 0 ? mcRes.rows[0] : null;

    const mlRes = await pool.query<DbMedicalLungRow>(
      `
      SELECT id::text, patient_id::text, smoker, dyspnea, asthma, created_at::text
      FROM medical_lung
      WHERE patient_id = $1
      ORDER BY created_at DESC
      LIMIT 1
      `,
      [p.id]
    );
    const medicalLung = (mlRes.rowCount ?? 0) > 0 ? mlRes.rows[0] : null;

    const moRes = await pool.query<DbMedicalOtherRow>(
      `
      SELECT id::text, patient_id::text, diabetes, cancer, coagulation, created_at::text
      FROM medical_other
      WHERE patient_id = $1
      ORDER BY created_at DESC
      LIMIT 1
      `,
      [p.id]
    );
    const medicalOther = (moRes.rowCount ?? 0) > 0 ? moRes.rows[0] : null;

    // ---------- FHIR Patient ----------
    const patientResource = {
      resourceType: "Patient",
      id: p.id,
      identifier: [
        {
          system: "http://example.org/identifier/ahv",
          value: p.ahv_number,
        },
      ],
      name: [
        {
          use: "official",
          family: p.last_name,
          given: [p.first_name],
        },
      ],
      gender: fhirGender(p.gender),
      birthDate: p.birth_date,
      telecom: [
        ...(contact?.phone ? [{ system: "phone", use: "mobile", value: contact.phone }] : []),
        ...(contact?.phone_private ? [{ system: "phone", use: "home", value: contact.phone_private }] : []),
        ...(contact?.email ? [{ system: "email", value: contact.email }] : []),
      ],
      address: contact
        ? [
            {
              line: [contact.address],
              postalCode: contact.zip,
              city: contact.city,
              country: "CH",
            },
          ]
        : undefined,
    };

    // ---------- FHIR RelatedPerson (Notfallkontakt) ----------
    const relatedPerson = emergency
      ? {
          resourceType: "RelatedPerson",
          id: emergency.id,
          patient: { reference: `Patient/${p.id}` },
          name: [
            {
              use: "official",
              family: (emergency.last_name ?? "").trim() || undefined,
              given: emergency.first_name ? [emergency.first_name] : undefined,
            },
          ],
          telecom: emergency.phone ? [{ system: "phone", value: emergency.phone }] : undefined,
          address: emergency.address
            ? [
                {
                  line: [emergency.address],
                  country: "CH",
                },
              ]
            : undefined,
        }
      : null;

    // ---------- Questionnaire (minimal, aber sauber) ----------
    const questionnaire = {
      resourceType: "Questionnaire",
      id: "intake-questionnaire",
      status: "active",
      title: "Online Patient Check-in (Demo)",
    };

    // ---------- QuestionnaireResponse ----------
    const items: QrItem[] = [];

    // Case group
    items.push({
      linkId: "case",
      text: "Fall",
      item: [
        itemStr("caseNumber", "Fallnummer", c.case_number),
        itemStr("token", "Token", c.token),
        itemStr("status", "Status", c.status),
      ].filter((x): x is QrItem => Boolean(x)),
    });

    // Contact group
    if (contact) {
      items.push({
        linkId: "contact",
        text: "Kontakt",
        item: [
          itemStr("address", "Adresse", contact.address),
          itemStr("zip", "PLZ", contact.zip),
          itemStr("city", "Ort", contact.city),
          itemStr("phone", "Telefon", contact.phone),
          itemStr("phone_private", "Telefon privat", contact.phone_private),
          itemStr("email", "E-Mail", contact.email),
        ].filter((x): x is QrItem => Boolean(x)),
      });
    }

    // Emergency group
    if (emergency) {
      items.push({
        linkId: "emergency_contact",
        text: "Notfallkontakt",
        item: [
          itemStr("first_name", "Vorname", emergency.first_name),
          itemStr("last_name", "Nachname", emergency.last_name),
          itemStr("address", "Adresse", emergency.address),
          itemStr("phone", "Telefon", emergency.phone),
        ].filter((x): x is QrItem => Boolean(x)),
      });
    }

    // Medical General
    if (medicalGeneral) {
      items.push({
        linkId: "medical_general",
        text: "Allgemein",
        item: [
          itemBool("hospitalized", "Im Spital (12 Monate)", medicalGeneral.hospitalized),
          itemStr("hospitalized_when", "Wenn ja: wann", medicalGeneral.hospitalized_when),
          itemStr("hospitalized_where", "Wenn ja: wo", medicalGeneral.hospitalized_where),
          itemStr("hospitalized_why", "Wenn ja: warum", medicalGeneral.hospitalized_why),

          itemBool("regular_gp", "Regelmässig Hausarzt", medicalGeneral.regular_gp),
          itemStr("regular_gp_why", "Wenn ja: warum", medicalGeneral.regular_gp_why),

          itemBool("regular_medication", "Regelmässige Medikamente", medicalGeneral.regular_medication),
          itemStr("medications", "Welche Medikamente", medicalGeneral.medications),

          itemBool("allergies", "Allergien", medicalGeneral.allergies),
          itemStr("allergies_text", "Welche Allergien", medicalGeneral.allergies_text),

          itemInt("weight_kg", "Gewicht (kg)", medicalGeneral.weight_kg),
          itemInt("height_cm", "Grösse (cm)", medicalGeneral.height_cm),
        ].filter((x): x is QrItem => Boolean(x)),
      });
    }

    // Medical Cardio
    if (medicalCardio) {
      items.push({
        linkId: "medical_cardio",
        text: "Herz-Kreislauf",
        item: [
          itemBool("blood_pressure", "Blutdruckprobleme", medicalCardio.blood_pressure),
          itemBool("exertion_pain_breath", "Schmerzen/Atemnot bei Belastung", medicalCardio.exertion_pain_breath),
          itemBool("flat_lying_problem", "Flach liegen Problem", medicalCardio.flat_lying_problem),
          itemBool("irregular_pulse", "Unregelmässiger Puls", medicalCardio.irregular_pulse),
          itemBool("night_symptoms", "Nachts Symptome", medicalCardio.night_symptoms),
          itemBool("swollen_legs", "Geschwollene Beine/Füsse", medicalCardio.swollen_legs),
          itemBool("thrombosis", "Thrombose/Embolie", medicalCardio.thrombosis),
        ].filter((x): x is QrItem => Boolean(x)),
      });
    }

    // Medical Lung (ohne inhaler!)
    if (medicalLung) {
      items.push({
        linkId: "medical_lung",
        text: "Lunge",
        item: [
          itemBool("smoker", "Raucher/in", medicalLung.smoker),
          itemBool("dyspnea", "Luftnot bei Belastung", medicalLung.dyspnea),
          itemBool("asthma", "Asthma", medicalLung.asthma),
        ].filter((x): x is QrItem => Boolean(x)),
      });
    }

    // Medical Other
    if (medicalOther) {
      items.push({
        linkId: "medical_other",
        text: "Weitere medizinische Angaben",
        item: [
          itemBool("diabetes", "Diabetes/Hormonkrankheiten", medicalOther.diabetes),
          itemBool("cancer", "Tumorerkrankung", medicalOther.cancer),
          itemBool("coagulation", "Gerinnungsprobleme", medicalOther.coagulation),
        ].filter((x): x is QrItem => Boolean(x)),
      });
    }

    const authored = new Date().toISOString();

    const questionnaireResponse = {
      resourceType: "QuestionnaireResponse",
      id: `qr-${c.case_number}`,
      status: "completed",
      questionnaire: "Questionnaire/intake-questionnaire",
      subject: { reference: `Patient/${p.id}` },
      authored,
      item: items,
    };

    // ---------- Observations (Vital Signs) für Gewicht/Grösse ----------
    const obs: Array<Record<string, unknown>> = [];

    if (medicalGeneral?.weight_kg !== null && medicalGeneral?.weight_kg !== undefined) {
      obs.push({
        resourceType: "Observation",
        id: `obs-weight-${c.case_number}`,
        status: "final",
        category: [
          {
            coding: [
              {
                system: "http://terminology.hl7.org/CodeSystem/observation-category",
                code: "vital-signs",
                display: "Vital Signs",
              },
            ],
          },
        ],
        code: {
          coding: [
            { system: "http://loinc.org", code: "29463-7", display: "Body weight" },
          ],
          text: "Gewicht",
        },
        subject: { reference: `Patient/${p.id}` },
        effectiveDateTime: authored,
        valueQuantity: {
          value: medicalGeneral.weight_kg,
          unit: "kg",
          system: "http://unitsofmeasure.org",
          code: "kg",
        },
      });
    }

    if (medicalGeneral?.height_cm !== null && medicalGeneral?.height_cm !== undefined) {
      obs.push({
        resourceType: "Observation",
        id: `obs-height-${c.case_number}`,
        status: "final",
        category: [
          {
            coding: [
              {
                system: "http://terminology.hl7.org/CodeSystem/observation-category",
                code: "vital-signs",
                display: "Vital Signs",
              },
            ],
          },
        ],
        code: {
          coding: [
            { system: "http://loinc.org", code: "8302-2", display: "Body height" },
          ],
          text: "Körpergrösse",
        },
        subject: { reference: `Patient/${p.id}` },
        effectiveDateTime: authored,
        valueQuantity: {
          value: medicalGeneral.height_cm,
          unit: "cm",
          system: "http://unitsofmeasure.org",
          code: "cm",
        },
      });
    }

    // ---------- Bundle ----------
    const bundle = {
      resourceType: "Bundle",
      type: "collection",
      timestamp: authored,
      identifier: {
        system: "http://example.org/case-number",
        value: c.case_number,
      },
      entry: [
        { resource: patientResource },
        ...(relatedPerson ? [{ resource: relatedPerson }] : []),
        { resource: questionnaire },
        { resource: questionnaireResponse },
        ...obs.map((o) => ({ resource: o })),
      ],
    };

    const filename = `case-${c.case_number}.fhir.json`;

    return new NextResponse(JSON.stringify(bundle, null, 2), {
      status: 200,
      headers: {
        "Content-Type": "application/fhir+json; charset=utf-8",
        "Content-Disposition": `attachment; filename="${filename}"`,
      },
    });
  } catch (e) {
    console.error("FHIR export error:", e);
    return NextResponse.json({ ok: false, error: "FHIR export error" }, { status: 500 });
  }
}