# 코딩 표준 및 컨벤션 가이드

## 개요

이 문서는 "감성적인 할일 목록" 프로젝트의 모든 개발자가 따라야 할 코딩 표준과 컨벤션을 정의합니다. 5명의 개발자(백엔드 4명, 프론트엔드 1명)가 AI와 협업하면서 일관성 있는 코드를 작성할 수 있도록 가이드라인을 제공합니다.

## 일반 원칙

### 1. 코드 가독성
- 변수명과 함수명은 한국어 주석과 함께 영어로 작성
- 주석은 한국어로 작성하되, 기술적 용어는 영어 병기
- Self-documenting code 작성을 지향

### 2. 일관성
- 팀 전체가 동일한 포맷터와 린터 설정 사용
- Git commit message는 한국어로 작성
- 브랜치 명명 규칙 준수

## 백엔드 (Spring Boot) 코딩 표준

### 1. Java 코딩 컨벤션

#### 패키지 구조
```
com.todolist
├── controller/     # REST API 컨트롤러
├── service/        # 비즈니스 로직
├── repository/     # 데이터 액세스 레이어
├── entity/         # JPA 엔티티
├── dto/            # 데이터 전송 객체
├── config/         # 설정 클래스
└── exception/      # 예외 처리
```

#### 명명 규칙
- **클래스명**: PascalCase (예: `TodoController`, `UserService`)
- **메서드명**: camelCase (예: `getTodoList`, `createTodo`)
- **변수명**: camelCase (예: `todoId`, `userName`)
- **상수명**: UPPER_SNAKE_CASE (예: `MAX_TODO_COUNT`)

#### 어노테이션 규칙
```java
// 컨트롤러 예시
@RestController
@RequestMapping("/api/todos")
@Slf4j
public class TodoController {

    @GetMapping
    public ResponseEntity<List<TodoDto>> getTodos() {
        // 할일 목록 조회 로직
        return ResponseEntity.ok(todoService.getAllTodos());
    }
}
```

### 2. 데이터베이스 규칙

#### 테이블 명명
- 소문자 + 언더스코어 사용 (예: `todo_items`, `user_accounts`)
- 복수형 사용

#### 컬럼 명명
- 소문자 + 언더스코어 사용 (예: `created_at`, `updated_at`)
- ID 컬럼은 `테이블명_id` 형식 (예: `todo_id`, `user_id`)

### 3. API 설계 규칙

#### REST 엔드포인트 패턴
```
GET    /api/todos           # 할일 목록 조회
POST   /api/todos           # 할일 생성
GET    /api/todos/{id}      # 특정 할일 조회
PUT    /api/todos/{id}      # 할일 수정
DELETE /api/todos/{id}      # 할일 삭제
```

#### HTTP 상태 코드 사용
- `200 OK`: 성공적인 GET, PUT 요청
- `201 Created`: 성공적인 POST 요청
- `204 No Content`: 성공적인 DELETE 요청
- `400 Bad Request`: 잘못된 요청
- `404 Not Found`: 리소스를 찾을 수 없음
- `500 Internal Server Error`: 서버 오류

## 프론트엔드 (Next.js) 코딩 표준

### 1. TypeScript 컨벤션

#### 파일 구조
```
src/
├── components/         # 재사용 가능한 컴포넌트
├── pages/             # Next.js 페이지
├── hooks/             # 커스텀 훅
├── services/          # API 호출 서비스
├── types/             # TypeScript 타입 정의
├── utils/             # 유틸리티 함수
└── styles/            # 스타일 파일
```

#### 명명 규칙
- **컴포넌트 파일**: PascalCase (예: `TodoItem.tsx`, `TodoList.tsx`)
- **훅 파일**: camelCase with 'use' prefix (예: `useTodos.ts`)
- **서비스 파일**: camelCase (예: `todoService.ts`)
- **타입 파일**: PascalCase (예: `Todo.ts`, `User.ts`)

### 2. React 컴포넌트 규칙

