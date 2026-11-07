-- ============================================================================
-- VIETJET TRAVEL WEBSITE - FULL MASTER SQLITE DATABASE SCRIPT
-- File: SQLite/vietjet_full_database.sql
-- Tệp tổng hợp toàn bộ Schema + Seed Data (Airlines, Flights, 8 Tours, Cart, Bookings)
-- Có thể chạy trực tiếp bằng SQLite CLI, DB Browser for SQLite, hoặc sql.js trên trình duyệt
-- ============================================================================

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS cart_items;
DROP TABLE IF EXISTS tours;
DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS airlines;

-- ============================================================================
-- 1. TẠO BẢNG (TABLES)
-- ============================================================================

CREATE TABLE airlines (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    logo_url TEXT NOT NULL,
    country TEXT DEFAULT 'Việt Nam',
    description TEXT
);

CREATE TABLE flights (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    flight_code TEXT NOT NULL,
    airline_id INTEGER NOT NULL,
    airline_name TEXT NOT NULL,
    origin_code TEXT NOT NULL,
    origin_city TEXT NOT NULL,
    destination_code TEXT NOT NULL,
    destination_city TEXT NOT NULL,
    departure_date TEXT NOT NULL,
    return_date TEXT,
    departure_time TEXT NOT NULL,
    arrival_time TEXT NOT NULL,
    duration TEXT NOT NULL,
    trip_type TEXT NOT NULL,             -- 'round-trip' | 'one-way' | 'direct' | 'multi-city'
    is_direct INTEGER DEFAULT 1,
    aircraft_type TEXT NOT NULL,         -- Airbus, Boeing...
    price_economy INTEGER NOT NULL,      -- Giá Hạng Phổ Thông
    price_business INTEGER NOT NULL,     -- Giá Hạng Thương Gia
    services_economy TEXT NOT NULL,
    services_business TEXT NOT NULL,
    FOREIGN KEY (airline_id) REFERENCES airlines(id) ON DELETE CASCADE
);

CREATE TABLE tours (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    travel_agency TEXT NOT NULL,
    airline_id INTEGER NOT NULL,
    airline_name TEXT NOT NULL,
    origin_code TEXT NOT NULL,
    origin_city TEXT NOT NULL,
    destination_code TEXT NOT NULL,
    destination_city TEXT NOT NULL,
    duration_text TEXT NOT NULL,
    departure_date TEXT NOT NULL,
    departure_time TEXT NOT NULL,
    flight_duration TEXT NOT NULL,
    aircraft_type TEXT NOT NULL,
    price INTEGER NOT NULL,
    thumbnail_url TEXT NOT NULL,         -- Hình 600x400
    services TEXT NOT NULL,
    itinerary_json TEXT NOT NULL,
    is_featured INTEGER DEFAULT 1,
    FOREIGN KEY (airline_id) REFERENCES airlines(id) ON DELETE CASCADE
);

CREATE TABLE cart_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    item_type TEXT NOT NULL,             -- 'FLIGHT' | 'TOUR'
    ref_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    subtitle TEXT,
    origin_city TEXT,
    destination_city TEXT,
    service_class TEXT NOT NULL,         -- 'Hạng Phổ Thông' | 'Hạng Thương Gia' | 'Tour Trọn Gói'
    unit_price INTEGER NOT NULL,
    quantity INTEGER DEFAULT 1,
    departure_date TEXT,
    departure_time TEXT,
    flight_duration TEXT,
    airline_name TEXT,
    aircraft_type TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE bookings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    booking_code TEXT NOT NULL UNIQUE,
    customer_name TEXT NOT NULL,
    customer_email TEXT NOT NULL,
    customer_phone TEXT NOT NULL,
    customer_note TEXT,
    sender_email TEXT DEFAULT 'minhkhoithan@gmail.com',
    total_amount INTEGER NOT NULL,
    items_summary_json TEXT NOT NULL,
    status TEXT DEFAULT 'COMPLETED',
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_flights_airline ON flights(airline_name);
CREATE INDEX idx_flights_route ON flights(origin_code, destination_code);
CREATE INDEX idx_flights_trip_type ON flights(trip_type);
CREATE INDEX idx_flights_price_eco ON flights(price_economy);
CREATE INDEX idx_flights_dep_time ON flights(departure_time);

