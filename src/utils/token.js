const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

const SECRET = "EC402_APP_KEY"; // nên để vào biến môi trường .env

// hash password
async function hashPassword(password) {
  const salt = await bcrypt.genSalt(10);
  return bcrypt.hash(password, salt);
}

// so sánh password
async function comparePassword(password, hash) {
  return bcrypt.compare(password, hash);
}

// tạo token
function generateToken(payload) {
  return jwt.sign(payload, SECRET, { expiresIn: "7d" });
}
 
function generateOTP(){
  return Math.floor(100000 + Math.random() * 900000).toString(); // 6 chữ số
}

function sendOTP(phone, otp){
  console.log(`📲 Gửi OTP ${otp} đến số: ${phone}`);
  return true;
}

module.exports = { hashPassword, comparePassword, generateToken, generateOTP, sendOTP };
