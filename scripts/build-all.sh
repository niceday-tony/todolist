#!/bin/bash

# =============================================================================
# GrowTogether TodoList - 전체 프로젝트 빌드 스크립트
# =============================================================================
# 1일 개발 제약을 위한 빠른 빌드 및 배포 준비
# 사용법: ./scripts/build-all.sh [--prod|--dev|--test]
# =============================================================================

set -e  # 에러 발생시 스크립트 중단

# 색상 코드
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 기본 설정
BUILD_MODE="dev"
SKIP_TESTS=false
CLEAN_BUILD=false
VERBOSE=false

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

show_usage() {
    echo "사용법: $0 [OPTIONS]"
    echo ""
    echo "옵션:"
    echo "  --prod      프로덕션 빌드 (최적화 적용)"
    echo "  --dev       개발 빌드 (기본값)"
    echo "  --test      테스트 포함 빌드"
    echo "  --clean     clean 빌드 (캐시 삭제)"
    echo "  --verbose   상세 출력"
    echo "  --help      이 도움말 표시"
    echo ""
    echo "예시:"
    echo "  $0 --prod          # 프로덕션 빌드"
    echo "  $0 --test --clean  # 테스트 포함 clean 빌드"
}

# 명령행 인수 처리
while [[ $# -gt 0 ]]; do
    case $1 in
        --prod)
            BUILD_MODE="prod"
            shift
            ;;
        --dev)
            BUILD_MODE="dev"
            shift
            ;;
        --test)
            BUILD_MODE="test"
            shift
            ;;
        --clean)
            CLEAN_BUILD=true
            shift
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --help)
            show_usage
            exit 0
            ;;
        *)
            print_error "알 수 없는 옵션: $1"
            show_usage
            exit 1
            ;;
    esac
done

# 빌드 헤더 출력
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
echo -e "${BLUE}전체 프로젝트 빌드 - 모드: $BUILD_MODE${NC}\n"

# 타이머 시작
START_TIME=$(date +%s)

# 프로젝트 루트 확인
if [ ! -f "docker-compose.yml" ]; then
    print_error "docker-compose.yml이 없습니다. 프로젝트 루트에서 실행해주세요."
    exit 1
fi

# =============================================================================
# 1단계: 빌드 환경 확인
# =============================================================================

print_section "빌드 환경 확인"

# 필수 도구 확인
MISSING_TOOLS=()

if ! command -v java &> /dev/null; then
    MISSING_TOOLS+=("Java 17+")
fi

if ! command -v mvn &> /dev/null; then
    MISSING_TOOLS+=("Maven")
fi

if ! command -v node &> /dev/null; then
    MISSING_TOOLS+=("Node.js")
fi

if ! command -v npm &> /dev/null; then
    MISSING_TOOLS+=("npm")
fi

if [ ${#MISSING_TOOLS[@]} -ne 0 ]; then
    print_error "다음 도구들이 필요합니다: ${MISSING_TOOLS[*]}"
    exit 1
fi

print_success "빌드 환경 확인 완료"

# =============================================================================
# 2단계: 백엔드 빌드
# =============================================================================

print_section "백엔드 빌드 (Spring Boot)"

if [ ! -d "backend" ] || [ ! -f "backend/pom.xml" ]; then
    print_error "backend 프로젝트가 없습니다. Story 1.1을 먼저 완료해주세요."
    exit 1
fi

cd backend

# Clean 빌드 처리
if [ "$CLEAN_BUILD" = true ]; then
    print_info "Maven clean 실행 중..."
    if [ "$VERBOSE" = true ]; then
        mvn clean
    else
        mvn clean -q
    fi
    print_success "Maven clean 완료"
fi

# 빌드 모드별 처리
case $BUILD_MODE in
    "prod")
        print_info "프로덕션 빌드 실행 중..."
        if [ "$VERBOSE" = true ]; then
            mvn package -Pprod -DskipTests
        else
            mvn package -Pprod -DskipTests -q
        fi
        print_success "프로덕션 빌드 완료"
        ;;

    "test")
        print_info "테스트 포함 빌드 실행 중..."
        if [ "$VERBOSE" = true ]; then
            mvn test package
        else
            mvn test package -q
        fi
        print_success "테스트 포함 빌드 완료"
        ;;

    "dev"|*)
        print_info "개발 빌드 실행 중..."
        if [ "$VERBOSE" = true ]; then
            mvn package -DskipTests
        else
            mvn package -DskipTests -q
        fi
        print_success "개발 빌드 완료"
        ;;
