// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

error INVALID_DEADLINE();
error VOTING_PERIOD_ENDED();
error INVAILD_OPTION();
error INVAILD_WINNING_OPTION();
error USER_HAS_ALREADY_VOTED();
error AMOUNT_IS_LOW();
error USER_HAS_NOT_VOTED();
error ONLY_OWNER_CAN_CALL();
error VOTING_PERIOD_NOT_OVER();
error PROPOSAL_ALREADY_FINALIZED();
error PROPOSAL_NOT_FINALIZED();
error VALUE_NOT_TRANSFERED();

contract WiseBet {
    uint256 private proposalCount;
    address private i_owner;

    struct Proposal {
        string description;
        string option1;
        string option2;
        uint256 deadline;
        uint256 option1Votes;
        uint256 option2Votes;
        uint256 option1Pool;
        uint256 option2Pool;
        bool isFinalized;
        uint256 winningOption;
    }

    address[] private option1Users;
    address[] private option2Users;

    mapping(uint256 => Proposal) private proposals;
    mapping(uint256 => mapping(address => bool)) private userVoted;
    mapping(uint256 => mapping(address => uint256)) private userStakes;
    mapping(uint256 => mapping(address => uint256)) private userOpinionSelected;

    ///  EVENTS ///
    event ProposalCreated(
        uint256 indexed proposalId,
        string description,
        string option1,
        string option2,
        uint256 deadline
    );
    event VotePlaced(
        uint256 indexed proposalId,
        address indexed user,
        uint256 option,
        uint256 amount
    );
    event ProposalFinalized(uint256 indexed proposalId, uint256 winningOption);
    event RewardsDistributed(uint256 indexed proposalId, uint256 totalRewards);
    event RewardReceivedUser(address indexed user, uint256 amount);

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert ONLY_OWNER_CAN_CALL();
        _;
    }

    constructor(address _owner) {
        i_owner = _owner;
    }

    /**
     * @notice function to create Proposal
     * @param _description description of the proposal
     * @param _option1 description of first option
     * @param _option2 description of second option
     * @param _deadline deadline, when proposal will be over
     */
    function createProposal(
        string memory _description,
        string memory _option1,
        string memory _option2,
        uint256 _deadline
    ) external {
        if (_deadline <= block.timestamp) revert INVALID_DEADLINE();
        ++proposalCount;
        proposals[proposalCount] = Proposal(
            _description,
            _option1,
            _option2,
            _deadline,
            0,
            0,
            0,
            0,
            false,
            0
        );
        emit ProposalCreated(
            proposalCount,
            _description,
            _option1,
            _option2,
            _deadline
        );
    }

    /// @notice function to call by user to vote on the proposal
    function vote(
        uint256 _proposalId,
        uint256 _option,
        uint256 _amount
    ) external payable {
        if (_amount < msg.value) revert AMOUNT_IS_LOW();
        Proposal memory proposal = proposals[_proposalId];
        if (proposal.deadline < block.timestamp) revert VOTING_PERIOD_ENDED();
        if (_option != 1 && _option != 2) revert INVAILD_OPTION();
        if (userVoted[_proposalId][msg.sender]) revert USER_HAS_ALREADY_VOTED();

        userVoted[_proposalId][msg.sender] = true;
        userStakes[_proposalId][msg.sender] = _amount;
        userOpinionSelected[_proposalId][msg.sender] = _option;

        if (_option == 1) {
            ++proposal.option1Votes;
            proposal.option1Pool += _amount;
            option1Users.push(msg.sender);
        } else {
            ++proposal.option2Votes;
            proposal.option2Pool += _amount;
            option2Users.push(msg.sender);
        }

        emit VotePlaced(_proposalId, msg.sender, _option, _amount);
    }

    function increaseBet(
        uint256 _proposalId,
        uint256 _amount
    ) external payable {
        if (_amount < msg.value) revert AMOUNT_IS_LOW();
        Proposal storage proposal = proposals[_proposalId];
        if (proposal.deadline < block.timestamp) revert VOTING_PERIOD_ENDED();

        if (!userVoted[_proposalId][msg.sender]) revert USER_HAS_NOT_VOTED();

        userStakes[_proposalId][msg.sender] += _amount;
        uint256 userOption = userOpinionSelected[_proposalId][msg.sender];

        if (userOption == 1) {
            proposal.option1Pool += _amount;
        } else {
            proposal.option2Pool += _amount;
        }

        emit VotePlaced(_proposalId, msg.sender, userOption, _amount);
    }

    /// @notice function to decide the winner
    function finalizeProposal(
        uint256 _proposalId,
        uint256 _winningOption
    ) external onlyOwner {
        Proposal storage proposal = proposals[_proposalId];
        if (proposal.deadline > block.timestamp)
            revert VOTING_PERIOD_NOT_OVER();
        if (proposal.isFinalized) revert PROPOSAL_ALREADY_FINALIZED();
        if (_winningOption != 1 && _winningOption != 2)
            revert INVAILD_WINNING_OPTION();

        proposal.isFinalized = true;
        proposal.winningOption = _winningOption;

        emit ProposalFinalized(_proposalId, _winningOption);
    }

    function distributeRewards(uint256 _proposalId) external onlyOwner {
        Proposal storage proposal = proposals[_proposalId];

        if (!proposal.isFinalized) revert PROPOSAL_NOT_FINALIZED();

        uint256 totalPool = proposal.option1Pool + proposal.option2Pool;
        uint256 totalRewards;
        address user;
        uint256 userStake;
        uint256 userReward;

        if (proposal.winningOption == 1) {
            for (uint256 i = 0; i < proposal.option1Votes; i++) {
                user = option1Users[i];
                userStake = userStakes[_proposalId][user];
                userReward = (userStake * totalPool) / proposal.option1Pool;
                totalRewards += userReward;

                userStakes[_proposalId][user] = 0;

                emit RewardReceivedUser(user, userReward);

                (bool success, ) = user.call{value: userReward}("");
                if (!success) revert VALUE_NOT_TRANSFERED();
            }
        } else {
            for (uint256 i = 0; i < proposal.option2Votes; i++) {
                user = option2Users[i];
                userStake = userStakes[_proposalId][user];
                userReward = (userStake * totalPool) / proposal.option2Pool;
                totalRewards += userReward;
                userStakes[_proposalId][user] = 0;

                emit RewardReceivedUser(user, userReward);

                (bool success, ) = payable(user).call{value: userReward}("");
                if (!success) revert VALUE_NOT_TRANSFERED();
            }
            emit RewardsDistributed(_proposalId, totalRewards);
        }
    }

    // -------------------------------------//
    //      GETTER FUNCTION                 //
    // -------------------------------------//
    function getUserVote(
        uint256 _proposalId,
        address _user
    ) external view returns (bool) {
        return userVoted[_proposalId][_user];
    }

    function getUserStakeValue(
        uint256 _proposalId,
        address _user
    ) external view returns (uint256) {
        return userStakes[_proposalId][_user];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }

    function getProposalCount() external view returns (uint256) {
        return proposalCount;
    }

    function getProposalsById(
        uint256 id
    ) external view returns (Proposal memory) {
        return proposals[id];
    }

    function getUserOpinion(
        uint256 _id,
        address _user
    ) external view returns (uint256) {
        return userOpinionSelected[_id][_user];
    }
}
