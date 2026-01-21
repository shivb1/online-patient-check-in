"use client";

import { IntakeProvider } from "./context/IntakeContext";

export function Providers({ children }: { children: React.ReactNode }) {
  return <IntakeProvider>{children}</IntakeProvider>;
}
