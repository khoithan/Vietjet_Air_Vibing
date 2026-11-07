# Đặc tả Giao diện & Thiết kế Chi tiết (`UI_UX_SPEC.md`)

## 1. Nhận diện Thương hiệu (Brand Identity)
- **Tên Website**: **Vietjet**
- **Tông màu nền (Background)**: Tông sáng, nền trắng tinh khiết (`#FFFFFF`), vùng phân tách dùng xám nhạt (`#F8F9FA`).
- **Màu chủ đạo (Primary Color)**: Đỏ Vietjet **`#ee1d23`**.
- **Màu điểm nhấn (Accent Color)**: Vàng tươi **`#ffcc00`** (dùng cho nút phụ, huy hiệu khuyến mãi, đường viền trang trí kiểu đuôi máy bay Vietjet).
- **Biến CSS chuẩn (`:root`)**:
  ```css
  :root {
    --primary-red: #ee1d23;
    --primary-red-dark: #c51217;
    --primary-red-light: #fff1f2;
    --accent-yellow: #ffcc00;
    --bg-white: #ffffff;
    --bg-light: #f8f9fa;
    --text-main: #1e293b;
    --text-muted: #64748b;
    --border-color: #e2e8f0;
    --shadow-sm: 0 2px 8px rgba(0, 0, 0, 0.06);
    --shadow-md: 0 8px 24px rgba(238, 29, 35, 0.12);
    --radius-md: 12px;
    --radius-lg: 16px;
  }
  ```

---

## 2. Thiết kế Bố cục Từng Trang

### 2.1. Trang Chủ (`index.html`)
1. **Thanh Điều Hướng (Navbar)**:
   - Nền trắng `#ffffff`, đổ bóng nhẹ, thanh viền trên cùng màu đỏ `#ee1d23`.
   - Bên trái: Logo Vietjet (`images/2aOboRAvPCnNF8ux8l12JJoKC6uw9yMZkM5dUYs4.jpg`) + chữ **VIETJET TRAVEL**.
   - Bên phải: Menu `Trang chủ`, `Chuyến bay`, `Tour du lịch`, và nút `Giỏ hàng` có chấm đỏ hiển thị tổng số lượng vé/tour.
2. **Hero Section & Bộ Tìm Kiếm Chuyến Bay**:
   - Hình nền bên phải/banner sử dụng ảnh tiếp viên Vietjet (`images/2aOboRAvPChFky1ocMfEck7L9rvvV1VWvb6HTuOe.jpg`).
   - Khung tìm kiếm nổi (Floating Card nền trắng, viền bo tròn `16px`):
     - Hàng 1: Radio chọn **Vé khứ hồi** / **Vé một chiều**.
     - Hàng 2: 4 ô nhập liệu ngang:
       1. `Điểm xuất phát` (Select: TP.HCM, Hà Nội, Đà Nẵng, Phú Quốc...)
       2. `Điểm đến` (Select: Hà Nội, TP.HCM, Đà Nẵng, Singapore, Bangkok, Tokyo...)
       3. `Ngày đi` (Input date)
       4. `Ngày về` (Input date - tự động bật/tắt theo loại vé)
     - Nút **Tìm Kiếm** lớn màu đỏ `#ee1d23`, chữ trắng in đậm, icon máy bay. Click chuyển sang `flights.html`.
3. **Khu vực 8 Tour Du Lịch Nổi Bật**:
   - Tiêu đề: *"Tour Du Lịch Nổi Bật Cùng Vietjet"* kèm đường gạch chân màu đỏ `#ee1d23`.
   - Grid 4 cột x 2 hàng = **8 Tour**.
   - Mỗi Card Tour:
     - Khung ảnh kích thước chuẩn **600x400** (`width="600" height="400"`, CSS `aspect-ratio: 600 / 400; object-fit: cover;`).
     - Badge góc trái trên ảnh: Số ngày/đêm (VD: `4 Ngày 3 Đêm`) nền đỏ `#ee1d23`.
     - Nội dung dưới ảnh:
       - Hãng du lịch (icon chiếc cặp + tên hãng: *Vietjet Holidays*, *Vietravel*...).
       - Tên Tour in đậm (2 dòng).
       - Giá tour màu đỏ `#ee1d23` cỡ lớn + nút "Xem ngay".
     - Toàn bộ Card có hiệu ứng hover nâng nhẹ (`transform: translateY(-4px)`), click dẫn sang trang **Tour (`tours.html`)**.
4. **Khu vực Hãng Hàng Không Đối Tác**:
   - Tiêu đề: *"Đối Tác Hàng Không Hàng Đầu"*.
   - Các ô thẻ Logo: **VietJet Air**, **Vietnam Airlines**, **Singapore Airlines**, **Bamboo Airways**, **Thai Airways**, **Korean Air**.
   - Khi hover viền chuyển sang màu đỏ `#ee1d23`. Click vào logo dẫn ngay tới trang `flights.html?airline=<Tên_Hãng>`.

