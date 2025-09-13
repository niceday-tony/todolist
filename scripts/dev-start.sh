#!/bin/bash

# =============================================================================
# GrowTogether TodoList - 개발 환경 시작 스크립트
# =============================================================================
# 1일 개발 제약을 위한 빠른 개발 환경 시작
# 사용법: ./scripts/dev-start.sh
# =============================================================================

set -e  # 에러 발생시 스크립트 중단

# 색상 코드
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 함수들
print_section() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# 프로젝트 루트 확인
if [ ! -f "docker-compose.yml" ]; then
    print_error "docker-compose.yml이 없습니다. 프로젝트 루트에서 실행해주세요."
    exit 1
fi

echo -e "${GREEN}"
echo "  ______                 _______                 __  __              "
echo " |  ____|               |__   __|               |  \/  |             "
echo " | |  __ _ __ _____      ___| | ___   __ _  ___  | \  / | ___  _ __   "
echo " | | |_ | '__/ _ \ \ /\ / / | |/ _ \ / _\` |/ _ \ | |\/| |/ _ \| '__|  "
echo " | |__| | | | (_) \ V  V /  | | (_) | (_| |  __/ | |  | |  __/| |     "
echo "  \_____|_|  \___/ \_/\_/   |_|\___/ \__, |\___| |_|  |_|\___||_|     "
echo "                                     __/ |                           "
echo "                                    |___/                            "
echo -e "${NC}"
echo -e "${BLUE}식물과 함께 성장하는 TodoList - 개발 환경 시작${NC}\n"

# =============================================================================
# 1단계: 시스템 요구사항 확인
# =============================================================================

print_section "시스템 요구사항 확인"

# Docker 확인
if ! command -v docker &> /dev/null; then
    print_error "Docker가 설치되지 않았습니다."
    print_info "https://docs.docker.com/get-docker/ 에서 Docker를 설치해주세요."
    exit 1
fi
print_success "Docker 설치 확인됨"

# Docker Compose 확인
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose가 설치되지 않았습니다."
    exit 1
fi
print_success "Docker Compose 설치 확인됨"

# Java 확인 (Java 17 필수)
if ! command -v java &> /dev/null; then
    print_error "Java가 설치되지 않았습니다."
    print_info "Java 17을 설치해주세요."
    exit 1
fi

JAVA_VERSION=$(java -version 2>&1 | head -1 | cut -d'"' -f2 | sed '/^1\./s///' | cut -d'.' -f1)
if [ "$JAVA_VERSION" -lt 17 ]; then
    print_error "Java 17 이상이 필요합니다. 현재 버전: $JAVA_VERSION"
    exit 1
fi
print_success "Java $JAVA_VERSION 확인됨"

# Maven 확인
if ! command -v mvn &> /dev/null; then
    print_error "Maven이 설치되지 않았습니다."
    print_info "https://maven.apache.org/install.html 에서 Maven을 설치해주세요."
    exit 1
fi
print_success "Maven 설치 확인됨"

# Node.js 확인 (Node 18 이상 권장)
if ! command -v node &> /dev/null; then
    print_error "Node.js가 설치되지 않았습니다."
    print_info "https://nodejs.org 에서 Node.js를 설치해주세요."
    exit 1
fi

