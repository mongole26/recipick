# Phase 4: RAG 추천 파이프라인 — 구현 계획

## 결정 사항

| 항목 | 결정 |
|------|------|
| LLM | Gemini Flash (무료, 키 이미 있음) |
| 임베딩 | Gemini embedding-001 (768차원, 무료) |
| 배포 | Supabase CLI |
| Edge Function 언어 | TypeScript (Deno) |

---

## 구현 순서

### Task 1: 문서 불일치 수정
- [x] `ARCHITECTURE.md` — LLM을 Claude Haiku → Gemini Flash로 변경, 벡터 차원 1536 → 768
- [x] `AGENTS.md` — AI Agent 규칙의 임베딩/LLM 정보 업데이트
- [x] `docs/generated/db-schema.md` — vector(1536) → vector(768), ivfflat → HNSW
- [x] `supabase/migrations/001_initial_schema.sql` — 실제 DB 상태에 맞게 업데이트

### Task 2: Edge Function `recommend` 생성
- [x] `supabase/functions/recommend/index.ts` 생성
- [x] 요청 파싱: 사용자 재료 목록 (name, quantity, unit) 수신
- [x] 환경변수 설정: GEMINI_API_KEY를 Supabase secrets에 등록

### Task 3: Step ① 재료 매칭 (DB)
- [x] 사용자 재료명 → ingredient_id 변환 (aliases 포함 매칭)
- [x] recipe_ingredients JOIN으로 매칭률 계산
- [x] 매칭률 = (보유 재료 ∩ 필요 재료) / 필요 재료
- [x] 부족한 재료 목록 추출
- [x] 상위 20개 반환

### Task 4: Step ② 벡터 유사도 검색
- [x] 사용자 재료 목록 → 텍스트 조합
- [x] Gemini embedding API 호출 (768차원)
- [x] `match_recipes()` DB 함수로 cosine similarity 검색
- [x] 상위 20개 반환

### Task 5: Step ③ 후보 병합 + 랭킹
- [x] ①과 ②의 결과를 recipe_id 기준으로 병합
- [x] 가중 점수 계산: 매칭률 70% + 벡터 유사도 30%
- [x] 상위 10개 선별
- [x] 레시피 상세 정보 조회 (title, description, cook_time, difficulty, servings, image_url)

### Task 6: Step ④ LLM 보완 (Gemini Flash)
- [x] 프롬프트 작성: 상위 10개 후보 + 사용자 재료 → 최종 3개 선별
- [x] Gemini Flash API 호출
- [x] 응답 JSON 파싱 (추천 이유, 대체 재료 등)
- [x] Fallback: LLM 실패 시 ③단계 상위 3개를 기본 문구와 함께 반환

### Task 7: 응답 조립 + 배포
- [x] 최종 응답 형태 조립 (레시피 정보 + 매칭률 + 부족 재료 + AI 추천 이유)
- [x] Edge Function 배포: `supabase functions deploy recommend`
- [x] 환경변수 배포: `supabase secrets set`

### Task 8: Flutter 클라이언트 연동
- [x] `lib/models/recipe.dart` — 추천 결과 모델 생성
- [x] `lib/data/repositories/recipe_repository.dart` — Edge Function 호출
- [x] `lib/screens/ingredient_input/ingredient_input_screen.dart` — "레시피 추천받기" 버튼 추가
- [ ] 라우팅에 추천 결과 화면 경로 추가 (Phase 5에서 진행)

### Task 9: 통합 테스트
- [x] Edge Function 직접 호출 테스트 (curl) — 정상 동작 확인
- [ ] Flutter에서 재료 입력 → 추천 호출 → 응답 확인 (앱 실행 필요)
- [x] Fallback 동작 확인 (LLM 할당량 초과 시 DB 매칭 결과 반환)

---

## 응답 스펙

### 요청
```json
POST /functions/v1/recommend

{
  "ingredients": [
    {"name": "돼지고기", "quantity": 300, "unit": "g"},
    {"name": "양파", "quantity": 1, "unit": "개"},
    {"name": "대파", "quantity": 1, "unit": "단"}
  ]
}
```

### 응답
```json
{
  "recommendations": [
    {
      "recipe_id": "uuid",
      "title": "제육볶음",
      "description": "매콤달콤한 돼지고기 볶음, 밥도둑 반찬",
      "cook_time": 20,
      "difficulty": "쉬움",
      "servings": 2,
      "image_url": null,
      "match_rate": 0.78,
      "matched_ingredients": ["돼지고기", "양파", "대파"],
      "missing_ingredients": [
        {"name": "고추장", "quantity": 30, "unit": "g"},
        {"name": "간장", "quantity": 15, "unit": "ml"}
      ],
      "ai_reason": "보유한 돼지고기와 양파로 간단하게 만들 수 있어요"
    }
  ]
}
```

---

## 파일 생성 목록

| 파일 | 용도 |
|------|------|
| `supabase/functions/recommend/index.ts` | Edge Function 메인 |
| `lib/models/recipe.dart` | 추천 결과 모델 |
| `lib/data/repositories/recipe_repository.dart` | Edge Function 호출 |

---

## 의존 관계

```
Task 1 (문서 수정) — 독립, 먼저 처리
    ↓
Task 2 (Edge Function 생성) → Task 3 (매칭) → Task 4 (벡터) → Task 5 (랭킹) → Task 6 (LLM) → Task 7 (배포)
    ↓
Task 8 (Flutter 연동) → Task 9 (테스트)
```
