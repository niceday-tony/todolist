# 개발 환경 설정 가이드

## 🎯 목표
5명의 개발자가 동일한 환경에서 작업할 수 있도록 표준화된 개발 환경 구축

## 📋 필수 도구 목록

### 공통 요구사항
```bash
# 필수 도구
- Git 2.40+
- Docker Desktop 4.20+
- Node.js 18.x LTS
- Java 17 LTS

# 권장 도구
- IntelliJ IDEA (백엔드) 또는 VS Code
- Postman 또는 Insomnia (API 테스트)
```

### 백엔드 개발자 추가 요구사항
```bash
# Java 개발 환경
- IntelliJ IDEA Community/Ultimate
- Gradle 8.x (또는 Wrapper 사용)
- MySQL Workbench (선택사항)
```

### 프론트엔드 개발자 추가 요구사항
```bash
# Node.js 개발 환경
- VS Code (권장)
- npm 9.x+
- React Developer Tools (브라우저 확장)
```

## 🚀 단계별 설정

### 1단계: 기본 도구 설치

#### Git 설정
```bash
# Git 사용자 정보 설정
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# 줄바꿈 설정 (OS별)
# Windows
git config --global core.autocrlf true
# macOS/Linux
git config --global core.autocrlf input

# 기본 브랜치명 설정
git config --global init.defaultBranch main

# 유용한 별칭 설정
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
```

#### Docker Desktop 설치 및 확인
```bash
# Docker 설치 확인
docker --version
docker-compose --version

# Docker 실행 테스트
docker run hello-world
```

### 2단계: 프로젝트 클론 및 초기 설정

```bash
# 프로젝트 클론
git clone https://github.com/your-org/todolist.git
cd todolist

# 브랜치 확인
git branch -a
git checkout develop

# 환경 변수 파일 생성 (프론트엔드)
cd frontend
cp .env.example .env.local
```

### 3단계: 백엔드 환경 설정

#### Java 및 Gradle 설정
```bash
# Java 버전 확인
java -version
# 출력 예시: openjdk 17.0.x

# Gradle Wrapper 사용 (권장)
cd backend
./gradlew --version

# 의존성 다운로드 및 빌드 테스트
./gradlew build
```

#### 데이터베이스 설정
```bash
# Docker로 MySQL 실행
docker-compose up -d mysql

# 데이터베이스 연결 확인
docker-compose logs mysql

# 데이터베이스 초기화 확인
# MySQL에 접속해서 테이블 생성 확인
docker exec -it todolist_mysql_1 mysql -u todouser -p todolist
# 비밀번호: todopass
```

#### IntelliJ IDEA 설정
```
1. File → Open → backend 폴더 선택
2. Import Gradle project 선택
3. Use Gradle from: 'gradle-wrapper.properties' file 선택
4. Project SDK: Java 17 선택
5. File → Settings → Editor → Code Style → Import: coding-standards에서 제공된 설정
```

### 4단계: 프론트엔드 환경 설정

#### Node.js 및 npm 설정
```bash
# Node.js 버전 확인
node --version
# 출력 예시: v18.x.x

npm --version
# 출력 예시: 9.x.x

# 프로젝트 의존성 설치
cd frontend
npm install

# 개발 서버 실행 테스트
npm run dev
# http://localhost:3000 에서 확인
```

#### VS Code 설정 (권장)
```json
// .vscode/settings.json
{
  "typescript.preferences.importModuleSpecifier": "relative",
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "emmet.includeLanguages": {
    "typescript": "html",
    "typescriptreact": "html"
  }
}
```

#### VS Code 확장 프로그램
```
필수:
- ES7+ React/Redux/React-Native snippets
- Prettier - Code formatter
- ESLint
- TypeScript Importer

권장:
- GitLens
- Auto Rename Tag
- Bracket Pair Colorizer
- Thunder Client (API 테스트)
```

### 5단계: 전체 애플리케이션 실행

#### Docker Compose로 전체 환경 실행
```bash
# 프로젝트 루트에서
docker-compose up -d

# 로그 확인
docker-compose logs -f

# 서비스 상태 확인
docker-compose ps
```

#### 개별 서비스 실행 (개발 모드)
```bash
# 터미널 1: 데이터베이스
docker-compose up mysql

# 터미널 2: 백엔드
cd backend
./gradlew bootRun

# 터미널 3: 프론트엔드
cd frontend
npm run dev
```

#### 동작 확인
```bash
# 백엔드 API 테스트
curl http://localhost:8080/api/todos

# 프론트엔드 접속
# 브라우저에서 http://localhost:3000
```

## 🔧 IDE 및 도구별 설정

### IntelliJ IDEA 설정

