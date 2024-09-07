import { baseSepolia, morphHolesky, rootstockTestnet, spicy } from "viem/chains";

export const coolBetContracts = {
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

export const ABI = [
  {
    inputs: [],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    inputs: [],
    name: "INVAILD_OPTION",
    type: "error",
  },
  {
    inputs: [],
    name: "INVAILD_WINNING_OPTION",
    type: "error",
  },
  {
    inputs: [],
    name: "INVALID_DEADLINE",
    type: "error",
  },
  {
    inputs: [],
    name: "ONLY_OWNER_CAN_CALL",
    type: "error",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "caller",
        type: "address",
      },
    ],
    name: "ONLY_WHITELISTED_ADDRESS",
    type: "error",
  },
  {
    inputs: [],
    name: "PROPOSAL_ALREADY_FINALIZED",
    type: "error",
  },
  {
    inputs: [],
    name: "PROPOSAL_NOT_FINALIZED",
    type: "error",
  },
  {
    inputs: [],
    name: "TRANSFER_MORE_VALUE",
    type: "error",
  },
  {
    inputs: [],
    name: "USER_HAS_ALREADY_VOTED",
    type: "error",
  },
  {
    inputs: [],
    name: "USER_HAS_NOT_VOTED",
    type: "error",
  },
  {
    inputs: [],
    name: "VALUE_NOT_TRANSFERED",
    type: "error",
  },
  {
    inputs: [],
    name: "VOTING_PERIOD_ENDED",
    type: "error",
  },
  {
    inputs: [],
    name: "VOTING_PERIOD_NOT_OVER",
    type: "error",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "uint256",
        name: "proposalId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "string",
        name: "description",
        type: "string",
      },
      {
        indexed: false,
        internalType: "string",
        name: "option1",
        type: "string",
      },
      {
        indexed: false,
        internalType: "string",
        name: "option2",
        type: "string",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "deadline",
        type: "uint256",
      },
    ],
    name: "ProposalCreated",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "uint256",
        name: "proposalId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "winningOption",
        type: "uint256",
      },
    ],
    name: "ProposalFinalized",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "user",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "RewardReceivedUser",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "uint256",
        name: "proposalId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "totalRewards",
        type: "uint256",
      },
    ],
    name: "RewardsDistributed",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "uint256",
        name: "proposalId",
        type: "uint256",
      },
      {
        indexed: true,
        internalType: "address",
        name: "user",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "option",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "VotePlaced",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "string",
        name: "_description",
        type: "string",
      },
      {
        internalType: "string",
        name: "_option1",
        type: "string",
      },
      {
        internalType: "string",
        name: "_option2",
        type: "string",
      },
      {
        internalType: "uint256",
        name: "_deadline",
        type: "uint256",
      },
    ],
    name: "createProposal",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_proposalId",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_winningOption",
        type: "uint256",
      },
    ],
    name: "finalizeProposal",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "getOwner",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getProposalCount",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_id",
        type: "uint256",
      },
    ],
    name: "getProposalsById",
    outputs: [
      {
        components: [
          {
            internalType: "string",
            name: "description",
            type: "string",
          },
          {
            internalType: "string",
            name: "option1",
            type: "string",
          },
          {
            internalType: "string",
            name: "option2",
            type: "string",
          },
          {
            internalType: "uint256",
            name: "deadline",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "option1Votes",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "option2Votes",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "option1Pool",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "option2Pool",
            type: "uint256",
          },
          {
            internalType: "bool",
            name: "isFinalized",
            type: "bool",
          },
          {
            internalType: "uint256",
            name: "winningOption",
            type: "uint256",
          },
        ],
        internalType: "struct CoolBets.Proposal",
        name: "",
        type: "tuple",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_id",
        type: "uint256",
      },
      {
        internalType: "address",
        name: "_user",
        type: "address",
      },
    ],
    name: "getUserOpinion",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_proposalId",
        type: "uint256",
      },
      {
        internalType: "address",
        name: "_user",
        type: "address",
      },
    ],
    name: "getUserStakeValue",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_proposalId",
        type: "uint256",
      },
      {
        internalType: "address",
        name: "_user",
        type: "address",
      },
    ],
    name: "getUserVote",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_user",
        type: "address",
      },
    ],
    name: "getWhitelisted",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_proposalId",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_amount",
        type: "uint256",
      },
    ],
    name: "increaseBet",
    outputs: [],
    stateMutability: "payable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_whitelist",
        type: "address",
      },
      {
        internalType: "bool",
        name: "_value",
        type: "bool",
      },
    ],
    name: "setWhitelist",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_proposalId",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_option",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_amount",
        type: "uint256",
      },
    ],
    name: "vote",
    outputs: [],
    stateMutability: "payable",
    type: "function",
  },
];
