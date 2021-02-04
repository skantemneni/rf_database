SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;
USE `rulefree` ;

-- -----------------------------------------------------
-- procedure set_testinstances_percentiles_for_test
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`set_testinstances_percentiles_for_test`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`set_testinstances_percentiles_for_test` (IN v_in_idTest BIGINT)
BEGIN

    DECLARE v_finished INTEGER DEFAULT 0;

    DECLARE v_id_testinstance BIGINT DEFAULT 0;
    DECLARE v_percentile INT DEFAULT 0;

    -- Declare cursor to get the testinstances in a loop
    DECLARE testinstance_Cursor CURSOR FOR 
        SELECT id_testinstance FROM testinstance WHERE id_test = v_in_idTest;

    -- Declare cursor to get the abiptestinstances in a loop
    DECLARE abiptestinstance_Cursor CURSOR FOR 
        SELECT id_testinstance FROM abiptestinstance WHERE id_test = v_in_idTest;

    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET v_finished = 1;

    -- Update testinstance
    OPEN testinstance_Cursor;   
    -- Fetch in a loop
    get_testinstance: LOOP
        SET v_finished = 0;
        FETCH testinstance_Cursor INTO v_id_testinstance;
        IF v_finished = 1 THEN
            LEAVE get_testinstance;
        END IF;
        -- Calculate percentile
        SELECT MAX(atp.id_percentile) INTO v_percentile
        FROM anal_test_percentiles atp LEFT JOIN testinstance ati ON ati.id_test = atp.id_test 
                                        LEFT JOIN anal_test_data atd ON atd.id_usertest = ati.id_usertest 
        WHERE ati.id_testinstance = v_id_testinstance AND atp.percentage <= atd.percentage ;
        -- Update testinstance with percentile
        UPDATE testinstance SET percentile = v_percentile WHERE id_testinstance = v_id_testinstance AND id_test = v_in_idTest;
    END LOOP get_testinstance;
    
    -- close the cursor
    CLOSE testinstance_Cursor;

    -- Update abiptestinstance
    OPEN abiptestinstance_Cursor;   
    -- Fetch in a loop
    get_abiptestinstance: LOOP
        SET v_finished = 0;
        FETCH abiptestinstance_Cursor INTO v_id_testinstance;
        IF v_finished = 1 THEN
            LEAVE get_abiptestinstance;
        END IF;
        -- Calculate percentile
        SELECT MAX(atp.id_percentile) INTO v_percentile
        FROM anal_test_percentiles atp LEFT JOIN abiptestinstance ati ON ati.id_test = atp.id_test 
                                        LEFT JOIN anal_test_data atd ON atd.id_usertest = ati.id_usertest 
        WHERE ati.id_testinstance = v_id_testinstance AND atp.percentage <= atd.percentage ;
        -- Update testinstance with percentile
        UPDATE abiptestinstance SET percentile = v_percentile WHERE id_testinstance = v_id_testinstance AND id_test = v_in_idTest;
    END LOOP get_abiptestinstance;
    
    -- close the cursor
    CLOSE abiptestinstance_Cursor;


