// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/BetFactory.sol";

contract BetFactoryTest is Test {
    BetFactory public betFactory;
    address public owner;
    address public user1;
    address public user2;
    address public user3;
    address public whitelistedUser;

    function setUp() public {
        owner = address(this);
        user1 = address(0x1);
        user2 = address(0x2);
        user3 = address(0x3);
        whitelistedUser = address(0x4);

        betFactory = new BetFactory();
    }

    function testCreateProposal() public {
        string memory description = "Test Proposal";
        string memory opinion1 = "Yes";
        string memory opinion2 = "No";
        uint256 minimumValue = 1 ether;
        uint256 deadline = block.timestamp + 1 days;

        betFactory.createProposal(
            description,
            opinion1,
            opinion2,
            minimumValue,
            deadline
        );

        assertEq(betFactory.proposalCount(), 1);

        address[] memory proposals = betFactory.getAllProposals();
        assertEq(proposals.length, 1);

        Proposal proposal = Proposal(proposals[0]);
        assertEq(proposal.description(), description);
        assertEq(proposal.Opinion1(), opinion1);
        assertEq(proposal.Opinion2(), opinion2);
        assertEq(proposal.minimumValue(), minimumValue);
        assertEq(proposal.deadline(), deadline);
    }

    function testPlaceBet() public {
        // Create a proposal
        betFactory.createProposal(
            "Test Proposal",
            "Yes",
            "No",
            1 ether,
            block.timestamp + 1 days
        );
        address[] memory proposals = betFactory.getAllProposals();
        Proposal proposal = Proposal(proposals[0]);

        // Place bets
        vm.deal(user1, 2 ether);
        vm.prank(user1);
        proposal.placeBet{value: 1 ether}(1);

        vm.deal(user2, 2 ether);
        vm.prank(user2);
        proposal.placeBet{value: 1 ether}(2);

        (uint256 countOpinion1, uint256 countOpinion2) = proposal
            .getVoteCounts();
        assertEq(countOpinion1, 1);
        assertEq(countOpinion2, 1);
    }

    function testDeclareWinner() public {
        // Create a proposal
        betFactory.createProposal(
            "Test Proposal",
            "Yes",
            "No",
            1 ether,
            block.timestamp + 1 days
        );
        address[] memory proposals = betFactory.getAllProposals();
        Proposal proposal = Proposal(proposals[0]);

        // Place bets
        vm.deal(user1, 2 ether);
        vm.prank(user1);
        proposal.placeBet{value: 1 ether}(1);

        vm.deal(user2, 2 ether);
        vm.prank(user2);
        proposal.placeBet{value: 1 ether}(2);

        // Whitelist an address
        proposal.setWhitelist(whitelistedUser, true);

        // Declare winner
        vm.prank(whitelistedUser);
        proposal.declareWinner(1);

        assertEq(proposal.getWinner(), 1);
        assertTrue(proposal.isClosed());

        // Check if funds are distributed correctly
        assertEq(user1.balance, 3 ether);
        assertEq(user2.balance, 1 ether);
    }

    function testFailNonOwnerCreateProposal() public {
        vm.prank(user1);
        // vm.expectRevert(ONLY_OWNER_CAN_CALL.selector);
        vm.expectRevert(ONLY_OWNER_CAN_CALL.selector);
        betFactory.createProposal(
            "Test Proposal",
            "Yes",
            "No",
            1 ether,
            block.timestamp + 1 days
        );
    }

    function testFailPlaceBetAfterDeadline() public {
        betFactory.createProposal(
            "Test Proposal",
            "Yes",
            "No",
            1 ether,
            block.timestamp + 1 days
        );
        address[] memory proposals = betFactory.getAllProposals();
        Proposal proposal = Proposal(proposals[0]);

        // Warp time to after the deadline
        vm.warp(block.timestamp + 2 days);

        vm.deal(user1, 2 ether);
        vm.prank(user1);
        vm.expectRevert(PROPOSAL_HAS_ENDED.selector);
        proposal.placeBet{value: 1 ether}(1);
    }

    function testFailDeclareWinnerNonWhitelisted() public {
        betFactory.createProposal(
            "Test Proposal",
            "Yes",
            "No",
            1 ether,
            block.timestamp + 1 days
        );
        address[] memory proposals = betFactory.getAllProposals();
        Proposal proposal = Proposal(proposals[0]);

        vm.prank(user1);
        vm.expectRevert(ONLY_WHITELISTED_ADDRESS.selector);

        proposal.declareWinner(1);
    }

    function testMultipleProposals() public {
        betFactory.createProposal(
            "Proposal 1",
            "Yes",
            "No",
            1 ether,
            block.timestamp + 1 days
        );
        betFactory.createProposal(
            "Proposal 2",
            "Agree",
            "Disagree",
            0.5 ether,
            block.timestamp + 2 days
        );
        betFactory.createProposal(
            "Proposal 3",
            "For",
            "Against",
            2 ether,
            block.timestamp + 3 days
        );

        assertEq(betFactory.proposalCount(), 3);

        address[] memory proposals = betFactory.getAllProposals();
        assertEq(proposals.length, 3);

        Proposal proposal1 = Proposal(proposals[0]);
        Proposal proposal2 = Proposal(proposals[1]);
        Proposal proposal3 = Proposal(proposals[2]);

        assertEq(proposal1.description(), "Proposal 1");
        assertEq(proposal2.description(), "Proposal 2");
        assertEq(proposal3.description(), "Proposal 3");
    }

    function testGetVoteCountsFromBetFactory() public {
        betFactory.createProposal(
            "Test Proposal",
            "Yes",
            "No",
            1 ether,
            block.timestamp + 1 days
        );

        address[] memory proposals = betFactory.getAllProposals();
        Proposal proposal = Proposal(proposals[0]);

        vm.deal(user1, 2 ether);
        vm.prank(user1);
        proposal.placeBet{value: 1 ether}(1);

        vm.deal(user2, 2 ether);
        vm.prank(user2);
        proposal.placeBet{value: 1 ether}(2);

        (uint256 countOpinion1, uint256 countOpinion2) = betFactory
            .getVoteCounts(0);
        assertEq(countOpinion1, 1);
        assertEq(countOpinion2, 1);
    }

    function testFailGetVoteCountsInvalidProposal() public {
        vm.expectRevert(PROPOSAL_NOT_EXIST.selector);
        betFactory.getVoteCounts(1);
    }

    function testPlaceBetWithDifferentAmounts() public {
        betFactory.createProposal(
            "Test Proposal",
            "Yes",
            "No",
            0.5 ether,
            block.timestamp + 1 days
        );
        address[] memory proposals = betFactory.getAllProposals();
        Proposal proposal = Proposal(proposals[0]);

        vm.deal(user1, 3 ether);
        vm.prank(user1);
        proposal.placeBet{value: 1 ether}(1);

        vm.deal(user2, 3 ether);
        vm.prank(user2);
        proposal.placeBet{value: 2 ether}(2);

        (uint256 countOpinion1, uint256 countOpinion2) = proposal
            .getVoteCounts();
        assertEq(countOpinion1, 1);
        assertEq(countOpinion2, 1);

        // Check total bets
        assertEq(proposal.totalBets(1), 1 ether);
        assertEq(proposal.totalBets(2), 2 ether);
    }

    function testFailPlaceBetBelowMinimumValue() public {
        betFactory.createProposal(
            "Test Proposal",
            "Yes",
            "No",
            1 ether,
            block.timestamp + 1 days
        );
        address[] memory proposals = betFactory.getAllProposals();
        Proposal proposal = Proposal(proposals[0]);

        vm.deal(user1, 2 ether);
        vm.prank(user1);
        vm.expectRevert(SEND_MORE_VALUE.selector);
        proposal.placeBet{value: 0.5 ether}(1);
    }

    function testFailPlaceBetInvalidOpinion() public {
        betFactory.createProposal(
            "Test Proposal",
            "Yes",
            "No",
            1 ether,
            block.timestamp + 1 days
        );
        address[] memory proposals = betFactory.getAllProposals();
        Proposal proposal = Proposal(proposals[0]);

        vm.deal(user1, 2 ether);
        vm.prank(user1);
        vm.expectRevert(INVAILD_OPINION.selector);
        proposal.placeBet{value: 1 ether}(3);
    }

    function testDeclareWinnerWithMultipleBets() public {
        betFactory.createProposal(
            "Test Proposal",
            "Yes",
            "No",
            1 ether,
            block.timestamp + 1 days
        );
        address[] memory proposals = betFactory.getAllProposals();
        Proposal proposal = Proposal(proposals[0]);

        // Place bets
        vm.deal(user1, 1 ether);
        vm.prank(user1);
        proposal.placeBet{value: 1 ether}(1);

        vm.deal(user2, 1 ether);
        vm.prank(user2);
        proposal.placeBet{value: 1 ether}(2);

        vm.deal(user3, 1 ether);
        vm.prank(user3);
        proposal.placeBet{value: 1 ether}(1);

        // Whitelist an address and declare winner
        proposal.setWhitelist(whitelistedUser, true);
        vm.prank(whitelistedUser);
        proposal.declareWinner(1);

        // Check if funds are distributed correctly
        assertEq(user1.balance, 1.5 ether);
        assertEq(user2.balance, 0 ether);
        assertEq(user3.balance, 1.5 ether);
    }

    function testFailDeclareWinnerTwice() public {
        betFactory.createProposal(
            "Test Proposal",
            "Yes",
            "No",
            1 ether,
            block.timestamp + 1 days
        );
        address[] memory proposals = betFactory.getAllProposals();
        Proposal proposal = Proposal(proposals[0]);

        proposal.setWhitelist(whitelistedUser, true);
        vm.prank(whitelistedUser);
        proposal.declareWinner(1);

        vm.prank(whitelistedUser);
        vm.expectRevert(PROPOSAL_IS_ALREADY_CLOSED.selector);
        proposal.declareWinner(2);
    }

    function testWhitelistManagement() public {
        betFactory.createProposal(
            "Test Proposal",
            "Yes",
            "No",
            1 ether,
            block.timestamp + 1 days
        );
        address[] memory proposals = betFactory.getAllProposals();
        Proposal proposal = Proposal(proposals[0]);

        // Set whitelist
        proposal.setWhitelist(whitelistedUser, true);
        assertTrue(proposal.getWhitelisted(whitelistedUser));

        // Remove from whitelist
        proposal.setWhitelist(whitelistedUser, false);
        assertFalse(proposal.getWhitelisted(whitelistedUser));
    }

    function testFailNonOwnerSetWhitelist() public {
        betFactory.createProposal(
            "Test Proposal",
            "Yes",
            "No",
            1 ether,
            block.timestamp + 1 days
        );
        address[] memory proposals = betFactory.getAllProposals();
        Proposal proposal = Proposal(proposals[0]);

        vm.prank(user1);
        vm.expectRevert(ONLY_OWNER_CAN_CALL.selector);
        proposal.setWhitelist(whitelistedUser, true);
    }
}
