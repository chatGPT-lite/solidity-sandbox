// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {FixedPointMathLib} from "solady/utils/FixedPointMathLib.sol";
import {ERC20} from "solady/tokens/ERC20.sol";

contract Splits {
    using FixedPointMathLib for uint256;

    address[] public recipients;
    ERC20 public token;

    constructor(ERC20 _token) {
        token = _token;
    }

    function updateRecipients(address[] memory _recipients) external {
        recipients = _recipients;
    }

    function splitNative() external payable {
        uint256 individualAmount = msg.value / recipients.length;

        for (uint256 i = 0; i < recipients.length; i++) {
            payable(recipients[i]).transfer(individualAmount);
        }
    }

    function splitToken(uint256 value) external {
        uint256 individualAmount = value / recipients.length;

        for (uint256 i = 0; i < recipients.length; i++) {
            token.transferFrom(msg.sender, recipients[i], individualAmount);
        }
    }
}
