SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;
USE `rulefree` ;

-- -----------------------------------------------------
-- View `rulefree`.`vw_profiletest`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `rulefree`.`vw_profiletest` ;
USE `rulefree`;
CREATE OR REPLACE VIEW `rulefree`.`vw_profiletest` AS
SELECT  p.name AS profile_name, 
        pg.name AS profilesegment_name, 
        pt.name AS profiletest_name, 
        pt.* 
FROM profiletest pt LEFT JOIN profile p ON pt.id_profile = p.id_profile
                    LEFT JOIN profilesegment pg ON pt.id_profilesegment = pg.id_profilesegment;

;

-- -----------------------------------------------------
-- View `rulefree`.`vw_profile`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `rulefree`.`vw_profile` ;
USE `rulefree`;
CREATE OR REPLACE VIEW `rulefree`.`vw_profile` AS
SELECT  u.username AS provider_name, 
        o.name AS organization_name, 
        (CASE 
           WHEN p.profile_type = 1 THEN 'Exact Dates'
           WHEN p.profile_type = 2 THEN 'Fixed Days'
           WHEN p.profile_type = 3 THEN 'Sequenced'
           ELSE 'UNKNOWN'
         END) AS profile_type_string,
        (CASE 
           WHEN p.access_level = 1 THEN 'Private'
           WHEN p.access_level = 2 THEN 'Organization'
           WHEN p.access_level = 3 THEN 'Public'
           ELSE 'UNKNOWN'
         END) AS access_level_string,
        p.* 
FROM profile p LEFT JOIN user u ON p.id_provider = u.id_user
                LEFT JOIN organization_provider op ON p.id_provider = op.id_provider 
                LEFT JOIN organization o ON op.id_organization = o.id_organization;



;

-- -----------------------------------------------------
-- View `rulefree`.`vw_profilesegment`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `rulefree`.`vw_profilesegment` ;
USE `rulefree`;
CREATE  OR REPLACE VIEW `rulefree`.`vw_profilesegment` AS
SELECT  p.name AS profile_name, 
        ps.* 
FROM profilesegment ps LEFT JOIN profile p ON ps.id_profile = p.id_profile;
;

-- -----------------------------------------------------
-- View `rulefree`.`vw_userprofile`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `rulefree`.`vw_userprofile` ;
USE `rulefree`;
CREATE OR REPLACE VIEW `rulefree`.`vw_userprofile` AS
SELECT  p.name AS profile_name, 
        provider.username AS provider_username,
        CONCAT(provider.first_name, ' ', provider.last_name) AS provider_full_name,
        student.username AS student_username,
        CONCAT(student.first_name, ' ', student.last_name) AS student_full_name,
        up.* 
FROM userprofile up LEFT JOIN profile p ON up.id_profile = p.id_profile
                 LEFT JOIN user provider ON up.id_provider = provider.id_user 
                 LEFT JOIN user student ON up.id_student = student.id_user;
;

-- -----------------------------------------------------
-- View `rulefree`.`vw_userprofiletest`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `rulefree`.`vw_userprofiletest` ;
USE `rulefree`;
CREATE OR REPLACE VIEW `rulefree`.`vw_userprofiletest` AS
SELECT  p.name AS profile_name, 
        t.name AS test_name, 
        provider.username AS provider_username,
        CONCAT(provider.first_name, ' ', provider.last_name) AS provider_full_name,
        student.username AS student_username,
        CONCAT(student.first_name, ' ', student.last_name) AS student_full_name,
        upt.* 
FROM userprofiletest upt LEFT JOIN profiletest pt ON upt.id_profiletest = pt.id_profiletest 
                 LEFT JOIN test t ON pt.id_test_ref = t.id_test 
                 LEFT JOIN userprofile up ON upt.id_userprofile = up.id_userprofile 
                 LEFT JOIN profile p ON up.id_profile = p.id_profile
                 LEFT JOIN user provider ON up.id_provider = provider.id_user 
                 LEFT JOIN user student ON up.id_student = student.id_user
ORDER BY id_userprofile;

;

-- -----------------------------------------------------
-- View `rulefree`.`vw_question`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `rulefree`.`vw_question` ;
USE `rulefree`;
CREATE OR REPLACE VIEW `rulefree`.`vw_question` AS
SELECT  c.name AS system_name,
        c.id_system AS id_system,
        l.name AS level_name,
        l.id_level AS id_level,
        l.subject AS level_subject,
        t.name AS topic_name,
        t.id_topic AS id_topic, 
        t.subject AS topic_subject,
        sk.name AS skill_name, 
        sk.id_skill AS id_skill, 
        s.name AS section_name, 
        q.* 
FROM question q LEFT JOIN section s ON q.id_section = s.id_section
                LEFT JOIN skill sk ON s.id_skill = sk.id_skill
                LEFT JOIN topic t ON sk.id_topic = t.id_topic
                LEFT JOIN level l ON t.id_level = l.id_level
                LEFT JOIN system c ON l.id_system = c.id_system;






;

-- -----------------------------------------------------
-- View `rulefree`.`vw_section`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `rulefree`.`vw_section` ;
USE `rulefree`;
CREATE OR REPLACE VIEW `rulefree`.`vw_section` AS
SELECT  c.name AS system_name,
        c.id_system AS id_system,
        l.name AS level_name,
        l.id_level AS id_level, 
        l.subject AS level_subject,
        t.name AS topic_name,
        t.id_topic AS id_topic, 
        t.subject AS topic_subject,
        sk.name AS skill_name, 
        s.* 
FROM section s LEFT JOIN skill sk ON s.id_skill = sk.id_skill
                LEFT JOIN topic t ON sk.id_topic = t.id_topic
                LEFT JOIN level l ON t.id_level = l.id_level
                LEFT JOIN system c ON l.id_system = c.id_system;

;

-- -----------------------------------------------------
-- View `rulefree`.`vw_skill`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `rulefree`.`vw_skill` ;
USE `rulefree`;
CREATE OR REPLACE VIEW `rulefree`.`vw_skill` AS 
SELECT  c.name AS system_name,
        c.id_system AS id_system,
        l.name AS level_name,
        l.id_level AS id_level, 
        l.subject AS level_subject,
        t.name AS topic_name,
        t.subject AS topic_subject,
        sk.* 
FROM skill sk LEFT JOIN topic t ON sk.id_topic = t.id_topic
                LEFT JOIN level l ON t.id_level = l.id_level
                LEFT JOIN system c ON l.id_system = c.id_system;
;

-- -----------------------------------------------------
-- View `rulefree`.`vw_topic`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `rulefree`.`vw_topic` ;
USE `rulefree`;
CREATE OR REPLACE VIEW `rulefree`.`vw_topic` AS
SELECT  c.name AS system_name,
        c.id_system AS id_system,
        l.name AS level_name,
        l.subject AS level_subject,
        t.* 
FROM topic t LEFT JOIN level l ON t.id_level = l.id_level
             LEFT JOIN system c ON l.id_system = c.id_system;
;

-- -----------------------------------------------------
-- View `rulefree`.`vw_level`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `rulefree`.`vw_level` ;
USE `rulefree`;
CREATE OR REPLACE VIEW `rulefree`.`vw_level` AS
SELECT  c.name AS system_name,
        l.* 
FROM level l LEFT JOIN system c ON l.id_system = c.id_system;
;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
