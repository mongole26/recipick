# Phase 4: RAG 추천 파이프라인 — 리서치 보고서

## 1. 현재 프로젝트 상태

### 완료된 Phase
- **Phase 1:** 프로젝트 구조 정리 완료 (공통 위젯 6개, constants, 라우팅)
- **Phase 2:** Supabase 연동 완료 (스키마, RLS, Flutter 연동)
- **Phase 3:** 데이터 시딩 완료 (재료 80개, 레시피 30개, 임베딩 30개)

### 현재 코드베이스 구조
```
lib/
├── main.dart                    # Supabase 초기화 → RecipickApp 실행
├── app/
│   ├── app.dart                 # MaterialApp + 테마 + 라우팅
│   └── routes.dart              # '/ingredient-input' 경로만 존재
├── config/
│   ├── env.dart                 # supabaseUrl, supabaseAnonKey (gitignore)
│   └── supabase_config.dart     # initSupabase(), supabase getter
├── models/
│   └── ingredient.dart          # IngredientCategory(enum), IngredientInfo, UserIngredient
├── data/
│   └── ingredients_data.dart    # categoryUnits, ingredientDatabase(80개), searchIngredients(), getUnitsForIngredient()
├── screens/
│   └── ingredient_input/
│       └── ingredient_input_screen.dart  # 재료 입력 UI (검색, 바텀시트, 리스트)
├── widgets/common/              # RecipickCard, Button, Chip, Input, BottomSheet, EmptyState
└── utils/
    └── constants.dart           # 색상, 사이즈, 그림자 토큰
```

### 아직 없는 것 (Phase 4에서 만들어야 할 것)
- `lib/models/recipe.dart` — 레시피 모델
- `lib/data/repositories/` — 데이터 접근 레이어
- `lib/services/` — 추천 서비스, 임베딩 서비스
- Supabase Edge Function — `recommend` 엔드포인트
- LLM 프롬프트 파일

---

## 2. DB 스키마 현재 상태

### 테이블 구조

**ingredients** (80개 시딩됨)
| 컬럼 | 타입 | 비고 |
|-------|------|------|
| id | uuid | PK |
| name | text | UNIQUE, NOT NULL |
| category | text | CHECK: solid/liquid/countable/spice/powder/sheet/bunch |
| default_unit | text | NOT NULL |
| aliases | text[] | 동의어 배열 |
| created_at | timestamptz | |

**recipes** (30개 시딩됨)
| 컬럼 | 타입 | 비고 |
|-------|------|------|
| id | uuid | PK |
| title | text | NOT NULL |
| description | text | |
| instructions | jsonb | `[{"step":1,"text":"..."}]` 형태 |
| cook_time | int | 분 단위 |
| difficulty | text | CHECK: 쉬움/보통/어려움 |
| servings | int | default 2 |
| image_url | text | 현재 NULL (이미지 없음) |
| source | text | 'recipick-seed' |
| created_at | timestamptz | |

**recipe_ingredients** (레시피당 평균 6~8개 매핑)
| 컬럼 | 타입 | 비고 |
|-------|------|------|
| id | uuid | PK |
| recipe_id | uuid | FK → recipes |
| ingredient_id | uuid | FK → ingredients |
| quantity | numeric | |
| unit | text | |
| | | UNIQUE(recipe_id, ingredient_id) |

**recipe_embeddings** (30개, Gemini 768차원)
| 컬럼 | 타입 | 비고 |
|-------|------|------|
| id | uuid | PK |
| recipe_id | uuid | FK → recipes, UNIQUE |
| embedding | vector(768) | HNSW 인덱스 (사용자가 직접 변경함) |
| content | text | 임베딩 원본 텍스트 |

> **주의:** `001_initial_schema.sql`에는 vector(1536)과 ivfflat 인덱스로 작성되어 있으나,
> 실제 DB는 Gemini 전환 후 **vector(768) + HNSW 인덱스**로 변경된 상태.
> `match_recipes()` 함수도 768차원으로 업데이트됨.

### DB 함수

**match_recipes(query_embedding, match_threshold, match_count)**
- 입력: vector(768), threshold(0.5), count(20)
- 출력: recipe_id, similarity
- 정렬: cosine similarity 내림차순

### RLS 정책
- recipes, ingredients, recipe_ingredients, recipe_embeddings: **공개 읽기**
- user_fridge: **auth.uid() = user_id** (본인만)

---

