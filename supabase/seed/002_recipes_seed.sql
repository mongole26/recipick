-- ========================================
-- 레시피 데이터 시딩
-- Supabase SQL Editor에서 실행
-- 001_ingredients_seed.sql 실행 후 실행할 것
-- ========================================

-- 임시 함수: 재료명으로 ID 조회
CREATE OR REPLACE FUNCTION temp_get_ingredient_id(ingredient_name text)
RETURNS uuid AS $$
  SELECT id FROM public.ingredients WHERE name = ingredient_name LIMIT 1;
$$ LANGUAGE sql;

-- ========================================
-- 레시피 데이터
-- ========================================

-- 1. 김치찌개
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '김치찌개', '돼지고기와 묵은지로 만드는 깊은 맛의 찌개',
  '[{"step":1,"text":"돼지고기를 한입 크기로 썰어 냄비에 볶는다"},{"step":2,"text":"김치를 넣고 함께 볶다가 물을 붓는다"},{"step":3,"text":"된장과 고추장을 풀고 두부를 넣어 끓인다"},{"step":4,"text":"대파를 넣고 한소끔 더 끓인다"}]',
  25, '쉬움', 2, 'recipick-seed'
);

-- 2. 된장찌개
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '된장찌개', '구수한 된장으로 끓이는 한국인의 소울푸드',
  '[{"step":1,"text":"애호박, 감자, 양파를 깍둑썰기 한다"},{"step":2,"text":"멸치육수에 된장을 풀고 감자를 먼저 넣어 끓인다"},{"step":3,"text":"감자가 익으면 나머지 채소와 두부를 넣는다"},{"step":4,"text":"고추와 대파를 넣고 한소끔 끓인다"}]',
  20, '쉬움', 2, 'recipick-seed'
);

-- 3. 제육볶음
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '제육볶음', '매콤달콤한 돼지고기 볶음, 밥도둑 반찬',
  '[{"step":1,"text":"돼지고기에 고추장, 간장, 설탕, 다진마늘을 넣어 양념한다"},{"step":2,"text":"양파, 대파, 고추를 채 썬다"},{"step":3,"text":"팬에 기름을 두르고 양념한 고기를 센 불에 볶는다"},{"step":4,"text":"채소를 넣고 함께 볶아 완성한다"}]',
  20, '쉬움', 2, 'recipick-seed'
);

-- 4. 계란말이
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '계란말이', '부드럽고 촉촉한 기본 반찬',
  '[{"step":1,"text":"달걀 3개를 풀고 다진 대파, 당근, 소금을 넣어 섞는다"},{"step":2,"text":"팬에 기름을 두르고 약불에서 달걀물을 얇게 붓는다"},{"step":3,"text":"반쯤 익으면 한쪽에서 말아준다"},{"step":4,"text":"과정을 반복하여 두툼하게 만든 후 썰어낸다"}]',
  15, '보통', 2, 'recipick-seed'
);

-- 5. 볶음밥
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '볶음밥', '남은 밥과 재료로 빠르게 만드는 한 끼',
  '[{"step":1,"text":"양파, 당근, 대파를 잘게 다진다"},{"step":2,"text":"팬에 기름을 두르고 달걀을 스크램블한다"},{"step":3,"text":"채소를 넣고 볶다가 밥을 넣는다"},{"step":4,"text":"간장과 참기름으로 간을 하고 달걀과 섞어 완성한다"}]',
  10, '쉬움', 1, 'recipick-seed'
);

-- 6. 잡채
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '잡채', '당면과 다양한 채소로 만드는 명절 요리',
  '[{"step":1,"text":"당면을 삶아 물기를 빼고 참기름을 두른다"},{"step":2,"text":"시금치, 당근, 양파, 버섯, 피망을 각각 볶는다"},{"step":3,"text":"소고기를 간장 양념에 볶는다"},{"step":4,"text":"모든 재료와 당면을 큰 볼에 넣고 간장, 설탕, 참기름으로 버무린다"}]',
  40, '보통', 4, 'recipick-seed'
);

-- 7. 떡볶이
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '떡볶이', '매콤달콤한 국민 간식',
  '[{"step":1,"text":"떡을 물에 불려둔다"},{"step":2,"text":"멸치육수에 고추장, 고춧가루, 간장, 설탕을 넣어 양념장을 만든다"},{"step":3,"text":"양념장이 끓으면 떡과 어묵을 넣고 졸인다"},{"step":4,"text":"대파를 넣고 소스가 걸쭉해질 때까지 끓인다"}]',
  20, '쉬움', 2, 'recipick-seed'
);

