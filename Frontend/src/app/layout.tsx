import type { Metadata } from "next";
import "./globals.css";
import Providers from "./providers";
import { Navbar } from "@/components";
import { Toaster } from "react-hot-toast";

export const metadata: Metadata = {
  title: "Coolbets",
  description: "Trade your opinions on multiple chains",
  icons: "/coolbets.svg",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="bg-white">
        <Providers>
          <Navbar />
          {children}
        </Providers>
        <Toaster position="bottom-center" />
      </body>
    </html>
  );
}
