-- TodoList 데이터베이스 초기화 스크립트
-- 이 파일은 Docker 컨테이너가 처음 실행될 때 자동으로 실행됩니다.

-- 데이터베이스가 이미 생성되어 있지만 명시적으로 사용
USE todolist;

-- 문자셋 설정
ALTER DATABASE todolist CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 샘플 테이블 생성 (JPA가 자동으로 생성하지만 예시로 포함)
-- CREATE TABLE IF NOT EXISTS todos (
--     id BIGINT AUTO_INCREMENT PRIMARY KEY,
--     title VARCHAR(255) NOT NULL,
--     content TEXT,
--     completed BOOLEAN DEFAULT FALSE,
--     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--     updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 테스트용 샘플 데이터 (필요시 주석 해제)
-- INSERT INTO todos (title, content, completed) VALUES
-- ('Spring Boot 프로젝트 초기화', 'Spring Initializr로 프로젝트 생성', true),
-- ('데이터베이스 연결 설정', 'MySQL Docker 컨테이너 설정', true),
-- ('Todo 엔티티 생성', 'JPA Entity 클래스 작성', false),
-- ('REST API 구현', 'CRUD 컨트롤러 구현', false),
-- ('프론트엔드 연동', 'Vue.js와 API 연동', false);

-- 사용자 생성 (필요시)
-- CREATE USER IF NOT EXISTS 'todouser'@'%' IDENTIFIED BY 'todopass';
-- GRANT ALL PRIVILEGES ON todolist.* TO 'todouser'@'%';
-- FLUSH PRIVILEGES;