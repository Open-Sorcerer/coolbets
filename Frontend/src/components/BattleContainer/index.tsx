import { Avatar, AvatarImage } from "../ui/avatar";
import BetDrawer from "../BetDrawer";
import { formatLargeNumber } from "@/lib/utils";

type BattleContainerProps = {
  status: React.ReactNode;
  deadline: string;
  headerSection: React.ReactNode;
  records: {
    pfp: string;
    username: string;
    amount: number;
  }[];
  contestId: number;
  type: "upcoming" | "live" | "ended";
};

export default function BattleContainer({
  status,
  deadline,
  headerSection,
  records,
  type,
  contestId,
}: BattleContainerProps) {

  return (
    <div className="flex flex-col gap-5">
      <div className="flex items-center justify-between">
        <span className="flex flex-col">
          {status}
          <p className="text-neutral-500">{deadline}</p>
        </span>
        {headerSection}
      </div>
      <div className="flex flex-col bg-neutral-800 gap-3 p-5 rounded-2xl">
        <span className="flex flex-col w-full bg-ash p-5 rounded-xl mb-2">
          <p className="text-sm text-neutral-500">Prize Pool 💰</p>
          <h1 className="text-2xl text-sky-300 font-medium">
            3434
          </h1>
          <p className="text-sm font-medium text-neutral-300">$MOXIE</p>
        </span>
        {records.map((record, index) => (
          <div
            className="flex gap-4 items-center border-t border-neutral-700 pt-4"
            key={index}
          >
            <span className="flex flex-col gap-1 w-[20%]">
              <Avatar className="w-8 h-8">
                <AvatarImage
                  src={record.pfp ?? "https://github.com/shadcn.png"}
                />
              </Avatar>
              <h1 className="text-sm text-amber-300 font-medium overflow-hidden text-ellipsis">
                {record.username}
              </h1>
            </span>
            <div className="flex items-center justify-between w-[80%]">
              <div className="flex flex-col">
                <div className="flex items-center gap-2">
                  <p className="text-sm text-neutral-300">24hrs Earnings</p>
                  <span className="py-[0.1rem] px-2 w-fit bg-blew font-medium text-[0.7rem] text-neutral-50 rounded-2xl">
                    {formatLargeNumber(record.amount)}
                  </span>
                </div>
                <h1 className="text-lg text-sky-300 font-medium">
                  2345 MOXIE
                </h1>
                <span className='text-sm text-neutral-200'>350 bets</span>
              </div>
              {type === "upcoming" && (
                <BetDrawer
                  contestantId={index}
                  record={record}
                  contestId={contestId}
                  deadline={deadline}
                  contestDetails={""}
                />
              )}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
