import React from "react";

const statusColor = {
  pending: "secondary",
  confirmed: "info",
  shipping: "warning",
  delivered: "success",
  cancelled: "danger",
};

const OrderTable = ({ orders, onView, onUpdateStatus }) => {
  return (
    <table className="table table-bordered align-middle">
      <thead className="table-light">
        <tr>
          <th>#</th>
          <th>Người mua</th>
          <th>Người bán</th>
          <th>Tổng tiền</th>
          <th>Thanh toán</th>
          <th>Trạng thái</th>
          <th>Ngày tạo</th>
          <th>Thao tác</th>
        </tr>
      </thead>
      <tbody>
        {orders.length > 0 ? (
          orders.map((o, i) => (
            <tr key={o.id}>
              <td>{i + 1}</td>
              <td>{o.user_name}</td>
              <td>{o.seller_name}</td>
              <td>{o.total_amount.toLocaleString()} ₫</td>
              <td>
                <span
                  className={`badge bg-${
                    o.payment_status === "paid" ? "success" : "secondary"
                  }`}
                >
                  {o.payment_method.toUpperCase()}
                </span>
              </td>
              <td>
                <span
                  className={`badge bg-${statusColor[o.order_status] || "dark"}`}
                >
                  {o.order_status}
                </span>
              </td>
              <td>{o.created_at}</td>
              <td>
                <button
                  className="btn btn-sm btn-primary me-2"
                  data-bs-toggle="modal"
                  data-bs-target="#orderModal"
                  onClick={() => onView(o)}
                >
                  <i className="fa fa-eye"></i>
                </button>

                <div className="btn-group">
                  <button
                    className="btn btn-sm btn-outline-secondary dropdown-toggle"
                    data-bs-toggle="dropdown"
                  >
                    Cập nhật
                  </button>
                  <ul className="dropdown-menu">
                    {["pending", "confirmed", "shipping", "delivered", "cancelled"].map(
                      (st) => (
                        <li key={st}>
                          <button
                            className="dropdown-item"
                            onClick={() => onUpdateStatus(o.id, st)}
                          >
                            {st}
                          </button>
                        </li>
                      )
                    )}
                  </ul>
                </div>
              </td>
            </tr>
          ))
        ) : (
          <tr>
            <td colSpan="8" className="text-center">
              Không có đơn hàng
            </td>
          </tr>
        )}
      </tbody>
    </table>
  );
};

export default OrderTable;
