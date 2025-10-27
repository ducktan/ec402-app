import React from "react";

const OrderModal = ({ order }) => {
  if (!order) return null;

  return (
    <div className="modal fade" id="orderModal" tabIndex="-1">
      <div className="modal-dialog modal-lg">
        <div className="modal-content">
          <div className="modal-header">
            <h5 className="modal-title">Chi tiết đơn hàng #{order.id}</h5>
            <button type="button" className="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div className="modal-body">
            <h6>📦 Thông tin đơn hàng</h6>
            <ul>
              <li><strong>Người mua:</strong> {order.user_name}</li>
              <li><strong>Người bán:</strong> {order.seller_name}</li>
              <li><strong>Ngày tạo:</strong> {order.created_at}</li>
              <li><strong>Thanh toán:</strong> {order.payment_method.toUpperCase()} ({order.payment_status})</li>
              <li><strong>Trạng thái:</strong> {order.order_status}</li>
            </ul>

            <h6 className="mt-3">📍 Địa chỉ giao hàng</h6>
            <p>
              {order.shipping_address.name} - {order.shipping_address.phone} <br />
              {order.shipping_address.address}
            </p>

            <h6 className="mt-3">🛒 Sản phẩm</h6>
            <table className="table table-sm table-bordered">
              <thead>
                <tr>
                  <th>#</th>
                  <th>Tên sản phẩm</th>
                  <th>Giá</th>
                  <th>Số lượng</th>
                  <th>Thành tiền</th>
                </tr>
              </thead>
              <tbody>
                {order.items.map((item, i) => (
                  <tr key={item.id}>
                    <td>{i + 1}</td>
                    <td>{item.name}</td>
                    <td>{item.price.toLocaleString()} ₫</td>
                    <td>{item.quantity}</td>
                    <td>{(item.price * item.quantity).toLocaleString()} ₫</td>
                  </tr>
                ))}
              </tbody>
            </table>

            <div className="text-end fw-bold">
              Tổng cộng: {order.total_amount.toLocaleString()} ₫
            </div>
          </div>
          <div className="modal-footer">
            <button className="btn btn-secondary" data-bs-dismiss="modal">
              Đóng
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default OrderModal;
