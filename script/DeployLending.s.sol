//SPDX-Licence-Identifier: MIT
pragma solidity ^0.8.28;
import {Script} from "lib/forge-std/src/Script.sol";
import {Lending} from "../src/Lending.sol";
contract DeployLending is Script{
       Lending lending;
    function run()external returns(Lending){
    vm.startBroadcast();
    lending= new Lending();
    vm.stopBroadcast();
    return lending;
    }
}
