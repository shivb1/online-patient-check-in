export default function SubmitSuccessPage() {
  return (
    <main className="min-h-screen flex items-center justify-center p-6">
      <div className="w-full max-w-lg bg-white rounded-xl shadow-lg border border-slate-200 p-10 text-center">
        <h1 className="text-2xl font-bold text-slate-900">
          Anmeldung abgeschlossen
        </h1>

        <p className="mt-4 text-slate-800">
          Vielen Dank. Ihre Angaben wurden erfolgreich übermittelt.
        </p>

        <p className="mt-2 text-slate-600">
          Bitte melden Sie sich beim Empfang oder warten Sie auf weitere
          Anweisungen.
        </p>
      </div>
    </main>
  );
}
