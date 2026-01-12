import React from "react";

export function ReviewSection({
  title,
  children,
}: {
  title: string;
  children: React.ReactNode;
}) {
  return (
    <section className="mt-8">
      <h2 className="font-semibold text-slate-900 border-b border-slate-200 pb-2 mb-3">
        {title}
      </h2>
      <div className="space-y-1">{children}</div>
    </section>
  );
}
