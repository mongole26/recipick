# Recipick Agents

## Overview

이 문서는 Recipick 개발에 참여하는 AI 에이전트들의 역할, 권한, 규칙을 정의한다.
각 에이전트는 독립적인 전문 영역을 가지며, 코드 작성까지 직접 수행한다.

---

## Agent 목록

| 에이전트 | 역할 | 주요 담당 |
|----------|------|-----------|
| **Frontend Agent** | 클라이언트 UI/UX 구현 | Flutter 화면, 위젯, 상태관리 |
| **Backend Agent** | 서버/DB 구현 | Supabase, Edge Functions, 스키마 |
| **AI Agent** | 추천 엔진 구현 | RAG 파이프라인, 임베딩, LLM 연동 |
| **Data Agent** | 데이터 수집/관리 | 레시피 데이터셋, 크롤링, 시딩 |
| **QA Agent** | 품질 검증 | 테스트 작성, 코드 리뷰, 버그 분석 |

---

## Frontend Agent

### 역할
Flutter 앱의 모든 UI/UX를 설계하고 구현한다.

### 담당 범위
- `lib/screens/` — 화면 구현
- `lib/widgets/` — 공통 위젯
- `lib/app/` — 라우팅, 테마

### 규칙
- **컬리 스타일** 준수: 화이트 베이스, 충분한 여백, 카드 기반 레이아웃
- 색상 시스템: 메인 `#5F0080`, 보조 `#F3E8FF`, 배경 `#F7F7F7`
- 텍스트: 짧고 명확한 한국어 존댓말
- 모든 화면은 **모바일 우선**으로 구현 (추후 웹 반응형 확장 고려)
- 상태관리 방식은 프로젝트 규모에 맞게 선택 (MVP: setState → 확장 시 Riverpod 등)

### 참조 문서
- `docs/DESIGN.md` — 디자인 시스템
- `docs/FRONTEND.md` — 프론트엔드 컨벤션
- `docs/product-specs/index.md` — 추천 카드 스펙, 사용자 플로우

---

## Backend Agent

### 역할
Supabase 기반의 서버 인프라를 설계하고 구현한다.

### 담당 범위
- Supabase 프로젝트 설정 (Auth, DB, Storage, Edge Functions)
- PostgreSQL 스키마 설계 및 마이그레이션
- RLS(Row Level Security) 정책
- Edge Functions (API 엔드포인트)
- `lib/data/repositories/` — 데이터 접근 레이어

### 규칙
- 스키마 변경 시 반드시 마이그레이션 파일 작성
- RLS 정책은 기본 차단, 필요한 것만 허용
- Edge Functions는 TypeScript로 작성
- 비회원 데이터는 로컬(SharedPreferences) 우선, 로그인 시 Supabase로 마이그레이션
- API 응답 시간 목표: 500ms 이내

### 참조 문서
- `ARCHITECTURE.md` — 데이터 모델, 시스템 구조
- `docs/generated/db-schema.md` — DB 스키마 (자동 생성)

---

## AI Agent

### 역할
RAG 기반 레시피 추천 파이프라인을 설계하고 구현한다.

### 담당 범위
- `lib/services/recommendation_service.dart` — RAG 파이프라인
- `lib/services/embedding_service.dart` — 임베딩 API 연동
- Supabase Edge Functions 중 추천 관련 엔드포인트
- pgvector 쿼리 최적화
- LLM 프롬프트 설계 및 관리

### RAG 파이프라인 (4단계)
```
① 재료 매칭 (DB) → ② 벡터 검색 (pgvector) → ③ 랭킹 → ④ LLM 보완 (Gemini Flash)
```

### 규칙
- 임베딩: Google Gemini `gemini-embedding-001` (768차원, 무료)
- LLM: Google Gemini Flash (무료)
- 랭킹 가중치: 매칭률 70% + 벡터 유사도 30%
- 최종 추천: 항상 3개
- LLM 응답에는 반드시 **추천 이유**를 한 문장으로 포함
- 전체 추천 소요 시간 목표: 3초 이내
- 프롬프트는 별도 파일로 관리 (`lib/services/prompts/`)
- LLM 호출 실패 시 DB 매칭 결과만으로 fallback 제공

### 참조 문서
- `ARCHITECTURE.md` — RAG Pipeline 섹션
- `docs/product-specs/index.md` — 추천 카드 스펙

---

## Data Agent

### 역할
레시피 데이터를 수집, 정제, 관리한다.

