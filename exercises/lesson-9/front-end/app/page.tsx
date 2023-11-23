"use client"; 
import Image from "next/image";
import {
  addressEllipsis,
  ConnectButton,
  ErrorCode,
  formatSUI,
  SuiChainId,
  useAccountBalance,
  useWallet,
} from "@suiet/wallet-kit";

export default function Home() {
  const wallet = useWallet();
  const { balance } = useAccountBalance();

  return (
    <main className="flex min-h-screen flex-col items-center justify-between p-24">
      <div className="relative flex flex-col place-items-center before:absolute before:h-[300px] before:w-[480px] before:-translate-x-1/2 before:rounded-full before:bg-gradient-radial before:from-white before:to-transparent before:blur-2xl before:content-[''] after:absolute after:-z-20 after:h-[180px] after:w-[240px] after:translate-x-1/3 after:bg-gradient-conic after:from-sky-200 after:via-blue-200 after:blur-2xl after:content-[''] before:dark:bg-gradient-to-br before:dark:from-transparent before:dark:to-blue-700 before:dark:opacity-10 after:dark:from-sky-900 after:dark:via-[#0141ff] after:dark:opacity-40 before:lg:h-[360px]">
        <ConnectButton
          onConnectError={(error) => {
            if (error.code === ErrorCode.WALLET__CONNECT_ERROR__USER_REJECTED) {
              console.warn(
                "user rejected the connection to " + error.details?.wallet
              );
            } else {
              console.warn("unknown connect error: ", error);
            }
          }}
        />

        {!wallet.connected ? (
          <p className={"my-8"}>Connect DApp with Suiet wallet from now!</p>
        ) : (
          <div className={"my-8"}>
            <div>
              <p>current wallet: {wallet.adapter?.name}</p>
              <p>
                wallet status:{" "}
                {wallet.connecting
                  ? "connecting"
                  : wallet.connected
                  ? "connected"
                  : "disconnected"}
              </p>
              <p>
                wallet address: {addressEllipsis(wallet.account?.address ?? "")}
              </p>
              <p>current network: {wallet.chain?.name}</p>
              <p>
                wallet balance:{" "}
                {formatSUI(balance ?? 0, {
                  withAbbr: false,
                })}{" "}
                SUI
              </p>
            </div>
          </div>
        )}
      </div>

      <div></div>
    </main>
  );
}
