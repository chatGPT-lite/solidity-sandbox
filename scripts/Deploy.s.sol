// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Script.sol";

import {Token} from "src/Token.sol";
import {Splits} from "src/Splits.sol";

contract DeployScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        Token token = new Token(); 
        Splits splits = new Splits(token); 

        vm.stopBroadcast();
    }
}
