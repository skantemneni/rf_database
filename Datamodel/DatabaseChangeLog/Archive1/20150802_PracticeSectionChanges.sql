SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;

-- -----------------------------------------------------
-- Table `rulefree`.`core_artifact_types`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`core_artifact_types` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`core_artifact_types` (
  `core_artifact_type` VARCHAR(30) NOT NULL ,
  PRIMARY KEY (`core_artifact_type`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`adaptive_test`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`adaptive_test` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`adaptive_test` (
  `id_adaptive_test` BIGINT NOT NULL AUTO_INCREMENT ,
  `id_level` BIGINT NOT NULL ,
  `id_section` BIGINT NOT NULL ,
  `name` VARCHAR(100) NOT NULL ,
  `id_core_artifact` BIGINT NOT NULL ,
  `core_artifact_type` VARCHAR(30) NOT NULL ,
  PRIMARY KEY (`id_adaptive_test`) ,
  INDEX `fk_adaptive_test_to_section_idx` (`id_section` ASC) ,
  INDEX `fk_adaptive_test_core_artifact_types_idx` (`core_artifact_type` ASC) ,
  INDEX `fk_adaptive_test_to_level_idx` (`id_level` ASC) ,
  CONSTRAINT `fk_adaptive_test_section`
    FOREIGN KEY (`id_section` )
    REFERENCES `rulefree`.`section` (`id_section` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_adaptive_test_core_artifact_types`
    FOREIGN KEY (`core_artifact_type` )
    REFERENCES `rulefree`.`core_artifact_types` (`core_artifact_type` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_adaptive_test_to_level`
    FOREIGN KEY (`id_level` )
    REFERENCES `rulefree`.`level` (`id_level` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

USE `rulefree` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- core_artifact_types
INSERT INTO `rulefree`.`core_artifact_types`(`core_artifact_type`) VALUES ('skill');
INSERT INTO `rulefree`.`core_artifact_types`(`core_artifact_type`) VALUES ('topic');
INSERT INTO `rulefree`.`core_artifact_types`(`core_artifact_type`) VALUES ('level');
INSERT INTO `rulefree`.`core_artifact_types`(`core_artifact_type`) VALUES ('subject');
INSERT INTO `rulefree`.`core_artifact_types`(`core_artifact_type`) VALUES ('channel');

-- physics first year 
INSERT INTO `rulefree`.`adaptive_test`(`id_level`, `id_section`,`name`,`id_core_artifact`,`core_artifact_type`)VALUES(103101, 103101002010001,'Topic Test Section',103101002,'topic');
INSERT INTO `rulefree`.`adaptive_test`(`id_level`, `id_section`,`name`,`id_core_artifact`,`core_artifact_type`)VALUES(103101, 103101002020001,'Skill Test Section',10310100202,'skill');
INSERT INTO `rulefree`.`adaptive_test`(`id_level`, `id_section`,`name`,`id_core_artifact`,`core_artifact_type`)VALUES(103101, 103101002030001,'Skill Test Section',10310100203,'skill');
INSERT INTO `rulefree`.`adaptive_test`(`id_level`, `id_section`,`name`,`id_core_artifact`,`core_artifact_type`)VALUES(103101, 103101002040001,'Skill Test Section',10310100204,'skill');
INSERT INTO `rulefree`.`adaptive_test`(`id_level`, `id_section`,`name`,`id_core_artifact`,`core_artifact_type`)VALUES(103101, 103101002050001,'Skill Test Section',10310100205,'skill');
INSERT INTO `rulefree`.`adaptive_test`(`id_level`, `id_section`,`name`,`id_core_artifact`,`core_artifact_type`)VALUES(103101, 103101002060001,'Skill Test Section',10310100206,'skill');

INSERT INTO `rulefree`.`adaptive_test`(`id_level`, `id_section`,`name`,`id_core_artifact`,`core_artifact_type`)VALUES(103101, 103101003010001,'Topic Test Section',103101003,'topic');
INSERT INTO `rulefree`.`adaptive_test`(`id_level`, `id_section`,`name`,`id_core_artifact`,`core_artifact_type`)VALUES(103101, 103101003020001,'Skill Test Section',10310100302,'skill');
INSERT INTO `rulefree`.`adaptive_test`(`id_level`, `id_section`,`name`,`id_core_artifact`,`core_artifact_type`)VALUES(103101, 103101003030001,'Skill Test Section',10310100303,'skill');

