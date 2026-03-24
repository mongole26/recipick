# Recipick Frontend Guide

## 개요

Flutter 기반 모바일 앱의 프론트엔드 구현 규칙과 컨벤션을 정의한다.

---

## 폴더 구조

```
lib/
├── main.dart                    # 진입점
├── app/
│   ├── app.dart                 # MaterialApp, 테마 설정
│   └── routes.dart              # 라우팅 정의
├── config/
│   └── supabase_config.dart     # Supabase 초기화
├── models/                      # 데이터 모델
│   ├── ingredient.dart
│   ├── recipe.dart
│   └── user_fridge.dart
├── data/
│   ├── ingredients_data.dart    # 로컬 재료 데이터
│   └── repositories/            # Supabase 데이터 접근
│       ├── recipe_repository.dart
│       ├── fridge_repository.dart
│       └── auth_repository.dart
├── services/                    # 비즈니스 로직
│   ├── recommendation_service.dart
│   ├── embedding_service.dart
│   └── auth_service.dart
├── screens/                     # 화면 (feature 단위)
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   ├── ingredient_input/
│   │   ├── ingredient_input_screen.dart
│   │   └── widgets/
│   ├── recipe_result/
│   │   ├── recipe_result_screen.dart
│   │   └── widgets/
│   ├── recipe_detail/
│   │   ├── recipe_detail_screen.dart
│   │   └── widgets/
│   └── profile/
│       ├── profile_screen.dart
│       └── widgets/
├── widgets/                     # 공통 위젯
│   └── common/
│       ├── recipick_card.dart
│       ├── recipick_button.dart
│       ├── recipick_chip.dart
│       ├── recipick_input.dart
│       ├── recipick_bottom_sheet.dart
│       └── empty_state.dart
└── utils/
    ├── constants.dart           # 색상, 사이즈 상수
    └── extensions.dart          # Dart 확장 함수
```

---

## 네이밍 규칙

| 대상 | 규칙 | 예시 |
|------|------|------|
| 파일명 | snake_case | `recipe_detail_screen.dart` |
| 클래스 | PascalCase | `RecipeDetailScreen` |
| 변수/함수 | camelCase | `fetchRecipes()` |
| 상수 | camelCase | `primaryColor` |
| private | `_` 접두사 | `_buildCard()` |
| 위젯 파일 | 클래스명과 일치 | `RecipickCard` → `recipick_card.dart` |

---

## 화면 구조 패턴

각 화면(screen)은 다음 구조를 따른다:

```dart
// screens/home/home_screen.dart

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 상태 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(...),
      body: ...,
    );
  }

  // private 빌더 메서드
  Widget _buildSomething() { ... }
}
```

### 원칙
- 한 파일에 하나의 화면 위젯
- 화면 안에서 반복되는 부분은 `_build` 메서드로 분리
- 재사용 가능한 위젯은 `widgets/common/`으로 추출
- 화면 전용 위젯은 `screens/{feature}/widgets/`에 배치

---

## 상태관리

### MVP: setState
프로젝트 규모가 작은 MVP 단계에서는 `setState`로 충분하다.

### 확장 시: Riverpod
화면 간 공유 상태가 늘어나면 Riverpod으로 전환한다.

**전환 시점 기준:**
- 3개 이상의 화면이 같은 상태를 참조할 때
- 서비스 레이어 의존성 주입이 필요할 때

---

## 라우팅

### MVP: Navigator 기본

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const RecipeDetailScreen(id: id)),
);
```

### 확장 시: go_router
딥링크, 웹 URL 지원이 필요할 때 전환한다.

---

## 테마 적용

`utils/constants.dart`에 디자인 토큰을 중앙 관리한다:

```dart
// 색상
const kPrimaryColor = Color(0xFF5F0080);
const kPrimaryLight = Color(0xFFF3E8FF);
const kBackground = Color(0xFFF7F7F7);
const kTextPrimary = Color(0xFF333333);
const kTextSecondary = Color(0xFF666666);
const kTextHint = Color(0xFF999999);
const kBorder = Color(0xFFE0E0E0);
const kInputFill = Color(0xFFF5F5F5);

// 사이즈
const kRadiusCard = 14.0;
const kRadiusButton = 12.0;
const kRadiusChip = 20.0;
const kRadiusInput = 12.0;
const kRadiusBottomSheet = 20.0;

const kButtonHeight = 52.0;
const kPaddingPage = 16.0;
```

화면에서 직접 색상 코드를 쓰지 않고 상수를 참조한다.

---

## 공통 위젯 사용

### RecipickCard
```dart
RecipickCard(
  child: Row(
    children: [
      // 아이콘 영역
      // 텍스트 영역
    ],
  ),
)
```

### RecipickButton
```dart
RecipickButton(
  label: '추가하기',
  onPressed: () { ... },
)
```

### RecipickChip
```dart
RecipickChip(
  label: 'g',
  isSelected: true,
  onTap: () { ... },
)
```

공통 위젯은 `docs/DESIGN.md`의 컴포넌트 스펙을 코드로 구현한 것이다.
디자인 변경 시 공통 위젯만 수정하면 전체 앱에 반영된다.

---

## 로컬 데이터 (비회원)

비회원 사용자의 냉장고 데이터는 `SharedPreferences`에 JSON으로 저장한다:

```json
{
  "fridge": [
    {"name": "양파", "quantity": 2, "unit": "개"},
    {"name": "돼지고기", "quantity": 300, "unit": "g"}
  ]
}
```

로그인 시 이 데이터를 Supabase로 마이그레이션하고 로컬은 삭제한다.

---

## API 호출 패턴

Repository 패턴으로 Supabase 호출을 캡슐화한다:

```dart
class RecipeRepository {
  final SupabaseClient _client;

  RecipeRepository(this._client);

  Future<List<Recipe>> getRecommendations(List<UserIngredient> ingredients) async {
    // Edge Function 호출
    final response = await _client.functions.invoke(
      'recommend',
      body: {'ingredients': ingredients.map((i) => i.toJson()).toList()},
    );
    // 파싱 및 반환
  }
}
```

### 원칙
- 화면에서 Supabase 직접 호출 금지
- Repository를 통해서만 데이터 접근
- 에러 처리는 Repository에서 통일

---

## 성능 가이드

| 항목 | 기준 |
|------|------|
| 빌드 메서드 | 가볍게 유지, 무거운 연산 금지 |
| 리스트 | 10개 이상이면 `ListView.builder` 사용 |
| 이미지 | 캐싱 적용 (`cached_network_image`) |
| 초기 로딩 | 스켈레톤 UI 또는 shimmer |
| 추천 API 호출 | 로딩 인디케이터 필수 (3초 이내 목표) |
