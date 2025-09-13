# GrowTogether TodoList Frontend Architecture Document

## Change Log
| Date | Version | Description | Author |
|------|---------|-------------|---------|
| 2025-09-14 | 1.0 | Initial frontend architecture document | Winston (Architect) |

---

## Template and Framework Selection

### Framework Decision: React 18+ with Vite

Based on the PRD and project brief analysis, **React 18+ with TypeScript + Vite** has been selected as the frontend technology stack for GrowTogether TodoList.

**Key Technical Requirements Alignment**:
- **Vite**: 빠른 개발 서버로 1일 개발 제약에 최적화
- **React 18**: Concurrent 기능으로 부드러운 60fps 애니메이션 지원
- **TypeScript**: 5명 개발자 협업을 위한 타입 안전성 보장
- **모놀리식 구조**: Spring Boot와 단순한 REST API 통합

**Recommended Starter Template**: `npm create vite@latest frontend -- --template react-ts`

**Rationale**:
- **빠른 시작**: Vite의 React-TS 템플릿은 TypeScript, ESLint 포함으로 즉시 개발 가능
- **최적화된 번들링**: HMR과 빠른 빌드로 1일 개발 제약 대응
- **애니메이션 준비**: React 18의 Concurrent 기능으로 감정적 식물 애니메이션 구현
- **풍부한 생태계**: 식물 성장 시스템 구현에 필요한 라이브러리 지원

---

## Frontend Tech Stack

### Technology Stack Table

| Category | Technology | Version | Purpose | Rationale |
|----------|------------|---------|---------|-----------|
| Framework | React | 18.x | UI 컴포넌트 시스템과 상태 관리 | Concurrent 기능으로 부드러운 애니메이션, 풍부한 생태계, PRD 명시 요구사항 |
| Language | TypeScript | 5.x | 타입 안전성과 개발 경험 향상 | 코드 품질 보장, 대규모 코드베이스 관리, React와 완벽 통합 |
| Build Tool | Vite | 4.x | 빠른 개발 서버와 번들링 | HMR 최적화로 1일 개발 제약 대응, ESM 기반 빠른 빌드 |
| UI Library | React Transition Group | 4.x | 식물 성장 애니메이션 관리 | 부드러운 전환 효과, React 생명주기 통합, 가벼운 라이브러리 |
| State Management | React Built-in | 18.x | useState/useContext 활용 | MVP 단순함 우선, 외부 의존성 최소화, 빠른 개발 |
| Routing | React Router | 6.x | SPA 라우팅 관리 | 표준 React 라우팅, 코드 분할 지원, 가벼운 구조 |
| Styling | CSS Modules | - | 컴포넌트별 스타일 격리 | 스타일 충돌 방지, Vite 기본 지원, 빠른 개발 |
| HTTP Client | Axios | 1.x | REST API 통신 | 인터셉터 지원, 에러 처리 용이, Spring Boot 통합 최적화 |
| Testing | React Testing Library | 13.x | 컴포넌트 테스팅 | 사용자 중심 테스트, React 18 지원, 접근성 테스트 포함 |
| Component Library | Headless UI | 1.x | 접근성 있는 기본 컴포넌트 | WCAG AA 준수, 커스터마이징 용이, 가벼운 구조 |
| Form Handling | React Hook Form | 7.x | 폼 상태 및 검증 관리 | 성능 최적화, 간단한 API, 빠른 구현 |
| Animation | CSS Animations + React Spring | 9.x | 미세한 애니메이션과 상호작용 | 60fps 보장, 자연스러운 spring 애니메이션, 최적화된 성능 |
| Dev Tools | React DevTools, ESLint | latest | 개발 도구와 코드 품질 | 디버깅 효율성, 코드 일관성, Vite 통합 |

---

## Project Structure

