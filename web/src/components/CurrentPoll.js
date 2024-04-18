import React, { useState } from 'react';

function CurrentPoll() {
    const [vote, setVote] = useState('');

    const handleVoteChange = (event) => {
        setVote(event.target.value);
    };

    const submitVote = () => {
        alert(`Your vote for '${vote}' has been submitted!`);
    };

    return (
        <div className="p-5">
            <h1 className="text-xl font-bold mb-4">Current Poll</h1>
            <p className="mb-2">Who is your favorite blockchain developer?</p>
            <form onSubmit={e => { e.preventDefault(); submitVote(); }} className="space-y-2">
                <div>
                    <input type="radio" value="Alice" checked={vote === "Alice"} onChange={handleVoteChange} className="mr-2" /> Alice
                </div>
                <div>
                    <input type="radio" value="Bob" checked={vote === "Bob"} onChange={handleVoteChange} className="mr-2" /> Bob
                </div>
                <div>
                    <input type="radio" value="Charlie" checked={vote === "Charlie"} onChange={handleVoteChange} className="mr-2" /> Charlie
                </div>
                <button type="submit" className="mt-4 px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-700">Submit Vote</button>
            </form>
        </div>
    );
}

export default CurrentPoll;
