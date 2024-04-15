// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {PollDApp} from "../src/PollDApp.sol";
import {Poll, PollOption, PollDetails} from "../src/Models.sol";

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

    modifier hasManyPolls(uint _pollCount) {
        string[] memory options = new string[](2);
        options[0] = "yes";
        options[1] = "no";

        for (uint i = 0; i < _pollCount; i++) {
            app.createPoll("Do you code?", options, 0);
        }
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

        PollDetails memory details = app.getPoll(pollId);

        assertEq(details.id, pollId, "Expected PollIDs to match.");
        assertEq(details.options.length, 2, "Expected poll count to be 2.");
    }

    function testGetPollMustExist() public {
        vm.expectRevert(PollDApp.InvalidPoll.selector);
        app.getPoll(5);
    }

    function testGetPollsWithExistingPoll() public hasExistingPoll {
        PollDetails[] memory arr = app.getPolls(0, 3);
        assertEq(
            arr.length,
            1,
            "Expected an array of PollDetails with 1 item."
        );
    }

    function testGetPollsWithoutExistingPoll() public view {
        PollDetails[] memory arr = app.getPolls(0, 3);
        assertEq(
            arr.length,
            0,
            "Expected an array of PollDetails with 1 item."
        );
    }

    function testNoPollsAtIndexHigherThanPollCount() public hasExistingPoll {
        PollDetails[] memory arr = app.getPolls(123, 3);
        assertEq(
            arr.length,
            0,
            "Expected an array of PollDetails with 1 item."
        );
    }

    function testGetPollsAtNextIndex() public hasManyPolls(10) {
        uint pollsPerPage = 3;
        PollDetails[] memory arr = app.getPolls(1, pollsPerPage);
        assertEq(arr.length, pollsPerPage, "Expected a full page of polls.");
    }

    function testGetPollsAtLastIndex() public hasManyPolls(10) {
        // This number must match the amount passed to hasManyPolls
        uint pollsCreated = 10;
        uint pollsPerPage = 3;
        uint pollCountForLastPage = pollsCreated % pollsPerPage;
        PollDetails[] memory arr = app.getPolls(3, pollsPerPage);
        assertEq(
            arr.length,
            pollCountForLastPage,
            "Expected remaining amount of polls."
        );
    }

    function testGetPollsReturnInDescendingOrder() public hasManyPolls(3) {
        // This number must match the amount passed to hasManyPolls
        uint pollsCreated = 3;
        PollDetails[] memory arr = app.getPolls(0, pollsCreated);
        assertEq(arr[0].id, 3, "First poll should be id 3");
        assertEq(arr[1].id, 2, "Second poll should be id 2");
        assertEq(arr[2].id, 1, "Last poll should be id 1");
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
