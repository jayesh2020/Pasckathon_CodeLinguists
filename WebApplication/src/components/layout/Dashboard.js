import React from 'react';
import { Link } from 'react-router-dom';
const Dashboard = () => {
  return (
    <div>
      Dashboard
      <Link to='/imagetest'>Test</Link>
      <Link to='/doctorsearch'>Search Doctor</Link>
    </div>
  );
};

export default Dashboard;
