import React, { useState, useEffect } from "react";
import OrderTable from "../components/OrderTable";
import OrderModal from "../components/OrderModal";

const OrdersPage = () => {
  const [orders, setOrders] = useState([]);
  const [filterStatus, setFilterStatus] = useState("all");
  const [selectedOrder, setSelectedOrder] = useState(null);

  useEffect(() => {
    // Giả lập dữ liệu demo
    setOrders([
      {
        id: 1,
        user_name: "Nguyễn Văn A",
        seller_name: "Shop Điện Thoại ABC",
        total_amount: 45990000,
        payment_method: "momo",
        payment_status: "paid",
        order_status: "delivered",
        created_at: "2025-10-20",
        shipping_address: {
          name: "Nguyễn Văn A",
          phone: "0909123456",
          address: "12 Lý Thường Kiệt, Quận 10, TP.HCM",
        },
        items: [
          { id: 1, name: "iPhone 15 Pro", price: 34990000, quantity: 1 },
          { id: 2, name: "Ốp lưng", price: 500000, quantity: 1 },
        ],
      },
      {
        id: 2,
        user_name: "Trần Thị B",
        seller_name: "Laptop Store XYZ",
        total_amount: 17990000,
        payment_method: "vnpay",
        payment_status: "pending",
        order_status: "confirmed",
        created_at: "2025-10-24",
        shipping_address: {
          name: "Trần Thị B",
          phone: "0909555666",
          address: "25 Cách Mạng Tháng 8, TP.HCM",
        },
        items: [
          { id: 3, name: "Laptop Asus Vivobook", price: 17990000, quantity: 1 },
        ],
      },
    ]);
  }, []);

  const handleUpdateStatus = (id, newStatus) =>
    setOrders(
      orders.map((o) =>
        o.id === id ? { ...o, order_status: newStatus } : o
      )
    );

  const filteredOrders =
    filterStatus === "all"
      ? orders
      : orders.filter((o) => o.order_status === filterStatus);

  return (
    <div>
      <div className="container py-4">
        <div className="d-flex justify-content-between align-items-center mb-3">
          <h3>Quản lý đơn hàng</h3>
        </div>

        <div className="mb-3">
          <select
            className="form-select w-auto"
            value={filterStatus}
            onChange={(e) => setFilterStatus(e.target.value)}
          >
            <option value="all">Tất cả trạng thái</option>
            <option value="pending">Chờ xử lý</option>
            <option value="confirmed">Đã xác nhận</option>
            <option value="shipping">Đang giao</option>
            <option value="delivered">Đã giao</option>
            <option value="cancelled">Đã hủy</option>
          </select>
        </div>

        <OrderTable
          orders={filteredOrders}
          onView={setSelectedOrder}
          onUpdateStatus={handleUpdateStatus}
        />
      </div>

      <OrderModal order={selectedOrder} />
    </div>
  );
};

export default OrdersPage;
