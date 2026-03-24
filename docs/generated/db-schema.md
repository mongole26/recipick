# Recipick DB Schema

> 자동 생성 문서. 스키마 변경 시 업데이트 필요.
> SQL 원본: `supabase/migrations/001_initial_schema.sql`

---

## ERD

```
ingredients ──────┐
  │                │
  │           recipe_ingredients
  │                │
  │            recipes
  │                │
  │         recipe_embeddings
  │
user_fridge
```

---

## Tables

### ingredients
재료 마스터 데이터.

| 컬럼 | 타입 | 제약 | 설명 |
|-------|------|------|------|
| id | uuid | PK, default gen_random_uuid() | |
| name | text | NOT NULL, UNIQUE | 재료명 |
| category | text | NOT NULL, CHECK | solid/liquid/countable/spice/powder/sheet/bunch |
| default_unit | text | NOT NULL | 기본 단위 |
| aliases | text[] | default '{}' | 동의어 배열 |
| created_at | timestamptz | default now() | |

### recipes
레시피 정보.

| 컬럼 | 타입 | 제약 | 설명 |
|-------|------|------|------|
| id | uuid | PK | |
| title | text | NOT NULL | 레시피 이름 |
| description | text | | 간단 설명 |
| instructions | jsonb | NOT NULL, default '[]' | 조리 순서 |
| cook_time | int | | 조리 시간 (분) |
| difficulty | text | CHECK | 쉬움/보통/어려움 |
| servings | int | default 2 | 인분 |
| image_url | text | | 대표 이미지 URL |
| source | text | | 데이터 출처 |
| created_at | timestamptz | default now() | |

### recipe_ingredients
레시피-재료 매핑 (다대다).

| 컬럼 | 타입 | 제약 | 설명 |
|-------|------|------|------|
| id | uuid | PK | |
| recipe_id | uuid | FK → recipes, NOT NULL | |
| ingredient_id | uuid | FK → ingredients, NOT NULL | |
| quantity | numeric | | 수량 |
| unit | text | | 단위 |
| | | UNIQUE(recipe_id, ingredient_id) | |

### recipe_embeddings
레시피 벡터 임베딩 (RAG 검색용).

| 컬럼 | 타입 | 제약 | 설명 |
|-------|------|------|------|
| id | uuid | PK | |
| recipe_id | uuid | FK → recipes, UNIQUE, NOT NULL | |
| embedding | vector(1536) | NOT NULL | OpenAI embedding |
| content | text | NOT NULL | 임베딩 원본 텍스트 |

### user_fridge
사용자 냉장고 재료.

| 컬럼 | 타입 | 제약 | 설명 |
|-------|------|------|------|
| id | uuid | PK | |
| user_id | uuid | FK → auth.users, nullable | 비회원은 null |
| ingredient_id | uuid | FK → ingredients, NOT NULL | |
| quantity | numeric | NOT NULL | 수량 |
| unit | text | NOT NULL | 단위 |
| added_at | timestamptz | default now() | |

---

## Indexes

| 테이블 | 인덱스 | 타입 |
|--------|--------|------|
| recipe_ingredients | recipe_id | btree |
| recipe_ingredients | ingredient_id | btree |
| user_fridge | user_id | btree |
| recipe_embeddings | embedding | ivfflat (cosine) |

---

## RLS Policies

| 테이블 | 정책 | 규칙 |
|--------|------|------|
| recipes | 공개 읽기 | SELECT: 모든 사용자 |
| ingredients | 공개 읽기 | SELECT: 모든 사용자 |
| recipe_ingredients | 공개 읽기 | SELECT: 모든 사용자 |
| recipe_embeddings | 공개 읽기 | SELECT: 모든 사용자 |
| user_fridge | 본인만 | SELECT/INSERT/UPDATE/DELETE: auth.uid() = user_id |

---

## Functions

### match_recipes(query_embedding, match_threshold, match_count)
벡터 유사도 기반 레시피 검색.

- **입력**: query_embedding (vector 1536), threshold (float, default 0.5), count (int, default 20)
- **출력**: recipe_id (uuid), similarity (float)
- **정렬**: cosine similarity 내림차순
