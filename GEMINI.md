# Project Rules & Guidelines — Vietjet Travel Website

## 1. Tổng quan Dự án (Project Overview)
- **Tên dự án**: Vietjet (Hệ thống đặt vé máy bay & tour du lịch trực tuyến)
- **Lĩnh vực**: Du lịch & Hàng không (Travel & Airlines)
- **Mục tiêu**: Xây dựng website đặt vé máy bay và tour du lịch hiện đại, nhanh nhạy, hoạt động hoàn toàn phía Client-side (Frontend-only) nhưng có đầy đủ luồng nghiệp vụ từ tìm kiếm, lọc, xem chi tiết đến giỏ hàng và gửi email xác nhận.

## 2. Công nghệ sử dụng (Tech Stack Constraints)
- **Ngôn ngữ**: HTML5, CSS3, Vanilla JavaScript (ES6+). **Tuyệt đối không** sử dụng các JS framework (React, Vue, Angular) hay backend server (Node.js, PHP, Python...).
- **Cơ sở dữ liệu (Database)**: **SQLite** chạy trực tiếp trên trình duyệt thông qua thư viện **`sql.js`** (WebAssembly SQLite) kết hợp với `localStorage` để lưu trữ bền vững (persistence) giữa các trang, kèm theo file `schema.sql` chuẩn.
- **Dịch vụ Gửi Email (Client-side)**: Sử dụng **EmailJS** (hoặc SMTPJS / FormSubmit API phía client) để gửi email xác nhận đơn hàng từ `minhkhoithan@gmail.com` tới địa chỉ email của khách hàng mà không cần backend.

## 3. Hệ thống Thiết kế & Giao diện (Design System & UI/UX)
- **Phong cách chủ đạo**: Tông màu sáng (Light mode), hiện đại, năng động, chuẩn nhận diện thương hiệu hàng không Vietjet Air.
- **Bảng màu (Color Palette)**:
  - Nền chính (Background Primary): Trắng `#FFFFFF`
  - Nền phụ (Background Secondary / Section): Xám sáng `#F8F9FA`
  - Màu chủ đạo (Primary Brand Color): Đỏ Vietjet `#EE1D23`
  - Màu nhấn phụ (Secondary / Accent): Vàng tươi `#FFCC00` (dùng cho badge khuyến mãi, ngôi sao, điểm nhấn thương hiệu) & Đỏ đậm `#C81016` (khi hover button)
  - Màu chữ chính (Text Primary): Đen xám `#1A1A1A`
  - Màu chữ phụ (Text Muted): Xám `#666666`
  - Màu viền (Border Color): `#E5E7EB`
- **Typography**: Font chữ không chân hiện đại (`Inter`, `Roboto`, hoặc `Plus Jakarta Sans` từ Google Fonts).
- **Tài nguyên hình ảnh có sẵn (`images/`)**:
  - `images/2aOboRAvPCnNF8ux8l12JJoKC6uw9yMZkM5dUYs4.jpg`: Logo VietjetAir.com
  - `images/2aOboRAvPChFky1ocMfEck7L9rvvV1VWvb6HTuOe.jpg`: Hình tiếp viên Vietjet (Hero Banner)
  - `images/2aOboRAvPCl8aJFLRvC9C6cuHOJz016Hhl8xEeG0.jpg`: Hình máy bay Airbus Vietjet đang bay

## 4. Quy tắc Lập trình (Coding Standards)
1. **Chia tách trách nhiệm rõ ràng**:
   - Giao diện đặt tại các file `.html`.
   - Style dùng chung ở `css/style.css` (dùng CSS Variables `--primary-color: #ee1d23;`).
   - Xử lý Database SQLite tách riêng vào `js/db.js`.
   - Logic giỏ hàng và gửi mail tách riêng vào `js/cart.js` và `js/email.js`.
2. **Định dạng tiền tệ & Thời gian**:
   - Tiền tệ luôn format theo chuẩn Việt Nam Đồng (`1.250.000 ₫` hoặc `1,250,000 VNĐ` bằng `Intl.NumberFormat('vi-VN')`).
   - Giờ bay hiển thị định dạng 24h (`HH:mm`).
3. **Đồng bộ dữ liệu giữa các trang**:
   - Dùng URL Query Parameters (ví dụ: `flights.html?from=SGN&to=HAN&type=round-trip` hoặc `flight-detail.html?id=1`) để truyền trạng thái tìm kiếm và xem chi tiết.
   - Dùng bảng `cart_items` trong SQLite (được lưu binary snapshot vào `localStorage`) để giữ giỏ hàng xuyên suốt các trang.
4. **Trải nghiệm người dùng (UX)**:
   - Mọi thao tác thêm vào giỏ hàng, xóa giỏ hàng, hoặc đặt vé thành công đều phải có thông báo trực quan (Toast Notification hoặc Modal đẹp mắt).
   - Giao diện tương thích tốt trên cả Desktop và Mobile (Responsive Design).
