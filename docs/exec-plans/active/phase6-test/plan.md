# Phase 6: 통합 테스트 + 마무리 — 구현 계획

## 구현 순서

### Task 1: 모델 단위 테스트
- [x] RecipeRecommendation.fromJson 파싱 테스트
- [x] MissingIngredient.displayText 포맷 테스트
- [x] RecipeDetail 관련 모델 테스트
- [x] CookingStep.fromJson 파싱 테스트
- [x] matchPercent 계산 테스트

### Task 2: 재료 데이터 테스트
- [x] searchIngredients 검색 테스트 (이름, 키워드, 빈 쿼리)
- [x] getUnitsForIngredient 단위 반환 테스트

### Task 3: Edge Function 통합 테스트
- [x] curl로 정상 요청 테스트 — 3개 추천 반환 확인
- [x] curl로 빈 재료 요청 테스트 — 에러 메시지 확인
- [x] 응답 시간 측정 — 2.7초 (3초 이내 목표 달성)

### Task 4: 엣지 케이스 확인
- [x] 재료 0개에서 추천 버튼 미노출 (코드 확인)
- [x] 추천 0건 시 EmptyState (코드 확인)
- [x] 상세 화면 로딩 실패 시 재시도 (코드 확인)

### Task 5: 코드 정리 + 린트
- [x] flutter analyze 에러 0개
- [x] 불필요한 import 없음
- [x] mvp-plan.md 최종 업데이트
- [x] 커밋 + push
