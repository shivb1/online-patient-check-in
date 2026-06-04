"use client";

import React, { useEffect, useRef } from "react";
import { Html5QrcodeScanner } from "html5-qrcode";

interface BarcodeScannerProps {
  onScanSuccess: (decodedText: string) => void;
  onScanError?: (errorMessage: string) => void;
}

export default function BarcodeScanner({ onScanSuccess, onScanError }: BarcodeScannerProps) {
  const scannerContainerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    // Verhindert doppeltes Rendern im React Strict Mode
    if (!scannerContainerRef.current) return;

    // Konfiguration des Scanners
    const html5QrcodeScanner = new Html5QrcodeScanner(
      "emediplan-reader",
      { 
        fps: 10, 
        qrbox: { width: 250, height: 250 },
        rememberLastUsedCamera: true,
        supportedScanTypes: [] // Lässt die Bibliothek automatisch den besten Typ (2D Barcode/QR) wählen
      },
      false
    );

    html5QrcodeScanner.render(
      (decodedText) => {
        // Bei Erfolg: Scanner stoppen und Text an die Eltern-Komponente übergeben
        html5QrcodeScanner.clear().catch(console.error);
        onScanSuccess(decodedText);
      },
      (errorMessage) => {
        // Fehler (z.B. kein Code im Bild) werden hier kontinuierlich geworfen, 
        // wir leiten sie nur weiter, falls die Eltern-Komponente sie braucht.
        if (onScanError) {
          onScanError(errorMessage);
        }
      }
    );

    // Cleanup-Funktion, wenn die Komponente den Bildschirm verlässt
    return () => {
      html5QrcodeScanner.clear().catch(console.error);
    };
  }, [onScanSuccess, onScanError]);

  return (
    <div className="w-full max-w-md mx-auto">
      <div 
        id="emediplan-reader" 
        ref={scannerContainerRef} 
        className="overflow-hidden rounded-xl border-2 border-blue-200 bg-white shadow-sm"
      ></div>
      <p className="text-sm text-gray-500 text-center mt-2">
        Bitte scannen Sie den Code auf dem eMediplan.
      </p>
    </div>
  );
}