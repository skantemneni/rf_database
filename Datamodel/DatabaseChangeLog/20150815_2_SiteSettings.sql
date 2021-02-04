SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;

-- -----------------------------------------------------
-- Table `rulefree`.`site_settings`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`site_settings` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`site_settings` (
  `setting_name` VARCHAR(200) NOT NULL ,
  `setting_value` VARCHAR(400) NOT NULL ,
  PRIMARY KEY (`setting_name`) )
ENGINE = InnoDB;

USE `rulefree` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- Enter a few settings
INSERT INTO `rulefree`.`site_settings`(`setting_name`,`setting_value`)VALUES('SITE_ACTIVATION_URL','http://etester.com/rfservice/activateWebuser.do?');
INSERT INTO `rulefree`.`site_settings`(`setting_name`,`setting_value`)VALUES('SITE_PASSWORD_RESET_URL','http://etester.com/rfservice/resetWebuser.do?');


