// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {ERC721} from "solmate/tokens/ERC721.sol";
import {ERC721A} from "ERC721A/ERC721A.sol";

contract StandardERC721 is ERC721 {
    constructor() ERC721("erc721", "ERC721") {}

    function tokenURI(uint256 id) public view override returns (string memory) {
        return "ERC721";
    }

    function mint(address to, uint256 tokenId) external {
        _mint(to, tokenId);
    }
}

contract BatchERC721 is ERC721A {
    constructor() ERC721A("erc721a", "ERC721A") {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract NFT is Test {
    StandardERC721 private erc721;
    BatchERC721 private erc721a;

    address private user1;
    address private user2;

    uint256 immutable MINT_AMOUNT = 1_000_000;
    uint256 immutable STARTING_MINT_ID = 1;

    function setUp() public {
        erc721a = new BatchERC721();
        erc721 = new StandardERC721();

        user1 = makeAddr("user1");
        user2 = makeAddr("user2");

        // Mint both tokens to user1
        erc721a.mint(user1, 1);
        erc721a.setApprovalForAll(address(this), true);
        erc721.mint(user1, 0);
        erc721.setApprovalForAll(address(this), true);
    }

    function skip_testHugeMint_ERC721A() public {
        erc721a.mint(address(this), MINT_AMOUNT);
    }

    function skip_testHugeMint_ERC721() public {
        for (uint256 i = STARTING_MINT_ID; i < MINT_AMOUNT; ) {
            erc721.mint(address(this), i);
            unchecked {
                ++i;
            }
        }
    }

    function testTransfer_ERC721() public {
        bool user2Owned = false;
        uint256 numTransfers = 100;

        for (uint256 i = 0; i < numTransfers; ++i) {
            if (user2Owned) {
                _user2Transfer(address(erc721), 0);
                user2Owned = false;
                continue;
            }
            _user1Transfer(address(erc721), 0);
            user2Owned = true;
        }
    }

    function testTransfer_ERC721A() public {
        bool user2Owned = false;
        uint256 numTransfers = 100;

        for (uint256 i = 0; i < numTransfers; ++i) {
            if (user2Owned) {
                _user2Transfer(address(erc721a), 0);
                user2Owned = false;

                continue;
            }
            _user1Transfer(address(erc721a), 0);
            user2Owned = true;
        }
    }

    /// @notice solmate ERC721 is technically the IERC721 token iterface as well.
    function _user1Transfer(address tokenAddress, uint256 tokenId) internal {
        ERC721 token = ERC721(tokenAddress);
        vm.startPrank(user1);
        token.transferFrom(address(user1), address(user2), tokenId);
        vm.stopPrank();
    }

    function _user2Transfer(address tokenAddress, uint256 tokenId) internal {
        ERC721 token = ERC721(tokenAddress);
        vm.startPrank(user2);
        token.transferFrom(address(user2), address(user1), tokenId);
        vm.stopPrank();
    }
}
