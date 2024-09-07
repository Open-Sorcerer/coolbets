// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";

interface IWhitelistHook {
    function didReceiveAttestation(
        address attester,
        uint64 schemaId,
        uint64 attestationId,
        bytes calldata data
    ) external payable;
}

interface ICoolBetsNFT {
    function mintNFT(
        address recipient,
        string memory name,
        uint256 proposalId,
        uint256 opinion,
        uint256 betAmount,
        string memory imageUrl
    ) external;

    /// @dev The function to set the whitelist status of the address
    function setWhitelistHook(address _whitelistHook, bool _value) external;
}

// coolBetsNFT.setWhitelistHook(address(whitelistHook), true);

contract WhitelistHookInteraction is Script {
    address constant WHITELIST_HOOK_ADDRESS =
        0xF2323D5d9E6903D40e47f80D2ED6785a6C3d7c2B; // Contract address on Base Sepolia
    address attester = 0xFB2c923ABcCa1C5a411Bfb487c4984dcB4A2d8F6; // Replace with the attester address
    uint64 schemaId = 1; // Example schemaId
    uint64 attestationId = 1; // Example attestationId

    // Prepare data for minting
    address recipient = 0xFB2c923ABcCa1C5a411Bfb487c4984dcB4A2d8F6;
    string name = "Cool Bet #1";
    uint256 proposalId = 123;
    uint256 opinion = 1;
    uint256 betAmount = 1000;
    string imageUrl = "https://example.com/nft.png";

    function run() external {
        // Encode data for mintNFT
        bytes memory data = abi.encode(
            recipient,
            name,
            proposalId,
            opinion,
            betAmount,
            imageUrl
        );

        console.logBytes(data);

        // uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // // Start broadcasting transactions
        // vm.startBroadcast(deployerPrivateKey);

        // IWhitelistHook(WHITELIST_HOOK_ADDRESS).didReceiveAttestation{
        //     value: 0.000000001 ether
        // }(attester, schemaId, attestationId, data);

        // vm.stopBroadcast();
    }
}

// forge script script/InteractWhitelistHook.s.sol --rpc-url $BASE_SEPOLIA_RPC --broadcast

// data


// 0x000000000000000000000000fb2c923abcca1c5a411bfb487c4984dcb4a2d8f600000000000000000000000000000000000000000000000000000000000000c0000000000000000000000000000000000000000000000000000000000000007b000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000003e80000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000b436f6f6c20426574202331000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001b68747470733a2f2f6578616d706c652e636f6d2f6e66742e706e670000000000