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

function Status({ status }: { status: "Live" | "Ended" }) {
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
  status: "Live" | "Ended";
  deadline: Date;
}) {
  if (status === "Live") {
    return (
      <span className="flex items-center gap-3 text-sm text-neutral-400">
        How to play
        <Sheet>
          <SheetTrigger asChild>
            <InfoCircledIcon className="w-5 h-5" />
          </SheetTrigger>
          <SheetContent side="bottom">
            <SheetHeader className="max-w-[30rem] md:mx-auto">
              <SheetTitle className="text-lavender">Welcome to Arena ⚔️</SheetTitle>
              <SheetDescription className="text-neutral-50">
                <ol className="list-decimal pl-5 space-y-2">
                  <li>Choose an event: Select an upcoming match or contest.</li>
                  <li>Place your bet: Enter the amount you want to wager.</li>
                  <li>
                    Select your prediction: Choose the outcome you think will
                    happen.
                  </li>
                  <li>Confirm your bet: Review and submit your wager.</li>
                  <li>Watch the event: Follow the action live!</li>
                  <li>
                    Collect winnings: If your prediction is correct, your
                    winnings will be credited to your account.
                  </li>
                </ol>
                <p className="mt-4 text-amber-200">
                  *Remember to bet responsibly and have fun!
                </p>
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
    <div className="flex flex-col gap-5  w-full">
      <BattleContainer
        status={<Status status="Live" />}
        deadline=""
        headerSection={<HeaderSection status="Live" deadline={new Date()} />}
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
