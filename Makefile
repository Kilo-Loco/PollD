install-foundry:; curl -L https://foundry.paradigm.xyz | bash

start:; foundryup

build:; forge build

test:; forge test

local-chain:; anvil

get-poll-count:; python3 script/interact.py get-poll-count

get-poll:; python3 script/interact.py get-poll

create-poll:; python3 script/interact.py create-poll

vote:; python3 script/interact.py vote