```
frontend/
├── public/
│   ├── plant-images/           # 식물 성장 단계별 이미지/SVG
│   │   ├── stage-1-seed.svg
│   │   ├── stage-2-sprout.svg
│   │   ├── stage-3-young.svg
│   │   ├── stage-4-grown.svg
│   │   └── stage-5-mature.svg
│   └── favicon.ico
├── src/
│   ├── components/            # 재사용 가능한 UI 컴포넌트
│   │   ├── common/           # 공통 컴포넌트
│   │   │   ├── Button/
│   │   │   │   ├── Button.tsx
│   │   │   │   ├── Button.module.css
│   │   │   │   └── index.ts
│   │   │   ├── Input/
│   │   │   └── Layout/
│   │   ├── todo/             # TODO 관련 컴포넌트
│   │   │   ├── TodoItem/
│   │   │   │   ├── TodoItem.tsx
│   │   │   │   ├── TodoItem.module.css
│   │   │   │   └── index.ts
│   │   │   ├── TodoList/
│   │   │   ├── TodoForm/
│   │   │   └── TodoStats/
│   │   └── plant/            # 식물 관련 컴포넌트
│   │       ├── PlantView/
│   │       │   ├── PlantView.tsx
│   │       │   ├── PlantView.module.css
│   │       │   └── index.ts
│   │       ├── PlantGrowthAnimation/
│   │       ├── PlantMessage/
│   │       └── PlantProgress/
│   ├── pages/                # 페이지 컴포넌트
│   │   ├── Dashboard/
│   │   │   ├── Dashboard.tsx
│   │   │   ├── Dashboard.module.css
│   │   │   └── index.ts
│   │   ├── PlantDetails/
│   │   └── Settings/
│   ├── services/             # API 및 외부 서비스
│   │   ├── api/
│   │   │   ├── todoApi.ts
│   │   │   ├── plantApi.ts
│   │   │   └── httpClient.ts
│   │   └── plantGrowth/
│   │       ├── growthCalculator.ts
│   │       └── animationService.ts
│   ├── hooks/                # 커스텀 React 훅
│   │   ├── useTodos.ts
│   │   ├── usePlant.ts
│   │   ├── useGrowthAnimation.ts
│   │   └── useLocalStorage.ts
│   ├── types/                # TypeScript 타입 정의
│   │   ├── todo.ts
│   │   ├── plant.ts
│   │   └── api.ts
│   ├── styles/               # 전역 스타일 및 테마
│   │   ├── globals.css
│   │   ├── theme.css
│   │   ├── animations.css
│   │   └── reset.css
│   ├── utils/                # 유틸리티 함수
│   │   ├── constants.ts
│   │   ├── formatters.ts
│   │   └── validators.ts
│   ├── context/              # React Context (필요시)
│   │   └── AppContext.tsx
│   ├── App.tsx
│   ├── App.module.css
│   ├── main.tsx
│   └── vite-env.d.ts
├── __tests__/                # 테스트 파일
│   ├── components/
│   ├── services/
│   └── utils/
├── package.json
├── tsconfig.json
├── vite.config.ts
├── .eslintrc.js
├── .gitignore
└── README.md
```

**핵심 구조 설계 원칙**:
1. **도메인 기반 컴포넌트 분리**: `todo/`, `plant/` 폴더로 기능별 명확한 분리
2. **재사용성 우선**: `common/` 컴포넌트는 프로젝트 전반에서 사용
3. **서비스 계층 분리**: API 통신과 비즈니스 로직을 컴포넌트에서 분리
4. **타입 안전성**: 중앙집중식 타입 정의로 TypeScript 활용 극대화
5. **성능 최적화**: 레이지 로딩과 코드 분할을 위한 페이지 기반 구조

---

## Component Standards

### Component Template

