# 9. Quality Assurance

## 9.1. Security and Performance
**Security Requirements**
- Backend: Input Validation, Password Hashing (BCrypt), JWT Auth, CORS
- Frontend: Secure Token Storage (HttpOnly Cookie), Env Var Scoping

**Performance Optimization**
- Frontend: Code Splitting, Image Optimization, Bundle Size Target (<200KB)
- Backend: Response Time Target (<200ms), DB Indexing, Connection Pooling

## 9.2. Testing Strategy
**Testing Pyramid**
```text
      /------------------\
     /   E2E Tests      \
    /--------------------
   /  Integration Tests   \
  /------------------------\ 
 /       Unit Tests         \
/----------------------------\ 
```
**Test Organization**
- FE: Co-location for unit, feature-based for integration
- BE: Mirrored package structure in `src/test/java`
- E2E: Root `/e2e` directory

---
