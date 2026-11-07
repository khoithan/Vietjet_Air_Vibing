-- ============================================================================
-- VIETJET TRAVEL WEBSITE - SEED CART & BOOKINGS SAMPLE (SQLite)
-- File: SQLite/05_seed_cart_and_bookings.sql
-- ============================================================================

-- Dữ liệu mẫu trong Giỏ hàng để khi mở trang Giỏ Hàng có thể xem & kiểm thử ngay
INSERT INTO cart_items (
    id, item_type, ref_id, title, subtitle,
    origin_city, destination_city, service_class,
    unit_price, quantity, departure_date, departure_time,
    flight_duration, airline_name, aircraft_type
) VALUES
(
    1,
    'FLIGHT',
    1,
    'TP. Hồ Chí Minh (SGN) ➔ Hà Nội (HAN)',
    'Chuyến bay VJ122 • Khứ hồi',
    'TP. Hồ Chí Minh',
    'Hà Nội',
    'Hạng Phổ Thông',
    1190000,
    1,
    '2026-11-15',
    '07:30',
    '2 giờ 10 phút',
    'VietJet Air',
    'Airbus A321neo'
),
(
    2,
    'TOUR',
    1,
    'Thiên Đường Đảo Ngọc Phú Quốc - Grand World - Hòn Thơm',
    'Vietjet Holidays • 3 Ngày 2 Đêm',
    'TP. Hồ Chí Minh',
    'Phú Quốc',
    'Tour Trọn Gói',
    3890000,
    1,
    '2026-11-16',
    '08:15',
    '1 giờ 05 phút',
    'VietJet Air',
    'Airbus A321neo'
);

-- Dữ liệu mẫu 1 đơn đăng ký thành công trong bảng bookings
INSERT INTO bookings (
    id, booking_code, customer_name, customer_email, customer_phone,
    customer_note, sender_email, total_amount, items_summary_json, status
) VALUES
(
    1,
    'VJ-20261107-001',
    'Nguyễn Văn An',
    'khachhang@example.com',
    '0901234567',
    'Yêu cầu ghế ngồi gần cửa sổ',
    'minhkhoithan@gmail.com',
    5080000,
    '[{"type":"FLIGHT","title":"TP. Hồ Chí Minh (SGN) -> Hà Nội (HAN)","class":"Hạng Phổ Thông","price":1190000},{"type":"TOUR","title":"Thiên Đường Đảo Ngọc Phú Quốc - Grand World - Hòn Thơm","class":"Tour Trọn Gói","price":3890000}]',
    'COMPLETED'
);
