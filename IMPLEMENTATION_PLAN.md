# Kế hoạch Triển khai Dự án cho Antigravity (`IMPLEMENTATION_PLAN.md`)

Tài liệu này dùng làm kịch bản thực thi từng bước (Step-by-step Action Plan) để **Antigravity** tự động xây dựng hoàn chỉnh website du lịch **Vietjet**.

---

## Cấu trúc Thư mục Dự án (Target Directory Structure)

```text
Vietjet_AIR/
├── GEMINI.md                  # Quy tắc hệ thống cho Antigravity
├── PRD.md                     # Đặc tả yêu cầu chức năng chi tiết
├── DATABASE.md                # Thiết kế SQLite Schema & Luồng gửi Email
├── UI_UX_SPEC.md              # Đặc tả giao diện & màu sắc (#ee1d23)
├── IMPLEMENTATION_PLAN.md     # Kế hoạch thực thi từng bước
├── images/                    # Thư mục ảnh thương hiệu Vietjet có sẵn
│   ├── 2aOboRAvPChFky1ocMfEck7L9rvvV1VWvb6HTuOe.jpg (Banner tiếp viên)
│   ├── 2aOboRAvPCl8aJFLRvC9C6cuHOJz016Hhl8xEeG0.jpg (Máy bay Vietjet)
│   └── 2aOboRAvPCnNF8ux8l12JJoKC6uw9yMZkM5dUYs4.jpg (Logo VietjetAir.com)
├── sql/
│   └── schema.sql             # File SQL tạo bảng và dữ liệu mẫu (Flights, 8 Tours, Airlines)
├── css/
│   └── style.css              # Stylesheet tổng (Light theme, nền trắng, đỏ #ee1d23)
├── js/
│   ├── db.js                  # Khởi tạo SQLite (sql.js), seed data & đồng bộ localStorage
│   ├── app.js                 # Hàm tiện ích chung, header badge giỏ hàng, format tiền tệ
│   ├── home.js                # Logic Trang chủ (Form tìm kiếm, render 8 tour 600x400, hãng bay)
│   ├── flights.js             # Logic lọc & sắp xếp trang Chuyến bay
│   ├── flight-detail.js       # Logic chọn hạng Phổ thông/Thương gia & thêm vào giỏ hàng
│   ├── tours.js               # Logic lọc & sắp xếp trang Tour
│   ├── tour-detail.js         # Logic hiển thị lịch trình tour & thêm vào giỏ hàng
│   └── cart.js                # Quản lý giỏ hàng, đăng ký & gửi email từ minhkhoithan@gmail.com
├── index.html                 # 1. Trang chủ
├── flights.html               # 2. Trang danh sách & bộ lọc Chuyến bay
├── flight-detail.html         # 3. Trang Chi tiết chuyến bay
├── tours.html                 # 4. Trang danh sách & bộ lọc Tour
├── tour-detail.html           # 5. Trang Chi tiết Tour
└── cart.html                  # 6. Trang Giỏ hàng & Đăng ký nhận email
```

---

## Các Giai đoạn Thực thi (Implementation Phases)

### Phase 1: Xây dựng Cơ sở dữ liệu SQLite (`sql/schema.sql` & `js/db.js`)
- [ ] Tạo file `sql/schema.sql` định nghĩa 5 bảng: `airlines`, `flights`, `tours`, `cart_items`, `bookings`.
- [ ] Nạp dữ liệu mẫu phong phú:
  - **6 Hãng hàng không**: VietJet Air, Vietnam Airlines, Singapore Airlines, Bamboo Airways, Thai Airways, Korean Air.
  - **15+ Chuyến bay**: Đủ các chặng nội địa & quốc tế, đủ loại vé (một chiều, khứ hồi, bay thẳng, nhiều thành phố), đủ khung giờ cất cánh (sáng, trưa, chiều, tối), đủ dòng máy bay (`Airbus A321neo`, `Airbus A330`, `Boeing 787-9 Dreamliner`, `Boeing 737 MAX`).
  - **8+ Tour du lịch nổi bật**: Hình thumbnail chuẩn `600x400`, ghi rõ hãng lữ hành, số ngày/đêm, giá tour, hãng bay, giờ cất cánh, loại máy bay và lịch trình chi tiết từng ngày.
