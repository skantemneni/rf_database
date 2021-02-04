SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;

-- -----------------------------------------------------
-- Table `rulefree`.`anal_test_percentiles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`anal_test_percentiles` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`anal_test_percentiles` (
  `id_test` BIGINT NOT NULL ,
  `id_percentile` INT NOT NULL ,
  `percentage` DECIMAL(5,2) NOT NULL ,
  PRIMARY KEY (`id_test`, `id_percentile`) ,
  INDEX `fk_anal_test_percentiles_to_test_idx` (`id_test` ASC) ,
  CONSTRAINT `fk_anal_test_percentiles_to_test`
    FOREIGN KEY (`id_test` )
    REFERENCES `rulefree`.`test` (`id_test` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`anal_testsection_percentiles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`anal_testsection_percentiles` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`anal_testsection_percentiles` (
  `id_testsection` BIGINT NOT NULL ,
  `id_percentile` INT NOT NULL ,
  `id_testsegment` BIGINT NOT NULL ,
  `id_test` BIGINT NOT NULL ,
  `percentage` DECIMAL(5,2) NOT NULL ,
  INDEX `fk_anal_testsection_percentiles_to_testsection_idx` (`id_testsection` ASC) ,
  PRIMARY KEY (`id_testsection`, `id_percentile`) ,
  CONSTRAINT `fk_anal_testsection_percentiles_to_testsection`
    FOREIGN KEY (`id_testsection` )
    REFERENCES `rulefree`.`testsection` (`id_testsection` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`anal_testsubject_percentiles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`anal_testsubject_percentiles` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`anal_testsubject_percentiles` (
  `subject` VARCHAR(45) NOT NULL ,
  `id_test` BIGINT NOT NULL ,
  `id_percentile` INT NOT NULL ,
  `percentage` DECIMAL(5,2) NOT NULL ,
  PRIMARY KEY (`subject`, `id_test`, `id_percentile`) ,
  INDEX `fk_anal_testsubject_percentiles_to_test_idx` (`id_test` ASC) ,
  CONSTRAINT `fk_anal_testsubject_percentiles_to_test`
    FOREIGN KEY (`id_test` )
    REFERENCES `rulefree`.`test` (`id_test` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`anal_testlevel_percentiles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`anal_testlevel_percentiles` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`anal_testlevel_percentiles` (
  `id_level` BIGINT NOT NULL ,
  `id_test` BIGINT NOT NULL ,
  `id_percentile` INT NOT NULL ,
  `percentage` DECIMAL(5,2) NOT NULL ,
  PRIMARY KEY (`id_level`, `id_test`, `id_percentile`) ,
  INDEX `fk_anal_testlevel_percentiles_to_level_idx` (`id_level` ASC) ,
  INDEX `fk_anal_testlevel_percentiles_to_test_idx` (`id_test` ASC) ,
  CONSTRAINT `fk_anal_testlevel_percentiles_to_level`
    FOREIGN KEY (`id_level` )
    REFERENCES `rulefree`.`level` (`id_level` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_anal_testlevel_percentiles_to_test`
    FOREIGN KEY (`id_test` )
    REFERENCES `rulefree`.`test` (`id_test` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`anal_testtopic_percentiles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`anal_testtopic_percentiles` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`anal_testtopic_percentiles` (
  `id_topic` BIGINT NOT NULL ,
  `id_test` BIGINT NOT NULL ,
  `id_percentile` INT NOT NULL ,
  `percentage` DECIMAL(5,2) NOT NULL ,
  PRIMARY KEY (`id_topic`, `id_test`, `id_percentile`) ,
  INDEX `fk_anal_testtopic_percentiles_to_topic_idx` (`id_topic` ASC) ,
  INDEX `fk_anal_testtopic_percentiles_to_test_idx` (`id_test` ASC) ,
  CONSTRAINT `fk_anal_testtopic_percentiles_to_topic`
    FOREIGN KEY (`id_topic` )
    REFERENCES `rulefree`.`topic` (`id_topic` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_anal_testtopic_percentiles_to_test`
    FOREIGN KEY (`id_test` )
    REFERENCES `rulefree`.`test` (`id_test` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

USE `rulefree` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
