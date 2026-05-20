"use client";

import React from "react";
import { useRouter } from "next/navigation";
import MedicationForm from "../../components/medication-form";

/**
 * Page-Komponente für den Medikamenten-Schritt im Check-in Prozess.
 * Dient als Wrapper für die MedicationForm und verwaltet die Navigation
 * zur nächsten Seite (Review).
 */
export default function MedicationPage() {
  const router = useRouter();

  /**
   * Verarbeitet das Absenden des Formulars.
   * Prüft die nativen HTML5-Validierungsregeln des Browsers und
   * leitet bei Erfolg zur Review-Seite weiter.
   * * @param {React.FormEvent<HTMLFormElement>} e - Das Submit-Event des Formulars.
   */
  function handleNext(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    const form = e.currentTarget;

    // Löst die native Browser-Validation aus (für ggf. vorhandene 'required' Felder)
    if (!form.checkValidity()) {
      form.reportValidity();
      return;
    }

    // Leitet nach erfolgreicher Eingabe zur finalen Überprüfung weiter
    router.push("/intake/review");
  }

  return (
    <main className="min-h-screen bg-slate-200 flex items-center justify-center p-6">
      <div className="w-full max-w-4xl bg-white rounded-lg shadow-xl border border-slate-300">
        <form onSubmit={handleNext}>
          <div className="p-8">
            <MedicationForm />
          </div>

          <div className="px-8 pb-8 pt-4 flex justify-between">
            {/* Button zur Navigation auf die vorherige Seite (Allgemeine Krankengeschichte) */}
            <button
              type="button"
              onClick={() => router.back()}
              className="px-6 py-3 rounded-md bg-slate-300 hover:bg-slate-400 text-slate-900 font-semibold"
            >
              Zurück
            </button>

            {/* Submit-Button löst die handleNext Funktion aus */}
            <button
              type="submit"
              className="px-6 py-3 rounded-md bg-blue-600 hover:bg-blue-700 text-white font-semibold"
            >
              Weiter zur Überprüfung
            </button>
          </div>
        </form>
      </div>
    </main>
  );
}