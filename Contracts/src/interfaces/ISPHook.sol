// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ISPHook {
    function didReceiveAttestation(
        address attester,
        uint64 schemaId,
        uint64 attestationId,
        bytes calldata extraData
    ) external payable;

    // function didReceiveAttestation(
    //     address attester,
    //     uint64 schemaId,
    //     uint64 attestationId,
    //     IERC20 resolverFeeERC20Token,
    //     uint256 resolverFeeERC20Amount,
    //     bytes calldata extraData
    // ) external;

    function didReceiveRevocation(
        address attester,
        uint64 schemaId,
        uint64 attestationId,
        bytes calldata extraData
    ) external payable;

    // function didReceiveRevocation(
    //     address attester,
    //     uint64 schemaId,
    //     uint64 attestationId,
    //     IERC20 resolverFeeERC20Token,
    //     uint256 resolverFeeERC20Amount,
    //     bytes calldata extraData
    // ) external;
}
