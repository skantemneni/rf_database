SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;

-- -----------------------------------------------------
-- Table `rulefree`.`testsynopsislink`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`testsynopsislink` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`testsynopsislink` (
  `id_testsynopsislink` BIGINT NOT NULL ,
  `id_testsegment` BIGINT NOT NULL ,
  `id_synopsis_link_ref` BIGINT NOT NULL ,
  `name` VARCHAR(100) NOT NULL ,
  `description` VARCHAR(200) NULL ,
  `link` VARCHAR(400) NOT NULL ,
  `link_type` INT NULL DEFAULT 1 ,
  `seq` INT NULL DEFAULT 1 ,
  PRIMARY KEY (`id_testsynopsislink`) ,
  INDEX `fk_testsection_to_testsegment_idx` (`id_testsegment` ASC) ,
  INDEX `fk_testsynopsislink_to_synopsis_link_idx` (`id_synopsis_link_ref` ASC) ,
  CONSTRAINT `fk_testsynopsislink_to_testsegment`
    FOREIGN KEY (`id_testsegment` )
    REFERENCES `rulefree`.`testsegment` (`id_testsegment` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_testsynopsislink_to_synopsis_link`
    FOREIGN KEY (`id_synopsis_link_ref` )
    REFERENCES `rulefree`.`synopsis_link` (`id_core_artifact` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;

USE `rulefree` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
