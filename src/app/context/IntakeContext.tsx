"use client";

import React, { createContext, useContext, useMemo, useState } from "react";

export type YesNo = "yes" | "no";
export type Gender = "male" | "female" | "other" | "";

export type IntakeData = {

   // ========= Case (QR) =========
  caseToken?: string;
  caseNumber?: string;
  casePatientId?: string;

  // ========= Patientendaten =========
  firstName?: string;
  lastName?: string;
  gender?: Gender;
  birthDate?: string;
  ahvNumber?: string;

  address?: string;
  zip?: string;
  city?: string;
  phone?: string;
  phonePrivate?: string;
  email?: string;

  // ========= Notfallkontakt (optional) =========
  emergencyFirstName?: string;
  emergencyLastName?: string;
  emergencyAddress?: string;
  emergencyZip?: string;  // NEU
  emergencyCity?: string; // NEU
  emergencyPhone?: string;

  // ========= Medical History (nach deinem PDF) =========
  hospitalized?: YesNo;
  hospitalizedWhen?: string;
  hospitalizedWhere?: string;
  hospitalizedWhy?: string;

  regularGP?: YesNo;
  regularGPWhy?: string;

  regularMedication?: YesNo;
  takenLast7Days?: YesNo;
  medications?: string;
  medicationList?: string[];
  medicationsRaw?: unknown[];
  limitedActivity?: YesNo;
  limitedActivityHow?: string;
  limitedActivitySince?: string;

  allergiesFlag?: YesNo;
  allergies?: string;

  // Frauen im gebärfähigen Alter
  pregnantPossible?: YesNo;
  breastfeeding?: YesNo;

  anesthesia?: YesNo;
  anesthesiaWhy?: string;
  anesthesiaProblems?: YesNo;
  anesthesiaProblemsWhich?: string;

  familyAnesthesiaProblems?: YesNo;

  // Herz-Kreislauf
  bloodPressure?: YesNo;
  exertionPainBreath?: YesNo;
  flatLyingProblem?: YesNo;
  irregularPulse?: YesNo;
  nightSymptoms?: YesNo;
  swollenLegs?: YesNo;
  thrombosis?: YesNo;

  // Lunge
  smoker?: YesNo;
  dyspnea?: YesNo;
  asthma?: YesNo;
  inhaler?: YesNo;

  // Übrige Fragen
  paralysisStroke?: YesNo;
  neurological?: YesNo;
  kidneyProblem?: YesNo;
  liverProblem?: YesNo;
  reflux?: YesNo;
  diabetes?: YesNo;
  cancer?: YesNo;
  coagulation?: YesNo;

  anemia?: YesNo;
  transfusion?: YesNo;
  transfusionProblems?: YesNo;

  infectionDisease?: YesNo;
  woundHealingProblems?: YesNo;
  inflammationLast12mo?: YesNo;

  substances?: YesNo;
  badTeeth?: YesNo;
  dentures?: YesNo;
  implantedDevice?: YesNo;

  weight?: string;
  height?: string;
};

type IntakeContextValue = {
  data: IntakeData;
  updateData: (patch: Partial<IntakeData>) => void;
  reset: () => void;
};

const IntakeContext = createContext<IntakeContextValue | null>(null);

const defaultData: IntakeData = {
  caseToken: "",
  caseNumber: "",
  casePatientId: "",
  
  firstName: "",
  lastName: "",
  gender: "",
  birthDate: "",
  ahvNumber: "",

  address: "",
  zip: "",
  city: "",
  phone: "",
  phonePrivate: "",
  email: "",

  emergencyFirstName: "",
  emergencyLastName: "",
  emergencyAddress: "",
  emergencyZip: "",  // NEU
  emergencyCity: "", // NEU
  emergencyPhone: "",

  hospitalized: undefined,
  hospitalizedWhen: "",
  hospitalizedWhere: "",
  hospitalizedWhy: "",

  regularGP: undefined,
  regularGPWhy: "",

  regularMedication: undefined,
  takenLast7Days: undefined,
  medications: "",

  limitedActivity: undefined,
  limitedActivityHow: "",
  limitedActivitySince: "",

  allergiesFlag: undefined,
  allergies: "",

  pregnantPossible: undefined,
  breastfeeding: undefined,

  anesthesia: undefined,
  anesthesiaWhy: "",
  anesthesiaProblems: undefined,
  anesthesiaProblemsWhich: "",
  familyAnesthesiaProblems: undefined,

  bloodPressure: undefined,
  exertionPainBreath: undefined,
  flatLyingProblem: undefined,
  irregularPulse: undefined,
  nightSymptoms: undefined,
  swollenLegs: undefined,
  thrombosis: undefined,

  smoker: undefined,
  dyspnea: undefined,
  asthma: undefined,
  inhaler: undefined,

  paralysisStroke: undefined,
  neurological: undefined,
  kidneyProblem: undefined,
  liverProblem: undefined,
  reflux: undefined,
  diabetes: undefined,
  cancer: undefined,
  coagulation: undefined,

  anemia: undefined,
  transfusion: undefined,
  transfusionProblems: undefined,

  infectionDisease: undefined,
  woundHealingProblems: undefined,
  inflammationLast12mo: undefined,

  substances: undefined,
  badTeeth: undefined,
  dentures: undefined,
  implantedDevice: undefined,

  weight: "",
  height: "",
};

export function IntakeProvider({ children }: { children: React.ReactNode }) {
  const [data, setData] = useState<IntakeData>(defaultData);

  const updateData = (patch: Partial<IntakeData>) => {
    setData((prev) => {
      const next: IntakeData = { ...prev, ...patch };

      // Wenn gender auf "male" gesetzt wird -> Felder zu gebaerfaehigem Alter loeschen
      if (patch.gender === "male") {
        next.pregnantPossible = undefined;
        next.breastfeeding = undefined;
      }

      return next;
    });
  };

  const reset = () => setData(defaultData);

  const value = useMemo(() => ({ data, updateData, reset }), [data]);

  return <IntakeContext.Provider value={value}>{children}</IntakeContext.Provider>;
}

export function useIntake() {
  const ctx = useContext(IntakeContext);
  if (!ctx) throw new Error("useIntake must be used within IntakeProvider");
  return ctx;
}