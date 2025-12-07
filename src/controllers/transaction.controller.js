const TransactionModel = require("../models/transaction.model");

// ====================== CREATE TRANSACTION ======================
exports.createTransaction = async (req, res) => {
  try {
    const user_id = req.user.id;
    const { order_id, provider, amount, status } = req.body;

    if (!order_id || !provider || amount == null || !status) {
      return res.status(400).json({ message: "Thiếu thông tin bắt buộc." });
    }

    const transaction = await TransactionModel.create({
      order_id,
      user_id,
      provider,
      amount,
      status,
      transaction_code: "",
    });

    res.status(201).json({
      message: "Tạo transaction thành công.",
      data: transaction,
    });
  } catch (error) {
    console.error("Lỗi createTransaction:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

// ====================== ADMIN GET ALL TRANSACTIONS ======================
exports.adminGetAllTransactions = async (req, res) => {
  try {
    const transactions = await TransactionModel.adminGetAll();
    res.json({ data: transactions });
  } catch (error) {
    console.error("Lỗi adminGetAllTransactions:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};
