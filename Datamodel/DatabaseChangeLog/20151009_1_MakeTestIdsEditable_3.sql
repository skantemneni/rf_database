CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;
USE `rulefree` ;

-- -----------------------------------------------------
-- procedure change_test_id
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`change_test_id`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`change_test_id` (IN v_idTestOld BIGINT, IN v_idTestNew BIGINT, OUT status_code INT, OUT status_message VARCHAR(256))
main_procedure: BEGIN

    DECLARE v_old_test_count INT DEFAULT 0;
    DECLARE v_idTestsegmentOld BIGINT DEFAULT 0;
    DECLARE v_idTestsegmentNew BIGINT DEFAULT 0;
    DECLARE v_idTestsectionOld BIGINT DEFAULT 0;
    DECLARE v_idTestsectionNew BIGINT DEFAULT 0;
    DECLARE tg_loop_cntr INT DEFAULT 0;
    DECLARE ts_loop_cntr INT DEFAULT 0;

    DECLARE v_segment_finished INT DEFAULT FALSE;

    -- declare the testsegment cursor
    DECLARE cursor_testsegment CURSOR FOR 
        SELECT tg.id_testsegment AS id_testsegment
        FROM testsegment tg 
        WHERE tg.id_test = v_idTestOld
        ORDER BY 1;
    
    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET v_segment_finished = TRUE;

    DECLARE exit handler for sqlexception
        BEGIN
            SET status_code = -1;
            SET status_message = "Fail - SQL Error";
            ROLLBACK;
        END;

    DECLARE exit handler for sqlwarning
        BEGIN
            SET status_code = -1;
            SET status_message = "Fail - SQL Warning";
            ROLLBACK;
        END;

    -- truncate the debug table before getting started with the load
    TRUNCATE TABLE logtable;

    SET @enabled = TRUE;
    call write_debug_msg(@enabled, CONCAT('Starting execution on change_test_id. ', v_idTestOld, ' to ', v_idTestNew));

    -- See if a test exists with the old testid
    SELECT COUNT(*) INTO v_old_test_count 
    FROM test t 
    WHERE id_test = v_idTestOld;
    
    IF (v_old_test_count = 0) THEN 
        SET status_code = -1;
        SET status_message = CONCAT('Test Missing: ', v_idTestOld);
        call write_debug_msg(@enabled, status_message);
        LEAVE main_procedure;
    ELSE 
        call write_debug_msg(@enabled, CONCAT('Test Found.  Will Change it... ', v_idTestOld));
    END if;


    START TRANSACTION;

    -- open the cursor
    OPEN cursor_testsegment;   

    -- initialize loop variables
    SET tg_loop_cntr = 0;
      
    -- Fetch in a loop
    get_testsegment: LOOP

        SET tg_loop_cntr = tg_loop_cntr + 1;

        FETCH cursor_testsegment INTO v_idTestsegmentOld;
        IF v_segment_finished THEN
            LEAVE get_testsegment;
        END IF;

        -- create the new id_testsegment
        SET v_idTestsegmentNew = v_idTestNew * 100 + tg_loop_cntr;
        call write_debug_msg(@enabled, CONCAT('Change Old v_idTestsegmentOld. ', v_idTestsegmentOld, ' to New v_idTestsegmentNew ', v_idTestsegmentNew));
        

        BLOCK2: BEGIN
            DECLARE v_section_finished INT DEFAULT FALSE;
            -- declare the testsection cursor
            DECLARE cursor_testsection CURSOR FOR 
                SELECT ts.id_testsection AS id_testsection
                FROM testsection ts 
                WHERE ts.id_testsegment = v_idTestsegmentOld
                ORDER BY 1;
        
            -- declare NOT FOUND handler
            DECLARE CONTINUE HANDLER
                FOR NOT FOUND SET v_section_finished = TRUE;

            -- open the cursor
            OPEN cursor_testsection;   

            -- initialize loop variables
            SET ts_loop_cntr = 0;

            -- Fetch in a loop
            get_testsection: LOOP

                SET ts_loop_cntr = ts_loop_cntr + 1;

                FETCH cursor_testsection INTO v_idTestsectionOld;
                IF v_section_finished THEN
                    LEAVE get_testsection;
                END IF;

                SET v_idTestsectionNew = v_idTestsegmentNew * 100 + ts_loop_cntr;
                call write_debug_msg(@enabled, CONCAT('Change Old v_idTestsectionOld. ', v_idTestsectionOld, ' to New v_idTestsectionNew ', v_idTestsectionNew));

                -- Update idTestsection statement.  
                UPDATE testsection SET id_testsection = v_idTestsectionNew
                WHERE id_testsection = v_idTestsectionOld;

                call write_debug_msg(@enabled, CONCAT('Update Section Successful. to New v_idTestsectionNew ', v_idTestsectionNew));

            END LOOP get_testsection;
        END BLOCK2;
            
        -- now update the testsegment
        -- Update idTestsegment statement.  
        UPDATE testsegment SET id_testsegment = v_idTestsegmentNew
        WHERE id_testsegment = v_idTestsegmentOld;

        call write_debug_msg(@enabled, CONCAT('Update Segment Successful. to New v_idTestsegmentNew ', v_idTestsegmentNew));

    END LOOP get_testsegment;
            
    -- Update idTest statement.  This should also set the new Id on the testsegment due to FK being cascade on update
    UPDATE test SET id_test = v_idTestNew
    WHERE id_test = v_idTestOld;

    call write_debug_msg(@enabled, CONCAT('Update Test Successful. to New v_idTestNew ', v_idTestNew));

    COMMIT;

    SET status_code = 0;
    SET status_message = "Success!";

END main_procedure;

$$

DELIMITER ;

