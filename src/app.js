const express = require("express");
const authRoutes = require("./routes/auth.routes");
const userRoutes = require("./routes/user.routes");
const productRoutes = require("./routes/product.routes");
const CategoryRoutes = require("./routes/category.routes");
const Product = require("./routes/product.routes");



const app = express();

app.use(express.json());

// routes
app.use("/api/auth", authRoutes);
app.use("/api/users", userRoutes);      // thêm route user
app.use("/api/categories", CategoryRoutes);
app.use("/api/products", Product);


module.exports = app;

