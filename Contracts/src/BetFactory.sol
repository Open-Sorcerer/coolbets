// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Proposal} from "./Proposal.sol";

error ONLY_OWNER_CAN_CALL();
error PROPOSAL_HAS_ENDED();
error ONLY_WHITELISTED_ADDRESS();
error PROPOSAL_NOT_EXIST();
error PROPOSAL_IS_CLOSED();
error SEND_MORE_VALUE();
error INVAILD_OPINION();
error INVAILD_WINNER();
error PROPOSAL_IS_ALREADY_CLOSED();
error VALUE_NOT_TRANSFERED();

contract BetFactory {
    address public immutable i_owner;
    uint256 public proposalCount;

    mapping(uint256 => address) private proposals;

    event ProposalCreated(uint256 indexed proposalId, address proposalAddress);

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert ONLY_OWNER_CAN_CALL();
        _;
    }

    constructor() {
        i_owner = msg.sender;
    }

    /// @notice function to create new Proposals
    function createProposal(
        string memory _description,
        string memory _Opinion1,
        string memory _Opinion2,
        uint256 _minimumValue,
        uint256 _deadline
    ) public onlyOwner {
        Proposal newProposal = new Proposal(
            _description,
            _Opinion1,
            _Opinion2,
            _minimumValue,
            _deadline,
            msg.sender
        );
        // ++proposalCount;
        proposals[proposalCount] = address(newProposal);
        emit ProposalCreated(proposalCount, address(newProposal));
        ++proposalCount;
    }

    /// @notice function to get address of all the proposals created
    function getAllProposals() public view returns (address[] memory) {
        address[] memory allProposals = new address[](proposalCount);
        for (uint256 i = 0; i < proposalCount; i++) {
            allProposals[i] = proposals[i];
        }
        return allProposals;
    }

    /// @notice function to get votes get on proposals
    function getVoteCounts(
        uint256 proposalId
    ) public view returns (uint256 countOpinion1, uint256 countOpinion2) {
        require(proposalId < proposalCount, "Proposal does not exist");
        // if (proposalId > proposalCount) revert PROPOSAL_NOT_EXIST();
        Proposal proposal = Proposal(proposals[proposalId]);
        return proposal.getVoteCounts();
    }
}
