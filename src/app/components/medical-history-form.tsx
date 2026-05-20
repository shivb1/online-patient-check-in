"use client";

import React from "react";
import { useIntake, YesNo } from "../context/IntakeContext";

function SectionHeader({ title }: { title: string }) {
  return (
    <div className="mt-8">
      <div className="bg-slate-700 text-white font-semibold px-4 py-2 rounded-md">
        {title}
      </div>
    </div>
  );
}

function YesNoRow({
  label,
  value,
  onChange,
}: {
  label: string;
  value?: YesNo;
  onChange: (v: YesNo) => void;
}) {
  const base = "inline-flex items-center gap-2 cursor-pointer select-none";
  const radio = "h-4 w-4 accent-slate-700";

  return (
    <div className="grid grid-cols-12 gap-3 py-3 border-b border-slate-200">
      <div className="col-span-12 md:col-span-8 text-sm text-slate-900">
        {label}
      </div>

      <div className="col-span-12 md:col-span-4 flex md:justify-end gap-6">
        <label className={base}>
          <input
            className={radio}
            type="radio"
            checked={value === "yes"}
            onChange={() => onChange("yes")}
          />
          <span className="text-sm">ja</span>
        </label>

        <label className={base}>
          <input
            className={radio}
            type="radio"
            checked={value === "no"}
            onChange={() => onChange("no")}
          />
          <span className="text-sm">nein</span>
        </label>
      </div>
    </div>
  );
}

function LineInput({
  placeholder,
  value,
  onChange,
}: {
  placeholder: string;
  value?: string;
  onChange: (v: string) => void;
}) {
  return (
    <input
      type="text"
      className="w-full bg-transparent border-b border-slate-300 focus:border-slate-700 outline-none py-1 text-sm"
      placeholder={placeholder}
      value={value ?? ""}
      onChange={(e) => onChange(e.target.value)}
    />
  );
}

function LineArea({
  placeholder,
  value,
  onChange,
  rows = 3,
}: {
  placeholder: string;
  value?: string;
  onChange: (v: string) => void;
  rows?: number;
}) {
  return (
    <textarea
      rows={rows}
      className="w-full bg-white border border-slate-300 rounded-md px-3 py-2 text-sm focus:border-slate-700 outline-none"
      placeholder={placeholder}
      value={value ?? ""}
      onChange={(e) => onChange(e.target.value)}
    />
  );
}

// Zahlen-only Helper (verhindert e, -, Text)
function digitsOnly(raw: string): string {
  return (raw ?? "").replace(/[^\d]/g, "");
}

