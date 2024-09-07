/*
 * Please refer to https://docs.envio.dev for a thorough guide on all Envio indexer features
 */
import {
  CoolBets,
  CoolBets_ProposalCreated,
  CoolBets_ProposalFinalized,
  CoolBets_RewardReceivedUser,
  CoolBets_RewardsDistributed,
  CoolBets_VotePlaced,
} from "generated";

CoolBets.ProposalCreated.handler(async ({ event, context }) => {
  const entity: CoolBets_ProposalCreated = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    proposalId: event.params.proposalId,
    description: event.params.description,
    option1: event.params.option1,
    option2: event.params.option2,
    deadline: event.params.deadline,
  };

  context.CoolBets_ProposalCreated.set(entity);
});


CoolBets.ProposalFinalized.handler(async ({ event, context }) => {
  const entity: CoolBets_ProposalFinalized = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    proposalId: event.params.proposalId,
    winningOption: event.params.winningOption,
  };

  context.CoolBets_ProposalFinalized.set(entity);
});


CoolBets.RewardReceivedUser.handler(async ({ event, context }) => {
  const entity: CoolBets_RewardReceivedUser = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    user: event.params.user,
    amount: event.params.amount,
  };

  context.CoolBets_RewardReceivedUser.set(entity);
});


CoolBets.RewardsDistributed.handler(async ({ event, context }) => {
  const entity: CoolBets_RewardsDistributed = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    proposalId: event.params.proposalId,
    totalRewards: event.params.totalRewards,
  };

  context.CoolBets_RewardsDistributed.set(entity);
});


CoolBets.VotePlaced.handler(async ({ event, context }) => {
  const entity: CoolBets_VotePlaced = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    proposalId: event.params.proposalId,
    user: event.params.user,
    option: event.params.option,
    amount: event.params.amount,
  };

  context.CoolBets_VotePlaced.set(entity);
});

