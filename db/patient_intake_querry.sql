-- =========================================================
-- Schema: online-patient-check-in (PostgreSQL)
-- Erstellt Tabellen + Constraints + Defaults
-- =========================================================

-- Für gen_random_uuid()
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Für Fallnummern (YYYYMMDD-00001 usw.)
CREATE SEQUENCE IF NOT EXISTS intake_case_seq;

-- =========================================================
-- PATIENT
-- =========================================================
CREATE TABLE IF NOT EXISTS patient (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  first_name  text NOT NULL,
  last_name   text NOT NULL,
  birth_date  date NOT NULL,
  ahv_number  text NOT NULL,
  created_at  timestamptz NOT NULL DEFAULT now(),
  gender      text,

  CONSTRAINT patient_gender_check
    CHECK (gender IS NULL OR gender IN ('male','female','other',''))
);

-- =========================================================
-- CONTACT (1:1 pro Patient)
-- =========================================================
CREATE TABLE IF NOT EXISTS contact (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id    uuid NOT NULL,
  address       text NOT NULL,
  zip           text NOT NULL,
  city          text NOT NULL,
  phone         text NOT NULL,
  phone_private text,
  email         text,
  created_at    timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT fk_contact_patient
    FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE CASCADE,

  -- 1:1 Beziehung: pro Patient genau ein Kontakt-Datensatz
  CONSTRAINT ux_contact_patient UNIQUE (patient_id)
);

-- =========================================================
-- EMERGENCY CONTACT (optional, mehrere möglich)
-- =========================================================
CREATE TABLE IF NOT EXISTS emergency_contact (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id uuid NOT NULL,
  first_name text,
  last_name  text,
  address    text,
  phone      text,
  created_at timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT emergency_contact_patient_id_fkey
    FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE CASCADE
);

-- =========================================================
-- INTAKE CASE (Fall)
-- =========================================================
CREATE TABLE IF NOT EXISTS intake_case (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  case_number text NOT NULL DEFAULT (
    to_char(current_date,'YYYYMMDD') || '-' || lpad(nextval('intake_case_seq')::text, 5, '0')
  ),
  token       uuid NOT NULL DEFAULT gen_random_uuid(),
  patient_id  uuid NOT NULL,
  status      text NOT NULL DEFAULT 'open',
  created_at  timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT intake_case_case_number_key UNIQUE (case_number),
  CONSTRAINT intake_case_token_key       UNIQUE (token),

  CONSTRAINT intake_case_patient_id_fkey
    FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE CASCADE
);

-- =========================================================
-- MEDICAL GENERAL (inkl. Gewicht/Grösse)
-- =========================================================
CREATE TABLE IF NOT EXISTS medical_general (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id           uuid NOT NULL,

  hospitalized         boolean,
  hospitalized_when    text,
  hospitalized_where   text,
  hospitalized_why     text,

  regular_gp           boolean,
  regular_gp_why       text,

  regular_medication   boolean,
  medications          text,

  allergies            boolean,
  allergies_text       text,

  weight_kg            integer,
  height_cm            integer,

  created_at           timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT fk_medical_general_patient
    FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE CASCADE,

  CONSTRAINT chk_weight_kg_range
    CHECK (weight_kg IS NULL OR (weight_kg BETWEEN 1 AND 500)),

  CONSTRAINT chk_height_cm_range
    CHECK (height_cm IS NULL OR (height_cm BETWEEN 10 AND 250))
);

-- =========================================================
-- MEDICAL CARDIO
-- =========================================================
CREATE TABLE IF NOT EXISTS medical_cardio (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id           uuid NOT NULL,

  blood_pressure       boolean,
  exertion_pain_breath boolean,
  flat_lying_problem   boolean,
  irregular_pulse      boolean,
  night_symptoms       boolean,
  swollen_legs         boolean,
  thrombosis           boolean,

  created_at           timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT fk_medical_cardio_patient
    FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE CASCADE
);

-- =========================================================
-- MEDICAL LUNG (ohne inhaler)
-- =========================================================
CREATE TABLE IF NOT EXISTS medical_lung (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id uuid NOT NULL,

  smoker     boolean,
  dyspnea    boolean,
  asthma     boolean,

  created_at timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT fk_medical_lung_patient
    FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE CASCADE
);

-- =========================================================
-- MEDICAL OTHER
-- =========================================================
CREATE TABLE IF NOT EXISTS medical_other (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id  uuid NOT NULL,

  diabetes    boolean,
  cancer      boolean,
  coagulation boolean,

  created_at  timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT fk_medical_other_patient
    FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE CASCADE
);
