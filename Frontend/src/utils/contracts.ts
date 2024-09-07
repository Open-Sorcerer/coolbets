import {
  baseSepolia,
  morphHolesky,
  rootstockTestnet,
  spicy,
} from "viem/chains";

export const opinionTradingContracts = {
  [rootstockTestnet.id]: {
    contract: "0xe6a5267590aC048a599014a18815b9DaF247eEE7",
    chain: rootstockTestnet,
  },
  [spicy.id]: {
    contract: "0x6E84c2AF3393A2C85a6eA96765319040fd207f8a",
    chain: spicy,
  },
  [morphHolesky.id]: {
    contract: "0x6E84c2AF3393A2C85a6eA96765319040fd207f8a",
    chain: morphHolesky,
  },
  [baseSepolia.id]: {
    contract: "0x6E84c2AF3393A2C85a6eA96765319040fd207f8a",
    chain: baseSepolia,
  },
};