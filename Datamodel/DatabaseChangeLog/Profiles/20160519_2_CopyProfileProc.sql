SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;
USE `rulefree` ;

-- -----------------------------------------------------
-- procedure copy_profile
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`copy_profile`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`copy_profile` (IN v_idProfileOld BIGINT, IN v_idProfileNew BIGINT, OUT status_code INT, OUT status_message VARCHAR(256))
main_procedure: BEGIN
    DECLARE v_old_profile_count INT DEFAULT 0;
    DECLARE v_new_profile_count INT DEFAULT 0;
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
    call write_debug_msg(@enabled, CONCAT('Starting execution on copy_profile. ', v_idProfileOld, ' to ', v_idProfileNew));

    -- See if the profile exists with the old profileid
    SELECT COUNT(*) INTO v_old_profile_count 
    FROM profile p 
    WHERE id_profile = v_idProfileOld;
    
    IF (v_old_profile_count = 0) THEN 
        SET status_code = -1;
        SET status_message = CONCAT('Profile Missing: ', v_idProfileOld);
        call write_debug_msg(@enabled, status_message);
        LEAVE main_procedure;
    ELSE 
        call write_debug_msg(@enabled, CONCAT('Profile ', v_idProfileOld, ' Found.  Will Copy it to... ', v_idProfileNew));
    END if;


    -- See if the COPY profile ID already exists 
    SELECT COUNT(*) INTO v_new_profile_count 
    FROM profile p 
    WHERE id_profile = v_idProfileNew;
    
    IF (v_new_profile_count > 0) THEN 
        SET status_code = -1;
        SET status_message = CONCAT('Profile already exists with ID: ', v_idProfileNew, '.  Please use a different NEW Profile ID.');
        call write_debug_msg(@enabled, status_message);
        LEAVE main_procedure;
    ELSE 
        call write_debug_msg(@enabled, CONCAT('Profile ', v_idProfileOld, ' Found.  Will Copy it to... ', v_idProfileNew));
    END if;


    START TRANSACTION;

    -- Copy idProfile statement. 
    call write_debug_msg(@enabled, CONCAT('Attempting to Copy Profile: Old v_idProfileOld. ', v_idProfileOld, ' to New v_idProfileNew ', v_idProfileNew));

    INSERT INTO `profile`
        (`id_profile`,
        `id_provider`,
        `id_organization`,
        `name`,
        `description`,
        `access_level`,
        `published`,
        `profile_type`)
    SELECT 
        v_idProfileNew, 
        `id_provider`,
        `id_organization`,
        CONCAT(`name`, '_copy'),
        `description`,
        `access_level`,
        `published`,
        `profile_type`
    FROM `profile`
    WHERE `id_profile` = v_idProfileOld;
    
    call write_debug_msg(@enabled, CONCAT('Copy Profile Successful.  Old v_idProfileOld. ', v_idProfileOld, ' Changed to New v_idProfileNew ', v_idProfileNew));

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
        
        -- now insert the new profilesegment
        -- Insert Profilesegment statement.  
        call write_debug_msg(@enabled, CONCAT('Attempting to Copy Profilesegment: Old v_idProfilesegmentOld. ', v_idProfilesegmentOld, ' to New v_idProfilesegmentNew ', v_idProfilesegmentNew));

        INSERT INTO `profilesegment`
            (`id_profilesegment`,
            `id_profile`,
            `name`,
            `description`,
            `seq`,
            `profiletest_wrapper`)
        SELECT 
            v_idProfilesegmentNew,
            v_idProfileNew,
            `name`,
            `description`,
            `seq`,
            `profiletest_wrapper`
        FROM `profilesegment`
        WHERE `id_profilesegment` = v_idProfilesegmentOld;

        call write_debug_msg(@enabled, CONCAT('Copy Profilesegment Successful.  Old v_idProfilesegmentOld. ', v_idProfilesegmentOld, ' Changed to New v_idProfilesegmentNew ', v_idProfilesegmentNew));

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
                call write_debug_msg(@enabled, CONCAT('Attempting to Copy Profiletest: Old v_idProfiletestOld. ', v_idProfiletestOld, ' to New v_idProfiletestNew ', v_idProfiletestNew));

                -- Insert Profiletest statement.  
                INSERT INTO `profiletest`
                    (`id_profiletest`,
                    `id_profile`,
                    `id_profilesegment`,
                    `id_test_ref`,
                    `name`,
                    `description`,
                    `seq`,
                    `test_provision_day`,
                    `test_removal_day`,
                    `test_provision_date`,
                    `test_removal_date`,
                    `initial_active`)
                SELECT 
                    v_idProfiletestNew,
                    v_idProfileNew,
                    v_idProfilesegmentNew,
                    `id_test_ref`,
                    `name`,
                    `description`,
                    `seq`,
                    `test_provision_day`,
                    `test_removal_day`,
                    `test_provision_date`,
                    `test_removal_date`,
                    `initial_active`
                FROM `profiletest`
                WHERE `id_profiletest` = v_idProfiletestOld;                
                
                call write_debug_msg(@enabled, CONCAT('Copy Profiletest Successful.  Old v_idProfiletestOld. ', v_idProfiletestOld, ' Changed to New v_idProfiletestNew ', v_idProfiletestNew));

            END LOOP get_profiletest;
        END BLOCK2;
            
    END LOOP get_profilesegment;
            
    COMMIT;

    SET status_code = 0;
    SET status_message = "Success!";

END main_procedure;$$

DELIMITER ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
