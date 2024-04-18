import React from 'react';

function PollResults() {
    const results = [
        { name: 'Alice', votes: 65 },
        { name: 'Bob', votes: 45 },
        { name: 'Charlie', votes: 30 }
    ];

    return (
        <div className="p-5">
            <h1 className="text-xl font-bold mb-4">Poll Results</h1>
            <ul className="list-disc pl-5">
                {results.map(result => (
                    <li key={result.name}>{result.name}: {result.votes} votes</li>
                ))}
            </ul>
        </div>
    );
}

export default PollResults;
