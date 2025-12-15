import IntakeForm from "../components/intake-form";

export default function IntakePage() {
  return (
    <main className="min-h-screen bg-gray-100 p-4 flex items-center justify-center">
      <div className="w-full max-w-2xl bg-white rounded-xl shadow-lg p-8">
        <h1 className="text-2xl font-bold mb-6">
          Notfall-Anmeldung
        </h1>

        <IntakeForm />
      </div>
    </main>
  );
}
