const express = require("express");
const authRoutes = require("./routes/auth.routes");
const userRoutes = require("./routes/user.routes");
const productRoutes = require("./routes/product.routes");
const CategoryRoutes = require("./routes/category.routes");
const BrandRoutes = require("./routes/brand.routes");
const product_imagesRoutes = require("./routes/product_images.routes");
const CartRoutes = require("./routes/cart.routes");
const path = require("path");
const shopRoutes = require('./routes/shop.routes');
const reviewRoutes = require('./routes/review.routes');


const app = express();

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
app.use('/api/shop', shopRoutes);
app.use('/api/reviews', reviewRoutes);

module.exports = app;

