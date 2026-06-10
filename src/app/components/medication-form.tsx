"use client";

import React, { useState, useEffect, useRef } from "react";
import { useIntake, YesNo } from "../context/IntakeContext";
import BarcodeScanner from "./barcode-scanner";

function SectionHeader({ title }: { title: string }) {
  return (
    <div className="mt-8 mb-4">
      <div className="bg-slate-700 text-white font-semibold px-4 py-2 rounded-md">
        {title}
      </div>
    </div>
  );
}

function YesNoRow({ label, value, onChange }: { label: string; value?: YesNo; onChange: (v: YesNo) => void; }) {
  const base = "inline-flex items-center gap-2 cursor-pointer select-none";
  const radio = "h-4 w-4 accent-slate-700";
  return (
    <div className="grid grid-cols-12 gap-3 py-3 border-b border-slate-200">
      <div className="col-span-12 md:col-span-8 text-sm text-slate-900">{label}</div>
      <div className="col-span-12 md:col-span-4 flex md:justify-end gap-6">
        <label className={base}>
          <input className={radio} type="radio" checked={value === "yes"} onChange={() => onChange("yes")} />
          <span className="text-sm">ja</span>
        </label>
        <label className={base}>
          <input className={radio} type="radio" checked={value === "no"} onChange={() => onChange("no")} />
          <span className="text-sm">nein</span>
        </label>
      </div>
    </div>
  );
}

interface MedicationResult {
  id: string;
  name: string;
  description?: string;
}

interface SelectedMedication extends MedicationResult {
  category: "regular" | "acute";
}

