import argparse
import subprocess
import shlex
import json

def request_contract_address(args):
    return args.contract_address if args.contract_address else input("Enter the contract address: ")

def request_poll_id(args):
    return args.poll_id if args.poll_id else input("Enter the poll ID: ")

def request_rpc_url(args):
    return args.rpc_url if args.rpc_url else input("Enter the RPC URL: ")

def request_erc_2335_key(args):
    return args.erc_2335_key if args.erc_2335_key else input("Enter the ERC-2335 key: ")

def get_poll_count(args):
    contract_address = request_contract_address(args)

    command = (
        f'cast call {contract_address} '
        f'"getPollCount()(uint)"'
    )
    execute_command(command)

def get_poll(args):
    contract_address = request_contract_address(args)
    poll_id = request_poll_id(args)

    command = (
        f'cast call {contract_address} '
        f'"getPoll(uint)((uint,address,string,(uint,uint,string,uint)[]))" {poll_id}'
    )
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
    poll_id = request_poll_id(args)
    rpc_url = request_rpc_url(args)
    erc_2335_key = request_erc_2335_key(args)
    choice = args.choice if args.choice else input("Enter your vote (option index): ")

    command = (
        f'cast send {contract_address} '
        f'"vote(uint,uint)" {poll_id} {choice} '
        f'--rpc-url {rpc_url} '
        f'--account {erc_2335_key}'
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
    get_poll_count_parser.add_argument('contract_address', nargs='?', help='Contract address')
    get_poll_count_parser.set_defaults(func=get_poll_count)

    # get-poll with optional arguments
    get_poll_parser = subparsers.add_parser('get-poll', help='Get details of a poll')
    get_poll_parser.add_argument('contract_address', nargs='?', help='Contract address')
    get_poll_parser.add_argument('poll_id', nargs='?', type=int, help='Poll ID')
    get_poll_parser.set_defaults(func=get_poll)

    # create-poll with optional arguments
    create_poll_parser = subparsers.add_parser('create-poll', help='Create a new poll')
    create_poll_parser.add_argument('contract_address', nargs='?', help='Contract address')
    create_poll_parser.add_argument('question', nargs='?', help='Poll question')
    create_poll_parser.add_argument('rpc_url', nargs='?', help='RPC URL')
    create_poll_parser.add_argument('erc_2335_key', nargs='?', help='ERC-2335 key')
    create_poll_parser.set_defaults(func=create_poll)

    # vote with optional arguments
    vote_parser = subparsers.add_parser('vote', help='Vote on a poll')
    vote_parser.add_argument('contract_address', nargs='?', help='Contract address')
    vote_parser.add_argument('poll_id', nargs='?', type=int, help='Poll ID')
    vote_parser.add_argument('choice', nargs='?', type=int, help='Your vote (1 for yes, 0 for no)')
    vote_parser.add_argument('rpc_url', nargs='?', help='RPC URL')
    vote_parser.add_argument('erc_2335_key', nargs='?', help='ERC-2335 key')
    vote_parser.set_defaults(func=vote)

    args = parser.parse_args()

    if args.command is None:
        parser.print_help()
    else:
        args.func(args)

if __name__ == "__main__":
    main()
