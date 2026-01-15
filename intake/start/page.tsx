import { Suspense } from "react";
import StartClient from "./StartClient";

export const dynamic = "force-dynamic";

export default function Page() {
  return (
    <Suspense
      fallback={
        <main className="min-h-screen flex items-center justify-center p-6">
          <div className="w-full max-w-lg bg-white rounded-xl shadow-lg border border-slate-200 p-8">
            <h1 className="text-xl font-bold text-slate-900 mb-2">Fall laden</h1>
            <p className="text-slate-700">Token wird geprüft...</p>
            <div className="mt-4 text-sm text-slate-500">Bitte warten…</div>
          </div>
        </main>
      }
    >
      <StartClient />
    </Suspense>
  );
}