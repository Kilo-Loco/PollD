import json
import os
import streamlit as st
from dotenv  import load_dotenv
from pathlib import Path
from web3 import Web3

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

def add_field():
    st.session_state['option_count'] += 1

st.title("PollD")
st.text(f"Total Polls: {st.session_state.poll_count}")

with st.form("create_poll_form"):
    question = st.text_input("Enter your poll question...")

    st.divider()

    if 'option_count' not in st.session_state:
        st.session_state['option_count'] = 1
    for i in range(st.session_state['option_count']):
        st.text_input(f"Option {i+1}", key=f"option_{i+1}")
    st.form_submit_button("Add another field", on_click=add_field)

    st.divider()

    html_code = """
    <button onclick="connectWallet()">Connect to MetaMask</button>
    <p id="status"></p>
    <script>
    async function connectWallet() {
        if (typeof window.ethereum !== 'undefined') {
            try {
                const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
                document.getElementById('status').innerText = 'Connected: ' + accounts[0];
                // Add more JavaScript here to handle transactions
            } catch (error) {
                document.getElementById('status').innerText = 'Error connecting: ' + error.message;
            }
        } else {
            document.getElementById('status').innerText = 'MetaMask is not available.';
        }
    }
    </script>
    """

    st.markdown(html_code, unsafe_allow_html=True)

    if st.form_submit_button("Create Poll"):
        wallet_address = os.getenv("WALLET_ADDRESS")

        options = []
        for i in range(st.session_state['option_count']):
            options.append(st.session_state[f"option_{i+1}"])

        tx = contract.functions.createPoll(
            question,
            options,
            0
        ).build_transaction({
            "from": wallet_address,
            "nonce": w3.eth.get_transaction_count(wallet_address)
        })
        signed_tx = w3.eth.account.sign_transaction(
            tx, 
            private_key=os.getenv("WALLET_PRIVATE_KEY")
        )
        tx_hash = w3.eth.send_raw_transaction(signed_tx.rawTransaction)
        w3.eth.wait_for_transaction_receipt(tx_hash)

        st.session_state['last_transaction'] = w3.eth.get_transaction(tx_hash)

        refresh_poll_count()
    
if 'last_transaction' in st.session_state:
    st.success("Poll Created")
    with st.expander("Transaction Details"):
        st.write(st.session_state['last_transaction'])