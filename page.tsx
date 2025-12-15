import Link from "next/link";

export default function HomePage() {
  return (
    <main className="min-h-screen flex items-center justify-center bg-gray-100 p-4">
      <div className="w-full max-w-xl rounded-xl bg-white p-8 shadow-lg text-center">
        <h1 className="text-3xl font-bold mb-4">
          Online Patient-Check-in
        </h1>

        <p className="text-gray-600 mb-8">
          Digitale Notfall-Anmeldung für das Spital Emmental (Burgdorf)
        </p>

        <Link
          href="/intake"
          className="inline-block rounded-lg bg-blue-600 px-6 py-3 text-white font-semibold hover:bg-blue-700 transition"
        >
          Notfall-Anmeldung starten
        </Link>
      </div>
    </main>
  );
}

