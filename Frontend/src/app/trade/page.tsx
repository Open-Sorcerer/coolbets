"use client";

import { createPublicClient, getContract, http } from "viem";
import { baseSepolia } from "viem/chains";
import { useAccount } from "wagmi";
import Card from "@/components/trade/card";
import { ABI, coolBetContracts } from "@/utils/contracts";
import { useQuery } from "@tanstack/react-query";
import Spinner from "@/components/shared/Spinner";

export const fetchCache = "force-no-store";

type TProposal = {
  description: string;
  option1: string;
  option2: string;
  deadline: string;
  id: number;
  votes: number;
};

export default function TradePage() {
  const { chain } = useAccount();

  const client = createPublicClient({
    chain: coolBetContracts[chain?.id as keyof typeof coolBetContracts]?.chain ?? baseSepolia,
    transport: http(),
  });

  const contract = getContract({
    address: coolBetContracts[chain?.id as keyof typeof coolBetContracts]
      ?.contract as `0x${string}`,
    abi: ABI,
    client,
  });

  const fetchProposals = async () => {
    const totalProposals = (await contract.read.getProposalCount([])) as number;
    const proposals: TProposal[] = [];

    for (let i = 0; i < totalProposals; i++) {
      const proposal = (await contract.read.getProposalsById([i])) as {
        description: string;
        deadline: bigint;
        option1: string;
        option2: string;
        option1Votes: bigint;
        option2Votes: bigint;
      };

      const deadline = timestampToDateString(Number(proposal.deadline));
      proposals.push({
        description: proposal.description,
        option1: proposal.option1,
        option2: proposal.option2,
        deadline,
        id: i,
        votes: Number(proposal.option1Votes) + Number(proposal.option2Votes),
      });
    }

    return proposals;
  };

  const { data: allProposals, isLoading } = useQuery({
    queryKey: ["proposals", chain?.id],
    queryFn: fetchProposals,
  });

  function timestampToDateString(timestamp: number) {
    const date = new Date(timestamp * 1000);
    return `${date.getDate()}/${date.getMonth() + 1}/${date.getFullYear()}`;
  }

  return (
    <div className="flex flex-col w-full py-32 px-5 md:px-32 lg:px-28 xl:px-40 2xl:px-48">
      <h1 className="text-2xl md:text-3xl text-neutral-600 font-title font-medium">
        Trade on Live Opinions ⚡️
      </h1>
      <div
        className={`flex flex-wrap ${allProposals && allProposals.length % 3 === 0 ? "justify-between" : "justify-start"} gap-3 mt-4`}
      >
        {isLoading ? (
          <div className="flex items-center justify-center w-full h-full py-20">
            <Spinner className="text-violet-500" />
          </div>
        ) : allProposals && allProposals.length < 1 ? (
          <div>
            <p className="text-neutral-600 font-primary font-medium">No contests found</p>
          </div>
        ) : (
          <>{allProposals?.map((data, index) => <Card key={index} {...data} />)}</>
        )}
      </div>
    </div>
  );
}