#### 코딩 스타일 설정
```
File → Settings → Editor → Code Style → Java
- Tabs and Indents: Use tab character 체크 해제, Tab size: 4
- Spaces: Before parentheses 모든 항목 체크 해제
- Wrapping and Braces: Keep when reformatting의 Simple methods in one line 체크

File → Settings → Editor → Code Style → Imports
- Class count to use import with '*': 99
- Names count to use static import with '*': 99
```

#### 플러그인 설치
```
필수:
- Lombok Plugin
- Spring Boot Helper
- GitToolBox

권장:
- SonarLint
- Rainbow Brackets
- String Manipulation
```

### VS Code 설정

#### workspace 설정 파일
```json
// .vscode/launch.json (디버깅 설정)
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Next.js: debug server-side",
      "type": "node",
      "request": "attach",
      "port": 9229,
      "skipFiles": ["<node_internals>/**"]
    }
  ]
}
```

## 🧪 테스트 환경 설정

### 백엔드 테스트 설정
```bash
# 테스트 실행
cd backend
./gradlew test

# 특정 테스트 클래스 실행
./gradlew test --tests TodoServiceTest

# 통합 테스트 실행 (Testcontainers)
./gradlew integrationTest
```

### 프론트엔드 테스트 설정
```bash
# 테스트 실행
cd frontend
npm test

# 커버리지 포함 테스트
npm run test:coverage

# E2E 테스트 (Playwright)
npm run test:e2e
```

## 🔍 문제 해결 가이드

### 자주 발생하는 문제들

#### 1. Docker 관련 문제
```bash
# 포트 충돌 문제
# 기존 MySQL이 3306 포트 사용중인 경우
sudo service mysql stop  # Linux
brew services stop mysql  # macOS

# Docker 볼륨 초기화
docker-compose down -v
docker-compose up -d
```

#### 2. Node.js 버전 문제
```bash
# nvm 사용 (권장)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 18
nvm use 18

# 또는 직접 다운로드
# https://nodejs.org/en/download/
```

#### 3. Java 버전 문제
```bash
# Java 17 설치 확인
java -version

# JAVA_HOME 설정 (Linux/macOS)
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk' >> ~/.bashrc

# Windows
# 시스템 환경 변수에서 JAVA_HOME 설정
```

#### 4. 권한 문제 (Linux/macOS)
```bash
# gradlew 실행 권한 부여
chmod +x gradlew

# Docker 권한 문제
sudo usermod -aG docker $USER
# 로그아웃 후 다시 로그인
```

### 환경 검증 스크립트

#### 전체 환경 체크 스크립트
```bash
#!/bin/bash
# check-environment.sh

echo "=== 개발 환경 검증 스크립트 ==="

# Git 확인
echo "1. Git 버전 확인"
git --version || echo "❌ Git 설치 필요"

# Docker 확인
echo "2. Docker 확인"
docker --version || echo "❌ Docker 설치 필요"
docker-compose --version || echo "❌ Docker Compose 설치 필요"

# Java 확인
echo "3. Java 확인"
java -version 2>&1 | grep "17\." || echo "❌ Java 17 설치 필요"

# Node.js 확인
echo "4. Node.js 확인"
node --version | grep "v18\." || echo "❌ Node.js 18.x 설치 필요"

# 프로젝트 설정 확인
echo "5. 프로젝트 설정 확인"
[ -f "docker-compose.yml" ] && echo "✅ docker-compose.yml 존재" || echo "❌ 프로젝트 루트 디렉토리에서 실행하세요"

[ -f "backend/gradlew" ] && echo "✅ Gradle Wrapper 존재" || echo "❌ 백엔드 디렉토리 확인 필요"

[ -f "frontend/package.json" ] && echo "✅ package.json 존재" || echo "❌ 프론트엔드 디렉토리 확인 필요"

echo "=== 검증 완료 ==="
```

## 📚 참고 자료

### 개발 도구 링크
- [Java 17 다운로드](https://adoptium.net/)
- [Node.js 18 LTS 다운로드](https://nodejs.org/)
- [Docker Desktop 다운로드](https://www.docker.com/products/docker-desktop/)
- [IntelliJ IDEA 다운로드](https://www.jetbrains.com/idea/)
- [VS Code 다운로드](https://code.visualstudio.com/)

### 설정 파일 템플릿
- `.env.local` 템플릿은 `frontend/.env.example` 참조
- IntelliJ 코딩 스타일은 `docs/architecture/coding-standards.md` 참조
- Git 설정은 `docs/git-workflow.md` 참조

---

**환경 설정 완료 체크리스트**:
- [ ] 모든 필수 도구 설치 완료
- [ ] 프로젝트 클론 및 빌드 성공
- [ ] Docker로 전체 애플리케이션 실행 성공
- [ ] IDE/에디터 설정 완료
- [ ] 테스트 실행 확인