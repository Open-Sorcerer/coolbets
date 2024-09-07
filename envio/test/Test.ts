import assert from "assert";
import { 
  TestHelpers,
  CoolBets_ProposalCreated
} from "generated";
const { MockDb, CoolBets } = TestHelpers;

describe("CoolBets contract ProposalCreated event tests", () => {
  // Create mock db
  const mockDb = MockDb.createMockDb();

  // Creating mock for CoolBets contract ProposalCreated event
  const event = CoolBets.ProposalCreated.createMockEvent({/* It mocks event fields with default values. You can overwrite them if you need */});

  it("CoolBets_ProposalCreated is created correctly", async () => {
    // Processing the event
    const mockDbUpdated = await CoolBets.ProposalCreated.processEvent({
      event,
      mockDb,
    });

    // Getting the actual entity from the mock database
    let actualCoolBetsProposalCreated = mockDbUpdated.entities.CoolBets_ProposalCreated.get(
      `${event.chainId}_${event.block.number}_${event.logIndex}`
    );

    // Creating the expected entity
    const expectedCoolBetsProposalCreated: CoolBets_ProposalCreated = {
      id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
      proposalId: event.params.proposalId,
      description: event.params.description,
      option1: event.params.option1,
      option2: event.params.option2,
      deadline: event.params.deadline,
    };
    // Asserting that the entity in the mock database is the same as the expected entity
    assert.deepEqual(actualCoolBetsProposalCreated, expectedCoolBetsProposalCreated, "Actual CoolBetsProposalCreated should be the same as the expectedCoolBetsProposalCreated");
  });
});
