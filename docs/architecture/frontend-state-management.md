# 프론트엔드 상태관리 설계 (Zustand)

## 개요

"감성적인 할일 목록" MVP를 위한 Zustand 기반 상태관리 설계입니다. 단순하고 효율적인 상태 관리로 하루 개발 목표에 맞춰 최소한의 복잡성으로 설계했습니다.

## 🗂️ 상태 구조

### 1. Todo Store (메인 상태)

```typescript
// src/stores/todoStore.ts
interface Todo {
  id: number;
  title: string;
  description: string | null;
  completed: boolean;
  priority: 'HIGH' | 'MEDIUM' | 'LOW';
  dueDate: string | null;
  createdAt: string;
  updatedAt: string;
}

interface TodoState {
  // 상태
  todos: Todo[];
  isLoading: boolean;
  error: string | null;

  // 액션
  fetchTodos: () => Promise<void>;
  addTodo: (todo: Omit<Todo, 'id' | 'completed' | 'createdAt' | 'updatedAt'>) => Promise<void>;
  toggleTodo: (id: number) => Promise<void>;
  updateTodo: (id: number, updates: Partial<Todo>) => Promise<void>;
  deleteTodo: (id: number) => Promise<void>;
  clearError: () => void;
}
```

### 2. Basil Store (감성 기능)

```typescript
// src/stores/basilStore.ts
interface BasilState {
  // 상태
  growthLevel: number;        // 0-100 (완료된 할일 수에 따라 성장)
  lastCompletedAt: string | null;  // 마지막 완료 시간
  totalCompleted: number;     // 총 완료된 할일 수

  // 액션
  growBasil: () => void;      // 할일 완료시 성장
  resetGrowth: () => void;    // 성장 초기화
  loadFromStorage: () => void; // 로컬스토리지에서 불러오기
  saveToStorage: () => void;   // 로컬스토리지에 저장
}
```

## 🏪 Store 구현

### Todo Store 구현

```typescript
// src/stores/todoStore.ts
import { create } from 'zustand';
import { todoService } from '../services/todoService';
import { useBasilStore } from './basilStore';

export const useTodoStore = create<TodoState>((set, get) => ({
  // 초기 상태
  todos: [],
  isLoading: false,
  error: null,

  // 할일 목록 조회
  fetchTodos: async () => {
    set({ isLoading: true, error: null });
    try {
      const todos = await todoService.getTodos();
      set({ todos, isLoading: false });
    } catch (error) {
      set({
        error: error instanceof Error ? error.message : '할일을 불러오는데 실패했습니다.',
        isLoading: false
      });
    }
  },

  // 할일 추가
  addTodo: async (todoData) => {
    set({ isLoading: true, error: null });
    try {
      const newTodo = await todoService.createTodo(todoData);
      set(state => ({
        todos: [...state.todos, newTodo],
        isLoading: false
      }));
    } catch (error) {
      set({
        error: error instanceof Error ? error.message : '할일 추가에 실패했습니다.',
        isLoading: false
      });
    }
  },

  // 할일 완료 토글
  toggleTodo: async (id) => {
    set({ error: null });
    try {
      const updatedTodo = await todoService.toggleTodo(id);

      set(state => ({
        todos: state.todos.map(todo =>
          todo.id === id ? updatedTodo : todo
        )
      }));

      // 완료된 경우 바질 성장
      if (updatedTodo.completed) {
        useBasilStore.getState().growBasil();
      }
    } catch (error) {
      set({
        error: error instanceof Error ? error.message : '할일 상태 변경에 실패했습니다.'
      });
    }
  },

  // 할일 수정
  updateTodo: async (id, updates) => {
    set({ error: null });
    try {
      const updatedTodo = await todoService.updateTodo(id, updates);
      set(state => ({
        todos: state.todos.map(todo =>
          todo.id === id ? updatedTodo : todo
        )
      }));
    } catch (error) {
      set({
        error: error instanceof Error ? error.message : '할일 수정에 실패했습니다.'
      });
    }
  },

  // 할일 삭제
  deleteTodo: async (id) => {
    set({ error: null });
    try {
      await todoService.deleteTodo(id);
      set(state => ({
        todos: state.todos.filter(todo => todo.id !== id)
      }));
    } catch (error) {
      set({
        error: error instanceof Error ? error.message : '할일 삭제에 실패했습니다.'
      });
    }
  },

  // 에러 클리어
  clearError: () => set({ error: null })
}));
```