---

### 2.2. Giao diện Trang Chuyến Bay (`flights.html`) & Trang Tour (`tours.html`)
- **Layout 2 cột**:
  - **Sidebar Bộ lọc bên trái (`300px`)**: Nền trắng, cố định khi cuộn (`position: sticky; top: 90px;`), các nhóm bộ lọc phân cách bằng đường kẻ mảnh.
  - **Danh sách kết quả bên phải (`1fr`)**:
    - Thanh hiển thị số lượng kết quả tìm thấy và tag bộ lọc đang kích hoạt.
    - Các Card chuyến bay / tour thiết kế ngang (Horizontal Card) trên Desktop, hiển thị rõ giờ cất cánh, biểu tượng đường bay, dịch vụ đi kèm, giá tiền màu đỏ `#ee1d23` và nút **"Chọn"**.

---

### 2.3. Giao diện Chọn Hạng Vé ở Chi Tiết Chuyến Bay (`flight-detail.html`)
Mô phỏng trực quan bảng chọn hạng vé máy bay hiện đại của Vietjet Air:

```
+-----------------------------------------------------------------------------------+
| THÔNG TIN CHUYẾN BAY: VJ124 | TP. Hồ Chí Minh (SGN) ➔ Hà Nội (HAN)                |
| Ngày bay: 15/11/2026 | Giờ bay: 08:00 - 10:10 (2h 10m) | Máy bay: Airbus A321neo  |
+-----------------------------------------------------------------------------------+
|                                                                                   |
|   +-----------------------------------+   +-----------------------------------+   |
|   |        HẠNG PHỔ THÔNG (ECO)       |   |     HẠNG THƯƠNG GIA (SKYBOSS)     |   |
|   |         1.290.000 VNĐ / vé        |   |         3.490.000 VNĐ / vé        |   |
|   +-----------------------------------+   +-----------------------------------+   |
|   | ✓ 07 kg hành lý xách tay          |   | ✓ 18 kg hành lý xách tay          |   |
|   | ✗ Hành lý ký gửi (Mua thêm)       |   | ✓ 40 kg hành lý ký gửi miễn phí   |   |
|   | ✓ Chọn chỗ ngồi tiêu chuẩn        |   | ✓ Phòng chờ thương gia sang trọng |   |
|   | ✗ Suất ăn nóng trên máy bay       |   | ✓ Suất ăn nóng & đồ uống miễn phí |   |
|   |                                   |   | ✓ Ưu tiên làm thủ tục & lên tàu   |   |
|   |    [ (•) Chọn Hạng Phổ Thông ]    |   |    [ ( ) Chọn Hạng Thương Gia ]   |   |
|   +-----------------------------------+   +-----------------------------------+   |
|                                                                                   |
|                        [ 🛒 CHỌN CHUYẾN BAY (VÀO GIỎ HÀNG) ]                      |
+-----------------------------------------------------------------------------------+
```

---

### 2.4. Giao diện Chi Tiết Tour (`tour-detail.html`)
- **Khối Thông tin Hàng không của Tour**:
  - Hiển thị nổi bật: Điểm đi, Điểm đến, Thời gian bay, Hãng bay, **Loại máy bay (Airbus A321 / Boeing 787)**.
- **Khối Lịch trình chuyến đi (Timeline dọc)**:
  - Các mốc **Ngày 1**, **Ngày 2**, **Ngày 3**... có chấm tròn màu đỏ `#ee1d23` nối nhau bằng đường kẻ dọc, trình bày rõ hoạt động tham quan, ăn uống, khách sạn.
- **Khối Đặt Tour cố định bên phải**:
  - Hiển thị Giá Tour, chọn số lượng khách, nút **"Chọn Tour (Lưu vào Giỏ Hàng)"** màu đỏ `#ee1d23`.

---

### 2.5. Giao diện Giỏ Hàng & Đăng Ký (`cart.html`)
- **Cột Trái (Danh sách Giỏ Hàng)**:
  - Bảng / Danh sách các Chuyến bay & Tour đã chọn.
  - Mỗi dòng có: Loại (Badge `Chuyến bay` hoặc `Tour`), Tên hành trình, Hãng bay, Loại máy bay, Ngày/Giờ khởi hành, Hạng vé, Giá tiền, nút **Xóa** từng mục.
  - Nút **"Xóa toàn bộ giỏ hàng"** ở góc trên.
- **Cột Phải (Thông tin Cá nhân & Đăng Ký)**:
  - Form nhập: Họ và tên, Email nhận vé, Số điện thoại, Ghi chú.
  - Dòng ghi chú rõ ràng: *"Email xác nhận sẽ được gửi từ `minhkhoithan@gmail.com` tới hộp thư của bạn."*
  - Nút **"ĐĂNG KÝ NGAY"** màu đỏ `#ee1d23`.
  - Khi hoàn tất: Hiện Modal chúc mừng thành công kèm chi tiết email xác nhận.
