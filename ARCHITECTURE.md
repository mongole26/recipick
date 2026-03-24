# Recipick Architecture

## Overview

냉장고에 남은 재료를 입력하면 만들 수 있는 레시피를 추천해주는 앱.
RAG(Retrieval-Augmented Generation) 기반으로 레시피 DB 매칭 + LLM 보완 추천을 제공한다.

---

## Tech Stack

| 레이어 | 기술 | 비고 |
|--------|------|------|
| **클라이언트** | Flutter | 모바일 우선 (iOS/Android) → 추후 웹 확장 |
| **백엔드** | Supabase Cloud | Auth, DB, Edge Functions, Storage |
| **데이터베이스** | PostgreSQL + pgvector | 관계형 데이터 + 벡터 검색 통합 |
| **임베딩** | OpenAI `text-embedding-3-small` | 한국어 성능 양호, 비용 효율적 |
| **LLM** | Claude Haiku 4.5 | 한국어 요리 맥락 이해, 빠른 응답, 저비용 |
| **배포** | Supabase Cloud (무료 티어) | 인프라 관리 최소화 |

---

## System Architecture

```
┌─────────────────────────────────────────────────┐
│                  Flutter App                     │
│  ┌───────────┐  ┌───────────┐  ┌─────────────┐  │
│  │ 재료 입력  │  │ 레시피 탐색│  │  마이페이지  │  │
│  └─────┬─────┘  └─────┬─────┘  └──────┬──────┘  │
└────────┼──────────────┼────────────────┼─────────┘
         │              │                │
         ▼              ▼                ▼
┌─────────────────────────────────────────────────┐
│              Supabase Backend                    │
│                                                  │
│  ┌──────────┐  ┌──────────────┐  ┌───────────┐  │
│  │   Auth   │  │Edge Functions│  │  Storage   │  │
│  │ (소셜/   │  │              │  │ (레시피    │  │
│  │  익명)   │  │  • 추천 API  │  │  이미지)   │  │
│  └──────────┘  │  • 임베딩    │  └───────────┘  │
│                │  • RAG 파이프 │                  │
│                └───────┬──────┘                  │
│                        │                         │
│  ┌─────────────────────┴──────────────────────┐  │
│  │         PostgreSQL + pgvector              │  │
│  │                                            │  │
│  │  recipes        ingredients    user_fridge  │  │
│  │  recipe_embed   recipe_ingr   user_prefs   │  │
│  └────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
         │                    │
         ▼                    ▼
┌──────────────┐    ┌──────────────┐
│   OpenAI     │    │   Claude     │
│  Embedding   │    │  Haiku 4.5   │
│     API      │    │    API       │
└──────────────┘    └──────────────┘
```

---

## Core Data Model

### recipes (레시피)
| 컬럼 | 타입 | 설명 |
|-------|------|------|
| id | uuid | PK |
| title | text | 레시피 이름 |
| description | text | 간단 설명 |
| instructions | jsonb | 조리 순서 (단계별) |
| cook_time | int | 조리 시간 (분) |
| difficulty | text | 난이도 (쉬움/보통/어려움) |
| servings | int | 인분 |
| image_url | text | 대표 이미지 |
| source | text | 데이터 출처 |
| created_at | timestamptz | 생성일 |

### ingredients (재료 마스터)
| 컬럼 | 타입 | 설명 |
|-------|------|------|
| id | uuid | PK |
| name | text | 재료명 |
| category | text | 카테고리 (육류/채소/양념 등) |
| default_unit | text | 기본 단위 |
| aliases | text[] | 동의어 배열 (예: 계란, 달걀, egg) |

### recipe_ingredients (레시피-재료 매핑)
| 컬럼 | 타입 | 설명 |
|-------|------|------|
| recipe_id | uuid | FK → recipes |
| ingredient_id | uuid | FK → ingredients |
| quantity | numeric | 수량 |
| unit | text | 단위 |

### recipe_embeddings (벡터 검색용)
| 컬럼 | 타입 | 설명 |
|-------|------|------|
| recipe_id | uuid | FK → recipes |
| embedding | vector(1536) | 레시피 임베딩 벡터 |
| content | text | 임베딩 원본 텍스트 |

### user_fridge (사용자 냉장고)
| 컬럼 | 타입 | 설명 |
|-------|------|------|
| id | uuid | PK |
| user_id | uuid | FK → auth.users (nullable, 비회원은 로컬) |
| ingredient_id | uuid | FK → ingredients |
| quantity | numeric | 수량 |
| unit | text | 단위 |
| added_at | timestamptz | 등록일 |

---

## RAG Pipeline

재료 입력부터 레시피 추천까지의 흐름:

