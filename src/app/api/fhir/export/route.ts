import { NextResponse } from "next/server";
import { pool } from "@/app/lib/db";

// ---------- Database Row Types ----------
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
  medications_json: unknown | null; // Das neue Feld für strukturierte Daten
  allergies: boolean | null;
  allergies_text: string | null;
  weight_kg: number | null;
  height_cm: number | null;
  family_anesthesia_problems: boolean | null;
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

/**
 * Interface für ein Medikament, so wie es aus unserer neuen JSONB-Spalte kommt.
 */
interface StoredMedication {
  id: string;
  name: string;
  description?: string;
  category: "regular" | "acute";
}

// ---------- Helpers (FHIR item builders) ----------
type QrAnswer = { valueString: string } | { valueBoolean: boolean } | { valueInteger: number };

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

/**
 * Holt alle Patientendaten und konvertiert diese in ein strukturiertes FHIR R4 Bundle.
 */
export async function GET(req: Request) {
  try {
    const url = new URL(req.url);
    const caseNumber = (url.searchParams.get("caseNumber") ?? "").trim();

    if (!caseNumber) {
      return NextResponse.json({ ok: false, error: 'Bitte caseNumber angeben' }, { status: 400 });
    }

    // 1) Case holen
    const caseRes = await pool.query<DbCaseRow>(
      `SELECT case_number, token::text, patient_id::text, status, created_at::text FROM intake_case WHERE case_number = $1 LIMIT 1`,
      [caseNumber]
    );
    if ((caseRes.rowCount ?? 0) === 0) return NextResponse.json({ ok: false, error: "Kein Fall gefunden" }, { status: 404 });
    const c = caseRes.rows[0];

    // 2) Patient holen
    const pRes = await pool.query<DbPatientRow>(
      `SELECT id::text, first_name, last_name, birth_date::text, ahv_number, gender, created_at::text FROM patient WHERE id = $1 LIMIT 1`,
      [c.patient_id]
    );
    if ((pRes.rowCount ?? 0) === 0) return NextResponse.json({ ok: false, error: "Patient nicht gefunden" }, { status: 404 });
    const p = pRes.rows[0];

    // 3) Kontakt holen
    const contactRes = await pool.query<DbContactRow>(
      `SELECT id::text, patient_id::text, address, zip, city, phone, phone_private, email, created_at::text FROM contact WHERE patient_id = $1 ORDER BY created_at DESC LIMIT 1`,
      [p.id]
    );
    const contact = (contactRes.rowCount ?? 0) > 0 ? contactRes.rows[0] : null;

    // 4) Notfallkontakt holen
    const ecRes = await pool.query<DbEmergencyRow>(
      `SELECT id::text, patient_id::text, first_name, last_name, address, phone, created_at::text FROM emergency_contact WHERE patient_id = $1 ORDER BY created_at DESC LIMIT 1`,
      [p.id]
    );
    const emergency = (ecRes.rowCount ?? 0) > 0 ? ecRes.rows[0] : null;

    // 5) Alle Medical-Tabellen auslesen
    const mgRes = await pool.query<DbMedicalGeneralRow>(
      `SELECT * FROM medical_general WHERE patient_id = $1 ORDER BY created_at DESC LIMIT 1`, [p.id]
    );
    const medicalGeneral = (mgRes.rowCount ?? 0) > 0 ? mgRes.rows[0] : null;

    const mcRes = await pool.query<DbMedicalCardioRow>(
      `SELECT * FROM medical_cardio WHERE patient_id = $1 ORDER BY created_at DESC LIMIT 1`, [p.id]
    );
    const medicalCardio = (mcRes.rowCount ?? 0) > 0 ? mcRes.rows[0] : null;

    const mlRes = await pool.query<DbMedicalLungRow>(
      `SELECT * FROM medical_lung WHERE patient_id = $1 ORDER BY created_at DESC LIMIT 1`, [p.id]
    );
    const medicalLung = (mlRes.rowCount ?? 0) > 0 ? mlRes.rows[0] : null;

    const moRes = await pool.query<DbMedicalOtherRow>(
      `SELECT * FROM medical_other WHERE patient_id = $1 ORDER BY created_at DESC LIMIT 1`, [p.id]
    );
    const medicalOther = (moRes.rowCount ?? 0) > 0 ? moRes.rows[0] : null;

    // JSON-Array der Medikamente sicher entpacken
    let structuredMedications: StoredMedication[] = [];
    if (medicalGeneral?.medications_json) {
        if (typeof medicalGeneral.medications_json === "string") {
            try { structuredMedications = JSON.parse(medicalGeneral.medications_json) as StoredMedication[]; } catch(e) {}
        } else if (Array.isArray(medicalGeneral.medications_json)) {
            structuredMedications = medicalGeneral.medications_json as StoredMedication[];
        }
    }

    const authored = new Date().toISOString();

    // ---------- FHIR Ressourcen Erstellung ----------

    // 1. FHIR Patient
    const patientResource = {
      resourceType: "Patient",
      id: p.id,
      identifier: [{ system: "http://example.org/identifier/ahv", value: p.ahv_number }],
      name: [{ use: "official", family: p.last_name, given: [p.first_name] }],
      gender: fhirGender(p.gender),
      birthDate: p.birth_date,
      telecom: [
        ...(contact?.phone ? [{ system: "phone", use: "mobile", value: contact.phone }] : []),
        ...(contact?.phone_private ? [{ system: "phone", use: "home", value: contact.phone_private }] : []),
        ...(contact?.email ? [{ system: "email", value: contact.email }] : []),
      ],
      address: contact ? [{ line: [contact.address], postalCode: contact.zip, city: contact.city, country: "CH" }] : undefined,
    };

    // 2. FHIR RelatedPerson (Notfallkontakt)
    const relatedPerson = emergency ? {
        resourceType: "RelatedPerson",
        id: emergency.id,
        patient: { reference: `Patient/${p.id}` },
        name: [{ use: "official", family: (emergency.last_name ?? "").trim() || undefined, given: emergency.first_name ? [emergency.first_name] : undefined }],
        telecom: emergency.phone ? [{ system: "phone", value: emergency.phone }] : undefined,
        address: emergency.address ? [{ line: [emergency.address], country: "CH" }] : undefined,
    } : null;

    // 3. FHIR Questionnaire & QuestionnaireResponse
    const questionnaire = {
      resourceType: "Questionnaire",
      id: "intake-questionnaire",
      status: "active",
      title: "Online Patient Check-in",
    };

    const items: QrItem[] = [];

    if (medicalGeneral) {
      items.push({
        linkId: "medical_general",
        text: "Allgemeine Anamnese (Inkl. Allergien & Familie)",
        item: [
          itemBool("allergies", "Allergien vorhanden", medicalGeneral.allergies),
          itemStr("allergies_text", "Allergien Details", medicalGeneral.allergies_text),
          itemBool("family_anesthesia_problems", "Anästhesieprobleme in der Familie", medicalGeneral.family_anesthesia_problems),
          itemInt("weight_kg", "Gewicht (kg)", medicalGeneral.weight_kg),
          itemInt("height_cm", "Grösse (cm)", medicalGeneral.height_cm),
        ].filter((x): x is QrItem => Boolean(x)),
      });
    }

    if (medicalCardio) {
      items.push({
        linkId: "medical_cardio",
        text: "Herz-Kreislauf",
        item: [
          itemBool("blood_pressure", "Blutdruckprobleme", medicalCardio.blood_pressure),
          itemBool("thrombosis", "Thrombose/Embolie", medicalCardio.thrombosis),
        ].filter((x): x is QrItem => Boolean(x)),
      });
    }

    if (medicalLung) {
      items.push({
        linkId: "medical_lung",
        text: "Lunge",
        item: [
          itemBool("smoker", "Raucher/in", medicalLung.smoker),
          itemBool("asthma", "Asthma", medicalLung.asthma),
        ].filter((x): x is QrItem => Boolean(x)),
      });
    }

    if (medicalOther) {
      items.push({
        linkId: "medical_other",
        text: "Weitere Diagnosen",
        item: [
          itemBool("diabetes", "Diabetes", medicalOther.diabetes),
          itemBool("cancer", "Tumorerkrankung", medicalOther.cancer),
        ].filter((x): x is QrItem => Boolean(x)),
      });
    }

    const questionnaireResponse = {
      resourceType: "QuestionnaireResponse",
      id: `qr-${c.case_number}`,
      status: "completed",
      questionnaire: "Questionnaire/intake-questionnaire",
      subject: { reference: `Patient/${p.id}` },
      authored,
      item: items,
    };

    // 4. FHIR Medications (Aus dem neuen JSONB-Feld generiert)
    const fhirMedicationResources: Record<string, unknown>[] = [];
    const fhirMedicationStatements: Record<string, unknown>[] = [];

    structuredMedications.forEach((med, index) => {
        const medResourceId = `medication-${index + 1}`;
        const statementResourceId = `statement-${index + 1}`;

        fhirMedicationResources.push({
            resourceType: "Medication",
            id: medResourceId,
            code: {
                coding: [{ system: "urn:oid:2.51.1.1", code: med.id, display: med.name }],
                text: med.name
            }
        });

        fhirMedicationStatements.push({
            resourceType: "MedicationStatement",
            id: statementResourceId,
            status: "active",
            category: {
                coding: [{ system: "http://terminology.hl7.org/CodeSystem/medication-statement-category", code: "patientspecified", display: "Patient Specified" }]
            },
            subject: { reference: `Patient/${p.id}` },
            medicationReference: { reference: `Medication/${medResourceId}` },
            dateAsserted: authored,
            dosage: [{ text: med.description || "Keine spezifische Dosierung angegeben" }],
            note: [{ text: `Kategorie: ${med.category === "acute" ? "Akut" : "Dauermedikation"}` }]
        });
    });

    // 5. Finales Bundle erstellen
    const bundle = {
      resourceType: "Bundle",
      type: "collection",
      timestamp: authored,
      identifier: { system: "http://example.org/case-number", value: c.case_number },
      entry: [
        { resource: patientResource },
        ...(relatedPerson ? [{ resource: relatedPerson }] : []),
        { resource: questionnaire },
        { resource: questionnaireResponse },
        ...fhirMedicationResources.map(r => ({ resource: r })),
        ...fhirMedicationStatements.map(r => ({ resource: r }))
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