NODE_VERSION=$(node -v | sed 's/v//' | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    print_warning "Node.js 18 이상을 권장합니다. 현재 버전: $(node -v)"
else
    print_success "Node.js $(node -v) 확인됨"
fi

# npm 확인
if ! command -v npm &> /dev/null; then
    print_error "npm이 설치되지 않았습니다."
    exit 1
fi
print_success "npm $(npm -v) 확인됨"

# =============================================================================
# 2단계: MySQL 데이터베이스 시작
# =============================================================================

print_section "MySQL 데이터베이스 시작"

# 기존 컨테이너 상태 확인
if [ "$(docker ps -q -f name=todolist-mysql)" ]; then
    print_info "MySQL 컨테이너가 이미 실행 중입니다."
else
    print_info "MySQL 컨테이너 시작 중..."
    docker-compose up -d mysql

    # MySQL 준비 대기
    print_info "MySQL 초기화 대기 중..."
    for i in {1..30}; do
        if docker-compose exec -T mysql mysqladmin ping -h localhost -u root -proot --silent; then
            print_success "MySQL 준비 완료"
            break
        fi
        echo -n "."
        sleep 2
        if [ $i -eq 30 ]; then
            print_error "MySQL 시작 타임아웃"
            exit 1
        fi
    done
fi

# 데이터베이스 확인
print_info "todolist 데이터베이스 확인 중..."
if docker-compose exec -T mysql mysql -u root -proot -e "USE todolist;" 2>/dev/null; then
    print_success "todolist 데이터베이스 확인됨"
else
    print_info "todolist 데이터베이스 생성 중..."
    docker-compose exec -T mysql mysql -u root -proot -e "CREATE DATABASE IF NOT EXISTS todolist;"
    print_success "todolist 데이터베이스 생성됨"
fi

# =============================================================================
# 3단계: 백엔드 환경 확인
# =============================================================================

print_section "백엔드 환경 확인"

# 백엔드 디렉토리 확인
if [ ! -d "backend" ]; then
    print_warning "backend 디렉토리가 없습니다."
    print_info "Story 1.1에서 Spring Boot 프로젝트를 생성해야 합니다."
else
    print_success "backend 디렉토리 확인됨"

    # pom.xml 확인
    if [ -f "backend/pom.xml" ]; then
        print_success "Maven 프로젝트 확인됨"

        # 의존성 다운로드
        print_info "Maven 의존성 다운로드 중..."
        (cd backend && mvn dependency:resolve -q)
        print_success "Maven 의존성 준비 완료"
    else
        print_warning "pom.xml이 없습니다. Spring Boot 프로젝트를 먼저 생성해주세요."
    fi
fi

# =============================================================================
# 4단계: 프론트엔드 환경 확인
# =============================================================================

print_section "프론트엔드 환경 확인"

# 프론트엔드 디렉토리 확인
if [ ! -d "frontend" ]; then
    print_warning "frontend 디렉토리가 없습니다."
    print_info "Story 1.1에서 React 프로젝트를 생성해야 합니다."
else
    print_success "frontend 디렉토리 확인됨"

    # package.json 확인
    if [ -f "frontend/package.json" ]; then
        print_success "React 프로젝트 확인됨"

        # node_modules 확인
        if [ ! -d "frontend/node_modules" ]; then
            print_info "npm 의존성 설치 중..."
            (cd frontend && npm install)
        fi
        print_success "npm 의존성 준비 완료"
    else
        print_warning "package.json이 없습니다. React 프로젝트를 먼저 생성해주세요."
    fi
fi

# =============================================================================
# 5단계: 개발 서버 시작 옵션
# =============================================================================

print_section "개발 서버 시작 옵션"

echo -e "${YELLOW}"
echo "다음 중 선택해주세요:"
echo ""
echo "1) 백엔드만 시작 (Spring Boot)"
echo "2) 프론트엔드만 시작 (React)"
echo "3) 둘 다 시작 (별도 터미널에서)"
echo "4) 환경만 확인하고 종료"
echo -e "${NC}"

read -p "선택 (1-4): " choice

case $choice in
    1)
        print_section "백엔드 서버 시작"
        if [ -f "backend/pom.xml" ]; then
            print_info "Spring Boot 애플리케이션 시작 중..."
            print_info "서버 주소: http://localhost:8080"
            print_info "Health Check: http://localhost:8080/api/health"
            print_info "중단하려면 Ctrl+C를 누르세요."
            echo ""
            (cd backend && mvn spring-boot:run)
        else
            print_error "백엔드 프로젝트가 없습니다. Story 1.1을 먼저 완료해주세요."
        fi
        ;;

    2)
        print_section "프론트엔드 서버 시작"
        if [ -f "frontend/package.json" ]; then
            print_info "React 개발 서버 시작 중..."
            print_info "서버 주소: http://localhost:3000"
            print_info "중단하려면 Ctrl+C를 누르세요."
            echo ""
            (cd frontend && npm run dev)
        else
            print_error "프론트엔드 프로젝트가 없습니다. Story 1.1을 먼저 완료해주세요."
        fi
        ;;

    3)
        print_section "개발 환경 시작 명령어"
        echo -e "${GREEN}"
        echo "다음 명령어들을 별도 터미널에서 실행해주세요:"
        echo ""
        echo "터미널 1 (백엔드):"
        echo "cd $(pwd)/backend && mvn spring-boot:run"
        echo ""
        echo "터미널 2 (프론트엔드):"
        echo "cd $(pwd)/frontend && npm run dev"
        echo ""
        echo "접속 주소:"
        echo "- 백엔드: http://localhost:8080"
        echo "- 프론트엔드: http://localhost:3000"
        echo "- Health Check: http://localhost:8080/api/health"
        echo -e "${NC}"
        ;;

    4)
        print_section "환경 확인 완료"
        print_success "모든 환경 확인이 완료되었습니다!"
        ;;

    *)
        print_error "잘못된 선택입니다."
        exit 1
        ;;
esac

# =============================================================================
# 유용한 정보 출력
# =============================================================================

if [ "$choice" == "4" ]; then
    echo -e "\n${BLUE}=== 유용한 명령어들 ===${NC}"
    echo ""
    echo "🗄️  MySQL 접속:"
    echo "   docker-compose exec mysql mysql -u root -p todolist"
    echo ""
    echo "📊 로그 확인:"
    echo "   docker-compose logs mysql"
    echo ""
    echo "🔄 MySQL 재시작:"
    echo "   docker-compose restart mysql"
    echo ""
    echo "🧹 전체 정리:"
    echo "   docker-compose down"
    echo ""
    echo "📚 개발 가이드:"
    echo "   docs/DEVELOPMENT_SEQUENCE.md 참고"
    echo ""
fi

print_success "개발 환경 스크립트 실행 완료! 🌱"