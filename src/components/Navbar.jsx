import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";

const Navbar = () => {
  const navigate = useNavigate();
  const [userRole, setUserRole] = useState('');

  useEffect(() => {
    // Get user role from localStorage
    const user = JSON.parse(localStorage.getItem('user') || '{}');
    setUserRole(user.role || '');
  }, []);

  const handleLogout = () => {
    // Clear user session
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    // Redirect to login page
    navigate('/login');
  };

  return (
    <nav className="navbar navbar-dark bg-dark">
      <div className="container-fluid">
        <span className="navbar-brand mb-0 h1">
          <i className="fa fa-users me-2"></i>
          {userRole === 'admin' ? 'Admin Panel' : 'User Panel'}
        </span>
        <button 
          onClick={handleLogout}
          className="btn btn-outline-light d-flex align-items-center"
          style={{
            borderRadius: '20px',
            padding: '6px 16px',
            borderColor: 'rgba(255, 255, 255, 0.5)',
            backgroundColor: 'rgba(255, 255, 255, 0.1)'
          }}
        >
          <i className="fa fa-sign-out-alt me-2"></i>
          <span>Logout</span>
        </button>
      </div>
    </nav>
  );
};

export default Navbar;
