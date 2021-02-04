SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;
USE `rulefree` ;

-- -----------------------------------------------------
-- procedure update_anal_percentiles_for_test
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`update_anal_percentiles_for_test`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`update_anal_percentiles_for_test` (IN v_in_idTest BIGINT, IN v_sample_max_set_size INTEGER)
BEGIN

    -- Declare Question and Point count variables at a Test Level
    DECLARE v_finished INTEGER DEFAULT 0;

    DECLARE v_sample_set_size INTEGER DEFAULT 500;

    -- declare the loop percentile variables
    DECLARE v_id_test BIGINT DEFAULT 0;
    DECLARE v_id_percentile INT DEFAULT 0;
    DECLARE v_percentage DECIMAL(5,2) DEFAULT 0.0;

    -- Declare curson to get the testinstance_sections in a loop
    DECLARE test_percentile_Cursor CURSOR FOR 
        SELECT id_test, (v_sample_set_size-rank+1)*100/v_sample_set_size AS percentile, percentage
        FROM (
                SELECT ad1.id_test, ad1.id_usertest, ad1.percentage,
                        @prev := @curr AS previous_percentage,
                        (@curr := ad1.percentage) AS current_percentage,
                        @rank := IF(@prev = @curr, @rank+1, @rank+1) AS rank
                FROM 
                    (SELECT * FROM anal_test_data WHERE id_test = v_in_idTest LIMIT 0, v_sample_set_size) ad1, 
                    (SELECT @curr := null, @prev := null, @rank := 0) somename_1
        ORDER BY ad1.percentage DESC, ad1.id_usertest) sel2;

    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET v_finished = 1;

    -- First delete any anal_test_percentiles date for this test
    DELETE FROM anal_test_percentiles WHERE id_test = v_in_idTest;

    -- Set the Sample Set size - either the size of table or v_sample_max_set_size (300) - whichever is larger
    SELECT IF(COUNT(*) < v_sample_max_set_size, COUNT(*), v_sample_max_set_size) INTO v_sample_set_size
        FROM anal_test_data WHERE id_test = v_in_idTest;

    -- now update anal_test_percentiles for this test in a cursor loop
    SET v_finished = 0;

    -- open the cursor
    OPEN test_percentile_Cursor;   

    -- Fetch in a loop
    get_test_percentile: LOOP

        FETCH test_percentile_Cursor INTO v_id_test, v_id_percentile, v_percentage;

        IF v_finished = 1 THEN
            LEAVE get_test_percentile;
        END IF;

        INSERT INTO anal_test_percentiles (id_test, id_percentile, percentage) 
        VALUES (v_id_test, v_id_percentile, v_percentage) 
        ON DUPLICATE KEY 
        UPDATE percentage = v_percentage;

    END LOOP get_test_percentile;
    
    -- close the cursor
    CLOSE test_percentile_Cursor;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure update_anal_percentiles_for_testsubject
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`update_anal_percentiles_for_testsubject`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`update_anal_percentiles_for_testsubject` (IN v_in_idTest BIGINT, IN v_sample_max_set_size INTEGER)
BEGIN

    -- Declare Question and Point count variables at a Test Level
    DECLARE v_finished INTEGER DEFAULT 0;

    DECLARE v_sample_set_size INTEGER DEFAULT 500;

    -- declare the loop percentile variables
    DECLARE v_subject VARCHAR(45) DEFAULT null;
    DECLARE v_id_test BIGINT DEFAULT 0;
    DECLARE v_id_percentile INT DEFAULT 0;
    DECLARE v_percentage DECIMAL(5,2) DEFAULT 0.0;

    -- Declare cursor to get the testinstance_sections in a loop
    DECLARE uniquesubject_Cursor CURSOR FOR 
        SELECT distinct `subject`
        FROM anal_testsubject_data WHERE id_test = v_in_idTest
        ORDER BY `subject`;

    -- Declare cursor to get the testinstance_sections in a loop
    DECLARE testsubject_percentile_Cursor CURSOR FOR 
        SELECT id_test, (v_sample_set_size-rank+1)*100/v_sample_set_size AS percentile, percentage
        FROM (
                SELECT ad1.id_test, ad1.id_usertest, ad1.percentage,
                        @prev := @curr AS previous_percentage,
                        (@curr := ad1.percentage) AS current_percentage,
                        @rank := IF(@prev = @curr, @rank+1, @rank+1) AS rank
                FROM 
                    (SELECT * FROM anal_testsubject_data WHERE `subject` = v_subject AND id_test = v_in_idTest LIMIT 0, v_sample_set_size) ad1, 
                    (SELECT @curr := null, @prev := null, @rank := 0) somename_1
        ORDER BY ad1.percentage DESC, ad1.id_usertest) sel2;


    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET v_finished = 1;

    -- First delete any anal_testsubject_percentiles data for this test
    DELETE FROM anal_testsubject_percentiles WHERE id_test = v_in_idTest;





    -- open the cursor
    OPEN uniquesubject_Cursor;   

    -- Fetch in a loop
    get_uniquesubject_loop: LOOP

        -- now update anal_test_percentiles for this test in a cursor loop
        SET v_finished = 0;

        FETCH uniquesubject_Cursor INTO v_subject;

        IF v_finished = 1 THEN
            LEAVE get_uniquesubject_loop;
        END IF;




        -- Set the Sample Set size - either the size of table or v_sample_max_set_size (300) - whichever is larger
        SELECT IF(COUNT(*) < v_sample_max_set_size, COUNT(*), v_sample_max_set_size) INTO v_sample_set_size
            FROM anal_testsubject_data WHERE id_test = v_in_idTest AND `subject` = v_subject;

        -- open the cursor
        OPEN testsubject_percentile_Cursor;   

        -- Fetch in a loop
        get_testsubject_percentile_loop: LOOP

            -- now update anal_test_percentiles for this test in a cursor loop
            SET v_finished = 0;

            FETCH testsubject_percentile_Cursor INTO v_id_test, v_id_percentile, v_percentage;

            IF v_finished = 1 THEN
                LEAVE get_testsubject_percentile_loop;
            END IF;

            INSERT INTO anal_testsubject_percentiles (`subject`, id_test, id_percentile, percentage) 
            VALUES (v_subject, v_id_test, v_id_percentile, v_percentage) 
            ON DUPLICATE KEY 
            UPDATE percentage = v_percentage;

        END LOOP get_testsubject_percentile_loop;
    
        -- close the cursor
        CLOSE testsubject_percentile_Cursor;

    



    END LOOP get_uniquesubject_loop;

    -- close the cursor
    CLOSE uniquesubject_Cursor;




