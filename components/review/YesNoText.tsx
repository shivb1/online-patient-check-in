import { YesNo } from "@/app/context/IntakeContext";

export function YesNoText({ value }: { value?: YesNo }) {
  if (value === "yes") return "Ja";
  if (value === "no") return "Nein";
  return "—";
}