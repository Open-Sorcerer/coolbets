import { SignProtocolClient, SpMode, EvmChains } from "@ethsign/sp-sdk";
import { ethers } from "ethers";
import { privateKeyToAccount } from "viem/accounts";

import axios from "axios";

const privateKey = process.env.NEXT_PUBLIC_PRIVATE_KEY!;

const attesterWallet = new ethers.Wallet(privateKey);

let schemaId = "0x227";

//@ts-ignore
const signer = privateKeyToAccount(attesterWallet.privateKey);

// creating a client for Sign Protocol
const client = new SignProtocolClient(SpMode.OnChain, {
  chain: EvmChains.baseSepolia,

  account: signer,
});

async function createSchema() {
  console.log("Creating Schema");
  const result = await client.createSchema({
    name: "Placing Bets",
    data: [
      { name: "opinion", type: "uint256" },
      { name: "betAmount", type: "uint256" },
    ],
  });

  console.log(result); // we get the schemaId and the txn hash
}

// Create an Attestation

async function createNotaryAttestation(Description: string, Bet: string, Amount: string, attestingTo: string) {
  console.log("Creating Attestation");
  const res = await client.createAttestation({
    schemaId: schemaId,
    data: {
      Description,
      Bet,
      Amount,
    },
    indexingValue: attestingTo.toLowerCase(),
    recipients: [attestingTo.toLowerCase()],
  });
  console.log("Attestation created", res);
  return res.attestationId;
}

// Generate a function for making requests to the Sign Protocol Indexing Service
async function makeAttestationRequest(endpoint: string, options: any) {
  const url = `https://testnet-rpc.sign.global/api/${endpoint}`;
  const res = await axios.request({
    url,
    headers: {
      "Content-Type": "application/json; charset=UTF-8",
    },
    ...options,
  });
  // Throw API errors
  if (res.status !== 200) {
    throw new Error(JSON.stringify(res));
  }
  // Return original response
  return res.data;
}

async function queryAttestations(attestingTo: string) {
  const response = await makeAttestationRequest("index/attestations", {
    method: "GET",
    params: {
      mode: "onchain", // Data storage location
      schemaId: schemaId,
      attester: attesterWallet.address,
      indexingValue: attestingTo.toLowerCase(),
    },
  });

  console.log("Response", response);

  // Make sure the request was successfully processed.
  if (!response.success) {
    return {
      success: false,
      message: response?.message ?? "Attestation query failed.",
    };
  }

  // Return a message if no attestations are found.
  if (response.data?.total === 0) {
    return {
      success: false,
      message: "No attestation for this address found.",
    };
  }

  // Return all attestations that match our query.
  return {
    success: true,
    attestations: response.data.rows,
  };
}

export { createSchema, createNotaryAttestation, queryAttestations };
