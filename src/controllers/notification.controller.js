const NotificationModel = require("../models/notification.model");

exports.getMyNotifications = async (req, res) => {
  try {
    const user_id = req.user.id;

    const list = await NotificationModel.getByUser(user_id);

    res.json({ data: list });
  } catch (error) {
    console.error("Error getMyNotifications:", error);
    res.status(500).json({ message: "Server error" });
  }
};

exports.markAsRead = async (req, res) => {
  try {
    const id = req.params.id;

    await NotificationModel.markAsRead(id);

    res.json({ message: "Marked as read" });
  } catch (error) {
    console.error("Error markAsRead:", error);
    res.status(500).json({ message: "Server error" });
  }
};
