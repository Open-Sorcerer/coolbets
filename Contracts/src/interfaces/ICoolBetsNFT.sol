// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface ICoolBetsNFT {
    function mintNFT(bytes calldata data) external returns (uint256);
}