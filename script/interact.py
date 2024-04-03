import argparse
import subprocess
import shlex
import json

def require_contract_address(subparser):
    subparser.add_argument('contract_address', nargs='?', help='Contract address')

def request_contract_address(args):
    return args.contract_address if args.contract_address else input("Enter the contract address: ")

def require_rpc_url(subparser):
    subparser.add_argument('rpc_url', nargs='?', help='RPC URL')

def request_rpc_url(args):
    return args.rpc_url if args.rpc_url else input("Enter the RPC URL: ")

def require_erc_2335_key(subparser):
    subparser.add_argument('erc_2335_key', nargs='?', help='ERC-2335 key')

def request_erc_2335_key(args):
    return args.erc_2335_key if args.erc_2335_key else input("Enter the ERC-2335 key: ")

def require_poll_id(subparser):
    subparser.add_argument('poll_id', nargs='?', type=int, help='Poll ID')

def request_poll_id(args):
    return args.poll_id if args.poll_id else input("Enter the poll ID: ")

def get_poll_count(args):
    contract_address = request_contract_address(args)
    rpc_url = request_rpc_url(args)

    command = (
        f'cast call {contract_address} '
        f'"getPollCount()(uint)" '
        f'--rpc-url {rpc_url}'
    )
    execute_command(command)

def get_poll(args):
    contract_address = request_contract_address(args)
    rpc_url = request_rpc_url(args)
    poll_id = request_poll_id(args)

    command = (
        f'cast call {contract_address} '
        f'"getPoll(uint)((uint,address,string,(uint,uint,string,uint)[]))" {poll_id} '
        f'--rpc-url {rpc_url}'
    )
    print(command)
    execute_command(command)

def create_poll(args):
    contract_address = request_contract_address(args)
    rpc_url = request_rpc_url(args)
    erc_2335_key = request_erc_2335_key(args)
    question = args.question if args.question else input("Enter the poll question: ")

    print("Enter poll options (type 'done' when finished):")
    options = []
    while True:
        option = input(f"Option {len(options)+1}: ")
        if option.lower() == 'done':
            break
        options.append(option)

    options_json = json.dumps(options)
    options_json = options_json.replace(" ", "").replace('"', '\\"')

    command = (
        f'cast send {contract_address} '
        f'"createPoll(string,string[])" "{question}" "{options_json}" '
        f'--rpc-url {rpc_url} '
        f'--account {erc_2335_key}'
    )
    execute_command(command)

def vote(args):
    contract_address = request_contract_address(args)
    rpc_url = request_rpc_url(args)
    erc_2335_key = request_erc_2335_key(args)
    poll_id = request_poll_id(args)
    choice = args.choice if args.choice else input("Enter your vote (option index): ")

    command = (
        f'cast send {contract_address} '
        f'"vote(uint,uint)" {poll_id} {choice} '
        f'--rpc-url {rpc_url} '
        f'--account {erc_2335_key}'
    )
    execute_command(command)

def deploy(args):
    rpc_url = request_rpc_url(args)
    erc_2335_key = request_erc_2335_key(args)
    wallet_address = args.wallet_address if args.wallet_address else input("Enter the wallet address: ")

    command = (
        f'forge script script/DeployPollDApp.s.sol '
        f'--rpc-url {rpc_url} '
        f'--broadcast '
        f'--account {erc_2335_key} '
        f'--sender {wallet_address}'
    )
    execute_command(command)

def execute_command(command):
    args = shlex.split(command)
    result = subprocess.run(args, capture_output=True, text=True)
    if result.returncode == 0:
        print("Command executed successfully!")
        print("Output:", result.stdout)
    else:
        print("Error executing command:")
        print(result.stderr)

def main():
    parser = argparse.ArgumentParser(description="Interact with smart contracts")
    subparsers = parser.add_subparsers(help='commands', dest='command')

    # get-poll-count with optional arguments
    get_poll_count_parser = subparsers.add_parser('get-poll-count', help='Returns the total amount of polls and the last PollID used')
    require_contract_address(get_poll_count_parser)
    require_rpc_url(get_poll_count_parser)
    get_poll_count_parser.set_defaults(func=get_poll_count)

    # get-poll with optional arguments
    get_poll_parser = subparsers.add_parser('get-poll', help='Get details of a poll')
    require_contract_address(get_poll_parser)
    require_rpc_url(get_poll_parser)
    require_poll_id(get_poll_parser)
    get_poll_parser.set_defaults(func=get_poll)

    # create-poll with optional arguments
    create_poll_parser = subparsers.add_parser('create-poll', help='Create a new poll')
    require_contract_address(create_poll_parser)
    require_rpc_url(create_poll_parser)
    require_erc_2335_key(create_poll_parser)
    create_poll_parser.add_argument('question', nargs='?', help='Poll question')
    create_poll_parser.set_defaults(func=create_poll)

    # vote with optional arguments
    vote_parser = subparsers.add_parser('vote', help='Vote on a poll')
    require_contract_address(vote_parser.add_argument)
    require_rpc_url(vote_parser)
    require_erc_2335_key(vote_parser)
    require_poll_id(vote_parser)
    vote_parser.add_argument('choice', nargs='?', type=int, help='Your vote (1 for yes, 0 for no)')
    vote_parser.set_defaults(func=vote)

    # deploy with optional arguments
    deploy_parser = subparsers.add_parser('deploy', help='Deploy the DApp')
    require_rpc_url(deploy_parser)
    require_erc_2335_key(deploy_parser)
    deploy_parser.add_argument('wallet_address', nargs='?', help='Wallet address')
    deploy_parser.set_defaults(func=deploy)

    args = parser.parse_args()

    if args.command is None:
        parser.print_help()
    else:
        args.func(args)

if __name__ == "__main__":
    main()
