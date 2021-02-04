SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;
USE `rulefree` ;

-- -----------------------------------------------------
-- procedure update_anal_data_stats_for_abiptest
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`update_anal_data_stats_for_abiptest`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`update_anal_data_stats_for_abiptest` (IN v_in_idUsertest BIGINT)
BEGIN
    -- Declare Question and Point count variables at a Test Level
    DECLARE v_finished INTEGER DEFAULT 0;

    -- Delete and Insert into anal_test_data
   DELETE FROM `anal_test_data` WHERE `id_usertest` = v_in_idUsertest;
   INSERT INTO `anal_test_data`(`id_usertest`,`id_test`,`correct_count`,`correct_points`,`percentage`) 
    SELECT ti.id_usertest AS id_usertest, 
            ti.id_test AS id_test, 
            ti.correct_count AS correct_count,
            ti.user_points AS correct_points, 
            ((ti.user_points/ti.point_count) * 100) as percentage
    FROM abiptestinstance ti
    WHERE ti.id_usertest = v_in_idUsertest;
    
    -- Delete and Insert into anal_testsection_data
   DELETE FROM `anal_testsection_data` WHERE `id_usertest` = v_in_idUsertest;
   INSERT INTO `anal_testsection_data`(`id_usertest`,`id_testsection`,`id_test`,`correct_count`,`correct_points`,`percentage`)
    SELECT ti.id_usertest AS id_usertest, 
            tis.id_testsection AS id_testsection,
            ti.id_test AS id_test, 
            tis.correct_count AS correct_count,
            tis.user_points AS correct_points, 
            ((tis.user_points/tis.point_count) * 100) as percentage
    FROM abiptestinstance ti LEFT JOIN abiptestinstance_section tis ON tis.id_testinstance = ti.id_testinstance
    WHERE ti.id_usertest = v_in_idUsertest;

    -- Delete and Insert into anal_testsubject_data
DELETE FROM `anal_testsubject_data` WHERE `id_usertest` = v_in_idUsertest;
INSERT INTO `anal_testsubject_data`(`id_usertest`,`subject`,`id_test`,`correct_count`,`total_count`,`correct_points`,`total_points`,`percentage`)
SELECT ti.id_usertest AS id_usertest, 
        vwtq.subject AS subject, 
        ti.id_test AS id_test, 
        IFNULL(innertable.correct_count, 0) AS correct_count,
        COUNT(tid.question_status) AS total_count, 
        SUM(tid.user_points) AS correct_points,
        SUM(vwtq.points) AS total_points, 
        (SUM(tid.user_points)/SUM(vwtq.points) * 100) AS percentage
FROM vw_testquestion vwtq LEFT JOIN abiptestinstance_detail tid ON vwtq.id_question = tid.id_question
                        LEFT JOIN abiptestinstance_section tis ON tid.id_testinstance_section = tis.id_testinstance_section AND 
                                                                    tis.id_section = vwtq.id_section_derived
                        LEFT JOIN abiptestinstance ti ON tis.id_testinstance = ti.id_testinstance
                        LEFT JOIN test t ON ti.id_test = t.id_test
LEFT JOIN (
        SELECT ti_inner.id_usertest AS id_usertest, 
                vwtq_inner.subject AS subject, 
                COUNT(tid_inner.question_status) AS correct_count
        FROM vw_testquestion vwtq_inner LEFT JOIN abiptestinstance_detail tid_inner ON vwtq_inner.id_question = tid_inner.id_question
                                LEFT JOIN abiptestinstance_section tis_inner ON tid_inner.id_testinstance_section = tis_inner.id_testinstance_section AND 
                                                                                tis_inner.id_section = vwtq_inner.id_section_derived
                                LEFT JOIN abiptestinstance ti_inner ON tis_inner.id_testinstance = ti_inner.id_testinstance
                                LEFT JOIN test t_inner ON ti_inner.id_test = t_inner.id_test
        WHERE ti_inner.id_usertest = v_in_idUsertest AND tid_inner.question_status = 'C'
        GROUP BY vwtq_inner.subject
) AS innertable ON innertable.id_usertest = ti.id_usertest AND innertable.subject = vwtq.subject
WHERE ti.id_usertest = v_in_idUsertest
GROUP BY vwtq.subject
ORDER BY vwtq.subject;



    -- Delete and Insert into anal_testlevel_data
