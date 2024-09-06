import React, { useEffect, useMemo, useState } from "react";
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
import { TContestDetails } from "@/lib/types";
import { getWinningAmount } from "@/lib/helpers";
import { useWaitForTransactionReceipt, useWriteContract } from "wagmi";
import { toast } from "react-toastify";
import { quinnAbi, quinnContract, sepoliaToken, tokenABI } from "@/constants";
import { parseUnits } from "viem";
import { baseSepolia } from "viem/chains";

interface BetDrawerProps {
  record: {
    pfp: string | null;
    username: string;
  };
  deadline: string;
  contestDetails: TContestDetails;
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

  const { writeContractAsync: callPlaceBetContract, data: placeBetHash } =
    useWriteContract();
  const { writeContractAsync: approveTokenContract, data: approveTokenHash } =
    useWriteContract();
  const { isSuccess: approveSuccess } = useWaitForTransactionReceipt({
    hash: approveTokenHash,
  });
  const { isSuccess: placeBetSuccess } = useWaitForTransactionReceipt({
    hash: placeBetHash,
  });

  const winningAmount = useMemo(() => {
    if (contestDetails) {
      return getWinningAmount(
        Number(contestDetails?.totalPoolAmount ?? 0),
        sliderValue,
        contestDetails?.poolAmount,
        contestantId
      );
    }
    return 0;
  }, [
    sliderValue,
    contestDetails?.totalPoolAmount,
    contestDetails?.poolAmount,
  ]);
  const [state, setState] = useState<"approve" | "placeBet" | "idle">("idle");

  useEffect(() => {
    if (approveSuccess) {
      setState("placeBet");
      placeBet(contestantId + 1);
    }
  }, [approveSuccess]);

  useEffect(() => {
    if (placeBetSuccess) {
      setState("idle");
      toast.success("Bet placed successfully");
    }
  }, [placeBetSuccess]);

  const placeBet = async (index: number) => {
    await callPlaceBetContract({
      abi: quinnAbi,
      address: quinnContract as `0x${string}`,
      functionName: "getInContest",
      args: [contestId, index, sliderValue],
    });
  };

  const approveToken = async () => {
    setState("approve");
    await approveTokenContract({
      abi: tokenABI,
      address: sepoliaToken as `0x${string}`,
      functionName: "approve",
      args: [quinnContract, parseUnits(sliderValue.toString(), 18)],
      chain: baseSepolia,
    });
  };

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
            <p className="text-cream">social capital value cast tomorrow</p>
            <p className="text-sm text-neutral-500">{deadline}</p>
          </div>
          <div className="flex flex-col bg-neutral-800 gap-3 p-5 rounded-2xl mt-5 items-center justify-center w-full">
            <div className="flex justify-between w-full bg-ash p-5 rounded-xl mb-2">
              <span className="flex flex-col justify-between">
                <p className="text-sm text-neutral-500">Prize Pool 💰</p>
                <h1 className="text-2xl text-sky-300 font-medium">
                  {Number(contestDetails?.totalPoolAmount ?? 0)}
                </h1>
                <p className="text-sm font-medium text-neutral-300">$MOXIE</p>
              </span>
              <span className="flex flex-col items-end justify-between">
                <p className="text-sm text-neutral-500">Your Bet 🎯</p>
                <h1 className="text-2xl text-sky-300 font-medium">
                  {Number(contestDetails?.poolAmount[contestantId] ?? 0)}
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
            <p className="text-sm text-cream font-medium">
              to win {winningAmount.toFixed(2)} $MOXIE of prize pool (estimated)
            </p>
          </div>
          <p className="text-sm text-neutral-500">
            * Prize pool win estimates will change until the round starts
          </p>
        </div>
        <DrawerFooter className="w-full max-w-[30rem] mx-auto">
          <Button onClick={approveToken} variant="blew">
            {state === "approve"
              ? "Approving"
              : state === "placeBet"
                ? "Placing Bet"
                : "Place Wager"}
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
