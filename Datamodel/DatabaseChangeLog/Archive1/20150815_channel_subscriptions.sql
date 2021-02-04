SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;

-- -----------------------------------------------------
-- Table `rulefree`.`channel_subscriptions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`channel_subscriptions` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`channel_subscriptions` (
  `id_channel` BIGINT NOT NULL ,
  `id_student` BIGINT NOT NULL ,
  `start_date` DATE NOT NULL ,
  `end_date` DATE NOT NULL ,
  INDEX `fk_channel_subscriptions_to_channel_idx` (`id_channel` ASC) ,
  INDEX `fk_channel_subscriptions_to_student_idx` (`id_student` ASC) ,
  PRIMARY KEY (`id_channel`, `id_student`) ,
  CONSTRAINT `fk_channel_subscriptions_to_channel`
    FOREIGN KEY (`id_channel` )
    REFERENCES `rulefree`.`system` (`id_system` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_channel_subscriptions_to_student`
    FOREIGN KEY (`id_student` )
    REFERENCES `rulefree`.`user` (`id_user` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

USE `rulefree` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

