# Recipick Design System

## 디자인 철학

컬리의 실용적이고 깔끔한 접근을 따른다.
**보여줄 것만 보여주고, 여백으로 숨 쉬게 하고, 행동을 유도한다.**

---

## Color System

### Primary

| 이름 | 코드 | 용도 |
|------|------|------|
| **Purple 700** | `#5F0080` | 메인 액션, 강조, 선택된 상태 |
| **Purple 100** | `#F3E8FF` | 아이콘 배경, 태그 배경 |
| **Purple 50** | `#FAF5FF` | 선택된 카드 배경 |

### Neutral

| 이름 | 코드 | 용도 |
|------|------|------|
| **Gray 900** | `#333333` | 제목, 본문 텍스트 |
| **Gray 600** | `#666666` | 보조 텍스트 |
| **Gray 400** | `#999999` | 플레이스홀더, 비활성 |
| **Gray 200** | `#E0E0E0` | 구분선, 비선택 보더 |
| **Gray 100** | `#F5F5F5` | 입력 필드 배경 |
| **Gray 50** | `#F7F7F7` | 페이지 배경 |
| **White** | `#FFFFFF` | 카드, 앱바, 바텀시트 |

### Semantic

| 이름 | 코드 | 용도 |
|------|------|------|
| **Red 400** | `#EF5350` | 삭제, 에러 |
| **Green 500** | `#4CAF50` | 성공, 높은 매칭률 |
| **Orange 400** | `#FFA726` | 경고, 중간 매칭률 |

---

## Typography

| 스타일 | 크기 | 두께 | 색상 | 용도 |
|--------|------|------|------|------|
| **Heading L** | 22px | Bold (700) | Gray 900 | 화면 타이틀, 바텀시트 제목 |
| **Heading M** | 18px | Bold (700) | Gray 900 | 앱바 타이틀, 섹션 제목 |
| **Body L** | 16px | Semi-Bold (600) | Gray 900 | 카드 제목, 재료명 |
| **Body M** | 15px | Semi-Bold (600) | 상황별 | 칩 텍스트, 버튼 |
| **Body S** | 14px | Medium (500) | Purple 700 | 수량 표시, 링크 |
| **Caption** | 13px | Regular (400) | Gray 400 | 키워드, 부가 정보 |
| **Small** | 12px | Regular (400) | Gray 400 | 타임스탬프 |

### 원칙
- 본문: 시스템 기본 폰트 (San Francisco / Noto Sans KR)
- 행간: 1.4~1.5
- 한 화면에 3단계 이하의 텍스트 위계만 사용

---

## Spacing

8px 기반 그리드 시스템.

| 토큰 | 값 | 용도 |
|------|----|------|
| `xs` | 4px | 텍스트 간 미세 간격 |
| `sm` | 8px | 칩 내부, 아이콘-텍스트 간격 |
| `md` | 12px | 리스트 아이템 패딩 |
| `lg` | 16px | 카드 패딩, 섹션 간격 |
| `xl` | 20px | 바텀시트 상단 |
| `2xl` | 24px | 섹션 간 구분 |
| `3xl` | 28px | 버튼 상단 여백 |

---

## Components

### Card (카드)

```
배경: White
모서리: 14px
패딩: 16px
그림자: black 4% blur 8px offset (0, 2)
마진 (카드 간): 10px
```

### Button (버튼)

**Primary (메인 액션)**
```
배경: Purple 700 (#5F0080)
텍스트: White, 16px, Bold
높이: 52px
모서리: 12px
너비: 전체 (full-width)
```

**Secondary (보조 액션)**
```
배경: White
보더: Gray 200, 1.5px
텍스트: Gray 600, 15px, Semi-Bold
높이: 44px
모서리: 12px
```

### Chip (칩 / 단위 선택)

**선택됨**
```
배경: Purple 700
텍스트: White, 15px, Semi-Bold
모서리: 20px
패딩: 10px 20px
보더: Purple 700, 1.5px
```

**미선택**
```
배경: White
텍스트: Gray 600, 15px, Semi-Bold
모서리: 20px
패딩: 10px 20px
보더: Gray 200, 1.5px
```

### Input Field (입력 필드)

```
배경: Gray 100 (#F5F5F5)
모서리: 12px
패딩: 12px 16px
보더 (기본): 없음
보더 (포커스): Purple 700, 1.5px
플레이스홀더: Gray 400
```

### Bottom Sheet (바텀시트)

```
배경: White
상단 모서리: 20px
핸들바: Gray 200, 40px × 4px, 모서리 2px
패딩: 24px 좌우, 20px 상단
```

### List Item (리스트 아이템)

```
배경: White
아이콘 영역: 40px × 40px, Purple 100 배경, 모서리 10px
구분선: Gray 100, indent 56px
```

---

## Icon Style

- 기본: Material Icons
- 크기: 20~22px (카드/리스트 내), 48~64px (빈 상태)
- 색상: Purple 700 (활성), Gray 300 (비활성/빈 상태)
- 아이콘 배경: Purple 100, 모서리 10~12px

---

## Empty State (빈 상태)

모든 빈 상태는 동일한 패턴:

```
[큰 아이콘 (64px, Gray 300)]

[메인 텍스트 (17px, Semi-Bold, Gray 400)]
[보조 텍스트 (14px, Regular, Gray 400)]
```

예시:
- 냉장고 비었을 때: 🧊 "냉장고가 비어있어요" / "위 검색창에서 재료를 추가해 보세요"
- 검색 결과 없을 때: 🔍 "검색 결과가 없습니다"

---

## Motion & Animation

| 요소 | 시간 | 이징 |
|------|------|------|
| 칩 선택 전환 | 150ms | ease-out |
| 바텀시트 등장 | 300ms | ease-in-out |
| 카드 삭제 (스와이프) | 200ms | ease-out |
| 페이지 전환 | 300ms | Material default |

### 원칙
- 빠르고 자연스럽게 (300ms 이하)
- 장식용 애니메이션 자제
- 사용자 액션에 대한 피드백 위주

---

## Responsive 전략

### MVP (모바일)
- 기준 너비: 375px (iPhone SE ~ iPhone 15)
- 최대 컨텐츠 너비: 화면 전체
- 좌우 패딩: 16px

### 추후 (웹 확장 시)
- 최대 컨텐츠 너비: 480px (모바일 앱 느낌 유지)
- 중앙 정렬
- 좌우 여백: 자동
