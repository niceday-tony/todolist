-- 기본 식물 데이터 삽입 (애플리케이션 시작시 실행)
INSERT INTO plants (name, species, growth_points, current_stage, created_at, last_interaction_at)
VALUES ('내 식물', '해바라기', 0, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE
name = VALUES(name),
species = VALUES(species);