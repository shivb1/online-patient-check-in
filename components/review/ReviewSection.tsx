import React from "react";

export function ReviewSection({
  title,
  children,
}: {
  title: string;
  children: React.ReactNode;
}) {
  return (
    <section className="mt-6">
      <h2 className="font-semibold border-b border-slate-600 pb-1 mb-3">
        {title}
      </h2>
      <div className="space-y-1">{children}</div>
    </section>
  );
}
