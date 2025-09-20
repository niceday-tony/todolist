# 10. Standards & Policies

## 10.1. Coding Standards
**Critical Rules**
- Hexagonal Architecture Adherence
- DTO Usage in Controllers
- Service Layer Responsibility
- Configuration via Environment Variables
- Immutability

**Naming Conventions**
(Table as defined before)

## 10.2. Error Handling Strategy
**Error Response Format**
```typescript
interface ApiError {
  error: {
    code: string;
    message: string;
    // ...
  };
}
```
**Backend Error Handling**
- Use of `@RestControllerAdvice` for global exception handling.

---