-- 8. 소고기미역국
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '소고기미역국', '영양 가득한 생일 국',
  '[{"step":1,"text":"미역을 물에 불려 씻고 먹기 좋게 자른다"},{"step":2,"text":"소고기를 참기름에 볶는다"},{"step":3,"text":"미역을 넣고 함께 볶다가 물을 붓는다"},{"step":4,"text":"간장으로 간을 하고 20분 이상 끓인다"}]',
  35, '쉬움', 2, 'recipick-seed'
);

-- 9. 감자조림
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '감자조림', '달콤짭짤한 밑반찬',
  '[{"step":1,"text":"감자를 깍둑썰기 한다"},{"step":2,"text":"간장, 설탕, 물을 섞어 양념장을 만든다"},{"step":3,"text":"감자를 양념장에 넣고 중불에서 졸인다"},{"step":4,"text":"국물이 거의 졸아들면 참기름과 깨를 뿌린다"}]',
  25, '쉬움', 2, 'recipick-seed'
);

-- 10. 김치볶음밥
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '김치볶음밥', '김치와 밥만 있으면 되는 간단 요리',
  '[{"step":1,"text":"김치를 잘게 썰어 팬에 볶는다"},{"step":2,"text":"돼지고기가 있으면 함께 볶는다"},{"step":3,"text":"밥을 넣고 고춧가루, 참기름을 넣어 볶는다"},{"step":4,"text":"접시에 담고 달걀 프라이를 올린다"}]',
  10, '쉬움', 1, 'recipick-seed'
);

-- 11. 콩나물국
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '콩나물국', '시원하고 깔끔한 국',
  '[{"step":1,"text":"콩나물을 씻어 준비한다"},{"step":2,"text":"물에 콩나물을 넣고 뚜껑을 덮어 센 불에 끓인다"},{"step":3,"text":"끓기 시작하면 중간에 뚜껑을 열지 않고 10분 끓인다"},{"step":4,"text":"다진 마늘, 소금, 대파를 넣고 한소끔 더 끓인다"}]',
  15, '쉬움', 2, 'recipick-seed'
);

-- 12. 오이무침
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '오이무침', '아삭한 새콤달콤 반찬',
  '[{"step":1,"text":"오이를 얇게 어슷썰어 소금에 절인다"},{"step":2,"text":"10분 후 물기를 꼭 짠다"},{"step":3,"text":"고춧가루, 식초, 설탕, 다진마늘, 참기름을 넣어 양념한다"},{"step":4,"text":"깨를 뿌려 완성한다"}]',
  15, '쉬움', 2, 'recipick-seed'
);

-- 13. 카레라이스
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '카레라이스', '온 가족이 좋아하는 든든한 한 끼',
  '[{"step":1,"text":"감자, 당근, 양파를 깍둑썰기 한다"},{"step":2,"text":"고기를 먼저 볶고 채소를 넣어 함께 볶는다"},{"step":3,"text":"물을 붓고 채소가 익을 때까지 끓인다"},{"step":4,"text":"카레가루를 넣고 걸쭉해질 때까지 저으며 끓인다"}]',
  30, '쉬움', 3, 'recipick-seed'
);

-- 14. 순두부찌개
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '순두부찌개', '부드러운 순두부와 매콤한 국물의 조화',
  '[{"step":1,"text":"뚝배기에 참기름을 두르고 다진마늘을 볶는다"},{"step":2,"text":"고춧가루를 넣고 볶다가 물을 붓는다"},{"step":3,"text":"간장, 새우젓으로 간을 하고 순두부를 넣는다"},{"step":4,"text":"끓으면 달걀을 깨 넣고 대파를 올린다"}]',
  15, '쉬움', 1, 'recipick-seed'
);

-- 15. 불고기
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '불고기', '달콤한 양념의 대표 한식',
  '[{"step":1,"text":"소고기를 얇게 썰어 간장, 설탕, 배즙, 다진마늘, 참기름으로 양념한다"},{"step":2,"text":"30분 이상 재워둔다"},{"step":3,"text":"양파, 대파, 버섯을 채 썬다"},{"step":4,"text":"팬에서 센 불에 고기와 채소를 함께 볶는다"}]',
  40, '보통', 3, 'recipick-seed'
);

