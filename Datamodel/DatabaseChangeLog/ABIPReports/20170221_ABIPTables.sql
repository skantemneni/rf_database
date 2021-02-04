SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;

-- -----------------------------------------------------
-- Table `rulefree`.`abiptestinstance`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`abiptestinstance` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`abiptestinstance` (
  `id_testinstance` BIGINT NOT NULL AUTO_INCREMENT ,
  `id_test` BIGINT NOT NULL ,
  `id_user` BIGINT NOT NULL ,
  `id_provider` BIGINT NOT NULL ,
  `id_usertest` BIGINT NOT NULL COMMENT 'id_usertest can be null since usertest table may be purged priodically.' ,
  `name` VARCHAR(100) NOT NULL ,
  `description` VARCHAR(200) NOT NULL ,
  `test_type` VARCHAR(45) NOT NULL COMMENT 'Assignment,Test,Quiz,Challenge - default=Assignment' ,
  `question_count` INT NOT NULL DEFAULT 0 ,
  `point_count` DECIMAL(7,2) NOT NULL DEFAULT 0.0 ,
  `time_to_answer` INT NOT NULL DEFAULT 30 ,
  `correct_count` INT NOT NULL DEFAULT 0 ,
  `user_points` DECIMAL(7,2) NOT NULL DEFAULT 0.0 ,
  `wrong_count` INT NOT NULL DEFAULT 0 ,
  `unanswered_count` INT NOT NULL DEFAULT 0 ,
  `time_in_seconds` INT NOT NULL DEFAULT 0 ,
  `perfect_attempts` INT NULL COMMENT 'perfect_attempts: count of responses that were CORRECT and WITH-IN-TIME\n' ,
  `inefficient_attempts` INT NULL COMMENT 'inefficient_attempts: count of responses that were CORRECT and OUT-OF-TIME\n' ,
  `bad_attempts` INT NULL COMMENT 'bad_attempts: count of responses that were WRONG and OUT-OF-TIME\n\n' ,
  `wasted_attempts` INT NULL COMMENT 'wasted_attempts: : count of responses that were WRONG and WITH-IN-TIME\n' ,
  `attempt_quality` DECIMAL(3,2) NULL COMMENT 'Overall attempt quality of all the questions averaged (2 digits of precision)' ,
  `archived` INT NOT NULL DEFAULT 0 ,
  `test_completion_date` TIMESTAMP NOT NULL ,
  `report_by_subject` INT NULL DEFAULT 0 COMMENT 'Boolean to indicate if a report needs to be generated based on subjects - not sections' ,
  PRIMARY KEY (`id_testinstance`) ,
  INDEX `fk_abiptestinstance_to_test_idx` (`id_test` ASC) ,
  INDEX `fk_abiptestinstance_to_usertest_idx` (`id_usertest` ASC) ,
  CONSTRAINT `fk_abiptestinstance_to_test`
    FOREIGN KEY (`id_test` )
    REFERENCES `rulefree`.`test` (`id_test` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_abiptestinstance_to_usertest`
    FOREIGN KEY (`id_usertest` )
    REFERENCES `rulefree`.`usertest` (`id_usertest` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`abiptestinstance_section`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`abiptestinstance_section` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`abiptestinstance_section` (
  `id_testinstance_section` BIGINT NOT NULL AUTO_INCREMENT ,
  `id_testinstance` BIGINT NOT NULL ,
  `id_section` BIGINT NOT NULL ,
  `testsection_name` VARCHAR(100) NULL ,
  `testsection_description` VARCHAR(200) NULL ,
  `report_subject` VARCHAR(100) NULL ,
  `question_count` INT NOT NULL DEFAULT 0 ,
  `point_count` DECIMAL(7,2) NOT NULL DEFAULT 0 ,
  `time_to_answer` INT NOT NULL DEFAULT 30 ,
  `correct_count` INT NOT NULL DEFAULT 0 ,
  `user_points` DECIMAL(7,2) NOT NULL DEFAULT 0.0 ,
  `wrong_count` INT NOT NULL DEFAULT 0 ,
  `unanswered_count` INT NOT NULL DEFAULT 0 ,
  `time_in_seconds` INT NOT NULL DEFAULT 0 ,
  `perfect_attempts` INT NULL COMMENT 'perfect_attempts: count of responses that were CORRECT and WITH-IN-TIME\n' ,
  `inefficient_attempts` INT NULL COMMENT 'inefficient_attempts: count of responses that were CORRECT and OUT-OF-TIME\n' ,
  `bad_attempts` INT NULL COMMENT 'bad_attempts: count of responses that were WRONG and OUT-OF-TIME\n\n' ,
  `wasted_attempts` INT NULL COMMENT 'wasted_attempts: : count of responses that were WRONG and WITH-IN-TIME\n' ,
  `attempt_quality` DECIMAL(3,2) NULL COMMENT 'Overall attempt quality of all the questions averaged (2 digits of precision)' ,
  `points_per_question` DECIMAL(3,2) NOT NULL DEFAULT 1.0 ,
  `negative_points_per_question` DECIMAL(3,2) NOT NULL DEFAULT 0.0 ,
  `unanswered_points_per_question` DECIMAL(3,2) NULL DEFAULT 0.0 ,
  `seq` INT NULL DEFAULT 1 ,
  `distributed_scoring` INT NULL DEFAULT 0 ,
  `question_start_index` INT NULL DEFAULT 1 ,
  `id_testsection` BIGINT NULL ,
  PRIMARY KEY (`id_testinstance_section`) ,
  INDEX `fk_abiptestinstance_section_to_abiptestinstance_idx` (`id_testinstance` ASC) ,
  CONSTRAINT `fk_abiptestinstance_section_to_abiptestinstance`
    FOREIGN KEY (`id_testinstance` )
    REFERENCES `rulefree`.`abiptestinstance` (`id_testinstance` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`abiptestinstance_detail`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`abiptestinstance_detail` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`abiptestinstance_detail` (
  `id_testinstance_detail` BIGINT NOT NULL AUTO_INCREMENT ,
  `id_testinstance` BIGINT NOT NULL ,
  `id_testinstance_section` BIGINT NOT NULL ,
  `id_section` BIGINT NOT NULL ,
  `id_question` BIGINT NOT NULL ,
  `question_status` VARCHAR(1) NOT NULL ,
  `answer_text` VARCHAR(200) NULL ,
  `user_points` DECIMAL(7,2) NOT NULL DEFAULT 0.0 ,
  `time_in_seconds` INT NOT NULL DEFAULT 0 ,
  `attempt_quality` INT NOT NULL DEFAULT 0 COMMENT 'perfect attempt - intime and correct = 4\ninefficient attempt - out of time and correct = 3\nbad attempt - out of time and wrong = 2\nbad attempt - out of time and unanswered = 2\nwasted attempt - intime and wrong = 1\nwasted attempt - intime and unanswered =  /* comment truncated */ /*1
*/' ,
  PRIMARY KEY (`id_testinstance_detail`) ,
  INDEX `fk_abiptestinstance_detail_to_abiptestinstance_idx` (`id_testinstance` ASC) ,
  CONSTRAINT `fk_abiptestinstance_detail_to_abiptestinstance`
    FOREIGN KEY (`id_testinstance` )
    REFERENCES `rulefree`.`abiptestinstance` (`id_testinstance` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`abiptestresponse`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`abiptestresponse` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`abiptestresponse` (
  `id_abiptestresponse` BIGINT NOT NULL AUTO_INCREMENT ,
  `id_user` BIGINT NOT NULL ,
  `id_test` BIGINT NOT NULL ,
  `response` MEDIUMTEXT NOT NULL ,
  `date_saved` DATETIME NOT NULL ,
  `id_usertest` BIGINT NOT NULL ,
  PRIMARY KEY (`id_abiptestresponse`) ,
  UNIQUE INDEX `uk_abip_user_test` (`id_user` ASC, `id_test` ASC) ,
  INDEX `fk_abiptestresponse_to_usertest_idx` (`id_usertest` ASC) ,
  CONSTRAINT `fk_abiptestresponse_to_usertest`
    FOREIGN KEY (`id_usertest` )
    REFERENCES `rulefree`.`usertest` (`id_usertest` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

USE `rulefree` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
