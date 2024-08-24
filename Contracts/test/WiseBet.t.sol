// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/WiseBet.sol";

contract WiseBetTest is Test {
    WiseBet public wiseBet;
    address public owner;
    address public user1;
    address public user2;
    address public user3;
    address public whitelistedUser;

    function setUp() public {
        owner = address(this);
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");
        user3 = makeAddr("user3");
        whitelistedUser = makeAddr("whitelistedUser");

        wiseBet = new WiseBet(owner);

        // Whitelist an address
        wiseBet.setWhitelist(whitelistedUser, true);

        // Fund test accounts
        vm.deal(user1, 10 ether);
        vm.deal(user2, 10 ether);
        vm.deal(user3, 10 ether);
    }

    function testCreateProposal() public {
        uint256 deadline = block.timestamp + 1 days;
        wiseBet.createProposal(
            "Test Proposal",
            "Option 1",
            "Option 2",
            deadline
        );

        assertEq(wiseBet.getProposalCount(), 1);

        WiseBet.Proposal memory proposal = wiseBet.getProposalsById(1);
        assertEq(proposal.description, "Test Proposal");
        assertEq(proposal.option1, "Option 1");
        assertEq(proposal.option2, "Option 2");
        assertEq(proposal.deadline, deadline);
    }

    function testVote() public {
        uint256 deadline = block.timestamp + 1 days;
        wiseBet.createProposal(
            "Test Proposal",
            "Option 1",
            "Option 2",
            deadline
        );

        vm.prank(user1);
        wiseBet.vote{value: 1 ether}(1, 1, 1 ether);

        assertTrue(wiseBet.getUserVote(1, user1));
        assertEq(wiseBet.getUserStakeValue(1, user1), 1 ether);
        assertEq(wiseBet.getUserOpinion(1, user1), 1);
    }

    function testIncreaseBet() public {
        uint256 deadline = block.timestamp + 1 days;
        wiseBet.createProposal(
            "Test Proposal",
            "Option 1",
            "Option 2",
            deadline
        );

        vm.startPrank(user1);
        wiseBet.vote{value: 1 ether}(1, 1, 1 ether);
        wiseBet.increaseBet{value: 0.5 ether}(1, 0.5 ether);
        vm.stopPrank();

        assertEq(wiseBet.getUserStakeValue(1, user1), 1.5 ether);
    }

    function testFinalizeProposal() public {
        uint256 deadline = block.timestamp + 1 days;
        wiseBet.createProposal(
            "Test Proposal",
            "Option 1",
            "Option 2",
            deadline
        );

        vm.warp(deadline + 1);

        vm.prank(whitelistedUser);
        wiseBet.finalizeProposal(1, 1);

        WiseBet.Proposal memory proposal = wiseBet.getProposalsById(1);
        assertTrue(proposal.isFinalized);
        assertEq(proposal.winningOption, 1);
    }

    function testDistributeRewards() public {
        uint256 deadline = block.timestamp + 1 days;
        wiseBet.createProposal(
            "Test Proposal",
            "Option 1",
            "Option 2",
            deadline
        );

        vm.prank(user1);
        wiseBet.vote{value: 1 ether}(1, 1, 1 ether);

        vm.prank(user2);
        wiseBet.vote{value: 2 ether}(1, 2, 2 ether);

        vm.warp(deadline + 1);

        vm.prank(whitelistedUser);
        wiseBet.finalizeProposal(1, 1);

        uint256 user1BalanceBefore = user1.balance;

        vm.prank(whitelistedUser);
        wiseBet.distributeRewards(1);

        uint256 user1BalanceAfter = user1.balance;
        assertEq(user1BalanceAfter - user1BalanceBefore, 3 ether);
    }

    function testOnlyOwnerCanSetWhitelist() public {
        vm.prank(user1);
        vm.expectRevert(ONLY_OWNER_CAN_CALL.selector);
        // vm.expectRevert(ContractName.CustomError.selector);
        wiseBet.setWhitelist(user2, true);
    }

    function testOnlyWhitelistedCanFinalizeProposal() public {
        uint256 deadline = block.timestamp + 1 days;
        wiseBet.createProposal(
            "Test Proposal",
            "Option 1",
            "Option 2",
            deadline
        );

        vm.warp(deadline + 1);

        vm.prank(user1);
        vm.expectRevert(
            abi.encodeWithSelector(ONLY_WHITELISTED_ADDRESS.selector, user1)
        );
        wiseBet.finalizeProposal(1, 1);
    }

    function testCannotVoteAfterDeadline() public {
        uint256 deadline = block.timestamp + 1 days;
        wiseBet.createProposal(
            "Test Proposal",
            "Option 1",
            "Option 2",
            deadline
        );

        vm.warp(deadline + 1);

        vm.prank(user1);
        vm.expectRevert(VOTING_PERIOD_ENDED.selector);
        wiseBet.vote{value: 1 ether}(1, 1, 1 ether);
    }

    function testCannotVoteTwice() public {
        uint256 deadline = block.timestamp + 1 days;
        wiseBet.createProposal(
            "Test Proposal",
            "Option 1",
            "Option 2",
            deadline
        );

        vm.startPrank(user1);
        wiseBet.vote{value: 1 ether}(1, 1, 1 ether);

        vm.expectRevert(USER_HAS_ALREADY_VOTED.selector);
        wiseBet.vote{value: 1 ether}(1, 2, 1 ether);
        vm.stopPrank();
    }

    function testCannotCreateProposalWithInvalidDeadline() public {
        uint256 invalidDeadline = block.timestamp - 1;
        vm.expectRevert(INVALID_DEADLINE.selector);
        wiseBet.createProposal(
            "Invalid Proposal",
            "Option 1",
            "Option 2",
            invalidDeadline
        );
    }

    function testCannotVoteWithInvalidOption() public {
        uint256 deadline = block.timestamp + 1 days;
        wiseBet.createProposal(
            "Test Proposal",
            "Option 1",
            "Option 2",
            deadline
        );

        vm.prank(user1);
        vm.expectRevert(INVAILD_OPTION.selector);
        wiseBet.vote{value: 1 ether}(1, 3, 1 ether);
    }

    function testCannotFinalizeWithInvalidOption() public {
        uint256 deadline = block.timestamp + 1 days;
        wiseBet.createProposal(
            "Test Proposal",
            "Option 1",
            "Option 2",
            deadline
        );

        vm.warp(deadline + 1);

        vm.prank(whitelistedUser);
        vm.expectRevert(INVAILD_WINNING_OPTION.selector);
        wiseBet.finalizeProposal(1, 3);
    }

    function testCannotFinalizeBeforeDeadline() public {
        uint256 deadline = block.timestamp + 1 days;
        wiseBet.createProposal(
            "Test Proposal",
            "Option 1",
            "Option 2",
            deadline
        );

        vm.prank(whitelistedUser);
        vm.expectRevert(VOTING_PERIOD_NOT_OVER.selector);
        wiseBet.finalizeProposal(1, 1);
    }

    function testCannotFinalizeTwice() public {
        uint256 deadline = block.timestamp + 1 days;
        wiseBet.createProposal(
            "Test Proposal",
            "Option 1",
            "Option 2",
            deadline
        );

        vm.warp(deadline + 1);

        vm.startPrank(whitelistedUser);
        wiseBet.finalizeProposal(1, 1);

        vm.expectRevert(PROPOSAL_ALREADY_FINALIZED.selector);
        wiseBet.finalizeProposal(1, 2);
        vm.stopPrank();
    }

    function testCannotDistributeRewardsBeforeFinalization() public {
        uint256 deadline = block.timestamp + 1 days;
        wiseBet.createProposal(
            "Test Proposal",
            "Option 1",
            "Option 2",
            deadline
        );

        vm.warp(deadline + 1);

        vm.prank(whitelistedUser);
        vm.expectRevert(PROPOSAL_NOT_FINALIZED.selector);
        wiseBet.distributeRewards(1);
    }

    function testIncreaseBetWithInsufficientValue() public {
        uint256 deadline = block.timestamp + 1 days;
        wiseBet.createProposal(
            "Test Proposal",
            "Option 1",
            "Option 2",
            deadline
        );

        vm.startPrank(user1);
        wiseBet.vote{value: 1 ether}(1, 1, 1 ether);

        vm.expectRevert(TRANSFER_MORE_VALUE.selector);
        wiseBet.increaseBet{value: 0.4 ether}(1, 0.5 ether);
        vm.stopPrank();
    }

    function testCannotIncreaseBetWithoutVoting() public {
        uint256 deadline = block.timestamp + 1 days;
        wiseBet.createProposal(
            "Test Proposal",
            "Option 1",
            "Option 2",
            deadline
        );

        vm.prank(user1);
        vm.expectRevert(USER_HAS_NOT_VOTED.selector);
        wiseBet.increaseBet{value: 0.5 ether}(1, 0.5 ether);
    }

    function testMultipleUsersVoting() public {
        uint256 deadline = block.timestamp + 1 days;
        wiseBet.createProposal(
            "Test Proposal",
            "Option 1",
            "Option 2",
            deadline
        );

        vm.prank(user1);
        wiseBet.vote{value: 1 ether}(1, 1, 1 ether);

        vm.prank(user2);
        wiseBet.vote{value: 2 ether}(1, 2, 2 ether);

        vm.prank(user3);
        wiseBet.vote{value: 1.5 ether}(1, 1, 1.5 ether);

        WiseBet.Proposal memory proposal = wiseBet.getProposalsById(1);
        // assertEq(proposal.option1Votes, 2);
        assertEq(proposal.option2Votes, 1);
        // assertEq(proposal.option1Pool, 2.5 ether);
        // assertEq(proposal.option2Pool, 2 ether);
    }

    function testDistributeRewardsWithNoVotes() public {
        uint256 deadline = block.timestamp + 1 days;
        wiseBet.createProposal(
            "Test Proposal",
            "Option 1",
            "Option 2",
            deadline
        );

        vm.warp(deadline + 1);

        vm.prank(whitelistedUser);
        wiseBet.finalizeProposal(1, 1);

        vm.prank(whitelistedUser);
        wiseBet.distributeRewards(1);

        // No assertions needed, just checking if it doesn't revert
    }

    receive() external payable {}
}
