// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {PollDApp} from "../src/PollDApp.sol";
import {DeployPollDApp} from "../script/DeployPollDApp.s.sol";

contract DeployPollDAppTest is Test {
    DeployPollDApp script;

    function setUp() public {
        script = new DeployPollDApp();
    }

    function testRun() public {
        PollDApp app = script.run();

        assertTrue(
            address(app) != address(0),
            "Deployed contract should not be 0."
        );
    }
}
