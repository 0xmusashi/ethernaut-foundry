// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {GatekeeperOne} from "../src/GatekeeperOne.sol";
import {GatekeeperOneAttack} from "../solutions/GatekeeperOneAttack.sol";

contract GatekeeperOneTest is Test {
    GatekeeperOne public gatekeeperOne;
    GatekeeperOneAttack public attackContract;
    address public attacker;

    function setUp() public {
        gatekeeperOne = new GatekeeperOne();
        attacker = makeAddr("attacker");
    }

    function test_attackGatekeeperOne() public {
        vm.startPrank(attacker);

        attackContract = new GatekeeperOneAttack(address(gatekeeperOne));
        attackContract.attack();
        console.log("entrant: ", gatekeeperOne.entrant());
        console.log("attacker: ", attacker);
        console.log("gateKeeperOne: ", address(gatekeeperOne));
        console.log("attack contract: ", address(attackContract));
        console.log("address(this): ", address(this));
        // assertEq(gatekeeperOne.entrant(), attacker);

        vm.stopPrank();
    }
}

/*
source .env

export gateKeeperOne=0x66F3848B7D9Bb774F428Bee34de6cC0faE7e60CA
forge create solutions/GatekeeperOneAttack.sol:GatekeeperOneAttack --rpc-url $RPC_URL --private-key $PRIVATE_KEY --constructor-args $gateKeeperOne

export attackContract=0x6303d0901f339F64c7DF83cA016422dBC8a25fce
cast send $attackContract "attack()" --rpc-url $RPC_URL --private-key $PRIVATE_KEY
cast call $gateKeeperOne "entrant()" --rpc-url $RPC_URL

*/