## 3. RAG 파이프라인 설계 분석 (ARCHITECTURE.md 기반)

### 전체 흐름
```
사용자 재료 입력
    ↓
① 재료 매칭 (DB JOIN)
   - user가 가진 재료로 recipe_ingredients 매칭
   - 매칭률 = (보유 재료 ∩ 필요 재료) / 필요 재료
   - 상위 20개
    ↓
② 벡터 유사도 검색 (pgvector)
   - 재료 목록 → 텍스트 → Gemini 임베딩
   - recipe_embeddings에서 cosine similarity
   - 상위 20개
    ↓
③ 후보 병합 + 랭킹
   - ①과 ②의 결과 합산
   - 가중치: 매칭률 70% + 벡터 유사도 30%
   - 상위 10개
    ↓
④ LLM 보완 (Claude Haiku 4.5)
   - 상위 10개 + 사용자 재료 → 프롬프트
   - 최종 3개 선별 + 추천 이유
   - 부족 재료, 대체 재료 안내
    ↓
결과: 레시피 3개 반환
```

### 구현 방식 결정 사항

**Edge Function vs Flutter 직접 호출:**
- ARCHITECTURE.md에는 Edge Function으로 설계되어 있음
- Edge Function: TypeScript, Supabase에서 실행, API 키 서버에 보관
- **결론: Edge Function이 맞음** — API 키를 클라이언트에 노출하지 않기 위해

**임베딩 모델:**
- 원래 계획: OpenAI text-embedding-3-small (1536차원)
- **실제 변경: Gemini gemini-embedding-001 (768차원, 무료)**
- DB도 768차원으로 변경 완료

**LLM:**
- Claude Haiku 4.5 (ARCHITECTURE.md 확정)
- Anthropic API 키 필요 (아직 미설정)

---

## 4. 기술적 고려사항

### 4.1 Edge Function 구조

Supabase Edge Function은 Deno + TypeScript로 작성.
`supabase/functions/recommend/index.ts`에 위치해야 함.

**요청 형태 (예상):**
```json
{
  "ingredients": [
    {"name": "돼지고기", "quantity": 300, "unit": "g"},
    {"name": "양파", "quantity": 1, "unit": "개"},
    {"name": "대파", "quantity": 1, "unit": "단"}
  ]
}
```

**응답 형태 (예상):**
```json
{
  "recommendations": [
    {
      "recipe_id": "uuid",
      "title": "제육볶음",
      "description": "...",
      "cook_time": 20,
      "difficulty": "쉬움",
      "servings": 2,
      "image_url": null,
      "match_rate": 0.78,
      "missing_ingredients": [{"name": "고추장", "quantity": 30, "unit": "g"}],
      "ai_reason": "보유한 돼지고기와 양파로 간단하게 만들 수 있어요"
    }
  ]
}
```

### 4.2 Step ① 재료 매칭 쿼리

매칭률 계산을 위한 SQL:
```sql
-- 각 레시피별 매칭률 계산
SELECT
  r.id AS recipe_id,
  r.title,
  COUNT(CASE WHEN ri.ingredient_id IN (사용자_재료_id_목록) THEN 1 END)::float
    / COUNT(ri.ingredient_id)::float AS match_rate,
  COUNT(ri.ingredient_id) AS total_ingredients,
  COUNT(CASE WHEN ri.ingredient_id IN (사용자_재료_id_목록) THEN 1 END) AS matched_count
FROM recipes r
JOIN recipe_ingredients ri ON r.id = ri.recipe_id
GROUP BY r.id, r.title
ORDER BY match_rate DESC
LIMIT 20;
```

**문제: 사용자 재료명 → ingredient_id 변환 필요**
- 사용자는 이름으로 입력하지만 DB는 UUID 기반
- Edge Function에서 먼저 이름 → ID 매핑 수행해야 함
- `aliases` 배열도 고려해야 함 (예: "계란" → "달걀")

### 4.3 Step ② 벡터 검색

사용자 재료 목록을 텍스트로 조합 → Gemini 임베딩 → `match_recipes()` 호출

**임베딩 텍스트 형식:**
```
"돼지고기 양파 대파 고추장"
```

**match_recipes() 호출:**
```sql
SELECT * FROM match_recipes(
  '[0.1, 0.2, ...]'::vector(768),
  0.3,  -- threshold (낮출 수 있음, 레시피 30개밖에 없으므로)
  20
);
```

### 4.4 Step ③ 랭킹