```typescript
import React, { useState, useEffect } from 'react';
import styles from './ComponentName.module.css';
import { ComponentNameProps } from '../../types/component';

/**
 * ComponentName - 컴포넌트에 대한 간단한 설명
 *
 * @param prop1 - prop1에 대한 설명
 * @param prop2 - prop2에 대한 설명
 *
 * 사용 예시:
 * <ComponentName prop1="value" prop2={handler} />
 */
export const ComponentName: React.FC<ComponentNameProps> = ({
  prop1,
  prop2,
  children,
  className,
  ...restProps
}) => {
  // 상태 관리
  const [internalState, setInternalState] = useState<string>('');

  // 사이드 이펙트
  useEffect(() => {
    // 컴포넌트 마운트/업데이트 로직
  }, [prop1, prop2]);

  // 이벤트 핸들러
  const handleAction = (event: React.MouseEvent<HTMLButtonElement>) => {
    event.preventDefault();
    // 핸들러 로직
    prop2?.(internalState);
  };

  // 조건부 렌더링 로직
  if (!prop1) {
    return <div className={styles.empty}>No data available</div>;
  }

  return (
    <div
      className={`${styles.container} ${className || ''}`}
      {...restProps}
    >
      <h2 className={styles.title}>{prop1}</h2>

      {/* 자식 컴포넌트 렌더링 */}
      <div className={styles.content}>
        {children}
      </div>

      {/* 액션 버튼 */}
      <button
        className={styles.actionButton}
        onClick={handleAction}
        type="button"
      >
        Action
      </button>
    </div>
  );
};

export default ComponentName;
```

### Naming Conventions

**파일 및 폴더 명명 규칙**:

**컴포넌트 파일**:
- `PascalCase` 사용: `PlantView.tsx`, `TodoItem.tsx`
- 폴더와 파일명 일치: `PlantView/PlantView.tsx`
- 타입 파일: `plantView.types.ts` (camelCase)

**CSS 모듈**:
- 컴포넌트명과 일치: `PlantView.module.css`
- 클래스명은 `camelCase`: `.plantContainer`, `.growthAnimation`

**훅 (Hooks)**:
- `use` 접두사: `usePlant.ts`, `useGrowthAnimation.ts`
- 기능 중심 명명: `useTodoOperations.ts`

**상수 및 타입**:
- 상수: `PLANT_GROWTH_STAGES`, `API_ENDPOINTS` (SCREAMING_SNAKE_CASE)
- 타입/인터페이스: `PlantData`, `TodoItem` (PascalCase)
- Enum: `PlantStage`, `TodoStatus` (PascalCase)

---

## State Management

### Store Structure

```
src/hooks/
├── state/                    # 상태 관리 훅들
│   ├── useTodoState.ts      # TODO 상태 관리
│   ├── usePlantState.ts     # 식물 상태 관리
│   ├── useAnimationState.ts # 애니메이션 상태 관리
│   └── useAppState.ts       # 전역 앱 상태
├── effects/                 # 사이드 이펙트 훅들
│   ├── useTodoEffects.ts    # TODO 관련 API 호출
│   ├── usePlantEffects.ts   # 식물 성장 로직
│   └── useGrowthAnimation.ts # 성장 애니메이션 효과
├── selectors/               # 상태 선택자 및 계산된 값
│   ├── useTodoSelectors.ts  # TODO 파생 상태
│   ├── usePlantSelectors.ts # 식물 파생 상태
│   └── useStatsSelectors.ts # 통계 계산
└── context/                 # 컨텍스트 제공자
    ├── AppContext.tsx       # 전역 상태 컨텍스트
    └── PlantContext.tsx     # 식물 특화 컨텍스트
```

### State Management Template