-- 16. 달걀덮밥
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '달걀덮밥', '5분 완성 초간단 한 끼',
  '[{"step":1,"text":"양파를 채 썰어 간장, 설탕, 물에 끓인다"},{"step":2,"text":"양파가 투명해지면 풀어둔 달걀을 붓는다"},{"step":3,"text":"달걀이 반숙이 되면 불을 끈다"},{"step":4,"text":"밥 위에 올리고 대파를 뿌린다"}]',
  10, '쉬움', 1, 'recipick-seed'
);

-- 17. 시금치나물
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '시금치나물', '고소한 기본 나물 반찬',
  '[{"step":1,"text":"시금치를 끓는 물에 30초 데쳐 찬물에 헹군다"},{"step":2,"text":"물기를 꼭 짠다"},{"step":3,"text":"다진마늘, 간장, 참기름, 깨를 넣어 무친다"},{"step":4,"text":"소금으로 간을 맞춘다"}]',
  10, '쉬움', 2, 'recipick-seed'
);

-- 18. 콩나물불고기
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '콩나물불고기', '콩나물 위에 양념 소고기를 올려 찌는 요리',
  '[{"step":1,"text":"소고기를 간장, 설탕, 다진마늘, 참기름으로 양념한다"},{"step":2,"text":"냄비 바닥에 콩나물을 깔고 양념고기를 올린다"},{"step":3,"text":"뚜껑을 덮고 중불에서 15분 찐다"},{"step":4,"text":"대파, 고추를 올리고 섞어서 낸다"}]',
  25, '쉬움', 2, 'recipick-seed'
);

-- 19. 어묵볶음
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '어묵볶음', '도시락 반찬으로 딱 좋은 간단 요리',
  '[{"step":1,"text":"어묵을 먹기 좋은 크기로 자른다"},{"step":2,"text":"간장, 설탕, 물엿을 섞어 양념장을 만든다"},{"step":3,"text":"팬에 기름을 두르고 어묵을 볶다가 양념장을 넣는다"},{"step":4,"text":"양파, 고추를 넣고 졸여 완성한다"}]',
  15, '쉬움', 2, 'recipick-seed'
);

-- 20. 참치김치찌개
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '참치김치찌개', '참치캔으로 간편하게 끓이는 찌개',
  '[{"step":1,"text":"김치를 먹기 좋게 썰어 팬에 볶는다"},{"step":2,"text":"물을 붓고 끓인다"},{"step":3,"text":"참치캔 기름을 빼고 넣는다"},{"step":4,"text":"두부와 대파를 넣고 한소끔 더 끓인다"}]',
  15, '쉬움', 2, 'recipick-seed'
);

-- 21. 감자채볶음
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '감자채볶음', '아삭한 식감의 밑반찬',
  '[{"step":1,"text":"감자를 채 썰어 찬물에 전분을 빼준다"},{"step":2,"text":"팬에 기름을 두르고 감자채를 볶는다"},{"step":3,"text":"소금, 식초를 넣고 아삭하게 볶는다"},{"step":4,"text":"참기름과 깨를 뿌려 마무리한다"}]',
  15, '쉬움', 2, 'recipick-seed'
);

-- 22. 두부조림
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '두부조림', '양념이 쏙 밴 밥반찬',
  '[{"step":1,"text":"두부를 1cm 두께로 썰어 팬에 노릇하게 굽는다"},{"step":2,"text":"간장, 고춧가루, 설탕, 다진마늘, 물을 섞어 양념장을 만든다"},{"step":3,"text":"두부 위에 양념장을 끼얹고 중불에서 조린다"},{"step":4,"text":"대파를 올리고 국물이 자작해지면 완성"}]',
  20, '쉬움', 2, 'recipick-seed'
);

-- 23. 소불고기덮밥
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '소불고기덮밥', '불고기를 밥 위에 올린 든든한 한 끼',
  '[{"step":1,"text":"소고기를 간장, 설탕, 다진마늘, 참기름으로 양념한다"},{"step":2,"text":"양파와 대파를 채 썬다"},{"step":3,"text":"팬에서 고기와 채소를 함께 볶는다"},{"step":4,"text":"밥 위에 올리고 달걀 프라이를 얹는다"}]',
  20, '보통', 1, 'recipick-seed'
);

-- 24. 미역국
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '미역국', '담백한 기본 미역국',
  '[{"step":1,"text":"미역을 불려 먹기 좋게 자른다"},{"step":2,"text":"참기름에 미역을 볶는다"},{"step":3,"text":"물을 붓고 끓인다"},{"step":4,"text":"간장, 다진마늘로 간을 맞추고 10분 더 끓인다"}]',
  25, '쉬움', 2, 'recipick-seed'
);