DELETE FROM `anal_testlevel_data` WHERE `id_usertest` = v_in_idUsertest;
INSERT INTO `anal_testlevel_data`(`id_usertest`,`id_level`,`id_test`,`correct_count`,`total_count`,`correct_points`,`total_points`,`percentage`)
SELECT ti.id_usertest AS id_usertest, 
        vwtq.id_level AS id_level, 
        ti.id_test AS id_test, 
        IFNULL(innertable.correct_count, 0) AS correct_count,
        COUNT(tid.question_status) AS total_count, 
        SUM(tid.user_points) AS correct_points,
        SUM(vwtq.points) AS total_points, 
        (SUM(tid.user_points)/SUM(vwtq.points) * 100) AS percentage
FROM vw_testquestion vwtq LEFT JOIN abiptestinstance_detail tid ON vwtq.id_question = tid.id_question
                        LEFT JOIN abiptestinstance_section tis ON tid.id_testinstance_section = tis.id_testinstance_section AND 
                                                                    tis.id_section = vwtq.id_section_derived
                        LEFT JOIN abiptestinstance ti ON tis.id_testinstance = ti.id_testinstance
                        LEFT JOIN test t ON ti.id_test = t.id_test
LEFT JOIN (
        SELECT ti_inner.id_usertest AS id_usertest, 
                vwtq_inner.id_level AS id_level, 
                COUNT(tid_inner.question_status) AS correct_count
        FROM vw_testquestion vwtq_inner LEFT JOIN abiptestinstance_detail tid_inner ON vwtq_inner.id_question = tid_inner.id_question
                                LEFT JOIN abiptestinstance_section tis_inner ON tid_inner.id_testinstance_section = tis_inner.id_testinstance_section AND 
                                                                                tis_inner.id_section = vwtq_inner.id_section_derived
                                LEFT JOIN abiptestinstance ti_inner ON tis_inner.id_testinstance = ti_inner.id_testinstance
                                LEFT JOIN test t_inner ON ti_inner.id_test = t_inner.id_test
        WHERE ti_inner.id_usertest = v_in_idUsertest AND tid_inner.question_status = 'C'
        GROUP BY vwtq_inner.id_level
) AS innertable ON innertable.id_usertest = ti.id_usertest AND innertable.id_level = vwtq.id_level
WHERE ti.id_usertest = v_in_idUsertest
GROUP BY vwtq.id_level
ORDER BY vwtq.id_level;

    -- Delete and Insert into anal_testtopic_data
DELETE FROM `anal_testtopic_data` WHERE `id_usertest` = v_in_idUsertest;
INSERT INTO `anal_testtopic_data`(`id_usertest`,`id_topic`,`id_test`,`correct_count`,`total_count`,`correct_points`,`total_points`,`percentage`)
SELECT ti.id_usertest AS id_usertest, 
        vwtq.id_topic AS id_topic, 
        ti.id_test AS id_test, 
        IFNULL(innertable.correct_count, 0) AS correct_count,
        COUNT(tid.question_status) AS total_count, 
        SUM(tid.user_points) AS correct_points,
        SUM(vwtq.points) AS total_points, 
        (SUM(tid.user_points)/SUM(vwtq.points) * 100) AS percentage
FROM vw_testquestion vwtq LEFT JOIN abiptestinstance_detail tid ON vwtq.id_question = tid.id_question
                        LEFT JOIN abiptestinstance_section tis ON tid.id_testinstance_section = tis.id_testinstance_section AND 
                                                                    tis.id_section = vwtq.id_section_derived
                        LEFT JOIN abiptestinstance ti ON tis.id_testinstance = ti.id_testinstance
                        LEFT JOIN test t ON ti.id_test = t.id_test