END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure set_testinstance_sections_percentiles_for_test
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`set_testinstance_sections_percentiles_for_test`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`set_testinstance_sections_percentiles_for_test` (IN v_in_idTest BIGINT)
BEGIN
    DECLARE v_finished INTEGER DEFAULT 0;

    DECLARE v_percentile INT DEFAULT 0;
    DECLARE v_id_testinstance BIGINT DEFAULT 0;
    DECLARE v_id_testsection BIGINT DEFAULT 0;

    -- Declare cursor to get the testinstance_sections in a loop
    DECLARE testinstance_section_Cursor CURSOR FOR 
        SELECT MAX(atsp.id_percentile) AS v_max_percentage, ti.id_testinstance AS id_testinstance, ts.id_testsection AS id_testsection
        FROM testinstance ti LEFT JOIN testsegment tg ON tg.id_test = ti.id_test LEFT JOIN testsection ts ON tg.id_testsegment = ts.id_testsegment
                                LEFT JOIN anal_testsection_data atsd ON atsd.id_testsection = ts.id_testsection AND atsd.id_usertest = ti.id_usertest
                                LEFT JOIN anal_testsection_percentiles atsp ON atsp.id_testsection = ts.id_testsection
        WHERE ti.id_test = v_in_idTest AND atsp.percentage <= atsd.percentage
        GROUP BY ti.id_test, ti.id_testinstance, ts.id_testsection 
        ORDER BY ti.id_test, ti.id_testinstance, ts.id_testsection;

    -- Declare cursor to get the abiptestinstance_sections in a loop
    DECLARE abiptestinstance_section_Cursor CURSOR FOR 
        SELECT MAX(atsp.id_percentile) AS v_max_percentage, ti.id_testinstance AS id_testinstance, ts.id_testsection AS id_testsection
        FROM abiptestinstance ti LEFT JOIN testsegment tg ON tg.id_test = ti.id_test LEFT JOIN testsection ts ON tg.id_testsegment = ts.id_testsegment
                                LEFT JOIN anal_testsection_data atsd ON atsd.id_testsection = ts.id_testsection AND atsd.id_usertest = ti.id_usertest
                                LEFT JOIN anal_testsection_percentiles atsp ON atsp.id_testsection = ts.id_testsection
        WHERE ti.id_test = v_in_idTest AND atsp.percentage <= atsd.percentage
        GROUP BY ti.id_test, ti.id_testinstance, ts.id_testsection 
        ORDER BY ti.id_test, ti.id_testinstance, ts.id_testsection;

    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET v_finished = 1;

    -- Update testinstance_sections
    OPEN testinstance_section_Cursor;   
    -- Fetch in a loop
    get_testinstance_section: LOOP
        SET v_finished = 0;
        FETCH testinstance_section_Cursor INTO v_percentile, v_id_testinstance, v_id_testsection;
        IF v_finished = 1 THEN
            LEAVE get_testinstance_section;
        END IF;
        -- Update testinstance with percentile
        UPDATE testinstance_section atis LEFT JOIN testsection ts ON atis.id_section = ts.id_section_ref
        SET atis.percentile = v_percentile
        WHERE atis.id_testinstance = v_id_testinstance AND ts.id_testsection = v_id_testsection;
    END LOOP get_testinstance_section;
    -- close the cursor
    CLOSE testinstance_section_Cursor;

    -- Update testinstance
    OPEN abiptestinstance_section_Cursor;   
    -- Fetch in a loop
    get_abiptestinstance_section: LOOP
        SET v_finished = 0;
        FETCH abiptestinstance_section_Cursor INTO v_percentile, v_id_testinstance, v_id_testsection;
        IF v_finished = 1 THEN
            LEAVE get_abiptestinstance_section;
        END IF;
        -- Update testinstance with percentile
        UPDATE abiptestinstance_section atis LEFT JOIN testsection ts ON atis.id_section = ts.id_section_ref
        SET atis.percentile = v_percentile
        WHERE atis.id_testinstance = v_id_testinstance AND ts.id_testsection = v_id_testsection;
    END LOOP get_abiptestinstance_section;
    -- close the cursor
    CLOSE abiptestinstance_section_Cursor;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure set_all_percentiles_for_test
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`set_all_percentiles_for_test`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`set_all_percentiles_for_test` (IN v_in_idTest BIGINT)
BEGIN
    CALL set_testinstances_percentiles_for_test(v_in_idTest);
    CALL set_testinstance_sections_percentiles_for_test(v_in_idTest);
    CALL set_testsubjects_percentiles_for_test(v_in_idTest);
    CALL set_testlevels_percentiles_for_test(v_in_idTest);
    CALL set_testtopics_percentiles_for_test(v_in_idTest);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure set_all_percentiles_for_usertest
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`set_all_percentiles_for_usertest`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`set_all_percentiles_for_usertest` (IN v_in_idUsertest BIGINT)
BEGIN
    DECLARE v_finished INTEGER DEFAULT 0;

    DECLARE v_percentile INT DEFAULT 0;
    DECLARE v_id_usertest BIGINT DEFAULT 0;
    DECLARE v_subject VARCHAR(45) DEFAULT null;
    DECLARE v_id_level BIGINT DEFAULT 0;
    DECLARE v_id_topic BIGINT DEFAULT 0;
    DECLARE v_id_testinstance BIGINT DEFAULT 0;
    DECLARE v_id_testsection BIGINT DEFAULT 0;

    -- Declare cursor to get the testinstance_sections in a loop - for usertest
    DECLARE testinstance_section_Cursor CURSOR FOR 
        SELECT MAX(atsp.id_percentile) AS v_max_percentage, ti.id_testinstance AS id_testinstance, ts.id_testsection AS id_testsection
        FROM testinstance ti LEFT JOIN testsegment tg ON tg.id_test = ti.id_test LEFT JOIN testsection ts ON tg.id_testsegment = ts.id_testsegment
                                LEFT JOIN anal_testsection_data atsd ON atsd.id_testsection = ts.id_testsection AND atsd.id_usertest = ti.id_usertest
                                LEFT JOIN anal_testsection_percentiles atsp ON atsp.id_testsection = ts.id_testsection
        WHERE ti.id_usertest = v_in_idUsertest AND atsp.percentage <= atsd.percentage
        GROUP BY ti.id_test, ti.id_testinstance, ts.id_testsection 
        ORDER BY ti.id_test, ti.id_testinstance, ts.id_testsection;

    -- Declare cursor to get the subjects in a loop
    DECLARE testsubject_Cursor CURSOR FOR 
        SELECT atsd.subject, MAX(atsp.id_percentile)
        FROM anal_testsubject_data atsd LEFT JOIN anal_testsubject_percentiles atsp ON atsp.subject = atsd.subject
        WHERE atsd.id_usertest = v_in_idUsertest AND atsp.percentage <= atsd.percentage
        GROUP BY atsd.id_usertest , atsd.subject;

    -- Declare cursor to get the levels in a loop
    DECLARE testlevel_Cursor CURSOR FOR 
        SELECT atld.id_level, MAX(atlp.id_percentile)
        FROM anal_testlevel_data atld LEFT JOIN anal_testlevel_percentiles atlp ON atlp.id_level = atld.id_level
        WHERE atld.id_usertest = v_in_idUsertest AND atlp.percentage <= atld.percentage
        GROUP BY atld.id_usertest , atld.id_level;

    -- Declare cursor to get the topics in a loop
    DECLARE testtopic_Cursor CURSOR FOR 
        SELECT attd.id_topic, MAX(attp.id_percentile)
        FROM anal_testtopic_data attd LEFT JOIN anal_testtopic_percentiles attp ON attp.id_topic = attd.id_topic
        WHERE attd.id_usertest = v_in_idUsertest AND attp.percentage <= attd.percentage
        GROUP BY attd.id_usertest, attd.id_topic;

    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET v_finished = 1;

     -- Update testinstance for non-ABIP usertest
    SELECT MAX(atp.id_percentile) INTO v_percentile
    FROM testinstance ati LEFT JOIN anal_test_percentiles atp ON ati.id_test = atp.id_test 
                                    LEFT JOIN anal_test_data atd ON atd.id_usertest = ati.id_usertest 
    WHERE ati.id_usertest = 2603 AND atp.percentage <= atd.percentage ;
    UPDATE testinstance ati SET ati.percentile = v_percentile WHERE ati.id_usertest = v_in_idUsertest;

   -- Update testinstance_sections
    OPEN testinstance_section_Cursor;   
    -- Fetch in a loop
    get_testinstance_section: LOOP
        SET v_finished = 0;
        FETCH testinstance_section_Cursor INTO v_percentile, v_id_testinstance, v_id_testsection;
        IF v_finished = 1 THEN
            LEAVE get_testinstance_section;
        END IF;
        -- Update testinstance with percentile
        UPDATE testinstance_section atis LEFT JOIN testsection ts ON atis.id_section = ts.id_section_ref
        SET atis.percentile = v_percentile
        WHERE atis.id_testinstance = v_id_testinstance AND ts.id_testsection = v_id_testsection;
    END LOOP get_testinstance_section;
    -- close the cursor
    CLOSE testinstance_section_Cursor;

    -- Update subject percentiles for all usertests in test
    OPEN testsubject_Cursor;   
    -- Fetch in a loop
    get_testsubject: LOOP
        SET v_finished = 0;
        FETCH testsubject_Cursor INTO v_subject, v_percentile;
        IF v_finished = 1 THEN
            LEAVE get_testsubject;
        END IF;
        -- Update testinstance with percentile
        UPDATE anal_testsubject_data atsd
        SET atsd.percentile = v_percentile
        WHERE atsd.id_usertest = v_in_idUsertest AND atsd.subject = v_subject;
    END LOOP get_testsubject;
    -- close the cursor
    CLOSE testsubject_Cursor;

    -- Update level percentiles for usertest
    OPEN testlevel_Cursor;   
    -- Fetch in a loop
    get_testlevel: LOOP
        SET v_finished = 0;
        FETCH testlevel_Cursor INTO v_id_level, v_percentile;
        IF v_finished = 1 THEN
            LEAVE get_testlevel;
        END IF;
        -- Update testinstance with percentile
        UPDATE anal_testlevel_data atld
        SET atld.percentile = v_percentile
        WHERE atld.id_usertest = v_in_idUsertest AND atld.id_level = v_id_level;
    END LOOP get_testlevel;
    -- close the cursor
    CLOSE testlevel_Cursor;

    -- Update subject percentiles for all usertests in test
    OPEN testtopic_Cursor;   
    -- Fetch in a loop
    get_testtopic: LOOP
        SET v_finished = 0;
        FETCH testtopic_Cursor INTO v_id_topic, v_percentile;
        IF v_finished = 1 THEN
            LEAVE get_testtopic;
        END IF;
        -- Update anal_testtopic_data with percentile
        UPDATE anal_testtopic_data attd
        SET attd.percentile = v_percentile
        WHERE attd.id_usertest = v_in_idUsertest AND attd.id_topic = v_id_topic;
    END LOOP get_testtopic;
    -- close the cursor
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure set_all_percentiles_for_abipusertest
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`set_all_percentiles_for_abipusertest`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`set_all_percentiles_for_abipusertest` (IN v_in_idUsertest BIGINT)
BEGIN
    DECLARE v_finished INTEGER DEFAULT 0;

    DECLARE v_percentile INT DEFAULT 0;
    DECLARE v_id_usertest BIGINT DEFAULT 0;
    DECLARE v_subject VARCHAR(45) DEFAULT null;
    DECLARE v_id_level BIGINT DEFAULT 0;
    DECLARE v_id_topic BIGINT DEFAULT 0;
    DECLARE v_id_testinstance BIGINT DEFAULT 0;
    DECLARE v_id_testsection BIGINT DEFAULT 0;

    -- Declare cursor to get the testinstance_sections in a loop - for usertest
    DECLARE abiptestinstance_section_Cursor CURSOR FOR 
        SELECT MAX(atsp.id_percentile) AS v_max_percentage, ti.id_testinstance AS id_testinstance, ts.id_testsection AS id_testsection
        FROM abiptestinstance ti LEFT JOIN testsegment tg ON tg.id_test = ti.id_test LEFT JOIN testsection ts ON tg.id_testsegment = ts.id_testsegment
                                LEFT JOIN anal_testsection_data atsd ON atsd.id_testsection = ts.id_testsection AND atsd.id_usertest = ti.id_usertest
                                LEFT JOIN anal_testsection_percentiles atsp ON atsp.id_testsection = ts.id_testsection
        WHERE ti.id_usertest = v_in_idUsertest AND atsp.percentage <= atsd.percentage
        GROUP BY ti.id_test, ti.id_testinstance, ts.id_testsection 
        ORDER BY ti.id_test, ti.id_testinstance, ts.id_testsection;

    -- Declare cursor to get the subjects in a loop
    DECLARE testsubject_Cursor CURSOR FOR 
        SELECT atsd.subject, MAX(atsp.id_percentile)
        FROM anal_testsubject_data atsd LEFT JOIN anal_testsubject_percentiles atsp ON atsp.subject = atsd.subject
        WHERE atsd.id_usertest = v_in_idUsertest AND atsp.percentage <= atsd.percentage
        GROUP BY atsd.id_usertest , atsd.subject;

    -- Declare cursor to get the levels in a loop
    DECLARE testlevel_Cursor CURSOR FOR 
        SELECT atld.id_level, MAX(atlp.id_percentile)
        FROM anal_testlevel_data atld LEFT JOIN anal_testlevel_percentiles atlp ON atlp.id_level = atld.id_level
        WHERE atld.id_usertest = v_in_idUsertest AND atlp.percentage <= atld.percentage
        GROUP BY atld.id_usertest , atld.id_level;

    -- Declare cursor to get the topics in a loop
    DECLARE testtopic_Cursor CURSOR FOR 
        SELECT attd.id_topic, MAX(attp.id_percentile)
        FROM anal_testtopic_data attd LEFT JOIN anal_testtopic_percentiles attp ON attp.id_topic = attd.id_topic
        WHERE attd.id_usertest = v_in_idUsertest AND attp.percentage <= attd.percentage
        GROUP BY attd.id_usertest, attd.id_topic;

    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET v_finished = 1;

     -- Update testinstance for ABIP-usertest
    SELECT MAX(atp.id_percentile) INTO v_percentile
    FROM abiptestinstance ati LEFT JOIN anal_test_percentiles atp ON ati.id_test = atp.id_test 
                                    LEFT JOIN anal_test_data atd ON atd.id_usertest = ati.id_usertest 
    WHERE ati.id_usertest = 2603 AND atp.percentage <= atd.percentage ;
    UPDATE abiptestinstance ati SET ati.percentile = v_percentile WHERE ati.id_usertest = v_in_idUsertest;


   -- Update testinstance_sections
    OPEN abiptestinstance_section_Cursor;   
    -- Fetch in a loop
    get_abiptestinstance_section: LOOP
        SET v_finished = 0;
        FETCH abiptestinstance_section_Cursor INTO v_percentile, v_id_testinstance, v_id_testsection;
        IF v_finished = 1 THEN
            LEAVE get_abiptestinstance_section;
        END IF;
        -- Update testinstance with percentile
        UPDATE testinstance_section atis LEFT JOIN testsection ts ON atis.id_section = ts.id_section_ref
        SET atis.percentile = v_percentile
        WHERE atis.id_testinstance = v_id_testinstance AND ts.id_testsection = v_id_testsection;
    END LOOP get_abiptestinstance_section;
    -- close the cursor
    CLOSE abiptestinstance_section_Cursor;

    -- Update subject percentiles for usertest
    OPEN testsubject_Cursor;   
    -- Fetch in a loop
    get_testsubject: LOOP
        SET v_finished = 0;
        FETCH testsubject_Cursor INTO v_subject, v_percentile;
        IF v_finished = 1 THEN
            LEAVE get_testsubject;
        END IF;
        -- Update testinstance with percentile
        UPDATE anal_testsubject_data atsd
        SET atsd.percentile = v_percentile
        WHERE atsd.id_usertest = v_in_idUsertest AND atsd.subject = v_subject;
    END LOOP get_testsubject;
    -- close the cursor
    CLOSE testsubject_Cursor;

    -- Update level percentiles for usertest
    OPEN testlevel_Cursor;   
    -- Fetch in a loop
    get_testlevel: LOOP
        SET v_finished = 0;
        FETCH testlevel_Cursor INTO v_id_level, v_percentile;
        IF v_finished = 1 THEN
            LEAVE get_testlevel;
        END IF;
        -- Update testinstance with percentile
        UPDATE anal_testlevel_data atld
        SET atld.percentile = v_percentile
        WHERE atld.id_usertest = v_in_idUsertest AND atld.id_level = v_id_level;
    END LOOP get_testlevel;
    -- close the cursor
    CLOSE testlevel_Cursor;

    -- Update subject percentiles for all usertests in test
    OPEN testtopic_Cursor;   
    -- Fetch in a loop
    get_testtopic: LOOP
        SET v_finished = 0;
        FETCH testtopic_Cursor INTO v_id_topic, v_percentile;
        IF v_finished = 1 THEN
            LEAVE get_testtopic;
        END IF;
        -- Update anal_testtopic_data with percentile
        UPDATE anal_testtopic_data attd
        SET attd.percentile = v_percentile
        WHERE attd.id_usertest = v_in_idUsertest AND attd.id_topic = v_id_topic;
    END LOOP get_testtopic;
    -- close the cursor
    CLOSE testtopic_Cursor;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure set_testsubjects_percentiles_for_test
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`set_testsubjects_percentiles_for_test`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`set_testsubjects_percentiles_for_test` (IN v_in_idTest BIGINT)
BEGIN
    DECLARE v_finished INTEGER DEFAULT 0;

    DECLARE v_percentile INT DEFAULT 0;
    DECLARE v_id_usertest BIGINT DEFAULT 0;
    DECLARE v_subject VARCHAR(45) DEFAULT null;

    -- Declare cursor to get the usertest-subjects in a loop
    DECLARE testsubject_Cursor CURSOR FOR 
        SELECT atsd.id_usertest, atsd.subject, MAX(atsp.id_percentile)
        FROM anal_testsubject_data atsd LEFT JOIN anal_testsubject_percentiles atsp ON atsp.subject = atsd.subject
                                        LEFT JOIN usertest ut ON ut.id_usertest = atsd.id_usertest
        WHERE ut.id_test = v_in_idTest AND atsp.percentage <= atsd.percentage
        GROUP BY atsd.id_usertest , atsd.subject;

    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET v_finished = 1;

    -- Update subject percentiles for all usertests in test
    OPEN testsubject_Cursor;   
    -- Fetch in a loop
    get_testsubject: LOOP
        SET v_finished = 0;
        FETCH testsubject_Cursor INTO v_id_usertest, v_subject, v_percentile;
        IF v_finished = 1 THEN
            LEAVE get_testsubject;
        END IF;
        -- Update testinstance with percentile
        UPDATE anal_testsubject_data atsd
        SET atsd.percentile = v_percentile
        WHERE atsd.id_usertest = v_id_usertest AND atsd.subject = v_subject;
    END LOOP get_testsubject;
    -- close the cursor
    CLOSE testsubject_Cursor;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure set_testlevels_percentiles_for_test
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`set_testlevels_percentiles_for_test`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`set_testlevels_percentiles_for_test` (IN v_in_idTest BIGINT)
BEGIN
    DECLARE v_finished INTEGER DEFAULT 0;

    DECLARE v_percentile INT DEFAULT 0;
    DECLARE v_id_usertest BIGINT DEFAULT 0;
    DECLARE v_id_level BIGINT DEFAULT 0;

    -- Declare cursor to get the usertest-subjects in a loop
    DECLARE testlevel_Cursor CURSOR FOR 
        SELECT atld.id_usertest, atld.id_level, MAX(atlp.id_percentile)
        FROM anal_testlevel_data atld LEFT JOIN anal_testlevel_percentiles atlp ON atlp.id_level = atld.id_level
                                        LEFT JOIN usertest ut ON ut.id_usertest = atld.id_usertest
        WHERE ut.id_test = v_in_idTest AND atlp.percentage <= atld.percentage
        GROUP BY atld.id_usertest , atld.id_level;

    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET v_finished = 1;

    -- Update subject percentiles for all usertests in test
    OPEN testlevel_Cursor;   
    -- Fetch in a loop
    get_testlevel: LOOP
        SET v_finished = 0;
        FETCH testlevel_Cursor INTO v_id_usertest, v_id_level, v_percentile;
        IF v_finished = 1 THEN
            LEAVE get_testlevel;
        END IF;
        -- Update testinstance with percentile
        UPDATE anal_testlevel_data atld
        SET atld.percentile = v_percentile
        WHERE atld.id_usertest = v_id_usertest AND atld.id_level = v_id_level;
    END LOOP get_testlevel;
    -- close the cursor
    CLOSE testlevel_Cursor;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure set_testtopics_percentiles_for_test
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`set_testtopics_percentiles_for_test`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`set_testtopics_percentiles_for_test` (IN v_in_idTest BIGINT)
BEGIN
    DECLARE v_finished INTEGER DEFAULT 0;

    DECLARE v_percentile INT DEFAULT 0;
    DECLARE v_id_usertest BIGINT DEFAULT 0;
    DECLARE v_id_topic BIGINT DEFAULT 0;

    -- Declare cursor to get the usertest-subjects in a loop
    DECLARE testtopic_Cursor CURSOR FOR 
        SELECT attd.id_usertest, attd.id_topic, MAX(attp.id_percentile)
        FROM anal_testtopic_data attd LEFT JOIN anal_testtopic_percentiles attp ON attp.id_topic = attd.id_topic
                                        LEFT JOIN usertest ut ON ut.id_usertest = attd.id_usertest
        WHERE ut.id_test = v_in_idTest AND attp.percentage <= attd.percentage
        GROUP BY attd.id_usertest , attd.id_topic;

    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET v_finished = 1;

    -- Update subject percentiles for all usertests in test
    OPEN testtopic_Cursor;   
    -- Fetch in a loop
    get_testtopic: LOOP
        SET v_finished = 0;
        FETCH testtopic_Cursor INTO v_id_usertest, v_id_topic, v_percentile;
        IF v_finished = 1 THEN
            LEAVE get_testtopic;
        END IF;
        -- Update anal_testtopic_data with percentile
        UPDATE anal_testtopic_data attd
        SET attd.percentile = v_percentile
        WHERE attd.id_usertest = v_id_usertest AND attd.id_topic = v_id_topic;
    END LOOP get_testtopic;
    -- close the cursor
    CLOSE testtopic_Cursor;
END$$

DELIMITER ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
