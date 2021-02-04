SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;

-- -----------------------------------------------------
-- Table `rulefree`.`usermessage`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`usermessage` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`usermessage` (
  `id_usermessage` BIGINT NOT NULL AUTO_INCREMENT ,
  `id_user` BIGINT NOT NULL ,
  `heading` MEDIUMTEXT NULL ,
  `content` MEDIUMTEXT NULL ,
  `link` MEDIUMTEXT NULL ,
  `is_channel_message` TINYINT NOT NULL DEFAULT 0 COMMENT 'is_channel_message tells us if this message is a channel specific message or not. 1= true, 0=false, default=false' ,
  `message_priority` TINYINT NULL DEFAULT 3 COMMENT 'message_priority tells us how important a message is.  Higher numbers indicate greater priority. Normal priority is 3.  ' ,
  `message_acknowledged` TINYINT NULL DEFAULT 0 ,
  `message_expired` TINYINT NULL DEFAULT 0 ,
  `message_creation_date` DATETIME NOT NULL ,
  `message_acknowledged_date` DATETIME NULL ,
  `message_expiration_date` DATETIME NULL ,
  PRIMARY KEY (`id_usermessage`) ,
  INDEX `fk_usermessage_to_user_idx` (`id_user` ASC) ,
  CONSTRAINT `fk_usermessage_to_user`
    FOREIGN KEY (`id_user` )
    REFERENCES `rulefree`.`user` (`id_user` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

USE `rulefree` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
