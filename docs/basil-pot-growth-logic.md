# 바질 화분 성장 로직 명세

## 📋 개요
사용자가 할 일을 완료할 때마다 바질 화분이 성장하는 시스템

## 🌱 성장 단계 정의

### 레벨 시스템
총 10단계의 성장 레벨로 구성됩니다.

| 레벨 | 단계명 | 필요 경험치 | 시각적 상태 |
|------|--------|------------|------------|
| 1 | 씨앗 | 0 | 작은 화분에 흙만 있음 |
| 2 | 새싹 | 3 | 작은 초록 싹이 나옴 |
| 3 | 어린 잎 | 7 | 2-3개의 작은 잎 |
| 4 | 작은 바질 | 12 | 5-6개의 잎, 줄기 형성 |
| 5 | 성장중 | 18 | 10개 이상의 잎, 줄기가 굵어짐 |
| 6 | 무성함 | 25 | 풍성한 잎, 가지가 나옴 |
| 7 | 개화 준비 | 33 | 꽃봉오리가 보이기 시작 |
| 8 | 개화 | 42 | 작은 흰색/보라색 꽃이 피어남 |
| 9 | 만개 | 52 | 꽃이 만개하고 향기가 남 |
| 10 | 완성 | 63 | 무지개 빛 효과와 함께 완성된 바질 |

### 경험치 시스템
- **기본 경험치**: 할 일 완료 시 +1 EXP
- **연속 완료 보너스**:
  - 3개 연속 완료: +1 보너스 EXP
  - 5개 연속 완료: +2 보너스 EXP
  - 10개 연속 완료: +3 보너스 EXP

### 성장 공식
```javascript
// 다음 레벨까지 필요한 총 경험치
function getRequiredExp(level) {
  if (level === 1) return 3;
  return Math.floor(level * 2.5 + level - 1);
}

// 현재 레벨 진행률 (%)
function getLevelProgress(currentExp, currentLevel) {
  const required = getRequiredExp(currentLevel);
  const nextRequired = getRequiredExp(currentLevel + 1);
  const levelExp = currentExp - required;
  const levelRange = nextRequired - required;
  return Math.floor((levelExp / levelRange) * 100);
}
```

## 🎨 시각적 피드백

### 레벨업 시 애니메이션
1. **반짝임 효과**: 2초간 황금빛 파티클이 화분 주변에서 터짐
2. **성장 애니메이션**: 0.5초간 화분이 살짝 커졌다가 원래 크기로 돌아옴
3. **레벨업 메시지**: "레벨 {n}! {단계명}으로 성장했어요! 🌱"

### 할 일 완료 시 애니메이션
1. **물뿌리기 효과**: 작은 물방울 애니메이션
2. **잎 흔들림**: 바질 잎이 살랑살랑 흔들림
3. **+EXP 표시**: 화분 위에 "+1 EXP" 텍스트가 위로 올라가며 사라짐

## 💾 데이터 저장 구조

### Backend (MySQL)
```sql
CREATE TABLE basil_pots (
  id BIGINT NOT NULL AUTO_INCREMENT,
  user_id BIGINT NOT NULL DEFAULT 1, -- MVP는 단일 사용자
  level INT NOT NULL DEFAULT 1,
  experience INT NOT NULL DEFAULT 0,
  total_todos_completed INT NOT NULL DEFAULT 0,
  streak_count INT NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY unique_user (user_id)
);
```

### Frontend State (Zustand)
```typescript
interface BasilPotState {
  level: number;
  experience: number;
  levelProgress: number; // 0-100%
  isAnimating: boolean;
  lastAnimation: 'levelup' | 'growth' | null;
}

interface BasilPotActions {
  addExperience: (amount: number) => void;
  checkLevelUp: () => boolean;
  triggerAnimation: (type: 'levelup' | 'growth') => void;
  loadFromServer: () => Promise<void>;
}
```

## 🔄 상태 동기화

### 할 일 완료 시 플로우
1. Frontend: 할 일 완료 버튼 클릭
2. Backend API 호출: `PUT /api/todos/{id}/toggle`
3. Backend:
   - Todo 상태 업데이트
   - BasilPot 경험치 증가
   - 레벨업 체크
4. Response: 업데이트된 BasilPot 상태 포함
5. Frontend:
   - 상태 업데이트
   - 애니메이션 트리거
   - 격려 메시지 표시

## 🎮 향후 확장 가능성 (Post-MVP)
- 특별한 날 이벤트 (2배 경험치)
- 다양한 식물 종류 선택
- 친구와 화분 성장 비교
- 월별 성장 리포트
- 시즌별 특별 화분 스킨