```typescript
// hooks/state/usePlantState.ts
import { useState, useCallback, useRef } from 'react';
import { PlantState, PlantStage, GrowthEvent } from '../../types/plant';

interface UsePlantStateReturn {
  // 상태
  plant: PlantState;
  isGrowing: boolean;
  growthProgress: number;

  // 액션
  growPlant: (points: number) => Promise<void>;
  resetPlant: () => void;
  updatePlantName: (name: string) => void;

  // 계산된 값
  currentStage: PlantStage;
  nextStageProgress: number;
  canGrow: boolean;
}

export const usePlantState = (initialPlant?: PlantState): UsePlantStateReturn => {
  const [plant, setPlant] = useState<PlantState>(
    initialPlant || {
      id: '',
      name: '내 식물',
      stage: PlantStage.SEED,
      growthPoints: 0,
      level: 1,
      lastGrowth: new Date(),
      totalTodosCompleted: 0,
    }
  );

  const [isGrowing, setIsGrowing] = useState(false);
  const growthTimeoutRef = useRef<NodeJS.Timeout>();

  const growPlant = useCallback(async (points: number) => {
    setIsGrowing(true);

    await new Promise(resolve => {
      growthTimeoutRef.current = setTimeout(resolve, 1000);
    });

    setPlant(prevPlant => {
      const newGrowthPoints = prevPlant.growthPoints + points;
      const newStage = calculateNewStage(newGrowthPoints);

      return {
        ...prevPlant,
        growthPoints: newGrowthPoints,
        stage: newStage,
        level: Math.floor(newGrowthPoints / 10) + 1,
        lastGrowth: new Date(),
        totalTodosCompleted: prevPlant.totalTodosCompleted + 1,
      };
    });

    setIsGrowing(false);
  }, []);

  // ... 기타 메서드들

  return {
    plant,
    isGrowing,
    growthProgress: (plant.growthPoints / 100) * 100,
    growPlant,
    resetPlant,
    updatePlantName,
    currentStage: plant.stage,
    nextStageProgress: (plant.growthPoints % 20) / 20 * 100,
    canGrow: plant.stage < PlantStage.MATURE,
  };
};
```

---

## API Integration

### Service Template

```typescript
// services/api/plantApi.ts
import { ApiResponse, PlantData, GrowthRequest } from '../../types/api';
import { httpClient } from './httpClient';

export class PlantApiService {
  private readonly basePath = '/api/plants';

  async getPlant(userId: string): Promise<ApiResponse<PlantData>> {
    try {
      const response = await httpClient.get<PlantData>(`${this.basePath}/${userId}`);

      return {
        success: true,
        data: response.data,
        message: 'Plant data retrieved successfully',
      };
    } catch (error) {
      return this.handleError(error, 'Failed to fetch plant data');
    }
  }

  async growPlant(growthRequest: GrowthRequest): Promise<ApiResponse<PlantData>> {
    try {
      const response = await httpClient.post<PlantData>(
        `${this.basePath}/grow`,
        growthRequest,
        {
          timeout: 800, // 1초 제한 내에서 여유 확보
          headers: {
            'Content-Type': 'application/json',
          },
        }
      );

      return {
        success: true,
        data: response.data,
        message: 'Plant growth processed successfully',
      };
    } catch (error) {
      return this.handleError(error, 'Failed to process plant growth');
    }
  }

  private handleError(error: any, defaultMessage: string): ApiResponse<never> {
    console.error('PlantAPI Error:', error);

    if (!error.response) {
      return {
        success: false,
        error: 'Network error. Please check your connection.',
        code: 'NETWORK_ERROR',
      };
    }

    const { status, data } = error.response;
    switch (status) {
      case 404:
        return {
          success: false,
          error: 'Plant not found. Please refresh the page.',
          code: 'PLANT_NOT_FOUND',
        };
      case 400:
        return {
          success: false,
          error: data.message || 'Invalid request data.',
          code: 'BAD_REQUEST',
        };
      default:
        return {
          success: false,
          error: defaultMessage,
          code: 'UNKNOWN_ERROR',
        };
    }
  }
}

export const plantApi = new PlantApiService();
```

### API Client Configuration

