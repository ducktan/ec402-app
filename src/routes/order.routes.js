const express = require("express");
const router = express.Router();

const orderController = require("../controllers/order.controller");
const transactionController = require("../controllers/transaction.controller");
const { authMiddleware } = require("../middlewares/auth.middleware");
const authorizeRole = require("../middlewares/authorizeRole");

const paymentController = require("../controllers/payment.controller");

// =========================
// USER ROUTES
// =========================

// CREATE ORDER — POST /api/v1/orders
router.post(
  "/",
  authMiddleware,
  orderController.createOrder
);

// GET MY ORDERS — GET /api/v1/orders/me
router.get(
  "/me",
  authMiddleware,
  orderController.getMyOrders
);

// GET ORDER DETAIL — GET /api/v1/orders/:id
router.get(
  "/:id",
  authMiddleware,
  orderController.getOrderDetail
);

// CANCEL ORDER — PUT /api/v1/orders/:id/cancel
router.put(
  "/:id/cancel",
  authMiddleware,
  orderController.cancelOrder
);


// =========================
// ADMIN ROUTES
// =========================

// ADMIN — GET ALL ORDERS — GET /api/v1/orders/admin/all
router.get(
  "/admin/all",
  authMiddleware,
  authorizeRole(["admin"]),
  orderController.adminGetAllOrders
);

// ADMIN — UPDATE ORDER STATUS — PUT /api/v1/orders/admin/:id/status
router.put(
  "/admin/:id/status",
  authMiddleware,
  authorizeRole(["admin"]),
  orderController.adminUpdateOrderStatus
);

router.post("/create-payment-intent", paymentController.createPaymentIntent);

// CREATE TRANSACTION — POST /api/orders/create-transaction
router.post(
  "/create-transaction",
  authMiddleware,
  transactionController.createTransaction
);

// =========================
// ADMIN ROUTES
// =========================

// ADMIN GET ALL TRANSACTIONS — GET /api/orders/admin/transactions
router.get(
  "/admin/transactions",
  authMiddleware,
  authorizeRole(["admin"]),
  transactionController.adminGetAllTransactions
);

module.exports = router;
