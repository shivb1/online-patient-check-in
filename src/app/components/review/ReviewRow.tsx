import React from "react";

type Props = {
  label: string;
  value?: React.ReactNode;
};

export function ReviewRow({ label, value }: Props) {
  const isEmpty =
    value === undefined ||
    value === null ||
    (typeof value === "string" && value.trim() === "");

  if (isEmpty) return null;

  return (
    <div className="grid grid-cols-12 gap-4 py-1 text-sm">
      <div className="col-span-5 text-slate-600">{label}</div>
      <div className="col-span-7 text-slate-900">{value}</div>
    </div>
  );
}
