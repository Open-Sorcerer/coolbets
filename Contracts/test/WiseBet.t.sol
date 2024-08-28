// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/WiseBet.sol";

contract WiseBetTest is Test {
    WiseBet wiseBet;
    address owner = address(1);
    address whitelistedUser = address(2);
    address nonWhitelistedUser = address(3);
    address voter1 = address(4);
    address voter2 = address(5);

    function setUp() public {
        // Deploy WiseBet contract with owner address
        vm.startPrank(owner);
        wiseBet = new WiseBet(owner);
        // Set up whitelisted users
        wiseBet.setWhitelist(whitelistedUser, true);
        wiseBet.setWhitelist(voter1, true);
        wiseBet.setWhitelist(voter2, true);

        vm.deal(voter1, 100 ether);
        vm.deal(voter2, 100 ether);
        vm.stopPrank();
    }

    function testCreateProposal() public {
        vm.startPrank(whitelistedUser);
        wiseBet.createProposal(
            "Proposal 1",
            "Option A",
            "Option B",
            block.timestamp + 1 days
        );

        // Verify proposal details
        WiseBet.Proposal memory proposal = wiseBet.getProposalsById(0);
        assertEq(proposal.description, "Proposal 1");
        assertEq(proposal.option1, "Option A");
        assertEq(proposal.option2, "Option B");
        assertEq(proposal.deadline, block.timestamp + 1 days);
        assertEq(proposal.option1Votes, 0);
        assertEq(proposal.option2Votes, 0);
        assertEq(proposal.option1Pool, 0);
        assertEq(proposal.option2Pool, 0);
        assertFalse(proposal.isFinalized);
        assertEq(proposal.winningOption, 0);

        vm.stopPrank();
    }

    function testVoting() public {
        vm.startPrank(whitelistedUser);
        wiseBet.createProposal(
            "Proposal 1",
            "Option A",
            "Option B",
            block.timestamp + 1 days
        );
        vm.stopPrank();

        // Voter 1 places a vote for option 1 with 1 ETH
        vm.startPrank(voter1);
        wiseBet.vote{value: 1 ether}(0, 1, 1 ether);
        WiseBet.Proposal memory proposal = wiseBet.getProposalsById(0);
        assertEq(proposal.option1Votes, 1);
        assertEq(proposal.option1Pool, 1 ether);
        assertTrue(wiseBet.getUserVote(0, voter1));
        assertEq(wiseBet.getUserStakeValue(0, voter1), 1 ether);
        vm.stopPrank();

        // Voter 2 places a vote for option 2 with 2 ETH
        vm.startPrank(voter2);
        wiseBet.vote{value: 2 ether}(0, 2, 2 ether);
        proposal = wiseBet.getProposalsById(0);
        assertEq(proposal.option2Votes, 1);
        assertEq(proposal.option2Pool, 2 ether);
        assertTrue(wiseBet.getUserVote(0, voter2));
        assertEq(wiseBet.getUserStakeValue(0, voter2), 2 ether);
        vm.stopPrank();
    }

    function testIncreaseBet() public {
        vm.startPrank(whitelistedUser);
        wiseBet.createProposal(
            "Proposal 1",
            "Option A",
            "Option B",
            block.timestamp + 1 days
        );
        vm.stopPrank();

        vm.startPrank(voter1);
        wiseBet.vote{value: 1 ether}(0, 1, 1 ether);
        wiseBet.increaseBet{value: 0.5 ether}(0, 0.5 ether);

        // Validate increased bet
        WiseBet.Proposal memory proposal = wiseBet.getProposalsById(0);
        assertEq(proposal.option1Pool, 1.5 ether);
        assertEq(wiseBet.getUserStakeValue(0, voter1), 1.5 ether);
        vm.stopPrank();
    }

    function testFinalizeProposal() public {
        vm.startPrank(whitelistedUser);
        wiseBet.createProposal(
            "Proposal 1",
            "Option A",
            "Option B",
            block.timestamp + 1 days
        );
        vm.stopPrank();

        vm.startPrank(voter1);
        wiseBet.vote{value: 1 ether}(0, 1, 1 ether);
        vm.stopPrank();

        // Wait until after deadline
        vm.warp(block.timestamp + 2 days);

        // Finalize proposal as whitelisted user
        vm.startPrank(whitelistedUser);
        wiseBet.finalizeProposal(0, 1);
        WiseBet.Proposal memory proposal = wiseBet.getProposalsById(0);
        assertTrue(proposal.isFinalized);
        assertEq(proposal.winningOption, 1);
        vm.stopPrank();
    }

    function testDistributeRewards() public {
        vm.startPrank(whitelistedUser);
        wiseBet.createProposal(
            "Proposal 1",
            "Option A",
            "Option B",
            block.timestamp + 1 days
        );
        vm.stopPrank();

        vm.deal(voter1, 1 ether);
        vm.deal(voter2, 2 ether);

        vm.startPrank(voter1);
        wiseBet.vote{value: 1 ether}(0, 1, 1 ether);
        vm.stopPrank();

        vm.startPrank(voter2);
        wiseBet.vote{value: 2 ether}(0, 2, 2 ether);
        vm.stopPrank();

        // Fast forward to after the deadline
        vm.warp(block.timestamp + 2 days);

        // Finalize and distribute rewards
        vm.startPrank(whitelistedUser);
        wiseBet.finalizeProposal(0, 1);
        vm.stopPrank();

        // Check rewards are distributed
        assertEq(voter1.balance, 3 ether); // Voter 1 wins the pool
        assertEq(voter2.balance, 0 ether); // Voter 2 loses
    }

    function testCreateProposalRevertNonWhitelisted() public {
        // Try creating a proposal as non-whitelisted user
        vm.startPrank(nonWhitelistedUser);
        vm.expectRevert(
            abi.encodeWithSelector(
                ONLY_WHITELISTED_ADDRESS.selector,
                nonWhitelistedUser
            )
        );
        wiseBet.createProposal(
            "Proposal 1",
            "Option A",
            "Option B",
            block.timestamp + 1 days
        );
        vm.stopPrank();
    }

    function testVoteRevertInvalidOption() public {
        vm.startPrank(whitelistedUser);
        wiseBet.createProposal(
            "Proposal 1",
            "Option A",
            "Option B",
            block.timestamp + 1 days
        );
        vm.stopPrank();

        vm.startPrank(voter1);
        vm.expectRevert(INVAILD_OPTION.selector);
        wiseBet.vote{value: 1 ether}(0, 3, 1 ether);
        vm.stopPrank();
    }

    function testVoteRevertAlreadyVoted() public {
        vm.startPrank(whitelistedUser);
        wiseBet.createProposal(
            "Proposal 1",
            "Option A",
            "Option B",
            block.timestamp + 1 days
        );
        vm.stopPrank();

        vm.startPrank(voter1);
        wiseBet.vote{value: 1 ether}(0, 1, 1 ether);

        vm.expectRevert(USER_HAS_ALREADY_VOTED.selector);
        wiseBet.vote{value: 1 ether}(0, 1, 1 ether);
        vm.stopPrank();
    }

    function testIncreaseBetRevertNotVoted() public {
        vm.startPrank(whitelistedUser);
        wiseBet.createProposal(
            "Proposal 1",
            "Option A",
            "Option B",
            block.timestamp + 1 days
        );
        vm.stopPrank();

        vm.startPrank(voter1);
        vm.expectRevert(USER_HAS_NOT_VOTED.selector);
        wiseBet.increaseBet{value: 1 ether}(0, 1 ether);
        vm.stopPrank();
    }

    function testFinalizeProposalRevertInvalidWinningOption() public {
        vm.startPrank(whitelistedUser);
        wiseBet.createProposal(
            "Proposal 1",
            "Option A",
            "Option B",
            block.timestamp + 1 days
        );
        vm.stopPrank();

        // Fast forward to after the deadline
        vm.warp(block.timestamp + 2 days);

        vm.startPrank(whitelistedUser);
        vm.expectRevert(INVAILD_WINNING_OPTION.selector);
        wiseBet.finalizeProposal(0, 3); // Invalid winning option
        vm.stopPrank();
    }
}
