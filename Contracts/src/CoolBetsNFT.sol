// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

error CoolBetsNFT__TokenDoesNotExist(uint256 tokenId);

contract CoolBetsNFT is ERC721, Ownable {
    using Strings for uint256;

    uint256 private _tokenIds;

    struct NFTData {
        string name;
        uint256 proposalId;
        uint256 opinion;
        uint256 betAmount;
    }

    mapping(uint256 => NFTData) private _tokenData;
    mapping(uint256 => bool) private _exists;

    constructor(
        string memory name,
        string memory symbol
    ) ERC721(name, symbol) Ownable(msg.sender) {}

    function mintNFT(
        address recipient,
        string memory name,
        uint256 proposalId,
        uint256 opinion,
        uint256 betAmount
    ) public onlyOwner returns (uint256) {
        ++_tokenIds;
        uint256 newItemId = _tokenIds;
        _safeMint(recipient, newItemId);

        _tokenData[newItemId] = NFTData(name, proposalId, opinion, betAmount);

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
}
