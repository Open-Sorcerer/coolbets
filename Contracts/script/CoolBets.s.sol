// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import {CoolBets} from "../src/CoolBets.sol";

contract DeployCoolBets is Script {
    function run() external {
        // Retrieve the private key from the environment variable
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Start broadcasting transactions
        vm.startBroadcast(deployerPrivateKey);

        // Deploy the CoolBets contract
        CoolBets coolBets = new CoolBets();

        // Stop broadcasting transactions
        vm.stopBroadcast();

        // Log the address of the deployed contract
        console.log("CoolBets deployed at:", address(coolBets));
    }
}

// forge script script/CoolBets.s.sol --rpc-url $ROOTSTOCK_TESTNETWORK_RPC_URL --broadcast --legacy
// forge script script/CoolBets.s.sol --rpc-url $CHILIZ_TESTNETWORK_RPC_URL --broadcast
// forge script script/CoolBets.s.sol --rpc-url $MORPHL2_HOLESKY_RPC_URL --broadcast --legacy

// forge script script/CoolBets.s.sol --rpc-url $BASE_SEPOLIA_RPC --broadcast --verify --etherscan-api-key $BASE_API_KEY
