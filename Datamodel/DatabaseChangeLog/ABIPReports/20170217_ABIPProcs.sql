SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;
USE `rulefree` ;

-- -----------------------------------------------------
-- procedure delete_abiptestinstance
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_abiptestinstance`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_abiptestinstance` (IN idUsertest BIGINT)
BEGIN
    DELETE FROM abiptestinstance_detail WHERE id_testinstance IN (SELECT id_testinstance FROM abiptestinstance WHERE id_usertest = idUsertest); 
    DELETE FROM abiptestinstance_section WHERE id_testinstance IN (SELECT id_testinstance FROM abiptestinstance WHERE id_usertest = idUsertest); 
    DELETE FROM abiptestinstance WHERE id_usertest = idUsertest; 
END
$$

DELIMITER ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
