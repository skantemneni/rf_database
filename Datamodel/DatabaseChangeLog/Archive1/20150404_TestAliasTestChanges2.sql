SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;
USE `rulefree` ;

-- -----------------------------------------------------
-- procedure activate_usertest_for_free
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`activate_usertest_for_free`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`activate_usertest_for_free` (IN v_idTest BIGINT, IN v_idUser BIGINT, OUT v_status TEXT)
BEGIN

	DECLARE v_test_is_free INT DEFAULT 0;
	DECLARE v_test_in_free_period INT DEFAULT 0;

	-- is the test marked free (for turely free tests)
	SELECT IFNULL(t.is_free, 0) INTO v_test_is_free FROM test t WHERE t.id_test = v_idTest; 
	-- is the test currently offered for free (for a promotion)
	SELECT IFNULL((ta.date_free_start <= Now() AND ta.date_free_end >= Now()), 0) INTO v_test_in_free_period
			FROM test t LEFT JOIN testalias ta ON t.id_test = ta.id_test WHERE t.id_test = v_idTest; 

	IF (v_test_is_free = 1 OR v_test_in_free_period = 1) THEN
		BEGIN
			-- insert a record into usertest table
			INSERT INTO `rulefree`.`usertest`(`id_provider`, `id_test`, `id_user`, `test_type`, `user_type`, `name`, `description`, 
												`test_assignment_date`, `test_status`, `active`)
			SELECT 0, v_idtest, v_idUser, t.test_type, 1, t.`name`, t.description, now(), 'assigned', 1
			FROM test t 
			WHERE t.id_test = v_idtest;
		END;
	ELSE
		BEGIN
			SELECT 'Test is not marked free.  Please purchase the test or enter a valid Activation Code.' INTO v_status;
		END;
	END IF;


END$$

DELIMITER ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