END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure update_anal_percentiles_for_testlevel
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`update_anal_percentiles_for_testlevel`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`update_anal_percentiles_for_testlevel` (IN v_in_idTest BIGINT, IN v_sample_max_set_size INTEGER)
BEGIN

    -- Declare Question and Point count variables at a Test Level
    DECLARE v_finished INTEGER DEFAULT 0;

    DECLARE v_sample_set_size INTEGER DEFAULT 500;

    -- declare the loop percentile variables
    DECLARE v_id_level VARCHAR(45) DEFAULT null;
    DECLARE v_id_test BIGINT DEFAULT 0;
    DECLARE v_id_percentile INT DEFAULT 0;
    DECLARE v_percentage DECIMAL(5,2) DEFAULT 0.0;

    -- Declare cursor to get the testinstance_sections in a loop
    DECLARE uniquelevel_Cursor CURSOR FOR 
        SELECT distinct id_level
        FROM anal_testlevel_data WHERE id_test = v_in_idTest
        ORDER BY id_level;

    -- Declare cursor to get the testinstance_sections in a loop
    DECLARE testlevel_percentile_Cursor CURSOR FOR 
        SELECT id_test, (v_sample_set_size-rank+1)*100/v_sample_set_size AS percentile, percentage
        FROM (
                SELECT ad1.id_test, ad1.id_usertest, ad1.percentage,
                        @prev := @curr AS previous_percentage,
                        (@curr := ad1.percentage) AS current_percentage,
                        @rank := IF(@prev = @curr, @rank+1, @rank+1) AS rank
                FROM 
                    (SELECT * FROM anal_testlevel_data WHERE id_level = v_id_level AND id_test = v_in_idTest LIMIT 0, v_sample_set_size) ad1, 
                    (SELECT @curr := null, @prev := null, @rank := 0) somename_1
        ORDER BY ad1.percentage DESC, ad1.id_usertest) sel2;


    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET v_finished = 1;

    -- First delete any anal_testlevel_percentiles data for this test
    DELETE FROM anal_testlevel_percentiles WHERE id_test = v_in_idTest;





    -- open the cursor
    OPEN uniquelevel_Cursor;   

    -- Fetch in a loop
    get_uniquelevel_loop: LOOP

        -- now update anal_test_percentiles for this test in a cursor loop
        SET v_finished = 0;

        FETCH uniquelevel_Cursor INTO v_id_level;

        IF v_finished = 1 THEN
            LEAVE get_uniquelevel_loop;
        END IF;




        -- Set the Sample Set size - either the size of table or v_sample_max_set_size (300) - whichever is larger
        SELECT IF(COUNT(*) < v_sample_max_set_size, COUNT(*), v_sample_max_set_size) INTO v_sample_set_size
            FROM anal_testlevel_data WHERE id_test = v_in_idTest AND id_level = v_id_level;

        -- open the cursor
        OPEN testlevel_percentile_Cursor;   

        -- Fetch in a loop
        get_testlevel_percentile_loop: LOOP

            -- now update anal_test_percentiles for this test in a cursor loop
            SET v_finished = 0;

            FETCH testlevel_percentile_Cursor INTO v_id_test, v_id_percentile, v_percentage;

            IF v_finished = 1 THEN
                LEAVE get_testlevel_percentile_loop;
            END IF;

            INSERT INTO anal_testlevel_percentiles (id_level, id_test, id_percentile, percentage) 
            VALUES (v_id_level, v_id_test, v_id_percentile, v_percentage) 
            ON DUPLICATE KEY 
            UPDATE percentage = v_percentage;

        END LOOP get_testlevel_percentile_loop;
    
        -- close the cursor
        CLOSE testlevel_percentile_Cursor;

    



    END LOOP get_uniquelevel_loop;

    -- close the cursor
    CLOSE uniquelevel_Cursor;



