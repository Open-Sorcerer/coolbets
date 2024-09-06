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

const records = [
  {
    pfp: "https://pbs.twimg.com/profile_images/1798328126855069696/5Y5-5_9g_400x400.jpg",
    username: "John Doe",
    amount: 100,
  },
];

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
  return null;
}

export default function Arena() {
  return (
    <div className="flex flex-col gap-5 mt-7">
      <BattleContainer
        status={<Status status="Upcoming" />}
        deadline=""
        headerSection={
          <HeaderSection status="Upcoming" deadline={new Date()} />
        }
        records={
          records.map((record) => ({
            pfp: record.pfp,
            username: record.username,
            amount: record.amount,
          })) ?? []
        }
        contestId={123}
        type="upcoming"
      />
    </div>
  );
}
