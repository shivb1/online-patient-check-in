"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useIntake } from "@/app/context/IntakeContext";

import { ReviewRow } from "@/app/components/review/ReviewRow";
import { ReviewSection } from "@/app/components/review/ReviewSection";
import { YesNoText } from "@/app/components/review/YesNoText";

export default function ReviewPage() {
  const { data } = useIntake();
  const router = useRouter();
  const [isSubmitting, setIsSubmitting] = useState(false);

  async function handleSubmit() {
    try {
      setIsSubmitting(true);

      const res = await fetch("/intake/submit", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data),
      });

      if (!res.ok) {
        throw new Error("Fehler beim Absenden");
      }

      router.push("/intake/submit/success");
    } catch (err) {
      alert("Fehler beim Speichern der Anmeldung");
      console.error(err);
    } finally {
      setIsSubmitting(false);
    }
  }

  return (
    <main className="min-h-screen flex justify-center p-6">
      <div className="w-full max-w-3xl bg-white rounded-xl shadow-lg border border-slate-200 p-8">
        <h1 className="text-2xl font-bold text-slate-900 mb-6">
          Überprüfung Ihrer Angaben
        </h1>

        {/* ================= Patientendaten ================= */}
        <ReviewSection title="Patientendaten">
          <ReviewRow label="Vorname" value={data.firstName} />
          <ReviewRow label="Nachname" value={data.lastName} />
          <ReviewRow label="Geburtsdatum" value={data.birthDate} />
          <ReviewRow label="AHV-Nummer" value={data.ahvNumber} />
          <ReviewRow label="Geschlecht" value={data.gender} />
        </ReviewSection>

        {/* ================= Kontakt ================= */}
        <ReviewSection title="Kontakt">
          <ReviewRow label="Adresse" value={data.address} />
          <ReviewRow label="PLZ" value={data.zip} />
          <ReviewRow label="Ort" value={data.city} />
          <ReviewRow label="Telefon" value={data.phone} />
          <ReviewRow label="Telefon privat" value={data.phonePrivate} />
          <ReviewRow label="E-Mail" value={data.email} />
        </ReviewSection>

        {/* ================= Allgemein ================= */}
        <ReviewSection title="Allgemein">
          <ReviewRow
            label="Im Spital (12 Monate)"
            value={<YesNoText value={data.hospitalized} />}
          />
          <ReviewRow
            label="Hausarzt regelmässig"
            value={<YesNoText value={data.regularGP} />}
          />
          <ReviewRow
            label="Regelmässige Medikamente"
            value={<YesNoText value={data.regularMedication} />}
          />

          {/* Zusatzfelder (nur wenn wirklich befüllt → ReviewRow blendet sonst aus) */}
          <ReviewRow label="Medikamente" value={data.medications} />

          <ReviewRow
            label="Allergien"
            value={<YesNoText value={data.allergiesFlag} />}
          />
          <ReviewRow label="Welche Allergien" value={data.allergies} />

          <ReviewRow
            label="Aktivität eingeschränkt"
            value={<YesNoText value={data.limitedActivity} />}
          />
          <ReviewRow label="Wie" value={data.limitedActivityHow} />
          <ReviewRow label="Seit wann" value={data.limitedActivitySince} />

          {/* Gebärfähig-Fragen: nur zeigen wenn gender female/other */}
          {(data.gender === "female" || data.gender === "other") && (
            <>
              <ReviewRow
                label="Schwangerschaft möglich"
                value={<YesNoText value={data.pregnantPossible} />}
              />
              <ReviewRow
                label="Stillen"
                value={<YesNoText value={data.breastfeeding} />}
              />
            </>
          )}

          <ReviewRow
            label="Operation/Narkose"
            value={<YesNoText value={data.anesthesia} />}
          />
          <ReviewRow label="Warum" value={data.anesthesiaWhy} />

          <ReviewRow
            label="Probleme bei Narkose"
            value={<YesNoText value={data.anesthesiaProblems} />}
          />
          <ReviewRow label="Welche Probleme" value={data.anesthesiaProblemsWhich} />

          <ReviewRow
            label="Familie: Narkoseprobleme"
            value={<YesNoText value={data.familyAnesthesiaProblems} />}
          />
        </ReviewSection>

        {/* ================= Herz-Kreislauf ================= */}
        <ReviewSection title="Herz-Kreislauf">
          <ReviewRow
            label="Blutdruckprobleme"
            value={<YesNoText value={data.bloodPressure} />}
          />
          <ReviewRow
            label="Schmerzen/Atemnot bei Belastung"
            value={<YesNoText value={data.exertionPainBreath} />}
          />
          <ReviewRow
            label="Flach liegen Problem"
            value={<YesNoText value={data.flatLyingProblem} />}
          />
          <ReviewRow
            label="Unregelmässiger Puls"
            value={<YesNoText value={data.irregularPulse} />}
          />
          <ReviewRow
            label="Nachts Symptome"
            value={<YesNoText value={data.nightSymptoms} />}
          />
          <ReviewRow
            label="Geschwollene Beine/Füsse"
            value={<YesNoText value={data.swollenLegs} />}
          />
          <ReviewRow
            label="Thrombose/Embolie"
            value={<YesNoText value={data.thrombosis} />}
          />
        </ReviewSection>

        {/* ================= Lunge ================= */}
        <ReviewSection title="Lunge">
          <ReviewRow label="Raucher/in" value={<YesNoText value={data.smoker} />} />
          <ReviewRow
            label="Luftnot bei Belastung"
            value={<YesNoText value={data.dyspnea} />}
          />
          <ReviewRow label="Asthma" value={<YesNoText value={data.asthma} />} />
          <ReviewRow
            label="Regelmässig inhalieren"
            value={<YesNoText value={data.inhaler} />}
          />
        </ReviewSection>

        {/* ================= Übrige ================= */}
        <ReviewSection title="Weitere medizinische Angaben">
          <ReviewRow
            label="Diabetes/Hormonkrankheiten"
            value={<YesNoText value={data.diabetes} />}
          />
          <ReviewRow label="Tumorerkrankung" value={<YesNoText value={data.cancer} />} />
          <ReviewRow
            label="Gerinnungsprobleme"
            value={<YesNoText value={data.coagulation} />}
          />
        </ReviewSection>

        {/* ================= Körperdaten ================= */}
        <ReviewSection title="Körperdaten">
          <ReviewRow label="Gewicht" value={data.weight ? `${data.weight} kg` : ""} />
          <ReviewRow label="Grösse" value={data.height ? `${data.height} cm` : ""} />
        </ReviewSection>

        {/* ================= Aktionen ================= */}
        <div className="flex justify-between pt-8">
          <button
            onClick={() => router.back()}
            className="px-6 py-3 rounded-md bg-slate-200 hover:bg-slate-300 text-slate-900 font-semibold"
            disabled={isSubmitting}
          >
            Zurück
          </button>

          <button
            onClick={handleSubmit}
            className="px-6 py-3 rounded-md bg-blue-600 hover:bg-blue-700 text-white font-semibold disabled:opacity-60"
            disabled={isSubmitting}
          >
            {isSubmitting ? "Wird gesendet..." : "Anmeldung abschliessen"}
          </button>
        </div>
      </div>
    </main>
  );
}
