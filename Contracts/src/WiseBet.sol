// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";

error INVALID_DEADLINE();
error ONLY_OWNER_CAN_CALL();
error VOTING_PERIOD_ENDED();
error INVAILD_OPTION();
error INVAILD_WINNING_OPTION();
error USER_HAS_ALREADY_VOTED();
error TRANSFER_MORE_VALUE();
error USER_HAS_NOT_VOTED();
error VOTING_PERIOD_NOT_OVER();
error PROPOSAL_ALREADY_FINALIZED();
error PROPOSAL_NOT_FINALIZED();
error VALUE_NOT_TRANSFERED();
error ONLY_WHITELISTED_ADDRESS(address caller);

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
    mapping(address => bool) private isWhitelisted;

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

    modifier onlyWhiteListed() {
        if (!isWhitelisted[msg.sender])
            revert ONLY_WHITELISTED_ADDRESS(msg.sender);
        _;
    }

    constructor(address _owner) {
        i_owner = _owner;
    }

    /// @notice function to set whitelisted addresses
    function setWhitelist(address _whitelist, bool _value) external onlyOwner {
        isWhitelisted[_whitelist] = _value;
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
    ) external onlyWhiteListed {
        if (_deadline <= block.timestamp) revert INVALID_DEADLINE();
        Proposal storage newProposal = proposals[proposalCount];

        newProposal.description = _description;
        newProposal.option1 = _option1;
        newProposal.option2 = _option2;
        newProposal.deadline = _deadline;
        newProposal.option1Votes = 0;
        newProposal.option2Votes = 0;
        newProposal.option1Pool = 0;
        newProposal.option2Pool = 0;
        newProposal.isFinalized = false;
        newProposal.winningOption = 0;

        emit ProposalCreated(
            proposalCount,
            _description,
            _option1,
            _option2,
            _deadline
        );
        ++proposalCount;
    }

    /// @notice function to call by user to vote on the proposal
    function vote(
        uint256 _proposalId,
        uint256 _option,
        uint256 _amount
    ) external payable {
        if (_amount > msg.value) revert TRANSFER_MORE_VALUE();

        Proposal storage proposal = proposals[_proposalId];

        if (block.timestamp > proposal.deadline) revert VOTING_PERIOD_ENDED();
        if (_option != 1 && _option != 2) revert INVAILD_OPTION();
        if (userVoted[_proposalId][msg.sender]) revert USER_HAS_ALREADY_VOTED();

        userVoted[_proposalId][msg.sender] = true;
        userStakes[_proposalId][msg.sender] = _amount;
        userOpinionSelected[_proposalId][msg.sender] = _option;

        if (_option == 1) {
            ++proposal.option1Votes;
            console.log("value of option1Votes", proposal.option1Votes);
            proposal.option1Pool += _amount;
            console.log("value of option1Pool", proposal.option1Pool);
            option1Users.push(msg.sender);
        } else {
            proposal.option2Votes += 1;
            console.log("value of option2Votes", proposal.option2Votes);
            proposal.option2Pool += _amount;
            console.log("value of option2Pool", proposal.option2Pool);
            option2Users.push(msg.sender);
        }

        emit VotePlaced(_proposalId, msg.sender, _option, _amount);
    }

    /// @notice function to call if user wants to increase the bet on already selected opinion
    function increaseBet(
        uint256 _proposalId,
        uint256 _amount
    ) external payable {
        if (_amount > msg.value) revert TRANSFER_MORE_VALUE();
        Proposal storage proposal = proposals[_proposalId];
        if (block.timestamp > proposal.deadline) revert VOTING_PERIOD_ENDED();

        if (!userVoted[_proposalId][msg.sender]) revert USER_HAS_NOT_VOTED();

        userStakes[_proposalId][msg.sender] += _amount;
        uint256 userOption = userOpinionSelected[_proposalId][msg.sender];

        userOption == 1
            ? proposal.option1Pool += _amount
            : proposal.option2Pool += _amount;

        emit VotePlaced(_proposalId, msg.sender, userOption, _amount);
    }

    /// @notice function to decide the winner
    function finalizeProposal(
        uint256 _proposalId,
        uint256 _winningOption
    ) external onlyWhiteListed {
        Proposal storage proposal = proposals[_proposalId];
        if (proposal.deadline > block.timestamp)
            revert VOTING_PERIOD_NOT_OVER();
        if (proposal.isFinalized) revert PROPOSAL_ALREADY_FINALIZED();
        if (_winningOption != 1 && _winningOption != 2)
            revert INVAILD_WINNING_OPTION();

        proposal.isFinalized = true;
        proposal.winningOption = _winningOption;

        emit ProposalFinalized(_proposalId, _winningOption);

        distributeRewards(_proposalId);
    }

    /// @notice function to distribute stake to the winners
    function distributeRewards(uint256 _proposalId) private {
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

                (bool success, ) = payable(user).call{value: userReward}("");
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

    ///@notice function to check whether the user voted or not
    function getUserVote(
        uint256 _proposalId,
        address _user
    ) external view returns (bool) {
        return userVoted[_proposalId][_user];
    }

    /// @notice function to get the stake / bet amount of user
    function getUserStakeValue(
        uint256 _proposalId,
        address _user
    ) external view returns (uint256) {
        return userStakes[_proposalId][_user];
    }

    ///@notice function to get the owner of the contract
    function getOwner() external view returns (address) {
        return i_owner;
    }

    ///@notice function to get the proposal Count
    function getProposalCount() external view returns (uint256) {
        return proposalCount;
    }

    ///@notice function to get Proposal detail by proposal ID
    function getProposalsById(
        uint256 _id
    ) external view returns (Proposal memory) {
        return proposals[_id];
    }

    ///@notice function to get the user opinion
    function getUserOpinion(
        uint256 _id,
        address _user
    ) external view returns (uint256) {
        return userOpinionSelected[_id][_user];
    }

    ///@notice function to check whether this address is whitelisted or not
    function getWhitelisted(address _user) external view returns (bool) {
        return isWhitelisted[_user];
    }
}
