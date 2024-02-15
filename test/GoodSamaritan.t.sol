// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {GoodSamaritan, Wallet, Coin} from "../src/GoodSamaritan.sol";
import {GoodSamaritanAttack} from "../solutions/GoodSamaritanAttack.sol";

contract GoodSamaritanTest is Test {
    GoodSamaritan public goodSamaritanContract;
    GoodSamaritanAttack public attackContract;
    Wallet public wallet;
    Coin public coin;
    address public samaritan;
    address public attacker;

    function setUp() public {
        attacker = makeAddr("attacker");
        samaritan = makeAddr("samaritan");

        vm.startPrank(samaritan);

        goodSamaritanContract = new GoodSamaritan();
        wallet = goodSamaritanContract.wallet();
        coin = goodSamaritanContract.coin();

        vm.stopPrank();
    }

    function test_deploySamaritanContract() public {
        assertEq(wallet.owner(), address(goodSamaritanContract));
        assertEq(coin.balances(address(wallet)), 10 ** 6);
    }

    function test_attackGoodSamaritan() public {
        vm.startPrank(attacker);

        attackContract = new GoodSamaritanAttack(
            address(goodSamaritanContract)
        );
        attackContract.attack();

        assertEq(coin.balances(address(wallet)), 0);

        vm.stopPrank();
    }
}

/*
Instance address: 0xb7090120910C72096E7cCFfE5dc27731783F8fA5
source .env
export samaritan=0xb7090120910C72096E7cCFfE5dc27731783F8fA5
export attacker=0x7bB341488d5E6838Bb9C1fD521543f83066Dc9Bd
export wallet=0x707f699a8af7ce2942d8716b1dc0a0ed5407ca5b
export coin=0xf5632ad3e1dd441c5118724cdc759a7424469b2a

cast call $samaritan "wallet()" --rpc-url $RPC_URL
cast call $samaritan "coin()" --rpc-url $RPC_URL

forge create solutions/GoodSamaritanAttack.sol:GoodSamaritanAttack --rpc-url $RPC_URL --private-key $PRIVATE_KEY --constructor-args $samaritan
export attackContract=0x2A6256c28795bb63f600aD7D720c32Ba6A0565C2

cast send $attackContract "attack()" --rpc-url $RPC_URL --private-key $PRIVATE_KEY

cast call $coin "balances(address)" $wallet --rpc-url $RPC_URL

*/
