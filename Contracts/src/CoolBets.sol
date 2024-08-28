// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

error INVAILD_OPTION();

contract CoolBets {
    address public owner;
    uint256 public minimumBet;
    uint256 public totalWinnings;
    uint256 public deadline;
    uint256 public proposalId;

    struct Proposal {
        string description;
        string opinion1;
        string opinion2;
        uint256 votesForOpinion1;
        uint256 votesForOpinion2;
        uint256 deadline;
        mapping(address => uint256) userBets;
    }

    mapping(address => bool) public whitelist;
    mapping(uint256 => Proposal) public proposals;

    constructor(uint256 _minimumBet, uint256 _deadline) {
        owner = msg.sender;
        minimumBet = _minimumBet;
        deadline = _deadline;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    modifier onlyWhitelisted() {
        require(
            whitelist[msg.sender],
            "Only whitelisted addresses can call this function."
        );
        _;
    }

    function addWhitelistAddress(address _address) public onlyOwner {
        whitelist[_address] = true;
    }

    function removeWhitelistAddress(address _address) public onlyOwner {
        whitelist[_address] = false;
    }

    function changeMinimumBet(uint256 _minimumBet) public onlyWhitelisted {
        minimumBet = _minimumBet;
    }

    function createProposal(
        string memory _description,
        string memory _opinion1,
        string memory _opinion2,
        uint256 _deadline
    ) public onlyWhitelisted {
        Proposal storage newProposal = proposals[proposalId];
        newProposal.description = _description;
        newProposal.opinion1 = _opinion1;
        newProposal.opinion2 = _opinion2;
        newProposal.votesForOpinion1 = 0;
        newProposal.votesForOpinion2 = 0;
        newProposal.deadline = _deadline;

        ++proposalId;
    }

    function vote(uint256 _proposalId, uint256 _opinion) public payable {
        if (_opinion != 1 && _opinion != 2) revert INVAILD_OPTION();
        require(whitelist[msg.sender], "Only whitelisted addresses can vote.");
        require(msg.value >= minimumBet, "Minimum bet amount not met.");

        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp < deadline, "Voting period has ended.");

        proposal.userBets[msg.sender] += msg.value;

        // if (_opinion == 1) {
        //     proposal.votesForOpinion1 += msg.value;
        // } else if (_opinion == 2) {
        //     proposal.votesForOpinion2 += msg.value;
        // }

        _opinion == 1
            ? proposal.votesForOpinion1 += msg.value
            : proposal.votesForOpinion2 += msg.value;
    }

    function declareWinner(
        uint256 _proposalId,
        uint256 _winningOpinion
    ) public onlyWhitelisted {
        require(
            block.timestamp >= deadline,
            "Voting period has not ended yet."
        );

        Proposal storage proposal = proposals[_proposalId];
        require(
            _winningOpinion == 1 || _winningOpinion == 2,
            "Invalid winning opinion."
        );

        uint256 totalVotes = proposal.votesForOpinion1 +
            proposal.votesForOpinion2;
        require(totalVotes > 0, "No votes have been cast for this proposal.");

        if (_winningOpinion == 1) {
            totalWinnings = proposal.votesForOpinion2;
        } else {
            totalWinnings = proposal.votesForOpinion1;
        }

        for (uint256 i = 0; i < totalVotes; i++) {
            address user = msg.sender;
            uint256 userBet = proposal.userBets[user];
            uint256 userWinnings = (userBet * totalWinnings) / totalVotes;
            payable(user).transfer(userWinnings);
        }
    }
}
