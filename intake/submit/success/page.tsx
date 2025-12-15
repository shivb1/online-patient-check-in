export default function SubmitSuccessPage() {
  return (
    <main className="min-h-screen bg-gray-900 flex items-center justify-center">
      <div className="bg-black text-white p-8 rounded-xl max-w-md text-center space-y-6">
        <h1 className="text-2xl font-bold">Anmeldung abgeschlossen</h1>

        <p>
          Vielen Dank. Ihre Angaben wurden erfolgreich übermittelt.
        </p>

        <p className="text-sm text-gray-400">
          Bitte melden Sie sich beim Empfang oder warten Sie auf weitere Anweisungen.
        </p>
      </div>
    </main>
  );
}
