// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/MagicNum.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract MagicNumSolution is Script {
    MagicNum public magicNum =
        MagicNum(0xAb2654b34Db946cd4a5c750d7AFf01e2eA68Acf1);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        bytes
            memory code = "\x60\x0a\x60\x0c\x60\x00\x39\x60\x0a\x60\x00\xf3\x60\x2a\x60\x80\x52\x60\x20\x60\x80\xf3";
        address solver;

        assembly {
            solver := create(0, add(code, 0x20), mload(code))
        }
        magicNum.setSolver(solver);
        vm.stopBroadcast();
    }
}
/* 
source .env
forge script script/MagicNum.s.sol --broadcast --rpc-url $RPC_URL --private-key $PRIVATE_KEY
*/
