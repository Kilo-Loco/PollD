import React from "react";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import PollList from './components/PollList';
import PollDetails from './components/PollDetails';
import CreatePoll from './components/CreatePoll';

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" exact component={PollList} />
        {/* <Route path="/poll/:id" component={PollDetails} />
        <Route path="/create" component={CreatePoll} /> */}
      </Routes>
    </Router>
  );
}

export default App;