esac

# JAR 파일 확인
JAR_FILE=$(find target -name "*.jar" -not -name "*-sources.jar" | head -1)
if [ -n "$JAR_FILE" ]; then
    print_success "JAR 파일 생성: $JAR_FILE"

    # JAR 파일 크기 출력
    JAR_SIZE=$(du -h "$JAR_FILE" | cut -f1)
    print_info "JAR 파일 크기: $JAR_SIZE"
else
    print_error "JAR 파일을 찾을 수 없습니다."
    exit 1
fi

cd ..

# =============================================================================
# 3단계: 프론트엔드 빌드
# =============================================================================

print_section "프론트엔드 빌드 (React)"

if [ ! -d "frontend" ] || [ ! -f "frontend/package.json" ]; then
    print_error "frontend 프로젝트가 없습니다. Story 1.1을 먼저 완료해주세요."
    exit 1
fi

cd frontend

# node_modules 확인 및 설치
if [ ! -d "node_modules" ] || [ "$CLEAN_BUILD" = true ]; then
    print_info "npm 의존성 설치 중..."
    if [ "$VERBOSE" = true ]; then
        npm install
    else
        npm install --silent
    fi
    print_success "npm 의존성 설치 완료"
fi

# 빌드 모드별 처리
case $BUILD_MODE in
    "prod")
        print_info "프로덕션 빌드 실행 중..."

        # 환경변수 설정
        export NODE_ENV=production
        export VITE_API_BASE_URL="http://localhost:8080"

        if [ "$VERBOSE" = true ]; then
            npm run build
        else
            npm run build --silent
        fi
        print_success "프로덕션 빌드 완료"
        ;;

    "test")
        print_info "테스트 포함 빌드 실행 중..."

        # 테스트 실행
        if [ "$VERBOSE" = true ]; then
            npm run test:unit
        else
            npm run test:unit --silent
        fi

        # 빌드 실행
        if [ "$VERBOSE" = true ]; then
            npm run build
        else
            npm run build --silent
        fi
        print_success "테스트 포함 빌드 완료"
        ;;

    "dev"|*)
        print_info "개발 빌드 실행 중..."

        # 환경변수 설정
        export NODE_ENV=development
        export VITE_API_BASE_URL="http://localhost:8080"

        if [ "$VERBOSE" = true ]; then
            npm run build
        else
            npm run build --silent
        fi
        print_success "개발 빌드 완료"
        ;;
esac

# 빌드 결과 확인
if [ -d "dist" ]; then
    print_success "프론트엔드 빌드 결과: frontend/dist/"

    # 빌드 크기 출력
    BUILD_SIZE=$(du -sh dist | cut -f1)
    print_info "빌드 크기: $BUILD_SIZE"

    # 주요 파일 목록
    if [ "$VERBOSE" = true ]; then
        echo -e "\n${BLUE}빌드 파일 목록:${NC}"
        find dist -type f -name "*.js" -o -name "*.css" -o -name "*.html" | head -10
    fi
else
    print_error "프론트엔드 빌드 결과를 찾을 수 없습니다."
    exit 1
fi

cd ..

# =============================================================================
# 4단계: 통합 빌드 결과 정리
# =============================================================================

print_section "빌드 결과 정리"

# 빌드 아티팩트 디렉토리 생성
BUILD_OUTPUT_DIR="build-output"
mkdir -p "$BUILD_OUTPUT_DIR"

# 백엔드 JAR 파일 복사
if [ -n "$JAR_FILE" ]; then
    cp "backend/$JAR_FILE" "$BUILD_OUTPUT_DIR/todolist-backend.jar"
    print_success "백엔드 JAR 복사 완료: $BUILD_OUTPUT_DIR/todolist-backend.jar"
fi

# 프론트엔드 빌드 파일 복사
if [ -d "frontend/dist" ]; then
    cp -r frontend/dist "$BUILD_OUTPUT_DIR/frontend-dist"
    print_success "프론트엔드 빌드 복사 완료: $BUILD_OUTPUT_DIR/frontend-dist/"
fi

# 배포용 스크립트 생성
cat > "$BUILD_OUTPUT_DIR/run.sh" << 'EOF'
#!/bin/bash

# GrowTogether TodoList 실행 스크립트

echo "🌱 GrowTogether TodoList 시작 중..."

