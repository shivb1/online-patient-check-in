"use client";

import { useRouter } from "next/navigation";
import { useIntake } from "../context/IntakeContext";

export default function IntakeForm() {
  const router = useRouter();
  const { data, updateData } = useIntake();

  function handleChange(
    e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
  ) {
    const { name, value, type, checked } = e.target as HTMLInputElement;

    updateData({
      [name]: type === "checkbox" ? checked : value,
    });
  }

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault();

    // ⬇️ nur weiter, NICHT speichern
    router.push("/intake/medical-history");
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      <section>
        <h2 className="text-lg font-semibold">Patientendaten</h2>

        <input
          name="firstName"
          value={data.firstName ?? ""}
          onChange={handleChange}
          placeholder="Vorname *"
          required
          className="input"
        />

        <input
          name="lastName"
          value={data.lastName ?? ""}
          onChange={handleChange}
          placeholder="Nachname *"
          required
          className="input"
        />

        <input
          type="date"
          name="birthDate"
          value={data.birthDate ?? ""}
          onChange={handleChange}
          required
          className="input"
        />

        <input
          name="ahvNumber"
          value={data.ahvNumber ?? ""}
          onChange={handleChange}
          placeholder="AHV-Nummer *"
          required
          className="input"
        />
      </section>

      <section>
        <h2 className="text-lg font-semibold">Kontakt</h2>

        <input
          name="address"
          value={data.address ?? ""}
          onChange={handleChange}
          placeholder="Adresse *"
          required
          className="input"
        />

        <input
          name="zip"
          value={data.zip ?? ""}
          onChange={handleChange}
          placeholder="PLZ *"
          required
          className="input"
        />

        <input
          name="city"
          value={data.city ?? ""}
          onChange={handleChange}
          placeholder="Ort *"
          required
          className="input"
        />

        <input
          name="phone"
          value={data.phone ?? ""}
          onChange={handleChange}
          placeholder="Telefon *"
          required
          className="input"
        />

        <input
          name="phonePrivate"
          value={data.phonePrivate ?? ""}
          onChange={handleChange}
          placeholder="Telefon privat (optional)"
          className="input"
        />

        <input
          type="email"
          name="email"
          value={data.email ?? ""}
          onChange={handleChange}
          placeholder="E-Mail *"
          required
          className="input"
        />
      </section>

      <button
        type="submit"
        className="w-full bg-blue-600 text-white py-4 rounded-xl text-lg"
      >
        Weiter zur medizinischen Anamnese
      </button>
    </form>
  );
}
