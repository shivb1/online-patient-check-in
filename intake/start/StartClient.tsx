"use client";

import { useEffect, useMemo, useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { useIntake, type Gender } from "@/app/context/IntakeContext";

type CaseLookupOk = {
  ok: true;
  caseNumber: string;
  token: string;
  patientId: string;
  patient: {
    firstName: string;
    lastName: string;
    birthDate: string; // YYYY-MM-DD
    ahvNumber: string;
    gender: Gender | "" | null;
  };
};

type CaseLookupErr = { ok: false; error: string };

function toGender(v: unknown): Gender | "" {
  return v === "male" || v === "female" || v === "other" ? v : "";
}

export default function StartClient() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const { updateData, reset } = useIntake();

  const token = useMemo(() => searchParams.get("token") ?? "", [searchParams]);

  const [msg, setMsg] = useState<string>("Lade Fall-Daten...");

  useEffect(() => {
    let cancelled = false;

    async function run() {
      if (!token) {
        setMsg("Kein Token gefunden (QR-Code ungültig).");
        return;
      }

      try {
        // Wichtig: reset, damit kein alter Intake „mitgeschleppt“ wird
        reset();

        const res = await fetch("/api/case/lookup", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ token }),
        });

        const json = (await res.json()) as CaseLookupOk | CaseLookupErr;

        if (cancelled) return;

        if (!res.ok || json.ok === false) {
          setMsg(json.ok === false ? json.error : "Fall nicht gefunden.");
          return;
        }

        // Prefill Stammdaten in IntakeContext
        updateData({
          firstName: json.patient.firstName ?? "",
          lastName: json.patient.lastName ?? "",
          birthDate: json.patient.birthDate ?? "",
          ahvNumber: json.patient.ahvNumber ?? "",
          gender: toGender(json.patient.gender),
          // optional: falls du später beim Submit verknüpfen willst:
          // caseToken: json.token,
          // caseNumber: json.caseNumber,
          // casePatientId: json.patientId,
        });

        router.replace("/intake");
      } catch (err: unknown) {
        console.error(err);
        if (!cancelled) setMsg("Netzwerkfehler beim Laden des Falls.");
      }
    }

    run();
    return () => {
      cancelled = true;
    };
  }, [token, reset, updateData, router]);

  return (
    <main className="min-h-screen flex items-center justify-center p-6">
      <div className="bg-white border border-slate-200 rounded-xl shadow-sm p-6">
        {msg}
      </div>
    </main>
  );
}