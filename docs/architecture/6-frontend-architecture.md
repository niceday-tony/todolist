# 6. Frontend Architecture

## 6.1. Component Architecture
### Component Organization
```text
src/
├── components/
├── features/
└── pages/
```
### Component Template
```typescript
const MyComponent: React.FC<MyComponentProps> = ({ title }) => {
  // ...
};
```

## 6.2. State Management Architecture
### State Structure
```typescript
const useAppStore = create<TodoSlice & BasilPotSlice>()((set) => ({
  // ...
}));
```
### State Management Patterns
- Single Source of Truth
- Slice Pattern
- Selectors for Performance
- Async Actions in Hooks

## 6.3. Routing Architecture
### Route Organization
```text
src/app/
├── layout.tsx
├── page.tsx
├── login/
│   └── page.tsx
└── signup/
    └── page.tsx
```
### Protected Route Pattern
```typescript
// middleware.ts
export function middleware(request: NextRequest) {
  // ...
}
```

## 6.4. Frontend Services Layer
### API Client Setup
```typescript
// src/lib/apiClient.ts
const apiClient = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8080/api',
  // ...
});
```
### Service Example
```typescript
// src/features/todo/services/todoService.ts
export const getTodos = async (): Promise<Todo[]> => {
  // ...
};
```

---
