// src/middlewares/authorizeRole.js

/**
 * Middleware kiểm tra quyền của user
 * @param {Array} allowedRoles - Danh sách các role được phép (ví dụ: ["admin"])
 */
function authorizeRole(allowedRoles = []) {
  return (req, res, next) => {
    

    if (!req.user) {
      return res.status(401).json({ message: "Bạn chưa đăng nhập." });
    }

    if (!allowedRoles.includes(req.user.role)) {
      return res.status(403).json({ message: "Bạn không có quyền thực hiện hành động này." });
    }

    next();
  };
}


module.exports = authorizeRole;
