SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;

-- -----------------------------------------------------
-- Table `rulefree`.`practiceinstance`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`practiceinstance` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`practiceinstance` (
  `id_user` BIGINT NOT NULL ,
  `id_artifact` BIGINT NOT NULL ,
  `artifact_type` VARCHAR(45) NOT NULL ,
  `practice_status` VARCHAR(45) NOT NULL ,
  `practice_method` VARCHAR(45) NOT NULL ,
  `date_saved` DATETIME NOT NULL ,
  INDEX `fk_practiceinstance_to_user_idx` (`id_user` ASC) ,
  PRIMARY KEY (`id_user`, `id_artifact`) ,
  CONSTRAINT `fk_practiceinstance_to_user`
    FOREIGN KEY (`id_user` )
    REFERENCES `rulefree`.`user` (`id_user` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

USE `rulefree` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
