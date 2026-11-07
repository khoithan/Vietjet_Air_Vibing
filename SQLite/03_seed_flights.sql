-- ============================================================================
-- VIETJET TRAVEL WEBSITE - SEED FLIGHTS (SQLite)
-- File: SQLite/03_seed_flights.sql
-- ============================================================================

INSERT INTO flights (
    id, flight_code, airline_id, airline_name,
    origin_code, origin_city, destination_code, destination_city,
    departure_date, return_date, departure_time, arrival_time, duration,
    trip_type, is_direct, aircraft_type,
    price_economy, price_business, services_economy, services_business
) VALUES
-- 1. VietJet Air: TP.HCM -> Hà Nội (Khứ hồi, Bay thẳng, Buổi sáng)
(
    1, 'VJ122', 1, 'VietJet Air',
    'SGN', 'TP. Hồ Chí Minh', 'HAN', 'Hà Nội',
    '2026-11-15', '2026-11-18', '07:30', '09:40', '2 giờ 10 phút',
    'round-trip', 1, 'Airbus A321neo',
    1190000, 3290000,
    '07kg hành lý xách tay, Chọn ghế tiêu chuẩn, Bảo hiểm chuyến bay Sky Care',
    '18kg xách tay + 40kg ký gửi, Phòng chờ sang trọng, Suất ăn nóng miễn phí, Ưu tiên làm thủ tục SkyBoss'
),
-- 2. VietJet Air: TP.HCM -> Đà Nẵng (Một chiều, Bay thẳng, Sáng sớm)
(
    2, 'VJ624', 1, 'VietJet Air',
    'SGN', 'TP. Hồ Chí Minh', 'DAD', 'Đà Nẵng',
    '2026-11-15', NULL, '05:15', '06:35', '1 giờ 20 phút',
    'one-way', 1, 'Airbus A320-200',
    790000, 2450000,
    '07kg hành lý xách tay, Chọn ghế tiêu chuẩn, Bảo hiểm Sky Care',
    '18kg xách tay + 30kg ký gửi, Phòng chờ thương gia, Suất ăn nóng & đồ uống miễn phí, Ưu tiên lên máy bay'
),
-- 3. VietJet Air: Hà Nội -> Phú Quốc (Khứ hồi, Bay thẳng, Buổi chiều)
(
    3, 'VJ453', 1, 'VietJet Air',
    'HAN', 'Hà Nội', 'PQC', 'Phú Quốc',
    '2026-11-16', '2026-11-20', '13:45', '15:55', '2 giờ 10 phút',
    'round-trip', 1, 'Airbus A321neo ACF',
    1450000, 3690000,
    '07kg hành lý xách tay, Nước suối miễn phí, Bảo hiểm Sky Care',
    '18kg xách tay + 40kg ký gửi, Phòng chờ VIP, Suất ăn nóng cao cấp, Xe đưa đón ra tàu bay'
),
-- 4. VietJet Air: TP.HCM -> Tokyo Narita (Khứ hồi, Bay thẳng, Buổi tối, Thân rộng A330)
(
    4, 'VJ822', 1, 'VietJet Air',
    'SGN', 'TP. Hồ Chí Minh', 'NRT', 'Tokyo (Nhật Bản)',
    '2026-11-20', '2026-11-26', '23:10', '06:45', '5 giờ 35 phút',
    'round-trip', 1, 'Airbus A330-300',
    4290000, 9890000,
    '07kg hành lý xách tay, Ghế ngồi êm ái tàu thân rộng, Bảo hiểm quốc tế Sky Care',
    '18kg xách tay + 50kg ký gửi, Ghế giường nằm phẳng SkyBoss Business, Phòng chờ quốc tế 5 sao, Ẩm thực thực đơn riêng'
),
-- 5. Vietnam Airlines: TP.HCM -> Hà Nội (Khứ hồi, Bay thẳng, Buổi sáng)
(
    5, 'VN210', 2, 'Vietnam Airlines',
    'SGN', 'TP. Hồ Chí Minh', 'HAN', 'Hà Nội',
    '2026-11-15', '2026-11-19', '08:00', '10:10', '2 giờ 10 phút',
    'round-trip', 1, 'Boeing 787-9 Dreamliner',
    1790000, 4850000,
    '10kg xách tay + 23kg ký gửi, Suất ăn nhẹ & đồ uống trên không, Giải trí màn hình cá nhân',
    '18kg xách tay + 32kg ký gửi, Ghế thương gia ngả phẳng 180 độ, Phòng chờ Bông Sen Vàng, Ẩm thực 5 sao'
),
-- 6. Vietnam Airlines: Hà Nội -> Đà Nẵng (Một chiều, Bay thẳng, Buổi chiều)
(
    6, 'VN171', 2, 'Vietnam Airlines',
    'HAN', 'Hà Nội', 'DAD', 'Đà Nẵng',
    '2026-11-16', NULL, '15:20', '16:40', '1 giờ 20 phút',
    'one-way', 1, 'Airbus A321-200',
    1250000, 3350000,
    '10kg xách tay + 23kg ký gửi, Nước uống & khăn lạnh, Tích dặm Bông Sen Vàng',
    '18kg xách tay + 32kg ký gửi, Phòng chờ Bông Sen, Quầy thủ tục SkyPriority, Suất ăn nóng'
),
-- 7. Singapore Airlines: TP.HCM -> Singapore (Khứ hồi, Bay thẳng, Buổi trưa/chiều)
(
    7, 'SQ177', 3, 'Singapore Airlines',
    'SGN', 'TP. Hồ Chí Minh', 'SIN', 'Singapore',
    '2026-11-18', '2026-11-22', '12:30', '15:35', '2 giờ 05 phút',
    'round-trip', 1, 'Airbus A350-900',
    2890000, 7450000,
    '07kg xách tay + 25kg ký gửi, Suất ăn quốc tế nóng sốt, Hệ thống giải trí KrisWorld & Wifi',
    '15kg xách tay + 40kg ký gửi, Phòng chờ SilverKris 5 sao, Rượu vang thượng hạng & Thực đơn Book the Cook'
),
-- 8. Singapore Airlines: Hà Nội -> Singapore -> Bali (Nhiều thành phố, Buổi sáng)
(
    8, 'SQ191', 3, 'Singapore Airlines',
    'HAN', 'Hà Nội', 'DPS', 'Bali (Indonesia)',
    '2026-11-19', '2026-11-25', '09:15', '17:45', '7 giờ 30 phút',
    'multi-city', 0, 'Boeing 787-10 Dreamliner',
    5490000, 12900000,
    '07kg xách tay + 30kg ký gửi xuyên suốt, 02 suất ăn nóng quốc tế, Giải trí KrisWorld',
    '15kg xách tay + 40kg ký gửi, Phòng chờ thương gia tại Nội Bài & Changi, Ghế giường phẳng hoàn toàn'
),
-- 9. Bamboo Airways: Hà Nội -> Nha Trang (Một chiều, Bay thẳng, Buổi sáng)
(
    9, 'QH1415', 4, 'Bamboo Airways',
    'HAN', 'Hà Nội', 'CXR', 'Nha Trang',
    '2026-11-15', NULL, '06:45', '08:40', '1 giờ 55 phút',
    'one-way', 1, 'Airbus A321neo',
    1320000, 3590000,
    '07kg xách tay + 20kg ký gửi, Suất ăn nhẹ và nước uống miễn phí',
    '14kg xách tay + 40kg ký gửi, Phòng chờ First Lounge, Ưu tiên hành lý & lối đi riêng'
),
-- 10. Thai Airways: TP.HCM -> Bangkok (Bay thẳng, Buổi tối)
(
    10, 'TG557', 5, 'Thai Airways',
    'SGN', 'TP. Hồ Chí Minh', 'BKK', 'Bangkok (Thái Lan)',
    '2026-11-17', '2026-11-21', '19:15', '20:45', '1 giờ 30 phút',
    'direct', 1, 'Boeing 777-300ER',
    2350000, 5950000,
    '07kg xách tay + 30kg ký gửi, Ẩm thực Thái Lan truyền thống trên máy bay',
    '14kg xách tay + 40kg ký gửi, Phòng chờ Royal Silk Lounge, Ghế thương gia rộng rãi'
),
-- 11. Korean Air: Đà Nẵng -> Seoul Incheon (Khứ hồi, Bay thẳng, Buổi tối)
(
    11, 'KE462', 6, 'Korean Air',
    'DAD', 'Đà Nẵng', 'ICN', 'Seoul (Hàn Quốc)',
    '2026-11-21', '2026-11-26', '22:50', '05:25', '4 giờ 35 phút',
    'round-trip', 1, 'Boeing 787-9 Dreamliner',
    4950000, 11200000,
    '10kg xách tay + 23kg ký gửi, Suất ăn Bibimbap Hàn Quốc, Màn hình giải trí cá nhân',
    '18kg xách tay + 32kg ký gửix2, Phòng chờ Prestige Class, Ghế Prestige Sleeper ngả phẳng'
),
-- 12. VietJet Air: Đà Nẵng -> TP.HCM -> Phú Quốc (Nhiều thành phố, Buổi chiều)
(
    12, 'VJ631', 1, 'VietJet Air',
    'DAD', 'Đà Nẵng', 'PQC', 'Phú Quốc',
    '2026-11-18', NULL, '14:10', '18:05', '3 giờ 55 phút',
    'multi-city', 0, 'Airbus A321-200',
    1680000, 4190000,
    '07kg hành lý xách tay, Hỗ trợ nối chuyến nhanh, Bảo hiểm Sky Care',
    '18kg xách tay + 40kg ký gửi, Phòng chờ VIP tại cả 2 sân bay, Ẩm thực nóng miễn phí'
);
