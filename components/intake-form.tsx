"use client";

import React from "react";
import { useRouter } from "next/navigation";
import { useIntake, type IntakeData, type Gender } from "../context/IntakeContext";

function todayZurichISO(): string {
  // Liefert YYYY-MM-DD in der Zeitzone Europe/Zurich (auch wenn Gerät mal falsch eingestellt wäre)
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "Europe/Zurich",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).format(new Date());
}

function GenderButton({
  label,
  value,
  selected,
  onClick,
}: {
  label: string;
  value: Gender;
  selected: boolean;
  onClick: () => void;
}) {
  return (
    <button
      type="button"
      onClick={onClick}
      className={[
        "px-4 py-2 rounded-md border text-sm font-medium",
        selected
          ? "bg-blue-600 border-blue-600 text-white"
          : "bg-white border-gray-300 text-gray-900 hover:bg-gray-50",
      ].join(" ")}
      aria-pressed={selected}
    >
      {label}
    </button>
  );
}

export default function IntakeForm() {
  const router = useRouter();
  const { data, updateData } = useIntake();

  const maxBirthDate = todayZurichISO(); // heute (CH), als YYYY-MM-DD

  function handleChange(e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) {
    const target = e.target as HTMLInputElement;
    const name = target.name as keyof IntakeData;
    const value = target.value;

    // Extra: Birthdate darf nicht in der Zukunft sein
    if (name === "birthDate") {
      if (value && value > maxBirthDate) {
        // Du kannst auch stattdessen alert + return machen
        updateData({ birthDate: maxBirthDate });
        return;
      }
    }

    updateData({ [name]: value } as Partial<IntakeData>);
  }

  function setGender(g: Gender) {
    updateData({ gender: g });
  }

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault();

    // Zusätzliche Sicherheitsprüfung (falls Browser max ignoriert)
    if (data.birthDate && data.birthDate > maxBirthDate) {
      alert("Geburtsdatum darf nicht in der Zukunft liegen.");
      updateData({ birthDate: "" });
      return;
    }

    router.push("/intake/medical-history");
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      <section className="space-y-3">
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

        {/* Gender Auswahl */}
        <div className="space-y-2">
          <div className="text-sm font-medium text-gray-200">Geschlecht (optional)</div>
          <div className="flex gap-2">
            <GenderButton
              label="Männlich"
              value="male"
              selected={data.gender === "male"}
              onClick={() => setGender("male")}
            />
            <GenderButton
              label="Weiblich"
              value="female"
              selected={data.gender === "female"}
              onClick={() => setGender("female")}
            />
            <GenderButton
              label="Andere"
              value="other"
              selected={data.gender === "other"}
              onClick={() => setGender("other")}
            />
          </div>
        </div>

        <input
          type="date"
          name="birthDate"
          value={data.birthDate ?? ""}
          onChange={handleChange}
          required
          className="input"
          min="1900-01-01"
          max={maxBirthDate}
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

      <section className="space-y-3">
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

      <section>
        <h2 className="text-lg font-semibold">Notfallkontakt (optional)</h2>

        <input
          name="emergencyFirstName"
          value={data.emergencyFirstName ?? ""}
          onChange={handleChange}
          placeholder="Vorname Notfallkontakt"
          className="input"
        />

        <input
          name="emergencyLastName"
          value={data.emergencyLastName ?? ""}
          onChange={handleChange}
          placeholder="Nachname Notfallkontakt"
          className="input"
        />

        <input
          name="emergencyAddress"
          value={data.emergencyAddress ?? ""}
          onChange={handleChange}
          placeholder="Adresse Notfallkontakt"
          className="input"
        />

        <input
          name="emergencyPhone"
          value={data.emergencyPhone ?? ""}
          onChange={handleChange}
          placeholder="Telefon Notfallkontakt"
          className="input"
        />
      </section>

      <button type="submit" className="w-full bg-blue-600 text-white py-4 rounded-xl text-lg">
        Weiter zur medizinischen Anamnese
      </button>
    </form>
  );
}