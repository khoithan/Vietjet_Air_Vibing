# ✈️ Vietjet Travel — Hệ Thống Đặt Vé Máy Bay & Tour Du Lịch Trực Tuyến

![Vietjet Banner](images/2aOboRAvPChFky1ocMfEck7L9rvvV1VWvb6HTuOe.jpg)

> **Vietjet Travel** là website đặt vé máy bay và tour du lịch trực tuyến hiện đại, được xây dựng hoàn toàn bằng **HTML5, CSS3, Vanilla JavaScript (ES6+)** kết hợp với cơ sở dữ liệu **SQLite (`db.db`)** chạy trực tiếp trên trình duyệt thông qua **WebAssembly (`sql.js`)** mà không cần Backend server.

---

## 🌟 Tính Năng Nổi Bật

### 1. 🏠 Trang Chủ (`index.html`)
- **Khung Tìm Kiếm Chuyến Bay Thông Minh**:
  - Hỗ trợ chọn **Vé khứ hồi** hoặc **Vé một chiều**.
  - Chọn điểm xuất phát, điểm đến, ngày đi, ngày về.
  - Nhấn **Tìm Kiếm** tự động điều hướng và lọc kết quả tại trang Chuyến Bay (`flights.html`).
- **8 Tour Du Lịch Nổi Bật**:
  - Hiển thị 8 gói tour trong nước & quốc tế hấp dẫn nhất.
  - Hình ảnh thumbnail chuẩn tỷ lệ **`600x400`**, hiển thị hãng du lịch, thời lượng (số ngày/đêm), hãng hàng không đồng hành và giá tour.
  - Click vào tour dẫn đến trang Tour (`tours.html`).
- **Đối Tác Hãng Hàng Không**:
  - Hiển thị logo các hãng bay lớn: **VietJet Air, Vietnam Airlines, Singapore Airlines, Bamboo Airways, Thai Airways, Korean Air**.
  - Click vào logo hãng bay bất kỳ sẽ dẫn đến trang Chuyến Bay (`flights.html`) và lọc theo hãng đó.

### 2. 🛫 Trang Chuyến Bay (`flights.html`)
- **Bộ lọc đa tiêu chí (Sidebar bên trái)**:
  - Sắp xếp giá vé tăng dần / giảm dần.
  - Lọc theo loại hành trình: **Vé khứ hồi, Vé một chiều, Bay thẳng, Nhiều thành phố**.
  - Lọc theo các hãng hàng không.
  - Lọc theo khung giờ cất cánh: Sáng sớm (`00:00 - 06:00`), Buổi sáng (`06:00 - 12:00`), Buổi chiều (`12:00 - 18:00`), Buổi tối (`18:00 - 24:00`).
  - Lọc theo hạng dịch vụ: **Hạng Phổ Thông (Economy)** và **Hạng Thương Gia (Business / SkyBoss)**.
- **Danh sách chuyến bay (Bên phải)**:
  - Hiển thị đầy đủ hãng bay, mã chuyến bay, dòng máy bay, giờ cất/hạ cánh, tổng thời gian bay, ngày khởi hành, dịch vụ đi kèm và giá vé.

### 3. 🛩️ Chi Tiết Chuyến Bay (`flight-detail.html`)
- Hiển thị chi tiết hành trình: Điểm đi, điểm đến, thời gian bay, hãng bay, **loại máy bay (`Airbus A321neo`, `Airbus A330-300`, `Boeing 787-9 Dreamliner`...)**.
- Giao diện chọn hạng vé trực quan:
  - **Hạng Phổ Thông (Economy / Eco)**
  - **Hạng Thương Gia (Business / SkyBoss)**
- Lưu chuyến bay kèm hạng vé và số lượng hành khách vào **Giỏ Hàng** trong SQLite.

### 4. 🌴 Trang Tour Du Lịch (`tours.html`) & Chi Tiết Tour (`tour-detail.html`)
- **Trang danh sách Tour (`tours.html`)**:
  - Bộ lọc bên trái: Giá tăng/giảm dần, các hãng hàng không, khung giờ cất cánh.
  - Danh sách bên phải: Hình ảnh `600x400`, hãng lữ hành, hãng bay, ngày/giờ cất cánh, thời gian bay, loại máy bay, dịch vụ trọn gói và giá tiền.
- **Trang Chi Tiết Tour (`tour-detail.html`)**:
  - Thông tin điểm đi, điểm đến, thời gian bay, hãng bay, loại máy bay (`Boeing`, `Airbus`...).
  - **Lịch trình chuyến đi (Itinerary Timeline)** chi tiết từng ngày.
  - Nút chọn tour lưu trực tiếp vào **Giỏ Hàng**.

### 5. 🛒 Giỏ Hàng & Đăng Ký Nhận Email (`cart.html`)
- Xem danh sách các chuyến bay và tour đã chọn từ bảng `cart_items` trong SQLite.
- Thay đổi số lượng hành khách, xóa từng mục hoặc **Xóa toàn bộ giỏ hàng**.
- Form nhập thông tin cá nhân (Họ tên, Email, Số điện thoại, Ghi chú).
- Khi nhấn **Đăng Ký**:
  - Lưu đơn hàng vào bảng `bookings` trong SQLite.
  - Hiển thị thông báo hoàn thành và gửi **Email xác nhận** từ **`minhkhoithan@gmail.com`** đến địa chỉ email của khách hàng.

