import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import Navbar from "./components/Navbar";
import Dashboard from "./pages/Dashboard";
import UsersPage from "./pages/UsersPage";
import CategoriesPage from "./pages/CategoriesPage";
import ProductsPage from "./pages/ProductsPage";
import OrdersPage from "./pages/OrdersPage";
import ProtectedRoute from "./components/ProtectedRoute";

const App = () => {
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState("dashboard");
  const [userRole, setUserRole] = useState('');

  useEffect(() => {
    // Check if user is logged in
    const user = JSON.parse(localStorage.getItem('user') || '{}');
    const token = localStorage.getItem('token');
    
    // If not authenticated, redirect to login
    if (!token || !user) {
      navigate('/login', { replace: true });
      return;
    }
    
    // If authenticated but not admin and trying to access admin routes
    if (user.role !== 'admin' && 
        (activeTab === 'users' || 
         activeTab === 'categories' || 
         activeTab === 'products' || 
         activeTab === 'orders')) {
      setActiveTab('dashboard');
      return;
    }
    
    setUserRole(user.role || '');
  }, [navigate, activeTab]);

  // Function to check if user has required role
  const hasPermission = (requiredRole) => {
    if (!requiredRole) return true;
    return userRole === requiredRole;
  };

  return (
    <>
      <Navbar />
      <div className="container py-4">
        <ul className="nav nav-tabs mb-4">
          <li className="nav-item">
            <button
              className={`nav-link ${activeTab === "dashboard" ? "active" : ""}`}
              onClick={() => setActiveTab("dashboard")}
            >
              <i className="fa fa-chart-line me-2"></i>Tổng quan
            </button>
          </li>

          {hasPermission('admin') && (
            <li className="nav-item">
              <button
                className={`nav-link ${activeTab === "users" ? "active" : ""}`}
                onClick={() => setActiveTab("users")}
              >
                <i className="fa fa-users me-2"></i>Người dùng
              </button>
            </li>
          )}

          <li className="nav-item">
            <button
              className={`nav-link ${activeTab === "categories" ? "active" : ""}`}
              onClick={() => setActiveTab("categories")}
            >
              <i className="fa fa-tags me-2"></i>Danh mục
            </button>
          </li>

          <li className="nav-item">
            <button
              className={`nav-link ${activeTab === "products" ? "active" : ""}`}
              onClick={() => setActiveTab("products")}
            >
              <i className="fa fa-box me-2"></i>Sản phẩm
            </button>
          </li>

          <li className="nav-item">
            <button
              className={`nav-link ${activeTab === "orders" ? "active" : ""}`}
              onClick={() => setActiveTab("orders")}
            >
              <i className="fa fa-shopping-cart me-2"></i>Đơn hàng
            </button>
          </li>
        </ul>

        {/* Protected routes based on role */}
        {activeTab === "dashboard" && (
          <ProtectedRoute>
            <Dashboard />
          </ProtectedRoute>
        )}
        {activeTab === "users" && (
          <ProtectedRoute requiredRole="admin">
            <UsersPage />
          </ProtectedRoute>
        )}
        {activeTab === "categories" && (
          <ProtectedRoute requiredRole="admin">
            <CategoriesPage />
          </ProtectedRoute>
        )}
        {activeTab === "products" && (
          <ProtectedRoute requiredRole="admin">
            <ProductsPage />
          </ProtectedRoute>
        )}
        {activeTab === "orders" && (
          <ProtectedRoute requiredRole="admin">
            <OrdersPage />
          </ProtectedRoute>
        )}
      </div>
    </>
  );
};

export default App;
