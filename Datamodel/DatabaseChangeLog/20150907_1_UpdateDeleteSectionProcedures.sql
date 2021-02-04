SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;
USE `rulefree` ;

-- -----------------------------------------------------
-- procedure delete_section
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_section`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_section` (IN idSection BIGINT, OUT status_code INT, OUT status_message VARCHAR(256))
BEGIN

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

START TRANSACTION;
    DELETE from derived_section_question where id_section in (idSection);
    DELETE from answer where id_question in (select id_question from question where id_section in (idSection));
    DELETE from question where id_section in (idSection);
    DELETE from wl_passage where id_wordlist in (idSection);
    DELETE from wl_word where id_wordlist in (idSection);
    DELETE from wl_wordlist where id_wordlist in (idSection);
    DELETE from questionset where id_section in (idSection);
    DELETE from section where id_section in (idSection);
    SET status_code = 0;
    SET status_message = "success";
COMMIT;
END 
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_derived_section
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_derived_section`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_derived_section` (IN idDerivedSection BIGINT, OUT status_code INT, OUT status_message VARCHAR(256))
BEGIN

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

START TRANSACTION;
    DELETE from derived_section_question where id_section in (idDerivedSection);
    DELETE from section where id_section in (idDerivedSection) AND section.section_type = 'ds';
    SET status_code = 0;
    SET status_message = "success";
COMMIT;
END
$$

DELIMITER ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
