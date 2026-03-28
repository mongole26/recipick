# Phase 5: 프론트엔드 화면 완성 — 리서치 보고서

## 현재 상태 요약

| 항목 | 상태 | 비고 |
|------|------|------|
| 공통 위젯 6개 | ✅ | Card, Button, Chip, Input, BottomSheet, EmptyState |
| 디자인 토큰 | ✅ | constants.dart에 색상/사이즈/그림자 정의 |
| 재료 입력 화면 | ✅ | 검색, 자동완성, 단위 선택, 추천 버튼 |
| 추천 결과 화면 | 🔲 | 현재 AlertDialog 임시 표시 |
| 레시피 상세 화면 | 🔲 | 없음 |
| 라우팅 | 부분 | `/ingredient-input`만 정의 |

---

## 구현이 필요한 화면

### 1. 추천 결과 화면 (RecipeResultScreen)

**데이터 소스:** `List<RecipeRecommendation>` (ingredient_input_screen에서 전달)

**표시할 정보 (product-specs 카드 스펙):**
- 레시피 이름 (title)
- 대표 이미지 (image_url, 현재 null → 기본 이미지 필요)
- 조리 시간 (cookTime + "분") + 난이도 (difficulty)
- 매칭률 프로그레스바 (matchPercent%)
- 부족한 재료 목록 (missingIngredients)
- AI 추천 이유 (aiReason)

**사용 가능한 위젯:**
- RecipickCard — 각 레시피 카드 컨테이너
- EmptyState — 추천 결과 없을 때

**필요한 신규 위젯:**
- 매칭률 프로그레스바 (LinearProgressIndicator 커스텀)

### 2. 레시피 상세 화면 (RecipeDetailScreen)

**데이터 소스:** Supabase에서 recipe_id로 상세 조회 필요
- recipes 테이블: title, description, instructions, cook_time, difficulty, servings
- recipe_ingredients + ingredients JOIN: 재료 목록

**표시할 정보:**
- 레시피 이름 + 설명
- 조리 시간 / 난이도 / 인분
- 매칭률 + AI 추천 이유 (결과 화면에서 전달)
- 재료 목록 (보유/부족 구분 표시)
- 조리 순서 (instructions jsonb의 step/text)

**필요한 추가 작업:**
- RecipeRepository에 `getRecipeDetail(recipeId)` 메서드 추가

### 3. 로딩 상태

**현재:** 버튼 텍스트만 "추천 중..."으로 변경
**개선:** 추천 결과 화면으로 먼저 이동 → 화면 내에서 로딩 표시

### 4. 에러 상태

**현재:** SnackBar로 에러 메시지
**유지:** MVP에서는 SnackBar 충분, 추천 결과 0건일 때 EmptyState

---

## 기존 코드 수정 사항

### ingredient_input_screen.dart
- `_showRecommendationDialog()` 제거 → `Navigator.push(RecipeResultScreen)` 으로 교체
- `_onRecommendPressed()` 수정: 성공 시 화면 이동

### routes.dart
- 추천 결과 / 상세 라우트 추가 (Navigator.push로 데이터 전달하므로 named route 불필요)

---

## 디자인 토큰 활용

| 화면 요소 | 사용할 토큰 |
|-----------|-------------|
| 카드 컨테이너 | RecipickCard (14px radius, kCardShadow) |
| 매칭률 바 배경 | kInputFill (#F5F5F5) |
| 매칭률 바 채움 | kSuccess (#4CAF50) 높음 / kWarning (#FFA726) 중간 |
| 부족 재료 텍스트 | kWarning |
| AI 추천 이유 | kTextSecondary (#666666) |
| 조리 순서 번호 | kPrimaryColor (#5F0080) |
