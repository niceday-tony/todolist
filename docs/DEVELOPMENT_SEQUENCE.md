# 개발 실행 순서 가이드

## 🎯 전체 개발 순서 (1일 내 완료 목표)

### ⚡ **필수 실행 순서 (변경 불가)**

```
Story 1.1 → Story 1.2 → Story 1.3 → Story 1.4 → Story 1.5
(기반)     (TODO)     (식물)     (애니메이션)  (UI통합)
```

**중요**: 각 스토리는 이전 스토리가 100% 완료된 후에만 시작 가능

---

## 📋 **Story 1.1: Foundation & Database Setup** (2시간)

### 🔧 **구현 순서 (엄격한 순서 준수 필수)**

#### **Phase 1: 백엔드 기반 설정** (45분)
1. **MySQL 컨테이너 시작**
   ```bash
   docker-compose up -d mysql
   # 확인: docker ps | grep todolist-mysql
   ```

2. **Spring Boot 프로젝트 생성**
   ```bash
   # Spring Initializr 사용
   # Dependencies: Web, Data JPA, MySQL Driver, Validation
   ```

3. **application.yml 설정**
   ```yaml
   spring:
     datasource:
       url: jdbc:mysql://localhost:3306/todolist
       username: root
       password: root
     jpa:
       hibernate:
         ddl-auto: create-drop
       show-sql: true
   ```

4. **데이터베이스 연결 테스트**
   ```bash
   mvn spring-boot:run
   # 로그 확인: "HikariPool-1 - Start completed"
   ```

#### **Phase 2: JPA 엔티티 생성** (30분)
5. **BaseEntity.java** (공통 필드)
6. **Plant.java** (식물 엔티티)
7. **Todo.java** (할일 엔티티 + Plant 참조)
8. **애플리케이션 재시작 → 테이블 생성 확인**

#### **Phase 3: 프론트엔드 기반 설정** (30분)
9. **React 프로젝트 생성**
   ```bash
   npm create vite@latest frontend -- --template react-ts
   cd frontend && npm install
   ```

10. **추가 의존성 설치**
    ```bash
    npm install axios react-router-dom
    ```

#### **Phase 4: 통합 테스트** (15분)
11. **Health Controller 생성**
    ```java
    @GetMapping("/api/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("OK");
    }
    ```

12. **CORS 설정**
13. **프론트엔드에서 백엔드 호출 테스트**
14. **완료 확인**: 양쪽 서버 동시 실행 + API 호출 성공

---

## 📝 **Story 1.2: Basic TODO Management** (1.5시간)

### 🔧 **구현 순서 (계층별 순서 준수)**

#### **Phase 1: DTO 클래스** (15분)
1. **TodoCreateRequest.java**
2. **TodoUpdateRequest.java**
3. **TodoResponse.java**

#### **Phase 2: 데이터 액세스 계층** (20분)
4. **TodoRepository.java** (JPA Repository)
   - findByPlantIdOrderByCreatedAtDesc()
   - countByPlantIdAndCompleted()

#### **Phase 3: 비즈니스 로직 계층** (25분)
5. **TodoService.java**
   - createTodo()
   - getTodosByPlant()
   - updateTodo()
   - deleteTodo()
   - **completeTodo()** (Story 1.3에서 확장)

#### **Phase 4: 컨트롤러 계층** (20분)
6. **TodoController.java**
   - POST /api/todos
   - GET /api/todos
   - PUT /api/todos/{id}
   - DELETE /api/todos/{id}
   - **PATCH /api/todos/{id}/complete**

#### **Phase 5: 프론트엔드 구현** (30분)
7. **TodoService.ts** (API 호출)
8. **useTodos.ts** (React Hook)
9. **TodoList.tsx**
10. **TodoItem.tsx**
11. **TodoForm.tsx**

---

## 🌱 **Story 1.3: Plant Companion System** (2시간)

### 🔧 **구현 순서 (로직부터 UI까지)**

#### **Phase 1: 성장 로직 설계** (30분)
1. **PlantStage.java** (Enum)
2. **PlantGrowthService.java** (성장 계산)
3. **성장 알고리즘 테스트**

