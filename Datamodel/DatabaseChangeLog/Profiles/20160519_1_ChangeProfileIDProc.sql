SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;
USE `rulefree` ;

-- -----------------------------------------------------
-- procedure change_profile_id
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`change_profile_id`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`change_profile_id` (IN v_idProfileOld BIGINT, IN v_idProfileNew BIGINT, OUT status_code INT, OUT status_message VARCHAR(256))
main_procedure: BEGIN

    DECLARE v_old_profile_count INT DEFAULT 0;
    DECLARE v_idProfilesegmentOld BIGINT DEFAULT 0;
    DECLARE v_idProfilesegmentNew BIGINT DEFAULT 0;
    DECLARE v_idProfiletestOld BIGINT DEFAULT 0;
    DECLARE v_idProfiletestNew BIGINT DEFAULT 0;
    DECLARE pg_loop_cntr INT DEFAULT 0;
    DECLARE pt_loop_cntr INT DEFAULT 0;

    DECLARE v_segment_finished INT DEFAULT FALSE;

    -- declare the profilesegment cursor
    DECLARE cursor_profilesegment CURSOR FOR 
        SELECT pg.id_profilesegment AS id_profilesegment
        FROM profilesegment pg 
        WHERE pg.id_profile = v_idProfileOld
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
    call write_debug_msg(@enabled, CONCAT('Starting execution on change_profile_id. ', v_idProfileOld, ' to ', v_idProfileNew));

    -- See if a profile exists with the old profileid
    SELECT COUNT(*) INTO v_old_profile_count 
    FROM profile p 
    WHERE id_profile = v_idProfileOld;
    
    IF (v_old_profile_count = 0) THEN 
        SET status_code = -1;
        SET status_message = CONCAT('Profile Missing: ', v_idProfileOld);
        call write_debug_msg(@enabled, status_message);
        LEAVE main_procedure;
    ELSE 
        call write_debug_msg(@enabled, CONCAT('Profile ', v_idProfileOld, ' Found.  Will Change it... to ', v_idProfileNew));
    END if;


    START TRANSACTION;

    -- open the cursor
    OPEN cursor_profilesegment;   

    -- initialize loop variables
    SET pg_loop_cntr = 0;
      
    -- Fetch in a loop
    get_profilesegment: LOOP

        SET pg_loop_cntr = pg_loop_cntr + 1;

        FETCH cursor_profilesegment INTO v_idProfilesegmentOld;
        IF v_segment_finished THEN
            LEAVE get_profilesegment;
        END IF;

        -- create the new id_profilesegment
        SET v_idProfilesegmentNew = v_idProfileNew * 100 + pg_loop_cntr;
        call write_debug_msg(@enabled, CONCAT('Change Old v_idProfilesegmentOld. ', v_idProfilesegmentOld, ' to New v_idProfilesegmentNew ', v_idProfilesegmentNew));
        

        BLOCK2: BEGIN
            DECLARE v_profiletest_finished INT DEFAULT FALSE;
            -- declare the profiletest cursor
            DECLARE cursor_profiletest CURSOR FOR 
                SELECT pt.id_profiletest AS id_profiletest
                FROM profiletest pt 
                WHERE pt.id_profilesegment = v_idProfilesegmentOld
                ORDER BY 1;
        
            -- declare NOT FOUND handler
            DECLARE CONTINUE HANDLER
                FOR NOT FOUND SET v_profiletest_finished = TRUE;

            -- open the cursor
            OPEN cursor_profiletest;   

            -- initialize loop variables
            SET pt_loop_cntr = 0;

            -- Fetch in a loop
            get_profiletest: LOOP

                SET pt_loop_cntr = pt_loop_cntr + 1;

                FETCH cursor_profiletest INTO v_idProfiletestOld;
                IF v_profiletest_finished THEN
                    LEAVE get_profiletest;
                END IF;

                SET v_idProfiletestNew = v_idProfilesegmentNew * 100 + pt_loop_cntr;
                call write_debug_msg(@enabled, CONCAT('Attempting to Change Profiletest: Old v_idProfiletestOld. ', v_idProfiletestOld, ' to New v_idProfiletestNew ', v_idProfiletestNew));

                -- Update idProfiletest statement.  
                UPDATE profiletest SET id_profiletest = v_idProfiletestNew
                WHERE id_profiletest = v_idProfiletestOld;

                call write_debug_msg(@enabled, CONCAT('Update Profiletest Successful.  Old v_idProfiletestOld. ', v_idProfiletestOld, ' Changed to New v_idProfiletestNew ', v_idProfiletestNew));

            END LOOP get_profiletest;
        END BLOCK2;
            
        -- now update the profilesegment
        -- Update idProfilesegment statement.  
        call write_debug_msg(@enabled, CONCAT('Attempting to Change Profilesegment: Old v_idProfilesegmentOld. ', v_idProfilesegmentOld, ' to New v_idProfilesegmentNew ', v_idProfilesegmentNew));

        UPDATE profilesegment SET id_profilesegment = v_idProfilesegmentNew
        WHERE id_profilesegment = v_idProfilesegmentOld;

        call write_debug_msg(@enabled, CONCAT('Update Profilesegment Successful.  Old v_idProfilesegmentOld. ', v_idProfilesegmentOld, ' Changed to New v_idProfilesegmentNew ', v_idProfilesegmentNew));

    END LOOP get_profilesegment;
            
    -- Update idProfile statement.  This should also set the new Id on the profilesegment due to FK being cascade on update
    call write_debug_msg(@enabled, CONCAT('Attempting to Change Profile: Old v_idProfileOld. ', v_idProfileOld, ' to New v_idProfileNew ', v_idProfileNew));

    UPDATE profile SET id_profile = v_idProfileNew
    WHERE id_profile = v_idProfileOld;

    call write_debug_msg(@enabled, CONCAT('Update Profile Successful.  Old v_idProfileOld. ', v_idProfileOld, ' Changed to New v_idProfileNew ', v_idProfileNew));

    COMMIT;

    SET status_code = 0;
    SET status_message = "Success!";

END main_procedure;

$$

DELIMITER ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