export default function MedicalHistoryForm() {
  const { data, updateData } = useIntake();

  return (
    <div className="text-slate-900">
      <h1 className="text-xl font-bold mb-1">
        Allgemeine Fragen zum Gesundheitszustand
      </h1>
      <p className="text-xs text-slate-600 mb-6">
        Bitte beantworten Sie die Fragen so gut wie möglich.
      </p>

      {/* ===================== Allgemein ===================== */}
      <SectionHeader title="ALLGEMEIN" />

      <YesNoRow
        label="Waren Sie in den letzten 12 Monaten im Spital?"
        value={data.hospitalized}
        onChange={(v) => updateData({ hospitalized: v })}
      />
      {data.hospitalized === "yes" && (
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 pl-0 md:pl-6 py-3">
          <LineInput
            placeholder="wenn ja: wann"
            value={data.hospitalizedWhen}
            onChange={(v) => updateData({ hospitalizedWhen: v })}
          />
          <LineInput
            placeholder="wo"
            value={data.hospitalizedWhere}
            onChange={(v) => updateData({ hospitalizedWhere: v })}
          />
          <LineInput
            placeholder="warum"
            value={data.hospitalizedWhy}
            onChange={(v) => updateData({ hospitalizedWhy: v })}
          />
        </div>
      )}

      <YesNoRow
        label="Gehen Sie regelmässig zum Hausarzt?"
        value={data.regularGP}
        onChange={(v) => updateData({ regularGP: v })}
      />
      {data.regularGP === "yes" && (
        <div className="pl-0 md:pl-6 py-3">
          <LineInput
            placeholder="wenn ja: warum"
            value={data.regularGPWhy}
            onChange={(v) => updateData({ regularGPWhy: v })}
          />
        </div>
      )}

{/*      <YesNoRow
        label="Nehmen Sie regelmässig Medikamente? (Wichtig auch: blutverdünnende Medikamente wie Marcoumar, Aspirin, Plavix?)"
        value={data.regularMedication}
        onChange={(v) => updateData({ regularMedication: v })}
      />
      {data.regularMedication === "yes" && (
        <div className="pl-0 md:pl-6 py-3">
          <LineArea
            placeholder="wenn ja: welche (oder separate Liste)"
            value={data.medications}
            onChange={(v) => updateData({ medications: v })}
            rows={3}
          />
        </div>
      )}
*/}
      <YesNoRow
        label="Ist Ihre normale körperliche Aktivität oder Ihr Allgemeinzustand beeinträchtigt?"
        value={data.limitedActivity}
        onChange={(v) => updateData({ limitedActivity: v })}
      />
      {data.limitedActivity === "yes" && (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 pl-0 md:pl-6 py-3">
          <LineInput
            placeholder="wenn ja: wie"
            value={data.limitedActivityHow}
            onChange={(v) => updateData({ limitedActivityHow: v })}
          />
          <LineInput
            placeholder="seit wann"
            value={data.limitedActivitySince}
            onChange={(v) => updateData({ limitedActivitySince: v })}
          />
        </div>
      )}

      <YesNoRow
        label="Haben Sie Allergien / Überempfindlichkeiten? (z.B. Latex, Antibiotika, Medikamente, Metalle, Pflaster, Nahrungsmittel)"
        value={data.allergiesFlag}
        onChange={(v) => updateData({ allergiesFlag: v })}
      />
      {data.allergiesFlag === "yes" && (
        <div className="pl-0 md:pl-6 py-3">
          <LineArea
            placeholder="wenn ja: welche"
            value={data.allergies}
            onChange={(v) => updateData({ allergies: v })}
            rows={3}
          />
        </div>
      )}

      {(data.gender === "female" || data.gender === "other") && (
        <>
          <div className="mt-4 text-sm font-semibold">
            Für Frauen im gebärfähigen Alter
          </div>

          <YesNoRow
            label="Könnten Sie schwanger sein?"
            value={data.pregnantPossible}
            onChange={(v) => updateData({ pregnantPossible: v })}
          />
          <YesNoRow
            label="Stillen Sie derzeit?"
            value={data.breastfeeding}
            onChange={(v) => updateData({ breastfeeding: v })}
          />
        </>
      )}

      <YesNoRow
        label="Haben Sie schon je eine Operation oder Narkose / Teilnarkose erhalten?"
        value={data.anesthesia}
        onChange={(v) => updateData({ anesthesia: v })}
      />
      {data.anesthesia === "yes" && (
        <div className="pl-0 md:pl-6 py-3 space-y-3">
          <LineInput
            placeholder="wenn ja: warum"
            value={data.anesthesiaWhy}
            onChange={(v) => updateData({ anesthesiaWhy: v })}
          />

          <YesNoRow
            label="Hatten Sie dabei Probleme?"
            value={data.anesthesiaProblems}
            onChange={(v) => updateData({ anesthesiaProblems: v })}
          />
          {data.anesthesiaProblems === "yes" && (
            <div className="pl-0 md:pl-6">
              <LineInput
                placeholder="wenn ja: welche"
                value={data.anesthesiaProblemsWhich}
                onChange={(v) => updateData({ anesthesiaProblemsWhich: v })}
              />
            </div>
          )}
        </div>
      )}

      <YesNoRow
        label="Gab es bei Familienangehörigen Probleme mit Narkosen oder Operationen?"
        value={data.familyAnesthesiaProblems}
        onChange={(v) => updateData({ familyAnesthesiaProblems: v })}
      />

      {/* ===================== Herz-Kreislauf ===================== */}
      <SectionHeader title="FRAGEN ZUM HERZ-KREISLAUF-BEFINDEN" />

      <YesNoRow
        label="Haben Sie Blutdruckprobleme (zu hoch / zu tief)?"
        value={data.bloodPressure}
        onChange={(v) => updateData({ bloodPressure: v })}
      />
      <YesNoRow
        label="Haben Sie Schmerzen, Atemprobleme oder Druck bei Anstrengung (z.B. 1 Stock Treppen steigen)?"
        value={data.exertionPainBreath}
        onChange={(v) => updateData({ exertionPainBreath: v })}
      />
      <YesNoRow
        label="Ist flach liegen für Sie ein Problem?"
        value={data.flatLyingProblem}
        onChange={(v) => updateData({ flatLyingProblem: v })}
      />
      <YesNoRow
        label="Bemerken Sie manchmal einen unregelmässigen Puls (Herzrasen oder Herzstolpern)?"
        value={data.irregularPulse}
        onChange={(v) => updateData({ irregularPulse: v })}
      />
      <YesNoRow
        label="Haben Sie nachts Probleme, wie häufiges Wasserlösen, Unvermögen flach zu liegen?"
        value={data.nightSymptoms}
        onChange={(v) => updateData({ nightSymptoms: v })}
      />
      <YesNoRow
        label="Haben Sie geschwollene Beine oder Füsse?"
        value={data.swollenLegs}
        onChange={(v) => updateData({ swollenLegs: v })}
      />
      <YesNoRow
        label="Hatten Sie schon einmal ein Blutgerinnsel (Thrombose oder Embolie)?"
        value={data.thrombosis}
        onChange={(v) => updateData({ thrombosis: v })}
      />

      {/* ===================== Lunge ===================== */}
      <SectionHeader title="FRAGEN ZUR LUNGE" />

      <YesNoRow
        label="Sind Sie Raucher/in?"
        value={data.smoker}
        onChange={(v) => updateData({ smoker: v })}
      />
      <YesNoRow
        label="Haben Sie bei Anstrengung Luftnot?"
        value={data.dyspnea}
        onChange={(v) => updateData({ dyspnea: v })}
      />
      <YesNoRow
        label="Haben Sie Asthma, chronischen Auswurf, chronischen Husten?"
        value={data.asthma}
        onChange={(v) => updateData({ asthma: v })}
      />
      <YesNoRow
        label="Müssen Sie regelmässig inhalieren?"
        value={data.inhaler}
        onChange={(v) => updateData({ inhaler: v })}
      />

      {/* ===================== Übrige Fragen ===================== */}
      <SectionHeader title="ÜBRIGE FRAGEN" />

      <YesNoRow
        label="Haben Sie schon mal eine Lähmung gehabt (eine «Streifung» oder ein «Schlägli»)?"
        value={data.paralysisStroke}
        onChange={(v) => updateData({ paralysisStroke: v })}
      />
      <YesNoRow
        label="Haben Sie andere neurologische Krankheiten (z.B. Epilepsie, Migräne, Muskelkrankheiten)?"
        value={data.neurological}
        onChange={(v) => updateData({ neurological: v })}
      />
      <YesNoRow
        label="Haben Sie Nierenprobleme (z.B. Dialyse)?"
        value={data.kidneyProblem}
        onChange={(v) => updateData({ kidneyProblem: v })}
      />
      <YesNoRow
        label="Haben oder hatten Sie Leberprobleme (z.B. Gelbsucht / Hepatitis)?"
        value={data.liverProblem}
        onChange={(v) => updateData({ liverProblem: v })}
      />
      <YesNoRow
        label="Haben Sie Magen- oder Verdauungsprobleme (z.B. häufiges saures Aufstossen / Reflux)?"
        value={data.reflux}
        onChange={(v) => updateData({ reflux: v })}
      />
      <YesNoRow
        label="Haben Sie Diabetes, andere Hormonkrankheiten (z.B. Schilddrüsenleiden)?"
        value={data.diabetes}
        onChange={(v) => updateData({ diabetes: v })}
      />
      <YesNoRow
        label="Haben Sie bösartige Tumorerkrankungen (jetzt oder früher)?"
        value={data.cancer}
        onChange={(v) => updateData({ cancer: v })}
      />
      <YesNoRow
        label="Haben Sie oder Blutsverwandte Probleme mit der Blutgerinnung (z.B. Blutverdünnung, Blutung beim Rasieren, Zähneputzen usw.)?"
        value={data.coagulation}
        onChange={(v) => updateData({ coagulation: v })}
      />

      <YesNoRow
        label="Haben Sie eine bekannte Blutarmut?"
        value={data.anemia}
        onChange={(v) => updateData({ anemia: v })}
      />
      <YesNoRow
        label="Haben Sie jemals Blut / Blutprodukte erhalten?"
        value={data.transfusion}
        onChange={(v) => updateData({ transfusion: v })}
      />
      {data.transfusion === "yes" && (
        <div className="pl-0 md:pl-6 py-3">
          <YesNoRow
            label="Wenn ja: Gab es dabei Probleme?"
            value={data.transfusionProblems}
            onChange={(v) => updateData({ transfusionProblems: v })}
          />
        </div>
      )}

      <YesNoRow
        label="Besteht eine akute oder chronische Infektionskrankheit (z.B. HIV, Hepatitis, Tuberkulose)?"
        value={data.infectionDisease}
        onChange={(v) => updateData({ infectionDisease: v })}
      />
      <YesNoRow
        label="Kam es bei Wunden schon einmal zu Heilungsproblemen (z.B. Abszesse, Eiterung, Fisteln, starke Narbenbildung)?"
        value={data.woundHealingProblems}
        onChange={(v) => updateData({ woundHealingProblems: v })}
      />
      <YesNoRow
        label="Bestand in den letzten 12 Monaten eine akute oder chronische Entzündung (z.B. an einem Zahn)?"
        value={data.inflammationLast12mo}
        onChange={(v) => updateData({ inflammationLast12mo: v })}
      />
      <YesNoRow
        label="Trinken Sie regelmässig Alkohol oder nehmen Sie Drogen ein?"
        value={data.substances}
        onChange={(v) => updateData({ substances: v })}
      />
      <YesNoRow
        label="Haben Sie defekte oder wacklige Zähne?"
        value={data.badTeeth}
        onChange={(v) => updateData({ badTeeth: v })}
      />
      <YesNoRow
        label="Tragen Sie Zahnprothesen?"
        value={data.dentures}
        onChange={(v) => updateData({ dentures: v })}
      />
      <YesNoRow
        label="Tragen Sie ein implantiertes elektromedizinisches Gerät (z.B. Herzschrittmacher, Defibrillator)?"
        value={data.implantedDevice}
        onChange={(v) => updateData({ implantedDevice: v })}
      />

      {/* ===================== Körperdaten ===================== */}
      <SectionHeader title="KÖRPERDATEN" />

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6 py-4">
        <div>
          <div className="text-xs text-slate-600 mb-1">Gewicht (kg) *</div>
          <input
            type="number"
            name="weight"
            required
            min={1}
            max={500}
            step={1}
            inputMode="numeric"
            className="w-full bg-white border border-slate-300 rounded-md px-3 py-2 text-sm focus:border-slate-700 outline-none"
            placeholder="z.B. 72"
            value={data.weight ?? ""}
            onChange={(e) => {
              const v = digitsOnly(e.target.value);
              updateData({ weight: v });
            }}
            onKeyDown={(e) => {
              // verhindert e, E, -, +, .
              if (["e", "E", "-", "+", "."].includes(e.key)) e.preventDefault();
            }}
          />
        </div>

        <div>
          <div className="text-xs text-slate-600 mb-1">Körpergrösse (cm) *</div>
          <input
            type="number"
            name="height"
            required
            min={10}
            max={250}
            step={1}
            inputMode="numeric"
            className="w-full bg-white border border-slate-300 rounded-md px-3 py-2 text-sm focus:border-slate-700 outline-none"
            placeholder="z.B. 178"
            value={data.height ?? ""}
            onChange={(e) => {
              const v = digitsOnly(e.target.value);
              updateData({ height: v });
            }}
            onKeyDown={(e) => {
              if (["e", "E", "-", "+", "."].includes(e.key)) e.preventDefault();
            }}
          />
        </div>
      </div>
    </div>
  );
}