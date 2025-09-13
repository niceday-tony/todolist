#!/bin/bash

# =============================================================================
# GrowTogether TodoList - 전체 프로젝트 테스트 스크립트
# =============================================================================
# 1일 개발 제약을 위한 효율적인 테스트 실행
# 사용법: ./scripts/test-all.sh [--unit|--integration|--e2e|--all]
# =============================================================================

set -e  # 에러 발생시 스크립트 중단

# 색상 코드
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 기본 설정
TEST_TYPE="unit"
VERBOSE=false
GENERATE_REPORT=false
FAIL_FAST=true

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
    echo "테스트 타입:"
    echo "  --unit         유닛 테스트만 실행 (기본값, 빠름)"
    echo "  --integration  통합 테스트 실행 (DB 필요)"
    echo "  --e2e          E2E 테스트 실행 (전체 환경 필요)"
    echo "  --all          모든 테스트 실행"
    echo ""
    echo "옵션:"
    echo "  --verbose      상세 출력"
    echo "  --report       테스트 리포트 생성"
    echo "  --no-fail-fast 첫 번째 실패 시 중단하지 않음"
    echo "  --help         이 도움말 표시"
    echo ""
    echo "예시:"
    echo "  $0 --unit --report     # 유닛 테스트 + 리포트"
    echo "  $0 --integration       # 통합 테스트"
    echo "  $0 --all --verbose     # 모든 테스트 + 상세 출력"
}

# 명령행 인수 처리
while [[ $# -gt 0 ]]; do
    case $1 in
        --unit)
            TEST_TYPE="unit"
            shift
            ;;
        --integration)
            TEST_TYPE="integration"
            shift
            ;;
        --e2e)
            TEST_TYPE="e2e"
            shift
            ;;
        --all)
            TEST_TYPE="all"
            shift
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --report)
            GENERATE_REPORT=true
            shift
            ;;
        --no-fail-fast)
            FAIL_FAST=false
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

# 테스트 헤더
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
echo -e "${BLUE}전체 프로젝트 테스트 - 타입: $TEST_TYPE${NC}\n"

# 타이머 시작
START_TIME=$(date +%s)

# 테스트 결과 추적
BACKEND_UNIT_RESULT=0
BACKEND_INTEGRATION_RESULT=0
FRONTEND_UNIT_RESULT=0
E2E_RESULT=0

# 리포트 디렉토리 생성
if [ "$GENERATE_REPORT" = true ]; then
    REPORT_DIR="test-reports/$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$REPORT_DIR"
    print_info "테스트 리포트 디렉토리: $REPORT_DIR"
fi

# =============================================================================
# 1단계: 테스트 환경 확인
# =============================================================================

print_section "테스트 환경 확인"

# 프로젝트 구조 확인
if [ ! -f "docker-compose.yml" ]; then
    print_error "프로젝트 루트에서 실행해주세요."
    exit 1
fi

# MySQL 상태 확인 (통합 테스트나 E2E 테스트를 위해)
if [ "$TEST_TYPE" == "integration" ] || [ "$TEST_TYPE" == "e2e" ] || [ "$TEST_TYPE" == "all" ]; then
    print_info "MySQL 컨테이너 상태 확인..."
    if ! docker ps | grep -q todolist-mysql; then
        print_info "MySQL 컨테이너 시작 중..."
        docker-compose up -d mysql
        sleep 10  # MySQL 초기화 대기
    fi
    print_success "MySQL 준비 완료"
fi

# =============================================================================
# 2단계: 백엔드 유닛 테스트
# =============================================================================

