"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useIntake } from "@/app/context/IntakeContext";

import { ReviewRow } from "@/app/components/review/ReviewRow";
import { ReviewSection } from "@/app/components/review/ReviewSection";
import { YesNoText } from "@/app/components/review/YesNoText";

const STAFF_PASSWORD = "246813579";

export default function ReviewPage() {
  const { data } = useIntake();
  const router = useRouter();

  const [isSubmitting, setIsSubmitting] = useState(false);

  // Modal / Passwort-Freigabe
  const [showGate, setShowGate] = useState(false);
  const [staffPassword, setStaffPassword] = useState("");
  const [staffError, setStaffError] = useState<string>("");

  const hasEmergencyContact =
    (data.emergencyFirstName ?? "").trim() ||
    (data.emergencyLastName ?? "").trim() ||
    (data.emergencyAddress ?? "").trim() ||
    (data.emergencyPhone ?? "").trim();

  function openGate() {
    setStaffError("");
    setStaffPassword("");
    setShowGate(true);
  }

  function closeGate() {
    if (isSubmitting) return;
    setShowGate(false);
    setStaffError("");
    setStaffPassword("");
  }

  async function doSubmit() {
    try {
      setIsSubmitting(true);

      const res = await fetch("/api/intake/submit", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data),
      });

      if (!res.ok) {
        throw new Error("Fehler beim Absenden");
      }

      router.push("/intake/submit/success");
    } catch (err) {
      console.error(err);
      setStaffError("Fehler beim Speichern der Anmeldung. Bitte nochmals versuchen.");
    } finally {
      setIsSubmitting(false);
    }
  }

  async function confirmAndSubmit() {
    setStaffError("");

    if (staffPassword !== STAFF_PASSWORD) {
      setStaffError("Falsches Passwort. Bitte Fachkraft-Passwort eingeben.");
      return;
    }

    await doSubmit();
  }

  return (
    <main className="min-h-screen flex justify-center p-6 bg-slate-100">
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

        {/* ================= Notfallkontakt (optional) ================= */}
        {hasEmergencyContact && (
          <ReviewSection title="Notfallkontakt">
            <ReviewRow label="Vorname" value={data.emergencyFirstName} />
            <ReviewRow label="Nachname" value={data.emergencyLastName} />
            <ReviewRow label="Adresse" value={data.emergencyAddress} />
            <ReviewRow label="Telefon" value={data.emergencyPhone} />
          </ReviewSection>
        )}

        {/* ================= Körperdaten ================= */}
        <ReviewSection title="Körperdaten">
          <ReviewRow label="Gewicht" value={data.weight ? `${data.weight} kg` : ""} />
          <ReviewRow label="Grösse" value={data.height ? `${data.height} cm` : ""} />
        </ReviewSection>

        {/* ================= Medikamente & Allergien ================= */}
        <ReviewSection title="Medikamente & Allergien">
          <ReviewRow
            label="Regelmässige Medikamente"
            value={<YesNoText value={data.regularMedication} />}
          />
          <ReviewRow
            label="Medikamente letzte 7 Tage"
            value={<YesNoText value={data.takenLast7Days} />}
          />
          
          {(data.regularMedication === "yes" || data.takenLast7Days === "yes") && data.medications && (
            <ReviewRow 
              label="Erfasste Medikamente" 
              value={data.medications} 
            />
          )}

          <ReviewRow
            label="Allergien / Überempfindlichkeiten"
            value={<YesNoText value={data.allergiesFlag} />}
          />
          {data.allergiesFlag === "yes" && (
            <ReviewRow label="Welche Allergien" value={data.allergies} />
          )}
        </ReviewSection>

        {/* ================= Allgemein ================= */}
        <ReviewSection title="Allgemein">
          <ReviewRow label="Spitalaufenthalt (letzte 12 M.)" value={<YesNoText value={data.hospitalized} />} />
          {data.hospitalized === "yes" && (
            <>
              <ReviewRow label="Wann" value={data.hospitalizedWhen} />
              <ReviewRow label="Wo" value={data.hospitalizedWhere} />
              <ReviewRow label="Warum" value={data.hospitalizedWhy} />
            </>
          )}

          <ReviewRow label="Regelmässig Hausarzt" value={<YesNoText value={data.regularGP} />} />
          {data.regularGP === "yes" && (
            <ReviewRow label="Warum zum Hausarzt" value={data.regularGPWhy} />
          )}

          <ReviewRow label="Aktivität eingeschränkt" value={<YesNoText value={data.limitedActivity} />} />
          {data.limitedActivity === "yes" && (
            <>
              <ReviewRow label="Wie eingeschränkt" value={data.limitedActivityHow} />
              <ReviewRow label="Seit wann" value={data.limitedActivitySince} />
            </>
          )}

          {(data.gender === "female" || data.gender === "other") && (
            <>
              <ReviewRow label="Schwangerschaft möglich" value={<YesNoText value={data.pregnantPossible} />} />
              <ReviewRow label="Stillen derzeit" value={<YesNoText value={data.breastfeeding} />} />
            </>
          )}
        </ReviewSection>

        {/* ================= Operationen & Narkose ================= */}
        <ReviewSection title="Operationen & Narkose">
          <ReviewRow
            label="Bisherige Operation/Narkose"
            value={<YesNoText value={data.anesthesia} />}
          />
          {data.anesthesia === "yes" && (
            <>
              <ReviewRow label="Warum operiert" value={data.anesthesiaWhy} />
              <ReviewRow
                label="Probleme bei Narkose"
                value={<YesNoText value={data.anesthesiaProblems} />}
              />
              {data.anesthesiaProblems === "yes" && (
                <ReviewRow label="Welche Probleme" value={data.anesthesiaProblemsWhich} />
              )}
            </>
          )}

          <ReviewRow
            label="Familie: Narkoseprobleme"
            value={<YesNoText value={data.familyAnesthesiaProblems} />}
          />
        </ReviewSection>

        {/* ================= Herz-Kreislauf ================= */}
        <ReviewSection title="Herz-Kreislauf">
          <ReviewRow label="Blutdruckprobleme" value={<YesNoText value={data.bloodPressure} />} />
          <ReviewRow label="Schmerzen/Atemnot bei Belastung" value={<YesNoText value={data.exertionPainBreath} />} />
          <ReviewRow label="Flach liegen Problem" value={<YesNoText value={data.flatLyingProblem} />} />
          <ReviewRow label="Unregelmässiger Puls (Herzrasen/stolpern)" value={<YesNoText value={data.irregularPulse} />} />
          <ReviewRow label="Nachts Probleme (Wasserlösen etc.)" value={<YesNoText value={data.nightSymptoms} />} />
          <ReviewRow label="Geschwollene Beine/Füsse" value={<YesNoText value={data.swollenLegs} />} />
          <ReviewRow label="Thrombose oder Embolie" value={<YesNoText value={data.thrombosis} />} />
        </ReviewSection>

        {/* ================= Lunge ================= */}
        <ReviewSection title="Lunge">
          <ReviewRow label="Raucher/in" value={<YesNoText value={data.smoker} />} />
          <ReviewRow label="Luftnot bei Anstrengung" value={<YesNoText value={data.dyspnea} />} />
          <ReviewRow label="Asthma / Chronischer Husten" value={<YesNoText value={data.asthma} />} />
          <ReviewRow label="Regelmässig inhalieren" value={<YesNoText value={data.inhaler} />} />
        </ReviewSection>

        {/* ================= Übrige Fragen ================= */}
        <ReviewSection title="Übrige Fragen">
          <ReviewRow label="Lähmung / Schlaganfall" value={<YesNoText value={data.paralysisStroke} />} />
          <ReviewRow label="Neurologische Krankheiten (Epilepsie etc.)" value={<YesNoText value={data.neurological} />} />
          <ReviewRow label="Nierenprobleme" value={<YesNoText value={data.kidneyProblem} />} />
          <ReviewRow label="Leberprobleme" value={<YesNoText value={data.liverProblem} />} />
          <ReviewRow label="Magen- oder Verdauungsprobleme" value={<YesNoText value={data.reflux} />} />
          <ReviewRow label="Diabetes / Hormonkrankheiten" value={<YesNoText value={data.diabetes} />} />
          <ReviewRow label="Tumorerkrankung" value={<YesNoText value={data.cancer} />} />
          <ReviewRow label="Gerinnungsprobleme" value={<YesNoText value={data.coagulation} />} />
          <ReviewRow label="Bekannte Blutarmut" value={<YesNoText value={data.anemia} />} />
          
          <ReviewRow label="Blut / Blutprodukte erhalten" value={<YesNoText value={data.transfusion} />} />
          {data.transfusion === "yes" && (
            <ReviewRow label="Probleme bei Transfusion" value={<YesNoText value={data.transfusionProblems} />} />
          )}

          <ReviewRow label="Infektionskrankheit (HIV, Hepatitis etc.)" value={<YesNoText value={data.infectionDisease} />} />
          <ReviewRow label="Heilungsprobleme bei Wunden" value={<YesNoText value={data.woundHealingProblems} />} />
          <ReviewRow label="Entzündung (letzte 12 M.)" value={<YesNoText value={data.inflammationLast12mo} />} />
          <ReviewRow label="Regelmässig Alkohol / Drogen" value={<YesNoText value={data.substances} />} />
          <ReviewRow label="Defekte / wacklige Zähne" value={<YesNoText value={data.badTeeth} />} />
          <ReviewRow label="Trägt Zahnprothesen" value={<YesNoText value={data.dentures} />} />
          <ReviewRow label="Implantierte Geräte (Herzschrittmacher etc.)" value={<YesNoText value={data.implantedDevice} />} />
        </ReviewSection>

        {/* ================= Aktionen ================= */}
        <div className="flex justify-between pt-8">
          <button
            type="button"
            onClick={() => router.back()}
            className="px-6 py-3 rounded-md bg-slate-200 hover:bg-slate-300 text-slate-900 font-semibold"
            disabled={isSubmitting}
          >
            Zurück
          </button>

          <button
            type="button"
            onClick={openGate}
            className="px-6 py-3 rounded-md bg-blue-600 hover:bg-blue-700 text-white font-semibold disabled:opacity-60"
            disabled={isSubmitting}
          >
            Anmeldung abschliessen
          </button>
        </div>
      </div>

      {/* ================= Modal: Fachkraft-Freigabe ================= */}
      {showGate && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-6">
          <div className="absolute inset-0 bg-black/50" onClick={closeGate} />
          <div className="relative w-full max-w-lg bg-white rounded-xl shadow-xl border border-slate-200 p-6">
            <h2 className="text-xl font-bold text-slate-900 mb-2">Danke fürs Ausfüllen</h2>
            <p className="text-slate-700">
              Bitte melden Sie sich am Empfang oder warten Sie auf eine Fachkraft.
              Die Anmeldung wird erst nach Bestätigung durch Fachpersonal abgesendet.
            </p>

            <div className="mt-5">
              <label className="block text-sm font-semibold text-slate-900 mb-1">
                Fachkraft-Passwort
              </label>
              <input
                type="password"
                value={staffPassword}
                onChange={(e) => setStaffPassword(e.target.value)}
                className="w-full rounded-md border border-slate-300 px-3 py-2 text-slate-900 outline-none focus:border-blue-600"
                placeholder="Passwort eingeben"
                autoFocus
                disabled={isSubmitting}
              />
              {staffError && <p className="mt-2 text-sm text-red-600">{staffError}</p>}
            </div>

            <div className="mt-6 flex justify-between gap-3">
              <button
                type="button"
                onClick={closeGate}
                className="px-5 py-3 rounded-md bg-slate-200 hover:bg-slate-300 text-slate-900 font-semibold"
                disabled={isSubmitting}
              >
                Abbrechen
              </button>
              <button
                type="button"
                onClick={confirmAndSubmit}
                className="px-5 py-3 rounded-md bg-blue-600 hover:bg-blue-700 text-white font-semibold disabled:opacity-60"
                disabled={isSubmitting}
              >
                {isSubmitting ? "Wird gesendet..." : "Bestätigen & Absenden"}
              </button>
            </div>
          </div>
        </div>
      )}
    </main>
  );
}