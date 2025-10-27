import React, { useState } from "react";
import Navbar from "./components/Navbar";
import UsersPage from "./pages/UsersPage";
import CategoriesPage from "./pages/CategoriesPage";
import ProductsPage from "./pages/ProductsPage";
import OrdersPage from './pages/OrdersPage';

const App = () => {
  const [activeTab, setActiveTab] = useState("users");

  return (
    <>
      <Navbar />
      <div className="container py-4">
        <ul className="nav nav-tabs mb-4">
          <li className="nav-item">
            <button
              className={`nav-link ${activeTab === "users" ? "active" : ""}`}
              onClick={() => setActiveTab("users")}
            >
              <i className="fa fa-users me-2"></i>Người dùng
            </button>
          </li>
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
              <i className="fa fa-box me-2"></i>Đơn hàng
            </button>
          </li>


        </ul>

        {activeTab === "users" && <UsersPage />}
        {activeTab === "categories" && <CategoriesPage />}
        {activeTab === "products" && <ProductsPage />}
        {activeTab === "orders" && <OrdersPage />}
      </div>
    </>
  );
};

export default App;
