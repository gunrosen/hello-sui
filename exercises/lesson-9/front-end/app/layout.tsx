import './globals.css'
import { Inter } from 'next/font/google'
import Providers from "@/app/providers";
import "@suiet/wallet-kit/style.css";
import type { Metadata } from 'next';

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "Sui Bootcamp - VBI 2024",
  description: "Sui Bootcamp - VBI Academy 2024",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <Providers>
            {children}
        </Providers>
      </body>
    </html>
  );
}