두 결과를 합치고 가중 점수 계산:
```
final_score = 0.7 * match_rate + 0.3 * vector_similarity
```

- 같은 recipe_id가 양쪽에 있으면 합산
- 한쪽에만 있으면 없는 쪽은 0으로 처리

### 4.5 Step ④ LLM 호출

**Claude Haiku 프롬프트 구조:**
```
시스템: 당신은 한국 요리 전문가입니다. 사용자의 냉장고 재료를 기반으로 레시피를 추천합니다.

사용자:
[보유 재료]
- 돼지고기 300g
- 양파 1개
- 대파 1단

[추천 후보 레시피]
1. 제육볶음 (매칭률 78%) - 필요: 돼지고기, 양파, 대파, 고추장, 간장, 설탕, 마늘, 참기름
2. 김치찌개 (매칭률 40%) - 필요: 돼지고기, 두부, 대파, 된장, 고추장, 마늘, 고춧가루
...

위 후보 중 가장 적합한 3개를 골라 JSON으로 답해주세요.
```

### 4.6 Fallback

- LLM 호출 실패 시: ③단계 랭킹 결과 상위 3개를 그대로 반환
- ai_reason은 "매칭률이 높은 레시피입니다" 같은 기본 문구

### 4.7 Flutter 클라이언트 측

현재 Flutter에는 추천 서비스가 없음. 필요한 것:
- `lib/models/recipe.dart` — 추천 결과를 담을 모델
- `lib/data/repositories/recipe_repository.dart` — Edge Function 호출
- `lib/services/recommendation_service.dart` — 추천 로직 조율 (또는 Edge Function에 위임)

**고려사항:**
- 사용자 재료는 현재 `_ingredients` (로컬 state)에만 있음
- Edge Function에 재료 목록을 JSON으로 POST
- 응답을 파싱하여 추천 결과 화면에 전달

---

## 5. 의존성 및 필요 리소스

### API 키 (아직 미설정)
| API | 키 상태 | 용도 |
|-----|---------|------|
| Gemini Embedding | ✅ 있음 | 벡터 검색용 임베딩 |
| Claude (Anthropic) | ❌ 없음 | LLM 추천 보완 |

> **중요:** Claude API 키가 필요함. Anthropic 콘솔에서 발급 필요.
> 또는 무료 대안으로 Gemini LLM 사용 가능 (이미 키 있음).

### Supabase Edge Function 배포
- Supabase CLI (`supabase`) 설치 필요
- 또는 대시보드에서 직접 생성 가능
- Edge Function 내에서 환경변수로 API 키 관리

### 패키지 (Flutter 측)
- 현재 `supabase_flutter`, `http` 패키지 있음
- Edge Function 호출은 `supabase.functions.invoke()` 사용 가능
- 추가 패키지 불필요

---

## 6. 발견된 불일치 및 수정 필요 사항

### 6.1 SQL 스키마 파일 vs 실제 DB
- `001_initial_schema.sql`: vector(1536), ivfflat 인덱스
- **실제 DB**: vector(768), HNSW 인덱스
- **해야 할 것:** 마이그레이션 SQL 파일을 실제 상태에 맞게 업데이트하거나 별도 마이그레이션 추가

### 6.2 ARCHITECTURE.md 임베딩 정보
- ✅ 이미 Gemini로 업데이트됨
- 단, vector 차원 정보(768)가 데이터 모델 테이블에 아직 1536으로 기재
- `docs/generated/db-schema.md`도 1536으로 되어 있음

### 6.3 AGENTS.md AI Agent 규칙
- "임베딩: OpenAI text-embedding-3-small (1536차원)"으로 되어 있음
- Gemini gemini-embedding-001 (768차원)으로 업데이트 필요

### 6.4 LLM 선택
- ARCHITECTURE.md: Claude Haiku 4.5
- **문제:** Anthropic API도 유료. 사용자가 무료를 선호함
- **대안:** Gemini Flash를 LLM으로 사용 (이미 키 있음, 무료 티어)

---

## 7. 결론 및 다음 단계

Phase 4 구현을 위해 필요한 결정:
1. **LLM 선택:** Claude Haiku (유료) vs Gemini Flash (무료, 키 이미 있음)
2. **Edge Function 배포 방식:** Supabase CLI vs 대시보드 직접
3. **스키마 불일치 수정 범위**

이 결정들이 나오면 `plan.md` 작성으로 넘어간다.
