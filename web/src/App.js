import React from 'react';
import {
  BrowserRouter as Router,
  Routes,
  Route,
  Link
} from 'react-router-dom';
import CurrentPoll from './components/CurrentPoll';
import PollResults from './components/PollResults';
import Settings from './components/Settings';

function App() {
  return (
    <Router>
      <div>
        <nav style={{ marginBottom: '20px' }}>
          <Link to="/" style={{ padding: '10px' }}>Current Poll</Link>
          <Link to="/results" style={{ padding: '10px' }}>Poll Results</Link>
          <Link to="/settings" style={{ padding: '10px' }}>Settings</Link>
        </nav>
        <Routes>
          <Route path="/" element={<CurrentPoll />} />
          <Route path="/results" element={<PollResults />} />
          <Route path="/settings" element={<Settings />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
