"use client";

import { useEffect, useState } from "react";
import { Abi, createPublicClient, getContract, http } from "viem";
import { baseSepolia, zkSyncSepoliaTestnet } from "viem/chains";
import { useAccount } from "wagmi";
import Card from "@/components/trade/card";

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
  const [ethPrice, setEthPrice] = useState<number>(0);
  const [allProposals, setAllProposals] = useState<TProposal[]>([]);

//   const client = createPublicClient({
//     chain:
//       opinionTradingContracts[chain?.id as keyof typeof opinionTradingContracts]?.chain ??
//       baseSepolia,
//     transport: http(),
//   });

//   const contract = getContract({
//     address: opinionTradingContracts[chain?.id as keyof typeof opinionTradingContracts]
//       ?.contract as `0x${string}`,
//     abi:
//       chain?.id === zkSyncSepoliaTestnet.id ? zkSyncOpinionTradingABI : (opinionTradingABI as Abi),
//     client,
//   });

//   useEffect(() => {
//     const fetchData = async () => {
//       try {
//         const totalProposals = (await contract.read.proposalCount([])) as number;
//         const proposals: TProposal[] = [];
//         for (let i = 1; i <= totalProposals; i++) {
//           const proposal = (await contract.read.proposals([i])) as string[];
//           const deadline = timestampToDateString(Number(proposal[3]));
//           proposals.push({
//             description: proposal[0],
//             option1: proposal[1],
//             option2: proposal[2],
//             deadline,
//             id: i,
//             votes: Number(proposal[4]) + Number(proposal[5]),
//           });
//         }
//         setAllProposals(proposals);
//       } catch (error) {
//         console.log(error);
//       }
//       const price = await getETHPrice() as number;
//       setEthPrice(price)
//     };
//     fetchData();
//   }, [chain]);


  function timestampToDateString(timestamp: number) {
    const date = new Date(timestamp * 1000);
    return `${date.getDate()}/${date.getMonth() + 1}/${date.getFullYear()}`;
  }

  return (
    <div className="flex flex-col w-full py-32 px-5 md:px-32 lg:px-28 xl:px-40 2xl:px-48">
      <h1 className="text-2xl md:text-3xl font-title font-medium">Trade on Live Opinions ⚡️</h1>
      <div className="grid grid-flow-row grid-cols-1 lg:grid-cols-2 2xl:grid-cols-3 gap-3 mt-4">
        {allProposals.map((data, index) => (
          <Card key={index} {...data} ethPrice={ethPrice} />
        ))}
      </div>
    </div>
  );
}