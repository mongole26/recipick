# Phase 5: 프론트엔드 화면 완성 — 구현 계획

## 구현 순서

### Task 1: 추천 결과 화면
- [x] `lib/screens/recipe_result/recipe_result_screen.dart` 생성
- [x] AppBar: "추천 레시피" 타이틀 + 뒤로가기
- [x] 레시피 카드 3개 (RecipickCard 기반)
  - 레시피 이름 + 설명
  - 조리시간 / 난이도 칩
  - 매칭률 프로그레스바 (색상: 70%↑ 초록, 40%↑ 주황, 나머지 회색)
  - 부족한 재료 목록
  - AI 추천 이유
- [x] 카드 탭 → 레시피 상세 화면으로 이동
- [x] 빈 결과 시 EmptyState 표시

### Task 2: 레시피 상세 화면
- [x] `lib/screens/recipe_detail/recipe_detail_screen.dart` 생성
- [x] RecipeRepository에 `getRecipeDetail(recipeId)` 추가
- [x] 상단 영역: 레시피 이름 + 설명 + 메타 정보 (시간/난이도/인분)
- [x] 매칭 정보 섹션: 매칭률 + AI 추천 이유
- [x] 재료 섹션: 재료 목록 (보유 재료 체크 표시, 부족 재료 경고 표시)
- [x] 조리 순서 섹션: 번호 + 텍스트 (instructions jsonb)

### Task 3: 화면 연결
- [x] ingredient_input_screen: `_showRecommendationDialog()` → `Navigator.push(RecipeResultScreen)` 교체
- [x] recipe_result_screen: 카드 탭 → `Navigator.push(RecipeDetailScreen)`

### Task 4: 로딩/에러 상태
- [x] 추천 버튼: 로딩 중 텍스트 변경 + 비활성화
- [x] 추천 결과 화면: 빈 결과 시 EmptyState
- [x] 레시피 상세 화면: 로딩 중 CircularProgressIndicator
- [x] 레시피 상세 화면: 에러 시 "불러오기 실패" + 재시도 버튼

### Task 5: typecheck + 정리
- [x] `flutter analyze` 에러 0개 확인
- [x] mvp-plan.md Phase 5 완료 표시
- [ ] 커밋 + push

---

## 파일 생성/수정 목록

| 파일 | 작업 |
|------|------|
| `lib/screens/recipe_result/recipe_result_screen.dart` | 신규 ✅ |
| `lib/screens/recipe_detail/recipe_detail_screen.dart` | 신규 ✅ |
| `lib/models/recipe.dart` | 수정 ✅ (RecipeDetail, CookingStep, RecipeIngredientItem 추가) |
| `lib/data/repositories/recipe_repository.dart` | 수정 ✅ (getRecipeDetail 추가) |
| `lib/screens/ingredient_input/ingredient_input_screen.dart` | 수정 ✅ (화면 이동) |
