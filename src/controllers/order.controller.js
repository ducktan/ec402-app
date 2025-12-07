const OrderModel = require("../models/order.model");
const CartModel = require("../models/cart.model");

// ====================== CREATE ORDER ======================
exports.createOrder = async (req, res) => {
  try {
    const user_id = req.user.id;
    let { payment_method, shipping_address, total_amount } = req.body;

    if (!payment_method || !shipping_address || total_amount == null) {
      return res.status(400).json({
        message: "Thiếu thông tin bắt buộc."
      });
    }

    // Lấy giỏ hàng
    const cart = await CartModel.getCartWithItems(user_id);
    const cartItems = cart.items;

    if (!cartItems || cartItems.length === 0) {
      return res.status(400).json({ message: "Giỏ hàng trống." });
    }

    // Tạo order
    const order = await OrderModel.create({
      user_id,
      total_amount,
      payment_method,
      shipping_address
    });

    // Tạo order_items
    for (const item of cartItems) {
      const formatted = {
        product_id: item.product.id,
        name: item.product.title,
        price: item.product.price,
        quantity: item.quantity
      };

      await OrderModel.createItem(order.id, formatted);
    }

    // Xóa giỏ hàng
    await CartModel.clearCart(user_id);

    res.status(201).json({
      message: "Tạo đơn hàng thành công.",
      data: { order_id: order.id }
    });
  } catch (error) {
    console.error("Lỗi createOrder:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

// ====================== GET MY ORDERS ======================
exports.getMyOrders = async (req, res) => {
  try {
    const user_id = req.user.id;
    const orders = await OrderModel.getMyOrders(user_id);

    res.json({ data: orders });
  } catch (error) {
    console.error("Lỗi getMyOrders:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

// ====================== GET ORDER DETAIL ======================
exports.getOrderDetail = async (req, res) => {
  try {
    const order_id = req.params.id;

    const order = await OrderModel.getById(order_id);
    if (!order) {
      return res.status(404).json({ message: "Không tìm thấy đơn hàng." });
    }

    const items = await OrderModel.getItems(order_id);

    res.json({
      data: {
        ...order,
        items,
      },
    });
  } catch (error) {
    console.error("Lỗi getOrderDetail:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

// ====================== CANCEL ORDER ======================
exports.cancelOrder = async (req, res) => {
  try{
    const order_id = req.params.id;

    const order = await OrderModel.getById(order_id);
    if (!order) {
      return res.status(404).json({ message: "Không tìm thấy đơn hàng." });
    }

    if (order.order_status !== "pending") {
      return res
        .status(400)
        .json({ message: "Chỉ có thể hủy đơn hàng ở trạng thái pending." });
    }

    await OrderModel.cancel(order_id);

    res.json({ message: "Hủy đơn hàng thành công." });
  } catch (error) {
    console.error("Lỗi cancelOrder:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

// ====================== ADMIN GET ALL ORDERS ======================
exports.adminGetAllOrders = async (req, res) => {
  try {
    const orders = await OrderModel.adminGetAll();
    res.json({ data: orders });
  } catch (error) {
    console.error("Lỗi adminGetAllOrders:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

// ====================== ADMIN UPDATE STATUS ======================
exports.adminUpdateOrderStatus = async (req, res) => {
  try {
    const order_id = req.params.id;
    const { status } = req.body;

    if (!status) {
      return res.status(400).json({ message: "Thiếu trạng thái mới." });
    }

    const order = await OrderModel.getById(order_id);
    if (!order) {
      return res.status(404).json({ message: "Không tìm thấy đơn hàng." });
    }

    await OrderModel.adminUpdateStatus(order_id, status);

    res.json({
      message: "Cập nhật trạng thái đơn hàng thành công.",
      data: { order_id, status },
    });
  } catch (error) {
    console.error("Lỗi adminUpdateOrderStatus:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};
