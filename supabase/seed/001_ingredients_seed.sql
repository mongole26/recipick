-- ========================================
-- 재료 마스터 데이터 시딩
-- Supabase SQL Editor에서 실행
-- ========================================

INSERT INTO public.ingredients (name, category, default_unit, aliases) VALUES
-- 육류
('소고기', 'solid', 'g', ARRAY['쇠고기', '한우', 'beef']),
('돼지고기', 'solid', 'g', ARRAY['돼지', 'pork']),
('닭고기', 'solid', 'g', ARRAY['닭', 'chicken', '치킨']),
('닭가슴살', 'solid', 'g', ARRAY['가슴살']),
('삼겹살', 'solid', 'g', ARRAY['삼겹']),
('목살', 'solid', 'g', ARRAY['돼지목살']),
('갈비', 'solid', 'g', ARRAY['소갈비', '돼지갈비']),
('다짐육', 'solid', 'g', ARRAY['다진고기', '간고기']),
('베이컨', 'solid', 'g', ARRAY['bacon']),
('소시지', 'countable', '개', ARRAY['sausage', '비엔나']),
('햄', 'solid', 'g', ARRAY['ham']),

-- 해산물
('연어', 'solid', 'g', ARRAY['salmon', '생연어']),
('새우', 'countable', '개', ARRAY['shrimp', '대하']),
('오징어', 'countable', '개', ARRAY['squid']),
('고등어', 'countable', '개', ARRAY['생선']),
('참치캔', 'countable', '개', ARRAY['참치', '통조림']),
('조개', 'solid', 'g', ARRAY['바지락', '모시조개']),
('김', 'sheet', '장', ARRAY['해초', '김밥김', '구운김']),
('멸치', 'solid', 'g', ARRAY['anchovy', '국물멸치']),
('미역', 'solid', 'g', ARRAY['seaweed', '건미역']),

-- 채소
('양파', 'countable', '개', ARRAY['onion']),
('감자', 'countable', '개', ARRAY['potato']),
('당근', 'countable', '개', ARRAY['carrot']),
('대파', 'bunch', '단', ARRAY['파', 'green onion']),
('마늘', 'countable', '개', ARRAY['garlic', '통마늘', '다진마늘']),
('생강', 'solid', 'g', ARRAY['ginger']),
('고추', 'countable', '개', ARRAY['청양고추', '풋고추', '홍고추']),
('배추', 'countable', '개', ARRAY['chinese cabbage']),
('양배추', 'countable', '개', ARRAY['cabbage']),
('브로콜리', 'countable', '개', ARRAY['broccoli']),
('시금치', 'bunch', '단', ARRAY['spinach']),
('콩나물', 'solid', 'g', ARRAY['bean sprouts']),
('숙주', 'solid', 'g', ARRAY['숙주나물']),
('버섯', 'solid', 'g', ARRAY['mushroom', '팽이버섯', '새송이버섯', '표고버섯']),
('토마토', 'countable', '개', ARRAY['tomato', '방울토마토']),
('애호박', 'countable', '개', ARRAY['호박', 'zucchini']),
('피망', 'countable', '개', ARRAY['파프리카', 'pepper', '빨간피망']),
('오이', 'countable', '개', ARRAY['cucumber']),
('무', 'countable', '개', ARRAY['radish', '무우']),
('상추', 'bunch', '단', ARRAY['lettuce', '쌈채소']),
('깻잎', 'countable', '개', ARRAY['perilla leaf']),
('부추', 'bunch', '단', ARRAY['chive', '정구지']),
('쪽파', 'bunch', '단', ARRAY['chive', '실파']),

-- 과일
('사과', 'countable', '개', ARRAY['apple']),
('레몬', 'countable', '개', ARRAY['lemon', '레몬즙']),
('배', 'countable', '개', ARRAY['pear']),

-- 달걀/유제품
('달걀', 'countable', '개', ARRAY['계란', 'egg', '알']),
('우유', 'liquid', 'ml', ARRAY['milk']),
('버터', 'solid', 'g', ARRAY['butter']),
('치즈', 'solid', 'g', ARRAY['cheese', '슬라이스치즈', '모짜렐라']),
('생크림', 'liquid', 'ml', ARRAY['cream', '크림']),

-- 두부/곡류
('두부', 'countable', '개', ARRAY['tofu']),
('쌀', 'solid', 'g', ARRAY['rice', '백미', '밥']),
('라면', 'countable', '개', ARRAY['ramen', '라면사리']),
('국수', 'solid', 'g', ARRAY['noodle', '소면']),
('떡', 'solid', 'g', ARRAY['rice cake', '떡볶이떡', '가래떡']),
('당면', 'solid', 'g', ARRAY['glass noodle', '잡채면']),
('스파게티면', 'solid', 'g', ARRAY['pasta', '파스타면']),
('식빵', 'countable', '개', ARRAY['bread', '토스트']),

-- 양념/소스
('간장', 'spice', 'ml', ARRAY['soy sauce', '진간장', '국간장']),
('고추장', 'spice', 'g', ARRAY['gochujang']),
('된장', 'spice', 'g', ARRAY['doenjang', '쌈장']),
('식용유', 'liquid', 'ml', ARRAY['oil', '기름', '식물유']),
('참기름', 'spice', 'ml', ARRAY['sesame oil']),
('들기름', 'spice', 'ml', ARRAY['perilla oil']),
('설탕', 'powder', 'g', ARRAY['sugar']),
('소금', 'powder', 'g', ARRAY['salt']),
('후추', 'powder', 'g', ARRAY['pepper', '후추가루', '흑후추']),
('고춧가루', 'powder', 'g', ARRAY['chili powder', '고추가루']),
('식초', 'spice', 'ml', ARRAY['vinegar']),
('맛술', 'spice', 'ml', ARRAY['미림', '미린', 'mirin']),
('굴소스', 'spice', 'ml', ARRAY['oyster sauce']),
('케첩', 'spice', 'g', ARRAY['ketchup']),
('마요네즈', 'spice', 'g', ARRAY['mayonnaise', '마요']),
('올리브오일', 'liquid', 'ml', ARRAY['olive oil']),
('물엿', 'spice', 'ml', ARRAY['corn syrup', '올리고당']),
('다시다', 'powder', 'g', ARRAY['beef stock', '쇠고기다시다']),
('깨', 'powder', 'g', ARRAY['sesame', '참깨', '통깨']),

-- 가루류
('밀가루', 'powder', 'g', ARRAY['flour', '박력분', '강력분', '중력분']),
('전분', 'powder', 'g', ARRAY['starch', '녹말', '감자전분']),
('빵가루', 'powder', 'g', ARRAY['breadcrumbs', '빵가루']),
('카레가루', 'powder', 'g', ARRAY['curry powder', '카레'])

ON CONFLICT (name) DO NOTHING;
