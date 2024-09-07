"use server";

export const getProposals = async () => {
  const graphResponse = await fetch("https://indexer.bigdevenergy.link/8c40956/v1/graphql", {
    method: "POST",
    body: JSON.stringify({
      query: `
        query MyQuery {
          CoolBets_ProposalCreated {
            id
          }
        }
        }
      `,
    }),
  });
  const data = await graphResponse.json();
  return data;
};

export const getProposalsFinalized = async () => {
  const graphResponse = await fetch("https://indexer.bigdevenergy.link/8c40956/v1/graphql", {
    method: "POST",
    body: JSON.stringify({
      query: `
        query MyQuery {
          CoolBets_ProposalFinalized {
            id
          }
        }
      `,
    }),
  });
  const data = await graphResponse.json();
  return data;
};

export const getRewardsDistributed = async () => {
  const graphResponse = await fetch("https://indexer.bigdevenergy.link/8c40956/v1/graphql", {
    method: "POST",
    body: JSON.stringify({
      query: `
        query MyQuery {
          CoolBets_RewardsDistributed {
            id
          }
        }
      `,
    }),
  });
  const data = await graphResponse.json();
  return data;
};

export const getVotesPlaced = async () => {
  const graphResponse = await fetch("https://indexer.bigdevenergy.link/8c40956/v1/graphql", {
    method: "POST",
    body: JSON.stringify({
      query: `
        query MyQuery {
  CoolBets_VotePlaced {
            id
            }
        }
      `,
    }),
  });
  const data = await graphResponse.json();
  return data;
};

export const getRewardsClaimed = async () => {
  const graphResponse = await fetch("https://indexer.bigdevenergy.link/8c40956/v1/graphql", {
    method: "POST",
    body: JSON.stringify({
      query: `
        query MyQuery {
          CoolBets_RewardReceivedUser {
            id
            }
            }
        }
      `,
    }),
  });
  const data = await graphResponse.json();
  return data;
};
