// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

contract Object is Test {
    struct MyObject {
        bool isTrash;
        mapping(address => bool) addressToExistence;
    }

    // Mapping of index --> Objects
    mapping(uint8 => MyObject) private bagOfEmptyObjects;
    MyObject[] private objectArray;

    function testMap_setting() public {
        // This doesn't work??
        MyObject memory obj = MyObject();

        // How do you add an object to the array?
        objectArray.push(
            /**
             * Can't even push anything...
             */
        );

        // This works
        MyObject memory emptyObject = bagOfEmptyObjects[0];
        emptyObject.isTrash = true;
        emptyObject.addressToExistence[address(this)] = true;
    }
}
