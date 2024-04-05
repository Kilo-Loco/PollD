## PollD

PollD is a dApp that allows users to create polls with an unlimited amount of options to choose from. PollD only allows for a single option to be selected for each poll and a user (wallet) can only vote once.

To view the deployed contract, visit [Etherscan (Sepolia)](https://sepolia.etherscan.io/address/0x0a458EdBE13FE5E6DeB91a136fcf6Dd14Ed165f9).

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
    uint expDate;
    PollOption[] options;
}
```
</details>

## Usage

To easily interact with PollD, you can use the make commands located in the [Makefile](./Makefile).

You can also interact with the contract directly from Foundry. Those examples will be listed in dropdowns.

### Build

Foundryup must be running to build the project:

```shell
$ make start
```

In the root directory of the project, run the following command to compile the project:

```shell
$ make build
```

<details>
<summary>Build using Foundry</summary>

```shell
$ foundryup
```

```shell
$ forge build
```
</details>

### Test

```shell
$ make tests
```

<details>
<summary>Test using Foundry</summary>

```shell
$ forge test
```
</details>

### Deploy

```shell
$ make deploy
```

<details>
<summary>Deploy using Foundry</summary>

```shell
$ forge script script/DeployPollDApp.s.sol\
    --rpc-url <RPC_URL>\
    --broadcast\
    --account <ERC_2335_KEY>\
    --sender  <WALLET_ADDRESS>
```
</details>

### Interaction

Create a local testnet node:

```shell
$ make local-chain
```

#### Get Poll Count
```shell
$ make get-poll-count
```

#### Get A Poll
```shell
$ make get-poll
```

#### Create A Poll
```shell
$ make create-poll
```

#### Vote On A Poll
```shell
$ make vote
```

PollD creates a config file for storing both the `contract_address` and `rpc_url`which are fields required for most interactions with the dApp. If you need to clear the config, run the following command:

```shell
$ make clear-config
```

<details>
<summary>Interact using Foundry</summary>

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
</details>

<details>
<summary>Create ERC-2335 Key</summary>

```bash
$ cast wallet import <KEY_NAME> --private-key <WALLET_PRIVATE_KEY>
```
</details>

## Requirements

To install [Foundryup](https://book.getfoundry.sh/getting-started/installation#using-foundryup), run the following command in your terminal:

```shell
$ make install-foundry
```

OR

```shell
$ curl -L https://foundry.paradigm.xyz | bash
```
