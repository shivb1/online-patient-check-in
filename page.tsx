import Link from "next/link";

export default function HomePage() {
  return (
    <main className="min-h-screen flex items-center justify-center p-6">
      <div className="w-full max-w-2xl bg-white rounded-xl shadow-lg border border-slate-200 p-10">
        <div className="text-center">
          <h1 className="text-3xl font-bold text-slate-900">
            Online Patient-Check-in
          </h1>

          <p className="mt-2 text-slate-700">
            Digitale Notfall-Anmeldung für das Spital Emmental (Burgdorf)
          </p>

          <div className="mt-8 flex justify-center">
            <Link
              href="/intake"
              className="px-6 py-3 rounded-lg bg-blue-600 hover:bg-blue-700 text-white font-semibold"
            >
              Notfall-Anmeldung starten
            </Link>
          </div>
        </div>
      </div>
    </main>
  );
}