import { InfoCircledIcon } from "@radix-ui/react-icons";
import BattleContainer from "../BattleContainer";
import {
  Sheet,
  SheetContent,
  SheetDescription,
  SheetHeader,
  SheetTitle,
  SheetTrigger,
} from "../ui/sheet";
import { fetchContests } from "@/app/_actions";
import { calculateDeadline, getDeadline } from "@/lib/helpers";
import { TContestData } from "@/lib/types";
import { useQuery } from "@tanstack/react-query";
import { useCountdown } from "@/hooks/useCountdown";
import Spinner from "../Spinner";

function Status({ status }: { status: "Live" | "Upcoming" | "Ended" }) {
  if (status === "Live") {
    return (
      <div className="flex items-center gap-3">
        <span className="relative flex h-3 w-3">
          <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span>
          <span className="relative inline-flex rounded-full h-3 w-3 bg-emerald-500"></span>
        </span>
        <h1 className="text-lg font-medium uppercase">{status}</h1>
      </div>
    );
  }
  return <h1 className="text-lg font-medium uppercase">{status}</h1>;
}

function HeaderSection({
  status,
  deadline,
}: {
  status: "Upcoming" | "Live" | "Ended";
  deadline: Date;
}) {
  const timeLeft = useCountdown(deadline);

  if (status === "Upcoming") {
    return (
      <span className="flex items-center gap-3 text-sm text-neutral-400">
        How to play
        <Sheet>
          <SheetTrigger asChild>
            <InfoCircledIcon className="w-5 h-5" />
          </SheetTrigger>
          <SheetContent side="bottom">
            <SheetHeader className="max-w-[30rem] md:mx-auto">
              <SheetTitle>Welcome to Fans Arena 🎱</SheetTitle>
              <SheetDescription className="text-neutral-50">
                To play, pick the caster you think will have the highest social
                capital value (SCV) cast by the end of the round. Then, choose
                the amount of $DEGEN you want to wager. The more you wager, the
                bigger your share of the prize pool if your caster wins! <br />{" "}
                <br />
                Social capital value (SCV) is a measure of how much social
                influence a cast has. The higher the SCV, the more influential
                the cast. To promote a fair game, SCV is provided by our 3rd
                party partner Airstack. <br /> <br />
                There&apos;s no limit to how many picks you can make and how
                much you can wager. <br /> <br />
                Share your pick on Warpcast to earn 1% of what your referrals
                wager, no matter if they win or lose! <br /> <br />
                Coolbets takes a 5% fee from the prize pool, and up to 5% of the
                prize pool is saved for our Referral Program.
              </SheetDescription>
            </SheetHeader>
          </SheetContent>
        </Sheet>
      </span>
    );
  }
  if (status === "Live") {
    return <span className="text-neutral-400 text-sm">{timeLeft}</span>;
  }
  return null;
}

export default function FansArena() {

  const { data: records, isLoading } = useQuery<{ upcoming: TContestData[]; live: TContestData[]; ended: TContestData[]; }>({
    queryKey: ['contests'],
    queryFn: () => fetchContests() as Promise<{ upcoming: TContestData[]; live: TContestData[]; ended: TContestData[]; }>,
    refetchOnMount: true,
    refetchOnWindowFocus: true,
    staleTime: 0,
  });

  return (
    <div className="flex flex-col gap-5 mt-7">
      {isLoading ? (
        <div className="flex justify-center items-center h-64">
          <Spinner size="lg" color="white" />
        </div>
      ) : (
        <>
          {records && records.upcoming?.length > 0 && (
            <BattleContainer
              status={<Status status="Upcoming" />}
              deadline={calculateDeadline(
                new Date(records.upcoming[0].created_at)
              )}
              headerSection={
                <HeaderSection
                  status="Upcoming"
                  deadline={getDeadline(
                    new Date(records.upcoming[0].created_at)
                  )}
                />
              }
              records={
                records.upcoming[0].contestantDetails?.map((record) => ({
                  pfp: record.pfp,
                  username: record.username,
                  amount: Number(record.moxieEarnings),
                })) ?? []
              }
              contestId={records.upcoming[0].id}
              type="upcoming"
            />
          )}
          {records && records?.live?.length > 0 && (
            <BattleContainer
              status={<Status status="Live" />}
              deadline={calculateDeadline(new Date(records.live[0].created_at))}
              headerSection={
                <HeaderSection
                  status="Live"
                  deadline={getDeadline(new Date(records.live[0].created_at))}
                />
              }
              records={
                records.live[0].contestantDetails?.map((record) => ({
                  pfp: record.pfp,
                  username: record.username,
                  amount: Number(record.moxieEarnings),
                })) ?? []
              }
              contestId={records.live[0].id}
              type="live"
            />
          )}
          {records && records?.ended?.length > 0 && (
            <BattleContainer
              status={<Status status="Ended" />}
              deadline={calculateDeadline(
                new Date(records.ended[0].created_at)
              )}
              headerSection={
                <HeaderSection
                  status="Ended"
                  deadline={getDeadline(new Date(records.ended[0].created_at))}
                />
              }
              records={
                records.ended[0].contestantDetails?.map((record) => ({
                  pfp: record.pfp,
                  username: record.username,
                  amount: Number(record.moxieEarnings),
                })) ?? []
              }
              contestId={records.ended[0].id}
              type="ended"
            />
          )}
        </>
      )}
    </div>
  );
}
