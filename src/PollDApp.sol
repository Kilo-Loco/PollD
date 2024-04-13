// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Poll, PollOption, PollDetails} from "./Models.sol";

contract PollDApp {
    error InvalidOptionCount();
    error InvalidPoll();
    error InvalidPollOption();
    error CannotVoteAgain();
    error PollClosed();

    uint private s_pollCount;
    mapping(uint => Poll) private s_polls;

    modifier validatePoll(uint _pollId) {
        if (_pollId > s_pollCount) {
            revert InvalidPoll();
        }
        _;
    }

    function getPollCount() external view returns (uint) {
        return s_pollCount;
    }

    function getPoll(
        uint _pollId
    ) public view validatePoll(_pollId) returns (PollDetails memory) {
        Poll storage poll = s_polls[_pollId];

        PollOption[] memory options = new PollOption[](
            s_polls[_pollId].optionCount
        );
        for (uint i = 0; i < s_polls[_pollId].optionCount; i++) {
            options[i] = s_polls[_pollId].options[i];
        }
        PollDetails memory details = PollDetails(
            poll.id,
            poll.creator,
            poll.question,
            poll.expDate,
            options
        );
        return details;
    }

    function getPolls(
        uint _index,
        uint _pollsPerPage
    ) external view returns (PollDetails[] memory) {
        if (s_pollCount == 0 || (_index * _pollsPerPage) > s_pollCount) {
            return new PollDetails[](0);
        } else if (s_pollCount <= _pollsPerPage) {
            PollDetails[] memory pollDetails = new PollDetails[](s_pollCount);
            uint i = 0;
            for (uint j = s_pollCount; j > 0; j--) {
                pollDetails[i] = getPoll(j);
                i++;
            }
            return pollDetails;
        } else {
            uint startIndex = s_pollCount - (_index * _pollsPerPage);
            uint totalPages = s_pollCount / _pollsPerPage;
            uint endIndex = (_index < totalPages)
                ? (startIndex - _pollsPerPage)
                : (startIndex - (s_pollCount % _pollsPerPage));

            uint totalPolls = startIndex - endIndex;
            PollDetails[] memory pollDetails = new PollDetails[](totalPolls);

            uint i = 0;
            for (uint j = startIndex; j > endIndex; j--) {
                pollDetails[i] = getPoll(j);
                i++;
            }

            return pollDetails;
        }
    }

    function createPoll(
        string calldata _question,
        string[] calldata _options,
        uint _expDate
    ) external {
        if (_options.length < 2) {
            revert InvalidOptionCount();
        }

        s_pollCount++;
        uint newPollId = s_pollCount;

        Poll storage newPoll = s_polls[newPollId];
        newPoll.id = newPollId;
        newPoll.creator = msg.sender;
        newPoll.question = _question;
        newPoll.optionCount = _options.length;
        newPoll.expDate = _expDate;

        for (uint i = 0; i < _options.length; i++) {
            PollOption memory _newPollOption = PollOption(
                newPollId,
                i,
                _options[i],
                0
            );
            newPoll.options[i] = _newPollOption;
        }
    }

    function vote(
        uint _pollId,
        uint _optionIndex
    ) external validatePoll(_pollId) {
        Poll storage poll = s_polls[_pollId];
        if (poll.expDate != 0 && poll.expDate < block.timestamp) {
            revert PollClosed();
        }
        if (_optionIndex >= poll.optionCount) {
            revert InvalidPollOption();
        }
        if (poll.addressDidVoteMap[msg.sender]) {
            revert CannotVoteAgain();
        }

        poll.options[_optionIndex].voteCount++;
        poll.addressDidVoteMap[msg.sender] = true;
    }
}
