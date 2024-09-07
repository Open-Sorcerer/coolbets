// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";

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

contract CoolBetsNFTInteraction is Script {
    address constant COOLBETS_NFT_ADDRESS =
        0xE1486aa7d249cf84Ff532a7dbD424baa50Eb6d29; // Contract address on Base Sepolia

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Start broadcasting transactions
        vm.startBroadcast(deployerPrivateKey);

        ICoolBetsNFT(COOLBETS_NFT_ADDRESS).setWhitelistHook(
            0xF2323D5d9E6903D40e47f80D2ED6785a6C3d7c2B,
            true
        );

        // Stop broadcasting transactions
        vm.stopBroadcast();
    }
}

// forge script script/InteractNft.s.sol --rpc-url $BASE_SEPOLIA_RPC --broadcast
