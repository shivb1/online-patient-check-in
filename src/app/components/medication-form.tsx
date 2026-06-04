"use client";

import React, { useState, useEffect } from "react";
import { useIntake, YesNo } from "../context/IntakeContext";
import BarcodeScanner from "./barcode-scanner";

/**
 * UI-Komponente für Sektions-Überschriften.
 * @param {Object} props - Die Eigenschaften der Komponente.
 * @param {string} props.title - Der Titel, der angezeigt werden soll.
 */
function SectionHeader({ title }: { title: string }) {
  return (
    <div className="mt-8 mb-4">
      <div className="bg-slate-700 text-white font-semibold px-4 py-2 rounded-md">
        {title}
      </div>
    </div>
  );
}

/**
 * UI-Komponente für eine Ja/Nein Auswahl mittels Radio-Buttons.
 * @param {Object} props - Die Eigenschaften der Komponente.
 * @param {string} props.label - Die Frage oder Beschriftung.
 * @param {YesNo} [props.value] - Der aktuell ausgewählte Wert ("yes" oder "no").
 * @param {(v: YesNo) => void} props.onChange - Callback-Funktion bei Wertänderung.
 */
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

/**
 * Interface für ein von der API zurückgegebenes Medikament.
 */
interface MedicationResult {
  id: string;
  name: string;
  description?: string;
}

/**
 * Interface für ein ausgewähltes Medikament inklusive Zuweisung (Dauer- oder Akutmedikation).
 */
interface SelectedMedication extends MedicationResult {
  category: "regular" | "acute";
}

/**
 * Hauptkomponente zur Erfassung der Medikation (manuelle Suche, GTIN-Scan und eMediplan-Scan).
 */
export default function MedicationForm() {
  const { data, updateData } = useIntake();
  const [isMounted, setIsMounted] = useState(false);

  // States für die Text-Suche
  const [searchTerm, setSearchTerm] = useState("");
  const [searchResults, setSearchResults] = useState<MedicationResult[]>([]);
  const [isSearching, setIsSearching] = useState(false);

  // States für den GTIN-Scanner (einzelne Medikamente)
  const [showScanner, setShowScanner] = useState(false);
  const [isFetchingBarcode, setIsFetchingBarcode] = useState(false);

  // States für den eMediplan-Scanner (CHMED-String)
  const [showEmediplanScanner, setShowEmediplanScanner] = useState(false);
  const [isFetchingEmediplan, setIsFetchingEmediplan] = useState(false);

  const [selectedMeds, setSelectedMeds] = useState<SelectedMedication[]>([]);

  useEffect(() => {
    setIsMounted(true);
  }, []);

  /**
   * Synchronisiert die lokale Liste der ausgewählten Medikamente mit dem globalen Kontext.
   * @param {SelectedMedication[]} meds - Die aktuelle Liste der ausgewählten Medikamente.
   */
  const syncContext = (meds: SelectedMedication[]) => {
    const formattedString = meds.map((m) => {
      const catText = m.category === "regular" ? "Dauermedikation" : "Akut";
      return `${m.name} (${catText})`;
    }).join(", ");
    updateData({ medications: formattedString });
  };

  /**
   * Effekt-Hook für die Debounced-Textsuche bei Documedis.
   * Feuert erst, wenn der Benutzer aufhört zu tippen (300ms Verzögerung).
   */
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
        
        if (isActive) {
          setSearchResults(apiData);
        }
      } catch (error) {
        if (isActive) {
          setSearchResults([]);
        }
      } finally {
        if (isActive) {
          setIsSearching(false);
        }
      }
    }, 300);

    return () => {
      isActive = false; 
      clearTimeout(delayDebounceFn);
    };
  }, [searchTerm]);

  /**
   * Fügt ein gefundenes Medikament der lokalen Liste hinzu.
   * @param {MedicationResult} med - Das hinzuzufügende Medikament.
   */
  const addMedication = (med: MedicationResult) => {
    if (!selectedMeds.some(m => m.id === med.id)) {
      const defaultCat = (data.regularMedication !== "yes" && data.takenLast7Days === "yes") ? "acute" : "regular";
      const newMed: SelectedMedication = { ...med, category: defaultCat };
      const updated = [...selectedMeds, newMed];
      setSelectedMeds(updated);
      syncContext(updated);
    }
    setSearchTerm("");
    setSearchResults([]);
  };

  /**
   * Verarbeitet den Text (GTIN), der vom Barcode-Scanner (einzelne Medikamente) erfasst wurde.
   * @param {string} decodedText - Der gescannte Barcode-String.
   */
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

      addMedication({
        id: apiData.id,
        name: apiData.name,
        description: apiData.description,
      });

    } catch (error) {
      alert("Es gab ein Problem bei der Kommunikation mit dem Server.");
    } finally {
      setIsFetchingBarcode(false);
    }
  };