### Basil Store 구현

```typescript
// src/stores/basilStore.ts
import { create } from 'zustand';

const STORAGE_KEY = 'emotional-todo-basil';

export const useBasilStore = create<BasilState>((set, get) => ({
  // 초기 상태
  growthLevel: 0,
  lastCompletedAt: null,
  totalCompleted: 0,

  // 바질 성장 (할일 완료시)
  growBasil: () => {
    set(state => {
      const newState = {
        growthLevel: Math.min(state.growthLevel + 10, 100), // 최대 100
        lastCompletedAt: new Date().toISOString(),
        totalCompleted: state.totalCompleted + 1
      };

      // 로컬스토리지에 저장
      localStorage.setItem(STORAGE_KEY, JSON.stringify(newState));

      return newState;
    });
  },

  // 성장 초기화
  resetGrowth: () => {
    const resetState = {
      growthLevel: 0,
      lastCompletedAt: null,
      totalCompleted: 0
    };
    set(resetState);
    localStorage.setItem(STORAGE_KEY, JSON.stringify(resetState));
  },

  // 로컬스토리지에서 불러오기
  loadFromStorage: () => {
    try {
      const stored = localStorage.getItem(STORAGE_KEY);
      if (stored) {
        const data = JSON.parse(stored);
        set(data);
      }
    } catch (error) {
      console.warn('바질 데이터 로드 실패:', error);
    }
  },

  // 로컬스토리지에 저장
  saveToStorage: () => {
    const state = get();
    localStorage.setItem(STORAGE_KEY, JSON.stringify({
      growthLevel: state.growthLevel,
      lastCompletedAt: state.lastCompletedAt,
      totalCompleted: state.totalCompleted
    }));
  }
}));
```

## 🔌 Store 사용 예시

### 컴포넌트에서 사용

```typescript
// src/components/TodoList.tsx
import { useTodoStore } from '../stores/todoStore';
import { useBasilStore } from '../stores/basilStore';
import { useEffect } from 'react';

export const TodoList: React.FC = () => {
  const {
    todos,
    isLoading,
    error,
    fetchTodos,
    toggleTodo,
    clearError
  } = useTodoStore();

  const { growthLevel, loadFromStorage } = useBasilStore();

  // 컴포넌트 마운트 시 데이터 로드
  useEffect(() => {
    fetchTodos();
    loadFromStorage();
  }, [fetchTodos, loadFromStorage]);

  if (isLoading) return <div>로딩 중...</div>;

  if (error) {
    return (
      <div className="error">
        <p>{error}</p>
        <button onClick={clearError}>확인</button>
      </div>
    );
  }

  return (
    <div>
      <div className="basil-status">
        바질 성장도: {growthLevel}%
      </div>

      <ul className="todo-list">
        {todos.map(todo => (
          <li key={todo.id}>
            <input
              type="checkbox"
              checked={todo.completed}
              onChange={() => toggleTodo(todo.id)}
            />
            <span className={todo.completed ? 'completed' : ''}>
              {todo.title}
            </span>
          </li>
        ))}
      </ul>
    </div>
  );
};
```

### 할일 추가 폼