END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure update_anal_percentiles_for_testtopic
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`update_anal_percentiles_for_testtopic`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`update_anal_percentiles_for_testtopic` (IN v_in_idTest BIGINT, IN v_sample_max_set_size INTEGER)
BEGIN

    -- Declare Question and Point count variables at a Test Topic
    DECLARE v_finished INTEGER DEFAULT 0;

    DECLARE v_sample_set_size INTEGER DEFAULT 500;

    -- declare the loop percentile variables
    DECLARE v_id_topic VARCHAR(45) DEFAULT null;
    DECLARE v_id_test BIGINT DEFAULT 0;
    DECLARE v_id_percentile INT DEFAULT 0;
    DECLARE v_percentage DECIMAL(5,2) DEFAULT 0.0;

    -- Declare cursor to get the testinstance_sections in a loop
    DECLARE uniquetopic_Cursor CURSOR FOR 
        SELECT distinct id_topic
        FROM anal_testtopic_data WHERE id_test = v_in_idTest
        ORDER BY id_topic;

    -- Declare cursor to get the testinstance_sections in a loop
    DECLARE testtopic_percentile_Cursor CURSOR FOR 
        SELECT id_test, (v_sample_set_size-rank+1)*100/v_sample_set_size AS percentile, percentage
        FROM (
                SELECT ad1.id_test, ad1.id_usertest, ad1.percentage,
                        @prev := @curr AS previous_percentage,
                        (@curr := ad1.percentage) AS current_percentage,
                        @rank := IF(@prev = @curr, @rank+1, @rank+1) AS rank
                FROM 
                    (SELECT * FROM anal_testtopic_data WHERE id_topic = v_id_topic AND id_test = v_in_idTest LIMIT 0, v_sample_set_size) ad1, 
                    (SELECT @curr := null, @prev := null, @rank := 0) somename_1
        ORDER BY ad1.percentage DESC, ad1.id_usertest) sel2;


    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET v_finished = 1;

    -- First delete any anal_testtopic_percentiles data for this test
    DELETE FROM anal_testtopic_percentiles WHERE id_test = v_in_idTest;





    -- open the cursor
    OPEN uniquetopic_Cursor;   

    -- Fetch in a loop
    get_uniquetopic_loop: LOOP

        -- now update anal_test_percentiles for this test in a cursor loop
        SET v_finished = 0;

        FETCH uniquetopic_Cursor INTO v_id_topic;

        IF v_finished = 1 THEN
            LEAVE get_uniquetopic_loop;
        END IF;




        -- Set the Sample Set size - either the size of table or v_sample_max_set_size (300) - whichever is larger
        SELECT IF(COUNT(*) < v_sample_max_set_size, COUNT(*), v_sample_max_set_size) INTO v_sample_set_size
            FROM anal_testtopic_data WHERE id_test = v_in_idTest AND id_topic = v_id_topic;

        -- open the cursor
        OPEN testtopic_percentile_Cursor;   

        -- Fetch in a loop
        get_testtopic_percentile_loop: LOOP

            -- now update anal_test_percentiles for this test in a cursor loop
            SET v_finished = 0;

            FETCH testtopic_percentile_Cursor INTO v_id_test, v_id_percentile, v_percentage;

            IF v_finished = 1 THEN
                LEAVE get_testtopic_percentile_loop;
            END IF;

            INSERT INTO anal_testtopic_percentiles (id_topic, id_test, id_percentile, percentage) 
            VALUES (v_id_topic, v_id_test, v_id_percentile, v_percentage) 
            ON DUPLICATE KEY 
            UPDATE percentage = v_percentage;

        END LOOP get_testtopic_percentile_loop;
    
        -- close the cursor
        CLOSE testtopic_percentile_Cursor;

    



    END LOOP get_uniquetopic_loop;

    -- close the cursor
    CLOSE uniquetopic_Cursor;


