"use client";

import Image from "next/image";
import { useRouter } from "next/navigation";
import { baseSepolia } from "viem/chains";
import { useAccount } from "wagmi";

export default function Hero() {
  const router = useRouter();
  const { chain } = useAccount();
  return (
    <main className="flex min-h-screen flex-col items-center justify-center py-24">
      <div className="flex flex-wrap container p-5 mx-auto xl:px-20 2xl:px-20">
        <div className="flex items-center w-full lg:w-1/2">
          <div className="max-w-2xl mb-8">
            <h1 className="text-4xl font-bold font-title leading-snug tracking-tight text-gray-800 lg:text-4xl lg:leading-tight xl:text-6xl xl:leading-tight">
              Stake Your Insight, Shape the Future
            </h1>
            <p className="py-5 text-xl leading-normal text-gray-500 lg:text-xl xl:text-2xl">
              Our multi-chain platform allows you to trade predictions on global events, and
              potentially profit from your foresight. Stake your claims across multiple chains.
            </p>

            <div className="flex flex-col items-start space-y-3 sm:space-x-4 sm:space-y-0 sm:items-center sm:flex-row">
              <button
                onClick={() => {
                  router.push(`/trade?chainId=${chain?.id ?? baseSepolia.id}`);
                }}
                className="px-10 py-2 text-lg font-medium text-center text-white bg-violet-500 hover:bg-violet-600 rounded-3xl"
              >
                Start trading
              </button>
            </div>
          </div>
        </div>
        <div className="flex items-center justify-center w-full lg:w-1/2">
          <div>
            <Image
              src="/hero.jpeg"
              width="616"
              height="617"
              className="object-cover"
              alt="Hero Illustration"
              loading="eager"
            />
          </div>
        </div>
      </div>
    </main>
  );
}
