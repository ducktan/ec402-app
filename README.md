# 📱 T-Smart – Ứng dụng mua bán vật phẩm Second-hand

## 1. Giới thiệu đề tài

**Tên đề tài:**  
**Xây dựng ứng dụng T-Smart để mua bán các vật phẩm Second-hand**

Trong bối cảnh nhu cầu mua bán, trao đổi các vật phẩm đã qua sử dụng ngày càng tăng, đặc biệt trong cộng đồng sinh viên và giới trẻ, việc xây dựng một nền tảng thương mại điện tử chuyên biệt cho hàng second-hand là cần thiết.  

**T-Smart** được phát triển nhằm cung cấp một ứng dụng di động thân thiện, tiện lợi, giúp người dùng dễ dàng:
- Tìm kiếm và mua các sản phẩm second-hand chất lượng
- Quản lý giỏ hàng, đơn hàng
- Thanh toán trực tuyến an toàn
- Nhận thông báo và ưu đãi từ hệ thống

---

## 2. Mục tiêu của đề tài

- Xây dựng một **ứng dụng thương mại điện tử di động** hoàn chỉnh
- Hỗ trợ mua bán các vật phẩm second-hand theo danh mục và thương hiệu
- Áp dụng các công nghệ hiện đại trong phát triển Mobile App và Backend
- Thiết kế hệ thống có khả năng mở rộng, dễ bảo trì
- Tích hợp các tính năng nâng cao như:
  - Voucher khuyến mãi
  - Thông báo (Notification)
  - Thanh toán online
  - Minigame (Vòng quay may mắn)

---

## 3. Đối tượng sử dụng

- Sinh viên, người dùng cá nhân có nhu cầu mua bán đồ second-hand
- Người bán nhỏ lẻ
- Quản trị viên hệ thống (Admin)

---

## 4. Công nghệ sử dụng

### 🔹 Frontend (Mobile App)
- **Flutter**
- **Dart**
- GetX (State Management & Navigation)
- HTTP package (giao tiếp API)
- Flutter Stripe (Thanh toán)
- Firebase Cloud Messaging (Push Notification)

### 🔹 Backend
- **Node.js**
- **Express.js**
- JWT (Authentication & Authorization)
- RESTful API
- Webhook (Thanh toán)

### 🔹 Database
- **MySQL**
- Thiết kế theo mô hình quan hệ (Relational Database)
- Chuẩn hóa dữ liệu (3NF)

### 🔹 Other Services
- **Stripe**: Thanh toán trực tuyến
- **Firebase**: Push Notification
- **Gemini AI**: Chat AI hỗ trợ người dùng

---

## 5. Các chức năng chính

### 👤 Người dùng
- Đăng ký, đăng nhập
- Quản lý hồ sơ cá nhân
- Xem danh mục và sản phẩm
- Thêm sản phẩm vào giỏ hàng
- Thanh toán và theo dõi đơn hàng
- Đánh giá sản phẩm
- Lưu sản phẩm yêu thích (Wishlist)
- Nhận thông báo hệ thống

### 🛍️ Hệ thống bán hàng
- Quản lý danh mục sản phẩm
- Quản lý thương hiệu
- Quản lý voucher khuyến mãi
- Minigame vòng quay may mắn nhận voucher

### 🔔 Thông báo
- Thông báo trạng thái đơn hàng
- Thông báo khuyến mãi
- Thông báo hệ thống qua Firebase

---

## 6. Kiến trúc hệ thống

- Mô hình **Client – Server**
- Mobile App giao tiếp với Backend thông qua REST API
- Backend xử lý logic nghiệp vụ và truy vấn database
- Các dịch vụ bên thứ ba được tích hợp thông qua API/Webhook

---

## 7. Kết luận

Dự án **T-Smart** không chỉ đáp ứng nhu cầu mua bán vật phẩm second-hand mà còn giúp sinh viên áp dụng kiến thức đã học về:
- Lập trình Mobile
- Thiết kế Backend
- Quản lý cơ sở dữ liệu
- Tích hợp thanh toán và dịch vụ bên thứ ba

Ứng dụng có tính thực tiễn cao và có thể tiếp tục mở rộng trong tương lai.

---

## 8. Hướng phát triển

- Hệ thống chat giữa người mua và người bán
- Gợi ý sản phẩm bằng AI
- Quản lý người bán nâng cao
- Dashboard Admin trên Web
