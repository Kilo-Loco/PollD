import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { ethers } from 'ethers';

function PollList() {
    const [polls, setPolls] = useState([]);

    useEffect(() => {
        async function fetchPolls() {
            const provider = new ethers.providers.JsonRpcProvider(process.env.REACT_APP_ETH_NODE);
            const contract = new ethers.Contract(process.env.REACT_APP_CONTRACT_ADDRESS, ContractABI, provider);
            const data = await contract.getPolls(0, 10); // Example of fetching the first 10 polls
            setPolls(data);
        }

        fetchPolls();
    }, []);

    return (
        <div>
            {polls.map((poll, index) => (
                <div key={index}>
                    <h3>{poll.question}</h3>
                    <Link to={`/poll/${poll.id}`}>View Poll</Link>
                </div>
            ))}
        </div>
    );
}

export default PollList;
