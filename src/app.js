const express = require("express");
const cors = require('cors');
const authRoutes = require("./routes/auth.routes");
const userRoutes = require("./routes/user.routes");
const productRoutes = require("./routes/product.routes");
const CategoryRoutes = require("./routes/category.routes");
const BrandRoutes = require("./routes/brand.routes");
const product_imagesRoutes = require("./routes/product_images.routes");
const CartRoutes = require("./routes/cart.routes");
const path = require("path");



const app = express();

// Cấu hình CORS
const allowedOrigins = ['http://localhost:3000', 'http://localhost:3002'];
app.use(cors({
  origin: function(origin, callback) {
    // Cho phép tất cả các origin trong môi trường phát triển
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true
}));

app.use(express.json());
app.use("/uploads", express.static(path.join(__dirname, "uploads")));

// routes
app.use("/api/auth", authRoutes);
app.use("/api/users", userRoutes);      // thêm route user
app.use("/api/categories", CategoryRoutes);
app.use("/api/products", productRoutes);
app.use("/api/brands", BrandRoutes);
app.use("/api/product_images", product_imagesRoutes);
app.use("/api/cart", CartRoutes);


module.exports = app;

