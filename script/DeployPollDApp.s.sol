// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {PollDApp} from "../src/PollDApp.sol";

contract DeployPollDApp is Script {
    function run() external returns (PollDApp) {
        vm.startBroadcast();

        PollDApp app = new PollDApp();

        vm.stopBroadcast();

        return app;
    }
}
