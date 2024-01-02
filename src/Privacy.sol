// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Privacy {
    bool public locked = true;
    uint256 public ID = block.timestamp;
    uint8 private flattening = 10;
    uint8 private denomination = 255;
    uint16 private awkwardness = uint16(block.timestamp);
    bytes32[3] private data;

    constructor(bytes32[3] memory _data) {
        data = _data;
    }

    function unlock(bytes16 _key) public {
        require(_key == bytes16(data[2]));
        locked = false;
    }

    /*
    A bunch of super advanced solidity algorithms...

      ,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`
      .,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,
      *.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^         ,---/V\
      `*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.    ~|__(o.o)
      ^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'  UU  UU
  */
}
/* 
source .env
export privacy=0x8D99cA585288cB862589734771016e5d4f67f528
cast storage $privacy 0 --rpc-url $RPC_URL => locked = 1 = true
cast storage $privacy 1 --rpc-url $RPC_URL => ID = 1704196114
cast storage $privacy 3 --rpc-url $RPC_URL => data[0] = 0x0a2793fa28eb79d1f3bdd48b769fd76c6ab619039ad12232b2f22959b1c38ef6
cast storage $privacy 4 --rpc-url $RPC_URL => data[1] = 0xcb8bcf244a03ddc74b03526bbf77e3fe5f3d0581b62104ba4ffdf3b98ea0a87c
cast storage $privacy 5 --rpc-url $RPC_URL => data[2] = 0x63fb99a8cdd5bf912c915e8d096d4c7f7d399e9d3f5b4bdba6ffd5201a730a59
cast send $privacy "unlock(bytes16)" 0x63fb99a8cdd5bf912c915e8d096d4c7f --rpc-url $RPC_URL --private-key $PRIVATE_KEY
cast call $privacy "locked()" --rpc-url $RPC_URL
*/
