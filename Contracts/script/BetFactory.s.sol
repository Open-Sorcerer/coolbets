// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import {BetFactory} from "../src/BetFactory.sol";

contract DeployBetFactory is Script {
    function run() external {
        // Retrieve the private key from the environment variable
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Start broadcasting transactions
        vm.startBroadcast(deployerPrivateKey);

        // Deploy the BetFactory contract
        BetFactory betFactory = new BetFactory();

        // Stop broadcasting transactions
        vm.stopBroadcast();

        // Log the address of the deployed contract
        console.log("BetFactory deployed at:", address(betFactory));
    }
}

// forge script script/BetFactory.s.sol --rpc-url $ROOTSTOCK_TESTNETWORK_RPC_URL --broadcast --legacy
// forge script script/BetFactory.s.sol --rpc-url $CHILIZ_TESTNETWORK_RPC_URL --broadcast
// forge script script/BetFactory.s.sol --rpc-url $MORPHL2_HOLESKY_RPC_URL --broadcast --legacy