#### **Phase 2: 식물 서비스 구현** (40분)
4. **PlantRepository.java**
5. **PlantService.java**
   - growPlant()
   - calculateStage()
   - getProgressToNextStage()

#### **Phase 3: API 엔드포인트** (25분)
6. **PlantController.java**
7. **PlantResponse.java** DTO

#### **Phase 4: TODO-Plant 통합** (30분)
8. **TodoService.completeTodo() 확장**
   - @Transactional 추가
   - PlantService.growPlant() 호출
   - TodoCompletionResponse 반환

#### **Phase 5: 프론트엔드 식물 표시** (15분)
9. **Plant 타입 정의**
10. **usePlant.ts** Hook
11. **PlantView.tsx** (기본 표시)

---

## ✨ **Story 1.4: Growth Animation & Feedback** (1.5시간)

### 🔧 **구현 순서 (CSS부터 React까지)**

#### **Phase 1: CSS 애니메이션** (30분)
1. **plant-animations.css**
   - @keyframes plantGrowth
   - @keyframes stageTransition
   - @keyframes progressGrow

#### **Phase 2: 메시지 시스템** (20분)
2. **CelebrationMessages.ts**
3. **메시지 선택 로직**

#### **Phase 3: React 애니메이션 훅** (40분)
4. **useGrowthAnimation.ts**
5. **애니메이션 시퀀싱 로직**
6. **상태 관리**

#### **Phase 4: 컴포넌트 통합** (20분)
7. **PlantView.tsx 애니메이션 통합**
8. **TodoList에서 애니메이션 트리거**
9. **접근성 지원**

---

## 🎨 **Story 1.5: Integrated Dashboard UI** (1.5시간)

### 🔧 **구현 순서 (디자인 시스템부터 통합까지)**

#### **Phase 1: 디자인 시스템** (25분)
1. **design-tokens.css** (CSS 커스텀 프로퍼티)
2. **base.css** (리셋 + 기본 스타일)

#### **Phase 2: 레이아웃 컴포넌트** (30분)
3. **Dashboard.tsx** (메인 레이아웃)
4. **dashboard.css** (반응형 그리드)

#### **Phase 3: 시각적 연결** (20분)
5. **connection-effects.css**
6. **PlantStats.tsx** (식물 정보 표시)

#### **Phase 4: 접근성 & 최적화** (15분)
7. **ARIA 라벨 추가**
8. **키보드 내비게이션**
9. **성능 최적화**

---

## ⚠️ **의존성 규칙 (절대 위반 금지)**

### **백엔드 의존성**
```
Entity → Repository → Service → Controller
```

### **프론트엔드 의존성**
```
Types → Services → Hooks → Components
```

### **스토리 의존성**
```
Foundation → TODO → Plant → Animation → UI
```

---

## 🧪 **각 Phase 완료 확인 방법**

### **Phase 완료 체크리스트**
- [ ] 컴파일 에러 없음
- [ ] 테스트 통과
- [ ] 브라우저 콘솔 에러 없음
- [ ] 다음 Phase 시작 가능한 상태

### **Story 완료 체크리스트**
- [ ] 모든 Acceptance Criteria 충족
- [ ] Definition of Done 체크리스트 완료
- [ ] 다음 Story의 Blocking Dependencies 해결됨

---

## 🚨 **Critical 실패 시나리오 & 해결**

### **MySQL 연결 실패**
```bash
# 해결: 컨테이너 재시작
docker-compose down && docker-compose up -d mysql
```

### **JPA 엔티티 오류**
```bash
# 해결: 스키마 초기화
spring.jpa.hibernate.ddl-auto: create-drop
```

### **CORS 오류**
```java
// 해결: CORS 설정 추가
@CrossOrigin(origins = "http://localhost:3000")
```

### **React 빌드 실패**
```bash
# 해결: 의존성 재설치
rm -rf node_modules package-lock.json
npm install
```

---

## ⏱️ **시간 분배 가이드 (총 8시간)**

- **Story 1.1**: 2시간 (25%)
- **Story 1.2**: 1.5시간 (19%)
- **Story 1.3**: 2시간 (25%)
- **Story 1.4**: 1.5시간 (19%)
- **Story 1.5**: 1시간 (12%)

**중요**: 각 스토리 완료 후 15분 휴식 권장