LEFT JOIN (
        SELECT ti_inner.id_usertest AS id_usertest, 
                vwtq_inner.id_topic AS id_topic, 
                COUNT(tid_inner.question_status) AS correct_count
        FROM vw_testquestion vwtq_inner LEFT JOIN abiptestinstance_detail tid_inner ON vwtq_inner.id_question = tid_inner.id_question
                                LEFT JOIN abiptestinstance_section tis_inner ON tid_inner.id_testinstance_section = tis_inner.id_testinstance_section AND 
                                                                                tis_inner.id_section = vwtq_inner.id_section_derived
                                LEFT JOIN abiptestinstance ti_inner ON tis_inner.id_testinstance = ti_inner.id_testinstance
                                LEFT JOIN test t_inner ON ti_inner.id_test = t_inner.id_test
        WHERE ti_inner.id_usertest = v_in_idUsertest AND tid_inner.question_status = 'C'
        GROUP BY vwtq_inner.id_topic
) AS innertable ON innertable.id_usertest = ti.id_usertest AND innertable.id_topic = vwtq.id_topic
WHERE ti.id_usertest = v_in_idUsertest
GROUP BY vwtq.id_topic
ORDER BY vwtq.id_topic;


END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure update_anal_data_stats_for_usertest
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`update_anal_data_stats_for_usertest`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`update_anal_data_stats_for_usertest` (IN v_in_idUsertest BIGINT)
BEGIN

    -- Declare Question and Point count variables at a Test Level
    DECLARE v_finished INTEGER DEFAULT 0;

    -- Delete and Insert into anal_test_data
   DELETE FROM `anal_test_data` WHERE `id_usertest` = v_in_idUsertest;
   INSERT INTO `anal_test_data`(`id_usertest`,`id_test`,`correct_count`,`correct_points`,`percentage`) 
    SELECT ti.id_usertest AS id_usertest, 
            ti.id_test AS id_test, 
            ti.correct_count AS correct_count,
            ti.user_points AS correct_points, 
            ((ti.user_points/ti.point_count) * 100) as percentage
    FROM testinstance ti
    WHERE ti.id_usertest = v_in_idUsertest;
    
    -- Delete and Insert into anal_testsection_data
   DELETE FROM `anal_testsection_data` WHERE `id_usertest` = v_in_idUsertest;
   INSERT INTO `anal_testsection_data`(`id_usertest`,`id_testsection`,`id_test`,`correct_count`,`correct_points`,`percentage`)
    SELECT ti.id_usertest AS id_usertest, 
            tis.id_testsection AS id_testsection,
            ti.id_test AS id_test, 
            tis.correct_count AS correct_count,
            tis.user_points AS correct_points, 
            ((tis.user_points/tis.point_count) * 100) as percentage
    FROM testinstance ti LEFT JOIN testinstance_section tis ON tis.id_testinstance = ti.id_testinstance
    WHERE ti.id_usertest = v_in_idUsertest;

    -- Delete and Insert into anal_testsubject_data
DELETE FROM `anal_testsubject_data` WHERE `id_usertest` = v_in_idUsertest;
INSERT INTO `anal_testsubject_data`(`id_usertest`,`subject`,`id_test`,`correct_count`,`total_count`,`correct_points`,`total_points`,`percentage`)
SELECT ti.id_usertest AS id_usertest, 
        vwtq.subject AS subject, 
        ti.id_test AS id_test, 
        IFNULL(innertable.correct_count, 0) AS correct_count,
        COUNT(tid.question_status) AS total_count, 
        SUM(tid.user_points) AS correct_points,
        SUM(vwtq.points) AS total_points, 
        (SUM(tid.user_points)/SUM(vwtq.points) * 100) AS percentage
FROM vw_testquestion vwtq LEFT JOIN testinstance_detail tid ON vwtq.id_question = tid.id_question
                        LEFT JOIN testinstance_section tis ON tid.id_testinstance_section = tis.id_testinstance_section AND 
                                                                tis.id_section = vwtq.id_section_derived
                        LEFT JOIN testinstance ti ON tis.id_testinstance = ti.id_testinstance
                        LEFT JOIN test t ON ti.id_test = t.id_test
