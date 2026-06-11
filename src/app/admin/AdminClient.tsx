"use client";

import React, { useEffect, useMemo, useState } from "react";
import { QRCodeCanvas } from "qrcode.react";

type Gender = "male" | "female" | "other" | "";

type PatientRow = {
  id: string;
  firstName: string;
  lastName: string;
  birthDate: string; // YYYY-MM-DD
  ahvNumber: string;
  gender: Gender | null;
};

type PatientSearchResponse =
  | { ok: true; results: PatientRow[] }
  | { ok: false; error: string };

type PatientCreateResponse =
  | { ok: true; patient: PatientRow }
  | { ok: false; error: string };

type CaseCreateResponse =
  | { ok: true; caseNumber: string; token: string }
  | { ok: false; error: string };

type CaseResult = {
  caseNumber: string;
  token: string;
  startLink: string;
};

const AHV_REGEX = /^756\.\d{4}\.\d{4}\.\d{2}$/;

function normalizeAhv(raw: string): string {
  const trimmed = (raw ?? "").trim();
  const digits = trimmed.replace(/\D/g, "");
  if (digits.length === 13 && digits.startsWith("756")) {
    return `${digits.slice(0, 3)}.${digits.slice(3, 7)}.${digits.slice(7, 11)}.${digits.slice(11, 13)}`;
  }
  return trimmed;
}

function isISODate(v: string) {
  return /^\d{4}-\d{2}-\d{2}$/.test(v);
}

function getDefaultQrBaseUrl() {
  if (typeof window === "undefined") return "";
  return window.location.origin;
}

