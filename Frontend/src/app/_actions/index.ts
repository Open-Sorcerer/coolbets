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
