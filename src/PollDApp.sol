// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PollDApp {
    struct PollOption {
        uint pollId;
        uint optionIndex;
        string title;
        uint voteCount;
    }

    struct Poll {
        uint id;
        address creator;
        string question;
        uint optionCount;
        mapping(uint => PollOption) options;
        mapping(address => bool) addressDidVoteMap;
    }

    error InvalidOptionCount();
    error InvalidPoll();
    error InvalidPollOption();
    error CannotVoteAgain();

    uint public pollCount;
    mapping(uint => Poll) polls;

    function getPoll(
        uint _pollId
    ) external view returns (uint, address, string memory, uint) {
        if (_pollId > pollCount) {
            revert InvalidPoll();
        }

        return (
            polls[_pollId].id,
            polls[_pollId].creator,
            polls[_pollId].question,
            polls[_pollId].optionCount
        );
    }

    function createPoll(
        string memory _question,
        string[] memory _options
    ) external {
        if (_options.length < 2) {
            revert InvalidOptionCount();
        }

        pollCount++;

        Poll storage newPoll = polls[pollCount];
        newPoll.id = pollCount;
        newPoll.creator = msg.sender;
        newPoll.question = _question;
        newPoll.optionCount = _options.length;

        for (uint i = 0; i < _options.length; i++) {
            PollOption memory _newPollOption = PollOption(
                pollCount,
                i,
                _options[i],
                0
            );
            newPoll.options[i] = _newPollOption;
        }
    }

    function vote(uint _pollId, uint _optionIndex) external {
        if (_pollId > pollCount) {
            revert InvalidPoll();
        }
        if (_optionIndex >= polls[_pollId].optionCount) {
            revert InvalidPollOption();
        }
        if (polls[_pollId].addressDidVoteMap[msg.sender]) {
            revert CannotVoteAgain();
        }

        polls[_pollId].options[_optionIndex].voteCount++;
        polls[_pollId].addressDidVoteMap[msg.sender] = true;
    }

    function pollResults(
        uint _pollId
    ) external view returns (PollOption[] memory) {
        if (_pollId > pollCount) {
            revert InvalidPoll();
        }

        PollOption[] memory pollOptions = new PollOption[](
            polls[_pollId].optionCount
        );
        for (uint i = 0; i < polls[_pollId].optionCount; i++) {
            pollOptions[i] = polls[_pollId].options[i];
        }
        return pollOptions;
    }
}
