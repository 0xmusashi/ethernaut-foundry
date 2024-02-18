// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../extensions/Ownable.sol";

contract AlienCodex is Ownable(msg.sender) {
    bool public contact;
    bytes32[] public codex;

    modifier contacted() {
        assert(contact);
        _;
    }

    function makeContact() public {
        contact = true;
    }

    function record(bytes32 _content) public contacted {
        codex.push(_content);
    }

    function retract() public contacted {
        for (uint256 i = 0; i < codex.length - 1; i++) {
            codex[i] = codex[i + 1];
        }

        codex.pop();
    }

    function revise(uint i, bytes32 _content) public contacted {
        codex[i] = _content;
    }
}
