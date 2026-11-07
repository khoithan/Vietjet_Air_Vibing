-- ============================================================================
-- VIETJET TRAVEL WEBSITE - SEED 8 FEATURED TOURS (SQLite)
-- File: SQLite/04_seed_tours.sql
-- Tất cả hình thumbnail đều chuẩn kích thước 600x400 theo yêu cầu
-- ============================================================================

INSERT INTO tours (
    id, title, travel_agency, airline_id, airline_name,
    origin_code, origin_city, destination_code, destination_city,
    duration_text, departure_date, departure_time, flight_duration,
    aircraft_type, price, thumbnail_url, services, itinerary_json, is_featured
) VALUES
-- TOUR 1: Phú Quốc
(
    1,
    'Thiên Đường Đảo Ngọc Phú Quốc - Grand World - Hòn Thơm',
    'Vietjet Holidays',
    1,
    'VietJet Air',
    'SGN', 'TP. Hồ Chí Minh', 'PQC', 'Phú Quốc',
    '3 Ngày 2 Đêm',
    '2026-11-16',
    '08:15',
    '1 giờ 05 phút',
    'Airbus A321neo',
    3890000,
    'https://images.unsplash.com/photo-1583417319070-4a69db38a482?auto=format&fit=crop&w=600&h=400&q=80',
    'Vé máy bay khứ hồi VietJet Air, Khách sạn Resort 4 sao sát biển, Cáp treo Hòn Thơm, Xe đưa đón VIP, Bảo hiểm du lịch',
    '[{"day":"Ngày 1: TP.HCM - Phú Quốc - Thành phố không ngủ Grand World","details":"06:30 Có mặt tại sân bay Tân Sơn Nhất làm thủ tục chuyến bay VietJet Air (Airbus A321neo) đi Phú Quốc. Trưa nhận phòng Resort 4 sao nghỉ ngơi. Chiều tham quan Dinh Cậu, tối khám phá Grand World, xem nhạc nước Venice."},{"day":"Ngày 2: Cáp treo Hòn Thơm - Cano 4 Đảo - Hoàng hôn Sunset Town","details":"Sáng trải nghiệm cáp treo vượt biển dài nhất thế giới ra Hòn Thơm, tắm biển và lặn ngắm san hô tại Hòn Móng Tay - Hòn Gầm Ghì. Chiều check-in Cầu Hôn (Kiss Bridge) tại Thị trấn Hoàng Hôn."},{"day":"Ngày 3: Chợ Dương Đông - Mua sắm đặc sản - Bay về TP.HCM","details":"Sáng tắm biển tự do, thưởng thức bún quậy Kiến Xây, mua ngọc trai & nước mắm Phú Quốc. Chiều ra sân bay đáp chuyến bay về lại TP.HCM."}]',
    1
),
-- TOUR 2: Đà Nẵng - Hội An - Bà Nà Hills
(
    2,
    'Đà Nẵng - Phố Cổ Hội An - Cầu Vàng Bà Nà Hills',
    'Vietravel',
    1,
    'VietJet Air',
    'HAN', 'Hà Nội', 'DAD', 'Đà Nẵng',
    '4 Ngày 3 Đêm',
    '2026-11-18',
    '07:00',
    '1 giờ 20 phút',
    'Airbus A321neo ACF',
    4590000,
    'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=600&h=400&q=80',
    'Vé máy bay khứ hồi, Khách sạn 4 sao biển Mỹ Khê, Vé cáp treo Bà Nà Hills & Buffet trưa, Hướng dẫn viên suốt tuyến',
    '[{"day":"Ngày 1: Hà Nội - Đà Nẵng - Bán đảo Sơn Trà - Biển Mỹ Khê","details":"Đáp chuyến bay sáng của VietJet Air đến Đà Nẵng. Tham quan Chùa Linh Ứng Bãi Bụt, tắm biển Mỹ Khê và ngắm Cầu Rồng phun lửa về đêm."},{"day":"Ngày 2: Khu du lịch Bà Nà Hills - Cầu Vàng - Làng Pháp","details":"Đi cáp treo lên đỉnh Bà Nà, check-in Cầu Vàng nổi tiếng thế giới, vui chơi tại Fantasy Park và dùng buffet trưa 5 sao."},{"day":"Ngày 3: Rừng dừa Bảy Mẫu - Phố cổ Hội An","details":"Sáng trải nghiệm thuyền thúng Rừng dừa Bảy Mẫu. Chiều dạo bước Phố cổ Hội An, Chùa Cầu, thả đèn hoa đăng trên sông Hoài."},{"day":"Ngày 4: Chợ Hàn - Mua sắm đặc sản - Hà Nội","details":"Mua sắm đặc sản miền Trung tại Chợ Hàn, ra sân bay quốc tế Đà Nẵng bay về Hà Nội."}]',
    1
),
-- TOUR 3: Vịnh Hạ Long - Ninh Bình
(
    3,
    'Du Thuyền 5 Sao Vịnh Hạ Long - Tràng An Ninh Bình - Hà Nội',
    'Saigontourist',
    2,
    'Vietnam Airlines',
    'SGN', 'TP. Hồ Chí Minh', 'HAN', 'Hà Nội - Hạ Long',
    '4 Ngày 3 Đêm',
    '2026-11-20',
    '08:30',
    '2 giờ 10 phút',
    'Boeing 787-9 Dreamliner',
    6490000,
    'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=600&h=400&q=80',
    'Vé máy bay Vietnam Airlines (Boeing 787), 01 đêm Du thuyền 5 sao Hạ Long, 02 đêm khách sạn 4 sao, Ăn uống trọn gói',
    '[{"day":"Ngày 1: TP.HCM - Hà Nội - Phố cổ 36 Phố Phường","details":"Bay từ TP.HCM ra Hà Nội bằng tàu bay thân rộng Boeing 787-9 Dreamliner. Tham quan Hồ Hoàn Kiếm, Đền Ngọc Sơn, Văn Miếu Quốc Tử Giám."},{"day":"Ngày 2: Hà Nội - Vịnh Hạ Long - Ngủ đêm Du thuyền 5 sao","details":"Khởi hành đi Quảng Ninh, lên du thuyền 5 sao khám phá Hang Sửng Sốt, Đảo Titop, chèo Kayak và thưởng thức tiệc hải sản hoàng hôn."},{"day":"Ngày 3: Vịnh Hạ Long - Tràng An - Chùa Bái Đính (Ninh Bình)","details":"Ngắm bình minh trên vịnh, di chuyển về Ninh Bình đi thuyền khám phá quần thể danh thắng Tràng An (Di sản UNESCO)."},{"day":"Ngày 4: Lăng Bác - Chùa Một Cột - TP.HCM","details":"Viếng Lăng Chủ tịch Hồ Chí Minh, thưởng thức phở Hà Nội và ra sân bay Nội Bài bay về TP.HCM."}]',
    1
),
-- TOUR 4: Nha Trang - Vịnh San Hô - VinWonders
(
    4,
    'Nha Trang Biển Gọi - VinWonders - Đảo Điệp Sơn - Tắm Bùn Khoáng',
    'Bamboo Holidays',
    4,
    'Bamboo Airways',
    'HAN', 'Hà Nội', 'CXR', 'Nha Trang',
    '3 Ngày 2 Đêm',
    '2026-11-17',
    '10:15',
    '1 giờ 55 phút',
    'Airbus A321neo',
    4150000,
    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=600&h=400&q=80',
    'Vé máy bay Bamboo Airways kèm 20kg ký gửi, Khách sạn 4 sao đường Trần Phú, Vé VinWonders, Tắm bùn I-Resort',
    '[{"day":"Ngày 1: Hà Nội - Cam Ranh - Tháp Bà Ponagar - Tắm bùn I-Resort","details":"Đáp chuyến bay Airbus A321neo đến sân bay Cam Ranh. Tham quan Tháp Bà Ponagar, thư giãn tắm bùn khoáng nóng I-Resort."},{"day":"Ngày 2: Cano Vịnh San Hô - Làng Chài - VinWonders Nha Trang","details":"Sáng đi cano tham quan Vịnh San Hô, dùng bữa trưa hải sản trên bè. Chiều vui chơi không giới hạn tại đảo Hòn Tre - VinWonders."},{"day":"Ngày 3: Chùa Long Sơn - Chợ Đầm - Hà Nội","details":"Viếng Chùa Long Sơn (Tượng Phật Trắng), mua yến sào & hải sản khô tại Chợ Đầm trước khi ra sân bay về Hà Nội."}]',
    1
),
-- TOUR 5: Singapore - Đảo Sentosa - Gardens by the Bay
(
    5,
    'Khám Phá Quốc Đảo Sư Tử Singapore - Gardens By The Bay - Sentosa',
    'Vietjet Holidays',
    3,
    'Singapore Airlines',
    'SGN', 'TP. Hồ Chí Minh', 'SIN', 'Singapore',
    '4 Ngày 3 Đêm',
    '2026-11-22',
    '12:30',
    '2 giờ 05 phút',
    'Airbus A350-900',
    8990000,
    'https://images.unsplash.com/photo-1525625293386-3f8f99389edd?auto=format&fit=crop&w=600&h=400&q=80',
    'Vé máy bay khứ hồi Singapore Airlines (Airbus A350), Khách sạn 4 sao trung tâm, Vé Flower Dome, Nhạc nước Wings of Time',
    '[{"day":"Ngày 1: TP.HCM - Sân bay Changi - Jewel Changi - Merlion Park","details":"Bay cùng Singapore Airlines trên tàu bay Airbus A350-900. Check-in thác nước trong nhà lớn nhất thế giới HSBC Rain Vortex tại Jewel Changi và Công viên Sư tử biển."},{"day":"Ngày 2: Gardens by the Bay - Đảo Sentosa - Universal Studios","details":"Tham quan khu vườn siêu cây Gardens by the Bay, nhà kính Flower Dome. Chiều qua đảo Sentosa chụp hình quả cầu Universal và xem nhạc nước."},{"day":"Ngày 3: Marina Bay Sands - Khu Chinatown - Orchard Road","details":"Viếng Chùa Răng Phật tại Chinatown, mua sắm sầm uất tại đại lộ Orchard Road và ngắm toàn cảnh vịnh Marina về đêm."},{"day":"Ngày 4: Tự do mua sắm - Bay về TP.HCM","details":"Tự do mua sắm miễn thuế tại Changi Airport và đáp chuyến bay về lại TP.HCM."}]',
    1
),
-- TOUR 6: Bangkok - Pattaya (Thái Lan)
(
    6,
    'Thiên Đường Giải Trí Thái Lan: Bangkok - Pattaya - Đảo Coral',
    'Vietravel',
    5,
    'Thai Airways',
    'SGN', 'TP. Hồ Chí Minh', 'BKK', 'Bangkok (Thái Lan)',
    '5 Ngày 4 Đêm',
    '2026-11-19',
    '14:20',
    '1 giờ 30 phút',
    'Boeing 777-300ER',
    6890000,
    'https://images.unsplash.com/photo-1508009603885-50cf7c579365?auto=format&fit=crop&w=600&h=400&q=80',
    'Vé máy bay khứ hồi Thai Airways (Boeing 777), Khách sạn 4-5 sao, Buffet 86 tầng Baiyoke Sky, Cano Đảo Coral, Massage Thái',
    '[{"day":"Ngày 1: TP.HCM - Bangkok - Chợ đêm Asiatique","details":"Khởi hành đi Bangkok trên tàu bay Boeing 777-300ER của Thai Airways. Tối dạo chợ đêm Asiatique bên bờ sông Chao Phraya."},{"day":"Ngày 2: Bangkok - Thành phố biển Pattaya - Trân Bảo Phật Sơn","details":"Di chuyển đi Pattaya, tham quan Núi Phật Vàng (Khao Chee Chan), Chợ nổi 4 miền và thưởng thức Alcazar Show."},{"day":"Ngày 3: Đảo San Hô (Coral Island) - Lâu đài Tỷ phú Baan Sukhawadee","details":"Đi tàu cao tốc ra Đảo Coral tắm biển lặn ngắm san hô. Chiều tham quan Lâu đài Tỷ phú và tận hưởng 1 suất Massage Thái cổ truyền."},{"day":"Ngày 4: Bangkok - Buffet 86 tầng Baiyoke Sky - Phật Bốn Mặt","details":"Về lại Bangkok, ăn trưa Buffet quốc tế tại tòa nhà 86 tầng Baiyoke Sky, lễ Phật Bốn Mặt Erawan và mua sắm tại Central World, Big C."},{"day":"Ngày 5: Dạo thuyền sông Chao Phraya - Chùa Thuyền Wat Yannawa - TP.HCM","details":"Đi du thuyền trên sông Chao Phraya, viếng Chùa Thuyền Wat Yannawa trước khi ra sân bay Suvarnabhumi về TP.HCM."}]',
    1
),
-- TOUR 7: Seoul - Đảo Nami - Everland (Hàn Quốc)
(
    7,
    'Mùa Lá Đỏ Hàn Quốc: Seoul - Đảo Nami - Công Viên Everland',
    'Saigontourist',
    6,
    'Korean Air',
    'DAD', 'Đà Nẵng', 'ICN', 'Seoul (Hàn Quốc)',
    '5 Ngày 4 Đêm',
    '2026-11-23',
    '22:50',
    '4 giờ 35 phút',
    'Boeing 787-9 Dreamliner',
    13900000,
    'https://images.unsplash.com/photo-1517154421773-0529f29ea451?auto=format&fit=crop&w=600&h=400&q=80',
    'Vé máy bay Korean Air khứ hồi, Visa Hàn Quốc trọn gói, Khách sạn 4 sao tại Seoul, Vé công viên Everland, Trải nghiệm mặc Hanbok',
    '[{"day":"Ngày 1: Khởi hành đi Seoul - Đảo Nami lãng mạn","details":"Đáp chuyến bay đêm Korean Air (Boeing 787-9), sáng tới sân bay Incheon. Tham quan Đảo Nami ngập tràn sắc vàng lá ngân hạnh và hàng cây thủy sam."},{"day":"Ngày 2: Cung điện Gyeongbokgung - Làng cổ Bukchon Hanok - Tháp Namsan","details":"Mặc Hanbok truyền thống chụp ảnh tại Cung điện Cảnh Phúc (Gyeongbokgung), tham quan Nhà Xanh, Làng cổ Bukchon và khóa tình yêu trên Tháp N Seoul."},{"day":"Ngày 3: Công viên giải trí Everland - Chợ đêm Myeongdong","details":"Vui chơi trọn ngày tại công viên giải trí lớn nhất Hàn Quốc Everland (vườn thú Safari, tàu lượn T-Express). Tối mua sắm mỹ phẩm tại Myeongdong."},{"day":"Ngày 4: Trung tâm Nhân sâm Chính phủ - Hongdae - Du thuyền sông Hàn","details":"Mua sắm nhân sâm, tinh dầu thông đỏ, trải nghiệm làm Kimchi và du ngoạn sông Hàn lãng mạn."},{"day":"Ngày 5: Siêu thị miễn thuế - Sân bay Incheon - Về Việt Nam","details":"Mua sắm quà lưu niệm tại trung tâm miễn thuế, ra sân bay Incheon đáp chuyến bay về Việt Nam."}]',
    1
),
-- TOUR 8: Tokyo - Núi Phú Sĩ - Kyoto (Nhật Bản)
(
    8,
    'Cung Đường Vàng Nhật Bản: Tokyo - Núi Phú Sĩ - Làng Cổ Oshino Hakkai',
    'Vietjet Holidays',
    1,
    'VietJet Air',
    'SGN', 'TP. Hồ Chí Minh', 'NRT', 'Tokyo (Nhật Bản)',
    '5 Ngày 4 Đêm',
    '2026-11-24',
    '00:15',
    '5 giờ 35 phút',
    'Airbus A330-300',
    16990000,
    'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?auto=format&fit=crop&w=600&h=400&q=80',
    'Vé máy bay khứ hồi VietJet Air thân rộng Airbus A330, Khách sạn 4 sao + Tắm Onsen truyền thống, Bò Kobe & Cua Tuyết, Visa Nhật Bản',
    '[{"day":"Ngày 1: TP.HCM - Sân bay Quốc tế Narita - Chùa cổ Asakusa Kannon","details":"Bay thẳng tới Tokyo trên tàu bay thân rộng Airbus A330-300 của VietJet Air. Tham quan Chùa Asakusa Kannon, chụp hình tháp truyền hình Tokyo Skytree."},{"day":"Ngày 2: Tokyo - Núi Phú Sĩ - Làng cổ Oshino Hakkai - Tắm Onsen","details":"Di chuyển lên Trạm 5 Núi Phú Sĩ, dạo bước ngôi làng cổ Oshino Hakkai dưới chân núi. Tối mặc Yukata tắm suối khoáng nóng Onsen và thưởng thức Cua Tuyết."},{"day":"Ngày 3: Du thuyền Hồ Yamanaka - Mua sắm Gotemba Outlet - Vịnh Odaiba","details":"Ngồi du thuyền thiên nga trên hồ Yamanaka ngắm trọn Núi Phú Sĩ, mua sắm hàng hiệu tại Gotemba Premium Outlets và tham quan Tượng Nữ Thần Tự Do tại vịnh Odaiba."},{"day":"Ngày 4: Hoàng cung Tokyo - Phố điện tử Akihabara - Shibuya Crossing","details":"Tham quan ngoại thành Hoàng cung Tokyo, thưởng thức thịt bò Wagyu thượng hạng, khám phá Akihabara và giao lộ Shibuya đông đúc nhất thế giới."},{"day":"Ngày 5: Đại siêu thị Aeon Mall Narita - Bay về TP.HCM","details":"Mua sắm bánh kẹo Matcha và quà lưu niệm tại Aeon Mall trước khi ra sân bay Narita bay về TP.HCM."}]',
    1
);
