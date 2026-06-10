"use client";

import React, { useEffect, useRef } from "react";
import { Html5QrcodeScanner, Html5QrcodeSupportedFormats } from "html5-qrcode";

interface BarcodeScannerProps {
  onScanSuccess: (decodedText: string) => void;
  onScanError?: (errorMessage: string) => void;
}

export default function BarcodeScanner({ onScanSuccess, onScanError }: BarcodeScannerProps) {
  const scannerContainerRef = useRef<HTMLDivElement>(null);
  const isScannerInitialized = useRef(false);

  useEffect(() => {
    if (!scannerContainerRef.current) return;
    if (isScannerInitialized.current) return; 

    isScannerInitialized.current = true; 
    let isProcessing = false; // Harter Lock gegen Doppel-Scans

    const html5QrcodeScanner = new Html5QrcodeScanner(
      "unified-scanner-container", 
      { 
        fps: 10, 
        qrbox: { width: 300, height: 300 },
        rememberLastUsedCamera: true,
        formatsToSupport: [
          Html5QrcodeSupportedFormats.DATA_MATRIX,
          Html5QrcodeSupportedFormats.QR_CODE,
          Html5QrcodeSupportedFormats.EAN_13,
          Html5QrcodeSupportedFormats.EAN_8
        ]
      },
      false
    );

    html5QrcodeScanner.render(
      (decodedText) => {
        // Wenn er gerade schon verarbeitet, ignoriere weitere Kamera-Events sofort!
        if (isProcessing) return;
        isProcessing = true; 

        // Scanner pausieren, bevor das UI ihn überhaupt schliessen kann
        html5QrcodeScanner.pause(true); 
        
        onScanSuccess(decodedText);
      },
      (errorMessage) => {
        if (onScanError) onScanError(errorMessage);
      }
    );

    return () => {
      html5QrcodeScanner.clear().catch(console.error);
      isScannerInitialized.current = false;
    };
  }, [onScanSuccess, onScanError]);

  return (
    <div className="w-full max-w-md mx-auto">
      <div 
        id="unified-scanner-container" 
        ref={scannerContainerRef} 
        className="overflow-hidden rounded-xl border-2 border-slate-200 bg-white shadow-sm"
      ></div>
      <p className="text-sm text-gray-500 text-center mt-2">
        Achten Sie auf ausreichend Licht und halten Sie die Kamera ruhig.
      </p>
    </div>
  );
}