export default function AdminClient() {
  // ---------- QR Base URL (für Handy/iPad) ----------
  const [qrBaseUrl, setQrBaseUrl] = useState<string>("");

  useEffect(() => {
    const saved = localStorage.getItem("qrBaseUrl");
    setQrBaseUrl(saved || getDefaultQrBaseUrl());
  }, []);

  useEffect(() => {
    if (qrBaseUrl) localStorage.setItem("qrBaseUrl", qrBaseUrl);
  }, [qrBaseUrl]);

  const effectiveQrBaseUrl = useMemo(() => {
    const base = (qrBaseUrl || "").trim().replace(/\/$/, "");
    return base;
  }, [qrBaseUrl]);

  // ---------- Suche ----------
  const [searchFirstName, setSearchFirstName] = useState("");
  const [searchLastName, setSearchLastName] = useState("");
  const [searchBirthDate, setSearchBirthDate] = useState(""); // YYYY-MM-DD

  const [results, setResults] = useState<PatientRow[]>([]);
  const [selectedPatientId, setSelectedPatientId] = useState<string>("");

  const [isSearching, setIsSearching] = useState(false);
  const [searchMsg, setSearchMsg] = useState<string>("");

  // ---------- Patient erstellen ----------
  const [newFirstName, setNewFirstName] = useState("");
  const [newLastName, setNewLastName] = useState("");
  const [newBirthDate, setNewBirthDate] = useState(""); // YYYY-MM-DD
  const [newAhv, setNewAhv] = useState("");
  const [newGender, setNewGender] = useState<Gender>("");

  const [createCaseAfterCreatePatient, setCreateCaseAfterCreatePatient] = useState(false);
  const [isCreatingPatient, setIsCreatingPatient] = useState(false);

  // ---------- Fall erstellen ----------
  const [isCreatingCase, setIsCreatingCase] = useState(false);
  const [caseResult, setCaseResult] = useState<CaseResult | null>(null);

  const [error, setError] = useState<string>("");

  // ---------- Persist: QR/Fall-Daten NICHT verlieren (Dev-Reload) ----------
  useEffect(() => {
    const raw = sessionStorage.getItem("admin_case_result");
    if (raw) {
      try {
        const parsed = JSON.parse(raw) as CaseResult;
        if (parsed?.token && parsed?.startLink) setCaseResult(parsed);
      } catch {
        // ignore
      }
    }
  }, []);

  useEffect(() => {
    if (caseResult) {
      sessionStorage.setItem("admin_case_result", JSON.stringify(caseResult));
    }
  }, [caseResult]);

  function clearCaseResult() {
    setCaseResult(null);
    sessionStorage.removeItem("admin_case_result");
  }

  async function onSearch(e: React.FormEvent) {
    e.preventDefault();
    setError("");
    setSearchMsg("");
    setCaseResult(null);

    const ln = searchLastName.trim();
    const bd = searchBirthDate.trim();

    if (!ln || !bd) {
      setSearchMsg("Nachname und Geburtsdatum sind erforderlich.");
      return;
    }
    if (!isISODate(bd)) {
      setSearchMsg("Geburtsdatum bitte über Kalender auswählen (YYYY-MM-DD).");
      return;
    }

    setIsSearching(true);
    try {
      const res = await fetch("/api/patient/search", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          firstName: searchFirstName.trim() || undefined,
          lastName: ln,
          birthDate: bd,
        }),
      });

      const json = (await res.json()) as PatientSearchResponse;

      if (!res.ok || json.ok === false) {
        setResults([]);
        setSelectedPatientId("");
        setSearchMsg(json.ok === false ? json.error : "Fehler bei der Suche.");
        return;
      }

      setResults(json.results);
      if (json.results.length === 0) {
        setSelectedPatientId("");
        setSearchMsg("Patient existiert noch nicht im System.");
      } else {
        setSelectedPatientId(json.results[0].id);
        setSearchMsg("");
      }
    } catch (err: unknown) {
      console.error(err);
      setResults([]);
      setSelectedPatientId("");
      setSearchMsg("Netzwerkfehler bei der Suche.");
    } finally {
      setIsSearching(false);
    }
  }

  async function createCase(patientId: string) {
    setError("");
    if (!patientId) {
      setError("Bitte zuerst einen Patienten auswählen.");
      return;
    }
    if (!effectiveQrBaseUrl) {
      setError("Bitte 'QR Base URL' setzen (z.B. http://192.168.1.231:3000).");
      return;
    }

    setIsCreatingCase(true);
    try {
      const res = await fetch("/api/case/create", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ patientId }),
      });

      const json = (await res.json()) as CaseCreateResponse;

      if (!res.ok || json.ok === false) {
        setError(json.ok === false ? json.error : "DB-Fehler bei case/create.");
        return;
      }

      const startLink = `${effectiveQrBaseUrl}/intake/start?token=${encodeURIComponent(json.token)}`;

      setCaseResult({
        caseNumber: json.caseNumber,
        token: json.token,
        startLink,
      });
    } catch (err: unknown) {
      console.error(err);
      setError("Netzwerkfehler bei case/create.");
    } finally {
      setIsCreatingCase(false);
    }
  }

  async function onCreatePatient(e: React.FormEvent) {
    e.preventDefault();
    setError("");

    const fn = newFirstName.trim();
    const ln = newLastName.trim();
    const bd = newBirthDate.trim();
    const ahvNormalized = normalizeAhv(newAhv);

    if (!fn || !ln || !bd || !ahvNormalized) {
      setError("Vorname, Nachname, Geburtsdatum und AHV-Nummer sind erforderlich.");
      return;
    }
    if (!isISODate(bd)) {
      setError("Geburtsdatum bitte über Kalender auswählen (YYYY-MM-DD).");
      return;
    }
    if (!AHV_REGEX.test(ahvNormalized)) {
      setError("AHV-Nummer ist ungültig. Erwartet: 756.XXXX.XXXX.XX (Punkte zwingend).");
      return;
    }

    setIsCreatingPatient(true);
    try {
      const res = await fetch("/api/patient/create", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          firstName: fn,
          lastName: ln,
          birthDate: bd, 
          ahvNumber: ahvNormalized,
          gender: newGender || "",
        }),
      });

      const json = (await res.json()) as PatientCreateResponse;

      if (!res.ok || json.ok === false) {
        setError(json.ok === false ? json.error : "Fehler beim Patient anlegen.");
        return;
      }

      setResults([json.patient]);
      setSelectedPatientId(json.patient.id);

      setSearchFirstName(json.patient.firstName);
      setSearchLastName(json.patient.lastName);
      setSearchBirthDate(json.patient.birthDate);

      if (createCaseAfterCreatePatient) {
        await createCase(json.patient.id);
      }

      setNewFirstName("");
      setNewLastName("");
      setNewBirthDate("");
      setNewAhv("");
      setNewGender("");
      setCreateCaseAfterCreatePatient(false);
    } catch (err: unknown) {
      console.error(err);
      setError("Netzwerkfehler beim Patient anlegen.");
    } finally {
      setIsCreatingPatient(false);
    }
  }

  const selectedPatient = results.find((r) => r.id === selectedPatientId);

  return (
    <div className="w-full space-y-6">
      {/* QR Base URL */}
      <div className="bg-white border border-slate-200 rounded-xl shadow-sm p-6">
        <h2 className="text-lg font-semibold text-slate-900 mb-2">QR Base URL (für Handy/iPad)</h2>
        <p className="text-sm text-slate-600 mb-3">
          Wichtig: Für QR muss hier die <b>IP-Adresse</b> des PCs stehen (nicht localhost), z.B.{" "}
          <code>http://192.168.1.231:3000</code> oder für externe Tests die Ngrok-URL.
        </p>
        <input
          className="input"
          value={qrBaseUrl ?? ""}
          onChange={(e) => setQrBaseUrl(e.target.value)}
          placeholder="z.B. https://abc.ngrok-free.app"
        />
      </div>

      {error && (
        <div className="bg-red-50 border border-red-200 text-red-800 rounded-xl p-4">
          {error}
        </div>
      )}

      {/* Patient suchen */}
      <div className="bg-white border border-slate-200 rounded-xl shadow-sm p-6">
        <h2 className="text-lg font-semibold text-slate-900 mb-4">Patient suchen</h2>

        <form onSubmit={onSearch} className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div>
            <label className="text-sm font-medium text-slate-700">Vorname (optional)</label>
            <input
              className="input"
              value={searchFirstName ?? ""}
              onChange={(e) => setSearchFirstName(e.target.value)}
              placeholder="z.B. Max"
            />
          </div>

          <div>
            <label className="text-sm font-medium text-slate-700">Nachname *</label>
            <input
              className="input"
              value={searchLastName ?? ""}
              onChange={(e) => setSearchLastName(e.target.value)}
              placeholder="z.B. Muster"
              required
            />
          </div>

          <div>
            <label className="text-sm font-medium text-slate-700">Geburtsdatum *</label>
            <input
              className="input"
              type="date"
              value={searchBirthDate ?? ""}
              onChange={(e) => setSearchBirthDate(e.target.value)}
              required
            />
          </div>

          <div className="md:col-span-3">
            <button
              type="submit"
              className="px-6 py-3 rounded-md bg-blue-600 hover:bg-blue-700 text-white font-semibold disabled:opacity-60"
              disabled={isSearching}
            >
              {isSearching ? "Suche..." : "Patient suchen"}
            </button>

            {searchMsg && <div className="mt-3 text-sm text-slate-700">{searchMsg}</div>}
          </div>
        </form>
      </div>

      {/* Suchresultate + Fall */}
      <div className="bg-white border border-slate-200 rounded-xl shadow-sm p-6">
        <h2 className="text-lg font-semibold text-slate-900 mb-4">Suchresultate</h2>

        {results.length === 0 ? (
          <div className="text-sm text-slate-600">Noch keine Resultate (Suche ausführen).</div>
        ) : (
          <>
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="text-left border-b">
                    <th className="py-2 pr-2">Auswahl</th>
                    <th className="py-2 pr-2">Vorname</th>
                    <th className="py-2 pr-2">Nachname</th>
                    <th className="py-2 pr-2">Geburtsdatum</th>
                    <th className="py-2 pr-2">AHV</th>
                    <th className="py-2 pr-2">Gender</th>
                  </tr>
                </thead>
                <tbody>
                  {results.map((r) => (
                    <tr key={r.id} className="border-b">
                      <td className="py-2 pr-2">
                        <input
                          type="radio"
                          name="patient"
                          checked={selectedPatientId === r.id}
                          onChange={() => setSelectedPatientId(r.id)}
                        />
                      </td>
                      <td className="py-2 pr-2">{r.firstName}</td>
                      <td className="py-2 pr-2">{r.lastName}</td>
                      <td className="py-2 pr-2">{r.birthDate}</td>
                      <td className="py-2 pr-2">{r.ahvNumber}</td>
                      <td className="py-2 pr-2">{r.gender || "—"}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            <div className="mt-4 flex items-center gap-4">
              <button
                type="button"
                onClick={() => createCase(selectedPatientId)}
                className="px-6 py-3 rounded-md bg-slate-900 hover:bg-slate-800 text-white font-semibold disabled:opacity-60"
                disabled={isCreatingCase || !selectedPatientId}
              >
                {isCreatingCase ? "Erstelle..." : "Fall erstellen"}
              </button>

              <div className="text-sm text-slate-700">
                Ausgewählt:{" "}
                <b>{selectedPatient ? `${selectedPatient.firstName} ${selectedPatient.lastName}` : "—"}</b>
              </div>
            </div>

            {caseResult && (
              <div className="mt-6 border rounded-xl p-4 bg-slate-50">
                <div className="flex flex-col md:flex-row gap-6 items-start">
                  <div className="flex-1 space-y-2">
                    <h3 className="font-semibold text-slate-900">Fall erstellt</h3>

                    <div className="text-sm">
                      <div className="flex items-center gap-2">
                        <span className="w-28 text-slate-600 shrink-0">Fallnummer:</span>
                        <code className="bg-white border px-2 py-1 rounded">{caseResult.caseNumber}</code>
                      </div>
                      <div className="flex items-center gap-2 mt-2">
                        <span className="w-28 text-slate-600 shrink-0">Token:</span>
                        <code className="bg-white border px-2 py-1 rounded">{caseResult.token}</code>
                      </div>
                      <div className="flex items-center gap-2 mt-2">
                        <span className="w-28 text-slate-600 shrink-0">Start-Link:</span>
                        <a 
                          href={caseResult.startLink}
                          target="_blank" 
                          rel="noopener noreferrer" 
                          className="bg-white border px-2 py-1 rounded break-all text-blue-600 hover:text-blue-800 hover:underline font-medium"
                        >
                          {caseResult.startLink}
                        </a>
                      </div>
                    </div>

                    <button
                      type="button"
                      className="mt-3 px-4 py-2 rounded-md bg-slate-200 hover:bg-slate-300 text-slate-900 font-semibold"
                      onClick={clearCaseResult}
                    >
                      QR/Fall-Anzeige zurücksetzen
                    </button>
                  </div>

                  <div className="shrink-0">
                    <QRCodeCanvas value={caseResult.startLink} size={180} includeMargin />
                    <div className="mt-2 text-xs text-slate-600">
                      QR-Code öffnen → <code>/intake/start?token=…</code>
                    </div>
                  </div>
                </div>
              </div>
            )}
          </>
        )}
      </div>

      {/* Neuen Patienten erfassen */}
      <div className="bg-white border border-slate-200 rounded-xl shadow-sm p-6">
        <h2 className="text-lg font-semibold text-slate-900 mb-4">Neuen Patient erfassen</h2>

        <form onSubmit={onCreatePatient} className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label className="text-sm font-medium text-slate-700">Vorname *</label>
            <input className="input" value={newFirstName ?? ""} onChange={(e) => setNewFirstName(e.target.value)} required />
          </div>
          <div>
            <label className="text-sm font-medium text-slate-700">Nachname *</label>
            <input className="input" value={newLastName ?? ""} onChange={(e) => setNewLastName(e.target.value)} required />
          </div>

          <div>
            <label className="text-sm font-medium text-slate-700">Geburtsdatum *</label>
            <input className="input" type="date" value={newBirthDate ?? ""} onChange={(e) => setNewBirthDate(e.target.value)} required />
          </div>

          <div>
            <label className="text-sm font-medium text-slate-700">AHV-Nummer *</label>
            <input
              className="input"
              value={newAhv ?? ""}
              onChange={(e) => setNewAhv(e.target.value)}
              placeholder="756.XXXX.XXXX.XX"
              required
            />
            <div className="text-xs text-slate-600 mt-1">
              Format: 756.XXXX.XXXX.XX (Punkte zwingend) {AHV_REGEX.test(normalizeAhv(newAhv)) ? "✅ gültig" : ""}
            </div>
          </div>

          <div>
            <label className="text-sm font-medium text-slate-700">Geschlecht (optional)</label>
            <select className="input" value={newGender ?? ""} onChange={(e) => setNewGender(e.target.value as Gender)}>
              <option value="">—</option>
              <option value="male">male</option>
              <option value="female">female</option>
              <option value="other">other</option>
            </select>
          </div>

          <div className="flex items-center gap-2 mt-6">
            <input
              type="checkbox"
              checked={createCaseAfterCreatePatient}
              onChange={(e) => setCreateCaseAfterCreatePatient(e.target.checked)}
            />
            <span className="text-sm text-slate-700">Nach Patient anlegen direkt Fall erstellen</span>
          </div>

          <div className="md:col-span-2">
            <button
              type="submit"
              className="px-6 py-3 rounded-md bg-blue-600 hover:bg-blue-700 text-white font-semibold disabled:opacity-60"
              disabled={isCreatingPatient}
            >
              {isCreatingPatient ? "Erstelle..." : "Patient anlegen"}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}