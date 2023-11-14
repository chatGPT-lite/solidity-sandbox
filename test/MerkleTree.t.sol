// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "solmate/utils/MerkleProofLib.sol";
import "solmate/utils/Bytes32AddressLib.sol";
import "solmate/tokens/ERC20.sol";
import "solmate/tokens/ERC721.sol";
import "murky/Merkle.sol";

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

    function tokenURI(
        uint256 _id
    ) public pure override returns (string memory) {
        return "MOCK";
    }

    function mint(address _to, uint256 _tokenId) public {
        _mint(_to, _tokenId);
    }

    function burn(uint256 _tokenId) public {
        _burn(_tokenId);
    }
}

// Merkle trees & proofs are generated off-chain
// https://github.com/OpenZeppelin/merkle-tree
// https://github.com/merkletreejs/merkletreejs
contract MerkleTree is Test {
    using Bytes32AddressLib for address;

    uint256 private constant MINT_AMOUNT = 123123;
    uint256 private constant TOKEN_ID = 123;
    uint256 private constant MIN_BALANCE = 420;
    Utilities private utils = new Utilities();
    Merkle merkle = new Merkle();

    // Generated off-chain
    bytes32[] proof1;
    bytes32[] proof2;

    MockToken private token;
    MockNFT private nft;
    address private user1; // Token owner
    address private user2; // nft owner
    address private user3;
    address private user4;
    address private user5;

    bytes32 private merkleRoot;
    mapping(address => bool) allowed;

    function setUp() public {
        token = new MockToken();
        nft = new MockNFT();
        address payable[] memory users = utils.createUsers(5);
        user1 = users[0];
        user2 = users[1];
        user3 = users[2];
        user4 = users[3];
        user5 = users[4];

        // Generated off-chain and stored within a merkle contract
        bytes32[] memory data = new bytes32[](3);
        data[0] = _createLeafNode(user1);
        data[1] = _createLeafNode(user2);
        data[2] = _createLeafNode(user3);
        merkleRoot = merkle.getRoot(data);

        // mimic-ing off-chain proof proof generation by doing it in setup
        // Clients would loop through tree to find their address
        proof1 = merkle.getProof(data, 0);
        proof2 = merkle.getProof(data, 1);

        allowed[user1] = true;

        token.mint(user1, MINT_AMOUNT);
        nft.mint(user2, TOKEN_ID);
    }

    function testTokenOwnership_balanceOf() public {
        assertGt(
            token.balanceOf(user1),
            MIN_BALANCE,
            "Did you forget to mint?"
        );
    }

    function testNFTOwnership_balanceOf() public {
        assertGt(nft.balanceOf(user2), 0, "did you not mint?");
    }

    function testAllowed_map() public {
        assertTrue(allowed[user1]);
    }

    /**
     * Merkle tree things
     */

    function _createLeafNode(address _user) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(_user));
    }

    // Needed public to convert storage/memory --> calldata
    function _validateMerkle(
        bytes32[] calldata _proof,
        bytes32 _leaf
    ) public view returns (bool) {
        // return merkle.verifyProof(merkleRoot, _proof, _leaf);
        return MerkleProofLib.verify(_proof, merkleRoot, _leaf);
    }

    function testTokenOwnership_merkle() public {
        bytes32 leaf = _createLeafNode(user1);
        bool result = this._validateMerkle(proof1, leaf);
        assertTrue(result);
    }

    function testNFTOwnership_merkle() public {
        bytes32 leaf = _createLeafNode(user2);
        bool result = this._validateMerkle(proof2, leaf);
        assertTrue(result);
    }

    function testNoOwnership_merkle() public {
        bytes32 leaf = _createLeafNode(user3);
        bytes32[] memory fakeProof = new bytes32[](1);
        fakeProof[0] = "lol";
        bool result = this._validateMerkle(fakeProof, leaf);
        assertFalse(result);
    }
}
