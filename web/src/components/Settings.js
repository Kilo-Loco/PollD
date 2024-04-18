import React, { useState } from 'react';

function Settings() {
    const [network, setNetwork] = useState('mainnet');
    const [notifications, setNotifications] = useState(true);

    return (
        <div className="p-5">
            <h1 className="text-xl font-bold mb-4">Settings</h1>

            <form>
                <div className="mb-4">
                    <label htmlFor="network" className="block text-gray-700 text-sm font-bold mb-2">
                        Blockchain Network
                    </label>
                    <select
                        id="network"
                        value={network}
                        onChange={(e) => setNetwork(e.target.value)}
                        className="shadow border rounded py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
                    >
                        <option value="mainnet">Ethereum Mainnet</option>
                        <option value="ropsten">Ropsten (testnet)</option>
                        <option value="rinkeby">Rinkeby (testnet)</option>
                        <option value="goerli">Goerli (testnet)</option>
                        <option value="kovan">Kovan (testnet)</option>
                    </select>
                </div>

                <div className="mb-4">
                    <label htmlFor="notifications" className="flex items-center cursor-pointer">
                        <input
                            type="checkbox"
                            id="notifications"
                            checked={notifications}
                            onChange={() => setNotifications(!notifications)}
                            className="form-checkbox h-5 w-5 text-blue-600"
                        /><span className="ml-2 text-gray-700 text-sm">
                            Enable Notifications
                        </span>
                    </label>
                </div>

                <button
                    type="submit"
                    className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-700 focus:outline-none focus:shadow-outline"
                >
                    Save Changes
                </button>
            </form>
        </div>
    );
}

export default Settings;
