import BetDrawer from "../BetDrawer";

export default function BetContainer() {
  return (
    <div className="flex flex-col gap-5">
      <div className="flex flex-col bg-neutral-800 gap-3 p-5 rounded-2xl">
        <span className="flex flex-col w-full bg-ash p-5 rounded-xl">
          <h1 className="text-lg font-medium">
            Who will win US Election 2024?
          </h1>
        </span>
        <span className="flex gap-2 items-center justify-between px-2 my-2">
          <p className="text-sm text-neutral-400">Sept 12th 12:00 AM</p>
          <p className="text-sm text-amber-400">Picked 14 times</p>
        </span>
        <div className="flex gap-4">
          <BetDrawer label="Joe Biden" />
          <BetDrawer label="Donald Trump" />
        </div>
      </div>
    </div>
  );
}