```typescript
// services/api/httpClient.ts
import axios, { AxiosInstance } from 'axios';
import { API_CONFIG } from '../../utils/constants';

class HttpClient {
  private instance: AxiosInstance;

  constructor() {
    this.instance = axios.create({
      baseURL: API_CONFIG.BASE_URL,
      timeout: API_CONFIG.TIMEOUT,
      headers: {
        'Content-Type': 'application/json',
      },
    });

    this.setupInterceptors();
  }

  private setupInterceptors(): void {
    this.instance.interceptors.request.use(
      (config) => {
        if (import.meta.env.DEV) {
          console.log(`🚀 API Request: ${config.method?.toUpperCase()} ${config.url}`);
        }
        return config;
      },
      (error) => {
        console.error('Request Interceptor Error:', error);
        return Promise.reject(error);
      }
    );

    this.instance.interceptors.response.use(
      (response) => {
        if (import.meta.env.DEV) {
          console.log(`✅ API Response: ${response.status} ${response.config.url}`);
        }
        return response;
      },
      (error) => {
        if (import.meta.env.DEV) {
          console.error('❌ API Error:', {
            url: error.config?.url,
            method: error.config?.method,
            status: error.response?.status,
            data: error.response?.data,
          });
        }
        return Promise.reject(error);
      }
    );
  }

  async get<T>(url: string, config?: any) {
    return this.instance.get(url, config);
  }

  async post<T>(url: string, data?: any, config?: any) {
    return this.instance.post(url, data, config);
  }

  async patch<T>(url: string, data?: any, config?: any) {
    return this.instance.patch(url, data, config);
  }

  async delete<T>(url: string, config?: any) {
    return this.instance.delete(url, config);
  }
}

export const httpClient = new HttpClient();
```

---

## Routing

### Route Configuration

```typescript
// src/router/AppRouter.tsx
import React, { Suspense } from 'react';
import {
  BrowserRouter as Router,
  Routes,
  Route,
  Navigate
} from 'react-router-dom';
import { ErrorBoundary } from '../components/common/ErrorBoundary';
import { LoadingSpinner } from '../components/common/LoadingSpinner';
import { Layout } from '../components/common/Layout';

// 코드 분할을 통한 성능 최적화
const Dashboard = React.lazy(() => import('../pages/Dashboard'));
const PlantDetails = React.lazy(() => import('../pages/PlantDetails'));
const Settings = React.lazy(() => import('../pages/Settings'));
const NotFound = React.lazy(() => import('../pages/NotFound'));

export const AppRouter: React.FC = () => {
  return (
    <Router>
      <ErrorBoundary>
        <Layout>
          <Suspense fallback={<LoadingSpinner />}>
            <Routes>
              <Route path="/" element={<Dashboard />} />
              <Route path="/plant" element={<PlantDetails />} />
              <Route path="/settings" element={<Settings />} />
              <Route path="/dashboard" element={<Navigate to="/" replace />} />
              <Route path="*" element={<NotFound />} />
            </Routes>
          </Suspense>
        </Layout>
      </ErrorBoundary>
    </Router>
  );
};

export const ROUTES = {
  HOME: '/',
  PLANT_DETAILS: '/plant',
  SETTINGS: '/settings',
} as const;
```

---

## Styling Guidelines

### Styling Approach

**CSS Modules + CSS Custom Properties** 조합을 채택하여 컴포넌트별 스타일 격리와 전역 테마 시스템을 동시에 구현합니다.

### Global Theme Variables