LEFT JOIN (
        SELECT ti_inner.id_usertest AS id_usertest, 
                vwtq_inner.subject AS subject, 
                COUNT(tid_inner.question_status) AS correct_count
        FROM vw_testquestion vwtq_inner LEFT JOIN testinstance_detail tid_inner ON vwtq_inner.id_question = tid_inner.id_question
                                LEFT JOIN testinstance_section tis_inner ON tid_inner.id_testinstance_section = tis_inner.id_testinstance_section AND 
                                                                            tis_inner.id_section = vwtq_inner.id_section_derived
                                LEFT JOIN testinstance ti_inner ON tis_inner.id_testinstance = ti_inner.id_testinstance
                                LEFT JOIN test t_inner ON ti_inner.id_test = t_inner.id_test
        WHERE ti_inner.id_usertest = v_in_idUsertest AND tid_inner.question_status = 'C'
        GROUP BY vwtq_inner.subject
) AS innertable ON innertable.id_usertest = ti.id_usertest AND innertable.subject = vwtq.subject
WHERE ti.id_usertest = v_in_idUsertest
GROUP BY vwtq.subject
ORDER BY vwtq.subject;



    -- Delete and Insert into anal_testlevel_data
DELETE FROM `anal_testlevel_data` WHERE `id_usertest` = v_in_idUsertest;
INSERT INTO `anal_testlevel_data`(`id_usertest`,`id_level`,`id_test`,`correct_count`,`total_count`,`correct_points`,`total_points`,`percentage`)
SELECT ti.id_usertest AS id_usertest, 
        vwtq.id_level AS id_level, 
        ti.id_test AS id_test, 
        IFNULL(innertable.correct_count, 0) AS correct_count,
        COUNT(tid.question_status) AS total_count, 
        SUM(tid.user_points) AS correct_points,
        SUM(vwtq.points) AS total_points, 
        (SUM(tid.user_points)/SUM(vwtq.points) * 100) AS percentage
FROM vw_testquestion vwtq LEFT JOIN testinstance_detail tid ON vwtq.id_question = tid.id_question
                        LEFT JOIN testinstance_section tis ON tid.id_testinstance_section = tis.id_testinstance_section AND 
                                                                tis.id_section = vwtq.id_section_derived
                        LEFT JOIN testinstance ti ON tis.id_testinstance = ti.id_testinstance
                        LEFT JOIN test t ON ti.id_test = t.id_test
LEFT JOIN (
        SELECT ti_inner.id_usertest AS id_usertest, 
                vwtq_inner.id_level AS id_level, 
                COUNT(tid_inner.question_status) AS correct_count
        FROM vw_testquestion vwtq_inner LEFT JOIN testinstance_detail tid_inner ON vwtq_inner.id_question = tid_inner.id_question
                                LEFT JOIN testinstance_section tis_inner ON tid_inner.id_testinstance_section = tis_inner.id_testinstance_section AND 
                                                                            tis_inner.id_section = vwtq_inner.id_section_derived
                                LEFT JOIN testinstance ti_inner ON tis_inner.id_testinstance = ti_inner.id_testinstance
                                LEFT JOIN test t_inner ON ti_inner.id_test = t_inner.id_test
        WHERE ti_inner.id_usertest = v_in_idUsertest AND tid_inner.question_status = 'C'
        GROUP BY vwtq_inner.id_level
) AS innertable ON innertable.id_usertest = ti.id_usertest AND innertable.id_level = vwtq.id_level
WHERE ti.id_usertest = v_in_idUsertest
GROUP BY vwtq.id_level
ORDER BY vwtq.id_level;

    -- Delete and Insert into anal_testtopic_data
DELETE FROM `anal_testtopic_data` WHERE `id_usertest` = v_in_idUsertest;
INSERT INTO `anal_testtopic_data`(`id_usertest`,`id_topic`,`id_test`,`correct_count`,`total_count`,`correct_points`,`total_points`,`percentage`)
SELECT ti.id_usertest AS id_usertest, 
        vwtq.id_topic AS id_topic, 
        ti.id_test AS id_test, 
        IFNULL(innertable.correct_count, 0) AS correct_count,
        COUNT(tid.question_status) AS total_count, 
        SUM(tid.user_points) AS correct_points,
        SUM(vwtq.points) AS total_points, 
        (SUM(tid.user_points)/SUM(vwtq.points) * 100) AS percentage
