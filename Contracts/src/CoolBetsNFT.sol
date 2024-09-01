// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

error CoolBetsNFT__TokenDoesNotExist(uint256 tokenId);
error CoolBetsNFT__OnlyOwnerCanCall();
error CoolBetsNFT__OnlyWhitelisted();

contract CoolBetsNFT is ERC721 {
    using Strings for uint256;

    /// @dev The current token ID of NFT
    uint256 private tokenIds;
    /// @dev The owner of the contract
    address private owner;

    /// @dev The data structure of NFT
    struct NFTData {
        string name;
        uint256 proposalId;
        uint256 opinion;
        uint256 betAmount;
        string imageUrl;
    }

    /// @dev The mapping of token ID to NFT data
    mapping(uint256 => NFTData) private tokenData;
    /// @dev The mapping of token ID to existence. Check if the token ID exists
    mapping(uint256 => bool) private exists;
    /// @dev The mapping of address to whitelist status. Chcek if the address is whitelisted
    mapping(address => bool) private whitelist;

    /// @dev The modifier to check if the caller is the owner
    modifier onlyOwner() {
        if (msg.sender != owner) revert CoolBetsNFT__OnlyOwnerCanCall();
        _;
    }

    /// @dev The modifier to check if the caller is whitelisted
    modifier onlyWhitelisted() {
        if (!whitelist[msg.sender]) revert CoolBetsNFT__OnlyWhitelisted();
        _;
    }

    /// @dev The constructor of the contract. Setting the name and Symbol of the NFT and owner of this contract
    constructor(
        string memory name,
        string memory symbol,
        address _owner
    ) ERC721(name, symbol) {
        owner = _owner;
    }

    /// @dev The function to set the whitelist status of the address
    function setWhitelistHook(
        address _whitelistHook,
        bool _value
    ) public onlyOwner {
        whitelist[_whitelistHook] = _value;
    }

    /// @dev The function to mint NFT
    function mintNFT(
        bytes calldata data
    ) public onlyWhitelisted returns (uint256) {
        (
            address recipient,
            string memory name,
            uint256 proposalId,
            uint256 opinion,
            uint256 betAmount,
            string memory imageUrl
        ) = abi.decode(
                data,
                (address, string, uint256, uint256, uint256, string)
            );

        ++tokenIds;
        exists[tokenIds] = true;
        uint256 newItemId = tokenIds;
        _safeMint(recipient, newItemId);

        tokenData[newItemId] = NFTData(
            name,
            proposalId,
            opinion,
            betAmount,
            imageUrl
        );

        return newItemId;
    }

    /// @dev The function to get the token URI
    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        if (!exists[tokenId]) revert CoolBetsNFT__TokenDoesNotExist(tokenId);

        NFTData memory data = tokenData[tokenId];

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        data.name,
                        '",',
                        '"description": "On-chain NFT with custom data",',
                        '"image": "',
                        data.imageUrl,
                        '",',
                        '"attributes": [',
                        '{"trait_type": "Proposal ID", "value": "',
                        data.proposalId.toString(),
                        '"},',
                        '{"trait_type": "Opinion", "value": "',
                        data.opinion.toString(),
                        '"},',
                        '{"trait_type": "Bet Amount", "value": "',
                        data.betAmount.toString(),
                        '"}',
                        "]}"
                    )
                )
            )
        );

        return string(abi.encodePacked("data:application/json;base64,", json));
    }

    ///-----------------------------------//
    ///  GETTER FUNCTIONS                 //
    ///-----------------------------------//

    /// @dev The function to get the token data
    function getTokenData(
        uint256 tokenId
    ) public view returns (NFTData memory) {
        if (!exists[tokenId]) revert CoolBetsNFT__TokenDoesNotExist(tokenId);
        return tokenData[tokenId];
    }

    /// @dev The function to get the current token ID
    function getCurrentTokenId() public view returns (uint256) {
        return tokenIds;
    }

    /// @dev The function to get the owner of the contract
    function getOwner() public view returns (address) {
        return owner;
    }

    /// @dev The function to get the whitelist status of the address
    function getWhitelistStatus(address _address) public view returns (bool) {
        return whitelist[_address];
    }
}
