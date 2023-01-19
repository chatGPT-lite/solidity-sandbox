// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "solmate/utils/MerkleProofLib.sol";
import "solmate/tokens/ERC20.sol";
import "solmate/tokens/ERC721.sol";

import "./utils/Utilities.sol";

contract MockToken is ERC20 {
    constructor() ERC20("mock", "mock", 18) {}

    function mint(address _to, uint256 _amount) public {
        _mint(_to, _amount);
    }

    function burn(address _from, uint256 _amount) public {
        _burn(_from, _amount);
    }
}

contract MockNFT is ERC721 {
    constructor() ERC721("Mock", "MCK") {}

    function tokenURI(uint256 _id) public pure override returns (string memory) {
        return "MOCK";
    }

    function mint(address _to, uint256 _tokenId) public {
        _mint(_to, _tokenId);
    }

    function burn(uint256 _tokenId) public {
        _burn(_tokenId);
    }
}

contract MerkleTree is Test {
    uint256 private constant MINT_AMOUNT = 123123;
    uint256 private constant TOKEN_ID = 123;
    uint256 private constant MIN_BALANCE = 420;
    Utilities private utils = new Utilities();

    MockToken private token;
    MockNFT private nft;
    address private user1; // Token owner
    address private user2; // nft owner

    bytes32 private merkleRoot;

    function setUp() public {
        token = new MockToken();
        nft = new MockNFT();
        address payable[] memory users = utils.createUsers(2);
        user1 = users[0];
        user2 = users[1];

        token.mint(user1, MINT_AMOUNT);
        nft.mint(user2, TOKEN_ID);
    }

    function testTokenOwnership_balanceOf() public {
        assertGt(token.balanceOf(user1), MIN_BALANCE, "Did you forget to mint?");
    }

    function testNFTOwnership_balanceOf() public {
        assertGt(nft.balanceOf(user2), 0, "did you not mint?");
    }

    function testTokenOwnership_merkle() public {}

    function testNFTOwnership_merkle() public {}
}
