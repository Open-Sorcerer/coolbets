"use client";

import Image from "next/image";
export default function Navbar() {

  return (
    <div className="fixed top-0 left-0 right-0 bg-background">
      <div className="flex py-3 px-4 justify-between items-center max-w-[34rem] mx-auto">
        <Image src="/coolbets.svg" alt="Quinn" width={30} height={30} />
      </div>
    </div>
  );
}
