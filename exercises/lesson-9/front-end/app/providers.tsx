'use client'

import {FC} from "react";
import {WalletProvider, SuiDevnetChain, Chain, SuietWallet, SuiWallet, IDefaultWallet} from "@suiet/wallet-kit";

const SupportedChains: Chain[] = [
  // ...DefaultChains,
  SuiDevnetChain,
  // NOTE: you can add custom chain (network),
  // but make sure the connected wallet does support it
  // customChain,
]

const SupportWallets: IDefaultWallet[] = [
  // order defined by you
  SuietWallet,
  SuiWallet,
  // ...
]
/**
 * Custom provider component for integrating with third-party providers.
 * https://nextjs.org/docs/getting-started/react-essentials#rendering-third-party-context-providers-in-server-components
 * @param props
 * @constructor
 */
const Providers: FC<any> = ({children}) => {
  return (
    <WalletProvider 
    chains={ SupportedChains}
    defaultWallets={SupportWallets}>
      {children}
    </WalletProvider>
  );
};

export default Providers;