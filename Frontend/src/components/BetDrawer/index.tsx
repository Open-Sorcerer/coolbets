import React, { useState } from "react";
import { Avatar, AvatarImage } from "../ui/avatar";
import { Button } from "../ui/button";
import {
  Drawer,
  DrawerContent,
  DrawerTrigger,
  DrawerClose,
  DrawerFooter,
} from "../ui/drawer";
import { Slider } from "../ui/slider";

interface BetDrawerProps {
  record: {
    pfp: string | null;
    username: string;
  };
  deadline: string;
  contestDetails: string;
  contestId: number;
  contestantId: number;
}

const BetDrawer: React.FC<BetDrawerProps> = ({
  record,
  contestId,
  deadline,
  contestDetails,
  contestantId,
}) => {
  const [sliderValue, setSliderValue] = useState(10);

  return (
    <Drawer>
      <DrawerTrigger asChild>
        <Button variant="secondary" className="rounded-xl min-w-[3rem]">
          Bet
        </Button>
      </DrawerTrigger>
      <DrawerContent>
        <div className="flex flex-col gap-2 w-full max-w-[30rem] mx-auto mt-2 p-5">
          <div className="flex flex-col items-center justify-center">
            <span className="flex items-center gap-2">
              <Avatar className="w-6 h-6">
                <AvatarImage
                  src={record.pfp ?? "https://github.com/shadcn.png"}
                />
              </Avatar>{" "}
              @{record.username} will make the highest
            </span>
            <p className="text-amber-300">social capital value cast tomorrow</p>
            <p className="text-sm text-neutral-500">{deadline}</p>
          </div>
          <div className="flex flex-col bg-neutral-800 gap-3 p-5 rounded-2xl mt-5 items-center justify-center w-full">
            <div className="flex justify-between w-full bg-ash p-5 rounded-xl mb-2">
              <span className="flex flex-col justify-between">
                <p className="text-sm text-neutral-500">Prize Pool 💰</p>
                <h1 className="text-2xl text-sky-300 font-medium">
                  35
                </h1>
                <p className="text-sm font-medium text-neutral-300">$MOXIE</p>
              </span>
              <span className="flex flex-col items-end justify-between">
                <p className="text-sm text-neutral-500">Your Bet 🎯</p>
                <h1 className="text-2xl text-sky-300 font-medium">
                  3535
                </h1>
                <p className="text-sm font-medium text-neutral-300">$MOXIE</p>
              </span>
            </div>
            <span className="flex items-center gap-2 font-medium">
              <h1 className="text-xl">{sliderValue}</h1>
              <p className="text-sky-300">wager</p>
            </span>
            <Slider
              defaultValue={[10]}
              max={100}
              step={1}
              value={[sliderValue]}
              onValueChange={(value) => setSliderValue(value[0])}
            />
            <p className="text-sm text-amber-300 font-medium">
              to win rewards of prize pool (estimated)
            </p>
          </div>
          <p className="text-sm text-neutral-500">
            * Prize pool win estimates will change until the round starts
          </p>
        </div>
        <DrawerFooter className="w-full max-w-[30rem] mx-auto">
          <Button variant="blew">
            Place Bet
          </Button>
          <DrawerClose>
            <Button variant="outline" className="w-full">
              Cancel
            </Button>
          </DrawerClose>
        </DrawerFooter>
      </DrawerContent>
    </Drawer>
  );
};

export default BetDrawer;