END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure update_anal_percentiles_for_testsection
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`update_anal_percentiles_for_testsection`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`update_anal_percentiles_for_testsection` (IN v_in_idTest BIGINT, IN v_sample_max_set_size INTEGER)
BEGIN
    DECLARE v_finished INTEGER DEFAULT 0;

    DECLARE v_sample_set_size INTEGER DEFAULT 500;

    -- declare the loop percentile variables
    DECLARE v_id_testsection BIGINT DEFAULT null;
    DECLARE v_id_testsegment BIGINT DEFAULT null;
    DECLARE v_id_test BIGINT DEFAULT 0;
    DECLARE v_id_percentile INT DEFAULT 0;
    DECLARE v_percentage DECIMAL(5,2) DEFAULT 0.0;

    DECLARE uniquetestsection_Cursor CURSOR FOR 
        SELECT distinct atd.id_testsection AS id_testsection
        FROM anal_testsection_data atd LEFT JOIN testsection ts ON atd.id_testsection = ts.id_testsection
                                        LEFT JOIN testsegment tg ON ts.id_testsegment = tg.id_testsegment 
                                        LEFT JOIN test t ON tg.id_test = t.id_test
        WHERE t.id_test = v_in_idTest
        ORDER BY atd.id_testsection;

    -- Declare cursor to get the testsection_percentile_Cursor
    DECLARE testsection_percentile_Cursor CURSOR FOR 
        SELECT id_test, id_testsegment, (v_sample_set_size-rank+1)*100/v_sample_set_size AS percentile, percentage
        FROM (
                SELECT ad1.id_test, ad1.id_usertest, ad1.id_testsegment, ad1.percentage,
                        @prev := @curr AS previous_percentage,
                        (@curr := ad1.percentage) AS current_percentage,
                        @rank := IF(@prev = @curr, @rank+1, @rank+1) AS rank
                FROM 
                    (
                        SELECT atd.*, tg.id_testsegment
                        FROM anal_testsection_data atd LEFT JOIN testsection ts ON atd.id_testsection = ts.id_testsection
                                                       LEFT JOIN testsegment tg ON ts.id_testsegment = tg.id_testsegment 
                                                       LEFT JOIN test t ON tg.id_test = t.id_test
                        WHERE atd.id_testsection = v_id_testsection AND t.id_test = v_in_idTest LIMIT 0, v_sample_set_size
                    ) ad1, 
                    (SELECT @curr := null, @prev := null, @rank := 0) somename_1
        ORDER BY ad1.percentage DESC, ad1.id_usertest) sel2;


    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET v_finished = 1;

    -- First delete any anal_testsection_percentiles data for this test
    DELETE FROM anal_testsection_percentiles WHERE id_test = v_in_idTest;





    -- open the cursor
    OPEN uniquetestsection_Cursor;   

    -- Fetch in a loop
    get_uniquetestsection_loop: LOOP

        -- now update anal_testsection_percentiles for this test in a cursor loop
        SET v_finished = 0;

        FETCH uniquetestsection_Cursor INTO v_id_testsection;

        IF v_finished = 1 THEN
            LEAVE get_uniquetestsection_loop;
        END IF;




        -- Set the Sample Set size - either the size of table or v_sample_max_set_size (300) - whichever is larger
        SELECT IF(COUNT(*) < v_sample_max_set_size, COUNT(*), v_sample_max_set_size) INTO v_sample_set_size
            FROM anal_testsection_data atd LEFT JOIN testsection ts ON atd.id_testsection = ts.id_testsection
                                           LEFT JOIN testsegment tg ON ts.id_testsegment = tg.id_testsegment 
                                           LEFT JOIN test t ON tg.id_test = t.id_test
            WHERE t.id_test = v_in_idTest AND atd.id_testsection = v_id_testsection;

        -- open the cursor
        OPEN testsection_percentile_Cursor;   

        -- Fetch in a loop
        get_testsection_percentile_loop: LOOP

            -- now update anal_testsection_percentiles for this test in a cursor loop
            SET v_finished = 0;

            FETCH testsection_percentile_Cursor INTO v_id_test, v_id_testsegment, v_id_percentile, v_percentage;

            IF v_finished = 1 THEN
                LEAVE get_testsection_percentile_loop;
            END IF;

            INSERT INTO anal_testsection_percentiles (id_testsection, id_testsegment, id_test, id_percentile, percentage) 
            VALUES (v_id_testsection, v_id_testsegment, v_id_test, v_id_percentile, v_percentage) 
            ON DUPLICATE KEY 
            UPDATE percentage = v_percentage;

        END LOOP get_testsection_percentile_loop;
    
        -- close the cursor
        CLOSE testsection_percentile_Cursor;

    



    END LOOP get_uniquetestsection_loop;

    -- close the cursor
    CLOSE uniquetestsection_Cursor;


END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure update_all_anal_percentiles_for_test
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`update_all_anal_percentiles_for_test`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`update_all_anal_percentiles_for_test` (IN v_in_idTest BIGINT, IN v_sample_max_set_size INTEGER)
BEGIN
    CALL update_anal_percentiles_for_test(v_in_idTest, v_sample_max_set_size);
    CALL update_anal_percentiles_for_testsection(v_in_idTest, v_sample_max_set_size);
    CALL update_anal_percentiles_for_testsubject(v_in_idTest, v_sample_max_set_size);
    CALL update_anal_percentiles_for_testlevel(v_in_idTest, v_sample_max_set_size);
    CALL update_anal_percentiles_for_testtopic(v_in_idTest, v_sample_max_set_size);
END$$

DELIMITER ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
