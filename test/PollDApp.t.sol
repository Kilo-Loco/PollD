// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {PollDApp} from "../src/PollDApp.sol";

contract PollDAppTest is Test {
    PollDApp public app;

    function setUp() public {
        app = new PollDApp();
    }

    function createExamplePoll() private {
        string[] memory options = new string[](2);
        options[0] = "yes";
        options[1] = "no";
        app.createPoll("Do you code?", options);
    }

    function testCreatePoll() public {
        assertEq(app.pollCount(), 0, "Expected pollCount to start at 0");

        createExamplePoll();

        assertEq(app.pollCount(), 1, "Expected pollCount to increase to 1");
    }

    function testCreatePollMustHaveMultipleOptions() public {
        string[] memory options = new string[](1);
        options[0] = "yes";

        vm.expectRevert(PollDApp.InvalidOptionCount.selector);
        app.createPoll("Do you code?", options);
    }

    function testGetPoll() public {
        createExamplePoll();

        uint pollId = 1;

        (uint _pollId, , , uint optionCount) = app.getPoll(pollId);

        assertEq(_pollId, pollId, "Expected PollIDs to match.");
        assertEq(optionCount, 2, "Expected poll count to be 2.");
    }

    function testGetPollMustExist() public {
        vm.expectRevert(PollDApp.InvalidPoll.selector);
        app.getPoll(5);
    }

    function testCannotVoteOnFuturePoll() public {
        vm.expectRevert(PollDApp.InvalidPoll.selector);
        app.vote(1, 0);
    }

    function testVoteMustHaveValidOptionIndex() public {
        createExamplePoll();

        vm.expectRevert(PollDApp.InvalidPollOption.selector);
        app.vote(1, 5);
    }

    function testVoterCantVoteAgain() public {
        createExamplePoll();
        uint pollId = 1;
        app.vote(pollId, 0);

        vm.expectRevert(PollDApp.CannotVoteAgain.selector);
        app.vote(pollId, 1);
    }

    function testGetPollResults() public {
        createExamplePoll();
        uint pollId = 1;
        app.vote(pollId, 0);

        PollDApp.PollOption[] memory options = app.pollResults(pollId);

        assertEq(options[0].voteCount, 1, "Expected 1 vote for first option");
    }

    function testCannotGetPollResultsFromInvalidPoll() public {
        vm.expectRevert(PollDApp.InvalidPoll.selector);
        app.pollResults(5);
    }
}
