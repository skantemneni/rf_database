ALTER TABLE `rulefree`.`test`        MODIFY COLUMN  `point_count` DECIMAL(7,2) NULL DEFAULT 0.0;
ALTER TABLE `rulefree`.`testsegment` MODIFY COLUMN  `point_count` DECIMAL(7,2) NULL DEFAULT 0.0;
ALTER TABLE `rulefree`.`testsection` MODIFY COLUMN  `point_count` DECIMAL(7,2) NULL DEFAULT 0.0;
ALTER TABLE `rulefree`.`testsection` ADD COLUMN     `points_per_question` DECIMAL(3,2) NOT NULL DEFAULT 1.0;
ALTER TABLE `rulefree`.`testsection` ADD COLUMN     `negative_points_per_question` DECIMAL(3,2) NOT NULL DEFAULT 0.0;


ALTER TABLE `rulefree`.`testinstance`        MODIFY COLUMN  `point_count` DECIMAL(7,2) NOT NULL DEFAULT 0.0;
ALTER TABLE `rulefree`.`testinstance`        MODIFY COLUMN  `user_points` DECIMAL(7,2) NOT NULL DEFAULT 0.0;

ALTER TABLE `rulefree`.`testinstance_section`        MODIFY COLUMN  `point_count` DECIMAL(7,2) NOT NULL DEFAULT 0.0;
ALTER TABLE `rulefree`.`testinstance_section`        MODIFY COLUMN  `user_points` DECIMAL(7,2) NOT NULL DEFAULT 0.0;
ALTER TABLE `rulefree`.`testinstance_section` ADD COLUMN     `negative_points_per_question` DECIMAL(3,2) NOT NULL DEFAULT 0.0;
ALTER TABLE `rulefree`.`testinstance_section` ADD COLUMN     `points_per_question` DECIMAL(3,2) NOT NULL DEFAULT 1.0;