```css
/* src/styles/theme.css */
:root {
  /* Primary Colors - 식물 성장을 상징하는 초록색 계열 */
  --color-primary-50: #f0fdf4;
  --color-primary-100: #dcfce7;
  --color-primary-200: #bbf7d0;
  --color-primary-300: #86efac;
  --color-primary-400: #4ade80;
  --color-primary-500: #22c55e;  /* 기본 초록색 */
  --color-primary-600: #16a34a;
  --color-primary-700: #15803d;
  --color-primary-800: #166534;
  --color-primary-900: #14532d;

  /* Secondary Colors - 따뜻한 갈색과 베이지 계열 */
  --color-secondary-500: #f4b942;  /* 따뜻한 황토색 */

  /* Neutral Colors - 부드럽고 따뜻한 회색 계열 */
  --color-neutral-100: #f5f5f4;
  --color-neutral-500: #78716c;   /* 기본 텍스트 */
  --color-neutral-700: #44403c;   /* 진한 텍스트 */

  /* Semantic Colors */
  --color-success: var(--color-primary-500);
  --color-warning: #f59e0b;
  --color-error: #ef4444;
  --color-info: #3b82f6;

  /* Typography */
  --font-family-primary: 'Pretendard', -apple-system, BlinkMacSystemFont, sans-serif;
  --font-size-base: 1rem;
  --font-weight-normal: 400;
  --font-weight-medium: 500;
  --font-weight-bold: 700;

  /* Spacing System - 8px 기준 */
  --spacing-1: 0.25rem;   /* 4px */
  --spacing-2: 0.5rem;    /* 8px */
  --spacing-4: 1rem;      /* 16px */
  --spacing-6: 1.5rem;    /* 24px */
  --spacing-8: 2rem;      /* 32px */

  /* Border Radius */
  --radius-sm: 0.25rem;   /* 4px */
  --radius-md: 0.5rem;    /* 8px */
  --radius-lg: 0.75rem;   /* 12px */

  /* Shadows */
  --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
  --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);

  /* Animation */
  --transition-fast: 150ms cubic-bezier(0.4, 0, 0.2, 1);
  --transition-normal: 300ms cubic-bezier(0.4, 0, 0.2, 1);
  --transition-slow: 500ms cubic-bezier(0.4, 0, 0.2, 1);
  --ease-spring: cubic-bezier(0.68, -0.55, 0.265, 1.55);
  --ease-grow: cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

/* 접근성 지원 */
@media (prefers-reduced-motion: reduce) {
  :root {
    --transition-fast: 0ms;
    --transition-normal: 0ms;
    --transition-slow: 0ms;
  }
}
```

---

## Testing Requirements

### Component Test Template

```typescript
// __tests__/components/plant/PlantView.test.tsx
import React from 'react';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import '@testing-library/jest-dom';
import { PlantView } from '../../../src/components/plant/PlantView';
import { PlantStage } from '../../../src/types/plant';

const mockPlantData = {
  id: 'test-plant-1',
  name: '테스트 식물',
  stage: PlantStage.SPROUT,
  growthPoints: 25,
  level: 2,
  lastGrowth: new Date('2025-09-14'),
  totalTodosCompleted: 5,
};

describe('PlantView Component', () => {
  it('식물 기본 정보가 올바르게 표시된다', () => {
    render(<PlantView plant={mockPlantData} />);

    expect(screen.getByText('테스트 식물')).toBeInTheDocument();
    expect(screen.getByText(/레벨 2/)).toBeInTheDocument();
    expect(screen.getByText(/성장 포인트: 25/)).toBeInTheDocument();
  });

  it('현재 성장 단계에 맞는 식물 이미지가 표시된다', () => {
    render(<PlantView plant={mockPlantData} />);

    const plantImage = screen.getByAltText(/테스트 식물/);
    expect(plantImage).toBeInTheDocument();
    expect(plantImage).toHaveAttribute('src', expect.stringContaining('sprout'));
  });

  it('스크린 리더용 aria-label이 올바르게 설정되어 있다', () => {
    render(<PlantView plant={mockPlantData} />);

    const plantContainer = screen.getByRole('img', { name: /테스트 식물/ });
    expect(plantContainer).toHaveAttribute('aria-label',
      expect.stringContaining('테스트 식물, 새싹 단계, 레벨 2')
    );
  });
});
```

### Testing Best Practices

**테스팅 우선순위 (1일 개발 제약)**:

1. **최우선**: 식물 성장 로직과 TODO 완료 플로우
2. **우선**: 접근성 관련 기본 테스트
3. **일반**: 컴포넌트 렌더링과 상태 관리
4. **낮음**: 에지 케이스와 성능 최적화 테스트

**테스트 카테고리별 목표 커버리지**:
- **Unit Tests**: 80% 목표
- **Integration Tests**: 70% 목표
- **E2E Tests**: 핵심 플로우만

---

## Environment Configuration

### Environment Variables

**기본 환경 설정 (.env)**:
```env
# API 설정
VITE_APP_NAME=GrowTogether TodoList
VITE_API_BASE_URL=http://localhost:8080
VITE_API_TIMEOUT=5000

# 식물 시스템 설정
VITE_PLANT_GROWTH_POINTS_PER_TODO=10
VITE_PLANT_MAX_STAGE=5
VITE_PLANT_ANIMATION_DURATION=1000

# 기능 플래그
VITE_ANIMATION_ENABLED=true
VITE_DEBUG_MODE=false
VITE_DEFAULT_USER_ID=default-user
VITE_APP_LOCALE=ko
```

