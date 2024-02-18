// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import {Test, console} from "forge-std/Test.sol";
import {GatekeeperTwo} from "../src/GatekeeperTwo.sol";
import {GatekeeperTwoAttack} from "../solutions/GatekeeperTwoAttack.sol";

contract GatekeeperTwoTest is Test {
    GatekeeperTwo public gatekeeperTwo;
    GatekeeperTwoAttack public attackContract;
    address public attacker;

    function setUp() public {
        gatekeeperTwo = new GatekeeperTwo();
        attacker = makeAddr("attacker");
    }

    function test_attackGatekeeperTwo() public {
        vm.startPrank(attacker);

        attackContract = new GatekeeperTwoAttack(address(gatekeeperTwo));

        assertEq(
            gatekeeperTwo.entrant(),
            0x7bB341488d5E6838Bb9C1fD521543f83066Dc9Bd
        );

        vm.stopPrank();
    }
}

/*
source .env

export gatekeeperTwo=0x9FF8358bd5Af439F1017138377Ed2048D8c0D13D
forge create solutions/GatekeeperTwoAttack.sol:GatekeeperTwoAttack --rpc-url $RPC_URL --private-key $PRIVATE_KEY --constructor-args $gatekeeperTwo

cast call $gatekeeperTwo "entrant()" --rpc-url $RPC_URL

forge test --match-test test_attackGatekeeperTwo
*/
