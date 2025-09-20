# API 명세서 - 감성적인 할일 목록

**Base URL**: `http://localhost:8080/api`

## 📝 Todo CRUD APIs

### 1. 할일 목록 조회
```http
GET /api/todos
```

**Response (200 OK):**
```json
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "title": "프로젝트 설계",
      "description": "아키텍처 문서 작성",
      "completed": false,
      "priority": "HIGH",
      "dueDate": "2024-09-25",
      "createdAt": "2024-09-20T10:00:00Z",
      "updatedAt": "2024-09-20T10:00:00Z"
    }
  ]
}
```

### 2. 할일 생성
```http
POST /api/todos
Content-Type: application/json

{
  "title": "새로운 할일",
  "description": "할일 설명 (선택사항)",
  "priority": "MEDIUM",
  "dueDate": "2024-09-25"
}
```

**Response (201 Created):**
```json
{
  "status": "success",
  "data": {
    "id": 2,
    "title": "새로운 할일",
    "description": "할일 설명 (선택사항)",
    "completed": false,
    "priority": "MEDIUM",
    "dueDate": "2024-09-25",
    "createdAt": "2024-09-20T10:30:00Z",
    "updatedAt": "2024-09-20T10:30:00Z"
  },
  "message": "할일이 성공적으로 생성되었습니다."
}
```

### 3. 할일 완료 토글
```http
PUT /api/todos/{id}/toggle
```

**Response (200 OK):**
```json
{
  "status": "success",
  "data": {
    "id": 1,
    "title": "프로젝트 설계",
    "description": "아키텍처 문서 작성",
    "completed": true,
    "priority": "HIGH",
    "dueDate": "2024-09-25",
    "createdAt": "2024-09-20T10:00:00Z",
    "updatedAt": "2024-09-20T10:35:00Z"
  },
  "message": "할일 상태가 변경되었습니다."
}
```

### 4. 할일 수정
```http
PUT /api/todos/{id}
Content-Type: application/json

{
  "title": "수정된 할일",
  "description": "수정된 설명",
  "priority": "LOW",
  "dueDate": "2024-09-26"
}
```

**Response (200 OK):**
```json
{
  "status": "success",
  "data": {
    "id": 1,
    "title": "수정된 할일",
    "description": "수정된 설명",
    "completed": false,
    "priority": "LOW",
    "dueDate": "2024-09-26",
    "createdAt": "2024-09-20T10:00:00Z",
    "updatedAt": "2024-09-20T10:40:00Z"
  },
  "message": "할일이 성공적으로 수정되었습니다."
}
```

### 5. 할일 삭제
```http
DELETE /api/todos/{id}
```

**Response (200 OK):**
```json
{
  "status": "success",
  "message": "할일이 성공적으로 삭제되었습니다."
}
```

## 🎉 격려 메시지 API (선택사항)

### 랜덤 격려 메시지 조회
```http
GET /api/messages/encouragement
```

**Response (200 OK):**
```json
{
  "status": "success",
  "data": {
    "message": "오늘도 고생하셨습니다! 🌿",
    "category": "completion"
  }
}
```

## ❌ 에러 응답 형식

### 400 Bad Request
```json
{
  "status": "error",
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "입력 데이터가 올바르지 않습니다.",
    "details": {
      "title": "제목은 필수입니다."
    }
  },
  "timestamp": "2024-09-20T10:00:00Z"
}
```

### 404 Not Found
```json
{
  "status": "error",
  "error": {
    "code": "TODO_NOT_FOUND",
    "message": "요청한 할일을 찾을 수 없습니다.",
    "details": {
      "todoId": 999
    }
  },
  "timestamp": "2024-09-20T10:00:00Z"
}
```

### 500 Internal Server Error
```json
{
  "status": "error",
  "error": {
    "code": "INTERNAL_SERVER_ERROR",
    "message": "서버 내부 오류가 발생했습니다."
  },
  "timestamp": "2024-09-20T10:00:00Z"
}
```

## 🏷️ 데이터 타입 정의

### Priority 열거형
- `HIGH`: 높음
- `MEDIUM`: 보통
- `LOW`: 낮음

### TodoRequest (생성/수정)
```typescript
interface TodoRequest {
  title: string;        // 필수, 1-255자
  description?: string; // 선택사항, 최대 1000자
  priority?: 'HIGH' | 'MEDIUM' | 'LOW'; // 기본값: MEDIUM
  dueDate?: string;     // ISO 8601 날짜 형식
}
```

### TodoResponse
```typescript
interface TodoResponse {
  id: number;
  title: string;
  description: string | null;
  completed: boolean;
  priority: 'HIGH' | 'MEDIUM' | 'LOW';
  dueDate: string | null;  // ISO 8601 날짜 형식
  createdAt: string;       // ISO 8601 datetime 형식
  updatedAt: string;       // ISO 8601 datetime 형식
}
```

---

**참고**: 이 API는 MVP 버전이므로 사용자 인증, 복잡한 권한 관리 등은 포함되지 않습니다.