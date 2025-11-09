const multer = require("multer");
const path = require("path");
const fs = require("fs");

// Thư mục lưu ảnh
const uploadDir = path.join(__dirname, "../uploads/avatars");
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
}

// Cấu hình nơi lưu và tên file
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    const fileName = `${Date.now()}-${Math.round(Math.random() * 1E9)}${ext}`;
    cb(null, fileName);
  },
});

// Chỉ cho phép upload ảnh
const fileFilter = (req, file, cb) => {
  console.log("==> Debug fileFilter:", file);
  if (file.mimetype.startsWith("image/")) cb(null, true);
  else cb(new Error("Chỉ được phép upload file ảnh"), false);
};


const upload = multer({ storage, fileFilter });

module.exports = upload;