```typescript
// src/components/TodoForm.tsx
import { useState } from 'react';
import { useTodoStore } from '../stores/todoStore';

export const TodoForm: React.FC = () => {
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const { addTodo, isLoading } = useTodoStore();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!title.trim()) return;

    await addTodo({
      title: title.trim(),
      description: description.trim() || null,
      priority: 'MEDIUM',
      dueDate: null
    });

    // 성공시 폼 리셋
    setTitle('');
    setDescription('');
  };

  return (
    <form onSubmit={handleSubmit} className="todo-form">
      <input
        type="text"
        value={title}
        onChange={(e) => setTitle(e.target.value)}
        placeholder="할일을 입력하세요..."
        disabled={isLoading}
        required
      />

      <textarea
        value={description}
        onChange={(e) => setDescription(e.target.value)}
        placeholder="설명 (선택사항)"
        disabled={isLoading}
      />

      <button type="submit" disabled={isLoading || !title.trim()}>
        {isLoading ? '추가 중...' : '할일 추가'}
      </button>
    </form>
  );
};
```

## 🎯 감성 기능 구현

### 격려 메시지 표시

```typescript
// src/components/EncouragementMessage.tsx
import { useEffect, useState } from 'react';
import { useTodoStore } from '../stores/todoStore';

const ENCOURAGEMENT_MESSAGES = [
  "오늘도 고생하셨습니다! 🌿",
  "작은 성취도 큰 의미가 있어요 ✨",
  "한 걸음씩 나아가고 있어요 🌱",
  "정말 대단해요! 계속 화이팅! 💪",
  "오늘의 나를 칭찬해주세요 🎉"
];

export const EncouragementMessage: React.FC = () => {
  const { todos } = useTodoStore();
  const [message, setMessage] = useState('');
  const [showMessage, setShowMessage] = useState(false);

  // 할일 완료 감지
  useEffect(() => {
    const completedCount = todos.filter(todo => todo.completed).length;
    const lastCompleted = localStorage.getItem('lastCompletedCount');

    if (lastCompleted && completedCount > parseInt(lastCompleted)) {
      // 새로 완료된 할일이 있으면 메시지 표시
      const randomMessage = ENCOURAGEMENT_MESSAGES[
        Math.floor(Math.random() * ENCOURAGEMENT_MESSAGES.length)
      ];
      setMessage(randomMessage);
      setShowMessage(true);

      // 3초 후 메시지 숨김
      setTimeout(() => setShowMessage(false), 3000);
    }

    localStorage.setItem('lastCompletedCount', completedCount.toString());
  }, [todos]);

  if (!showMessage) return null;

  return (
    <div className="encouragement-message">
      <p>{message}</p>
    </div>
  );
};
```

### 바질 화분 컴포넌트

```typescript
// src/components/BasilPlant.tsx
import { useBasilStore } from '../stores/basilStore';

export const BasilPlant: React.FC = () => {
  const { growthLevel, totalCompleted } = useBasilStore();

  const getBasilStage = (level: number) => {
    if (level < 20) return '🌱'; // 새싹
    if (level < 50) return '🌿'; // 작은 잎
    if (level < 80) return '🍃'; // 큰 잎
    return '🌳'; // 완전한 나무
  };

  return (
    <div className="basil-container">
      <div className="basil-plant">
        <div className="plant-icon">
          {getBasilStage(growthLevel)}
        </div>
        <div className="growth-bar">
          <div
            className="growth-fill"
            style={{ width: `${growthLevel}%` }}
          />
        </div>
      </div>

      <div className="basil-info">
        <p>성장도: {growthLevel}%</p>
        <p>완료한 할일: {totalCompleted}개</p>
      </div>
    </div>
  );
};
```

## 📱 앱 초기화

```typescript
// src/App.tsx
import { useEffect } from 'react';
import { useBasilStore } from './stores/basilStore';
import { useTodoStore } from './stores/todoStore';

export const App: React.FC = () => {
  const { loadFromStorage } = useBasilStore();
  const { fetchTodos } = useTodoStore();

  useEffect(() => {
    // 앱 시작시 데이터 로드
    loadFromStorage();
    fetchTodos();
  }, []);

  return (
    <div className="app">
      {/* 컴포넌트들 */}
    </div>
  );
};
```

---

**MVP 특징**:
- 사용자 인증 없음 (로컬 전용)
- 간단한 에러 처리
- 로컬스토리지로 감성 데이터 유지
- 최소한의 상태로 빠른 개발 가능