**환경 설정 유틸리티**:
```typescript
// src/utils/env.ts
export class EnvConfig {
  static get apiBaseUrl(): string {
    return import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080';
  }

  static get plantConfig() {
    return {
      growthPointsPerTodo: parseInt(import.meta.env.VITE_PLANT_GROWTH_POINTS_PER_TODO) || 10,
      maxStage: parseInt(import.meta.env.VITE_PLANT_MAX_STAGE) || 5,
      animationDuration: parseInt(import.meta.env.VITE_PLANT_ANIMATION_DURATION) || 1000,
    };
  }

  static get isDevelopment(): boolean {
    return import.meta.env.DEV;
  }
}
```

---

## Frontend Developer Standards

### Critical Coding Rules

**AI와 개발자 모두를 위한 필수 규칙**:

1. **컴포넌트 생성 규칙**
   ```typescript
   // ✅ 올바른 방법
   export const PlantView: React.FC<PlantViewProps> = ({ plant, onGrow }) => {
     // 컴포넌트 로직
   };
   ```

2. **상태 업데이트 규칙**
   ```typescript
   // ✅ 불변성 유지
   setPlant(prevPlant => ({
     ...prevPlant,
     growthPoints: prevPlant.growthPoints + points
   }));
   ```

3. **에러 처리 필수**
   ```typescript
   const handleGrowth = async () => {
     try {
       await plantApi.growPlant(growthData);
     } catch (error) {
       console.error('Plant growth failed:', error);
       setErrorMessage('식물 성장에 실패했습니다.');
     }
   };
   ```

4. **접근성 필수 속성**
   ```tsx
   <button
     aria-label="식물 성장시키기"
     onClick={handleGrowth}
     disabled={isGrowing}
   >
     {isGrowing ? '성장 중...' : '성장하기'}
   </button>
   ```

### Quick Reference

**자주 사용하는 명령어**:
```bash
# 개발 서버 시작
npm run dev

# 테스트 실행
npm run test:watch

# 빌드
npm run build
```

**핵심 Import 패턴**:
```typescript
// 상태 관리
import { usePlant } from '../hooks/usePlant';
import { useTodos } from '../hooks/useTodos';

// API 호출
import { plantApi } from '../services/api/plantApi';

// 유틸리티
import { EnvConfig } from '../utils/env';
```

---

## Next Steps

이 프론트엔드 아키텍처 문서는 GrowTogether TodoList의 감정적 식물 동반자 시스템을 성공적으로 구현하기 위한 완전한 기술적 기반을 제공합니다.

**즉시 시작할 수 있는 다음 단계**:

1. **프로젝트 초기화**:
   ```bash
   npm create vite@latest frontend -- --template react-ts
   cd frontend
   npm install
   ```

2. **추가 의존성 설치**:
   ```bash
   npm install axios react-router-dom react-spring @headlessui/react
   npm install -D @testing-library/react @testing-library/jest-dom
   ```

3. **기본 폴더 구조 생성**: 본 문서의 프로젝트 구조를 따라 폴더 생성

4. **환경 변수 설정**: `.env` 파일들을 생성하고 기본 환경 설정 적용

5. **첫 번째 컴포넌트 구현**: `PlantView` 컴포넌트부터 시작하여 식물 동반자 시스템의 핵심 구현

이 아키텍처는 1일 개발 제약 내에서 5명의 개발자가 효율적으로 협업할 수 있도록 설계되었으며, 사용자에게 따뜻하고 감정적인 TodoList 경험을 제공할 것입니다.

---

*이 문서는 2025-09-14에 Winston (Architect)에 의해 작성되었으며, GrowTogether TodoList 프로젝트의 프론트엔드 구현을 위한 완전한 기술적 가이드라인을 제공합니다.*