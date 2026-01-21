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

const AHV_REGEX = /^756\.\d{4}\.\d{4}\.\d{2}$/;

function normalizeAhv(raw: string): string {
  const trimmed = (raw ?? "").trim();

  // Alles ausser Ziffern entfernen
  const digits = trimmed.replace(/\D/g, "");

  // Erwartung: 13 Ziffern, beginnt mit 756
  if (digits.length === 13 && digits.startsWith("756")) {
    return `${digits.slice(0, 3)}.${digits.slice(3, 7)}.${digits.slice(7, 11)}.${digits.slice(11, 13)}`;
  }

  return trimmed;
}

// Erlaubte CH Mobile/Telefon Formate:
// - 0XX XXX XX XX  (z.B. 079 797 79 79)
// - +41 XX XXX XX XX (z.B. +41 79 797 79 79)
// Whitespace / Bindestrich / Klammern sind egal.
// erlaubt: 079..., +4179..., 004179...  (jeweils mit/ohne Leerzeichen/Binde/() weil wir normalisieren)
const PHONE_REGEX = /^(?:0\d{2}|\+41\d{2}|0041\d{2})\d{7}$/;


function normalizePhone(raw: string): string {
  const trimmed = (raw ?? "").trim();

  // Alles ausser Ziffern und + entfernen
  // (wir erlauben + nur am Anfang)
  let cleaned = trimmed.replace(/[^\d+]/g, "");

  // 0041... -> +41...
  if (cleaned.startsWith("0041")) cleaned = "+41" + cleaned.slice(4);

  // wenn + vorkommt, nur vorne erlauben
  if (cleaned.includes("+") && !cleaned.startsWith("+")) {
    cleaned = cleaned.replace(/\+/g, "");
  }

  return cleaned;
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

        // AHV: automatisch formatieren + Browser-Validation Message setzen
    if (name === "ahvNumber") {
      const formatted = normalizeAhv(value);

      // Custom validity: erst leer lassen oder gültig -> ok, sonst Fehlermeldung
      if (formatted === "" || AHV_REGEX.test(formatted)) {
        target.setCustomValidity("");
      } else {
        target.setCustomValidity("AHV-Nummer muss im Format 756.XXXX.XXXX.XX sein.");
      }

      updateData({ ahvNumber: formatted });
      return;
    }

        // Telefon: normalisieren + validieren (primary + notfall)
    if (name === "phone" || name === "phonePrivate" || name === "emergencyPhone") {
      
      const normalized = normalizePhone(value);

      if (normalized === "" && (name === "phonePrivate" || name === "emergencyPhone")) {
        // optional -> ok wenn leer
        target.setCustomValidity("");
      } else if (PHONE_REGEX.test(normalized)) {
        target.setCustomValidity("");
      } else {
        target.setCustomValidity(
          "Telefon muss im Format 079 101 10 01, +41 79 101 10 01 oder 0041 79 101 10 01 sein."
        );
      }


      updateData({ [name]: normalized } as Partial<IntakeData>);
      return;
    }


    updateData({ [name]: value } as Partial<IntakeData>);
  }

  function setGender(g: Gender) {
    updateData({ gender: g });
  }

  function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
  e.preventDefault();

  // ✅ Browser-Validierung aktiv nutzen (required/pattern/type=email/etc.)
  const form = e.currentTarget;
  if (!form.checkValidity()) {
    form.reportValidity();
    return;
  }

  // Zusätzliche Sicherheitsprüfung (falls Browser max ignoriert)
  if (data.birthDate && data.birthDate > maxBirthDate) {
    alert("Geburtsdatum darf nicht in der Zukunft liegen.");
    updateData({ birthDate: "" });
    return;
  }

  // Extra Sicherheit: AHV nochmals prüfen (falls irgendwas schief ging)
  if (!AHV_REGEX.test((data.ahvNumber ?? "").trim())) {
    alert("Bitte eine gültige AHV-Nummer eingeben: 756.XXXX.XXXX.XX");
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
          placeholder="AHV-Nummer * (756.XXXX.XXXX.XX)"
          required
          pattern="^756\.\d{4}\.\d{4}\.\d{2}$"
          title="Format: 756.XXXX.XXXX.XX"
          inputMode="numeric"
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
          placeholder="Telefon * (079 123 45 45 oder +41 79 123 45 45)"
          required
          pattern="^(?:0\d{2}|\+41\d{2})\d{7}$"
          title="Format: 079 123 45 45 oder +41 79 123 45 45"
          inputMode="tel"
          className="input"
        />


       <input
          name="phonePrivate"
          value={data.phonePrivate ?? ""}
          onChange={handleChange}
          placeholder="Telefon privat (optional) z.B. +41 79 101 10 01"
          pattern="^(?:0\d{2}|\+41\d{2}|0041\d{2})\d{7}$"
          title="Format: 079 101 10 01 oder +41 79 101 10 01 oder 0041 79 101 10 01"
          inputMode="tel"
          className="input"
        />


        <input
          type="email"
          name="email"
          value={data.email ?? ""}
          onChange={handleChange}
          placeholder="E-Mail "
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
          placeholder="Telefon Notfallkontakt (optional)"
          pattern="^(?:0\d{2}|\+41\d{2})\d{7}$"
          title="Format: 079 123 45 45 oder +41 79 123 45 45"
          inputMode="tel"
          className="input"
        />

      </section>

      <button type="submit" className="w-full bg-blue-600 text-white py-4 rounded-xl text-lg">
        Weiter zur medizinischen Anamnese
      </button>
    </form>
  );
}