```
[사용자: 재료 입력]
    │
    ▼
① 재료 매칭 (DB 검색)
   - user_fridge 재료로 recipe_ingredients 매칭
   - 매칭률 계산 (보유 재료 / 필요 재료)
   - 상위 후보 20개 추출
    │
    ▼
② 벡터 유사도 검색 (pgvector)
   - 사용자 재료 목록을 텍스트로 조합
   - OpenAI Embedding API로 벡터화
   - recipe_embeddings에서 cosine similarity 검색
   - 상위 후보 20개 추출
    │
    ▼
③ 후보 병합 및 랭킹
   - ①과 ②의 결과를 합산 (가중 점수)
   - 매칭률 70% + 벡터 유사도 30%
   - 상위 10개 선별
    │
    ▼
④ LLM 보완 (Claude Haiku 4.5)
   - 상위 10개 후보 + 사용자 재료 목록을 프롬프트로 전달
   - "이 재료로 가장 적합한 3개 추천 + 이유 설명"
   - 부족한 재료, 대체 재료 안내 포함
    │
    ▼
[사용자에게 레시피 3개 추천 결과 반환]
```

---

## Authentication

| 사용자 유형 | 동작 |
|-------------|------|
| **비회원** | 냉장고 데이터 로컬 저장 (SharedPreferences), 추천 기능 사용 가능 |
| **로그인 회원** | Supabase Auth (Google, 카카오), 냉장고 데이터 클라우드 동기화 |

비회원 → 로그인 시 로컬 데이터를 Supabase로 마이그레이션한다.

---

## Recipe Data Strategy

### Phase 1: MVP
- 공개 레시피 데이터셋 활용 (만개의레시피 등)
- 수동 정제 후 Supabase에 시딩
- 목표: 1,000~5,000개 레시피

### Phase 2: 크롤링 확장
- Supabase Edge Functions + pg_cron으로 정기 크롤링
- 레시피 사이트에서 데이터 수집 → 정규화 → 임베딩 생성
- 목표: 50,000개 이상

### Phase 3: 사용자 기여
- 사용자 레시피 등록 기능
- 커뮤니티 리뷰/평점

---

## Scaling Strategy

```
[현재] pgvector — 레시피 10만 건 이하, 충분
   ↓
[중기] pgvector + HNSW 인덱스 최적화 — 50만 건까지
   ↓
[장기] PostgreSQL (관계형) + 전용 벡터DB 분리 (검색만)
```

PostgreSQL은 관계형 데이터의 중심으로 유지하고,
벡터 검색 부하가 한계에 도달할 때만 전용 벡터DB(Pinecone 등)를 검색 레이어로 추가한다.

---

## Project Structure (Target)

```
lib/
├── main.dart
├── app/
│   ├── app.dart                # MaterialApp 설정
│   └── routes.dart             # 라우팅
├── config/
│   └── supabase_config.dart    # Supabase 초기화
├── models/
│   ├── ingredient.dart
│   ├── recipe.dart
│   └── user_fridge.dart
├── data/
│   ├── ingredients_data.dart   # 로컬 재료 DB
│   └── repositories/
│       ├── recipe_repository.dart
│       ├── fridge_repository.dart
│       └── auth_repository.dart
├── services/
│   ├── recommendation_service.dart  # RAG 파이프라인
│   ├── embedding_service.dart       # 임베딩 API 호출
│   └── auth_service.dart
├── screens/
│   ├── home/
│   ├── ingredient_input/
│   ├── recipe_detail/
│   └── profile/
├── widgets/
│   └── common/
└── utils/
```

---

## MVP Scope

**포함:**
- [x] 냉장고 재료 입력 UI (자동완성 + 단위 선택)
- [ ] Supabase 연동 (DB + Auth)
- [ ] 레시피 데이터 시딩 (공개 데이터셋)
- [ ] RAG 추천 파이프라인 (매칭 + 벡터 + LLM)
- [ ] 레시피 추천 결과 화면 (3개)
- [ ] 레시피 상세 화면

**제외 (MVP 이후):**
- 웹 버전
- 크롤링 파이프라인
- 사용자 레시피 등록
- 즐겨찾기 / 조리 기록
- 푸시 알림

---

## Constraints & Decisions

| 결정 | 근거 |
|------|------|
| Supabase 선택 | 혼자 개발, 인프라 관리 최소화, 무료 티어 |
| pgvector (MongoDB 대신) | Supabase 내장, 단일 DB, 관계형 JOIN 필수 |
| Haiku 4.5 (Sonnet 대신) | MVP 비용 최적화, 충분한 한국어 성능 |
| 비회원 허용 | 진입 장벽 낮춤, 로컬 → 클라우드 마이그레이션 지원 |
| 임베딩은 OpenAI | text-embedding-3-small 한국어 성능 + 비용 효율 |
