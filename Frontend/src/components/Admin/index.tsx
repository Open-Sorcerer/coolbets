"use client";

import { useState } from "react";
import { Button } from "../ui/button";
import { Input } from "../ui/input";

export default function Admin() {
  const [contestName, setContestName] = useState("");
  const [deadline, setDeadline] = useState("");
  const [option1, setOption1] = useState("");
  const [option2, setOption2] = useState("");

  const handleCreateContest = () => {
    console.log(contestName, deadline, option1, option2);
  };

  const handleAnnounceWinner = () => {
    console.log("Announce Winner");
  };

  return (
    <main className="flex bg-darkAsh md:min-h-screen min-w-[25rem] md:min-w-[34rem] max-w-[34rem] flex-col gap-10 items-center py-[5.5rem] px-5">
      <div className="flex flex-col gap-3 w-full">
        <h3 className="text-2xl text-amber-200 font-medium mb-2">
          Create Contest
        </h3>
        <Input
          placeholder="Contest Name"
          value={contestName}
          onChange={(e) => setContestName(e.target.value)}
          label="Contest Name"
        />
        <Input
          placeholder="20/01/2025"
          value={deadline}
          onChange={(e) => setDeadline(e.target.value)}
          label="Contest Deadline"
        />
        <Input
          placeholder="Option 1"
          value={option1}
          onChange={(e) => setOption1(e.target.value)}
          label="Contest Options - I"
        />
        <Input
          placeholder="Option 2"
          value={option2}
          onChange={(e) => setOption2(e.target.value)}
          label="Contest Options - II"
        />
        <Button variant="lavender" onClick={handleCreateContest}>
          Add Contest
        </Button>
      </div>
      <div className="flex flex-col gap-3 w-full">
        <h3 className="text-2xl text-amber-200 font-medium mb-2">
          Declare Results
        </h3>
        <Button variant="lavender" onClick={handleAnnounceWinner}>
          Distribute Prizes
        </Button>
      </div>
    </main>
  );
}
