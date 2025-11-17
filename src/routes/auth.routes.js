const express = require("express");
const router = express.Router();
const authController = require("../controllers/auth.controller");
const { verifyToken } = require("../middlewares/auth.middleware");

router.post("/register", authController.register);
router.post("/login", authController.login);
router.post("/login-otp", authController.loginWithOtp);
router.post("/verify-otp", authController.verifyOtp);
router.post("/logout", verifyToken, authController.logout);

module.exports = router;