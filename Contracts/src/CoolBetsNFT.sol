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

    uint256 private tokenIds;
    address private owner;

    struct NFTData {
        string name;
        uint256 proposalId;
        uint256 opinion;
        uint256 betAmount;
        string imageUrl;
    }

    mapping(uint256 => NFTData) private _tokenData;
    mapping(uint256 => bool) private _exists;
    mapping(address => bool) private _whitelist;

    modifier onlyOwner() {
        if (msg.sender != owner) revert CoolBetsNFT__OnlyOwnerCanCall();
        _;
    }

    modifier onlyWhitelisted() {
        if (!_whitelist[msg.sender]) revert CoolBetsNFT__OnlyWhitelisted();
        _;
    }

    constructor(
        string memory name,
        string memory symbol,
        address _owner
    ) ERC721(name, symbol) {
        owner = _owner;
    }

    function setWhitelistHook(
        address _whitelistHook,
        bool _value
    ) public onlyOwner {
        _whitelist[_whitelistHook] = _value;
    }

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
        _exists[tokenIds] = true;
        uint256 newItemId = tokenIds;
        _safeMint(recipient, newItemId);

        _tokenData[newItemId] = NFTData(
            name,
            proposalId,
            opinion,
            betAmount,
            imageUrl
        );

        return newItemId;
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        // require(
        //     _exists(tokenId),
        //     "ERC721Metadata: URI query for nonexistent token"
        // );
        if (!_exists[tokenId]) revert CoolBetsNFT__TokenDoesNotExist(tokenId);

        NFTData memory data = _tokenData[tokenId];

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

    function getTokenData(
        uint256 tokenId
    ) public view returns (NFTData memory) {
        // require(
        //     _exists(tokenId),
        //     "ERC721Metadata: Query for nonexistent token"
        // );
        if (!_exists[tokenId]) revert CoolBetsNFT__TokenDoesNotExist(tokenId);
        return _tokenData[tokenId];
    }

    function getCurrentTokenId() public view returns (uint256) {
        return tokenIds;
    }

    function getOwner() public view returns (address) {
        return owner;
    }
}
