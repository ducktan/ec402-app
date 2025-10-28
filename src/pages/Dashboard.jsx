import React, { useEffect, useState } from "react";
import Navbar from "../components/Navbar";

const Dashboard = () => {
  const [stats, setStats] = useState({
    users: 0,
    products: 0,
    orders: 0,
    revenue: 0,
  });

  const [recentOrders, setRecentOrders] = useState([]);

  useEffect(() => {
    // 🚀 Giả lập fetch dữ liệu từ API
    setStats({
      users: 128,
      products: 452,
      orders: 87,
      revenue: 21500000,
    });

    setRecentOrders([
      {
        id: 1,
        buyer: "Nguyễn Văn A",
        seller: "Shop Minh Anh",
        total: 1200000,
        status: "delivered",
      },
      {
        id: 2,
        buyer: "Trần Thị B",
        seller: "Shop Thanh Tâm",
        total: 480000,
        status: "pending",
      },
      {
        id: 3,
        buyer: "Phạm Văn C",
        seller: "Shop Lan Anh",
        total: 310000,
        status: "confirmed",
      },
    ]);
  }, []);

  const formatCurrency = (v) =>
    v.toLocaleString("vi-VN", { style: "currency", currency: "VND" });

  return (
    <div>
      <Navbar />
      <div className="container py-4">
        <h3 className="mb-4">Bảng điều khiển</h3>

        {/* ==== THỐNG KÊ ==== */}
        <div className="row g-4 mb-4">
          <div className="col-md-3">
            <div className="card text-bg-primary shadow-sm">
              <div className="card-body">
                <h5 className="card-title">
                  <i className="fa fa-users me-2"></i>Người dùng
                </h5>
                <h2>{stats.users}</h2>
              </div>
            </div>
          </div>

          <div className="col-md-3">
            <div className="card text-bg-success shadow-sm">
              <div className="card-body">
                <h5 className="card-title">
                  <i className="fa fa-box me-2"></i>Sản phẩm
                </h5>
                <h2>{stats.products}</h2>
              </div>
            </div>
          </div>

          <div className="col-md-3">
            <div className="card text-bg-warning shadow-sm">
              <div className="card-body">
                <h5 className="card-title">
                  <i className="fa fa-shopping-cart me-2"></i>Đơn hàng
                </h5>
                <h2>{stats.orders}</h2>
              </div>
            </div>
          </div>

          <div className="col-md-3">
            <div className="card text-bg-danger shadow-sm">
              <div className="card-body">
                <h5 className="card-title">
                  <i className="fa fa-coins me-2"></i>Doanh thu
                </h5>
                <h2>{formatCurrency(stats.revenue)}</h2>
              </div>
            </div>
          </div>
        </div>

        {/* ==== BẢNG ĐƠN HÀNG GẦN ĐÂY ==== */}
        <div className="card shadow-sm">
          <div className="card-header d-flex justify-content-between align-items-center">
            <h5 className="mb-0">Đơn hàng gần đây</h5>
            <a href="/orders" className="btn btn-sm btn-outline-primary">
              Xem tất cả
            </a>
          </div>
          <div className="card-body table-responsive">
            <table className="table align-middle">
              <thead>
                <tr>
                  <th>Mã đơn</th>
                  <th>Người mua</th>
                  <th>Người bán</th>
                  <th>Tổng tiền</th>
                  <th>Trạng thái</th>
                </tr>
              </thead>
              <tbody>
                {recentOrders.map((o) => (
                  <tr key={o.id}>
                    <td>#{o.id}</td>
                    <td>{o.buyer}</td>
                    <td>{o.seller}</td>
                    <td>{formatCurrency(o.total)}</td>
                    <td>
                      <span
                        className={`badge text-bg-${
                          o.status === "delivered"
                            ? "success"
                            : o.status === "pending"
                            ? "secondary"
                            : "warning"
                        }`}
                      >
                        {o.status}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
