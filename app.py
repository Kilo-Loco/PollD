import json
import os
import streamlit as st
from dotenv  import load_dotenv
from pathlib import Path
from web3 import Web3

# if 'poll_count' not in st.session_state:
#     st.session_state["poll_count"] = 0

# def handle_click(amount):
#     st.session_state["poll_count"] = amount

# st.write(st.session_state.poll_count)

# with st.form("poll_count_form"):
#     async_value = 0
#     st.form_submit_button("Set Poll Count",  on_click=handle_click, args=async_value)
#     async_value = st.number_input("Provide async amount", step=1)


load_dotenv()

w3 = Web3(Web3.HTTPProvider(os.getenv("WEB3_PROVIDER_URI")))

@st.cache_resource
def load_contract():

    with open(Path('./abi/PollDAppABI.json')) as f:
        abi = json.load(f)

    contract_address = os.getenv("SMART_CONTRACT_ADDRESS")

    contract = w3.eth.contract(
        address=w3.to_checksum_address(contract_address),
        abi=abi
    )

    return contract

contract = load_contract()

if 'poll_count' not in st.session_state:
    st.session_state['poll_count'] = contract.functions.getPollCount().call()

def refresh_poll_count():
    st.session_state['poll_count'] = contract.functions.getPollCount().call()
    st.experimental_rerun()

st.title("PollD")
st.text(f"Total Polls: {st.session_state.poll_count}")

with st.form("create_poll_form"):
    question = st.text_input("Enter your poll question...")
    st.divider()
    option1 = st.text_input("Option 1")
    option2 = st.text_input("Option 2")
    st.divider()

    if st.form_submit_button("Create Poll"):
        wallet_address = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
        tx = contract.functions.createPoll(
            question,
            [option1, option2],
            0
        ).build_transaction({
            "from": wallet_address,
            "nonce": w3.eth.get_transaction_count(wallet_address)
        })
        signed_tx = w3.eth.account.sign_transaction(
            tx, 
            private_key="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
        )
        tx_hash = w3.eth.send_raw_transaction(signed_tx.rawTransaction)
        w3.eth.wait_for_transaction_receipt(tx_hash)

        st.session_state['last_transaction'] = w3.eth.get_transaction(tx_hash)

        refresh_poll_count()
    
if 'last_transaction' in st.session_state:
    st.success("Poll Created")
    with st.expander("Transaction Details"):
        st.write(st.session_state['last_transaction'])