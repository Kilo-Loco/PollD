// import React, { useState } from 'react';
// import { ethers } from 'ethers';
// import ContractABI from '../abi/PollDAppABI.json';

// function CreatePoll() {
//     const [question, setQuestion] = useState('');
//     const [options, setOptions] = useState(['', '']);
//     const [expDate, setExpDate] = useState('');
//     const [loading, setLoading] = useState(false);

//     const handleOptionChange = (index, value) => {
//         const newOptions = [...options];
//         newOptions[index] = value;
//         setOptions(newOptions);
//     };

//     const addOption = () => {
//         setOptions([...options, '']);
//     };

//     const handleCreatePoll = async () => {
//         if (options.length < 2) {
//             alert('Please add at least two options.');
//             return;
//         }
//         setLoading(true);
//         try {
//             const provider = new ethers.providers.Web3Provider(window.ethereum);
//             const signer = provider.getSigner();
//             const contract = new ethers.Contract(process.env.REACT_APP_CONTRACT_ADDRESS, ContractABI, signer);
//             await contract.createPoll(question, options, Math.floor(new Date(expDate).getTime() / 1000));
//             setQuestion('');
//             setOptions(['', '']);
//             setExpDate('');
//         } catch (error) {
//             console.error('Error creating poll:', error);
//         }
//         setLoading(false);
//     };

//     return (
//         <div>
//             <h2>Create a New Poll</h2>
//             <input
//                 type="text"
//                 value={question}
//                 onChange={(e) => setQuestion(e.target.value)}
//                 placeholder="Enter poll question"
//             />
//             <h4>Options:</h4>
//             {options.map((option, index) => (
//                 <input
//                     key={index}
//                     type="text"
//                     value={option}
//                     onChange={(e) => handleOptionChange(index, e.target.value)}
//                     placeholder={`Option ${index + 1}`}
//                 />
//             ))}
//             <button onClick={addOption}>Add Option</button>
//             <input
//                 type="date"
//                 value={expDate}
//                 onChange={(e) => setExpDate(e.target.value)}
//                 placeholder="Expiration Date"
//             />
//             <button onClick={handleCreatePoll} disabled={loading}>
//                 {loading ? 'Creating...' : 'Create Poll'}
//             </button>
//         </div>
//     );
// }

// export default CreatePoll;