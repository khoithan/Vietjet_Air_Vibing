-- ============================================================================
-- VIETJET TRAVEL WEBSITE - SEED AIRLINES (SQLite)
-- File: SQLite/02_seed_airlines.sql
-- ============================================================================

INSERT INTO airlines (id, code, name, logo_url, country, description) VALUES
(
    1,
    'VJ',
    'VietJet Air',
    'images/2aOboRAvPCnNF8ux8l12JJoKC6uw9yMZkM5dUYs4.jpg',
    'Việt Nam',
    'Hãng hàng không thế hệ mới hàng đầu Việt Nam & khu vực với mạng bay rộng khắp và chi phí tiết kiệm.'
),
(
    2,
    'VN',
    'Vietnam Airlines',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Vietnam_Airlines_logo.svg/600px-Vietnam_Airlines_logo.svg.png',
    'Việt Nam',
    'Hãng hàng không Quốc gia Việt Nam tiêu chuẩn 4 sao Skytrax.'
),
(
    3,
    'SQ',
    'Singapore Airlines',
    'https://upload.wikimedia.org/wikipedia/en/thumb/6/6b/Singapore_Airlines_Logo_2.svg/600px-Singapore_Airlines_Logo_2.svg.png',
    'Singapore',
    'Hãng hàng không 5 sao hàng đầu thế giới với chất lượng dịch vụ đẳng cấp quốc tế.'
),
(
    4,
    'QH',
    'Bamboo Airways',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Bamboo_Airways_Logo.svg/600px-Bamboo_Airways_Logo.svg.png',
    'Việt Nam',
    'Hãng hàng không hiếu khách với dịch vụ định hướng 5 sao tại Việt Nam.'
),
(
    5,
    'TG',
    'Thai Airways',
    'https://upload.wikimedia.org/wikipedia/en/thumb/5/58/Thai_Airways_Logo.svg/600px-Thai_Airways_Logo.svg.png',
    'Thái Lan',
    'Hãng hàng không Quốc gia Thái Lan kết nối Đông Nam Á và toàn cầu.'
),
(
    6,
    'KE',
    'Korean Air',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8f/Korean_Air_Logo.svg/600px-Korean_Air_Logo.svg.png',
    'Hàn Quốc',
    'Hãng hàng không lớn nhất Hàn Quốc chuyên khai thác các dòng tàu bay thân rộng hiện đại.'
);
