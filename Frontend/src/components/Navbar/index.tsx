"use client";

import Image from "next/image";
export default function Navbar() {
  return (
    <div className="fixed top-0 left-0 right-0 bg-background">
      <div className="flex p-4 justify-between items-center max-w-[34rem] mx-auto">
        <span className="flex items-center gap-2 text-lg font-medium text-sky-400">
          <Image src="/coolbets.svg" alt="Coolbets" width={25} height={25} />{" "}
          Coolbets
        </span>
      </div>
    </div>
  );
}
