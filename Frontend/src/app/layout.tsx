import type { Metadata } from "next";
import "./globals.css";
import "react-toastify/dist/ReactToastify.css";
import { Slide, ToastContainer } from "react-toastify";
import Navbar from "@/components/Navbar";

export const metadata: Metadata = {
  title: "Coolbets",
  description: "Coolbets",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="max-w-[34rem] mx-auto">
        <Navbar />
        {children}
        <ToastContainer
          position="top-right"
          autoClose={3000}
          hideProgressBar={false}
          newestOnTop={false}
          closeOnClick
          rtl={false}
          pauseOnFocusLoss
          draggable
          pauseOnHover
          theme="dark"
          transition={Slide}
        />
      </body>
    </html>
  );
}