/**
   * Verarbeitet den Text (CHMED-String), der vom eMediplan-Scanner erfasst wurde.
   * @param {string} decodedText - Der rohe eMediplan-String.
   */
  const handleEmediplanScanned = async (decodedText: string) => {
    setShowEmediplanScanner(false);
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

      // Gehe durch alle Medikamente, die der eMediplan enthalten hat, 
      // und füge sie nacheinander unserer Liste hinzu
      if (apiData.medications && apiData.medications.length > 0) {
        apiData.medications.forEach((med: MedicationResult) => {
          addMedication({
            id: med.id,
            name: med.name,
            description: med.description,
          });
        });
        alert(`${apiData.medications.length} Medikamente aus dem eMediplan erfolgreich importiert!`);
      } else {
        alert("Der gescannte eMediplan enthielt keine Medikamente.");
      }

    } catch (error) {
      alert("Es gab ein Problem bei der Kommunikation mit dem Server.");
    } finally {
      setIsFetchingEmediplan(false);
    }
  };

  /**
   * Aktualisiert die Kategorie (Akut/Dauer) eines bereits erfassten Medikaments.
   * @param {string} id - Die ID des Medikaments.
   * @param {"regular" | "acute"} newCategory - Die neu gewählte Kategorie.
   */
  const updateMedCategory = (id: string, newCategory: "regular" | "acute") => {
    const updated = selectedMeds.map(m => m.id === id ? { ...m, category: newCategory } : m);
    setSelectedMeds(updated);
    syncContext(updated);
  };

  /**
   * Entfernt ein Medikament aus der lokalen Liste.
   * @param {string} id - Die ID des zu entfernenden Medikaments.
   */
  const removeMedication = (id: string) => {
    const updated = selectedMeds.filter(m => m.id !== id);
    setSelectedMeds(updated);
    syncContext(updated);
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
          
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-3 items-start">
            {/* Textsuche */}
            <div className="col-span-12 lg:col-span-6 relative">
              <label className="block text-xs font-semibold text-slate-700 mb-1">Name des Medikaments eingeben</label>
              <input type="text" className="w-full bg-white border border-slate-300 rounded-md px-3 py-2 text-sm focus:border-slate-700 outline-none" placeholder="z.B. Dafalgan..." value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} />
              
              {searchResults.length > 0 && (
                <div className="absolute left-0 right-0 mt-1 bg-white border border-slate-200 rounded-md shadow-lg z-50 max-h-[400px] overflow-y-auto">
                  {searchResults.map((med) => (
                    <button key={med.id} type="button" onClick={() => addMedication(med)} className="w-full text-left px-4 py-2 text-sm hover:bg-slate-100 border-b border-slate-100 last:border-none flex justify-between items-center">
                      <span className="font-medium text-slate-900">{med.name}</span>
                      <span className="text-xs text-slate-500">{med.description}</span>
                    </button>
                  ))}
                </div>
              )}
              {isSearching && <div className="absolute right-3 top-8 text-xs text-slate-400">Suche...</div>}
            </div>

            {/* Scan Buttons */}
            <div className="col-span-12 lg:col-span-6 grid grid-cols-2 gap-2 lg:mt-5">
              <button
                type="button"
                onClick={() => {
                  setShowScanner(!showScanner);
                  setShowEmediplanScanner(false);
                }}
                className="px-3 py-2 text-xs md:text-sm font-semibold rounded-md bg-slate-800 text-white hover:bg-slate-900 transition flex items-center justify-center gap-1 h-[38px]"
              >
                {showScanner ? "❌ Scanner schliessen" : "📸 Einzel-Medikament scannen"}
              </button>
              <button
                type="button"
                onClick={() => {
                  setShowEmediplanScanner(!showEmediplanScanner);
                  setShowScanner(false);
                }}
                className="px-3 py-2 text-xs md:text-sm font-semibold rounded-md bg-blue-600 text-white hover:bg-blue-700 transition flex items-center justify-center gap-1 h-[38px]"
              >
                {showEmediplanScanner ? "❌ Scanner schliessen" : "📋 eMediplan scannen"}
              </button>
            </div>
          </div>

          {/* GTIN Scanner UI --- */}
          {showScanner && (
            <div className="mt-4 border-2 border-dashed border-blue-300 p-2 rounded-lg bg-blue-50">
              <h3 className="text-sm font-semibold text-center mb-2">Strichcode auf der Verpackung scannen</h3>
              <BarcodeScanner onScanSuccess={handleBarcodeScanned} />
            </div>
          )}

          {/* eMediplan Scanner UI --- */}
          {showEmediplanScanner && (
            <div className="mt-4 border-2 border-dashed border-green-300 p-2 rounded-lg bg-green-50">
              <h3 className="text-sm font-semibold text-center mb-2">2D-Code des eMediplans scannen</h3>
              <BarcodeScanner onScanSuccess={handleEmediplanScanned} />
            </div>
          )}

          {isFetchingBarcode && (
            <div className="mt-4 p-3 bg-yellow-50 text-yellow-800 text-sm rounded border border-yellow-200 animate-pulse text-center">
              ⏳ Suche Medikament in der Documedis-Datenbank...
            </div>
          )}

          {isFetchingEmediplan && (
            <div className="mt-4 p-3 bg-yellow-50 text-yellow-800 text-sm rounded border border-yellow-200 animate-pulse text-center">
              ⏳ Verarbeite eMediplan Daten...
            </div>
          )}

          {/* Erfasste Medikamente */}
          {selectedMeds.length > 0 && (
            <div className="mt-6">
              <h3 className="text-sm font-semibold text-slate-800 mb-2">Erfasste Medikamente:</h3>
              <div className="space-y-3">
                {selectedMeds.map((med) => (
                  <div key={med.id} className="flex flex-col sm:flex-row sm:justify-between sm:items-center bg-white border border-slate-200 px-3 py-3 rounded-md shadow-sm gap-3">
                    <div className="flex-1">
                      <span className="text-sm font-medium text-slate-900 block">{med.name}</span>
                      <span className="text-xs text-slate-500">{med.description || "Strukturiert erfasst"}</span>
                    </div>
                    <div className="flex items-center gap-3">
                      <select value={med.category} onChange={(e) => updateMedCategory(med.id, e.target.value as "regular" | "acute")} className="text-xs border border-slate-300 rounded px-2 py-1 bg-slate-50 text-slate-700 outline-none">
                        <option value="regular">Dauermedikation</option>
                        <option value="acute">Akut (letzte 7 Tage)</option>
                      </select>
                      <button type="button" onClick={() => removeMedication(med.id)} className="text-xs text-red-600 hover:text-red-800 font-semibold px-2 py-1 rounded hover:bg-red-50">Entfernen</button>
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