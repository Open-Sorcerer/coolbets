// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

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

contract Proposal {
    struct Bet {
        address user;
        uint256 amount;
        uint8 opinion;
        uint256 timestamp;
    }

    address public immutable i_owner;
    string public description;
    string public Opinion1;
    string public Opinion2;
    uint256 public minimumValue;
    uint256 public deadline;
    uint8 public winner;
    bool public isClosed;

    Bet[] public bets;
    mapping(uint8 => uint256) public totalBets;
    mapping(uint8 => uint256) public voteCounts;
    mapping(address => bool) private isWhitelisted;

    event BetPlaced(
        address indexed user,
        uint256 amount,
        uint8 opinion,
        uint256 timestamp
    );
    event WinnerDeclared(uint8 winner);

    ///@notice modifier to check that proposal is still open
    modifier isOpen() {
        if (block.timestamp > deadline) revert PROPOSAL_HAS_ENDED();
        if (isClosed) revert PROPOSAL_IS_CLOSED();
        _;
    }

    ///@notice modifier to check only owner can call the function
    modifier onlyOwner() {
        if (msg.sender != i_owner) revert ONLY_OWNER_CAN_CALL();
        _;
    }

    ///@notice modifier to check only whitelisted addresses can call the function
    modifier onlyWhiteListed() {
        if (!isWhitelisted[msg.sender]) revert ONLY_WHITELISTED_ADDRESS();
        _;
    }

    constructor(
        string memory _description,
        string memory _Opinion1,
        string memory _Opinion2,
        uint256 _minimumValue,
        uint256 _deadline,
        address _owner
    ) {
        description = _description;
        Opinion1 = _Opinion1;
        Opinion2 = _Opinion2;
        minimumValue = _minimumValue;
        deadline = _deadline;
        i_owner = _owner;
    }

    /// @notice function to set whitelisted addresses
    function setWhitelist(address _whitelist, bool _value) external onlyOwner {
        isWhitelisted[_whitelist] = _value;
    }

    /// @notice function to set bet on the proposal
    function placeBet(uint8 _opinion) public payable isOpen {
        if (msg.value < minimumValue) revert SEND_MORE_VALUE();
        if (_opinion != 1 && _opinion != 2) revert INVAILD_OPINION();

        totalBets[_opinion] += msg.value;
        bets.push(Bet(msg.sender, msg.value, _opinion, block.timestamp));
        ++voteCounts[_opinion];

        emit BetPlaced(msg.sender, msg.value, _opinion, block.timestamp);
    }

    ///@notice function to declear winner of the proposal
    function declareWinner(uint8 _winner) public onlyWhiteListed {
        if (_winner != 1 && _winner != 2) revert INVAILD_WINNER();
        if (isClosed) revert PROPOSAL_IS_ALREADY_CLOSED();

        winner = _winner;
        isClosed = true;
        emit WinnerDeclared(_winner);

        distributeFunds();
    }

    /// @notice function to distribute funds
    function distributeFunds() private {
        uint256 totalPool = totalBets[1] + totalBets[2];
        uint256 winnerPool = totalBets[winner];

        for (uint256 i = 0; i < bets.length; i++) {
            if (bets[i].opinion == winner) {
                uint256 reward = (bets[i].amount * totalPool) / winnerPool;
                (bool success, ) = payable(bets[i].user).call{value: reward}(
                    ""
                );
                if (!success) revert VALUE_NOT_TRANSFERED();
            }
        }
    }

    /// -----------------------------//
    //          Getter Function     //
    // ----------------------------- //

    /// @notice function to get total votes for each opinion
    function getVoteCounts()
        public
        view
        returns (uint256 countOpinion1, uint256 countOpinion2)
    {
        return (voteCounts[1], voteCounts[2]);
    }

    ///@notice function to check whether this address is whitelisted or not
    function getWhitelisted(address _user) external view returns (bool) {
        return isWhitelisted[_user];
    }

    /// @notice function to get the winner opinion
    function getWinner() external view returns (uint8) {
        return winner;
    }
}