# MySQL 확인
if ! docker ps | grep -q todolist-mysql; then
    echo "MySQL 컨테이너 시작 중..."
    docker-compose up -d mysql

    # MySQL 준비 대기
    echo "MySQL 초기화 대기 중..."
    sleep 10
fi

# Spring Boot 애플리케이션 시작
echo "백엔드 서버 시작 중..."
java -jar todolist-backend.jar &
BACKEND_PID=$!

# 백엔드 준비 대기
echo "백엔드 서버 준비 대기 중..."
for i in {1..30}; do
    if curl -s http://localhost:8080/api/health > /dev/null; then
        echo "✅ 백엔드 서버 준비 완료"
        break
    fi
    sleep 2
done

# 프론트엔드 서빙 (간단한 Python 서버)
if command -v python3 &> /dev/null; then
    echo "프론트엔드 서버 시작 중..."
    cd frontend-dist
    python3 -m http.server 3000 &
    FRONTEND_PID=$!
    cd ..
    echo "✅ 프론트엔드 서버 시작 완료"
elif command -v python &> /dev/null; then
    echo "프론트엔드 서버 시작 중..."
    cd frontend-dist
    python -m SimpleHTTPServer 3000 &
    FRONTEND_PID=$!
    cd ..
    echo "✅ 프론트엔드 서버 시작 완료"
else
    echo "⚠️  Python이 없어 프론트엔드 서버를 시작할 수 없습니다."
    echo "   frontend-dist 디렉토리를 웹 서버로 서빙해주세요."
fi

echo ""
echo "🎉 GrowTogether TodoList 실행 완료!"
echo ""
echo "📍 접속 주소:"
echo "   프론트엔드: http://localhost:3000"
echo "   백엔드 API: http://localhost:8080"
echo "   Health Check: http://localhost:8080/api/health"
echo ""
echo "🛑 종료하려면 Ctrl+C를 누르세요."

# 종료 시그널 처리
trap 'echo "서버 종료 중..."; kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit' INT TERM

# 백그라운드 프로세스 대기
wait
EOF

chmod +x "$BUILD_OUTPUT_DIR/run.sh"
print_success "실행 스크립트 생성: $BUILD_OUTPUT_DIR/run.sh"

# README 생성
cat > "$BUILD_OUTPUT_DIR/README.md" << EOF
# GrowTogether TodoList - 빌드 결과

빌드 날짜: $(date)
빌드 모드: $BUILD_MODE

## 파일 구조

- \`todolist-backend.jar\` - Spring Boot 애플리케이션
- \`frontend-dist/\` - React 빌드 결과
- \`run.sh\` - 실행 스크립트

## 실행 방법

1. MySQL 컨테이너가 실행 중인지 확인
2. 실행 스크립트 실행:
   \`\`\`bash
   ./run.sh
   \`\`\`

## 수동 실행

### 백엔드만 실행
\`\`\`bash
java -jar todolist-backend.jar
\`\`\`

### 프론트엔드만 서빙
\`\`\`bash
cd frontend-dist
python3 -m http.server 3000
\`\`\`

## 접속 주소

- 프론트엔드: http://localhost:3000
- 백엔드 API: http://localhost:8080
- Health Check: http://localhost:8080/api/health
EOF

print_success "README 생성: $BUILD_OUTPUT_DIR/README.md"

# =============================================================================
# 5단계: 빌드 완료 정보
# =============================================================================

print_section "빌드 완료"

# 총 빌드 시간 계산
END_TIME=$(date +%s)
BUILD_TIME=$((END_TIME - START_TIME))
BUILD_TIME_MIN=$((BUILD_TIME / 60))
BUILD_TIME_SEC=$((BUILD_TIME % 60))

echo -e "${GREEN}"
echo "🎉 전체 빌드 완료!"
echo ""
echo "📊 빌드 정보:"
echo "   모드: $BUILD_MODE"
echo "   시간: ${BUILD_TIME_MIN}분 ${BUILD_TIME_SEC}초"
echo "   출력: $BUILD_OUTPUT_DIR/"
echo ""
echo "🚀 실행 방법:"
echo "   cd $BUILD_OUTPUT_DIR && ./run.sh"
echo ""
echo "📁 빌드 결과:"
ls -la "$BUILD_OUTPUT_DIR/"
echo -e "${NC}"

print_success "빌드 스크립트 실행 완료! 🌱"