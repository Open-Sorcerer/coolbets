"use client";

import { useState } from "react";
import { Button } from "../ui/button";
import { Input } from "../ui/input";

export default function Admin() {
  const [contestName, setContestName] = useState("");
  const [fid, setFid] = useState("");

  const handleCreateContest = () => {
    console.log(contestName);
  };

  const handleAnnounceWinner = () => {
    console.log(fid);
  };

  return (
    <main className="flex bg-darkAsh md:min-h-screen min-w-[25rem] md:min-w-[34rem] max-w-[34rem] flex-col gap-10 items-center py-[5.5rem] px-5">
      <div className="flex flex-col gap-3 w-full">
        <h3 className="text-2xl text-sky-300 font-medium mb-2">
          Create Contest
        </h3>
        <Input
          placeholder="Contest Name"
          value={contestName}
          onChange={(e) => setContestName(e.target.value)}
        />
        <Button variant="blew" onClick={handleCreateContest}>
          Create
        </Button>
      </div>
      <div className="flex flex-col gap-3 w-full">
        <h3 className="text-2xl text-sky-300 font-medium mb-2">
          Declare Results
        </h3>
        <Input
          placeholder="Type FID"
          value={fid}
          onChange={(e) => setFid(e.target.value)}
        />
        <Button variant="blew" onClick={handleAnnounceWinner}>
          Announce
        </Button>
      </div>
    </main>
  );
}
