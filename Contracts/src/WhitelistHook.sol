// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ISPHook} from "./interfaces/ISPHook.sol";
import {ICoolBetsNFT} from "./interfaces/ICoolBetsNFT.sol";
import {IERC20} from "./interfaces/IERC20.sol";

contract WhitelistHook is ISPHook {
    ICoolBetsNFT public coolBetsNFT;

    constructor(address _CoolBetsNftAddr) {
        coolBetsNFT = ICoolBetsNFT(_CoolBetsNftAddr);
    }

    function didReceiveAttestation(
        address attester,
        uint64, // schemaId
        uint64, // attestationId
        bytes calldata data // extraData
    ) external payable override {
        coolBetsNFT.mintNFT(data);
    }

    function didReceiveAttestation(
        address attester,
        uint64, // schemaId
        uint64, // attestationId
        IERC20, // resolverFeeERC20Token
        uint256, // resolverFeeERC20Amount
        bytes calldata data // extraData
    ) external {
        coolBetsNFT.mintNFT(data);
    }

    function didReceiveRevocation(
        address attester,
        uint64, // schemaId
        uint64, // attestationId
        bytes calldata data // extraData
    ) external payable {
        coolBetsNFT.mintNFT(data);
    }

    function didReceiveRevocation(
        address attester,
        uint64, // schemaId
        uint64, // attestationId
        IERC20, // resolverFeeERC20Token
        uint256, // resolverFeeERC20Amount
        bytes calldata data // extraData
    ) external {
        coolBetsNFT.mintNFT(data);
    }
}
