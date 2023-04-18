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

    uint256 immutable MINT_AMOUNT = 1_000_000;

    function setUp() public {
        erc721a = new BatchERC721();
        erc721 = new StandardERC721();
    }

    function testHugeMint_ERC721A() public {
        erc721a.mint(address(this), MINT_AMOUNT);
    }

    function testHugeMint_ERC721() public {
        for (uint256 i = 0; i < MINT_AMOUNT;) {
            erc721.mint(address(this), i);
            unchecked {
                ++i;
            }
        }
    }
}
