import React, { useState } from 'react';
import styled from 'styled-components';
import { useNavigate, useLocation } from 'react-router-dom';

const LoginContainer = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background-color: #f5f5f5;
  padding: 20px;
`;

const LoginCard = styled.div`
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  padding: 70px 60px;
  width: 100%;
  max-width: 600px;
  text-align: center;
`;

const Logo = styled.h1`
  color: #ff6b35;
  margin: 0 0 20px 0;
  font-size: 2.5rem;
`;

const Title = styled.h2`
  margin: 0 0 8px 0;
  color: #333;
  font-size: 1.5rem;
`;

const Subtitle = styled.p`
  color: #666;
  margin: 0 0 30px 0;
  font-size: 0.9rem;
`;

const FormGroup = styled.div`
  margin-bottom: 20px;
  text-align: left;
`;

const Label = styled.label`
  display: block;
  margin-bottom: 8px;
  color: #555;
  font-size: 0.9rem;
`;

const Input = styled.input`
  width: 100%;
  padding: 12px 16px;
  border: 1px solid #ddd;
  border-radius: 8px;
  font-size: 1rem;
  box-sizing: border-box;
  
  &:focus {
    outline: none;
    border-color: #ff6b35;
    box-shadow: 0 0 0 2px rgba(255, 107, 53, 0.2);
  }
`;

const ErrorText = styled.p`
  color: #e74c3c;
  margin-bottom: 15px;
  font-size: 0.9rem;
`;

const Button = styled.button`
  width: 100%;
  padding: 14px;
  background-color: #ff6b35;
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  transition: background-color 0.2s;
  
  &:hover {
    background-color: #e65a2b;
  }
  
  &:active {
    transform: translateY(1px);
  }
`;

const LoginPage = () => {
  const location = useLocation();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
  e.preventDefault();
  setError('');
  setLoading(true);

  try {
    const response = await fetch('http://localhost:5000/api/auth/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ 
        email: email.trim(),
        password: password
      }),
    });

    const data = await response.json();
    
    if (!response.ok) {
      throw new Error(data.message || 'Login failed. Please check your credentials and try again.');
    }

    if (!data || !data.user) {
      throw new Error('Invalid response from server');
    }

    // Store the token and user data
    localStorage.setItem('token', data.token);
    localStorage.setItem('user', JSON.stringify({
      id: data.user.id,
      name: data.user.name,
      email: data.user.email,
      role: data.user.role
    }));
    
    // Redirect to dashboard or previous location
    const from = location.state?.from?.pathname || '/dashboard';
    navigate(from, { replace: true });
    
  } catch (err) {
    setError(err.message || 'An error occurred during login. Please try again.');
    console.error('Login error:', err);
  } finally {
    setLoading(false);
  }
};

  return (
    <LoginContainer>
      <LoginCard>
        <Logo>EASY SMART</Logo>
        <Title>Welcome Back!</Title>
        <Subtitle>Enter to access your account</Subtitle>
        
        <form onSubmit={handleSubmit}>
          <FormGroup>
            <Label htmlFor="email">Email</Label>
            <Input
              id="email"
              type="email"
              placeholder="Enter your email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />
          </FormGroup>
          
          <FormGroup>
            <Label htmlFor="password">Password</Label>
            <Input
              id="password"
              type="password"
              placeholder="Enter your password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />
          </FormGroup>
          
          {error && <ErrorText>{error}</ErrorText>}
          <Button type="submit" disabled={loading}>
            {loading ? 'Signing in...' : 'Sign In'}
          </Button>
        </form>
      </LoginCard>
    </LoginContainer>
  );
};

export default LoginPage;
