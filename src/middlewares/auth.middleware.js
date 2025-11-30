const jwt = require("jsonwebtoken");
const SECRET = "EC402_APP_KEY"; // nên để .env
const db = require("../config/db");

// Middleware kiểm tra quyền admin
exports.isAdmin = (req, res, next) => {
  if (req.user && req.user.role === 'admin') {
    return next();
  }
  return res.status(403).json({ message: 'Truy cập bị từ chối. Yêu cầu quyền admin.' });
};

exports.authMiddleware = (req, res, next) => {
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1];

  if (!token) return res.status(401).json({ message: "No token provided" });

  try {
    const decoded = jwt.verify(token, SECRET);
    req.user = decoded;
    next();
  } catch (err) {
    return res.status(403).json({ message: "Invalid token" });
  }
};

exports.verifyToken = async (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ message: "Unauthorized" });
  }

  const token = authHeader.split(" ")[1];

  try {
    // Kiểm tra token có trong blacklist không
    const [blacklisted] = await db.query("SELECT * FROM token_blacklist WHERE token = ?", [token]);
    if (blacklisted.length > 0) {
      return res.status(403).json({ message: "Token has been revoked. Please login again." });
    }

    // Xác thực token
    const decoded = jwt.verify(token, process.env.JWT_SECRET || "EC402_APP_KEY");
    req.user = decoded;
    next();
  } catch (err) {
    console.error(err);
    return res.status(403).json({ message: "Invalid token" });
  }
};