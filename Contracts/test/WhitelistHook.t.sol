// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/WhitelistHook.sol";
import "../src/CoolBetsNFT.sol";

contract WhitelistHookTest is Test {
    WhitelistHook public whitelistHook;
    CoolBetsNFT public coolBetsNFT;

    address public owner = address(0x1);
    address public user = address(0x2);
    address public nonWhitelistedUser = address(0x3);

    function setUp() public {
        // Deploy CoolBetsNFT with owner address
        coolBetsNFT = new CoolBetsNFT("Cool Bets", "CBET", owner);

        // Deploy WhitelistHook with CoolBetsNFT contract address
        whitelistHook = new WhitelistHook(address(coolBetsNFT));

        // Set whitelistHook contract as whitelisted in CoolBetsNFT
        vm.prank(owner); // Make the following call as the owner
        coolBetsNFT.setWhitelistHook(address(whitelistHook), true);
    }

    function testDidReceiveAttestation() public {
        // Prepare data for minting
        address recipient = user;
        string memory name = "Cool Bet #1";
        uint256 proposalId = 123;
        uint256 opinion = 1;
        uint256 betAmount = 1000;
        string memory imageUrl = "https://example.com/nft.png";

        // Encode data for mintNFT
        bytes memory data = abi.encode(
            recipient,
            name,
            proposalId,
            opinion,
            betAmount,
            imageUrl
        );

        // Call didReceiveAttestation function from whitelistHook
        vm.prank(user); // Make the following call as the user
        whitelistHook.didReceiveAttestation(user, 0, 0, data);

        // Verify the NFT was minted and the data is correct
        uint256 tokenId = coolBetsNFT.getCurrentTokenId();
        assertEq(tokenId, 1); // The first minted token ID should be 1

        CoolBetsNFT.NFTData memory nftData = coolBetsNFT.getTokenData(tokenId);
        assertEq(nftData.name, name);
        assertEq(nftData.proposalId, proposalId);
        assertEq(nftData.opinion, opinion);
        assertEq(nftData.betAmount, betAmount);
        assertEq(nftData.imageUrl, imageUrl);
    }

    function testRevertIfNotWhitelisted() public {
        // Prepare data for minting
        bytes memory data = encodeMintData(
            user,
            "Cool Bet #1",
            123,
            1,
            1000,
            "https://example.com/nft.png"
        );

        // Attempt to mint NFT without whitelisting - should revert
        vm.prank(nonWhitelistedUser);
        vm.expectRevert(CoolBetsNFT__OnlyWhitelisted.selector);
        coolBetsNFT.mintNFT(data);
    }

    function testMintMultipleNFTs() public {
        // Mint first NFT
        bytes memory data1 = encodeMintData(
            user,
            "Cool Bet #1",
            123,
            1,
            1000,
            "https://example.com/nft1.png"
        );
        vm.prank(user);
        whitelistHook.didReceiveAttestation(user, 0, 0, data1);

        // Mint second NFT
        bytes memory data2 = encodeMintData(
            user,
            "Cool Bet #2",
            456,
            2,
            2000,
            "https://example.com/nft2.png"
        );
        vm.prank(user);
        whitelistHook.didReceiveAttestation(user, 0, 0, data2);

        // Verify both NFTs were minted correctly
        assertEq(coolBetsNFT.getCurrentTokenId(), 2);

        CoolBetsNFT.NFTData memory nftData1 = coolBetsNFT.getTokenData(1);
        CoolBetsNFT.NFTData memory nftData2 = coolBetsNFT.getTokenData(2);

        assertEq(nftData1.name, "Cool Bet #1");
        assertEq(nftData2.name, "Cool Bet #2");
    }

    function testOnlyOwnerCanSetWhitelist() public {
        // Attempt to whitelist from a non-owner address - should revert
        vm.prank(user);
        vm.expectRevert(CoolBetsNFT__OnlyOwnerCanCall.selector);
        coolBetsNFT.setWhitelistHook(user, true);

        // Whitelist from the owner address - should succeed
        vm.prank(owner);
        coolBetsNFT.setWhitelistHook(user, true);
        assertTrue(coolBetsNFT.getWhitelistStatus(user)); // Ensure user is whitelisted
    }

    function testTokenURI() public {
        // Mint an NFT to test tokenURI
        bytes memory data = encodeMintData(
            user,
            "Cool Bet #1",
            123,
            1,
            1000,
            "https://example.com/nft.png"
        );
        vm.prank(user);
        whitelistHook.didReceiveAttestation(user, 0, 0, data);

        // Fetch the token URI
        string memory tokenUri = coolBetsNFT.tokenURI(1);

        // Verify the token URI is properly formatted
        assertTrue(bytes(tokenUri).length > 0);
        assertTrue(keccak256(bytes(tokenUri)) != keccak256(bytes("")));
    }

    function encodeMintData(
        address recipient,
        string memory name,
        uint256 proposalId,
        uint256 opinion,
        uint256 betAmount,
        string memory imageUrl
    ) internal pure returns (bytes memory) {
        return
            abi.encode(
                recipient,
                name,
                proposalId,
                opinion,
                betAmount,
                imageUrl
            );
    }

    function testTokenURIForNonExistentToken() public {
        // Check tokenURI for a non-existent token (tokenId = 999)
        vm.expectRevert(
            abi.encodeWithSelector(CoolBetsNFT__TokenDoesNotExist.selector, 999)
        );
        coolBetsNFT.tokenURI(999);
    }
}
