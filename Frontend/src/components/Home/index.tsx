"use client";

import Arena from "../Arena";

export default function Home() {
  return (
    <main className="flex bg-darkAsh min-h-screen min-w-[25rem] md:min-w-[34rem] max-w-[34rem] flex-col items-center justify-between py-[5.5rem] px-5">
      <Arena />
    </main>
  );
}
