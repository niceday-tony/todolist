# 8. Development & Operations

## 8.1. Development Workflow
### Prerequisites
```bash
# Java 17, Node.js 18, Docker
```
### Initial Setup
```bash
# docker-compose up, npm install, ./gradlew build
```
### Development Commands
```bash
# ./gradlew bootRun
# npm run dev
```

## 8.2. Environment Configuration
**Backend (`/backend/.env`)**
```bash
DB_HOST=localhost
DB_USERNAME=root
JWT_SECRET_KEY=...
```
**Frontend (`/frontend/.env.local`)**
```bash
NEXT_PUBLIC_API_URL=http://localhost:8080/api
```

## 8.3. Deployment Architecture
향후 설계 예정 (N/A for MVP)

---
