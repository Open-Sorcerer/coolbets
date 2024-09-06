"use client";

import Image from "next/image";
import { Avatar, AvatarImage, AvatarFallback } from "@/components/ui/avatar";

export default function Navbar() {
  return (
    <div className="fixed top-0 left-0 right-0 bg-background">
      <div className="flex p-4 justify-between items-center max-w-[34rem] mx-auto">
        <span className="flex items-center gap-2 text-lg font-semibold text-purple">
          <Image src="/coolbets.svg" alt="Coolbets" width={25} height={25} />{" "}
          Coolbets
        </span>
        <Avatar className="w-7 h-7">
          <AvatarImage src="https://github.com/shadcn.png" />
          <AvatarFallback>CN</AvatarFallback>
        </Avatar>
      </div>
    </div>
  );
}
