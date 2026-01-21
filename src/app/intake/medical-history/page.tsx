"use client";

import React from "react";
import { useRouter } from "next/navigation";
import MedicalHistoryForm from "../../components/medical-history-form";

export default function MedicalHistoryPage() {
  const router = useRouter();

  function handleNext(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();

    const form = e.currentTarget;

    // ✅ Browser-Validation (required/min/max/pattern) auslösen
    if (!form.checkValidity()) {
      form.reportValidity();
      return;
    }

    router.push("/intake/review");
  }

  return (
    <main className="min-h-screen bg-slate-200 flex items-center justify-center p-6">
      <div className="w-full max-w-4xl bg-white rounded-lg shadow-xl border border-slate-300">
        {/* ✅ Form wrapper, damit required/min/max greift */}
        <form onSubmit={handleNext}>
          <div className="p-8">
            <MedicalHistoryForm />
          </div>

          <div className="px-8 pb-8 pt-4 flex justify-between">
            <button
              type="button"
              onClick={() => router.back()}
              className="px-6 py-3 rounded-md bg-slate-300 hover:bg-slate-400 text-slate-900 font-semibold"
            >
              Zurück
            </button>

            <button
              type="submit"
              className="px-6 py-3 rounded-md bg-blue-600 hover:bg-blue-700 text-white font-semibold"
            >
              Weiter
            </button>
          </div>
        </form>
      </div>
    </main>
  );
}