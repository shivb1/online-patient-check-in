"use client";

import React, { useEffect, useState } from "react";
import { Html5Qrcode } from "html5-qrcode";

// Der Wächter regelt den Verkehr zur Kamera-Hardware im Hintergrund
let cameraLock = Promise.resolve();

interface BarcodeScannerProps {
  onScanSuccess: (decodedText: string) => void;
}

export default function BarcodeScanner({ onScanSuccess }: BarcodeScannerProps) {
  const [isStarting, setIsStarting] = useState(true);
  const READER_ID = "stable-barcode-reader";

  useEffect(() => {
    let isMounted = true;
    let html5QrCode: Html5Qrcode | null = null;

    cameraLock = cameraLock.then(async () => {
      if (!isMounted) return;
      
      setIsStarting(true);

      // DOM restlos leeren, falls Reste eines alten Scans hängen geblieben sind
      const readerElement = document.getElementById(READER_ID);
      if (readerElement) {
        readerElement.innerHTML = "";
      }

      html5QrCode = new Html5Qrcode(READER_ID, { verbose: false });

      try {
        await html5QrCode.start(
          { facingMode: "environment" },
          { fps: 10, qrbox: { width: 250, height: 100 } },
          (decodedText) => {
            if (isMounted) onScanSuccess(decodedText);
          },
          () => {} // Leere Bilder ignorieren
        );
        
        if (isMounted) setIsStarting(false);
      } catch (err) {
        console.error("Kamerafehler:", err);
        if (isMounted) setIsStarting(false);
      }
    });

    return () => {
      isMounted = false;
      if (html5QrCode) {
        cameraLock = cameraLock.then(async () => {
          try {
            await html5QrCode!.stop();
            html5QrCode!.clear();
          } catch (e) {
            // Ignorieren, falls die Kamera bereits geschlossen war
          }
        });
      }
    };
  }, [onScanSuccess]);

  return (
    <div className="w-full max-w-sm mx-auto bg-white p-2 rounded-lg shadow-sm relative">
      <div id={READER_ID} className="min-h-[150px] overflow-hidden rounded bg-black"></div>
      
      {isStarting && (
        <div className="absolute inset-0 flex items-center justify-center text-white text-xs z-10 animate-pulse">
          ⏳ Kamera startet...
        </div>
      )}
      
      {!isStarting && (
        <p className="text-xs text-center text-slate-500 mt-2">
          Halten Sie den Strichcode in das markierte Feld.
        </p>
      )}
    </div>
  );
}