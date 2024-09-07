// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import {CoolBets} from "../src/CoolBets.sol";

interface ICoolBets {
    function setWhitelist(address _whitelist, bool _value) external;

    function getWhitelisted(address _user) external view returns (bool);
}

contract SetWhitelist is Script {
    function run() external {
        // Retrieve the private key from the environment variable
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        address rootstockCoolBetsAddress = 0xe6a5267590aC048a599014a18815b9DaF247eEE7;
        address chilizCoolBetsAddress = 0x6E84c2AF3393A2C85a6eA96765319040fd207f8a;
        address morphl2CoolBetsAddress = 0x6E84c2AF3393A2C85a6eA96765319040fd207f8a;
        address baseCoolBetsAddress = 0x6E84c2AF3393A2C85a6eA96765319040fd207f8a;
        address vraj = 0x1c4C98d2EAd474876a9E84e2Ba8ff226cc9a161c;
        address vraj2 = 0x78D98C8DBD4e1BFEfe439f1bF89692FeDCa95C45;
        address harsh = 0x4aB65FEb7Dc1644Cabe45e00e918815D3acbFa0a;
        address aayush = 0xFB2c923ABcCa1C5a411Bfb487c4984dcB4A2d8F6;

        // uint64 customNonce = 6; // Set your desired nonce here
        // vm.setNonce(aayush, customNonce);
        // vm.setNonce(msg.sende, customNonce);


        // Start broadcasting transactions
        vm.startBroadcast(deployerPrivateKey);

        // set whitelist for rootstock
        // ICoolBets(rootstockCoolBetsAddress).setWhitelist(harsh, true);

        // set whitelist for chiliz
        // ICoolBets(chilizCoolBetsAddress).setWhitelist(harsh, true);

        // set whitelist for morphl2
        // ICoolBets(morphl2CoolBetsAddress).setWhitelist(harsh, true);

        // set whitelist for base
        // ICoolBets(baseCoolBetsAddress).setWhitelist(harsh, true);

        // Stop broadcasting transactions
        vm.stopBroadcast();

        // Log the address of the deployed contract
        console.log("User is whitelisted", ICoolBets(chilizCoolBetsAddress).getWhitelisted(harsh));
        console.log(vm.getNonce(aayush));
    }
}

// console.log(vm.getNonce(aayush));

// forge script script/SetWhitelist.s.sol --rpc-url $ROOTSTOCK_TESTNETWORK_RPC_URL --broadcast --legacy
// forge script script/SetWhitelist.s.sol --rpc-url $CHILIZ_TESTNETWORK_RPC_URL --broadcast
// forge script script/SetWhitelist.s.sol --rpc-url $CHILIZ_TESTNETWORK_RPC_URL --broadcast --gas-price 4000000000
// forge script script/SetWhitelist.s.sol --rpc-url $MORPHL2_HOLESKY_RPC_URL --broadcast --legacy
// forge script script/SetWhitelist.s.sol --rpc-url $BASE_SEPOLIA_RPC --broadcast

// forge script script/SetWhitelist.s.sol --rpc-url $CHILIZ_TESTNETWORK_RPC_URL --broadcast --nonce 5

// 4

//  cast send --rpc-url $CHILIZ_TESTNETWORK_RPC_URL --private-key $PRIVATE_KEY --nonce 4 --gas-price 50gwei 0xFB2c923ABcCa1C5a411Bfb487c4984dcB4A2d8F6 0

// cast send --rpc-url https://mainnet.infura.io/v3/YOUR-PROJECT-ID --private-key $PRIVATE_KEY --nonce 4 --gas-price 50gwei 0xFB2c923ABcCa1C5a411Bfb487c4984dcB4A2d8F6 0