// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

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
    uint expDate;
    mapping(uint => PollOption) options;
    mapping(address => bool) addressDidVoteMap;
}

struct PollDetails {
    uint id;
    address creator;
    string question;
    uint expDate;
    PollOption[] options;
}