export default function MedicationForm() {
  const { data, updateData } = useIntake();
  const [isMounted, setIsMounted] = useState(false);

  const [searchTerm, setSearchTerm] = useState("");
  const [searchResults, setSearchResults] = useState<MedicationResult[]>([]);
  const [isSearching, setIsSearching] = useState(false);

  const [showScanner, setShowScanner] = useState(false);
  const [isFetchingBarcode, setIsFetchingBarcode] = useState(false);
  const [isFetchingEmediplan, setIsFetchingEmediplan] = useState(false);

  const [selectedMeds, setSelectedMeds] = useState<SelectedMedication[]>([]);
  const hasRestoredMeds = useRef(false);

  /**
   * INITIALISIERUNG
   */
  useEffect(() => {
    setIsMounted(true);
    if (!hasRestoredMeds.current) {
      const backup = sessionStorage.getItem("medicationListBackup");
      if (backup) {
        try {
          setSelectedMeds(JSON.parse(backup));
        } catch (err) {
          console.error("Fehler beim Wiederherstellen:", err);
        }
      }
      hasRestoredMeds.current = true;
    }
  }, []);

  /**
   * SPEICHERUNG (Sicher gegen den Datenbank 400 Fehler)
   */
  useEffect(() => {
    if (!isMounted) return;
    
    let formattedString = selectedMeds.map((m) => `${m.name} (${m.category === "regular" ? "Dauermedikation" : "Akut"})`).join(", ");
    
    // HARTES LIMIT: Schützt die PostgreSQL Datenbank vor Überlänge (VARCHAR Fehler)
    if (formattedString.length > 200) {
      formattedString = formattedString.substring(0, 197) + "...";
    }

    updateData({ medications: formattedString });
    sessionStorage.setItem("medicationListBackup", JSON.stringify(selectedMeds));
    
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [selectedMeds, isMounted]);

  useEffect(() => {
    let isActive = true;
    if (searchTerm.trim().length < 3) {
      setSearchResults([]);
      return;
    }
    const delayDebounceFn = setTimeout(async () => {
      setIsSearching(true);
      try {
        const res = await fetch(`/api/documedis/search?q=${encodeURIComponent(searchTerm)}`);
        const contentType = res.headers.get("content-type");
        if (!contentType || !contentType.includes("application/json")) throw new Error("Kein JSON");
        if (!res.ok) throw new Error(`Fehler: ${res.status}`);
        
        const apiData: MedicationResult[] = await res.json();
        if (isActive) setSearchResults(apiData);
      } catch (error) {
        if (isActive) setSearchResults([]);
      } finally {
        if (isActive) setIsSearching(false);
      }
    }, 300);

    return () => {
      isActive = false; 
      clearTimeout(delayDebounceFn);
    };
  }, [searchTerm]);

  const addMedication = (med: MedicationResult) => {
    setSelectedMeds((prev) => {
      if (prev.some(m => m.id === med.id)) return prev;
      const defaultCat = (data.regularMedication !== "yes" && data.takenLast7Days === "yes") ? "acute" : "regular";
      return [...prev, { ...med, category: defaultCat }];
    });
    setSearchTerm("");
    setSearchResults([]);
  };

  const addMultipleMedications = (meds: MedicationResult[]) => {
    setSelectedMeds((prev) => {
      const newMeds = meds
        .filter(med => !prev.some(m => m.id === med.id))
        .map(med => {
          const defaultCat = (data.regularMedication !== "yes" && data.takenLast7Days === "yes") ? "acute" : "regular";
          return { ...med, category: defaultCat as "regular" | "acute" };
        });
      return [...prev, ...newMeds];
    });
  };

  const handleBarcodeScanned = async (decodedText: string) => {
    setShowScanner(false);
    setIsFetchingBarcode(true);
    try {
      const res = await fetch(`/api/documedis/barcode?gtin=${decodedText}`);
      const apiData = await res.json();
      if (!res.ok) {
        alert(`Fehler: ${apiData.error || "Medikament nicht gefunden."}`);
        return;
      }
      addMedication({ id: apiData.id, name: apiData.name, description: apiData.description });
    } catch (error) {
      alert("Es gab ein Problem bei der Kommunikation mit dem Server.");
    } finally {
      setIsFetchingBarcode(false);
    }
  };

  const handleEmediplanScanned = async (decodedText: string) => {
    setShowScanner(false);
    setIsFetchingEmediplan(true);
    try {
      const res = await fetch("/api/documedis/emediplan", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ chmedString: decodedText })
      });
      const apiData = await res.json();
      
      if (!res.ok) {
        alert(`Fehler: ${apiData.error || "eMediplan konnte nicht verarbeitet werden."}`);
        return;
      }

      if (apiData.medications && apiData.medications.length > 0) {
        addMultipleMedications(apiData.medications);
      } else {
        alert("Der gescannte eMediplan enthielt keine Medikamente.");
      }
    } catch (error) {
      alert("Es gab ein Problem bei der Kommunikation mit dem Server.");
    } finally {
      setIsFetchingEmediplan(false);
    }
  };

  const handleSmartScan = (decodedText: string) => {
    if (decodedText.startsWith("CHMED")) {
      handleEmediplanScanned(decodedText);
    } else {
      handleBarcodeScanned(decodedText);
    }
  };

  const updateMedCategory = (id: string, newCategory: "regular" | "acute") => {
    setSelectedMeds(prev => prev.map(m => m.id === id ? { ...m, category: newCategory } : m));
  };

  const removeMedication = (id: string) => {
    setSelectedMeds(prev => prev.filter(m => m.id !== id));
  };

  if (!isMounted) return null;

  return (
    <div className="text-slate-900">
      <h1 className="text-xl font-bold mb-1">Medikamenten-Informationen</h1>
      <p className="text-xs text-slate-600 mb-6">Bitte erfassen Sie alle Medikamente, die Sie aktuell einnehmen.</p>

      <YesNoRow label="Nehmen Sie regelmässig Medikamente?" value={data.regularMedication} onChange={(v) => updateData({ regularMedication: v })} />
      <div className="mt-4">
        <YesNoRow label="Haben Sie in den vergangenen 7 Tagen akute Medikamente eingenommen?" value={data.takenLast7Days} onChange={(v) => updateData({ takenLast7Days: v })} />
      </div>

      {(data.regularMedication === "yes" || data.takenLast7Days === "yes") && (
        <div className="mt-6 p-4 bg-slate-50 border border-slate-200 rounded-lg animate-fadeIn">
          <SectionHeader title="MEDIKAMENTE ERFASSEN" />
          
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-4 items-start">
            <div className="col-span-12 lg:col-span-7 relative">
              <label className="block text-xs font-semibold text-slate-700 mb-1">Manuelle Suche (Name eingeben)</label>
              <input type="text" className="w-full bg-white border border-slate-300 rounded-md px-3 py-3 text-sm focus:border-blue-600 outline-none" placeholder="z.B. Dafalgan..." value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} />
              
              {searchResults.length > 0 && (
                <div className="absolute left-0 right-0 mt-1 bg-white border border-slate-200 rounded-md shadow-lg z-50 max-h-[400px] overflow-y-auto">
                  {searchResults.map((med) => (
                    <button key={med.id} type="button" onClick={() => addMedication(med)} className="w-full text-left px-4 py-3 text-sm hover:bg-slate-100 border-b border-slate-100 last:border-none flex justify-between items-center">
                      <span className="font-medium text-slate-900">{med.name}</span>
                      <span className="text-xs text-slate-500">{med.description}</span>
                    </button>
                  ))}
                </div>
              )}
              {isSearching && <div className="absolute right-3 top-10 text-xs text-slate-400">Suche...</div>}
            </div>

            <div className="col-span-12 lg:col-span-5 flex flex-col justify-end">
              <label className="hidden lg:block text-xs font-semibold text-slate-700 mb-1 opacity-0">Kamera</label>
              <button
                type="button"
                onClick={() => setShowScanner(!showScanner)}
                className="w-full px-4 py-3 text-sm font-bold rounded-md bg-blue-600 text-white hover:bg-blue-700 transition flex items-center justify-center gap-2 shadow-sm"
              >
                {showScanner ? "❌ Kamera schliessen" : "📸 Scanner öffnen"}
              </button>
            </div>
          </div>

          {showScanner && (
            <div className="mt-6 border-2 border-dashed border-blue-400 p-4 rounded-xl bg-blue-50 shadow-inner">
              <h3 className="text-sm font-bold text-center mb-1 text-blue-900">
                Code in die Kamera halten
              </h3>
              <p className="text-xs text-center text-blue-700 mb-4">
                Wir erkennen automatisch, ob es ein <strong>eMediplan</strong> oder eine <strong>Medikamentenpackung</strong> ist.
              </p>
              <BarcodeScanner onScanSuccess={handleSmartScan} />
            </div>
          )}

          {isFetchingBarcode && (
             <div className="mt-4 p-3 bg-yellow-50 text-yellow-800 text-sm font-medium rounded-md border border-yellow-200 animate-pulse text-center">
               ⏳ Suche Medikament in der Documedis-Datenbank...
             </div>
           )}

           {isFetchingEmediplan && (
             <div className="mt-4 p-3 bg-green-50 text-green-800 text-sm font-medium rounded-md border border-green-200 animate-pulse text-center">
               ⏳ Entschlüssele eMediplan Daten...
             </div>
           )}

          {selectedMeds.length > 0 && (
            <div className="mt-8">
              <h3 className="text-sm font-bold text-slate-800 mb-3 border-b pb-2">Erfasste Medikamente ({selectedMeds.length})</h3>
              <div className="space-y-3">
                {selectedMeds.map((med) => (
                  <div key={med.id} className="flex flex-col sm:flex-row sm:justify-between sm:items-center bg-white border border-slate-200 px-4 py-3 rounded-lg shadow-sm gap-3">
                    <div className="flex-1">
                      <span className="text-sm font-bold text-slate-900 block">{med.name}</span>
                      <span className="text-xs text-slate-500 mt-1 truncate max-w-[250px] md:max-w-md block">{med.description || "Strukturiert erfasst"}</span>
                    </div>
                    <div className="flex items-center gap-3">
                      <select value={med.category} onChange={(e) => updateMedCategory(med.id, e.target.value as "regular" | "acute")} className="text-xs font-medium border border-slate-300 rounded px-2 py-2 bg-slate-50 text-slate-700 outline-none focus:border-blue-500">
                        <option value="regular">Dauermedikation</option>
                        <option value="acute">Akut (letzte 7 Tage)</option>
                      </select>
                      <button type="button" onClick={() => removeMedication(med.id)} className="text-xs text-red-600 hover:text-white font-bold px-3 py-2 rounded border border-red-200 hover:bg-red-600 transition-colors">Entfernen</button>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  );
}