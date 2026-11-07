-- ============================================================================
-- VIETJET TRAVEL WEBSITE - DATABASE SCHEMA (SQLite)
-- File: SQLite/01_schema.sql
-- ============================================================================

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS cart_items;
DROP TABLE IF EXISTS tours;
DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS airlines;

-- 1. Bảng Hãng hàng không (Airlines)
CREATE TABLE airlines (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    logo_url TEXT NOT NULL,
    country TEXT DEFAULT 'Việt Nam',
    description TEXT
);

-- 2. Bảng Chuyến bay (Flights)
CREATE TABLE flights (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    flight_code TEXT NOT NULL,
    airline_id INTEGER NOT NULL,
    airline_name TEXT NOT NULL,
    origin_code TEXT NOT NULL,
    origin_city TEXT NOT NULL,
    destination_code TEXT NOT NULL,
    destination_city TEXT NOT NULL,
    departure_date TEXT NOT NULL,        -- Định dạng YYYY-MM-DD
    return_date TEXT,                    -- Định dạng YYYY-MM-DD (nếu vé khứ hồi)
    departure_time TEXT NOT NULL,        -- Định dạng HH:mm (24h)
    arrival_time TEXT NOT NULL,          -- Định dạng HH:mm (24h)
    duration TEXT NOT NULL,              -- Thời gian bay (VD: 2 giờ 05 phút)
    trip_type TEXT NOT NULL,             -- 'round-trip' | 'one-way' | 'direct' | 'multi-city'
    is_direct INTEGER DEFAULT 1,         -- 1: Bay thẳng, 0: Nhiều thành phố / Nối chuyến
    aircraft_type TEXT NOT NULL,         -- Loại máy bay (Airbus A321neo, Boeing 787-9...)
    price_economy INTEGER NOT NULL,      -- Giá vé Hạng Phổ Thông (VNĐ)
    price_business INTEGER NOT NULL,     -- Giá vé Hạng Thương Gia (VNĐ)
    services_economy TEXT NOT NULL,      -- Quyền lợi Hạng Phổ Thông
    services_business TEXT NOT NULL,     -- Quyền lợi Hạng Thương Gia
    FOREIGN KEY (airline_id) REFERENCES airlines(id) ON DELETE CASCADE
);

-- 3. Bảng Tour du lịch (Tours)
CREATE TABLE tours (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    travel_agency TEXT NOT NULL,         -- Hãng du lịch (Vietjet Holidays, Vietravel, Saigontourist...)
    airline_id INTEGER NOT NULL,
    airline_name TEXT NOT NULL,          -- Hãng hàng không vận chuyển
    origin_code TEXT NOT NULL,
    origin_city TEXT NOT NULL,           -- Điểm đi
    destination_code TEXT NOT NULL,
    destination_city TEXT NOT NULL,      -- Điểm đến
    duration_text TEXT NOT NULL,         -- Số ngày/đêm (VD: 4 Ngày 3 Đêm)
    departure_date TEXT NOT NULL,        -- Ngày cất cánh (YYYY-MM-DD)
    departure_time TEXT NOT NULL,        -- Giờ cất cánh (HH:mm)
    flight_duration TEXT NOT NULL,       -- Thời gian bay (VD: 1 giờ 50 phút)
    aircraft_type TEXT NOT NULL,         -- Loại máy bay (Boeing, Airbus...)
    price INTEGER NOT NULL,              -- Giá tour trọn gói (VNĐ)
    thumbnail_url TEXT NOT NULL,         -- Hình thumbnail 600x400
    services TEXT NOT NULL,              -- Dịch vụ đi kèm (Khách sạn, vé máy bay, xe đưa đón...)
    itinerary_json TEXT NOT NULL,        -- Lịch trình chi tiết từng ngày (JSON)
    is_featured INTEGER DEFAULT 1,       -- 1: Hiển thị trong 8 tour nổi bật ở Trang chủ
    FOREIGN KEY (airline_id) REFERENCES airlines(id) ON DELETE CASCADE
);

-- 4. Bảng Giỏ hàng (Cart Items)
CREATE TABLE cart_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    item_type TEXT NOT NULL,             -- 'FLIGHT' hoặc 'TOUR'
    ref_id INTEGER NOT NULL,             -- ID tham chiếu tới bảng flights hoặc tours
    title TEXT NOT NULL,                 -- Tiêu đề chuyến bay hoặc tên tour
    subtitle TEXT,                       -- Thông tin phụ (Mã chuyến bay / Hãng du lịch)
    origin_city TEXT,
    destination_city TEXT,
    service_class TEXT NOT NULL,         -- 'Hạng Phổ Thông' | 'Hạng Thương Gia' | 'Tour Trọn Gói'
    unit_price INTEGER NOT NULL,         -- Đơn giá (VNĐ)
    quantity INTEGER DEFAULT 1,          -- Số lượng hành khách
    departure_date TEXT,                 -- Ngày khởi hành
    departure_time TEXT,                 -- Giờ cất cánh
    flight_duration TEXT,                -- Thời gian bay
    airline_name TEXT,                   -- Hãng hàng không
    aircraft_type TEXT,                  -- Loại máy bay (Boeing, Airbus...)
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- 5. Bảng Đơn đặt chỗ & Đăng ký nhận Email (Bookings)
CREATE TABLE bookings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    booking_code TEXT NOT NULL UNIQUE,   -- Mã đơn hàng (VD: VJ-20261107-001)
    customer_name TEXT NOT NULL,         -- Họ tên khách hàng
    customer_email TEXT NOT NULL,        -- Email khách hàng nhận thông báo
    customer_phone TEXT NOT NULL,        -- Số điện thoại khách hàng
    customer_note TEXT,                  -- Ghi chú thêm
    sender_email TEXT DEFAULT 'minhkhoithan@gmail.com', -- Email gửi xác nhận
    total_amount INTEGER NOT NULL,       -- Tổng tiền thanh toán (VNĐ)
    items_summary_json TEXT NOT NULL,    -- Chi tiết các vé/tour đã đặt (JSON)
    status TEXT DEFAULT 'COMPLETED',
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Indexes tối ưu hóa truy vấn lọc (Filter Queries)
CREATE INDEX idx_flights_airline ON flights(airline_name);
CREATE INDEX idx_flights_route ON flights(origin_code, destination_code);
CREATE INDEX idx_flights_trip_type ON flights(trip_type);
CREATE INDEX idx_flights_price_eco ON flights(price_economy);
CREATE INDEX idx_flights_dep_time ON flights(departure_time);

CREATE INDEX idx_tours_airline ON tours(airline_name);
CREATE INDEX idx_tours_price ON tours(price);
CREATE INDEX idx_tours_dep_time ON tours(departure_time);
CREATE INDEX idx_tours_featured ON tours(is_featured);
