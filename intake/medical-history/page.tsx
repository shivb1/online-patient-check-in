"use client";

import { useRouter } from "next/navigation";
import MedicalHistoryForm from "../../components/medical-history-form";

export default function MedicalHistoryPage() {
  const router = useRouter();

  return (
    <main className="min-h-screen bg-slate-200 flex items-center justify-center p-6">
      <div className="w-full max-w-4xl bg-white rounded-lg shadow-xl border border-slate-300">
        <div className="p-8">
          <MedicalHistoryForm />
        </div>

        <div className="px-8 pb-8 pt-4 flex justify-between">
          <button
            onClick={() => router.back()}
            className="px-6 py-3 rounded-md bg-slate-300 hover:bg-slate-400 text-slate-900 font-semibold"
          >
            Zurück
          </button>

          <button
            onClick={() => router.push("/intake/review")}
            className="px-6 py-3 rounded-md bg-blue-600 hover:bg-blue-700 text-white font-semibold"
          >
            Weiter
          </button>
        </div>
      </div>
    </main>
  );
}
