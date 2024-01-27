// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {Denial} from "../src/Denial.sol";

contract DenialTest is Test {
    Denial public denial;
    address public attacker;
    address public owner;

    function setUp() public {
        owner = makeAddr("owner");
        attacker = makeAddr("attacker");

        vm.prank(owner);
        denial = new Denial();
    }

    function test_denial() public {
        vm.startPrank(attacker);

        vm.stopPrank();
    }
}

/*
source .env
export deinal=0x79aD73D0EE0dB5cCe6E2b64e43104d357B175e59
*/
