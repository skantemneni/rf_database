SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;

-- -----------------------------------------------------
-- Table `rulefree`.`profile`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`profile` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`profile` (
  `id_profile` BIGINT NOT NULL AUTO_INCREMENT ,
  `id_provider` BIGINT NOT NULL COMMENT 'ID of the Provider who created the Profile.' ,
  `id_organization` BIGINT NOT NULL COMMENT 'The organization that owns the profile.' ,
  `name` VARCHAR(100) NOT NULL ,
  `description` VARCHAR(200) NULL ,
  `access_level` INT NOT NULL DEFAULT 1 COMMENT '1=private, 2=organization, 3=public' ,
  `published` INT NOT NULL DEFAULT 0 COMMENT '0=no, 1=yes' ,
  `profile_type` INT NOT NULL DEFAULT 1 COMMENT '1=fixed-date-based, 2=start-day-based, 3=undated' ,
  PRIMARY KEY (`id_profile`) ,
  INDEX `fk_profile_to_provider_idx` (`id_provider` ASC) ,
  INDEX `fk_profile_to_organization_idx` (`id_organization` ASC) ,
  CONSTRAINT `fk_profile_to_provider`
    FOREIGN KEY (`id_provider` )
    REFERENCES `rulefree`.`user` (`id_user` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_profile_to_organization`
    FOREIGN KEY (`id_organization` )
    REFERENCES `rulefree`.`organization` (`id_organization` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`profilesegment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`profilesegment` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`profilesegment` (
  `id_profilesegment` BIGINT NOT NULL ,
  `id_profile` BIGINT NOT NULL DEFAULT 0 ,
  `name` VARCHAR(100) NOT NULL DEFAULT 'Default Test Segment' ,
  `description` VARCHAR(200) NULL ,
  `seq` INT NULL DEFAULT 1 ,
  `profiletest_wrapper` INT NULL DEFAULT 0 COMMENT 'Boolean to indicate if the segment was automatically created to simple wrap a top level section.' ,
  PRIMARY KEY (`id_profilesegment`) ,
  INDEX `fk_profilesegment_to_profile_idx` (`id_profile` ASC) ,
  CONSTRAINT `fk_profilesegment_to_profile`
    FOREIGN KEY (`id_profile` )
    REFERENCES `rulefree`.`profile` (`id_profile` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`profiletest`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`profiletest` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`profiletest` (
  `id_profiletest` BIGINT NOT NULL ,
  `id_profile` BIGINT NOT NULL ,
  `id_profilesegment` BIGINT NOT NULL ,
  `id_test_ref` BIGINT NOT NULL ,
  `name` VARCHAR(100) NOT NULL ,
  `description` VARCHAR(200) NULL ,
  `seq` INT NULL DEFAULT 1 ,
  `test_provision_day` INT NULL ,
  `test_removal_day` INT NULL ,
  `test_provision_date` TIMESTAMP NULL ,
  `test_removal_date` TIMESTAMP NULL ,
  `initial_active` INT NOT NULL DEFAULT 0 COMMENT 'Initial State of this test for profile_type Sequenced.  1=yes, 0=no, null=0' ,
  PRIMARY KEY (`id_profiletest`) ,
  INDEX `fk_profiletest_to_profilesegment_idx` (`id_profilesegment` ASC) ,
  INDEX `fk_profiletest_to_test_idx` (`id_test_ref` ASC) ,
  INDEX `fk_profiletest_to_profile_idx` (`id_profile` ASC) ,
  UNIQUE INDEX `uk_profile_test` (`id_profile` ASC, `id_test_ref` ASC) ,
  CONSTRAINT `fk_profiletest_to_profilesegment`
    FOREIGN KEY (`id_profilesegment` )
    REFERENCES `rulefree`.`profilesegment` (`id_profilesegment` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_profiletest_to_test`
    FOREIGN KEY (`id_test_ref` )
    REFERENCES `rulefree`.`test` (`id_test` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_profiletest_to_profile`
    FOREIGN KEY (`id_profile` )
    REFERENCES `rulefree`.`profile` (`id_profile` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`userprofile`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`userprofile` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`userprofile` (
  `id_userprofile` BIGINT NOT NULL AUTO_INCREMENT ,
  `id_profile` BIGINT NOT NULL ,
  `id_provider` BIGINT NOT NULL COMMENT 'ID of the Provider that Assigned the profile to the student.' ,
  `id_student` BIGINT NOT NULL COMMENT 'ID of the student.' ,
  `profile_assignment_date` TIMESTAMP NOT NULL COMMENT 'Date the profile was Assigned. (Not the start Date)' ,
  `profile_start_date` TIMESTAMP NULL COMMENT 'The day when the profile starts being administered.  This only matters for Fixed_Day profiles.' ,
  INDEX `fk_userprofile_profile_idx` (`id_profile` ASC) ,
  INDEX `fk_userprofile_student_idx` (`id_student` ASC) ,
  INDEX `fk_userprofile_provider_idx` (`id_provider` ASC) ,
  PRIMARY KEY (`id_userprofile`) ,
  UNIQUE INDEX `uk_userprofile_alt_key` (`id_profile` ASC, `id_student` ASC) ,
  CONSTRAINT `fk_userprofile_profile`
    FOREIGN KEY (`id_profile` )
    REFERENCES `rulefree`.`profile` (`id_profile` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_userprofile_student`
    FOREIGN KEY (`id_student` )
    REFERENCES `rulefree`.`user` (`id_user` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_userprofile_provider`
    FOREIGN KEY (`id_provider` )
    REFERENCES `rulefree`.`user` (`id_user` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`userprofiletest`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`userprofiletest` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`userprofiletest` (
  `id_userprofile` BIGINT NOT NULL ,
  `id_profiletest` BIGINT NOT NULL ,
  `test_provision_date` TIMESTAMP NOT NULL COMMENT 'Date will match profiletest test_provision_date for ExactDates profile.  For Fixed Days profile, this date is calculated as the userprofile.profile_start_date + profiletest.test_provision_day.' ,
  `test_removal_date` TIMESTAMP NULL COMMENT 'Date will match profiletest test_removal_date for ExactDates profile.  For Fixed Days profile, this date is calculated as the userprofile.profile_start_date + profiletest.test_removal_day.' ,
  `active` INT NOT NULL DEFAULT 1 COMMENT 'Ready to be transferred to usertest when date matches?  1=yes, 0=no, null=0' ,
  PRIMARY KEY (`id_userprofile`, `id_profiletest`) ,
  INDEX `fk_userprofiletest_2_userprofile_idx` (`id_userprofile` ASC) ,
  INDEX `fk_userprofiletest_to_profiletest_idx` (`id_profiletest` ASC) ,
  CONSTRAINT `fk_userprofiletest_2_userprofile`
    FOREIGN KEY (`id_userprofile` )
    REFERENCES `rulefree`.`userprofile` (`id_userprofile` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_userprofiletest_to_profiletest`
    FOREIGN KEY (`id_profiletest` )
    REFERENCES `rulefree`.`profiletest` (`id_profiletest` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

USE `rulefree` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