#### 함수형 컴포넌트 작성
```typescript
// TodoItem.tsx
interface TodoItemProps {
  todo: Todo;
  onUpdate: (todo: Todo) => void;
  onDelete: (id: string) => void;
}

export const TodoItem: React.FC<TodoItemProps> = ({
  todo,
  onUpdate,
  onDelete
}) => {
  // 할일 아이템 컴포넌트 로직
  return (
    <div className="todo-item">
      {/* JSX 내용 */}
    </div>
  );
};
```

#### 커스텀 훅 작성
```typescript
// useTodos.ts
export const useTodos = () => {
  const [todos, setTodos] = useState<Todo[]>([]);
  const [loading, setLoading] = useState(false);

  // 훅 로직

  return {
    todos,
    loading,
    addTodo,
    updateTodo,
    deleteTodo
  };
};
```

### 3. 스타일링 규칙

#### CSS Modules 사용
```css
/* TodoItem.module.css */
.todoItem {
  padding: 1rem;
  border: 1px solid #e1e5e9;
  border-radius: 0.5rem;
}

.todoItem--completed {
  opacity: 0.6;
  text-decoration: line-through;
}
```

## Git 워크플로우 및 커밋 컨벤션

### 1. 브랜치 전략

#### 브랜치 명명 규칙
- `feature/기능명`: 새로운 기능 개발
- `fix/버그명`: 버그 수정
- `refactor/리팩토링명`: 코드 리팩토링
- `docs/문서명`: 문서 업데이트

예시:
- `feature/todo-crud`
- `fix/api-error-handling`
- `refactor/component-structure`

### 2. 커밋 메시지 컨벤션

#### 기본 형식
```
타입: 제목 (50자 이내)

본문 (선택사항)
- 변경 이유 설명
- 영향받는 부분 명시

푸터 (선택사항)
- 이슈 번호 참조
```

#### 타입 종류
- `feat`: 새로운 기능 추가
- `fix`: 버그 수정
- `refactor`: 코드 리팩토링
- `style`: 코드 포맷팅, 세미콜론 누락 등
- `docs`: 문서 수정
- `test`: 테스트 코드 추가/수정
- `chore`: 빌드 업무 수정, 패키지 매니저 수정 등

#### 예시
```
feat: 할일 목록 CRUD API 구현

- TodoController에 GET, POST, PUT, DELETE 엔드포인트 추가
- TodoService 비즈니스 로직 구현
- TodoRepository JPA 인터페이스 정의

관련 이슈: #12
```

## 코드 품질 관리

### 1. 린팅 및 포맷팅

#### 백엔드 (Java)
- Google Java Style Guide 사용
- Checkstyle 설정
- SonarLint 플러그인 활용

#### 프론트엔드 (TypeScript)
- ESLint + Prettier 조합
- Airbnb TypeScript Style Guide 기반
- 저장 시 자동 포맷팅 설정

### 2. 코드 리뷰 가이드라인

#### 리뷰 체크 포인트
- [ ] 코딩 컨벤션 준수
- [ ] 비즈니스 로직 정확성
- [ ] 예외 처리 적절성
- [ ] 테스트 코드 포함 여부
- [ ] 성능 이슈 확인
- [ ] 보안 취약점 점검

#### AI와의 협업 시 주의사항
- AI가 생성한 코드도 반드시 코드 리뷰 진행
- 비즈니스 로직의 정확성을 수동으로 검증
- 보안 관련 코드는 특별히 주의 깊게 검토

## AI 협업 가이드라인

### 1. AI 활용 원칙
- AI는 코드 생성 도구로 활용, 최종 책임은 개발자
- 생성된 코드는 반드시 검토 후 적용
- 비즈니스 로직의 정확성은 개발자가 검증

### 2. 프롬프트 작성 가이드
- 구체적이고 명확한 요구사항 제시
- 기존 코드 컨벤션 명시
- 예상되는 입출력 예시 제공

### 3. 코드 생성 후 체크리스트
- [ ] 컨벤션 준수 확인
- [ ] 비즈니스 로직 검증
- [ ] 테스트 코드 작성
- [ ] 문서 업데이트

---

*이 문서는 프로젝트 진행에 따라 지속적으로 업데이트됩니다.*