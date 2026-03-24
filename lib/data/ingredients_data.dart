import '../models/ingredient.dart';

/// 카테고리별 단위 목록
const Map<IngredientCategory, List<String>> categoryUnits = {
  IngredientCategory.solid: ['g', 'kg', '근'],
  IngredientCategory.liquid: ['ml', 'L', '컵'],
  IngredientCategory.countable: ['개', 'g', 'kg'],
  IngredientCategory.spice: ['g', '큰술', '작은술', 'ml'],
  IngredientCategory.powder: ['g', 'kg', '큰술', '작은술', '컵'],
  IngredientCategory.sheet: ['장', 'g', 'kg'],
  IngredientCategory.bunch: ['단', '줌', 'g', 'kg'],
};

/// 재료 데이터베이스
const List<IngredientInfo> ingredientDatabase = [
  // 육류
  IngredientInfo(name: '소고기', category: IngredientCategory.solid, keywords: ['쇠고기', '한우', 'beef']),
  IngredientInfo(name: '돼지고기', category: IngredientCategory.solid, keywords: ['돼지', 'pork']),
  IngredientInfo(name: '닭고기', category: IngredientCategory.solid, keywords: ['닭', 'chicken', '치킨']),
  IngredientInfo(name: '닭가슴살', category: IngredientCategory.solid, keywords: ['가슴살', '닭']),
  IngredientInfo(name: '삼겹살', category: IngredientCategory.solid, keywords: ['삼겹', '돼지']),
  IngredientInfo(name: '목살', category: IngredientCategory.solid, keywords: ['돼지', '목']),
  IngredientInfo(name: '갈비', category: IngredientCategory.solid, keywords: ['소갈비', '돼지갈비']),
  IngredientInfo(name: '다짐육', category: IngredientCategory.solid, keywords: ['다진고기', '간고기']),

  // 해산물
  IngredientInfo(name: '연어', category: IngredientCategory.solid, keywords: ['salmon', '생선']),
  IngredientInfo(name: '새우', category: IngredientCategory.countable, keywords: ['shrimp', '해산물']),
  IngredientInfo(name: '오징어', category: IngredientCategory.countable, keywords: ['squid', '해산물']),
  IngredientInfo(name: '고등어', category: IngredientCategory.countable, keywords: ['생선', '등푸른생선']),
  IngredientInfo(name: '참치캔', category: IngredientCategory.countable, keywords: ['참치', '캔', '통조림']),
  IngredientInfo(name: '조개', category: IngredientCategory.solid, keywords: ['바지락', '해산물']),
  IngredientInfo(name: '김', category: IngredientCategory.sheet, keywords: ['해초', '김밥김']),

  // 채소
  IngredientInfo(name: '양파', category: IngredientCategory.countable, keywords: ['onion']),
  IngredientInfo(name: '감자', category: IngredientCategory.countable, keywords: ['potato']),
  IngredientInfo(name: '당근', category: IngredientCategory.countable, keywords: ['carrot']),
  IngredientInfo(name: '대파', category: IngredientCategory.bunch, keywords: ['파', 'green onion']),
  IngredientInfo(name: '마늘', category: IngredientCategory.countable, keywords: ['garlic', '통마늘']),
  IngredientInfo(name: '생강', category: IngredientCategory.solid, keywords: ['ginger']),
  IngredientInfo(name: '고추', category: IngredientCategory.countable, keywords: ['pepper', '청양고추', '풋고추']),
  IngredientInfo(name: '배추', category: IngredientCategory.countable, keywords: ['chinese cabbage', '김장']),
  IngredientInfo(name: '양배추', category: IngredientCategory.countable, keywords: ['cabbage']),
  IngredientInfo(name: '브로콜리', category: IngredientCategory.countable, keywords: ['broccoli']),
  IngredientInfo(name: '시금치', category: IngredientCategory.bunch, keywords: ['spinach', '나물']),
  IngredientInfo(name: '콩나물', category: IngredientCategory.solid, keywords: ['bean sprouts', '나물']),
  IngredientInfo(name: '숙주', category: IngredientCategory.solid, keywords: ['숙주나물']),
  IngredientInfo(name: '버섯', category: IngredientCategory.solid, keywords: ['mushroom', '팽이', '새송이', '표고']),
  IngredientInfo(name: '토마토', category: IngredientCategory.countable, keywords: ['tomato']),
  IngredientInfo(name: '애호박', category: IngredientCategory.countable, keywords: ['호박', 'zucchini']),
  IngredientInfo(name: '피망', category: IngredientCategory.countable, keywords: ['파프리카', 'pepper']),
  IngredientInfo(name: '오이', category: IngredientCategory.countable, keywords: ['cucumber']),
  IngredientInfo(name: '무', category: IngredientCategory.countable, keywords: ['radish', '무우']),
  IngredientInfo(name: '상추', category: IngredientCategory.bunch, keywords: ['lettuce', '쌈']),

  // 과일
  IngredientInfo(name: '사과', category: IngredientCategory.countable, keywords: ['apple']),
  IngredientInfo(name: '바나나', category: IngredientCategory.countable, keywords: ['banana']),
  IngredientInfo(name: '레몬', category: IngredientCategory.countable, keywords: ['lemon']),

  // 달걀/유제품
  IngredientInfo(name: '달걀', category: IngredientCategory.countable, keywords: ['계란', 'egg', '알']),
  IngredientInfo(name: '우유', category: IngredientCategory.liquid, keywords: ['milk']),
  IngredientInfo(name: '버터', category: IngredientCategory.solid, keywords: ['butter']),
  IngredientInfo(name: '치즈', category: IngredientCategory.solid, keywords: ['cheese', '슬라이스치즈']),
  IngredientInfo(name: '생크림', category: IngredientCategory.liquid, keywords: ['cream', '크림']),
  IngredientInfo(name: '요거트', category: IngredientCategory.liquid, keywords: ['yogurt', '요구르트']),

  // 두부/곡류
  IngredientInfo(name: '두부', category: IngredientCategory.countable, keywords: ['tofu']),
  IngredientInfo(name: '쌀', category: IngredientCategory.solid, keywords: ['rice', '백미']),
  IngredientInfo(name: '면', category: IngredientCategory.solid, keywords: ['noodle', '라면', '국수', '파스타']),

  // 양념/소스
  IngredientInfo(name: '간장', category: IngredientCategory.spice, keywords: ['soy sauce', '진간장', '국간장']),
  IngredientInfo(name: '고추장', category: IngredientCategory.spice, keywords: ['gochujang']),
  IngredientInfo(name: '된장', category: IngredientCategory.spice, keywords: ['doenjang', '쌈장']),
  IngredientInfo(name: '식용유', category: IngredientCategory.liquid, keywords: ['oil', '기름']),
  IngredientInfo(name: '참기름', category: IngredientCategory.spice, keywords: ['sesame oil']),
  IngredientInfo(name: '들기름', category: IngredientCategory.spice, keywords: ['perilla oil']),
  IngredientInfo(name: '설탕', category: IngredientCategory.powder, keywords: ['sugar']),
  IngredientInfo(name: '소금', category: IngredientCategory.powder, keywords: ['salt']),
  IngredientInfo(name: '후추', category: IngredientCategory.powder, keywords: ['pepper', '후추가루']),
  IngredientInfo(name: '고춧가루', category: IngredientCategory.powder, keywords: ['chili powder', '고추가루']),
  IngredientInfo(name: '식초', category: IngredientCategory.spice, keywords: ['vinegar']),
  IngredientInfo(name: '맛술', category: IngredientCategory.spice, keywords: ['미림', '미린', 'mirin']),
  IngredientInfo(name: '굴소스', category: IngredientCategory.spice, keywords: ['oyster sauce']),
  IngredientInfo(name: '케첩', category: IngredientCategory.spice, keywords: ['ketchup']),
  IngredientInfo(name: '마요네즈', category: IngredientCategory.spice, keywords: ['mayonnaise', '마요']),
  IngredientInfo(name: '올리브오일', category: IngredientCategory.liquid, keywords: ['olive oil']),

  // 가루류
  IngredientInfo(name: '밀가루', category: IngredientCategory.powder, keywords: ['flour', '박력분', '강력분']),
  IngredientInfo(name: '전분', category: IngredientCategory.powder, keywords: ['starch', '녹말']),
  IngredientInfo(name: '빵가루', category: IngredientCategory.powder, keywords: ['breadcrumbs']),
];

/// 재료 검색
List<IngredientInfo> searchIngredients(String query) {
  if (query.isEmpty) return [];
  final lower = query.toLowerCase();
  return ingredientDatabase.where((info) {
    if (info.name.contains(lower)) return true;
    return info.keywords.any((kw) => kw.contains(lower));
  }).toList();
}

/// 재료명으로 카테고리별 단위 가져오기
List<String> getUnitsForIngredient(String name) {
  final info = ingredientDatabase.where((i) => i.name == name).firstOrNull;
  if (info == null) {
    return ['g', 'kg', 'ml', 'L', '개'];
  }
  return categoryUnits[info.category] ?? ['g', 'kg'];
}
