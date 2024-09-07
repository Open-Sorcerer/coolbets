import { CreateCampaign } from "@/components";
import { Metadata } from "next";

export function generateMetadata(): Promise<Metadata> {
  return Promise.resolve({
    title: "Create Campaign | Coolbets",
    icons: "/coolbets.svg",
  });
}

export default function Create() {
  return <CreateCampaign />;
}
