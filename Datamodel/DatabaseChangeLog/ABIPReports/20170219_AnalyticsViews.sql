SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;
USE `rulefree` ;

-- -----------------------------------------------------
-- Placeholder table for view `rulefree`.`vw_testquestion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rulefree`.`vw_testquestion` (`id_test` INT, `id_testsegment` INT, `id_testsection` INT, `id_section_derived` INT, `id_section_actual` INT, `id_skill` INT, `id_topic` INT, `id_level` INT, `subject` INT, `id_question` INT, `points` INT, `negative_points` INT, `unanswered_points` INT);

-- -----------------------------------------------------
-- View `rulefree`.`vw_testquestion`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `rulefree`.`vw_testquestion` ;
DROP TABLE IF EXISTS `rulefree`.`vw_testquestion`;
USE `rulefree`;
CREATE OR REPLACE VIEW `rulefree`.`vw_testquestion` AS
SELECT t.id_test AS id_test, tg.id_testsegment AS id_testsegment, ts.id_testsection AS id_testsection, ts.id_section_ref AS id_section_derived, 
        s.id_section AS id_section_actual, sk.id_skill AS id_skill, 
        IFNULL(q.id_reference_topic, tp.id_topic) AS id_topic, 
        IFNULL(q.id_reference_level, l.id_level) AS id_level, 
        l.`subject` AS `subject`, 
        q.id_question AS id_question,
        ts.points_per_question AS points,
        ts.negative_points_per_question AS negative_points,
        ts.unanswered_points_per_question AS unanswered_points
FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
            INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
            INNER JOIN section s ON ts.id_section_ref = s.id_section AND s.section_type != 'ds'
            INNER JOIN question q ON q.id_section = s.id_section
            INNER JOIN skill sk ON s.id_skill = sk.id_skill 
            INNER JOIN topic tp ON sk.id_topic = tp.id_topic 
            INNER JOIN level l ON tp.id_level = l.id_level

UNION 

SELECT t.id_test AS id_test, tg.id_testsegment AS id_testsegment, ts.id_testsection AS id_testsection, ts.id_section_ref AS id_section_derived, 
        rs.id_section AS id_section_actual, sk.id_skill AS id_skill, 
        IFNULL(q.id_reference_topic, tp.id_topic) AS id_topic, 
        IFNULL(q.id_reference_level, l.id_level) AS id_level,
        l.`subject` AS `subject`, 
        q.id_question AS id_question,
        ts.points_per_question AS points,
        ts.negative_points_per_question AS negative_points,
        ts.unanswered_points_per_question AS unanswered_points
FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
            INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
            INNER JOIN section s ON ts.id_section_ref = s.id_section AND s.section_type = 'ds'
            INNER JOIN derived_section_question dsq ON dsq.id_section = s.id_section 
            INNER JOIN question q ON dsq.id_question = q.id_question 
            INNER JOIN section rs ON q.id_section = rs.id_section
            INNER JOIN skill sk ON rs.id_skill = sk.id_skill
            INNER JOIN topic tp ON sk.id_topic = tp.id_topic 
            INNER JOIN level l ON tp.id_level = l.id_level
;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