FROM vw_testquestion vwtq LEFT JOIN testinstance_detail tid ON vwtq.id_question = tid.id_question
                        LEFT JOIN testinstance_section tis ON tid.id_testinstance_section = tis.id_testinstance_section AND 
                                                                tis.id_section = vwtq.id_section_derived
                        LEFT JOIN testinstance ti ON tis.id_testinstance = ti.id_testinstance
                        LEFT JOIN test t ON ti.id_test = t.id_test
LEFT JOIN (
        SELECT ti_inner.id_usertest AS id_usertest, 
                vwtq_inner.id_topic AS id_topic, 
                COUNT(tid_inner.question_status) AS correct_count
        FROM vw_testquestion vwtq_inner LEFT JOIN testinstance_detail tid_inner ON vwtq_inner.id_question = tid_inner.id_question
                                LEFT JOIN testinstance_section tis_inner ON tid_inner.id_testinstance_section = tis_inner.id_testinstance_section AND 
                                                                            tis_inner.id_section = vwtq_inner.id_section_derived
                                LEFT JOIN testinstance ti_inner ON tis_inner.id_testinstance = ti_inner.id_testinstance
                                LEFT JOIN test t_inner ON ti_inner.id_test = t_inner.id_test
        WHERE ti_inner.id_usertest = v_in_idUsertest AND tid_inner.question_status = 'C'
        GROUP BY vwtq_inner.id_topic
) AS innertable ON innertable.id_usertest = ti.id_usertest AND innertable.id_topic = vwtq.id_topic
WHERE ti.id_usertest = v_in_idUsertest
GROUP BY vwtq.id_topic
ORDER BY vwtq.id_topic;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure update_anal_rollup_stats_for_test
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`update_anal_rollup_stats_for_test`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`update_anal_rollup_stats_for_test` (IN v_in_idTest BIGINT)
BEGIN

DELETE FROM `anal_test_rollup` WHERE `id_test` = v_in_idTest;
INSERT INTO `anal_test_rollup` (`id_test`,`correct_count_average`,`correct_points_average`,`percentage_average`,`sd1`,`percentile_distribution`)
SELECT ad.id_test AS id_test,
        SUM(ad.correct_count)/COUNT(ad.correct_count) AS correct_count_average, 
        SUM(ad.correct_points)/COUNT(ad.correct_points) AS correct_points_average, 
        SUM(ad.percentage)/COUNT(ad.percentage) AS percentage_average,
        FORMAT(STD(ad.percentage),2),
        GROUP_CONCAT(DISTINCT CONCAT(atp.id_percentile, ',', atp.percentage) ORDER BY atp.id_percentile ASC SEPARATOR ';')
FROM anal_test_data ad LEFT JOIN test t ON ad.id_test = t.id_test 
                        LEFT JOIN anal_test_percentiles atp ON atp.id_test = t.id_test
WHERE ad.id_test = v_in_idTest
GROUP BY ad.id_test
ORDER BY ad.id_test;

DELETE FROM `anal_testsection_rollup` WHERE `id_test` = v_in_idTest;
INSERT INTO `anal_testsection_rollup`(`id_testsection`,`id_testsegment`,`id_test`,`correct_count_average`,`correct_points_average`,`percentage_average`,`sd1`,`percentile_distribution`)
SELECT ads.id_testsection AS id_testsection,
        tg.id_testsegment AS id_testsegment,
        t.id_test AS id_test, 
        SUM(ads.correct_count)/COUNT(ads.correct_count) AS correct_count_average, 
        SUM(ads.correct_points)/COUNT(ads.correct_points) AS correct_points_average, 
        SUM(ads.percentage)/COUNT(ads.percentage) AS percentage_average,
        FORMAT(STD(ads.percentage),2) AS sd1,
        GROUP_CONCAT(DISTINCT CONCAT(atp.id_percentile, ',', atp.percentage) ORDER BY atp.id_percentile ASC SEPARATOR ';')
FROM anal_testsection_data ads LEFT JOIN testsection ts ON ads.id_testsection = ts.id_testsection 
                                LEFT JOIN testsegment tg ON ts.id_testsegment = tg.id_testsegment 
                                LEFT JOIN test t ON tg.id_test = t.id_test
                                LEFT JOIN anal_testsection_percentiles atp ON atp.id_testsection = ts.id_testsection