- [ ] Xây dựng `js/db.js` tích hợp `sql.js` để thực thi truy vấn SQL thật ngay trên trình duyệt.

### Phase 2: Xây dựng Hệ thống Giao diện (`css/style.css` & `js/app.js`)
- [ ] Thiết kế `css/style.css` với tông sáng, nền trắng `#FFFFFF`, màu chủ đạo `#ee1d23`, chữ rõ nét, responsive hoàn chỉnh.
- [ ] Xây dựng Header/Navbar đồng nhất trên cả 6 trang kèm bộ đếm số lượng Giỏ hàng thời gian thực.

### Phase 3: Xây dựng Trang Chủ (`index.html` & `js/home.js`)
- [ ] Tạo khung tìm kiếm chuyến bay (chọn ngày, điểm đi, điểm đến, vé khứ hồi / một chiều) dẫn sang `flights.html`.
- [ ] Render **8 tour du lịch nổi bật** từ SQLite với hình thumbnail `600x400`, hãng du lịch, số ngày/đêm, giá tour; click dẫn đến trang Tour.
- [ ] Render danh sách **Logo các hãng hàng không** (VietJet Air, Vietnam Airlines, Singapore Airlines...); click vào logo dẫn đến trang `flights.html` lọc theo hãng đó.

### Phase 4: Xây dựng Luồng Chuyến Bay (`flights.html` & `flight-detail.html`)
- [ ] Trang `flights.html`:
  - Cột trái: Bộ lọc giá vé tăng/giảm dần, vé khứ hồi, vé một chiều, bay thẳng, nhiều thành phố, các hãng hàng không, thời gian cất cánh (giờ), hạng dịch vụ (Phổ thông, Thương gia).
  - Cột phải: Danh sách chuyến bay từ SQLite, click chọn dẫn đến `flight-detail.html`.
- [ ] Trang `flight-detail.html`:
  - Hiển thị điểm đi, điểm đến, thời gian bay, hãng bay, loại máy bay (Boeing, Airbus...).
  - Hiển thị 2 card chọn giá vé: **Hạng Phổ Thông** và **Hạng Thương Gia**.
  - Click chọn chuyến bay sẽ lưu vào bảng `cart_items` trong SQLite và chuyển tới Giỏ Hàng.

### Phase 5: Xây dựng Luồng Tour Du Lịch (`tours.html` & `tour-detail.html`)
- [ ] Trang `tours.html`:
  - Cột trái: Bộ lọc giá vé tăng/giảm dần, các hãng hàng không, thời gian cất cánh (giờ).
  - Cột phải: Danh sách tour du lịch, hãng bay, ngày cất cánh, thời gian bay, giá tiền, dịch vụ. Click chọn dẫn đến `tour-detail.html`.
- [ ] Trang `tour-detail.html`:
  - Hiển thị điểm đi, điểm đến, thời gian bay, hãng bay, loại máy bay (Boeing, Airbus...) và **Lịch trình chuyến đi** chi tiết.
  - Click chọn tour sẽ lưu vào Giỏ Hàng.

### Phase 6: Xây dựng Giỏ Hàng & Gửi Email (`cart.html` & `js/cart.js`)
- [ ] Hiển thị danh sách chuyến bay và tour đã chọn từ SQLite, cho phép xóa từng mục hoặc xóa toàn bộ giỏ hàng.
- [ ] Form nhập thông tin cá nhân (Họ tên, Email, Số điện thoại, Ghi chú).
- [ ] Xử lý nút **Đăng ký**: Lưu vào bảng `bookings`, gửi email xác nhận từ `minhkhoithan@gmail.com` đến email của khách hàng, và hiển thị thông báo hoàn thành.

---

## Câu lệnh Prompt Gợi ý để Chạy trong Antigravity
Sau khi có bộ file `.md` này, bạn chỉ cần nhập câu lệnh sau cho Antigravity:
> *"Hãy đọc các file `GEMINI.md`, `PRD.md`, `DATABASE.md`, `UI_UX_SPEC.md` và `IMPLEMENTATION_PLAN.md` trong thư mục dự án, sau đó tiến hành code hoàn chỉnh toàn bộ website Vietjet theo đúng kế hoạch."*
