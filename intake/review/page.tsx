"use client";

import { useRouter } from "next/navigation";
import { useIntake } from "@/app/context/IntakeContext";

import { ReviewRow } from "@/app/components/review/ReviewRow";
import { ReviewSection } from "@/app/components/review/ReviewSection";
import { YesNoText } from "@/app/components/review/YesNoText";

export default function ReviewPage() {
  const { data } = useIntake();
  const router = useRouter();

  async function handleSubmit() {
  try {
    const res = await fetch("/intake/submit", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(data),
    });

    if (!res.ok) {
      throw new Error("Fehler beim Absenden");
    }

    router.push("/intake/submit/success");
  } catch (err) {
    alert("Fehler beim Speichern der Anmeldung");
    console.error(err);
  }
}
  return (
    <main className="min-h-screen bg-gray-900 flex justify-center py-10">
      <div className="w-full max-w-3xl bg-black rounded-xl p-6 text-white">

        <h1 className="text-xl font-bold mb-6">Überprüfung Ihrer Angaben</h1>

        {/* ================= Patientendaten ================= */}
        <ReviewSection title="Patientendaten">
          <ReviewRow label="Vorname" value={data.firstName} />
          <ReviewRow label="Nachname" value={data.lastName} />
          <ReviewRow label="Geburtsdatum" value={data.birthDate} />
          <ReviewRow label="AHV-Nummer" value={data.ahvNumber} />
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
          <ReviewRow label="Im Spital (12 Monate)" value={<YesNoText value={data.hospitalized} />} />
          <ReviewRow label="Hausarzt regelmässig" value={<YesNoText value={data.regularGP} />} />
          <ReviewRow label="Regelmässige Medikamente" value={<YesNoText value={data.regularMedication} />} />

          {data.medications && (
            <ReviewRow label="Medikamente" value={data.medications} />
          )}

          <ReviewRow label="Allergien" value={<YesNoText value={data.allergiesFlag} />} />
          {data.allergies && (
            <ReviewRow label="Welche Allergien" value={data.allergies} />
          )}
        </ReviewSection>

        {/* ================= Herz-Kreislauf ================= */}
        <ReviewSection title="Herz-Kreislauf">
          <ReviewRow label="Blutdruckprobleme" value={<YesNoText value={data.bloodPressure} />} />
          <ReviewRow label="Schmerzen/Atemnot bei Belastung" value={<YesNoText value={data.exertionPainBreath} />} />
          <ReviewRow label="Unregelmässiger Puls" value={<YesNoText value={data.irregularPulse} />} />
          <ReviewRow label="Geschwollene Beine/Füsse" value={<YesNoText value={data.swollenLegs} />} />
        </ReviewSection>

        {/* ================= Lunge ================= */}
        <ReviewSection title="Lunge">
          <ReviewRow label="Raucher/in" value={<YesNoText value={data.smoker} />} />
          <ReviewRow label="Luftnot bei Belastung" value={<YesNoText value={data.dyspnea} />} />
          <ReviewRow label="Asthma" value={<YesNoText value={data.asthma} />} />
        </ReviewSection>

        {/* ================= Körperdaten ================= */}
        <ReviewSection title="Körperdaten">
          <ReviewRow label="Gewicht" value={data.weight ? `${data.weight} kg` : "—"} />
          <ReviewRow label="Grösse" value={data.height ? `${data.height} cm` : "—"} />
        </ReviewSection>

        {/* ================= Aktionen ================= */}
        <div className="flex justify-between pt-8">
          <button
            onClick={() => router.back()}
            className="px-6 py-3 rounded-md bg-gray-700 hover:bg-gray-600"
          >
            Zurück
          </button>

          <button
            onClick={handleSubmit}
            className="px-6 py-3 rounded-md bg-blue-600 hover:bg-blue-500"
>
              Anmeldung abschliessen
          </button>
        </div>
      </div>
    </main>
  );
}