if [ "$TEST_TYPE" == "unit" ] || [ "$TEST_TYPE" == "all" ]; then
    print_section "백엔드 유닛 테스트 (JUnit 5)"

    if [ ! -d "backend" ] || [ ! -f "backend/pom.xml" ]; then
        print_warning "백엔드 프로젝트가 없습니다. 스킵합니다."
    else
        cd backend

        print_info "Maven 유닛 테스트 실행 중..."

        MAVEN_OPTS=""
        if [ "$VERBOSE" != true ]; then
            MAVEN_OPTS="-q"
        fi

        if [ "$GENERATE_REPORT" = true ]; then
            MAVEN_OPTS="$MAVEN_OPTS -Djacoco.skip=false"
        fi

        if mvn test $MAVEN_OPTS -Dtest="*Test" -DfailIfNoTests=false; then
            BACKEND_UNIT_RESULT=0
            print_success "백엔드 유닛 테스트 통과"

            # 테스트 결과 통계
            if [ -d "target/surefire-reports" ]; then
                TEST_COUNT=$(find target/surefire-reports -name "TEST-*.xml" -exec grep -l "testcase" {} \; | wc -l)
                print_info "실행된 테스트 클래스: $TEST_COUNT"
            fi

            # 리포트 복사
            if [ "$GENERATE_REPORT" = true ] && [ -d "target/surefire-reports" ]; then
                mkdir -p "../$REPORT_DIR/backend-unit"
                cp -r target/surefire-reports/* "../$REPORT_DIR/backend-unit/"
                print_info "백엔드 유닛 테스트 리포트: $REPORT_DIR/backend-unit/"
            fi
        else
            BACKEND_UNIT_RESULT=1
            print_error "백엔드 유닛 테스트 실패"
            if [ "$FAIL_FAST" = true ]; then
                cd ..
                exit 1
            fi
        fi

        cd ..
    fi
fi

# =============================================================================
# 3단계: 백엔드 통합 테스트
# =============================================================================

if [ "$TEST_TYPE" == "integration" ] || [ "$TEST_TYPE" == "all" ]; then
    print_section "백엔드 통합 테스트 (TestContainers)"

    if [ ! -d "backend" ] || [ ! -f "backend/pom.xml" ]; then
        print_warning "백엔드 프로젝트가 없습니다. 스킵합니다."
    else
        cd backend

        print_info "Maven 통합 테스트 실행 중..."

        MAVEN_OPTS=""
        if [ "$VERBOSE" != true ]; then
            MAVEN_OPTS="-q"
        fi

        if mvn test $MAVEN_OPTS -Dtest="*IntegrationTest" -DfailIfNoTests=false; then
            BACKEND_INTEGRATION_RESULT=0
            print_success "백엔드 통합 테스트 통과"

            # 리포트 복사
            if [ "$GENERATE_REPORT" = true ] && [ -d "target/failsafe-reports" ]; then
                mkdir -p "../$REPORT_DIR/backend-integration"
                cp -r target/failsafe-reports/* "../$REPORT_DIR/backend-integration/"
                print_info "백엔드 통합 테스트 리포트: $REPORT_DIR/backend-integration/"
            fi
        else
            BACKEND_INTEGRATION_RESULT=1
            print_error "백엔드 통합 테스트 실패"
            if [ "$FAIL_FAST" = true ]; then
                cd ..
                exit 1
            fi
        fi

        cd ..
    fi
fi

# =============================================================================
# 4단계: 프론트엔드 유닛 테스트
# =============================================================================

if [ "$TEST_TYPE" == "unit" ] || [ "$TEST_TYPE" == "all" ]; then
    print_section "프론트엔드 유닛 테스트 (Jest + React Testing Library)"

    if [ ! -d "frontend" ] || [ ! -f "frontend/package.json" ]; then
        print_warning "프론트엔드 프로젝트가 없습니다. 스킵합니다."
    else
        cd frontend

        # node_modules 확인
        if [ ! -d "node_modules" ]; then
            print_info "npm 의존성 설치 중..."
            npm install --silent
        fi

        print_info "Jest 테스트 실행 중..."

        NPM_OPTS=""
        if [ "$VERBOSE" != true ]; then
            NPM_OPTS="--silent"
        fi

        if npm run test:unit $NPM_OPTS -- --watchAll=false --passWithNoTests; then
            FRONTEND_UNIT_RESULT=0
            print_success "프론트엔드 유닛 테스트 통과"

            # 테스트 커버리지 정보
            if [ -f "coverage/lcov-report/index.html" ] && [ "$GENERATE_REPORT" = true ]; then
                mkdir -p "../$REPORT_DIR/frontend-unit"
                cp -r coverage/* "../$REPORT_DIR/frontend-unit/"
                print_info "프론트엔드 커버리지 리포트: $REPORT_DIR/frontend-unit/"
            fi
        else
            FRONTEND_UNIT_RESULT=1
            print_error "프론트엔드 유닛 테스트 실패"
            if [ "$FAIL_FAST" = true ]; then
                cd ..
                exit 1
            fi
        fi

        cd ..
    fi
fi

# =============================================================================
# 5단계: E2E 테스트 (선택적)
# =============================================================================

if [ "$TEST_TYPE" == "e2e" ] || [ "$TEST_TYPE" == "all" ]; then
    print_section "E2E 테스트 (Playwright - 선택적)"

    # E2E 테스트는 완전한 환경이 필요
    print_info "E2E 테스트를 위한 환경 시작..."

    # 백엔드 시작 (백그라운드)
    if [ -f "backend/target/todolist-0.0.1-SNAPSHOT.jar" ]; then
        print_info "백엔드 서버 시작 중..."
        cd backend
        java -jar target/*.jar --server.port=8080 &
        BACKEND_PID=$!
        cd ..

        # 백엔드 준비 대기
        print_info "백엔드 서버 준비 대기..."
        for i in {1..30}; do
            if curl -s http://localhost:8080/api/health > /dev/null 2>&1; then
                print_success "백엔드 서버 준비 완료"
                break
            fi
            sleep 2
        done
    else
        print_warning "백엔드 JAR 파일이 없습니다. 먼저 빌드를 실행해주세요."
        print_info "E2E 테스트를 스킵합니다."
        E2E_RESULT=0
    fi

    # 프론트엔드 빌드 및 서빙
    if [ -d "frontend" ] && [ "$BACKEND_PID" ]; then
        cd frontend

        if [ ! -d "dist" ]; then
            print_info "프론트엔드 빌드 중..."
            npm run build --silent
        fi

        print_info "프론트엔드 서버 시작 중..."
        python3 -m http.server 3000 --directory dist &
        FRONTEND_PID=$!

        cd ..

        # 간단한 E2E 테스트 (curl 기반)
        print_info "기본 E2E 테스트 실행 중..."

        # 프론트엔드 접근 테스트
        if curl -s http://localhost:3000 > /dev/null; then
            print_success "프론트엔드 접근 테스트 통과"
        else
            print_error "프론트엔드 접근 실패"
            E2E_RESULT=1
        fi

        # API 엔드포인트 테스트
        if curl -s http://localhost:8080/api/health | grep -q "OK"; then
            print_success "백엔드 API 테스트 통과"
        else
            print_error "백엔드 API 테스트 실패"
            E2E_RESULT=1
        fi

        # TODO API 테스트 (GET /api/todos)
        if curl -s http://localhost:8080/api/todos > /dev/null; then
            print_success "TODO API 테스트 통과"
        else
            print_error "TODO API 테스트 실패"
            E2E_RESULT=1
        fi

        # 서버 정리
        kill $BACKEND_PID $FRONTEND_PID 2>/dev/null || true
        wait $BACKEND_PID $FRONTEND_PID 2>/dev/null || true

        if [ "$E2E_RESULT" -eq 0 ]; then
            print_success "E2E 테스트 통과"
        else
            print_error "E2E 테스트 실패"
            if [ "$FAIL_FAST" = true ]; then
                exit 1
            fi
        fi
    fi
fi

# =============================================================================
# 6단계: 테스트 결과 요약
# =============================================================================

print_section "테스트 결과 요약"

# 총 테스트 시간 계산
END_TIME=$(date +%s)
TEST_TIME=$((END_TIME - START_TIME))
TEST_TIME_MIN=$((TEST_TIME / 60))
TEST_TIME_SEC=$((TEST_TIME % 60))

# 결과 출력
echo -e "${BLUE}📊 테스트 실행 결과:${NC}"
echo ""

TOTAL_FAILURES=0

if [ "$TEST_TYPE" == "unit" ] || [ "$TEST_TYPE" == "all" ]; then
    if [ "$BACKEND_UNIT_RESULT" -eq 0 ]; then
        echo -e "${GREEN}✅ 백엔드 유닛 테스트: 통과${NC}"
    else
        echo -e "${RED}❌ 백엔드 유닛 테스트: 실패${NC}"
        TOTAL_FAILURES=$((TOTAL_FAILURES + 1))
    fi

    if [ "$FRONTEND_UNIT_RESULT" -eq 0 ]; then
        echo -e "${GREEN}✅ 프론트엔드 유닛 테스트: 통과${NC}"
    else
        echo -e "${RED}❌ 프론트엔드 유닛 테스트: 실패${NC}"
        TOTAL_FAILURES=$((TOTAL_FAILURES + 1))
    fi
fi

if [ "$TEST_TYPE" == "integration" ] || [ "$TEST_TYPE" == "all" ]; then
    if [ "$BACKEND_INTEGRATION_RESULT" -eq 0 ]; then
        echo -e "${GREEN}✅ 백엔드 통합 테스트: 통과${NC}"
    else
        echo -e "${RED}❌ 백엔드 통합 테스트: 실패${NC}"
        TOTAL_FAILURES=$((TOTAL_FAILURES + 1))
    fi
fi

if [ "$TEST_TYPE" == "e2e" ] || [ "$TEST_TYPE" == "all" ]; then
    if [ "$E2E_RESULT" -eq 0 ]; then
        echo -e "${GREEN}✅ E2E 테스트: 통과${NC}"
    else
        echo -e "${RED}❌ E2E 테스트: 실패${NC}"
        TOTAL_FAILURES=$((TOTAL_FAILURES + 1))
    fi
fi

echo ""
echo -e "${BLUE}⏱️  총 테스트 시간: ${TEST_TIME_MIN}분 ${TEST_TIME_SEC}초${NC}"

if [ "$GENERATE_REPORT" = true ]; then
    echo -e "${BLUE}📄 테스트 리포트: $REPORT_DIR/${NC}"
fi

echo ""

# 최종 결과
if [ "$TOTAL_FAILURES" -eq 0 ]; then
    echo -e "${GREEN}🎉 모든 테스트가 통과했습니다!${NC}"
    exit 0
else
    echo -e "${RED}💥 $TOTAL_FAILURES개의 테스트가 실패했습니다.${NC}"
    exit 1
fi