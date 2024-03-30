## PollD

PollD is a dApp that allows users to create polls with an unlimited amount of options to choose from. PollD only allows for a single option to be selected for each poll and a user (wallet) can only vote once.

To view the deployed contract, visit [Etherscan (Sepolia)](https://sepolia.etherscan.io/address/0x18654a89b03ed072474cd79d4d10def09117a169).

You can interact with the `PollDApp` smart contract using the following functions:

### Call
- `getPollCount()`: Returns the total amount of polls and the last PollID used.
- `getPoll(uint)(PollResponse)`: Get relevant information of a Poll by its ID.

### Send
- `createPoll(string,string[])`: Creates a Poll given the question and an array of options to choose from.
- `vote(uint256,uint256)`: Allows a user to vote given the PollID and the option index.

<details>
<summary>Response Structures</summary>

```solidity
struct PollOption {
    uint pollId;
    uint optionIndex;
    string title;
    uint voteCount;
}

struct PollResponse {
    uint id;
    address creator;
    string question;
    PollOption[] options;
}
```
</details>

## Usage

You can use Foundry to build, test, interact, and deploy PollD.

### Build

Foundryup must be running to build the project:

```shell
$ foundryup
```

In the root directory of the project, run the following command to compile the project:

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Interaction

Use Anvil to create a local testnet node:
```shell
$ anvil
```

#### Example Send
```shell
$ cast send <CONTRACT_ADDRESS>\
    "createPoll(string,string[])" "Favorite color?" "['red','blue','yellow']"\
    --rpc-url <RPC_URL>\
    --account <ERC_2335_KEY>
```

#### Example Call
```shell
$ cast call <CONTRACT_ADDRESS>\
    "getPoll(uint)(uint,address,string,uint)" 1
```

<details>
<summary>Create ERC-2335 Key</summary>

```bash
$ cast wallet import <KEY_NAME> --private-key <WALLET_PRIVATE_KEY>
```
</details>

### Deploy

```shell
$ forge script script/DeployPollDApp.s.sol\
    --rpc-url <RPC_URL>\
    --broadcast\
    --account <ERC_2335_KEY>\
    --sender  <WALLET_ADDRESS>
```

## Requirements

To install [Foundryup](https://book.getfoundry.sh/getting-started/installation#using-foundryup), run the following command in your terminal:
```shell
$ curl -L https://foundry.paradigm.xyz | bash
```