### 담당 범위
- 공개 데이터셋 수집 및 정규화
- 레시피 데이터 시딩 스크립트
- 임베딩 벡터 생성 배치 작업
- (Phase 2) 크롤링 파이프라인

### 규칙
- 레시피 데이터는 반드시 정규화된 형태로 저장
  - 재료는 `ingredients` 테이블의 마스터 데이터와 매핑
  - 수량/단위는 표준화 (`ARCHITECTURE.md`의 데이터 모델 참조)
- 임베딩 원본 텍스트 형식: `"[레시피명] [재료1] [재료2] ... [조리법 요약]"`
- 데이터 출처(`source` 컬럼)를 반드시 기록
- 중복 레시피 검출 로직 포함

### 데이터 전략
| Phase | 방식 | 목표 |
|-------|------|------|
| MVP | 공개 데이터셋 정제 | 1,000~5,000개 |
| Phase 2 | 크롤링 파이프라인 | 50,000개+ |
| Phase 3 | 사용자 기여 | 지속 증가 |

### 참조 문서
- `ARCHITECTURE.md` — Recipe Data Strategy 섹션

---

## QA Agent

### 역할
코드 품질을 검증하고 테스트를 작성한다.

### 담당 범위
- `test/` — 단위 테스트, 위젯 테스트
- 코드 리뷰 (다른 에이전트가 작성한 코드)
- 버그 재현 및 분석
- 성능 검증

### 규칙
- 새 기능에는 최소한의 테스트 동반 (핵심 로직 위주)
- 추천 파이프라인은 반드시 테스트 커버 (매칭률 계산, 랭킹 로직)
- 테스트 실패 시 원인 분석 → 수정안 제시
- 린트 규칙(`analysis_options.yaml`) 준수 확인

### 참조 문서
- `docs/QUALITY_SCORE.md` — 품질 기준

---

## 작업 프로세스

모든 에이전트는 기능 구현 시 아래 5단계를 **반드시** 순서대로 따른다.
기획과 코딩을 분리하여, 충분한 이해 없이 코드를 작성하지 않는다.

### 1단계: 리서치

- 관련 코드/폴더를 **깊이** 읽고 동작 방식을 완전히 이해한다
- 모든 세부사항을 파악한 뒤, 해당 작업의 `research.md`에 **상세 보고서**를 작성한다
- 채팅창에서 구두 요약으로 끝내지 않는다 — 반드시 파일로 남긴다
- 산출물: `docs/exec-plans/active/{작업명}/research.md`

### 2단계: 계획

- 리서치 내용을 토대로 구현 계획을 수립한다
- 산출물: `docs/exec-plans/active/{작업명}/plan.md`
- 승인 후 다음 단계로 넘어간다

### 3단계: 주석달기 (반복)

- 구현할 코드에 주석 메모를 추가한다
- 사용자가 검토 후 주석을 추가/수정하면 반영한다
- **이 단계에서는 구현하지 않는다** — 주석 업데이트만 수행

### 4단계: 구현

구현 시 아래 규칙을 따른다:

1. **전부 구현한다** — 부분 구현하지 않음
2. **작업/단계 완료 시 plan.md에서 완료로 표시**한다
3. **모든 작업과 단계가 완료될 때까지 멈추지 않는다**
4. **`any`, `unknown` 타입을 사용하지 않는다** — 명시적 타입만 사용
5. **지속적으로 typecheck를 실행**하여 새로운 문제를 만들지 않는다

### 5단계: 피드백

- 사용자의 피드백을 반영하여 수정한다

---

## 공통 규칙

### 코드 작성
- Dart 공식 스타일 가이드 준수
- 파일명: snake_case, 클래스명: PascalCase
- 한 파일에 하나의 주요 클래스/위젯
- `ARCHITECTURE.md`의 Target 폴더 구조를 따름

### 커뮤니케이션
- 작업 전 **무엇을 할지** 간단히 설명
- 변경 범위가 크면 먼저 계획을 공유하고 승인 후 진행
- 다른 에이전트 담당 영역을 수정해야 할 때는 최소한의 변경만

### 문서
- 스키마 변경 시 `docs/generated/db-schema.md` 업데이트
- 새로운 설계 결정은 `docs/design-docs/`에 기록
- 실행 계획은 `docs/exec-plans/active/`에 작성

### Git
- 커밋 메시지: `type: 설명` 형식 (feat, fix, refactor, docs, test, chore)
- 한 커밋에 하나의 논리적 변경
- 작동하는 상태에서만 커밋
