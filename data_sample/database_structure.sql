-- 1. Tạo Database
CREATE DATABASE IF NOT EXISTS ec402;
USE ec402;

-- 2. Bảng Users
-- (Đã sửa lỗi: Bỏ 'AFTER', sắp xếp lại thứ tự dòng để gender/dob nằm sau phone)
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    role ENUM('buyer','seller','admin') NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    gender ENUM('male', 'female', 'other') DEFAULT 'other',
    dob DATE,
    avatar VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 3. Bảng User Addresses
CREATE TABLE user_addresses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    street VARCHAR(255),
    ward VARCHAR(100),
    district VARCHAR(100),
    city VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 4. Bảng Categories
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    parent_id INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE SET NULL
);

-- 5. Bảng Brands
CREATE TABLE brands (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    logo_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 6. Bảng Products
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    brand_id INT NOT NULL,
    category_id INT,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(12,2) NOT NULL,
    stock INT DEFAULT 0,
    rating_avg DECIMAL(3,2) DEFAULT 0,
    review_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (brand_id) REFERENCES brands(id),
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- 7. Bảng Product Images
CREATE TABLE product_images (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- 8. Bảng Reviews
CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating TINYINT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 9. Bảng Carts
CREATE TABLE carts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 10. Bảng Cart Items
CREATE TABLE cart_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    FOREIGN KEY (cart_id) REFERENCES carts(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 11. Bảng Orders
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    brand_id INT NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    payment_method ENUM('momo','vnpay','stripe','cod'),
    payment_status ENUM('pending','paid','failed') DEFAULT 'pending',
    order_status ENUM('pending','confirmed','shipping','delivered','cancelled') DEFAULT 'pending',
    shipping_address JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (brand_id) REFERENCES brands(id)
);

-- 12. Bảng Order Items
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    name VARCHAR(200),
    price DECIMAL(12,2),
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 13. Bảng Transactions
CREATE TABLE transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    user_id INT NOT NULL,
    provider ENUM('momo','vnpay','stripe'),
    amount DECIMAL(12,2) NOT NULL,
    status ENUM('pending','success','failed'),
    transaction_code VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 14. Bảng OTPs
CREATE TABLE otps (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  otp_code VARCHAR(6) NOT NULL,
  expires_at DATETIME NOT NULL,
  is_used BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 15. Bảng Token Blacklist
CREATE TABLE token_blacklist (
  id INT AUTO_INCREMENT PRIMARY KEY,
  token TEXT NOT NULL,
  user_id INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 16. Bảng Wishlist
CREATE TABLE wishlist (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_wishlist_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_wishlist_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY unique_wishlist (user_id, product_id)
);

-- 17. Bảng Vouchers 
CREATE TABLE vouchers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL COMMENT 'Mã giảm giá, VD: SALE50',
    discount_type ENUM('percentage', 'fixed') NOT NULL COMMENT 'Loại giảm: theo % hoặc số tiền cố định',
    discount_value DECIMAL(12,2) NOT NULL COMMENT 'Giá trị giảm',
    min_order_value DECIMAL(12,2) DEFAULT 0 COMMENT 'Đơn tối thiểu để dùng được',
    max_discount_amount DECIMAL(12,2) NULL COMMENT 'Giảm tối đa bao nhiêu (nếu là %)',
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    usage_limit INT DEFAULT 0 COMMENT 'Giới hạn số lần dùng chung, 0 là không giới hạn',
    used_count INT DEFAULT 0 COMMENT 'Số lần đã dùng',
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

USE ec402;

-- =============================================
-- 1. TẠO DỮ LIỆU THƯƠNG HIỆU (BRANDS)
-- =============================================
INSERT INTO brands (id, name, description, logo_url) VALUES 
(1, 'Apple', 'Tập đoàn công nghệ hàng đầu thế giới', 'https://upload.wikimedia.org/wikipedia/commons/f/fa/Apple_logo_black.svg'),
(2, 'Samsung', 'Gã khổng lồ công nghệ Hàn Quốc', 'https://upload.wikimedia.org/wikipedia/commons/2/24/Samsung_Logo.svg'),
(3, 'Nike', 'Just Do It - Thương hiệu thể thao số 1', 'https://upload.wikimedia.org/wikipedia/commons/a/a6/Logo_NIKE.svg'),
(4, 'Adidas', 'Impossible is Nothing', 'https://upload.wikimedia.org/wikipedia/commons/2/20/Adidas_Logo.svg'),
(5, 'ZARA', 'Thương hiệu thời trang nhanh nổi tiếng', 'https://upload.wikimedia.org/wikipedia/commons/f/fd/Zara_Logo.svg');

-- =============================================
-- 2. TẠO DỮ LIỆU DANH MỤC (CATEGORIES)
-- =============================================
INSERT INTO categories (id, name, parent_id) VALUES 
(1, 'Electronics', NULL),       -- Danh mục cha
(2, 'Fashion', NULL),           -- Danh mục cha
(3, 'Smartphones', 1),          -- Con của Electronics
(4, 'Laptops', 1),              -- Con của Electronics
(5, 'Shoes', 2),                -- Con của Fashion
(6, 'Clothing', 2);             -- Con của Fashion

-- =============================================
-- 3. TẠO DỮ LIỆU SẢN PHẨM (PRODUCTS)
-- =============================================
INSERT INTO products (brand_id, category_id, name, description, price, stock, rating_avg, review_count) VALUES 
-- Apple Products
(1, 3, 'iPhone 15 Pro Max', 'Titanium design, A17 Pro chip, camera siêu đỉnh.', 34990000, 50, 4.8, 120),
(1, 4, 'MacBook Air M2', 'Laptop mỏng nhẹ, pin trâu, hiệu năng mạnh mẽ cho văn phòng.', 26990000, 30, 4.9, 85),
(1, 1, 'AirPods Pro 2', 'Tai nghe chống ồn chủ động thế hệ mới.', 5990000, 100, 4.7, 200),

-- Samsung Products
(2, 3, 'Samsung Galaxy S24 Ultra', 'Quyền năng AI, Camera mắt thần bóng đêm.', 30990000, 45, 4.6, 90),
(2, 1, 'Samsung Galaxy Watch 6', 'Đồng hồ thông minh theo dõi sức khỏe toàn diện.', 4500000, 60, 4.5, 50),

-- Nike Products
(3, 5, 'Nike Air Jordan 1', 'Giày bóng rổ huyền thoại, phong cách đường phố.', 4500000, 20, 5.0, 300),
(3, 6, 'Nike Sportswear T-Shirt', 'Áo thun thể thao thoáng mát, co giãn tốt.', 850000, 150, 4.2, 40),

-- Adidas Products
(4, 5, 'Adidas Ultraboost Light', 'Giày chạy bộ êm ái nhất, công nghệ Boost tiên tiến.', 3800000, 25, 4.7, 110),
(4, 6, 'Adidas Jacket 3-Stripes', 'Áo khoác gió thể thao 3 sọc đặc trưng.', 1200000, 40, 4.4, 60),

-- ZARA Products
(5, 6, 'ZARA Slim Fit Shirt', 'Áo sơ mi nam form ôm, lịch lãm công sở.', 999000, 80, 4.1, 20);

-- =============================================
-- 4. TẠO DỮ LIỆU ẢNH SẢN PHẨM (PRODUCT IMAGES)
-- =============================================
-- (Giả lập ảnh để App không bị lỗi hiển thị)
INSERT INTO product_images (product_id, image_url) VALUES
(1, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:358:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/i/p/iphone-15-pro-max_3.png'),
(2, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:358:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/m/a/macbook-air-m2-2022_1.png'),
(4, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:358:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/s/s/samsung-galaxy-s24-ultra-grey_2.png'),
(6, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/99486392-5060-4b13-a447-094921f0845a/air-jordan-1-mid-shoes-X5pM09.png');