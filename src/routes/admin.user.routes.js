const express = require("express");
const router = express.Router();
const AdminUserController = require("../controllers/admin.user.controller");
const { authMiddleware } = require("../middlewares/auth.middleware");
const authorizeRole = require("../middlewares/authorizeRole");

router.use(authMiddleware);
router.use(authorizeRole(["admin"]));

router.get("/users", AdminUserController.getAllUsers);
router.post("/users", AdminUserController.createUser);
router.put("/users/:id", AdminUserController.updateUser);
router.delete("/users/:id", AdminUserController.deleteUser);

module.exports = router;
