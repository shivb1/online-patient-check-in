import React from "react";

export function ReviewRow({
  label,
  value,
}: {
  label: string;
  value?: React.ReactNode;
}) {
  if (value === undefined || value === null || value === "") return null;

  return (
    <div className="grid grid-cols-2 gap-4 py-1 text-sm">
      <div className="text-slate-400">{label}</div>
      <div className="text-white">{value}</div>
    </div>
  );
}
