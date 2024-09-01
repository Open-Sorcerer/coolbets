// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import {WhitelistHook} from "../src/WhitelistHook.sol";
import {CoolBetsNFT} from "../src/CoolBetsNFT.sol";

contract DeployWhitelistHook is Script {
    function run() external {
        // Retrieve the private key from the environment variable
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address owner = 0xFB2c923ABcCa1C5a411Bfb487c4984dcB4A2d8F6;

        // Start broadcasting transactions
        vm.startBroadcast(deployerPrivateKey);

        // Deploy the CoolBetsNFT contract
        CoolBetsNFT coolBetsNFT = new CoolBetsNFT(
            "Cool Bets NFT",
            "CBET",
            owner
        );

        // Log the address of the deployed coolBetsNFT contract
        console.log("CoolBetsNFT deployed at:", address(coolBetsNFT));

        // Deploy the WhitelistHook contract
        WhitelistHook whitelistHook = new WhitelistHook(address(coolBetsNFT));

        // Stop broadcasting transactions
        vm.stopBroadcast();

        // Log the address of the deployed WhitelistHook contract
        console.log("WhitelistHook deployed at:", address(whitelistHook));
    }
}

// forge script script/WhitelistHook.s.sol --rpc-url $ROOTSTOCK_TESTNETWORK_RPC_URL --broadcast --legacy
// forge script script/WhitelistHook.s.sol --rpc-url $CHILIZ_TESTNETWORK_RPC_URL --broadcast
// forge script script/WhitelistHook.s.sol --rpc-url $MORPHL2_HOLESKY_RPC_URL --broadcast --legacy

// forge script script/WhitelistHook.s.sol --rpc-url $BASE_SEPOLIA_RPC --broadcast --verify --etherscan-api-key $BASE_API_KEY

// forge deploy --chain-id 11135 --rpc-url https://sepolia-base-rpc.optimism.io/ --private-key <YOUR_PRIVATE_KEY> --etherscan-api-key <YOUR_ETHERSCAN_API_KEY>