---

## 🛠️ Công Nghệ Sử Dụng

| Thành phần | Công nghệ |
| :--- | :--- |
| **Giao diện (Frontend)** | HTML5, CSS3 (Custom Variables, Responsive Grid/Flexbox) |
| **Ngôn ngữ lập trình** | Vanilla JavaScript (ES6+), hoàn toàn không sử dụng Framework hay Backend |
| **Cơ sở dữ liệu** | **SQLite 3** (`db.db` / `SQLite/db.db`) chạy trên trình duyệt qua WebAssembly (`sql.js`) + đồng bộ `localStorage` |
| **Thiết kế & Màu sắc** | Light Mode, nền trắng (`#FFFFFF`), màu đỏ chủ đạo Vietjet (`#ee1d23`), điểm nhấn vàng (`#ffcc00`) |

---

## 📂 Cấu Trúc Thư Mục Dự Án

```text
Vietjet_AIR/
├── index.html                  # 1. Trang chủ (Tìm chuyến bay, 8 Tour 600x400, Hãng hàng không)
├── flights.html                # 2. Trang danh sách & bộ lọc Chuyến bay
├── flight-detail.html          # 3. Trang Chi tiết chuyến bay (Chọn Hạng Phổ Thông / Thương Gia)
├── tours.html                  # 4. Trang danh sách & bộ lọc Tour du lịch
├── tour-detail.html            # 5. Trang Chi tiết Tour & Lịch trình chuyến đi
├── cart.html                   # 6. Trang Giỏ hàng, Đăng ký & Gửi email xác nhận
├── db.db                       # File cơ sở dữ liệu SQLite 3 chính
├── css/
│   └── style.css               # Stylesheet toàn trang (Tông sáng, màu chủ đạo #ee1d23)
├── js/
│   ├── db.js                   # Kết nối & truy vấn SQLite (db.db) qua sql.js
│   ├── home.js                 # Logic Trang chủ
│   ├── flights.js              # Logic lọc & sắp xếp Chuyến bay
│   ├── flight-detail.js        # Logic chọn hạng vé & thêm chuyến bay vào Giỏ hàng
│   ├── tours.js                # Logic lọc & sắp xếp Tour
│   ├── tour-detail.js          # Logic hiển thị lịch trình & thêm Tour vào Giỏ hàng
│   └── cart.js                 # Logic quản lý Giỏ hàng, Đăng ký & Gửi email từ minhkhoithan@gmail.com
├── SQLite/                     # Thư mục chứa các file .sql và các bản .db SQLite
│   ├── db.db                   # Database SQLite đầy đủ
│   ├── vietjet_full_database.sql
│   ├── 01_schema.sql
│   ├── 02_seed_airlines.sql
│   ├── 03_seed_flights.sql
│   ├── 04_seed_tours.sql
│   └── 05_seed_cart_and_bookings.sql
├── images/                     # Hình ảnh thương hiệu & tàu bay Vietjet Air
└── README.md                   # Tài liệu giới thiệu & hướng dẫn sử dụng
```

---

## 🚀 Hướng Dẫn Chạy Dự Án (Local & GitHub Pages)

### Cách 1: Mở trực tiếp trên máy tính
Bạn chỉ cần mở trực tiếp file **`index.html`** bằng trình duyệt (Chrome, Edge, Firefox, Safari) hoặc sử dụng tiện ích **Live Server** trên VS Code / Antigravity.

### Cách 2: Chạy bằng Local HTTP Server (Khuyến nghị)
Nếu muốn chạy qua cổng localhost, mở Terminal tại thư mục dự án:
```bash
# Sử dụng npx serve (nếu có Node.js)
npx serve .

# Hoặc sử dụng Python HTTP Server
python -m http.server 8080
```
Sau đó truy cập `http://localhost:8080`.

---

## 📦 Hướng Dẫn Đẩy Dự Án Lên GitHub (Git Commands)

Mở Terminal (PowerShell hoặc Git Bash) tại thư mục `d:\Vibe Coding\Vietjet_AIR` và chạy lần lượt các lệnh sau:

```bash
# 1. Khởi tạo Git repository
git init

# 2. Thêm toàn bộ file vào staging
git add .

# 3. Tạo commit đầu tiên
git commit -m "feat: complete Vietjet travel website with SQLite db.db"

# 4. Đổi tên nhánh chính thành main
git branch -M main

# 5. Kết nối tới GitHub repository của bạn (Thay URL bằng link repo của bạn)
git remote add origin https://github.com/<ten-tai-khoan-cua-ban>/<ten-repo>.git

# 6. Đẩy code lên GitHub
git push -u origin main
```

> 💡 **Mẹo triển khai miễn phí trên GitHub Pages**:
> Sau khi đẩy code lên GitHub, vào mục **Settings** ➔ **Pages** của repository, dưới phần **Build and deployment (Branch)** chọn nhánh **`main`** và thư mục **`/ (root)`**, sau đó nhấn **Save**. Website Vietjet của bạn sẽ chạy trực tuyến ngay lập tức!

---

## 📧 Thông Tin Liên Hệ
- **Dự án**: Vietjet Travel Website
- **Email hệ thống xác nhận đặt chỗ**: `minhkhoithan@gmail.com`