CREATE INDEX idx_tours_airline ON tours(airline_name);
CREATE INDEX idx_tours_price ON tours(price);
CREATE INDEX idx_tours_dep_time ON tours(departure_time);
CREATE INDEX idx_tours_featured ON tours(is_featured);

-- ============================================================================
-- 2. DỮ LIỆU HÃNG HÀNG KHÔNG (AIRLINES)
-- ============================================================================

INSERT INTO airlines (id, code, name, logo_url, country, description) VALUES
(1, 'VJ', 'VietJet Air', 'images/2aOboRAvPCnNF8ux8l12JJoKC6uw9yMZkM5dUYs4.jpg', 'Việt Nam', 'Hãng hàng không thế hệ mới hàng đầu Việt Nam & khu vực.'),
(2, 'VN', 'Vietnam Airlines', 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Vietnam_Airlines_logo.svg/600px-Vietnam_Airlines_logo.svg.png', 'Việt Nam', 'Hãng hàng không Quốc gia Việt Nam tiêu chuẩn 4 sao Skytrax.'),
(3, 'SQ', 'Singapore Airlines', 'https://upload.wikimedia.org/wikipedia/en/thumb/6/6b/Singapore_Airlines_Logo_2.svg/600px-Singapore_Airlines_Logo_2.svg.png', 'Singapore', 'Hãng hàng không 5 sao hàng đầu thế giới.'),
(4, 'QH', 'Bamboo Airways', 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Bamboo_Airways_Logo.svg/600px-Bamboo_Airways_Logo.svg.png', 'Việt Nam', 'Hãng hàng không hiếu khách định hướng dịch vụ 5 sao.'),
(5, 'TG', 'Thai Airways', 'https://upload.wikimedia.org/wikipedia/en/thumb/5/58/Thai_Airways_Logo.svg/600px-Thai_Airways_Logo.svg.png', 'Thái Lan', 'Hãng hàng không Quốc gia Thái Lan.'),
(6, 'KE', 'Korean Air', 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8f/Korean_Air_Logo.svg/600px-Korean_Air_Logo.svg.png', 'Hàn Quốc', 'Hãng hàng không lớn nhất Hàn Quốc.');

-- ============================================================================
-- 3. DỮ LIỆU CHUYẾN BAY (FLIGHTS)
-- ============================================================================

INSERT INTO flights (
    id, flight_code, airline_id, airline_name,
    origin_code, origin_city, destination_code, destination_city,
    departure_date, return_date, departure_time, arrival_time, duration,
    trip_type, is_direct, aircraft_type,
    price_economy, price_business, services_economy, services_business
) VALUES
(1, 'VJ122', 1, 'VietJet Air', 'SGN', 'TP. Hồ Chí Minh', 'HAN', 'Hà Nội', '2026-11-15', '2026-11-18', '07:30', '09:40', '2 giờ 10 phút', 'round-trip', 1, 'Airbus A321neo', 1190000, 3290000, '07kg hành lý xách tay, Chọn ghế tiêu chuẩn, Bảo hiểm chuyến bay Sky Care', '18kg xách tay + 40kg ký gửi, Phòng chờ sang trọng, Suất ăn nóng miễn phí, Ưu tiên làm thủ tục SkyBoss'),
(2, 'VJ624', 1, 'VietJet Air', 'SGN', 'TP. Hồ Chí Minh', 'DAD', 'Đà Nẵng', '2026-11-15', NULL, '05:15', '06:35', '1 giờ 20 phút', 'one-way', 1, 'Airbus A320-200', 790000, 2450000, '07kg hành lý xách tay, Chọn ghế tiêu chuẩn, Bảo hiểm Sky Care', '18kg xách tay + 30kg ký gửi, Phòng chờ thương gia, Suất ăn nóng & đồ uống miễn phí, Ưu tiên lên máy bay'),
(3, 'VJ453', 1, 'VietJet Air', 'HAN', 'Hà Nội', 'PQC', 'Phú Quốc', '2026-11-16', '2026-11-20', '13:45', '15:55', '2 giờ 10 phút', 'round-trip', 1, 'Airbus A321neo ACF', 1450000, 3690000, '07kg hành lý xách tay, Nước suối miễn phí, Bảo hiểm Sky Care', '18kg xách tay + 40kg ký gửi, Phòng chờ VIP, Suất ăn nóng cao cấp, Xe đưa đón ra tàu bay'),
(4, 'VJ822', 1, 'VietJet Air', 'SGN', 'TP. Hồ Chí Minh', 'NRT', 'Tokyo (Nhật Bản)', '2026-11-20', '2026-11-26', '23:10', '06:45', '5 giờ 35 phút', 'round-trip', 1, 'Airbus A330-300', 4290000, 9890000, '07kg hành lý xách tay, Ghế ngồi êm ái tàu thân rộng, Bảo hiểm quốc tế Sky Care', '18kg xách tay + 50kg ký gửi, Ghế giường nằm phẳng SkyBoss Business, Phòng chờ quốc tế 5 sao, Ẩm thực thực đơn riêng'),
(5, 'VN210', 2, 'Vietnam Airlines', 'SGN', 'TP. Hồ Chí Minh', 'HAN', 'Hà Nội', '2026-11-15', '2026-11-19', '08:00', '10:10', '2 giờ 10 phút', 'round-trip', 1, 'Boeing 787-9 Dreamliner', 1790000, 4850000, '10kg xách tay + 23kg ký gửi, Suất ăn nhẹ & đồ uống trên không, Giải trí màn hình cá nhân', '18kg xách tay + 32kg ký gửi, Ghế thương gia ngả phẳng 180 độ, Phòng chờ Bông Sen Vàng, Ẩm thực 5 sao'),
(6, 'VN171', 2, 'Vietnam Airlines', 'HAN', 'Hà Nội', 'DAD', 'Đà Nẵng', '2026-11-16', NULL, '15:20', '16:40', '1 giờ 20 phút', 'one-way', 1, 'Airbus A321-200', 1250000, 3350000, '10kg xách tay + 23kg ký gửi, Nước uống & khăn lạnh, Tích dặm Bông Sen Vàng', '18kg xách tay + 32kg ký gửi, Phòng chờ Bông Sen, Quầy thủ tục SkyPriority, Suất ăn nóng'),
(7, 'SQ177', 3, 'Singapore Airlines', 'SGN', 'TP. Hồ Chí Minh', 'SIN', 'Singapore', '2026-11-18', '2026-11-22', '12:30', '15:35', '2 giờ 05 phút', 'round-trip', 1, 'Airbus A350-900', 2890000, 7450000, '07kg xách tay + 25kg ký gửi, Suất ăn quốc tế nóng sốt, Hệ thống giải trí KrisWorld & Wifi', '15kg xách tay + 40kg ký gửi, Phòng chờ SilverKris 5 sao, Rượu vang thượng hạng & Thực đơn Book the Cook'),
(8, 'SQ191', 3, 'Singapore Airlines', 'HAN', 'Hà Nội', 'DPS', 'Bali (Indonesia)', '2026-11-19', '2026-11-25', '09:15', '17:45', '7 giờ 30 phút', 'multi-city', 0, 'Boeing 787-10 Dreamliner', 5490000, 12900000, '07kg xách tay + 30kg ký gửi xuyên suốt, 02 suất ăn nóng quốc tế, Giải trí KrisWorld', '15kg xách tay + 40kg ký gửi, Phòng chờ thương gia tại Nội Bài & Changi, Ghế giường phẳng hoàn toàn'),
(9, 'QH1415', 4, 'Bamboo Airways', 'HAN', 'Hà Nội', 'CXR', 'Nha Trang', '2026-11-15', NULL, '06:45', '08:40', '1 giờ 55 phút', 'one-way', 1, 'Airbus A321neo', 1320000, 3590000, '07kg xách tay + 20kg ký gửi, Suất ăn nhẹ và nước uống miễn phí', '14kg xách tay + 40kg ký gửi, Phòng chờ First Lounge, Ưu tiên hành lý & lối đi riêng'),
(10, 'TG557', 5, 'Thai Airways', 'SGN', 'TP. Hồ Chí Minh', 'BKK', 'Bangkok (Thái Lan)', '2026-11-17', '2026-11-21', '19:15', '20:45', '1 giờ 30 phút', 'direct', 1, 'Boeing 777-300ER', 2350000, 5950000, '07kg xách tay + 30kg ký gửi, Ẩm thực Thái Lan truyền thống trên máy bay', '14kg xách tay + 40kg ký gửi, Phòng chờ Royal Silk Lounge, Ghế thương gia rộng rãi'),
(11, 'KE462', 6, 'Korean Air', 'DAD', 'Đà Nẵng', 'ICN', 'Seoul (Hàn Quốc)', '2026-11-21', '2026-11-26', '22:50', '05:25', '4 giờ 35 phút', 'round-trip', 1, 'Boeing 787-9 Dreamliner', 4950000, 11200000, '10kg xách tay + 23kg ký gửi, Suất ăn Bibimbap Hàn Quốc, Màn hình giải trí cá nhân', '18kg xách tay + 32kg ký gửix2, Phòng chờ Prestige Class, Ghế Prestige Sleeper ngả phẳng'),
(12, 'VJ631', 1, 'VietJet Air', 'DAD', 'Đà Nẵng', 'PQC', 'Phú Quốc', '2026-11-18', NULL, '14:10', '18:05', '3 giờ 55 phút', 'multi-city', 0, 'Airbus A321-200', 1680000, 4190000, '07kg hành lý xách tay, Hỗ trợ nối chuyến nhanh, Bảo hiểm Sky Care', '18kg xách tay + 40kg ký gửi, Phòng chờ VIP tại cả 2 sân bay, Ẩm thực nóng miễn phí');

-- ============================================================================
-- 4. DỮ LIỆU 8 TOUR DU LỊCH NỔI BẬT (TOURS - THUMBNAIL 600x400)
-- ============================================================================

INSERT INTO tours (
    id, title, travel_agency, airline_id, airline_name,
    origin_code, origin_city, destination_code, destination_city,
    duration_text, departure_date, departure_time, flight_duration,
    aircraft_type, price, thumbnail_url, services, itinerary_json, is_featured
) VALUES
(1, 'Thiên Đường Đảo Ngọc Phú Quốc - Grand World - Hòn Thơm', 'Vietjet Holidays', 1, 'VietJet Air', 'SGN', 'TP. Hồ Chí Minh', 'PQC', 'Phú Quốc', '3 Ngày 2 Đêm', '2026-11-16', '08:15', '1 giờ 05 phút', 'Airbus A321neo', 3890000, 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?auto=format&fit=crop&w=600&h=400&q=80', 'Vé máy bay khứ hồi VietJet Air, Khách sạn Resort 4 sao sát biển, Cáp treo Hòn Thơm, Xe đưa đón VIP, Bảo hiểm du lịch', '[{"day":"Ngày 1: TP.HCM - Phú Quốc - Thành phố không ngủ Grand World","details":"06:30 Có mặt tại sân bay Tân Sơn Nhất làm thủ tục chuyến bay VietJet Air (Airbus A321neo) đi Phú Quốc. Trưa nhận phòng Resort 4 sao nghỉ ngơi. Chiều tham quan Dinh Cậu, tối khám phá Grand World, xem nhạc nước Venice."},{"day":"Ngày 2: Cáp treo Hòn Thơm - Cano 4 Đảo - Hoàng hôn Sunset Town","details":"Sáng trải nghiệm cáp treo vượt biển dài nhất thế giới ra Hòn Thơm, tắm biển và lặn ngắm san hô tại Hòn Móng Tay - Hòn Gầm Ghì. Chiều check-in Cầu Hôn (Kiss Bridge) tại Thị trấn Hoàng Hôn."},{"day":"Ngày 3: Chợ Dương Đông - Mua sắm đặc sản - Bay về TP.HCM","details":"Sáng tắm biển tự do, thưởng thức bún quậy Kiến Xây, mua ngọc trai & nước mắm Phú Quốc. Chiều ra sân bay đáp chuyến bay về lại TP.HCM."}]', 1),
(2, 'Đà Nẵng - Phố Cổ Hội An - Cầu Vàng Bà Nà Hills', 'Vietravel', 1, 'VietJet Air', 'HAN', 'Hà Nội', 'DAD', 'Đà Nẵng', '4 Ngày 3 Đêm', '2026-11-18', '07:00', '1 giờ 20 phút', 'Airbus A321neo ACF', 4590000, 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=600&h=400&q=80', 'Vé máy bay khứ hồi, Khách sạn 4 sao biển Mỹ Khê, Vé cáp treo Bà Nà Hills & Buffet trưa, Hướng dẫn viên suốt tuyến', '[{"day":"Ngày 1: Hà Nội - Đà Nẵng - Bán đảo Sơn Trà - Biển Mỹ Khê","details":"Đáp chuyến bay sáng của VietJet Air đến Đà Nẵng. Tham quan Chùa Linh Ứng Bãi Bụt, tắm biển Mỹ Khê và ngắm Cầu Rồng phun lửa về đêm."},{"day":"Ngày 2: Khu du lịch Bà Nà Hills - Cầu Vàng - Làng Pháp","details":"Đi cáp treo lên đỉnh Bà Nà, check-in Cầu Vàng nổi tiếng thế giới, vui chơi tại Fantasy Park và dùng buffet trưa 5 sao."},{"day":"Ngày 3: Rừng dừa Bảy Mẫu - Phố cổ Hội An","details":"Sáng trải nghiệm thuyền thúng Rừng dừa Bảy Mẫu. Chiều dạo bước Phố cổ Hội An, Chùa Cầu, thả đèn hoa đăng trên sông Hoài."},{"day":"Ngày 4: Chợ Hàn - Mua sắm đặc sản - Hà Nội","details":"Mua sắm đặc sản miền Trung tại Chợ Hàn, ra sân bay quốc tế Đà Nẵng bay về Hà Nội."}]', 1),
(3, 'Du Thuyền 5 Sao Vịnh Hạ Long - Tràng An Ninh Bình - Hà Nội', 'Saigontourist', 2, 'Vietnam Airlines', 'SGN', 'TP. Hồ Chí Minh', 'HAN', 'Hà Nội - Hạ Long', '4 Ngày 3 Đêm', '2026-11-20', '08:30', '2 giờ 10 phút', 'Boeing 787-9 Dreamliner', 6490000, 'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=600&h=400&q=80', 'Vé máy bay Vietnam Airlines (Boeing 787), 01 đêm Du thuyền 5 sao Hạ Long, 02 đêm khách sạn 4 sao, Ăn uống trọn gói', '[{"day":"Ngày 1: TP.HCM - Hà Nội - Phố cổ 36 Phố Phường","details":"Bay từ TP.HCM ra Hà Nội bằng tàu bay thân rộng Boeing 787-9 Dreamliner. Tham quan Hồ Hoàn Kiếm, Đền Ngọc Sơn, Văn Miếu Quốc Tử Giám."},{"day":"Ngày 2: Hà Nội - Vịnh Hạ Long - Ngủ đêm Du thuyền 5 sao","details":"Khởi hành đi Quảng Ninh, lên du thuyền 5 sao khám phá Hang Sửng Sốt, Đảo Titop, chèo Kayak và thưởng thức tiệc hải sản hoàng hôn."},{"day":"Ngày 3: Vịnh Hạ Long - Tràng An - Chùa Bái Đính (Ninh Bình)","details":"Ngắm bình minh trên vịnh, di chuyển về Ninh Bình đi thuyền khám phá quần thể danh thắng Tràng An (Di sản UNESCO)."},{"day":"Ngày 4: Lăng Bác - Chùa Một Cột - TP.HCM","details":"Viếng Lăng Chủ tịch Hồ Chí Minh, thưởng thức phở Hà Nội và ra sân bay Nội Bài bay về TP.HCM."}]', 1),
(4, 'Nha Trang Biển Gọi - VinWonders - Đảo Điệp Sơn - Tắm Bùn Khoáng', 'Bamboo Holidays', 4, 'Bamboo Airways', 'HAN', 'Hà Nội', 'CXR', 'Nha Trang', '3 Ngày 2 Đêm', '2026-11-17', '10:15', '1 giờ 55 phút', 'Airbus A321neo', 4150000, 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=600&h=400&q=80', 'Vé máy bay Bamboo Airways kèm 20kg ký gửi, Khách sạn 4 sao đường Trần Phú, Vé VinWonders, Tắm bùn I-Resort', '[{"day":"Ngày 1: Hà Nội - Cam Ranh - Tháp Bà Ponagar - Tắm bùn I-Resort","details":"Đáp chuyến bay Airbus A321neo đến sân bay Cam Ranh. Tham quan Tháp Bà Ponagar, thư giãn tắm bùn khoáng nóng I-Resort."},{"day":"Ngày 2: Cano Vịnh San Hô - Làng Chài - VinWonders Nha Trang","details":"Sáng đi cano tham quan Vịnh San Hô, dùng bữa trưa hải sản trên bè. Chiều vui chơi không giới hạn tại đảo Hòn Tre - VinWonders."},{"day":"Ngày 3: Chùa Long Sơn - Chợ Đầm - Hà Nội","details":"Viếng Chùa Long Sơn (Tượng Phật Trắng), mua yến sào & hải sản khô tại Chợ Đầm trước khi ra sân bay về Hà Nội."}]', 1),
(5, 'Khám Phá Quốc Đảo Sư Tử Singapore - Gardens By The Bay - Sentosa', 'Vietjet Holidays', 3, 'Singapore Airlines', 'SGN', 'TP. Hồ Chí Minh', 'SIN', 'Singapore', '4 Ngày 3 Đêm', '2026-11-22', '12:30', '2 giờ 05 phút', 'Airbus A350-900', 8990000, 'https://images.unsplash.com/photo-1525625293386-3f8f99389edd?auto=format&fit=crop&w=600&h=400&q=80', 'Vé máy bay khứ hồi Singapore Airlines (Airbus A350), Khách sạn 4 sao trung tâm, Vé Flower Dome, Nhạc nước Wings of Time', '[{"day":"Ngày 1: TP.HCM - Sân bay Changi - Jewel Changi - Merlion Park","details":"Bay cùng Singapore Airlines trên tàu bay Airbus A350-900. Check-in thác nước trong nhà lớn nhất thế giới HSBC Rain Vortex tại Jewel Changi và Công viên Sư tử biển."},{"day":"Ngày 2: Gardens by the Bay - Đảo Sentosa - Universal Studios","details":"Tham quan khu vườn siêu cây Gardens by the Bay, nhà kính Flower Dome. Chiều qua đảo Sentosa chụp hình quả cầu Universal và xem nhạc nước."},{"day":"Ngày 3: Marina Bay Sands - Khu Chinatown - Orchard Road","details":"Viếng Chùa Răng Phật tại Chinatown, mua sắm sầm uất tại đại lộ Orchard Road và ngắm toàn cảnh vịnh Marina về đêm."},{"day":"Ngày 4: Tự do mua sắm - Bay về TP.HCM","details":"Tự do mua sắm miễn thuế tại Changi Airport và đáp chuyến bay về lại TP.HCM."}]', 1),
(6, 'Thiên Đường Giải Trí Thái Lan: Bangkok - Pattaya - Đảo Coral', 'Vietravel', 5, 'Thai Airways', 'SGN', 'TP. Hồ Chí Minh', 'BKK', 'Bangkok (Thái Lan)', '5 Ngày 4 Đêm', '2026-11-19', '14:20', '1 giờ 30 phút', 'Boeing 777-300ER', 6890000, 'https://images.unsplash.com/photo-1508009603885-50cf7c579365?auto=format&fit=crop&w=600&h=400&q=80', 'Vé máy bay khứ hồi Thai Airways (Boeing 777), Khách sạn 4-5 sao, Buffet 86 tầng Baiyoke Sky, Cano Đảo Coral, Massage Thái', '[{"day":"Ngày 1: TP.HCM - Bangkok - Chợ đêm Asiatique","details":"Khởi hành đi Bangkok trên tàu bay Boeing 777-300ER của Thai Airways. Tối dạo chợ đêm Asiatique bên bờ sông Chao Phraya."},{"day":"Ngày 2: Bangkok - Thành phố biển Pattaya - Trân Bảo Phật Sơn","details":"Di chuyển đi Pattaya, tham quan Núi Phật Vàng (Khao Chee Chan), Chợ nổi 4 miền và thưởng thức Alcazar Show."},{"day":"Ngày 3: Đảo San Hô (Coral Island) - Lâu đài Tỷ phú Baan Sukhawadee","details":"Đi tàu cao tốc ra Đảo Coral tắm biển lặn ngắm san hô. Chiều tham quan Lâu đài Tỷ phú và tận hưởng 1 suất Massage Thái cổ truyền."},{"day":"Ngày 4: Bangkok - Buffet 86 tầng Baiyoke Sky - Phật Bốn Mặt","details":"Về lại Bangkok, ăn trưa Buffet quốc tế tại tòa nhà 86 tầng Baiyoke Sky, lễ Phật Bốn Mặt Erawan và mua sắm tại Central World, Big C."},{"day":"Ngày 5: Dạo thuyền sông Chao Phraya - Chùa Thuyền Wat Yannawa - TP.HCM","details":"Đi du thuyền trên sông Chao Phraya, viếng Chùa Thuyền Wat Yannawa trước khi ra sân bay Suvarnabhumi về TP.HCM."}]', 1),
(7, 'Mùa Lá Đỏ Hàn Quốc: Seoul - Đảo Nami - Công Viên Everland', 'Saigontourist', 6, 'Korean Air', 'DAD', 'Đà Nẵng', 'ICN', 'Seoul (Hàn Quốc)', '5 Ngày 4 Đêm', '2026-11-23', '22:50', '4 giờ 35 phút', 'Boeing 787-9 Dreamliner', 13900000, 'https://images.unsplash.com/photo-1517154421773-0529f29ea451?auto=format&fit=crop&w=600&h=400&q=80', 'Vé máy bay Korean Air khứ hồi, Visa Hàn Quốc trọn gói, Khách sạn 4 sao tại Seoul, Vé công viên Everland, Trải nghiệm mặc Hanbok', '[{"day":"Ngày 1: Khởi hành đi Seoul - Đảo Nami lãng mạn","details":"Đáp chuyến bay đêm Korean Air (Boeing 787-9), sáng tới sân bay Incheon. Tham quan Đảo Nami ngập tràn sắc vàng lá ngân hạnh và hàng cây thủy sam."},{"day":"Ngày 2: Cung điện Gyeongbokgung - Làng cổ Bukchon Hanok - Tháp Namsan","details":"Mặc Hanbok truyền thống chụp ảnh tại Cung điện Cảnh Phúc (Gyeongbokgung), tham quan Nhà Xanh, Làng cổ Bukchon và khóa tình yêu trên Tháp N Seoul."},{"day":"Ngày 3: Công viên giải trí Everland - Chợ đêm Myeongdong","details":"Vui chơi trọn ngày tại công viên giải trí lớn nhất Hàn Quốc Everland (vườn thú Safari, tàu lượn T-Express). Tối mua sắm mỹ phẩm tại Myeongdong."},{"day":"Ngày 4: Trung tâm Nhân sâm Chính phủ - Hongdae - Du thuyền sông Hàn","details":"Mua sắm nhân sâm, tinh dầu thông đỏ, trải nghiệm làm Kimchi và du ngoạn sông Hàn lãng mạn."},{"day":"Ngày 5: Siêu thị miễn thuế - Sân bay Incheon - Về Việt Nam","details":"Mua sắm quà lưu niệm tại trung tâm miễn thuế, ra sân bay Incheon đáp chuyến bay về Việt Nam."}]', 1),
(8, 'Cung Đường Vàng Nhật Bản: Tokyo - Núi Phú Sĩ - Làng Cổ Oshino Hakkai', 'Vietjet Holidays', 1, 'VietJet Air', 'SGN', 'TP. Hồ Chí Minh', 'NRT', 'Tokyo (Nhật Bản)', '5 Ngày 4 Đêm', '2026-11-24', '00:15', '5 giờ 35 phút', 'Airbus A330-300', 16990000, 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?auto=format&fit=crop&w=600&h=400&q=80', 'Vé máy bay khứ hồi VietJet Air thân rộng Airbus A330, Khách sạn 4 sao + Tắm Onsen truyền thống, Bò Kobe & Cua Tuyết, Visa Nhật Bản', '[{"day":"Ngày 1: TP.HCM - Sân bay Quốc tế Narita - Chùa cổ Asakusa Kannon","details":"Bay thẳng tới Tokyo trên tàu bay thân rộng Airbus A330-300 của VietJet Air. Tham quan Chùa Asakusa Kannon, chụp hình tháp truyền hình Tokyo Skytree."},{"day":"Ngày 2: Tokyo - Núi Phú Sĩ - Làng cổ Oshino Hakkai - Tắm Onsen","details":"Di chuyển lên Trạm 5 Núi Phú Sĩ, dạo bước ngôi làng cổ Oshino Hakkai dưới chân núi. Tối mặc Yukata tắm suối khoáng nóng Onsen và thưởng thức Cua Tuyết."},{"day":"Ngày 3: Du thuyền Hồ Yamanaka - Mua sắm Gotemba Outlet - Vịnh Odaiba","details":"Ngồi du thuyền thiên nga trên hồ Yamanaka ngắm trọn Núi Phú Sĩ, mua sắm hàng hiệu tại Gotemba Premium Outlets và tham quan Tượng Nữ Thần Tự Do tại vịnh Odaiba."},{"day":"Ngày 4: Hoàng cung Tokyo - Phố điện tử Akihabara - Shibuya Crossing","details":"Tham quan ngoại thành Hoàng cung Tokyo, thưởng thức thịt bò Wagyu thượng hạng, khám phá Akihabara và giao lộ Shibuya đông đúc nhất thế giới."},{"day":"Ngày 5: Đại siêu thị Aeon Mall Narita - Bay về TP.HCM","details":"Mua sắm bánh kẹo Matcha và quà lưu niệm tại Aeon Mall trước khi ra sân bay Narita bay về TP.HCM."}]', 1);

-- ============================================================================
-- 5. DỮ LIỆU MẪU GIỎ HÀNG & ĐƠN ĐẶT CHỖ (CART & BOOKINGS)
-- ============================================================================

INSERT INTO cart_items (
    id, item_type, ref_id, title, subtitle,
    origin_city, destination_city, service_class,
    unit_price, quantity, departure_date, departure_time,
    flight_duration, airline_name, aircraft_type
) VALUES
(1, 'FLIGHT', 1, 'TP. Hồ Chí Minh (SGN) ➔ Hà Nội (HAN)', 'Chuyến bay VJ122 • Khứ hồi', 'TP. Hồ Chí Minh', 'Hà Nội', 'Hạng Phổ Thông', 1190000, 1, '2026-11-15', '07:30', '2 giờ 10 phút', 'VietJet Air', 'Airbus A321neo'),
(2, 'TOUR', 1, 'Thiên Đường Đảo Ngọc Phú Quốc - Grand World - Hòn Thơm', 'Vietjet Holidays • 3 Ngày 2 Đêm', 'TP. Hồ Chí Minh', 'Phú Quốc', 'Tour Trọn Gói', 3890000, 1, '2026-11-16', '08:15', '1 giờ 05 phút', 'VietJet Air', 'Airbus A321neo');

INSERT INTO bookings (
    id, booking_code, customer_name, customer_email, customer_phone,
    customer_note, sender_email, total_amount, items_summary_json, status
) VALUES
(1, 'VJ-20261107-001', 'Nguyễn Văn An', 'khachhang@example.com', '0901234567', 'Yêu cầu ghế ngồi gần cửa sổ', 'minhkhoithan@gmail.com', 5080000, '[{"type":"FLIGHT","title":"TP. Hồ Chí Minh (SGN) -> Hà Nội (HAN)","class":"Hạng Phổ Thông","price":1190000},{"type":"TOUR","title":"Thiên Đường Đảo Ngọc Phú Quốc - Grand World - Hòn Thơm","class":"Tour Trọn Gói","price":3890000}]', 'COMPLETED');
