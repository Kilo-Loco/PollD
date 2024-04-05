// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {PollDApp} from "../src/PollDApp.sol";
import {Poll, PollOption, PollResponse} from "../src/Models.sol";

contract PollDAppTest is Test {
    PollDApp public app;

    function setUp() public {
        app = new PollDApp();
    }

    modifier hasExistingPoll() {
        string[] memory options = new string[](2);
        options[0] = "yes";
        options[1] = "no";
        app.createPoll("Do you code?", options, 0);
        _;
    }

    function testCreatePoll() public hasExistingPoll {
        assertEq(app.getPollCount(), 1, "Expected pollCount to increase to 1");
    }

    function testCreatePollMustHaveMultipleOptions() public {
        string[] memory options = new string[](1);
        options[0] = "yes";

        vm.expectRevert(PollDApp.InvalidOptionCount.selector);
        app.createPoll("Do you code?", options, 0);
    }

    function testGetPoll() public hasExistingPoll {
        uint pollId = 1;

        PollResponse memory response = app.getPoll(pollId);

        assertEq(response.id, pollId, "Expected PollIDs to match.");
        assertEq(response.options.length, 2, "Expected poll count to be 2.");
    }

    function testGetPollMustExist() public {
        vm.expectRevert(PollDApp.InvalidPoll.selector);
        app.getPoll(5);
    }

    function testCannotVoteOnFuturePoll() public {
        vm.expectRevert(PollDApp.InvalidPoll.selector);
        app.vote(1, 0);
    }

    function testVoteMustHaveValidOptionIndex() public hasExistingPoll {
        vm.expectRevert(PollDApp.InvalidPollOption.selector);
        app.vote(1, 5);
    }

    function testVoterCantVoteAgain() public hasExistingPoll {
        uint pollId = 1;
        app.vote(pollId, 0);

        vm.expectRevert(PollDApp.CannotVoteAgain.selector);
        app.vote(pollId, 1);
    }

    function testCannotVoteOnClosedPoll() public {
        string[] memory options = new string[](2);
        options[0] = "yes";
        options[1] = "no";
        uint expDate = 1;
        app.createPoll("Do you code?", options, expDate);

        uint pollId = 1;
        uint optionIndex = 0;
        skip(300);

        vm.expectRevert(PollDApp.PollClosed.selector);
        app.vote(pollId, optionIndex);
    }

    function testCanVoteOnOpenPoll() public {
        uint timestamp = 300;
        string[] memory options = new string[](2);
        options[0] = "yes";
        options[1] = "no";
        uint expDate = timestamp;
        app.createPoll("Do you code?", options, expDate);

        uint pollId = 1;
        uint optionIndex = 0;
        skip(timestamp + 5);

        vm.expectRevert(PollDApp.PollClosed.selector);
        app.vote(pollId, optionIndex);
    }
}
