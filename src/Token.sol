// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {ERC20} from "solady/tokens/ERC20.sol";

contract Token is ERC20 {
    function name() public view override returns (string memory) {
        return "LolChocotaco";
    }

    function symbol() public view override returns (string memory) {
        return "LOLC";
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    function transferMultiple(address to, uint256 totalAmount, uint256 times) external {
        uint256 individualAmount = totalAmount / times;

        for(uint256 i = 0; i < times; i++) {
            _transfer(msg.sender, to, individualAmount);
        }
    }
}
