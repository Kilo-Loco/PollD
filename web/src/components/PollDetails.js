// import React, { useEffect, useState } from 'react';
// import { useParams } from 'react-router-dom';
// import { ethers } from 'ethers';
// import ContractABI from '../abis/ContractABI.json';

// function PollDetails() {
//     const { id } = useParams();
//     const [poll, setPoll] = useState(null);
//     const [hasVoted, setHasVoted] = useState(false);
//     const [loading, setLoading] = useState(false);

//     useEffect(() => {
//         async function fetchPoll() {
//             const provider = new ethers.providers.JsonRpcProvider(process.env.REACT_APP_ETH_NODE);
//             const contract = new ethers.Contract(process.env.REACT_APP_CONTRACT_ADDRESS, ContractABI, provider);
//             const pollDetails = await contract.getPoll(id);
//             setPoll(pollDetails);
//         }

//         fetchPoll();
//     }, [id]);

//     async function handleVote(optionIndex) {
//         setLoading(true);
//         try {
//             const provider = new ethers.providers.Web3Provider(window.ethereum);
//             const signer = provider.getSigner();
//             const contract = new ethers.Contract(process.env.REACT_APP_CONTRACT_ADDRESS, ContractABI, signer);
//             await contract.vote(id, optionIndex);
//             setHasVoted(true);
//         } catch (error) {
//             console.error('Error voting:', error);
//         }
//         setLoading(false);
//     }

//     return (
//         <div>
//             {poll ? (
//                 <>
//                     <h2>{poll.question}</h2>
//                     <ul>
//                         {poll.options.map((option, index) => (
//                             <li key={index}>
//                                 {option.description} - Votes: {option.voteCount}
//                                 {!hasVoted && <button onClick={() => handleVote(index)}>Vote</button>}
//                             </li>
//                         ))}
//                     </ul>
//                 </>
//             ) : (
//                 <p>Loading poll details...</p>
//             )}
//             {loading && <p>Sending vote...</p>}
//         </div>
//     );
// }

// export default PollDetails;