WHERE t.id_test = v_in_idTest
GROUP BY ads.id_testsection
ORDER BY ads.id_testsection;


DELETE FROM `anal_testsubject_rollup` WHERE `id_test` = v_in_idTest;
INSERT INTO `anal_testsubject_rollup`(`subject`,`id_test`,`correct_count_average`,`total_count`,`correct_points_average`,`total_points`,`percentage_average`,`sd1`,`percentile_distribution`)
SELECT ad.`subject` AS subject,
        t.id_test AS id_test, 
        SUM(ad.correct_count)/COUNT(ad.correct_count) AS correct_count_average, 
        MAX(ad.total_count) AS total_count,
        SUM(ad.correct_points)/COUNT(ad.correct_points) AS correct_points_average, 
        MAX(total_points) AS total_points,
        SUM(ad.percentage)/COUNT(ad.percentage) AS percentage_average,
        FORMAT(STD(ad.percentage),2) AS sd1,
        GROUP_CONCAT(DISTINCT CONCAT(atp.id_percentile, ',', atp.percentage) ORDER BY atp.id_percentile ASC SEPARATOR ';')
FROM anal_testsubject_data ad LEFT JOIN test t ON ad.id_test = t.id_test
                                LEFT JOIN anal_testsubject_percentiles atp ON atp.`subject` = ad.`subject`
WHERE t.id_test = v_in_idTest
GROUP BY ad.`subject`
ORDER BY ad.`subject`;

DELETE FROM `anal_testlevel_rollup` WHERE `id_test` = v_in_idTest;
INSERT INTO `anal_testlevel_rollup`(`id_level`,`id_test`,`correct_count_average`,`total_count`,`correct_points_average`,`total_points`,`percentage_average`,`sd1`,`percentile_distribution`)
SELECT ad.id_level AS id_level,
        t.id_test AS id_test, 
        SUM(ad.correct_count)/COUNT(ad.correct_count) AS correct_count_average, 
        MAX(ad.total_count) AS total_count,
        SUM(ad.correct_points)/COUNT(ad.correct_points) AS correct_points_average, 
        MAX(total_points) AS total_points,
        SUM(ad.percentage)/COUNT(ad.percentage) AS percentage_average,
        FORMAT(STD(ad.percentage),2) AS sd1,
        GROUP_CONCAT(DISTINCT CONCAT(atp.id_percentile, ',', atp.percentage) ORDER BY atp.id_percentile ASC SEPARATOR ';')
FROM anal_testlevel_data ad LEFT JOIN test t ON ad.id_test = t.id_test
                            LEFT JOIN anal_testlevel_percentiles atp ON atp.id_level = ad.id_level
WHERE t.id_test = v_in_idTest
GROUP BY ad.id_level
ORDER BY ad.id_level;

DELETE FROM `anal_testtopic_rollup` WHERE `id_test` = v_in_idTest;
INSERT INTO `anal_testtopic_rollup`(`id_topic`,`id_test`,`correct_count_average`,`total_count`,`correct_points_average`,`total_points`,`percentage_average`,`sd1`,`percentile_distribution`)
SELECT ad.id_topic AS id_topic,
        t.id_test AS id_test, 
        SUM(ad.correct_count)/COUNT(ad.correct_count) AS correct_count_average, 
        MAX(ad.total_count) AS total_count,
        SUM(ad.correct_points)/COUNT(ad.correct_points) AS correct_points_average, 
        MAX(total_points) AS total_points,
        SUM(ad.percentage)/COUNT(ad.percentage) AS percentage_average,
        FORMAT(STD(ad.percentage),2) AS sd1,
        GROUP_CONCAT(DISTINCT CONCAT(atp.id_percentile, ',', atp.percentage) ORDER BY atp.id_percentile ASC SEPARATOR ';')
FROM anal_testtopic_data ad LEFT JOIN test t ON ad.id_test = t.id_test
                            LEFT JOIN anal_testtopic_percentiles atp ON atp.id_topic = ad.id_topic
WHERE t.id_test = v_in_idTest
GROUP BY ad.id_topic
ORDER BY ad.id_topic;

END$$

DELIMITER ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
