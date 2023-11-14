// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";

import {Splits} from "src/Splits.sol";
import {ERC20} from "solady/tokens/ERC20.sol";
import {LibString} from "solady/utils/LibString.sol";

contract MockToken is ERC20 {
    function name() public view override returns (string memory) {
        return "MockToken";
    }

    function symbol() public view override returns (string memory) {
        return "MTK";
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract TestSplits is Test {
    Splits private splits;
    MockToken private token;
    address[] private addresses10;
    address[] private addresses100;
    address[] private addresses1000;

    uint256 private valueAmount;

    function setUp() public {
        token = new MockToken();
        splits = new Splits(token);
        token.approve(address(splits), type(uint256).max); // splitter contract can spend all tokens

        valueAmount = 1000 * 1e18;
        token.mint(address(this), valueAmount);
        vm.deal(address(this), valueAmount);

        addresses10 = _makeAddresses(10);
        addresses100 = _makeAddresses(100);
        addresses1000 = _makeAddresses(1000);
    }

    function _makeAddresses(uint256 count) private returns (address[] memory) {
        address[] memory addresses = new address[](count);
        for (uint256 i = 0; i < count; i++) {
            addresses[i] = makeAddr(LibString.toString(i));
        }

        return addresses;
    }

    function testSingleSplit() public {
        address[] memory recipients = new address[](2);
        recipients[0] = makeAddr("user1");
        recipients[1] = makeAddr("user2");

        splits.updateRecipients(recipients);

        splits.splitToken(valueAmount);
        assertEq(token.balanceOf(recipients[0]), valueAmount / 2);
        assertEq(token.balanceOf(recipients[1]), valueAmount / 2);
    }

    function testSingleNativeSplit() public {
        address[] memory recipients = new address[](2);
        recipients[0] = makeAddr("user1");
        recipients[1] = makeAddr("user2");

        splits.updateRecipients(recipients);

        splits.splitNative{value: valueAmount}();
        assertEq(recipients[0].balance, valueAmount / 2);
        assertEq(recipients[1].balance, valueAmount / 2);
    }

    function testSplits10() public {
        address[] memory recipients = addresses10;
        splits.updateRecipients(recipients);

        splits.splitToken(valueAmount);
    }

    function testSplits100() public {
        address[] memory recipients = addresses100;
        splits.updateRecipients(recipients);

        splits.splitToken(valueAmount);
    }

    function testSplits1000() public {
        address[] memory recipients = addresses1000;
        splits.updateRecipients(recipients);

        splits.splitToken(valueAmount);
    }

    function testNativeSplits10() public {
        address[] memory recipients = addresses10;
        splits.updateRecipients(recipients);

        splits.splitNative{value: valueAmount}();
    }

    function testNativeSplits100() public {
        address[] memory recipients = addresses100;
        splits.updateRecipients(recipients);

        splits.splitNative{value: valueAmount}();
    }

    function testNativeSplits1000() public {
        address[] memory recipients = addresses1000;
        splits.updateRecipients(recipients);

        splits.splitNative{value: valueAmount}();
    }
}