-- 25. 스크램블에그
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '스크램블에그', '부드러운 아침 메뉴',
  '[{"step":1,"text":"달걀에 우유, 소금을 넣고 잘 풀어준다"},{"step":2,"text":"팬에 버터를 녹인다"},{"step":3,"text":"약불에서 달걀물을 넣고 천천히 저어준다"},{"step":4,"text":"반숙 상태에서 불을 끄고 후추를 뿌린다"}]',
  5, '쉬움', 1, 'recipick-seed'
);

-- 26. 비빔국수
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '비빔국수', '새콤달콤 매콤한 여름 별미',
  '[{"step":1,"text":"국수를 삶아 찬물에 헹궈 물기를 뺀다"},{"step":2,"text":"고추장, 식초, 설탕, 간장, 참기름으로 양념장을 만든다"},{"step":3,"text":"오이와 당근을 채 썬다"},{"step":4,"text":"국수에 양념장과 채소를 올리고 비벼 먹는다"}]',
  15, '쉬움', 1, 'recipick-seed'
);

-- 27. 부추전
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '부추전', '바삭한 부추 향이 가득한 전',
  '[{"step":1,"text":"부추를 5cm 길이로 자른다"},{"step":2,"text":"밀가루, 전분, 물, 달걀, 소금을 섞어 반죽한다"},{"step":3,"text":"부추를 넣어 섞는다"},{"step":4,"text":"팬에 기름을 두르고 얇게 펴서 양면을 바삭하게 부친다"}]',
  20, '쉬움', 2, 'recipick-seed'
);

-- 28. 오므라이스
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '오므라이스', '케첩볶음밥을 달걀로 감싼 일품요리',
  '[{"step":1,"text":"양파, 당근, 햄을 잘게 다져 볶는다"},{"step":2,"text":"밥을 넣고 케첩으로 볶음밥을 만든다"},{"step":3,"text":"달걀을 얇게 부친다"},{"step":4,"text":"달걀 위에 볶음밥을 올리고 감싸서 접시에 담는다"}]',
  20, '보통', 1, 'recipick-seed'
);

-- 29. 소세지야채볶음
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '소세지야채볶음', '아이들도 좋아하는 간단 반찬',
  '[{"step":1,"text":"소시지를 어슷하게 썬다"},{"step":2,"text":"양파, 피망, 당근을 채 썬다"},{"step":3,"text":"팬에 기름을 두르고 소시지를 볶다가 채소를 넣는다"},{"step":4,"text":"케첩, 간장으로 간을 맞추고 볶아 완성한다"}]',
  10, '쉬움', 2, 'recipick-seed'
);

-- 30. 무생채
INSERT INTO public.recipes (id, title, description, instructions, cook_time, difficulty, servings, source) VALUES (
  gen_random_uuid(), '무생채', '아삭 새콤 매콤한 밑반찬',
  '[{"step":1,"text":"무를 곱게 채 썰어 소금에 살짝 절인다"},{"step":2,"text":"물기를 짠다"},{"step":3,"text":"고춧가루, 식초, 설탕, 다진마늘, 멸치액젓을 넣어 무친다"},{"step":4,"text":"대파와 깨를 넣어 마무리한다"}]',
  15, '쉬움', 2, 'recipick-seed'
);

-- ========================================
-- 레시피-재료 매핑
-- ========================================

