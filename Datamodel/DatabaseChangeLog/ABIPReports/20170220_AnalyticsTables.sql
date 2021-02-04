SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;

-- -----------------------------------------------------
-- Table `rulefree`.`anal_test_rollup`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`anal_test_rollup` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`anal_test_rollup` (
  `id_test` BIGINT NOT NULL ,
  `correct_count_average` INT NULL DEFAULT 0 COMMENT 'Number of questions corerctly answered' ,
  `correct_points_average` DECIMAL(5,2) NULL DEFAULT 0 COMMENT 'Average points score' ,
  `percentage_average` DECIMAL(5,2) NULL DEFAULT 0 COMMENT 'average percentage as per points' ,
  `sd1` DECIMAL(5,2) NULL DEFAULT 0 COMMENT 'standard diviation as per points' ,
  PRIMARY KEY (`id_test`) ,
  CONSTRAINT `fk_anal_test_rollup_to_test`
    FOREIGN KEY (`id_test` )
    REFERENCES `rulefree`.`test` (`id_test` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`anal_test_data`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`anal_test_data` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`anal_test_data` (
  `id_usertest` BIGINT NOT NULL ,
  `id_test` BIGINT NOT NULL ,
  `correct_count` INT NULL DEFAULT 0 COMMENT 'Number of questions corerctly answered' ,
  `correct_points` DECIMAL(5,2) NULL DEFAULT 0 COMMENT 'points score' ,
  `percentage` DECIMAL(5,2) NULL DEFAULT 0 COMMENT 'points percentage score' ,
  PRIMARY KEY (`id_usertest`) ,
  INDEX `fk_anal_test_data_to_test_idx` (`id_test` ASC) ,
  CONSTRAINT `fk_anal_test_data_to_usertest`
    FOREIGN KEY (`id_usertest` )
    REFERENCES `rulefree`.`usertest` (`id_usertest` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_anal_test_data_to_test`
    FOREIGN KEY (`id_test` )
    REFERENCES `rulefree`.`test` (`id_test` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`anal_testsection_data`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`anal_testsection_data` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`anal_testsection_data` (
  `id_usertest` BIGINT NOT NULL ,
  `id_testsection` BIGINT NOT NULL ,
  `id_test` BIGINT NOT NULL ,
  `correct_count` INT NULL DEFAULT 0 COMMENT 'Number of questions corerctly answered' ,
  `correct_points` DECIMAL(5,2) NULL DEFAULT 0 ,
  `percentage` DECIMAL(5,2) NULL DEFAULT 0 ,
  PRIMARY KEY (`id_usertest`, `id_testsection`) ,
  CONSTRAINT `fk_anal_testsection_data_to_usertest`
    FOREIGN KEY (`id_usertest` )
    REFERENCES `rulefree`.`usertest` (`id_usertest` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`anal_testsection_rollup`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`anal_testsection_rollup` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`anal_testsection_rollup` (
  `id_testsection` BIGINT NOT NULL ,
  `id_testsegment` BIGINT NOT NULL ,
  `id_test` BIGINT NOT NULL ,
  `correct_count_average` INT NULL DEFAULT 0 COMMENT 'Number of questions corerctly answered' ,
  `correct_points_average` DECIMAL(5,2) NULL DEFAULT 0 ,
  `percentage_average` DECIMAL(5,2) NULL DEFAULT 0 ,
  `sd1` VARCHAR(45) NULL ,
  PRIMARY KEY (`id_testsection`) ,
  CONSTRAINT `fk_anal_testsection_rollup_to_testsection`
    FOREIGN KEY (`id_testsection` )
    REFERENCES `rulefree`.`testsection` (`id_testsection` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`anal_testlevel_data`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`anal_testlevel_data` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`anal_testlevel_data` (
  `id_usertest` BIGINT NOT NULL ,
  `id_level` BIGINT NOT NULL ,
  `id_test` BIGINT NOT NULL ,
  `correct_count` INT NULL DEFAULT 0 COMMENT 'Number of questions corerctly answered' ,
  `total_count` INT NULL DEFAULT 0 ,
  `correct_points` DECIMAL(5,2) NULL DEFAULT 0 ,
  `total_points` DECIMAL(5,2) NULL DEFAULT 0 ,
  `percentage` DECIMAL(5,2) NULL DEFAULT 0 ,
  PRIMARY KEY (`id_usertest`, `id_level`) ,
  INDEX `fk_anal_testlevel_data_to_level_idx` (`id_level` ASC) ,
  INDEX `fk_anal_testlevel_data_to_usertest_idx` (`id_usertest` ASC) ,
  CONSTRAINT `fk_anal_testlevel_data_to_level`
    FOREIGN KEY (`id_level` )
    REFERENCES `rulefree`.`level` (`id_level` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_anal_testlevel_data_to_usertest`
    FOREIGN KEY (`id_usertest` )
    REFERENCES `rulefree`.`usertest` (`id_usertest` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`anal_testlevel_rollup`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`anal_testlevel_rollup` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`anal_testlevel_rollup` (
  `id_level` BIGINT NOT NULL ,
  `id_test` BIGINT NOT NULL ,
  `correct_count_average` DECIMAL(5,2) NULL DEFAULT 0 COMMENT 'Number of questions corerctly answered' ,
  `total_count` INT NULL DEFAULT 0 ,
  `correct_points_average` DECIMAL(5,2) NULL DEFAULT 0 ,
  `total_points` DECIMAL(5,2) NULL DEFAULT 0 ,
  `percentage_average` DECIMAL(5,2) NULL DEFAULT 0 ,
  `sd1` DECIMAL(5,2) NULL DEFAULT 0 ,
  PRIMARY KEY (`id_level`, `id_test`) ,
  INDEX `fk_anal_testlevel_rollup_to_level_idx` (`id_level` ASC) ,
  INDEX `fk_anal_testlevel_rollup_to_test_idx` (`id_test` ASC) ,
  CONSTRAINT `fk_anal_testlevel_rollup_to_level`
    FOREIGN KEY (`id_level` )
    REFERENCES `rulefree`.`level` (`id_level` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_anal_testlevel_rollup_to_test`
    FOREIGN KEY (`id_test` )
    REFERENCES `rulefree`.`test` (`id_test` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`anal_testtopic_rollup`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`anal_testtopic_rollup` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`anal_testtopic_rollup` (
  `id_topic` BIGINT NOT NULL ,
  `id_test` BIGINT NOT NULL ,
  `correct_count_average` DECIMAL(5,2) NULL DEFAULT 0 COMMENT 'Number of questions corerctly answered' ,
  `total_count` INT NULL DEFAULT 0 ,
  `correct_points_average` DECIMAL(5,2) NULL DEFAULT 0 ,
  `total_points` DECIMAL(5,2) NULL DEFAULT 0 ,
  `percentage_average` DECIMAL(5,2) NULL DEFAULT 0 ,
  `sd1` DECIMAL(5,2) NULL DEFAULT 0 ,
  PRIMARY KEY (`id_topic`, `id_test`) ,
  INDEX `fk_anal_testtopic_rollup_to_topic_idx` (`id_topic` ASC) ,
  INDEX `fk_anal_testtopic_rollup_to_test_idx` (`id_test` ASC) ,
  CONSTRAINT `fk_anal_testtopic_rollup_to_topic`
    FOREIGN KEY (`id_topic` )
    REFERENCES `rulefree`.`topic` (`id_topic` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_anal_testtopic_rollup_to_test`
    FOREIGN KEY (`id_test` )
    REFERENCES `rulefree`.`test` (`id_test` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`anal_testtopic_data`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`anal_testtopic_data` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`anal_testtopic_data` (
  `id_usertest` BIGINT NOT NULL ,
  `id_topic` BIGINT NOT NULL ,
  `id_test` BIGINT NOT NULL ,
  `correct_count` INT NULL DEFAULT 0 COMMENT 'Number of questions corerctly answered' ,
  `total_count` INT NULL DEFAULT 0 ,
  `correct_points` DECIMAL(5,2) NULL DEFAULT 0 ,
  `total_points` DECIMAL(5,2) NULL DEFAULT 0 ,
  `percentage` DECIMAL(5,2) NULL DEFAULT 0 ,
  PRIMARY KEY (`id_usertest`, `id_topic`) ,
  INDEX `fk_anal_testtopic_data_to_topic_idx` (`id_topic` ASC) ,
  INDEX `fk_anal_testtopic_data_to_usertest_idx` (`id_usertest` ASC) ,
  CONSTRAINT `fk_anal_testtopic_data_to_topic`
    FOREIGN KEY (`id_topic` )
    REFERENCES `rulefree`.`topic` (`id_topic` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_anal_testtopic_data_to_usertest`
    FOREIGN KEY (`id_usertest` )
    REFERENCES `rulefree`.`usertest` (`id_usertest` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`anal_testsubject_data`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`anal_testsubject_data` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`anal_testsubject_data` (
  `id_usertest` BIGINT NOT NULL ,
  `subject` VARCHAR(45) NOT NULL ,
  `id_test` BIGINT NOT NULL ,
  `correct_count` INT NULL DEFAULT 0 COMMENT 'Number of questions corerctly answered' ,
  `total_count` INT NULL DEFAULT 0 ,
  `correct_points` DECIMAL(5,2) NULL DEFAULT 0 ,
  `total_points` DECIMAL(5,2) NULL DEFAULT 0 ,
  `percentage` DECIMAL(5,2) NULL DEFAULT 0 ,
  PRIMARY KEY (`id_usertest`, `subject`) ,
  INDEX `fk_anal_testsubject_data_to_usertest_idx` (`id_usertest` ASC) ,
  CONSTRAINT `fk_anal_testsubject_data_to_usertest`
    FOREIGN KEY (`id_usertest` )
    REFERENCES `rulefree`.`usertest` (`id_usertest` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`anal_testsubject_rollup`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`anal_testsubject_rollup` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`anal_testsubject_rollup` (
  `subject` VARCHAR(45) NOT NULL ,
  `id_test` BIGINT NOT NULL ,
  `correct_count_average` DECIMAL(5,2) NULL DEFAULT 0 COMMENT 'Number of questions corerctly answered' ,
  `total_count` INT NULL DEFAULT 0 ,
  `correct_points_average` DECIMAL(5,2) NULL DEFAULT 0 ,
  `total_points` DECIMAL(5,2) NULL DEFAULT 0 ,
  `percentage_average` DECIMAL(5,2) NULL DEFAULT 0 ,
  `sd1` DECIMAL(5,2) NULL DEFAULT 0 ,
  PRIMARY KEY (`subject`, `id_test`) ,
  INDEX `fk_anal_testsubject_rollup_to_test_idx` (`id_test` ASC) ,
  CONSTRAINT `fk_anal_testsubject_rollup_to_test`
    FOREIGN KEY (`id_test` )
    REFERENCES `rulefree`.`test` (`id_test` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;

USE `rulefree` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
