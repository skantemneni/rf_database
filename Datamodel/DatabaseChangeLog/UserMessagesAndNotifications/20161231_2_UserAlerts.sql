SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;

-- -----------------------------------------------------
-- Table `rulefree`.`user_alert`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`user_alert` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`user_alert` (
  `id_user_alert` BIGINT NOT NULL AUTO_INCREMENT ,
  `id_provider` BIGINT NOT NULL ,
  `name` VARCHAR(100) NOT NULL ,
  `description` VARCHAR(200) NULL ,
  `alert_target_criteria` MEDIUMTEXT NULL ,
  `heading` MEDIUMTEXT NULL ,
  `content` MEDIUMTEXT NULL ,
  `link` MEDIUMTEXT NULL ,
  `alert_type` TINYINT NOT NULL DEFAULT 1 COMMENT '1=user alert, 2=channel alert, default is 1\n' ,
  `alert_priority` TINYINT NULL DEFAULT 5 COMMENT 'message_priority tells us how important a message is.  Higher numbers indicate greater priority. Normal priority is 5.  ' ,
  `alert_creation_date` DATETIME NOT NULL ,
  `alert_publish_date` DATETIME NULL ,
  `alert_expiry_date` DATETIME NULL ,
  `published` TINYINT NOT NULL DEFAULT 0 ,
  `alert_mode_online` TINYINT NULL DEFAULT 0 COMMENT 'alert_mode_online tells if we display online messages when the user logs in' ,
  `alert_mode_email` TINYINT NULL DEFAULT 0 COMMENT 'alert_mode_email tells if we send email messages' ,
  `alert_mode_sms` TINYINT NULL DEFAULT 0 COMMENT 'alert_mode_sms tells if we send sms messages' ,
  PRIMARY KEY (`id_user_alert`) ,
  INDEX `fk_usermessage_to_user_idx` (`id_provider` ASC) ,
  CONSTRAINT `fk_user_alert_to_user`
    FOREIGN KEY (`id_provider` )
    REFERENCES `rulefree`.`user` (`id_user` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

USE `rulefree` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