-- 김치찌개
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('돼지고기', 200, 'g'), ('두부', 0.5, '개'), ('대파', 1, '단'), ('된장', 15, 'g'), ('고추장', 10, 'g'), ('마늘', 3, '개'), ('고춧가루', 5, 'g')) AS v(name, qty, u)
WHERE r.title = '김치찌개' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 된장찌개
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('두부', 0.5, '개'), ('애호박', 0.5, '개'), ('감자', 1, '개'), ('양파', 0.5, '개'), ('대파', 0.5, '단'), ('고추', 1, '개'), ('된장', 30, 'g'), ('마늘', 2, '개'), ('멸치', 20, 'g')) AS v(name, qty, u)
WHERE r.title = '된장찌개' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 제육볶음
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('돼지고기', 300, 'g'), ('양파', 1, '개'), ('대파', 1, '단'), ('고추', 2, '개'), ('고추장', 30, 'g'), ('간장', 15, 'ml'), ('설탕', 10, 'g'), ('마늘', 3, '개'), ('참기름', 5, 'ml')) AS v(name, qty, u)
WHERE r.title = '제육볶음' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 계란말이
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('달걀', 3, '개'), ('대파', 0.3, '단'), ('당근', 0.3, '개'), ('소금', 2, 'g'), ('식용유', 10, 'ml')) AS v(name, qty, u)
WHERE r.title = '계란말이' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 볶음밥
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('쌀', 200, 'g'), ('달걀', 1, '개'), ('양파', 0.5, '개'), ('당근', 0.3, '개'), ('대파', 0.3, '단'), ('간장', 10, 'ml'), ('참기름', 5, 'ml'), ('식용유', 10, 'ml')) AS v(name, qty, u)
WHERE r.title = '볶음밥' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 잡채
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('당면', 200, 'g'), ('소고기', 100, 'g'), ('시금치', 0.5, '단'), ('당근', 0.5, '개'), ('양파', 1, '개'), ('버섯', 100, 'g'), ('피망', 1, '개'), ('간장', 30, 'ml'), ('설탕', 15, 'g'), ('참기름', 10, 'ml'), ('깨', 5, 'g')) AS v(name, qty, u)
WHERE r.title = '잡채' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 떡볶이
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('떡', 300, 'g'), ('고추장', 30, 'g'), ('고춧가루', 5, 'g'), ('간장', 10, 'ml'), ('설탕', 15, 'g'), ('대파', 0.5, '단'), ('멸치', 20, 'g')) AS v(name, qty, u)
WHERE r.title = '떡볶이' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 소고기미역국
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('소고기', 150, 'g'), ('미역', 30, 'g'), ('참기름', 10, 'ml'), ('간장', 15, 'ml'), ('마늘', 2, '개')) AS v(name, qty, u)
WHERE r.title = '소고기미역국' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 감자조림
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('감자', 3, '개'), ('간장', 30, 'ml'), ('설탕', 15, 'g'), ('참기름', 5, 'ml'), ('깨', 3, 'g')) AS v(name, qty, u)
WHERE r.title = '감자조림' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 김치볶음밥
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('쌀', 200, 'g'), ('돼지고기', 100, 'g'), ('달걀', 1, '개'), ('대파', 0.3, '단'), ('고춧가루', 5, 'g'), ('참기름', 5, 'ml'), ('식용유', 10, 'ml')) AS v(name, qty, u)
WHERE r.title = '김치볶음밥' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 콩나물국
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('콩나물', 200, 'g'), ('대파', 0.3, '단'), ('마늘', 2, '개'), ('소금', 5, 'g')) AS v(name, qty, u)
WHERE r.title = '콩나물국' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 오이무침
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('오이', 2, '개'), ('고춧가루', 10, 'g'), ('식초', 10, 'ml'), ('설탕', 5, 'g'), ('마늘', 2, '개'), ('참기름', 5, 'ml'), ('깨', 3, 'g'), ('소금', 3, 'g')) AS v(name, qty, u)
WHERE r.title = '오이무침' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 카레라이스
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('감자', 2, '개'), ('당근', 1, '개'), ('양파', 1, '개'), ('돼지고기', 200, 'g'), ('카레가루', 40, 'g'), ('식용유', 10, 'ml'), ('쌀', 300, 'g')) AS v(name, qty, u)
WHERE r.title = '카레라이스' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 순두부찌개
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('두부', 1, '개'), ('달걀', 1, '개'), ('대파', 0.3, '단'), ('마늘', 2, '개'), ('고춧가루', 10, 'g'), ('간장', 10, 'ml'), ('참기름', 5, 'ml')) AS v(name, qty, u)
WHERE r.title = '순두부찌개' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 불고기
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('소고기', 400, 'g'), ('양파', 1, '개'), ('대파', 1, '단'), ('버섯', 100, 'g'), ('간장', 40, 'ml'), ('설탕', 20, 'g'), ('배', 0.25, '개'), ('마늘', 3, '개'), ('참기름', 10, 'ml'), ('후추', 2, 'g')) AS v(name, qty, u)
WHERE r.title = '불고기' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 달걀덮밥
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('달걀', 2, '개'), ('양파', 0.5, '개'), ('대파', 0.3, '단'), ('간장', 15, 'ml'), ('설탕', 5, 'g'), ('쌀', 200, 'g')) AS v(name, qty, u)
WHERE r.title = '달걀덮밥' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 시금치나물
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('시금치', 1, '단'), ('마늘', 2, '개'), ('간장', 10, 'ml'), ('참기름', 5, 'ml'), ('깨', 3, 'g'), ('소금', 2, 'g')) AS v(name, qty, u)
WHERE r.title = '시금치나물' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 콩나물불고기
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('소고기', 200, 'g'), ('콩나물', 200, 'g'), ('대파', 0.5, '단'), ('고추', 1, '개'), ('간장', 20, 'ml'), ('설탕', 10, 'g'), ('마늘', 2, '개'), ('참기름', 5, 'ml')) AS v(name, qty, u)
WHERE r.title = '콩나물불고기' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 참치김치찌개
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('참치캔', 1, '개'), ('두부', 0.5, '개'), ('대파', 0.5, '단'), ('마늘', 2, '개'), ('고춧가루', 5, 'g')) AS v(name, qty, u)
WHERE r.title = '참치김치찌개' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 감자채볶음
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('감자', 2, '개'), ('식용유', 15, 'ml'), ('소금', 3, 'g'), ('식초', 5, 'ml'), ('참기름', 5, 'ml'), ('깨', 3, 'g')) AS v(name, qty, u)
WHERE r.title = '감자채볶음' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 두부조림
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('두부', 1, '개'), ('간장', 20, 'ml'), ('고춧가루', 5, 'g'), ('설탕', 5, 'g'), ('마늘', 2, '개'), ('대파', 0.3, '단'), ('식용유', 10, 'ml')) AS v(name, qty, u)
WHERE r.title = '두부조림' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 소불고기덮밥
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('소고기', 200, 'g'), ('양파', 0.5, '개'), ('대파', 0.5, '단'), ('달걀', 1, '개'), ('간장', 20, 'ml'), ('설탕', 10, 'g'), ('마늘', 2, '개'), ('참기름', 5, 'ml'), ('쌀', 200, 'g')) AS v(name, qty, u)
WHERE r.title = '소불고기덮밥' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 미역국
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('미역', 30, 'g'), ('참기름', 10, 'ml'), ('간장', 10, 'ml'), ('마늘', 2, '개')) AS v(name, qty, u)
WHERE r.title = '미역국' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 스크램블에그
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('달걀', 3, '개'), ('우유', 30, 'ml'), ('버터', 10, 'g'), ('소금', 2, 'g'), ('후추', 1, 'g')) AS v(name, qty, u)
WHERE r.title = '스크램블에그' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 비빔국수
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('국수', 200, 'g'), ('오이', 0.5, '개'), ('당근', 0.3, '개'), ('고추장', 20, 'g'), ('식초', 15, 'ml'), ('설탕', 10, 'g'), ('간장', 5, 'ml'), ('참기름', 5, 'ml')) AS v(name, qty, u)
WHERE r.title = '비빔국수' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 부추전
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('부추', 1, '단'), ('밀가루', 100, 'g'), ('전분', 30, 'g'), ('달걀', 1, '개'), ('소금', 3, 'g'), ('식용유', 30, 'ml')) AS v(name, qty, u)
WHERE r.title = '부추전' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 오므라이스
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('쌀', 200, 'g'), ('달걀', 2, '개'), ('양파', 0.5, '개'), ('당근', 0.3, '개'), ('햄', 50, 'g'), ('케첩', 30, 'g'), ('식용유', 10, 'ml')) AS v(name, qty, u)
WHERE r.title = '오므라이스' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 소세지야채볶음
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('소시지', 6, '개'), ('양파', 0.5, '개'), ('피망', 1, '개'), ('당근', 0.3, '개'), ('케첩', 15, 'g'), ('간장', 5, 'ml'), ('식용유', 10, 'ml')) AS v(name, qty, u)
WHERE r.title = '소세지야채볶음' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 무생채
INSERT INTO public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, temp_get_ingredient_id(v.name), v.qty, v.u
FROM public.recipes r,
(VALUES ('무', 0.5, '개'), ('고춧가루', 10, 'g'), ('식초', 10, 'ml'), ('설탕', 5, 'g'), ('마늘', 2, '개'), ('대파', 0.3, '단'), ('깨', 3, 'g')) AS v(name, qty, u)
WHERE r.title = '무생채' AND temp_get_ingredient_id(v.name) IS NOT NULL;

-- 임시 함수 삭제
DROP FUNCTION IF EXISTS temp_get_ingredient_id(text);
