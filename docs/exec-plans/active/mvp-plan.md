# MVP 실행 계획

## 목표

재료 입력 → 레시피 3개 추천까지 동작하는 최소 제품을 완성한다.

---

## Phase 개요

| Phase | 내용 | 담당 에이전트 |
|-------|------|---------------|
| **Phase 1** | 프로젝트 기반 정리 | Frontend |
| **Phase 2** | Supabase 셋업 + DB 구축 | Backend |
| **Phase 3** | 레시피 데이터 시딩 | Data |
| **Phase 4** | RAG 추천 파이프라인 | AI |
| **Phase 5** | 프론트엔드 화면 완성 | Frontend |
| **Phase 6** | 통합 테스트 + 마무리 | QA |

---

## Phase 1: 프로젝트 기반 정리

기존 코드를 `ARCHITECTURE.md`의 Target 폴더 구조에 맞게 정리한다.

| # | 작업 | 상태 |
|---|------|------|
| 1.1 | `utils/constants.dart` 생성 (색상, 사이즈 상수) | ✅ |
| 1.2 | 공통 위젯 추출 (`recipick_card`, `recipick_button`, `recipick_chip` 등) | ✅ |
| 1.3 | 기존 `ingredient_input_screen.dart`를 공통 위젯 사용하도록 리팩터링 | ✅ |
| 1.4 | `app/routes.dart` 라우팅 설정 | ✅ |

**완료 기준:** 프로젝트 구조가 Target과 일치하고, 재료 입력 화면이 정상 동작

---

## Phase 2: Supabase 셋업 + DB 구축

| # | 작업 | 상태 |
|---|------|------|
| 2.1 | Supabase 프로젝트 생성 | ✅ |
| 2.2 | pgvector 확장 활성화 | ✅ |
| 2.3 | DB 스키마 생성 (recipes, ingredients, recipe_ingredients, recipe_embeddings, user_fridge) | ✅ |
| 2.4 | RLS 정책 설정 | ✅ |
| 2.5 | Flutter에 Supabase 연동 (`supabase_flutter` 패키지) | ✅ |
| 2.6 | Auth 설정 (익명 + Google + 카카오) | 🔲 (P1에서 진행) |
| 2.7 | `docs/generated/db-schema.md` 생성 | ✅ |

**완료 기준:** Flutter 앱에서 Supabase 연결 확인, 테이블 CRUD 동작

---

## Phase 3: 레시피 데이터 시딩

| # | 작업 | 상태 |
|---|------|------|
| 3.1 | 공개 레시피 데이터셋 수집 (만개의레시피 등) | ✅ (30개 수동 시드) |
| 3.2 | 데이터 정규화 스크립트 작성 (재료 분리, 단위 표준화) | ✅ |
| 3.3 | `ingredients` 마스터 테이블 시딩 (재료 + 동의어) | ✅ (80개) |
| 3.4 | `recipes` + `recipe_ingredients` 시딩 | ✅ (30개) |
| 3.5 | 임베딩 벡터 생성 (Gemini embedding-001, 768차원) | ✅ |
| 3.6 | `recipe_embeddings` 시딩 | ✅ (30개) |

**완료 기준:** 1,000개 이상 레시피 + 임베딩 벡터가 DB에 존재

---

## Phase 4: RAG 추천 파이프라인

| # | 작업 | 상태 |
|---|------|------|
| 4.1 | Edge Function: `recommend` 엔드포인트 생성 | 🔲 |
| 4.2 | Step ①: 재료 매칭 쿼리 (recipe_ingredients JOIN) | 🔲 |
| 4.3 | Step ②: 벡터 유사도 검색 (pgvector cosine similarity) | 🔲 |
| 4.4 | Step ③: 후보 병합 + 랭킹 (매칭률 70% + 벡터 30%) | 🔲 |
| 4.5 | Step ④: Claude Haiku 호출 (최종 3개 선별 + 추천 이유) | 🔲 |
| 4.6 | LLM 프롬프트 작성 (`lib/services/prompts/`) | 🔲 |
| 4.7 | Fallback 처리 (LLM 실패 시 DB 매칭 결과만 반환) | 🔲 |
| 4.8 | 응답 시간 최적화 (3초 이내 목표) | 🔲 |

**완료 기준:** Edge Function 호출 시 재료 기반 레시피 3개 + 추천 이유 반환

---

## Phase 5: 프론트엔드 화면 완성

| # | 작업 | 상태 |
|---|------|------|
| 5.1 | 홈 화면 — 냉장고 재료 요약 + "추천받기" 버튼 | 🔲 |
| 5.2 | 추천 결과 화면 — 레시피 카드 3개 (매칭률, 부족 재료, AI 이유) | 🔲 |
| 5.3 | 레시피 상세 화면 — 재료 목록, 조리 순서, 팁 | 🔲 |
| 5.4 | 로딩 상태 — 추천 API 호출 중 스켈레톤/shimmer | 🔲 |
| 5.5 | 에러 상태 — 네트워크 오류, 빈 결과 처리 | 🔲 |
| 5.6 | 온보딩 카드 3장 (최초 실행 시) | 🔲 |

**완료 기준:** 재료 입력 → 추천 → 상세까지 전체 플로우 동작

---

## Phase 6: 통합 테스트 + 마무리

| # | 작업 | 상태 |
|---|------|------|
| 6.1 | 추천 파이프라인 단위 테스트 (매칭률 계산, 랭킹) | 🔲 |
| 6.2 | 위젯 테스트 (재료 입력, 추천 결과 화면) | 🔲 |
| 6.3 | E2E 플로우 수동 테스트 | 🔲 |
| 6.4 | 엣지 케이스 처리 (재료 0개, 매칭 0건, 네트워크 오류) | 🔲 |
| 6.5 | 성능 확인 (추천 3초 이내, 앱 시작 2초 이내) | 🔲 |
| 6.6 | 코드 정리 + 린트 패스 | 🔲 |

**완료 기준:** 버그 없이 전체 플로우 동작, 테스트 통과

---

## 의존 관계

```
Phase 1 (기반 정리)
  ↓
Phase 2 (Supabase) ─────→ Phase 3 (데이터 시딩)
                                    ↓
                           Phase 4 (RAG 파이프라인)
                                    ↓
Phase 1 완료 ──────────→ Phase 5 (화면 완성)
                                    ↓
                           Phase 6 (테스트)
```

- Phase 1과 Phase 2는 병렬 가능
- Phase 3은 Phase 2 완료 후
- Phase 4는 Phase 3 완료 후
- Phase 5는 Phase 1 + Phase 4 완료 후
- Phase 6은 Phase 5 완료 후

---

## 리스크

| 리스크 | 영향 | 대응 |
|--------|------|------|
| 공개 레시피 데이터 품질 낮음 | 추천 정확도 저하 | 수동 정제, 소규모(500개)로 시작 |
| OpenAI Embedding API 비용 | 예산 초과 | 배치 크기 제한, 캐싱 |
| Claude API 응답 지연 | 3초 목표 미달 | Fallback 활용, 프롬프트 간소화 |
| Supabase 무료 티어 한계 | DB 용량/요청 제한 | MVP 데이터 규모 제한 |
