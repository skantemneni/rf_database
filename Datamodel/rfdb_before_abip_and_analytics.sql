SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;

-- -----------------------------------------------------
-- Table `rulefree`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`user` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`user` (
  `id_user` BIGINT NOT NULL AUTO_INCREMENT ,
  `username` VARCHAR(50) NOT NULL ,
  `password` VARCHAR(200) NOT NULL ,
  `enabled` INT NULL DEFAULT 0 COMMENT '1=true,0=false,null=0' ,
  `email_address` VARCHAR(50) NOT NULL ,
  `first_name` VARCHAR(45) NOT NULL ,
  `last_name` VARCHAR(45) NOT NULL ,
  `middle_name` VARCHAR(45) NULL ,
  PRIMARY KEY (`id_user`) ,
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`address` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`address` (
  `id_address` BIGINT NOT NULL AUTO_INCREMENT ,
  `id_user` BIGINT NOT NULL ,
  `address_line1` VARCHAR(100) NOT NULL ,
  `address_line2` VARCHAR(100) NULL ,
  `city` VARCHAR(45) NOT NULL ,
  `state` VARCHAR(2) NOT NULL ,
  `zip` VARCHAR(5) NOT NULL ,
  `zip-ext` VARCHAR(4) NULL ,
  PRIMARY KEY (`id_address`) ,
  INDEX `fk_address_to_user_idx` (`id_user` ASC) ,
  CONSTRAINT `fk_address_to_user`
    FOREIGN KEY (`id_user` )
    REFERENCES `rulefree`.`user` (`id_user` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`testtype`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`testtype` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`testtype` (
  `test_type` VARCHAR(45) NOT NULL ,
  `description` VARCHAR(200) NULL ,
  PRIMARY KEY (`test_type`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`organization`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`organization` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`organization` (
  `id_organization` BIGINT NOT NULL ,
  `name` VARCHAR(200) NOT NULL ,
  `description` VARCHAR(400) NOT NULL ,
  `text` MEDIUMTEXT NULL ,
  `addl_info` MEDIUMTEXT NULL ,
  PRIMARY KEY (`id_organization`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`examtrack`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`examtrack` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`examtrack` (
  `examtrack` VARCHAR(45) NOT NULL ,
  `description` VARCHAR(200) NOT NULL ,
  PRIMARY KEY (`examtrack`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`system`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`system` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`system` (
  `id_system` BIGINT NOT NULL COMMENT 'can have a range of 100 - 999.' ,
  `name` VARCHAR(100) NULL ,
  `description` VARCHAR(200) NULL ,
  `addl_info` MEDIUMTEXT NULL ,
  `text` MEDIUMTEXT NULL ,
  `editable` TINYINT NOT NULL DEFAULT 0 ,
  `published` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`id_system`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`test`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`test` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`test` (
  `id_test` BIGINT NOT NULL ,
  `id_provider` BIGINT NOT NULL ,
  `id_organization` BIGINT NOT NULL COMMENT 'The organization that owns the test.' ,
  `id_channel` BIGINT NOT NULL ,
  `name` VARCHAR(100) NOT NULL ,
  `description` VARCHAR(200) NULL ,
  `test_type` VARCHAR(45) NOT NULL DEFAULT 'Assignment' ,
  `text` MEDIUMTEXT NULL ,
  `addl_info` MEDIUMTEXT NULL ,
  `test_level` VARCHAR(45) NULL ,
  `timed` INT NULL DEFAULT 1 ,
  `time_to_answer` INT NULL DEFAULT 30 ,
  `published` INT NOT NULL DEFAULT 1 ,
  `access_level` INT NOT NULL DEFAULT 1 COMMENT '1=private, 2=organization, 3=public' ,
  `is_practice` INT NOT NULL DEFAULT 0 COMMENT 'Indicates if its a practice test.  0 = test, 1 = practice, default = 0.' ,
  `question_count` INT NULL DEFAULT 0 ,
  `point_count` DECIMAL(7,2) NULL DEFAULT 0.0 ,
  `auto_grade` INT NOT NULL DEFAULT 1 COMMENT 'auto_grade can be 1 or 0.  1 indicates that the test moves from Submitted to Corrections stage without any interaction from the provider.  0 indicates that the test must be graded and approved by the provider.' ,
  `auto_publish_results` INT NOT NULL DEFAULT 1 COMMENT 'This only applies to TEST test_type objects.  auto_publish_results can take values of 1 and 0.  1 indicates that the results are published for stat purposes automatically.  0 indicates that the user needs to approve such a publish explicitely.' ,
  `examtrack` VARCHAR(45) NULL ,
  `is_free` INT NOT NULL DEFAULT 0 COMMENT 'Indicates if its a free test.  0 = paid, 1 = free, default = 0.' ,
  `report_by_subject` INT NULL DEFAULT 0 COMMENT 'Boolean to indicate if a report needs to be generated based on subjects - not sections' ,
  `combine_sections` INT NULL DEFAULT 0 COMMENT '0=NoCombineSections, 1=CombineSectionsForSegment, 2=CombineSectionsForTest, Else 0' ,
  PRIMARY KEY (`id_test`) ,
  INDEX `fk_test_to_user_idx` (`id_provider` ASC) ,
  INDEX `fk_test_to_testtype_idx` (`test_type` ASC) ,
  INDEX `fk_test_to_organization_idx` (`id_organization` ASC) ,
  INDEX `fk_test_to_examtrack_idx` (`examtrack` ASC) ,
  INDEX `fk_test_to_channel_idx` (`id_channel` ASC) ,
  CONSTRAINT `fk_test_to_user`
    FOREIGN KEY (`id_provider` )
    REFERENCES `rulefree`.`user` (`id_user` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_test_to_testtype`
    FOREIGN KEY (`test_type` )
    REFERENCES `rulefree`.`testtype` (`test_type` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_test_to_organization`
    FOREIGN KEY (`id_organization` )
    REFERENCES `rulefree`.`organization` (`id_organization` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_test_to_examtrack`
    FOREIGN KEY (`examtrack` )
    REFERENCES `rulefree`.`examtrack` (`examtrack` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_test_to_channel`
    FOREIGN KEY (`id_channel` )
    REFERENCES `rulefree`.`system` (`id_system` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`emailaddress`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`emailaddress` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`emailaddress` (
  `id_emailaddress` BIGINT NOT NULL AUTO_INCREMENT ,
  `id_user` BIGINT NOT NULL ,
  `emailaddress` VARCHAR(45) NOT NULL ,
  `primary_flag` TINYINT(1) NULL DEFAULT 0 ,
  PRIMARY KEY (`id_emailaddress`) ,
  INDEX `fk_emailaddress_to_user_idx` (`id_user` ASC) ,
  CONSTRAINT `fk_emailaddress_to_user`
    FOREIGN KEY (`id_user` )
    REFERENCES `rulefree`.`user` (`id_user` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`role`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`role` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`role` (
  `authority` VARCHAR(50) NOT NULL COMMENT 'ROLE_USER, ROLE_PROVIDER, ROLE_ADMIN, ROLE_SYSTEM' ,
  PRIMARY KEY (`authority`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`authorities`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`authorities` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`authorities` (
  `username` VARCHAR(50) NOT NULL ,
  `authority` VARCHAR(50) NOT NULL COMMENT 'ROLE_USER, ROLE_PROVIDER, ROLE_ADMIN, ROLE_SYSTEM' ,
  INDEX `fk_authorities_to_user_idx` (`username` ASC) ,
  INDEX `fk_authorities_to_role_idx` (`authority` ASC) ,
  CONSTRAINT `fk_authorities_to_user`
    FOREIGN KEY (`username` )
    REFERENCES `rulefree`.`user` (`username` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_authorities_to_role`
    FOREIGN KEY (`authority` )
    REFERENCES `rulefree`.`role` (`authority` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`practicesection`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`practicesection` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`practicesection` (
  `id_section` BIGINT NOT NULL AUTO_INCREMENT ,
  `id_provider` INT NULL COMMENT 'the provider user who owns the question.  can be null.  Null indicates any one can use the question for their tests.' ,
  `id_studenttopic` INT NOT NULL ,
  `name` VARCHAR(45) NULL COMMENT '\n' ,
  `description` VARCHAR(200) NULL ,
  `section_category` VARCHAR(15) NOT NULL DEFAULT 'general' COMMENT 'helps classify questions into categories for ease of searching and filtering purposes.' ,
  `section_subject` VARCHAR(15) NOT NULL DEFAULT 'general' ,
  `section_text` MEDIUMTEXT NOT NULL ,
  `section_addl_info` MEDIUMTEXT NULL ,
  `time_to_answer` INT NULL DEFAULT 600 ,
  `auto_generated` INT NULL DEFAULT '0' ,
  `generator_metadata` MEDIUMTEXT NULL ,
  `question_banner` VARCHAR(45) NULL ,
  `question_heading` VARCHAR(200) NULL ,
  `question_instructions` VARCHAR(200) NULL ,
  PRIMARY KEY (`id_section`) )
ENGINE = InnoDB
COMMENT = '			';


-- -----------------------------------------------------
-- Table `rulefree`.`subject`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`subject` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`subject` (
  `subject_name` VARCHAR(45) NOT NULL ,
  `description` VARCHAR(200) NULL ,
  PRIMARY KEY (`subject_name`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`level`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`level` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`level` (
  `id_level` BIGINT NOT NULL COMMENT 'can be between 1 and 999.' ,
  `id_system` BIGINT NOT NULL ,
  `id_provider` BIGINT NOT NULL DEFAULT 0 COMMENT 'default to root provider = 0.  FK to user table later.' ,
  `subject` VARCHAR(45) NOT NULL ,
  `subject_header` VARCHAR(100) NULL ,
  `name` VARCHAR(100) NOT NULL ,
  `display_name` VARCHAR(100) NULL ,
  `description` VARCHAR(500) NOT NULL ,
  `text` MEDIUMTEXT NULL ,
  `addl_info` MEDIUMTEXT NULL ,
  `published` INT NOT NULL DEFAULT 1 ,
  `derived` INT NOT NULL DEFAULT 0 ,
  `id_level_reference` BIGINT NULL ,
  `topiccount` INT NULL DEFAULT 0 ,
  `skillcount` INT NULL DEFAULT 0 ,
  PRIMARY KEY (`id_level`) ,
  INDEX `fk_level_to_system_idx` (`id_system` ASC) ,
  INDEX `fk_level_to_subject_idx` (`subject` ASC) ,
  INDEX `fk_id_level_reference_to_level_idx` (`id_level_reference` ASC) ,
  CONSTRAINT `fk_level_to_system`
    FOREIGN KEY (`id_system` )
    REFERENCES `rulefree`.`system` (`id_system` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_level_to_subject`
    FOREIGN KEY (`subject` )
    REFERENCES `rulefree`.`subject` (`subject_name` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_id_level_reference_to_level`
    FOREIGN KEY (`id_level_reference` )
    REFERENCES `rulefree`.`level` (`id_level` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`topic`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`topic` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`topic` (
  `id_topic` BIGINT NOT NULL ,
  `id_level` BIGINT NOT NULL ,
  `id_provider` BIGINT NOT NULL DEFAULT 0 COMMENT 'default to 0.  Enable FK to users table later' ,
  `subject` VARCHAR(100) NULL ,
  `name` VARCHAR(100) NOT NULL ,
  `display_name` VARCHAR(100) NULL COMMENT 'Shown on the screen whenever the topic is shown.  Can be null in which case the name value is rendered. ' ,
  `description` VARCHAR(500) NULL ,
  `text` MEDIUMTEXT NULL ,
  `addl_info` MEDIUMTEXT NULL ,
  `published` INT NOT NULL DEFAULT 1 ,
  `derived` INT NOT NULL DEFAULT 0 ,
  `display_order` INT NULL DEFAULT 0 ,
  `id_topic_reference` BIGINT NULL ,
  PRIMARY KEY (`id_topic`) ,
  INDEX `fk_topic_to_level_idx` (`id_level` ASC) ,
  INDEX `fk_id_topic_reference_to_topic_idx` (`id_topic_reference` ASC) ,
  CONSTRAINT `fk_topic_to_level`
    FOREIGN KEY (`id_level` )
    REFERENCES `rulefree`.`level` (`id_level` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_id_topic_reference_to_topic`
    FOREIGN KEY (`id_topic_reference` )
    REFERENCES `rulefree`.`topic` (`id_topic` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`skill`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`skill` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`skill` (
  `id_skill` BIGINT NOT NULL ,
  `id_topic` BIGINT NOT NULL ,
  `id_provider` BIGINT NOT NULL DEFAULT 0 COMMENT 'Fk to user table later' ,
  `subject` VARCHAR(100) NULL ,
  `name` VARCHAR(200) NOT NULL ,
  `display_name` VARCHAR(200) NULL COMMENT 'Shown on the screen whenever the skill is shown.  Can be null in which case the name value is rendered. ' ,
  `description` VARCHAR(500) NULL ,
  `text` MEDIUMTEXT NULL ,
  `addl_info` MEDIUMTEXT NULL ,
  `published` INT NULL DEFAULT 1 ,
  `derived_skill` INT NOT NULL DEFAULT 0 ,
  `display_order` INT NULL DEFAULT 0 ,
  `id_skill_reference` BIGINT NULL ,
  PRIMARY KEY (`id_skill`) ,
  INDEX `fk_skill_to_topic_idx` (`id_topic` ASC) ,
  INDEX `fk_id_skill_reference_to_skill_idx` (`id_skill_reference` ASC) ,
  CONSTRAINT `fk_skill_to_topic`
    FOREIGN KEY (`id_topic` )
    REFERENCES `rulefree`.`topic` (`id_topic` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_id_skill_reference_to_skill`
    FOREIGN KEY (`id_skill_reference` )
    REFERENCES `rulefree`.`skill` (`id_skill` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`section`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`section` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`section` (
  `id_section` BIGINT NOT NULL ,
  `id_skill` BIGINT NOT NULL ,
  `id_provider` BIGINT NULL DEFAULT 0 COMMENT 'the provider user who owns the section.  can be null.  This is significant for a DerivedSection. (section type = \'ds\')' ,
  `name` VARCHAR(100) NULL COMMENT '\n' ,
  `description` VARCHAR(200) NULL ,
  `text` MEDIUMTEXT NULL ,
  `is_linktext` INT NULL DEFAULT 0 COMMENT '0=false, 1=true,default=0' ,
  `linktext_address` VARCHAR(200) NULL ,
  `addl_info` MEDIUMTEXT NULL ,
  `time_to_answer` INT NULL DEFAULT 10 ,
  `auto_generated` INT NULL DEFAULT '0' ,
  `generator_metadata` MEDIUMTEXT NULL ,
  `question_banner` VARCHAR(45) NULL ,
  `question_heading` VARCHAR(200) NULL ,
  `question_instructions` VARCHAR(200) NULL ,
  `is_external` INT NOT NULL DEFAULT 0 ,
  `section_type` VARCHAR(10) NULL ,
  `is_practice` INT NOT NULL DEFAULT 0 COMMENT 'Indicates if its a practice section. 0 = test, 1 = practice, default = 0.' ,
  PRIMARY KEY (`id_section`) ,
  INDEX `fk_section_to_skill_idx` (`id_skill` ASC) ,
  CONSTRAINT `fk_section_to_skill`
    FOREIGN KEY (`id_skill` )
    REFERENCES `rulefree`.`skill` (`id_skill` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '			';


-- -----------------------------------------------------
-- Table `rulefree`.`questiontype`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`questiontype` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`questiontype` (
  `question_type` VARCHAR(45) NOT NULL ,
  `description` VARCHAR(200) NULL ,
  PRIMARY KEY (`question_type`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`question`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`question` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`question` (
  `id_question` BIGINT NOT NULL AUTO_INCREMENT ,
  `id_section` BIGINT NOT NULL COMMENT 'the provider user who owns the question.  can be null.  Null indicates any one can use the question for their tests.' ,
  `name` VARCHAR(100) NULL COMMENT '\n' ,
  `description` VARCHAR(200) NULL ,
  `text` MEDIUMTEXT NOT NULL ,
  `addl_info` MEDIUMTEXT NULL ,
  `text_precontext` MEDIUMTEXT NULL ,
  `text_postcontext` MEDIUMTEXT NULL ,
  `banner` VARCHAR(45) NULL ,
  `heading` VARCHAR(200) NULL ,
  `instructions` VARCHAR(200) NULL ,
  `question_type` VARCHAR(45) NOT NULL DEFAULT 'MultipleChoice' COMMENT 'indicates write in answer or multiple choice\n' ,
  `multiple_answers` INT NULL DEFAULT 0 ,
  `all_answers` INT NULL DEFAULT 0 ,
  `points` INT NULL DEFAULT 1 ,
  `id_questionset` BIGINT NULL ,
  `reference_skills` VARCHAR(100) NULL ,
  `id_reference_topic` BIGINT NULL ,
  `id_reference_level` BIGINT NULL ,
  PRIMARY KEY (`id_question`) ,
  INDEX `fk_question_to_section_idx` (`id_section` ASC) ,
  INDEX `fk_question_to_questiontype_idx` (`question_type` ASC) ,
  CONSTRAINT `fk_question_to_section`
    FOREIGN KEY (`id_section` )
    REFERENCES `rulefree`.`section` (`id_section` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_question_to_questiontype`
    FOREIGN KEY (`question_type` )
    REFERENCES `rulefree`.`questiontype` (`question_type` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '			';


-- -----------------------------------------------------
-- Table `rulefree`.`answer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`answer` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`answer` (
  `id_answer` BIGINT NOT NULL AUTO_INCREMENT ,
  `id_question` BIGINT NOT NULL ,
  `seq` INT NOT NULL DEFAULT 1 ,
  `correct` INT NOT NULL DEFAULT 1 ,
  `text` MEDIUMTEXT NULL ,
  `addl_info` MEDIUMTEXT NULL ,
  `answer_compare_type` TINYINT NULL COMMENT 'answer_compare_type can be one of 3 values: 1=text, 2=integer, 3=numeric.\nDefault is text compare (1).' ,
  `answer_compare_addl_info` VARCHAR(3) NULL COMMENT 'Value here depends on whats entered on the answer_compare_type values.\n1.) For Text compare (1) this value is a 3 char string for, the characters representing the following:\n    a.) 1st char: 0=case insensitive, 1= case sensitive\n    b.) 2nd char: 0=do no /* comment truncated */ /*t trim surrounding white space, 1 = trim surrounding white space
    c.) 3rd char: 0= trim interior white spaces to one white space, 1 = leave interior white spaces alone
2.) For Integer Compare (2) this value has no significance
3.) For Decimal Compare (3) this value is a number indicating the number of digits of precision to compare
*/' ,
  PRIMARY KEY (`id_answer`) ,
  INDEX `fk_answer_to_question_idx` (`id_question` ASC) ,
  CONSTRAINT `fk_answer_to_question`
    FOREIGN KEY (`id_question` )
    REFERENCES `rulefree`.`question` (`id_question` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`testsegment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`testsegment` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`testsegment` (
  `id_testsegment` BIGINT NOT NULL ,
  `id_test` BIGINT NOT NULL DEFAULT 0 ,
  `name` VARCHAR(100) NOT NULL DEFAULT 'Default Test Segment' ,
  `description` VARCHAR(200) NULL ,
  `text` MEDIUMTEXT NULL ,
  `addl_info` MEDIUMTEXT NULL ,
  `time_to_answer` INT NULL DEFAULT 30 ,
  `seq` INT NULL DEFAULT 1 ,
  `published` INT NULL DEFAULT 1 ,
  `sectionwrapper` INT NULL DEFAULT 0 COMMENT 'Boolean to indicate if the segment was automatically created to simple wrap a top level section.' ,
  `point_count` DECIMAL(7,2) NULL DEFAULT 0.0 ,
  `question_count` INT NULL DEFAULT 0 ,
  PRIMARY KEY (`id_testsegment`) ,
  INDEX `fk_testsegment_to_test_idx` (`id_test` ASC) ,
  CONSTRAINT `fk_testsegment_to_test`
    FOREIGN KEY (`id_test` )
    REFERENCES `rulefree`.`test` (`id_test` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`mysection`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`mysection` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`mysection` (
  `id_mysection` BIGINT NOT NULL AUTO_INCREMENT ,
  `id_section` BIGINT NOT NULL ,
  `id_provider` BIGINT NOT NULL DEFAULT 0 ,
  `name` VARCHAR(100) NULL COMMENT '\n' ,
  `description` VARCHAR(200) NULL ,
  PRIMARY KEY (`id_mysection`) ,
  INDEX `fk_mysection_to_provider_idx` (`id_provider` ASC) ,
  CONSTRAINT `fk_mysection_to_provider`
    FOREIGN KEY (`id_provider` )
    REFERENCES `rulefree`.`user` (`id_user` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '			';


-- -----------------------------------------------------
-- Table `rulefree`.`testsection_instructions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`testsection_instructions` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`testsection_instructions` (
  `instructions_name` VARCHAR(100) NOT NULL ,
  `description` VARCHAR(200) NULL ,
  `text` MEDIUMTEXT NULL ,
  `addl_info` MEDIUMTEXT NULL ,
  PRIMARY KEY (`instructions_name`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`testsection`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`testsection` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`testsection` (
  `id_testsection` BIGINT NOT NULL ,
  `id_testsegment` BIGINT NOT NULL ,
  `id_section_ref` BIGINT NOT NULL ,
  `name` VARCHAR(100) NULL ,
  `description` VARCHAR(200) NULL ,
  `report_subject` VARCHAR(100) NULL ,
  `time_to_answer` INT NULL DEFAULT 10 ,
  `seq` INT NULL DEFAULT 1 ,
  `point_count` DECIMAL(7,2) NULL DEFAULT 0.0 ,
  `question_count` INT NULL DEFAULT 0 ,
  `points_per_question` DECIMAL(3,2) NOT NULL DEFAULT 1.0 ,
  `negative_points_per_question` DECIMAL(3,2) NOT NULL DEFAULT 0.0 ,
  `unanswered_points_per_question` DECIMAL(3,2) NULL DEFAULT 0.0 ,
  `question_start_index` INT NULL DEFAULT 1 ,
  `distributed_scoring` INT NULL DEFAULT 0 ,
  `instructions_name` VARCHAR(100) NULL ,
  PRIMARY KEY (`id_testsection`) ,
  INDEX `fk_testsection_to_testsegment_idx` (`id_testsegment` ASC) ,
  INDEX `fk_testsection_to_section_idx` (`id_section_ref` ASC) ,
  INDEX `fk_testsection_to_testsection_instructions_idx` (`instructions_name` ASC) ,
  CONSTRAINT `fk_testsection_to_testsegment`
    FOREIGN KEY (`id_testsegment` )
    REFERENCES `rulefree`.`testsegment` (`id_testsegment` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_testsection_to_section`
    FOREIGN KEY (`id_section_ref` )
    REFERENCES `rulefree`.`section` (`id_section` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_testsection_to_testsection_instructions`
    FOREIGN KEY (`instructions_name` )
    REFERENCES `rulefree`.`testsection_instructions` (`instructions_name` )
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`teststatus`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`teststatus` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`teststatus` (
  `test_status` VARCHAR(45) NOT NULL ,
  `description` VARCHAR(200) NULL ,
  PRIMARY KEY (`test_status`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`usertest`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`usertest` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`usertest` (
  `id_usertest` BIGINT NOT NULL AUTO_INCREMENT ,
  `id_provider` BIGINT NOT NULL COMMENT 'The user provider that owns the usertest record.' ,
  `id_test` BIGINT NOT NULL ,
  `id_user` BIGINT NOT NULL ,
  `id_profile` BIGINT NOT NULL DEFAULT 0 COMMENT '0 indicates that this Record has no associated Profile' ,
  `auto_grade` INT NOT NULL DEFAULT 1 COMMENT 'auto_grade can be 1 or 0.  1 indicates that the test moves from Submitted to Corrections stage without any interaction from the provider.  0 indicates that the test must be graded and approved by the provider.' ,
  `auto_publish_results` INT NOT NULL DEFAULT 1 COMMENT 'This only applies to TEST test_type objects.  auto_publish_results can take values of 1 and 0.  1 indicates that the results are published for stat purposes automatically.  0 indicates that the user needs to approve such a publish explicitely.' ,
  `test_type` VARCHAR(45) NOT NULL DEFAULT 'Assignment' COMMENT 'Assignment,Test,Quiz,Challenge - default=Assignment' ,
  `user_type` INT NOT NULL DEFAULT 1 COMMENT '1=user, 2=usergroup,null=1' ,
  `name` VARCHAR(100) NOT NULL ,
  `description` VARCHAR(200) NULL ,
  `test_assignment_date` TIMESTAMP NULL ,
  `test_completion_date` TIMESTAMP NULL ,
  `test_reassignment_date` TIMESTAMP NULL ,
  `test_status` VARCHAR(45) NOT NULL DEFAULT 'assigned' COMMENT 'assigned,started,3=submitted,4=corrections,5=completed,archived.  default=assigned' ,
  `test_archived` INT NULL COMMENT '0=true,1=false,null=1' ,
  `active` INT NULL DEFAULT 0 COMMENT '0=true, 1=false, null=0' ,
  `id_profiletest` BIGINT NULL COMMENT 'ID of the Profiletest record - if the usertest ic created from a Profile Assignment.  Null otherwise.' ,
  `profile_name` VARCHAR(100) NULL COMMENT 'Name of the profile - if the usertest record is the result of a profile test assignment.  Null otherwise.  This will help us avoid a link to the profile table when querying for usertests.' ,
  `profilesegment_name` VARCHAR(100) NULL COMMENT 'Name of the profilesegment associated with the profiletest - if the usertest record is the result of a profile test assignment.  Null otherwise.  This will help us avoid a link to the profilesegment table when querying for usertests.' ,
  PRIMARY KEY (`id_usertest`) ,
  UNIQUE INDEX `id_usertest_UNIQUE` (`id_usertest` ASC) ,
  INDEX `fk_usertest_to_test_idx` (`id_test` ASC) ,
  INDEX `fk_usertest_to_teststatus_idx` (`test_status` ASC) ,
  INDEX `fk_usertest_to_testtype_idx` (`test_type` ASC) ,
  INDEX `fk_usertest_to_user_idx` (`id_user` ASC) ,
  UNIQUE INDEX `uk_id_test_id_profile` (`id_user` ASC, `id_test` ASC, `id_profile` ASC) ,
  CONSTRAINT `fk_usertest_to_test`
    FOREIGN KEY (`id_test` )
    REFERENCES `rulefree`.`test` (`id_test` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_usertest_to_user`
    FOREIGN KEY (`id_user` )
    REFERENCES `rulefree`.`user` (`id_user` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usertest_to_teststatus`
    FOREIGN KEY (`test_status` )
    REFERENCES `rulefree`.`teststatus` (`test_status` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usertest_to_testtype`
    FOREIGN KEY (`test_type` )
    REFERENCES `rulefree`.`testtype` (`test_type` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`providerstudent`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`providerstudent` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`providerstudent` (
  `id_providerstudent` BIGINT NOT NULL AUTO_INCREMENT ,
  `student_username` VARCHAR(50) NOT NULL ,
  `provider_username` VARCHAR(50) NOT NULL ,
  INDEX `fk_providerstudent_to_user1_idx` (`provider_username` ASC) ,
  INDEX `fk_providerstudent_to_user2_idx` (`student_username` ASC) ,
  PRIMARY KEY (`id_providerstudent`) ,
  UNIQUE INDEX `pk_providerstudent_alt_key` (`student_username` ASC, `provider_username` ASC) ,
  CONSTRAINT `fk_providerstudent_to_userAsProvider`
    FOREIGN KEY (`provider_username` )
    REFERENCES `rulefree`.`user` (`username` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_providerstudent_to_userAsStudent`
    FOREIGN KEY (`student_username` )
    REFERENCES `rulefree`.`user` (`username` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`usergroup`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`usergroup` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`usergroup` (
  `id_usergroup` BIGINT NOT NULL AUTO_INCREMENT ,
  `provider_username` VARCHAR(50) NOT NULL ,
  `name` VARCHAR(100) NOT NULL ,
  `description` VARCHAR(200) NULL ,
  PRIMARY KEY (`id_usergroup`) ,
  INDEX `fk_usergroup_to_user_idx` (`provider_username` ASC) ,
  CONSTRAINT `fk_usergroup_to_user`
    FOREIGN KEY (`provider_username` )
    REFERENCES `rulefree`.`user` (`username` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`usergroupmember`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`usergroupmember` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`usergroupmember` (
  `id_usergroupmember` BIGINT NOT NULL AUTO_INCREMENT ,
  `id_usergroup` BIGINT NOT NULL ,
  `username` VARCHAR(50) NOT NULL ,
  PRIMARY KEY (`id_usergroupmember`) ,
  INDEX `fk_usergroupmember_to_usergroup_idx` (`id_usergroup` ASC) ,
  INDEX `fk_usergroupmember_to_user_idx` (`username` ASC) ,
  UNIQUE INDEX `pk_alt_usergroupmember` (`id_usergroup` ASC, `username` ASC) ,
  CONSTRAINT `fk_usergroupmember_to_usergroup`
    FOREIGN KEY (`id_usergroup` )
    REFERENCES `rulefree`.`usergroup` (`id_usergroup` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_usergroupmember_to_user`
    FOREIGN KEY (`username` )
    REFERENCES `rulefree`.`user` (`username` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`grade`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`grade` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`grade` (
  `grade_name` VARCHAR(45) NOT NULL ,
  `description` VARCHAR(200) NULL ,
  PRIMARY KEY (`grade_name`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`gradeskill`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`gradeskill` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`gradeskill` (
  `id_gradeskill` BIGINT NOT NULL AUTO_INCREMENT ,
  `grade_name` VARCHAR(45) NOT NULL ,
  `id_skill` BIGINT NOT NULL ,
  `alt_name` VARCHAR(100) NULL ,
  `alt_description` VARCHAR(200) NULL ,
  PRIMARY KEY (`id_gradeskill`) ,
  INDEX `fk_grade_skill_skill_idx` (`id_skill` ASC) ,
  INDEX `fk_gradeskill_grade_idx` (`grade_name` ASC) ,
  CONSTRAINT `fk_gradeskill_skill`
    FOREIGN KEY (`id_skill` )
    REFERENCES `rulefree`.`skill` (`id_skill` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_gradeskill_grade`
    FOREIGN KEY (`grade_name` )
    REFERENCES `rulefree`.`grade` (`grade_name` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`gradelevel`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`gradelevel` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`gradelevel` (
  `id_gradelevel` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'can be between 1 and 999.' ,
  `id_system` BIGINT NOT NULL ,
  `id_provider` BIGINT NOT NULL DEFAULT 0 COMMENT 'default to root provider = 0.  FK to user table later.' ,
  `gradekey` VARCHAR(45) NOT NULL ,
  `subject` VARCHAR(45) NOT NULL ,
  `subject_header` VARCHAR(100) NULL ,
  `name` VARCHAR(100) NOT NULL ,
  `display_name` VARCHAR(100) NULL ,
  `description` VARCHAR(200) NOT NULL ,
  `text` MEDIUMTEXT NULL ,
  `addl_info` MEDIUMTEXT NULL ,
  `published` INT NOT NULL DEFAULT 1 ,
  `derived` INT NOT NULL DEFAULT 1 ,
  `topiccount` INT NULL DEFAULT 0 ,
  `skillcount` INT NULL DEFAULT 0 ,
  PRIMARY KEY (`id_gradelevel`) ,
  INDEX `fk_level_to_system_idx` (`id_system` ASC) ,
  INDEX `fk_gradelevel_to_subject_idx` (`subject` ASC) ,
  INDEX `fk_gradelevel_to_grade_idx` (`gradekey` ASC) ,
  UNIQUE INDEX `uk_unique_subject_grade` (`gradekey` ASC, `subject` ASC) ,
  CONSTRAINT `fk_gradelevel_to_system`
    FOREIGN KEY (`id_system` )
    REFERENCES `rulefree`.`system` (`id_system` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_gradelevel_to_subject`
    FOREIGN KEY (`subject` )
    REFERENCES `rulefree`.`subject` (`subject_name` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_gradelevel_to_grade`
    FOREIGN KEY (`gradekey` )
    REFERENCES `rulefree`.`grade` (`grade_name` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`wl_wordlist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`wl_wordlist` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`wl_wordlist` (
  `id_wordlist` BIGINT NOT NULL ,
  `id_skill` BIGINT NOT NULL ,
  `id_provider` BIGINT NOT NULL ,
  `name` VARCHAR(100) NOT NULL ,
  `description` VARCHAR(200) NULL COMMENT 'Represents a Vocabuulary word list table.  A module specific table for English Language.' ,
  PRIMARY KEY (`id_wordlist`) ,
  INDEX `fk_wordlist_to_skill_idx` (`id_skill` ASC) ,
  CONSTRAINT `fk_wordlist_to_skill`
    FOREIGN KEY (`id_skill` )
    REFERENCES `rulefree`.`skill` (`id_skill` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_wordlist_to_section`
    FOREIGN KEY (`id_wordlist` )
    REFERENCES `rulefree`.`section` (`id_section` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`wl_word`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`wl_word` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`wl_word` (
  `id_word` BIGINT NOT NULL ,
  `id_wordlist` BIGINT NOT NULL ,
  `word` VARCHAR(100) NOT NULL ,
  `definition` VARCHAR(400) NULL ,
  `pronunciation` VARCHAR(100) NULL ,
  `synonym` VARCHAR(200) NULL ,
  `antonym` VARCHAR(200) NULL ,
  `thesaurus` VARCHAR(200) NULL ,
  `sampletext` MEDIUMTEXT NULL ,
  PRIMARY KEY (`id_word`) ,
  INDEX `fk_word_to_wordlist_idx` (`id_wordlist` ASC) ,
  CONSTRAINT `fk_word_to_wordlist`
    FOREIGN KEY (`id_wordlist` )
    REFERENCES `rulefree`.`wl_wordlist` (`id_wordlist` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`wl_passage`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`wl_passage` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`wl_passage` (
  `id_passage` BIGINT NOT NULL ,
  `id_wordlist` BIGINT NOT NULL ,
  `text` MEDIUMTEXT NOT NULL ,
  PRIMARY KEY (`id_passage`) ,
  INDEX `fk_passage_to_wordlist_idx` (`id_wordlist` ASC) ,
  CONSTRAINT `fk_passage_to_wordlist`
    FOREIGN KEY (`id_wordlist` )
    REFERENCES `rulefree`.`wl_wordlist` (`id_wordlist` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`wl_answer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`wl_answer` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`wl_answer` (
  `id_answer` BIGINT NOT NULL ,
  `id_question` BIGINT NOT NULL ,
  `text` MEDIUMTEXT NOT NULL ,
  PRIMARY KEY (`id_answer`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`cword`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`cword` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`cword` (
  `id_cword` BIGINT NOT NULL ,
  `id_system` BIGINT NOT NULL ,
  `id_provider` BIGINT NOT NULL DEFAULT 0 COMMENT 'default to root provider = 0.  FK to user table later.' ,
  `id_level` BIGINT NOT NULL COMMENT 'can be between 1 and 999.' ,
  `name` VARCHAR(100) NOT NULL ,
  `pronunciation` VARCHAR(500) NULL ,
  `syllables` VARCHAR(100) NULL ,
  `published` INT NOT NULL DEFAULT 1 ,
  `themes` VARCHAR(100) NULL ,
  `rank` VARCHAR(10) NULL ,
  `syllable_count` INT(11) NULL ,
  `source` VARCHAR(100) NULL ,
  `audio_file_url` VARCHAR(200) NULL ,
  `video_file_url` VARCHAR(200) NULL ,
  PRIMARY KEY (`id_cword`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`cworddef`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`cworddef` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`cworddef` (
  `id_cworddef` BIGINT NOT NULL ,
  `id_cword` BIGINT NOT NULL ,
  `pos` VARCHAR(5) NOT NULL ,
  `definition` VARCHAR(1000) NOT NULL ,
  `synonym` VARCHAR(400) NULL ,
  `antonym` VARCHAR(200) NULL ,
  `thesaurus` VARCHAR(400) NULL ,
  `sampletext` MEDIUMTEXT NULL ,
  PRIMARY KEY (`id_cworddef`) ,
  INDEX `fk_cworddef_to_cword_idx` (`id_cword` ASC) ,
  CONSTRAINT `fk_cworddef_to_cword`
    FOREIGN KEY (`id_cword` )
    REFERENCES `rulefree`.`cword` (`id_cword` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`cwordusage`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`cwordusage` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`cwordusage` (
  `id_cwordusage` BIGINT NOT NULL ,
  `id_cword` BIGINT NOT NULL ,
  `text` MEDIUMTEXT NOT NULL ,
  `source` VARCHAR(200) NULL ,
  PRIMARY KEY (`id_cwordusage`) ,
  INDEX `fk_cwordusage_to_cword_idx` (`id_cword` ASC) ,
  CONSTRAINT `fk_cwordusage_to_cword`
    FOREIGN KEY (`id_cword` )
    REFERENCES `rulefree`.`cword` (`id_cword` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`logtable`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`logtable` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`logtable` (
  `id` BIGINT NOT NULL AUTO_INCREMENT ,
  `msg` MEDIUMTEXT NOT NULL ,
  `date_time` DATETIME NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`cgradeword`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`cgradeword` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`cgradeword` (
  `id_cgradeword` BIGINT NOT NULL AUTO_INCREMENT ,
  `id_section` BIGINT NOT NULL ,
  `id_cword` BIGINT NOT NULL ,
  PRIMARY KEY (`id_cgradeword`) ,
  INDEX `fk_cgradeword_to_cword_idx` (`id_cword` ASC) ,
  UNIQUE INDEX `uk_section_cword` (`id_section` ASC, `id_cword` ASC) ,
  CONSTRAINT `fk_cgradeword_to_cword`
    FOREIGN KEY (`id_cword` )
    REFERENCES `rulefree`.`cword` (`id_cword` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`testinstance`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`testinstance` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`testinstance` (
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
  INDEX `fk_testinstance_to_test_idx` (`id_test` ASC) ,
  CONSTRAINT `fk_testinstance_to_test`
    FOREIGN KEY (`id_test` )
    REFERENCES `rulefree`.`test` (`id_test` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`usertestresponse`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`usertestresponse` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`usertestresponse` (
  `id_usertestresponse` BIGINT NOT NULL AUTO_INCREMENT ,
  `id_usertest` BIGINT NOT NULL ,
  `response` MEDIUMTEXT NOT NULL ,
  `date_saved` DATETIME NOT NULL ,
  INDEX `fk_usertestresponse_to_usertest_idx` (`id_usertest` ASC) ,
  UNIQUE INDEX `uk_id_usertest_idx` (`id_usertest` ASC) ,
  PRIMARY KEY (`id_usertestresponse`) ,
  CONSTRAINT `fk_usertestresponse_to_usertest`
    FOREIGN KEY (`id_usertest` )
    REFERENCES `rulefree`.`usertest` (`id_usertest` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`webuser_password_transaction`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`webuser_password_transaction` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`webuser_password_transaction` (
  `username` VARCHAR(50) NOT NULL ,
  `transaction_type` VARCHAR(1) NOT NULL ,
  `transaction_key` VARCHAR(200) NOT NULL ,
  `new_password` VARCHAR(200) NOT NULL ,
  `transaction_expiry_date` DATETIME NOT NULL COMMENT 'Table used to track and password related transactions.  New passwords, updates, resets etc.\nNote that there can only be one active user transaction at any given time.' ,
  PRIMARY KEY (`username`) ,
  CONSTRAINT `fk_webuser_password_transaction_to_user`
    FOREIGN KEY (`username` )
    REFERENCES `rulefree`.`user` (`username` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`webuser`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`webuser` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`webuser` (
  `username` VARCHAR(50) NOT NULL ,
  `first_name` VARCHAR(45) NOT NULL ,
  `last_name` VARCHAR(45) NOT NULL ,
  `middle_name` VARCHAR(45) NULL ,
  `gender` VARCHAR(1) NOT NULL ,
  `profession` VARCHAR(50) NULL ,
  `institution` VARCHAR(100) NULL ,
  `branch_year` VARCHAR(40) NULL ,
  `address_line1` VARCHAR(100) NOT NULL ,
  `address_line2` VARCHAR(100) NULL ,
  `country` VARCHAR(40) NOT NULL ,
  `phone_number` VARCHAR(10) NOT NULL ,
  `dob` DATE NOT NULL ,
  `from_channel` VARCHAR(50) NOT NULL DEFAULT 'Other' ,
  `date_created` DATETIME NOT NULL ,
  PRIMARY KEY (`username`) ,
  CONSTRAINT `fk_webuser_to_user`
    FOREIGN KEY (`username` )
    REFERENCES `rulefree`.`user` (`username` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`usersectionresponse`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`usersectionresponse` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`usersectionresponse` (
  `id_user` BIGINT NOT NULL ,
  `id_artifact` BIGINT NOT NULL DEFAULT 0 ,
  `id_section` BIGINT NOT NULL ,
  `date_saved` DATETIME NOT NULL ,
  `response` MEDIUMTEXT NOT NULL ,
  INDEX `fk_usersectionresponse_to_user_idx` (`id_user` ASC) ,
  INDEX `fk_usersectionresponse_to_section_idx` (`id_section` ASC) ,
  PRIMARY KEY (`id_user`, `id_artifact`, `id_section`) ,
  CONSTRAINT `fk_usersectionresponse_to_user`
    FOREIGN KEY (`id_user` )
    REFERENCES `rulefree`.`user` (`id_user` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_usersectionresponse_to_section`
    FOREIGN KEY (`id_section` )
    REFERENCES `rulefree`.`section` (`id_section` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`questionset`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`questionset` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`questionset` (
  `id_questionset` BIGINT NOT NULL ,
  `id_section` BIGINT NOT NULL ,
  `text` MEDIUMTEXT NULL ,
  PRIMARY KEY (`id_questionset`) ,
  INDEX `fk_questionset_to_section_idx` (`id_section` ASC) ,
  CONSTRAINT `fk_questionset_to_section`
    FOREIGN KEY (`id_section` )
    REFERENCES `rulefree`.`section` (`id_section` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`testinstance_detail`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`testinstance_detail` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`testinstance_detail` (
  `id_testinstance_detail` BIGINT NOT NULL AUTO_INCREMENT ,
  `id_testinstance` BIGINT NOT NULL ,
  `id_testinstance_section` BIGINT NOT NULL ,
  `id_section` BIGINT NOT NULL ,
  `id_question` BIGINT NOT NULL ,
  `question_status` VARCHAR(1) NOT NULL ,
  `answer_text` VARCHAR(200) NULL ,
  `time_in_seconds` INT NOT NULL DEFAULT 0 ,
  `attempt_quality` INT NOT NULL DEFAULT 0 COMMENT 'perfect attempt - intime and correct = 4\ninefficient attempt - out of time and correct = 3\nbad attempt - out of time and wrong = 2\nbad attempt - out of time and unanswered = 2\nwasted attempt - intime and wrong = 1\nwasted attempt - intime and unanswered =  /* comment truncated */ /*1
*/' ,
  PRIMARY KEY (`id_testinstance_detail`) ,
  INDEX `fk_testinstance_detail_to_testinstance_idx` (`id_testinstance` ASC) ,
  CONSTRAINT `fk_testinstance_detail_to_testinstance`
    FOREIGN KEY (`id_testinstance` )
    REFERENCES `rulefree`.`testinstance` (`id_testinstance` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`testinstance_section`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`testinstance_section` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`testinstance_section` (
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
  INDEX `fk_testinstance_section_to_testinstance_idx` (`id_testinstance` ASC) ,
  CONSTRAINT `fk_testinstance_section_to_testinstance`
    FOREIGN KEY (`id_testinstance` )
    REFERENCES `rulefree`.`testinstance` (`id_testinstance` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


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
-- Table `rulefree`.`derived_section_question`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`derived_section_question` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`derived_section_question` (
  `id_derived_section_question` BIGINT NOT NULL AUTO_INCREMENT ,
  `id_section` BIGINT NOT NULL ,
  `id_question` BIGINT NOT NULL ,
  `question_order` INT NOT NULL ,
  PRIMARY KEY (`id_derived_section_question`) ,
  INDEX `fk_derived_section_question_to_section_idx` (`id_section` ASC) ,
  INDEX `fk_derived_section_question_to_question_idx` (`id_question` ASC) ,
  CONSTRAINT `fk_derived_section_question_to_section`
    FOREIGN KEY (`id_section` )
    REFERENCES `rulefree`.`section` (`id_section` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_derived_section_question_to_question`
    FOREIGN KEY (`id_question` )
    REFERENCES `rulefree`.`question` (`id_question` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`organization_channel`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`organization_channel` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`organization_channel` (
  `id_organization_channel` BIGINT NOT NULL AUTO_INCREMENT ,
  `id_organization` BIGINT NOT NULL ,
  `id_channel` BIGINT NOT NULL ,
  PRIMARY KEY (`id_organization_channel`) ,
  INDEX `fk_organization_channel_to_system_idx` (`id_channel` ASC) ,
  INDEX `fk_organization_channel_to_organization_idx` (`id_organization` ASC) ,
  CONSTRAINT `fk_organization_channel_to_system`
    FOREIGN KEY (`id_channel` )
    REFERENCES `rulefree`.`system` (`id_system` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_organization_channel_to_organization`
    FOREIGN KEY (`id_organization` )
    REFERENCES `rulefree`.`organization` (`id_organization` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`organization_provider`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`organization_provider` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`organization_provider` (
  `id_organization_provider` BIGINT NOT NULL AUTO_INCREMENT ,
  `id_organization` BIGINT NOT NULL ,
  `id_provider` BIGINT NOT NULL ,
  PRIMARY KEY (`id_organization_provider`) ,
  INDEX `fk_organization_provider_to_organization_idx` (`id_organization` ASC) ,
  INDEX `fk_organization_provider_to_provider_idx` (`id_provider` ASC) ,
  UNIQUE INDEX `uk_provider_to_only_one_organization` (`id_provider` ASC) ,
  CONSTRAINT `fk_organization_provider_to_organization`
    FOREIGN KEY (`id_organization` )
    REFERENCES `rulefree`.`organization` (`id_organization` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_organization_provider_to_provider`
    FOREIGN KEY (`id_provider` )
    REFERENCES `rulefree`.`user` (`id_user` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`privilege`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`privilege` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`privilege` (
  `privilege` VARCHAR(50) NOT NULL COMMENT 'many permissions like UPDATE_TEST, UPDATE_ANY_TEST etc.' ,
  PRIMARY KEY (`privilege`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`permissions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`permissions` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`permissions` (
  `username` VARCHAR(50) NOT NULL ,
  `privilege` VARCHAR(50) NOT NULL COMMENT 'ROLE_USER, ROLE_PROVIDER, ROLE_ADMIN, ROLE_SYSTEM' ,
  INDEX `fk_permissions_to_user_idx` (`username` ASC) ,
  INDEX `fk_permissions_to_privilege_idx` (`privilege` ASC) ,
  CONSTRAINT `fk_permissions_to_user`
    FOREIGN KEY (`username` )
    REFERENCES `rulefree`.`user` (`username` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_permissions_to_privilege`
    FOREIGN KEY (`privilege` )
    REFERENCES `rulefree`.`privilege` (`privilege` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`serialized_test`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`serialized_test` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`serialized_test` (
  `id_test` BIGINT NOT NULL ,
  `test_string_json` MEDIUMTEXT NOT NULL ,
  `date_saved` DATETIME NOT NULL ,
  PRIMARY KEY (`id_test`) ,
  CONSTRAINT `fk_serialized_test_to_test`
    FOREIGN KEY (`id_test` )
    REFERENCES `rulefree`.`test` (`id_test` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`redumption_code`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`redumption_code` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`redumption_code` (
  `redumption_code` VARCHAR(16) NOT NULL ,
  `total_uses` INT NOT NULL DEFAULT 1 ,
  `current_uses` INT NOT NULL DEFAULT 0 ,
  `id_channel` BIGINT NULL DEFAULT 0 COMMENT 'System ID to which the code applies.  0 indicates the code is not channel restricted and can be used across channels.' ,
  `test_restricted` INT NOT NULL DEFAULT 0 COMMENT 'test_restricted = 0 means its not restricted to a test in the channel\ntest_restricted = 1 means it can only be used on certain tests in the channel.  Expect to find mappings in the mappings table\n\n' ,
  `retail_price` INT NOT NULL DEFAULT 0 COMMENT 'List Price for the code (in rupees)\n' ,
  `sale_price` INT NOT NULL DEFAULT 0 COMMENT 'actual price it was sold for\n' ,
  `purchaser` VARCHAR(200) NULL ,
  `redeemed` INT NOT NULL DEFAULT 0 COMMENT '0 = yet to complete redumption\n1 = already redeemed\n' ,
  `start_date` TIMESTAMP NULL ,
  `expiration_date` TIMESTAMP NULL ,
  PRIMARY KEY (`redumption_code`) ,
  INDEX `fk_redumption_codes_to_system_idx` (`id_channel` ASC) ,
  CONSTRAINT `fk_redumption_codes_to_system`
    FOREIGN KEY (`id_channel` )
    REFERENCES `rulefree`.`system` (`id_system` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`redumption_code_test`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`redumption_code_test` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`redumption_code_test` (
  `redumption_code` VARCHAR(16) NOT NULL ,
  `id_test` BIGINT NOT NULL ,
  PRIMARY KEY (`redumption_code`, `id_test`) ,
  INDEX `fl_redumption_code_test_to_redumption_code_idx` (`redumption_code` ASC) ,
  INDEX `fk_redumption_code_test_to_test_idx` (`id_test` ASC) ,
  CONSTRAINT `fl_redumption_code_test_to_redumption_code`
    FOREIGN KEY (`redumption_code` )
    REFERENCES `rulefree`.`redumption_code` (`redumption_code` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_redumption_code_test_to_test`
    FOREIGN KEY (`id_test` )
    REFERENCES `rulefree`.`test` (`id_test` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`serialized_testinstance`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`serialized_testinstance` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`serialized_testinstance` (
  `id_testinstance` BIGINT NOT NULL ,
  `testinstance_string_json` MEDIUMTEXT NOT NULL ,
  `date_saved` DATETIME NOT NULL ,
  PRIMARY KEY (`id_testinstance`) ,
  CONSTRAINT `fk_serialized_testinstance_to_testinstance`
    FOREIGN KEY (`id_testinstance` )
    REFERENCES `rulefree`.`testinstance` (`id_testinstance` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`rank_estimator`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`rank_estimator` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`rank_estimator` (
  `id_rank_estimator` BIGINT NOT NULL AUTO_INCREMENT ,
  `exam_name` VARCHAR(100) NOT NULL ,
  `sub_exam_name` VARCHAR(100) NULL ,
  `percentage_score` DECIMAL(5,2) NOT NULL ,
  `estimated_rank` INT NOT NULL ,
  PRIMARY KEY (`id_rank_estimator`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`testalias`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`testalias` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`testalias` (
  `id_testalias` BIGINT NOT NULL AUTO_INCREMENT ,
  `id_test` BIGINT NOT NULL ,
  `name` VARCHAR(100) NULL ,
  `description` VARCHAR(200) NULL ,
  `examtrack` VARCHAR(45) NOT NULL ,
  `is_free` INT NOT NULL DEFAULT 0 COMMENT 'Indicates if its a free test.  0 = paid, 1 = free, default = 0.' ,
  `date_free_start` DATETIME NULL ,
  `date_free_end` DATETIME NULL ,
  `free_message` VARCHAR(45) NULL ,
  PRIMARY KEY (`id_testalias`) ,
  UNIQUE INDEX `id_test_UNIQUE` (`id_test` ASC) ,
  CONSTRAINT `fk_testalias_to_test`
    FOREIGN KEY (`id_test` )
    REFERENCES `rulefree`.`test` (`id_test` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


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
  `id_section` BIGINT NULL ,
  `name` VARCHAR(100) NULL ,
  `id_core_artifact` BIGINT NOT NULL ,
  `core_artifact_type` VARCHAR(30) NOT NULL ,
  `test_artifacts_string` VARCHAR(1000) NULL ,
  `test_type` VARCHAR(1) NULL DEFAULT 'S' ,
  `test_mode` VARCHAR(1) NULL DEFAULT 'A' ,
  PRIMARY KEY (`id_adaptive_test`) ,
  INDEX `fk_adaptive_test_core_artifact_types_idx` (`core_artifact_type` ASC) ,
  INDEX `fk_adaptive_test_to_level_idx` (`id_level` ASC) ,
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
  `practice_additional_info` VARCHAR(400) NULL ,
  `practice_status_int` INT NOT NULL DEFAULT 0 ,
  INDEX `fk_practiceinstance_to_user_idx` (`id_user` ASC) ,
  PRIMARY KEY (`id_user`, `id_artifact`) ,
  CONSTRAINT `fk_practiceinstance_to_user`
    FOREIGN KEY (`id_user` )
    REFERENCES `rulefree`.`user` (`id_user` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`organization_student`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`organization_student` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`organization_student` (
  `id_organization` BIGINT NOT NULL ,
  `id_student` BIGINT NOT NULL ,
  INDEX `fk_organization_student_to_student_idx` (`id_student` ASC) ,
  INDEX `fk_organization_student_to_organization_idx` (`id_organization` ASC) ,
  PRIMARY KEY (`id_organization`, `id_student`) ,
  CONSTRAINT `fk_organization_student_to_student`
    FOREIGN KEY (`id_student` )
    REFERENCES `rulefree`.`user` (`id_user` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_organization_student_to_organization`
    FOREIGN KEY (`id_organization` )
    REFERENCES `rulefree`.`organization` (`id_organization` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


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


-- -----------------------------------------------------
-- Table `rulefree`.`channel_redumption_code_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`channel_redumption_code_type` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`channel_redumption_code_type` (
  `id_channel_redumption_code_type` INT NOT NULL ,
  `channel_redumption_code_type_description` VARCHAR(200) NULL ,
  `id_channel` BIGINT NOT NULL ,
  `retail_price` INT NOT NULL DEFAULT 0 COMMENT 'List Price for the code (in rupees)\n' ,
  `code_validity_start_date` TIMESTAMP NULL ,
  `code_validity_end_date` TIMESTAMP NULL ,
  `subscription_duration_days` INT NULL ,
  PRIMARY KEY (`id_channel_redumption_code_type`) ,
  INDEX `fk_crctype_to_channel_idx` (`id_channel` ASC) ,
  CONSTRAINT `fk_crctype_to_channel`
    FOREIGN KEY (`id_channel` )
    REFERENCES `rulefree`.`system` (`id_system` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`channel_redumption_code`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`channel_redumption_code` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`channel_redumption_code` (
  `channel_redumption_code` VARCHAR(25) NOT NULL ,
  `id_channel_redumption_code_type` INT NOT NULL ,
  `crc_type_sequence` INT NOT NULL ,
  `sale_price` INT NOT NULL DEFAULT 0 COMMENT 'actual price it was sold for\n' ,
  `purchaser` VARCHAR(200) NULL ,
  `redeemed` INT NOT NULL DEFAULT 0 COMMENT '0 = yet to complete redumption\n1 = already redeemed\n' ,
  `redumption_date` TIMESTAMP NULL ,
  `subscriber_username` VARCHAR(50) NULL ,
  `expired` INT NOT NULL DEFAULT 0 ,
  `subscription_start_date` TIMESTAMP NULL ,
  `subscription_end_date` TIMESTAMP NULL ,
  `channel_redumption_codecol` VARCHAR(45) NULL ,
  PRIMARY KEY (`channel_redumption_code`, `id_channel_redumption_code_type`) ,
  INDEX `fk_crc_crctype_idx` (`id_channel_redumption_code_type` ASC) ,
  CONSTRAINT `fk_crc_crctype`
    FOREIGN KEY (`id_channel_redumption_code_type` )
    REFERENCES `rulefree`.`channel_redumption_code_type` (`id_channel_redumption_code_type` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`channel_admin`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`channel_admin` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`channel_admin` (
  `id_channel` BIGINT NOT NULL ,
  `id_provider` BIGINT NOT NULL ,
  `upload_content` TINYINT NULL DEFAULT 0 ,
  PRIMARY KEY (`id_channel`, `id_provider`) ,
  INDEX `fk_channel_admin_to_channel_idx` (`id_channel` ASC) ,
  INDEX `fk_channel_admin_to_provider_idx` (`id_provider` ASC) ,
  CONSTRAINT `fk_channel_admin_to_channel`
    FOREIGN KEY (`id_channel` )
    REFERENCES `rulefree`.`system` (`id_system` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_channel_admin_to_provider`
    FOREIGN KEY (`id_provider` )
    REFERENCES `rulefree`.`user` (`id_user` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`site_settings`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`site_settings` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`site_settings` (
  `setting_name` VARCHAR(200) NOT NULL ,
  `setting_value` VARCHAR(400) NOT NULL ,
  PRIMARY KEY (`setting_name`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`sequence`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`sequence` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`sequence` (
  `key` VARCHAR(30) NOT NULL ,
  `current` BIGINT NOT NULL ,
  PRIMARY KEY (`key`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`channel_stats`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`channel_stats` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`channel_stats` (
  `id_channel` BIGINT NOT NULL ,
  `total_subscribers` INT NOT NULL DEFAULT 0 ,
  `level_count` INT NOT NULL DEFAULT 0 ,
  `topic_count` INT NOT NULL DEFAULT 0 ,
  `skill_count` INT NOT NULL DEFAULT 0 ,
  `comprehensive_test_count` INT NOT NULL DEFAULT 0 ,
  `subject_test_count` INT NOT NULL DEFAULT 0 ,
  `level_test_count` INT NOT NULL DEFAULT 0 ,
  `topic_test_count` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`id_channel`) ,
  INDEX `fk_channel_admin_to_channel_idx` (`id_channel` ASC) ,
  CONSTRAINT `fk_channel_stats_to_channel`
    FOREIGN KEY (`id_channel` )
    REFERENCES `rulefree`.`system` (`id_system` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`channeltrack`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`channeltrack` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`channeltrack` (
  `channeltrack` VARCHAR(45) NOT NULL ,
  `channeltrack_description` VARCHAR(200) NOT NULL ,
  `display_seq` INT NOT NULL AUTO_INCREMENT ,
  PRIMARY KEY (`channeltrack`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`channel_channeltrack`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`channel_channeltrack` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`channel_channeltrack` (
  `id_channel` BIGINT NOT NULL ,
  `channeltrack` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`id_channel`, `channeltrack`) ,
  INDEX `fk_channeltrack_to_channel_idx` (`id_channel` ASC) ,
  INDEX `fk_channelchanneltrack_to_channeltrack_idx` (`channeltrack` ASC) ,
  CONSTRAINT `fk_channelchanneltrack_to_channel`
    FOREIGN KEY (`id_channel` )
    REFERENCES `rulefree`.`system` (`id_system` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_channelchanneltrack_to_channeltrack`
    FOREIGN KEY (`channeltrack` )
    REFERENCES `rulefree`.`channeltrack` (`channeltrack` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`sequence_channel_redumption_code`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`sequence_channel_redumption_code` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`sequence_channel_redumption_code` (
  `id_channel_redumption_code_type` INT NOT NULL ,
  `create_current` INT NOT NULL DEFAULT 0 ,
  `assign_current` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`id_channel_redumption_code_type`) ,
  CONSTRAINT `fk_sequence_crctype_to_crctype`
    FOREIGN KEY (`id_channel_redumption_code_type` )
    REFERENCES `rulefree`.`channel_redumption_code_type` (`id_channel_redumption_code_type` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`synopsis_link`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`synopsis_link` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`synopsis_link` (
  `id_core_artifact` BIGINT NOT NULL ,
  `core_artifact_type` VARCHAR(30) NOT NULL ,
  `synopsis_link` VARCHAR(400) NULL ,
  `synopsis_link_more` VARCHAR(1000) NULL ,
  `synopsis_video_link` VARCHAR(400) NULL ,
  `synopsis_video_link_more` VARCHAR(1000) NULL ,
  PRIMARY KEY (`id_core_artifact`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`channel_examtrack`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`channel_examtrack` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`channel_examtrack` (
  `id_channel` BIGINT NOT NULL ,
  `examtrack` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`id_channel`, `examtrack`) ,
  INDEX `fk_channel_examtrack_2_channel_idx` (`id_channel` ASC) ,
  INDEX `fk_channel_examtrack_2_examtrack_idx` (`examtrack` ASC) ,
  CONSTRAINT `fk_channel_examtrack_2_channel`
    FOREIGN KEY (`id_channel` )
    REFERENCES `rulefree`.`system` (`id_system` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_channel_examtrack_2_examtrack`
    FOREIGN KEY (`examtrack` )
    REFERENCES `rulefree`.`examtrack` (`examtrack` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


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


-- -----------------------------------------------------
-- Table `rulefree`.`eventlog`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`eventlog` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`eventlog` (
  `id` BIGINT NOT NULL AUTO_INCREMENT ,
  `event_type` VARCHAR(45) NOT NULL ,
  `msg` MEDIUMTEXT NOT NULL ,
  `date_time` DATETIME NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`printsettings`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`printsettings` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`printsettings` (
  `id_test` BIGINT NOT NULL ,
  `settings` MEDIUMTEXT NOT NULL ,
  `date_saved` TIMESTAMP NOT NULL ,
  PRIMARY KEY (`id_test`) ,
  CONSTRAINT `fk_printsettings_to_test`
    FOREIGN KEY (`id_test` )
    REFERENCES `rulefree`.`test` (`id_test` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`printsectionsettings`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`printsectionsettings` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`printsectionsettings` (
  `id_section` BIGINT NOT NULL ,
  `settings` MEDIUMTEXT NOT NULL ,
  `date_saved` TIMESTAMP NOT NULL ,
  PRIMARY KEY (`id_section`) ,
  CONSTRAINT `fk_printsectionsettings_to_section`
    FOREIGN KEY (`id_section` )
    REFERENCES `rulefree`.`section` (`id_section` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rulefree`.`channel_level_subscriptions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`channel_level_subscriptions` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`channel_level_subscriptions` (
  `id_level` BIGINT NOT NULL ,
  `id_student` BIGINT NOT NULL ,
  `id_channel` BIGINT NOT NULL ,
  `start_date` DATE NOT NULL ,
  `end_date` DATE NOT NULL ,
  PRIMARY KEY (`id_level`, `id_student`) ,
  INDEX `fk_channel_level_subscriptions_to_level_idx` (`id_level` ASC) ,
  INDEX `fk_channel_level_subscriptions_to_student_idx` (`id_student` ASC) ,
  CONSTRAINT `fk_channel_level_subscriptions_to_level`
    FOREIGN KEY (`id_level` )
    REFERENCES `rulefree`.`level` (`id_level` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_channel_level_subscriptions_to_student`
    FOREIGN KEY (`id_student` )
    REFERENCES `rulefree`.`user` (`id_user` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


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
  `message_priority` TINYINT NULL DEFAULT 5 COMMENT 'message_priority tells us how important a message is.  Higher numbers indicate greater priority. Normal priority is 5.  ' ,
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

-- -----------------------------------------------------
-- Placeholder table for view `rulefree`.`vw_gradeleveldetail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rulefree`.`vw_gradeleveldetail` (`id_system` INT, `id_gradelevel` INT, `grade_name` INT, `level_subject` INT, `id_level` INT, `level_name` INT, `level_description` INT, `id_topic` INT, `topic_name` INT, `topic_subject` INT, `topic_description` INT, `id_skill` INT, `skill_name` INT, `skill_subject` INT, `skill_description` INT, `id_provider` INT);

-- -----------------------------------------------------
-- Placeholder table for view `rulefree`.`vw_profiletest`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rulefree`.`vw_profiletest` (`profile_name` INT, `profilesegment_name` INT, `profiletest_name` INT, `id_profiletest` INT, `id_profile` INT, `id_profilesegment` INT, `id_test_ref` INT, `name` INT, `description` INT, `seq` INT, `test_provision_day` INT, `test_removal_day` INT, `test_provision_date` INT, `test_removal_date` INT, `initial_active` INT);

-- -----------------------------------------------------
-- Placeholder table for view `rulefree`.`vw_profile`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rulefree`.`vw_profile` (`provider_name` INT, `organization_name` INT, `profile_type_string` INT, `access_level_string` INT, `id_profile` INT, `id_provider` INT, `id_organization` INT, `name` INT, `description` INT, `access_level` INT, `published` INT, `profile_type` INT);

-- -----------------------------------------------------
-- Placeholder table for view `rulefree`.`vw_profilesegment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rulefree`.`vw_profilesegment` (`profile_name` INT, `id_profilesegment` INT, `id_profile` INT, `name` INT, `description` INT, `seq` INT, `profiletest_wrapper` INT);

-- -----------------------------------------------------
-- Placeholder table for view `rulefree`.`vw_userprofile`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rulefree`.`vw_userprofile` (`profile_name` INT, `provider_username` INT, `provider_full_name` INT, `student_username` INT, `student_full_name` INT, `id_userprofile` INT, `id_profile` INT, `id_provider` INT, `id_student` INT, `profile_assignment_date` INT, `profile_start_date` INT);

-- -----------------------------------------------------
-- Placeholder table for view `rulefree`.`vw_userprofiletest`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rulefree`.`vw_userprofiletest` (`profile_name` INT, `test_name` INT, `provider_username` INT, `provider_full_name` INT, `student_username` INT, `student_full_name` INT, `id_userprofile` INT, `id_profiletest` INT, `test_provision_date` INT, `test_removal_date` INT, `active` INT);

-- -----------------------------------------------------
-- Placeholder table for view `rulefree`.`vw_question`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rulefree`.`vw_question` (`system_name` INT, `id_system` INT, `level_name` INT, `id_level` INT, `level_subject` INT, `topic_name` INT, `id_topic` INT, `topic_subject` INT, `skill_name` INT, `id_skill` INT, `section_name` INT, `id_question` INT, `id_section` INT, `name` INT, `description` INT, `text` INT, `addl_info` INT, `text_precontext` INT, `text_postcontext` INT, `banner` INT, `heading` INT, `instructions` INT, `question_type` INT, `multiple_answers` INT, `all_answers` INT, `points` INT, `id_questionset` INT, `reference_skills` INT, `id_reference_topic` INT, `id_reference_level` INT);

-- -----------------------------------------------------
-- Placeholder table for view `rulefree`.`vw_section`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rulefree`.`vw_section` (`system_name` INT, `id_system` INT, `level_name` INT, `id_level` INT, `level_subject` INT, `topic_name` INT, `id_topic` INT, `topic_subject` INT, `skill_name` INT, `id_section` INT, `id_skill` INT, `id_provider` INT, `name` INT, `description` INT, `text` INT, `is_linktext` INT, `linktext_address` INT, `addl_info` INT, `time_to_answer` INT, `auto_generated` INT, `generator_metadata` INT, `question_banner` INT, `question_heading` INT, `question_instructions` INT, `is_external` INT, `section_type` INT, `is_practice` INT);

-- -----------------------------------------------------
-- Placeholder table for view `rulefree`.`vw_skill`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rulefree`.`vw_skill` (`system_name` INT, `id_system` INT, `level_name` INT, `id_level` INT, `level_subject` INT, `topic_name` INT, `topic_subject` INT, `id_skill` INT, `id_topic` INT, `id_provider` INT, `subject` INT, `name` INT, `display_name` INT, `description` INT, `text` INT, `addl_info` INT, `published` INT, `derived_skill` INT, `display_order` INT, `id_skill_reference` INT);

-- -----------------------------------------------------
-- Placeholder table for view `rulefree`.`vw_topic`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rulefree`.`vw_topic` (`system_name` INT, `id_system` INT, `level_name` INT, `level_subject` INT, `id_topic` INT, `id_level` INT, `id_provider` INT, `subject` INT, `name` INT, `display_name` INT, `description` INT, `text` INT, `addl_info` INT, `published` INT, `derived` INT, `display_order` INT, `id_topic_reference` INT);

-- -----------------------------------------------------
-- Placeholder table for view `rulefree`.`vw_level`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rulefree`.`vw_level` (`system_name` INT, `id_level` INT, `id_system` INT, `id_provider` INT, `subject` INT, `subject_header` INT, `name` INT, `display_name` INT, `description` INT, `text` INT, `addl_info` INT, `published` INT, `derived` INT, `id_level_reference` INT, `topiccount` INT, `skillcount` INT);

-- -----------------------------------------------------
-- procedure delete_section
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_section`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_section` (IN idSection BIGINT, OUT status_code INT, OUT status_message VARCHAR(256))
BEGIN

DECLARE exit handler for sqlexception
  BEGIN
	SET status_code = -1;
	SET status_message = "Fail - SQL Error";
  ROLLBACK;
END;

DECLARE exit handler for sqlwarning
 BEGIN
	SET status_code = -1;
	SET status_message = "Fail - SQL Warning";
 ROLLBACK;
END;

START TRANSACTION;
	DELETE from derived_section_question where id_section in (idSection);
	DELETE from answer where id_question in (select id_question from question where id_section in (idSection));
	DELETE from question where id_section in (idSection);
	DELETE from wl_passage where id_wordlist in (idSection);
	DELETE from wl_word where id_wordlist in (idSection);
	DELETE from wl_wordlist where id_wordlist in (idSection);
	DELETE from questionset where id_section in (idSection);
	DELETE from section where id_section in (idSection);
	SET status_code = 0;
	SET status_message = "success";
COMMIT;
END 
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_skill
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_skill`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_skill` (IN idSkill BIGINT)
BEGIN
	DELETE from derived_section_question where id_section in (select id_section from section where id_skill in (idSkill));
	DELETE from answer where id_question in (select id_question from question where id_section in (select id_section from section where id_skill in (idSkill)));
	DELETE from question where id_section in (select id_section from section where id_skill in (idSkill));

	DELETE from wl_passage where id_wordlist in (select id_section from section where id_skill in (idSkill));
	DELETE from wl_word where id_wordlist in (select id_section from section where id_skill in (idSkill));
	DELETE from wl_wordlist where id_wordlist in (select id_section from section where id_skill in (idSkill));

	DELETE from section where id_skill in (idSkill);
	DELETE from gradeskill where id_skill in (idSkill);
	DELETE from skill where id_skill in (idSkill);
END 
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_topic
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_topic`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_topic` (IN idTopic BIGINT)
BEGIN
	DELETE from answer where id_question in (select id_question from question where id_section in (select id_section from section where id_skill in (select id_skill from skill where id_topic in (idTopic))));
	DELETE from question where id_section in (select id_section from section where id_skill in (select id_skill from skill where id_topic in (idTopic)));

	DELETE from wl_passage where id_wordlist in (select id_section from section where id_skill in (select id_skill from skill where id_topic in (idTopic)));
	DELETE from wl_word where id_wordlist in (select id_section from section where id_skill in (select id_skill from skill where id_topic in (idTopic)));
	DELETE from wl_wordlist where id_wordlist in (select id_section from section where id_skill in (select id_skill from skill where id_topic in (idTopic)));

	DELETE from section where id_skill in (select id_skill from skill where id_topic in (idTopic));
	DELETE from gradeskill where id_skill in (select id_skill from skill where id_topic in (idTopic));
	DELETE from skill where id_topic in (idTopic);
	DELETE from topic where id_topic in (idTopic);
END 
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_level
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_level`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_level` (IN idLevel BIGINT)
BEGIN
	DELETE from answer where id_question in (select id_question from question where id_section in (select id_section from section where id_skill in (select id_skill from skill where id_topic in (select id_topic from topic where id_level in (idLevel)))));
	DELETE from question where id_section in (select id_section from section where id_skill in (select id_skill from skill where id_topic in (select id_topic from topic where id_level in (idLevel))));

	DELETE from wl_passage where id_wordlist in (select id_section from section where id_skill in (select id_skill from skill where id_topic in (select id_topic from topic where id_level in (idLevel))));
	DELETE from wl_word where id_wordlist in (select id_section from section where id_skill in (select id_skill from skill where id_topic in (select id_topic from topic where id_level in (idLevel))));
	DELETE from wl_wordlist where id_wordlist in (select id_section from section where id_skill in (select id_skill from skill where id_topic in (select id_topic from topic where id_level in (idLevel))));

	DELETE from section where id_skill in (select id_skill from skill where id_topic in (select id_topic from topic where id_level in (idLevel)));
	DELETE from gradeskill where id_skill in (select id_skill from skill where id_topic in (select id_topic from topic where id_level in (idLevel)));
	DELETE from skill where id_topic in (select id_topic from topic where id_level in (idLevel));
	DELETE from topic where id_level in (idLevel);
	DELETE from `level` where id_level in (idLevel);
END 
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_testsegments_for_test
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_testsegments_for_test`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_testsegments_for_test` (IN idTest BIGINT)
BEGIN
	DELETE from testsection where id_testsegment in (select id_testsegment from testsegment where id_test in (idTest));
	DELETE from testsegment where id_test in (idTest);
END
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_testsegment
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_testsegment`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_testsegment` (IN idTestsegment BIGINT)
BEGIN
	DELETE from testsection where id_testsegment in (idTestsegment);
	DELETE from testsegment where id_testsegment in (idTestsegment);
END
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_testinstance
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_testinstance`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_testinstance` (IN idUsertest BIGINT)
BEGIN
	DELETE FROM testinstance_detail WHERE id_testinstance IN (SELECT id_testinstance FROM testinstance WHERE id_usertest = idUsertest); 
	DELETE FROM testinstance_section WHERE id_testinstance IN (SELECT id_testinstance FROM testinstance WHERE id_usertest = idUsertest); 
	DELETE FROM testinstance WHERE id_usertest = idUsertest; 
END
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_usergroup
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_usergroup`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_usergroup` (IN username VARCHAR(50))
BEGIN
	DELETE from usergroupmember where id_usergroup in (select id_usergroup from usergroup where provider_username in (username));
	DELETE from usergroup where provider_username in (username);
END
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_usertest
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_usertest`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_usertest` (IN idProvider BIGINT)
BEGIN
	DELETE from usertest where id_provider in (idProvider);
END
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_wordlist
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_wordlist`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_wordlist` (IN idWordlist BIGINT)
BEGIN
	DELETE from answer where id_question in (select id_question from question where id_section in (idWordlist));
	DELETE from question where id_section in (idWordlist);
	DELETE from wl_passage where id_wordlist in (idWordlist);
	DELETE from wl_word where id_wordlist in (idWordlist);
	DELETE from wl_wordlist where id_wordlist in (idWordlist);
	DELETE from section where id_section in (idWordlist);
END 
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure write_debug_msg
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`write_debug_msg`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE write_debug_msg(enabled INTEGER, msg VARCHAR(255))
BEGIN
  IF enabled THEN BEGIN
    INSERT INTO logtable (msg, date_time) SELECT msg, sysdate();
  END; END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure create_cword_grade_level_skills_sections
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`create_cword_grade_level_skills_sections`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`create_cword_grade_level_skills_sections` ()
BEGIN

  -- Declare constants
  DECLARE v_MAX_WORD_LIST_SIZE INTEGER DEFAULT 25;
  -- declare variables
  DECLARE v_finished INTEGER DEFAULT 0;
  DECLARE loop_cntr INT DEFAULT 0;
  DECLARE word_cntr INT DEFAULT 0;
  DECLARE v_new_id_skill BIGINT DEFAULT 0;
  DECLARE v_id_topic BIGINT;
  DECLARE v_prev_id_topic BIGINT DEFAULT 0;
  DECLARE v_topic_name varchar(200);
  DECLARE v_grade varchar(10);
  DECLARE v_word_count int;

  -- declare the cursor
  DECLARE cursor1 CURSOR FOR 
    SELECT t.id_topic AS id_topic, t.name AS topic_name, c.rank AS grade, count(c.id_cword) AS word_count
    FROM topic t INNER JOIN skill s on t.id_topic = s.id_topic INNER JOIN cword c on LOCATE (s.addl_info, c.themes) > 0 
    WHERE s.id_topic in (SELECT id_topic FROM topic WHERE id_level = 101308)
	-- AND s.id_topic = 101308001
    GROUP BY t.id_topic, t.name, c.rank
    ORDER BY 1, 3;
    
  -- declare NOT FOUND handler
  DECLARE CONTINUE HANDLER
    FOR NOT FOUND SET v_finished = 1;

  -- truncate the debug table before getting started with the load
  TRUNCATE TABLE logtable;

  SET @enabled = TRUE;
  call write_debug_msg(@enabled, "Starting execution on create_cword_grade_level_sections");

  -- open the cursor
  OPEN cursor1;   


  -- Fetch in a loop
  get_row: LOOP

	SET loop_cntr = loop_cntr + 1;

    FETCH cursor1 INTO v_id_topic, v_topic_name, v_grade, v_word_count;
    IF v_finished = 1 THEN
        LEAVE get_row;
    END IF;
    -- build email list
	call write_debug_msg(@enabled, CONCAT('v_id_topic: ', v_id_topic));

	IF (v_prev_id_topic <> v_id_topic) THEN 
		SET v_prev_id_topic = v_id_topic;
		SET loop_cntr = 1;
		call write_debug_msg(@enabled, CONCAT('NEW v_id_topic: ', v_id_topic));
	ELSE 
		call write_debug_msg(@enabled, CONCAT('SAME OLD v_id_topic: ', v_id_topic));
    END if;


	SET v_new_id_skill = (v_id_topic * 100) + 20 + loop_cntr;

	call write_debug_msg(@enabled, CONCAT('v_new_id_skill: ', v_new_id_skill));

	-- clean up any remnents from a previous run
	-- DELETE FROM `rulefree`.`skill` WHERE id_skill = v_new_id_skill;
	-- DELETE FROM `rulefree`.`gradeskill` WHERE id_skill = v_new_id_skill;
	

	-- add the skill to the skill table
	INSERT INTO `rulefree`.`skill` (`id_skill`,`id_topic`,`id_provider`,`name`, `addl_info`,`published`,`derived_skill`) 
    VALUES (v_new_id_skill, v_id_topic, 0, CONCAT(v_topic_name, ' - ', v_grade), v_topic_name, 1, 1);

	-- add data to the gradeskill table
    IF (v_grade = 'Grade 1-2') THEN
        INSERT INTO `rulefree`.`gradeskill` (`grade_name`, `id_skill`) VALUES ('I', v_new_id_skill);
        INSERT INTO `rulefree`.`gradeskill` (`grade_name`, `id_skill`) VALUES ('II', v_new_id_skill);
    ELSEIF (v_grade = 'Grade 3') THEN
        INSERT INTO `rulefree`.`gradeskill` (`grade_name`, `id_skill`) VALUES ('III', v_new_id_skill);
    ELSEIF (v_grade = 'Grade 4') THEN
        INSERT INTO `rulefree`.`gradeskill` (`grade_name`, `id_skill`) VALUES ('IV', v_new_id_skill);
    ELSEIF (v_grade = 'Grade 5-6') THEN
        INSERT INTO `rulefree`.`gradeskill` (`grade_name`, `id_skill`) VALUES ('V', v_new_id_skill);
        INSERT INTO `rulefree`.`gradeskill` (`grade_name`, `id_skill`) VALUES ('VI', v_new_id_skill);
    ELSEIF (v_grade = 'Grade 7-8') THEN
        INSERT INTO `rulefree`.`gradeskill` (`grade_name`, `id_skill`) VALUES ('VII', v_new_id_skill);
        INSERT INTO `rulefree`.`gradeskill` (`grade_name`, `id_skill`) VALUES ('VIII', v_new_id_skill);
    ELSEIF (v_grade = 'HighSchool') THEN
        INSERT INTO `rulefree`.`gradeskill` (`grade_name`, `id_skill`) VALUES ('VIII', v_new_id_skill);
	ELSE 
		SELECT v_id_topic, 'Something is Wrong';
    END IF;

	
	IF (v_word_count > 0) THEN 
	  BEGIN
		DECLARE v2_finished INTEGER DEFAULT 0;
		DECLARE loop2_cntr INT DEFAULT 0;
		DECLARE loop2_section_cntr INT DEFAULT 0;
		DECLARE v2_new_id_section BIGINT DEFAULT 0;
		DECLARE v2_new_section_name varchar(200);
		DECLARE v2_id_topic BIGINT;
		DECLARE v2_topic_name varchar(200);
		DECLARE v2_id_cword BIGINT;
		DECLARE v2_cword_name varchar(200);
		DECLARE v2_first_cword_name varchar(200);
		DECLARE v2_last_cword_name varchar(200);

		-- declare the cursor
		DECLARE cursor2 CURSOR FOR 
			SELECT t.id_topic AS id_topic, t.name AS topic_name, c.id_cword AS id_word, c.name AS word_name
			FROM topic t INNER JOIN skill s on t.id_topic = s.id_topic INNER JOIN cword c on LOCATE (s.addl_info, c.themes) > 0 
			WHERE s.id_topic = v_id_topic AND 
				  s.id_skill = v_new_id_skill AND
				c.rank = v_grade
			ORDER BY 1, 3 limit 0, 1000;
			
		-- declare NOT FOUND handler
		DECLARE CONTINUE HANDLER
			FOR NOT FOUND SET v2_finished = 1;

		call write_debug_msg(@enabled, CONCAT('Starting execution on inner loop for: ', v_id_topic));

		-- open the cursor
		OPEN cursor2;   


		-- Fetch in a loop
		SET loop2_cntr = 0;
		SET loop2_section_cntr = 1;
		SET v2_new_id_section = v_new_id_skill * 10000 + loop2_section_cntr;

		get_word: LOOP

			SET loop2_cntr = loop2_cntr + 1;

			FETCH cursor2 INTO v2_id_topic, v2_topic_name, v2_id_cword, v2_cword_name;
			IF v2_finished = 1 THEN
				LEAVE get_word;
			END IF;
			-- copy first word name
		    IF (loop2_cntr = 1) THEN
				SET v2_first_cword_name = v2_cword_name;
			END IF;
			
			-- insert cgradeword
			INSERT INTO `rulefree`.`cgradeword` (`id_section`, `id_cword`) VALUES (v2_new_id_section, v2_id_cword);
			-- Limit the section size to v_MAX_WORD_LIST_SIZE words
			IF (loop2_cntr = v_MAX_WORD_LIST_SIZE) THEN
				-- create and insert a new section
				SET v2_last_cword_name = v2_cword_name;
				SET v2_new_section_name = CONCAT('Section ', loop2_section_cntr, ': ', v2_topic_name, ' Topic Words - (', v2_first_cword_name, ' - ', v2_last_cword_name, ')');
				INSERT INTO `rulefree`.`section` (`id_section`,`id_skill`,`id_provider`,`name`,`is_external`,`section_type`)
								VALUES (v2_new_id_section, v_new_id_skill, 0, v2_new_section_name, 1, 'wr');
				-- reset all counters and numbers
				SET loop2_section_cntr = loop2_section_cntr + 1;
				SET v2_new_id_section = v_new_id_skill * 10000 + loop2_section_cntr;
				SET loop2_cntr = 0;
			END IF;

		END LOOP get_word;
		-- insert into Section table if necessary
		IF (loop2_cntr <> 0) THEN
			SET v2_last_cword_name = v2_cword_name;
			SET v2_new_section_name = CONCAT('Section ', loop2_section_cntr, ': ', v2_topic_name, ' Topic Words - (', v2_first_cword_name, ' - ', v2_last_cword_name, ')');
			INSERT INTO `rulefree`.`section` (`id_section`,`id_skill`,`id_provider`,`name`,`is_external`,`section_type`)
									VALUES (v2_new_id_section, v_new_id_skill, 0, v2_new_section_name, 1, 'wr');
		END IF;
		-- close the cursor
		CLOSE cursor2;


		END;
	END IF;
		
    -- SELECT v_word_count;
    -- SET email_list = CONCAT(v_email,";",email_list);
  END LOOP get_row;

  -- close the cursor
  CLOSE cursor1;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure create_cword_subject_sections
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`create_cword_subject_sections`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`create_cword_subject_sections` ()
BEGIN

  -- Declare constants
  DECLARE v_MAX_WORD_LIST_SIZE INTEGER DEFAULT 25;
  -- declare variables
  DECLARE v_finished INTEGER DEFAULT 0;
  DECLARE loop_cntr INT DEFAULT 0;
  DECLARE v_id_skill BIGINT DEFAULT 0;
  DECLARE v_skill_name varchar(200);
  DECLARE v_skill_key varchar(200);
  DECLARE v_word_count int;

  -- declare the cursor
  DECLARE cursor1 CURSOR FOR 
	SELECT s.id_skill AS id_skill, s.name AS skill_name, s.addl_info AS skill_key, count(c.id_cword) AS word_count
	FROM skill s INNER JOIN cword c on LOCATE (s.addl_info, c.themes) > 0 
		INNER JOIN topic t ON s.id_topic = t.id_topic
	WHERE s.derived_skill = 0 AND
		t.id_level = 101308
	GROUP BY id_skill, skill_name, skill_key
	ORDER BY id_skill;
    
  -- declare NOT FOUND handler
  DECLARE CONTINUE HANDLER
    FOR NOT FOUND SET v_finished = 1;

  -- truncate the debug table before getting started with the load
  TRUNCATE TABLE logtable;

  SET @enabled = TRUE;
  call write_debug_msg(@enabled, "Starting execution on create_cword_subject_sections");

  -- open the cursor
  OPEN cursor1;   


  -- Fetch in a loop
  get_row: LOOP

	SET loop_cntr = loop_cntr + 1;

    FETCH cursor1 INTO v_id_skill, v_skill_name, v_skill_key, v_word_count;
    IF v_finished = 1 THEN
        LEAVE get_row;
    END IF;
    -- build email list
	call write_debug_msg(@enabled, CONCAT('v_skill: ', v_id_skill, ', ', v_skill_name));

	IF (v_word_count > 0) THEN 
	  BEGIN
		DECLARE v2_finished INTEGER DEFAULT 0;
		DECLARE loop2_cntr INT DEFAULT 0;
		DECLARE loop2_section_cntr INT DEFAULT 0;
		DECLARE v2_new_id_section BIGINT DEFAULT 0;
		DECLARE v2_new_section_name varchar(100);
		DECLARE v2_new_section_description varchar(200);
		DECLARE v2_id_cword BIGINT;
		DECLARE v2_cword_name varchar(200);

		DECLARE v2_first_cword_name varchar(200);
		DECLARE v2_last_cword_name varchar(200);

		-- declare the cursor
		DECLARE cursor2 CURSOR FOR 
			SELECT c.id_cword AS id_word, c.name AS word_name
			FROM skill s INNER JOIN cword c on LOCATE (s.addl_info, c.themes) > 0 
			WHERE s.id_skill = v_id_skill
			ORDER BY id_word limit 0, 3000;
			
		-- declare NOT FOUND handler
		DECLARE CONTINUE HANDLER
			FOR NOT FOUND SET v2_finished = 1;

		call write_debug_msg(@enabled, CONCAT('Starting execution on inner loop for: ', v_id_skill));

		-- open the cursor
		OPEN cursor2;   


		-- Fetch in a loop
		SET loop2_cntr = 0;
		SET loop2_section_cntr = 1;
		SET v2_new_id_section = v_id_skill * 10000 + loop2_section_cntr;

		get_word: LOOP

			SET loop2_cntr = loop2_cntr + 1;

			FETCH cursor2 INTO v2_id_cword, v2_cword_name;
			IF v2_finished = 1 THEN
				LEAVE get_word;
			END IF;
			-- copy first word name
		    IF (loop2_cntr = 1) THEN
				SET v2_first_cword_name = v2_cword_name;
			END IF;
			
			-- insert cgradeword
			INSERT INTO `rulefree`.`cgradeword` (`id_section`, `id_cword`) VALUES (v2_new_id_section, v2_id_cword);
			-- Limit the section size to v_MAX_WORD_LIST_SIZE words
			IF (loop2_cntr = v_MAX_WORD_LIST_SIZE) THEN
				-- create and insert a new section
				SET v2_last_cword_name = v2_cword_name;
				SET v2_new_section_name = CONCAT('Section ', loop2_section_cntr, ': ', v_skill_key, ' Skill Words - (', v2_first_cword_name, ' - ', v2_last_cword_name, ')');
				SET v2_new_section_description = CONCAT('Section ', loop2_section_cntr, ': ', v_skill_name, ' Skill Words - (', v2_first_cword_name, ' - ', v2_last_cword_name, ')');
				INSERT INTO `rulefree`.`section` (`id_section`,`id_skill`,`id_provider`,`name`,`description`,`is_external`,`section_type`)
								VALUES (v2_new_id_section, v_id_skill, 0, v2_new_section_name, v2_new_section_description, 1, 'wr');
				-- reset all counters and numbers
				SET loop2_section_cntr = loop2_section_cntr + 1;
				SET v2_new_id_section = v_id_skill * 10000 + loop2_section_cntr;
				SET loop2_cntr = 0;
			END IF;

		END LOOP get_word;
		-- insert into Section table if necessary
		IF (loop2_cntr <> 0) THEN
			SET v2_last_cword_name = v2_cword_name;
			SET v2_new_section_name = CONCAT('Section ', loop2_section_cntr, ': ', v_skill_key, ' Skill Words - (', v2_first_cword_name, ' - ', v2_last_cword_name, ')');
			SET v2_new_section_description = CONCAT('Section ', loop2_section_cntr, ': ', v_skill_name, ' Skill Words - (', v2_first_cword_name, ' - ', v2_last_cword_name, ')');
			INSERT INTO `rulefree`.`section` (`id_section`,`id_skill`,`id_provider`,`name`,`description`,`is_external`,`section_type`)
									VALUES (v2_new_id_section, v_id_skill, 0, v2_new_section_name, v2_new_section_description, 1, 'wr');
		END IF;
		-- close the cursor
		CLOSE cursor2;


		END;
	END IF;
		
    -- SELECT v_word_count;
    -- SET email_list = CONCAT(v_email,";",email_list);
  END LOOP get_row;

  -- close the cursor
  CLOSE cursor1;


END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure update_question_point_counts_time_for_test_old
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`update_question_point_counts_time_for_test_old`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`update_question_point_counts_time_for_test_old` (IN v_idTest BIGINT)
BEGIN

	-- Declare Question and Point count variables at a Test Level
	DECLARE v_finished INTEGER DEFAULT 0;

	DECLARE v_test_point_count INT DEFAULT 0;
	DECLARE v_test_question_count INT DEFAULT 0;
	DECLARE v_test_point_count_for_derived_sections INT DEFAULT 0;
	DECLARE v_test_question_count_for_derived_sections INT DEFAULT 0;
	DECLARE v_test_time_in_minutes INT DEFAULT 0;

	-- Declare Question and Point count variables at a Testsegment Level
	DECLARE v_id_testsegment BIGINT DEFAULT 0;
	DECLARE v_testsegment_question_count INT DEFAULT 0;
	DECLARE v_testsegment_point_count INT DEFAULT 0;
	DECLARE v_testsegment_time_in_minutes INT DEFAULT 0;
	
	-- Declare Question and Point count variables at a Testsection Level
	DECLARE v_id_testsection BIGINT DEFAULT 0;
	DECLARE v_testsection_question_count INT DEFAULT 0;
	DECLARE v_testsection_point_count INT DEFAULT 0;
	
	-- declare the testsegment cursor -- note that union is to account for cases where the sections are derived 
	-- note that Union work Sections can be non-derived (have questions of their own) or derived (no questions on their own) but not both
	DECLARE testsegmentCursor CURSOR FOR 
	  SELECT id_testsegment AS id_testsegment, SUM(question_count) AS question_count, SUM(point_count) AS point_count
	  FROM (
			SELECT tg.id_testsegment AS id_testsegment, COUNT(q.id_question) AS question_count, SUM(IFNULL(q.points, 1)) AS point_count
			FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
				INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
				INNER JOIN section s ON ts.id_section_ref = s.id_section 
				INNER JOIN question  q ON q.id_section = s.id_section
			WHERE t.id_test = v_idTest
			GROUP BY 1
		  UNION
			SELECT tg.id_testsegment AS id_testsegment, COUNT(q.id_question) AS question_count, SUM(IFNULL(q.points, 1)) AS point_count
			FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
				INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
				INNER JOIN section s ON ts.id_section_ref = s.id_section 
				INNER JOIN derived_section_question dsq ON dsq.id_section = s.id_section
				INNER JOIN question q ON dsq.id_question = q.id_question
			WHERE t.id_test = v_idTest
			GROUP BY 1
		) AS union_table
	  GROUP BY id_testsegment;	

		
	-- declare the testsection cursor -- note that union is to account for cases where the sections are derived 
	-- note that Union work Sections can be non-derived (have questions of their own) or derived (no questions on their own) but not both
	DECLARE testsectionCursor CURSOR FOR 
		SELECT ts.id_testsection AS id_testsection, COUNT(q.id_question) AS question_count, SUM(IFNULL(q.points, 1)) AS point_count
		FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
			INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
			INNER JOIN section s ON ts.id_section_ref = s.id_section 
			INNER JOIN question  q ON q.id_section = s.id_section
		WHERE t.id_test = v_idTest
		GROUP BY 1	
	  UNION
		SELECT ts.id_testsection AS id_testsection, COUNT(q.id_question) AS question_count, SUM(IFNULL(q.points, 1)) AS point_count
		FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
			INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
			INNER JOIN section s ON ts.id_section_ref = s.id_section 
			INNER JOIN derived_section_question dsq ON dsq.id_section = s.id_section
			INNER JOIN question q ON dsq.id_question = q.id_question
		WHERE t.id_test = v_idTest
		GROUP BY 1;	
	
	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET v_finished = 1;

	-- Update Question Count, Point count and Time in Minutes at a Test Level
	-- Add point and question counts for derived sections also
	SELECT IFNULL(SUM(IFNULL(q.points, 1)), 0) INTO v_test_point_count
	FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
			INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
			INNER JOIN section s ON ts.id_section_ref = s.id_section 
			INNER JOIN question  q ON q.id_section = s.id_section
	WHERE t.id_test = v_idTest;

	SELECT IFNULL(SUM(IFNULL(q.points, 1)), 0) INTO v_test_point_count_for_derived_sections
	FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
			INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
			INNER JOIN section s ON ts.id_section_ref = s.id_section 
			INNER JOIN derived_section_question dsq ON dsq.id_section = s.id_section
			INNER JOIN question q ON dsq.id_question = q.id_question
	WHERE t.id_test = v_idTest;

	SELECT COUNT(q.id_question) INTO v_test_question_count 
	FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
			INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
			INNER JOIN section s ON ts.id_section_ref = s.id_section 
			INNER JOIN question  q ON q.id_section = s.id_section
	WHERE t.id_test = v_idTest;

	SELECT COUNT(q.id_question) INTO v_test_question_count_for_derived_sections 
	FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
			INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
			INNER JOIN section s ON ts.id_section_ref = s.id_section 
			INNER JOIN derived_section_question dsq ON dsq.id_section = s.id_section
			INNER JOIN question q ON dsq.id_question = q.id_question
	WHERE t.id_test = v_idTest;

	SELECT SUM(ts.time_to_answer) INTO v_test_time_in_minutes 
	FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
			INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
	WHERE t.id_test = v_idTest;

	UPDATE test t
	SET question_count = v_test_question_count + v_test_question_count_for_derived_sections, 
		point_count = v_test_point_count + v_test_point_count_for_derived_sections, 
		time_to_answer = v_test_time_in_minutes
	WHERE t.id_test = v_idTest;


	-- Update Question and Point count at a Testsegment Level
	SET v_finished = 0;

	-- open the cursor
	OPEN testsegmentCursor;   

	-- Fetch in a loop
	get_testsegment: LOOP

		FETCH testsegmentCursor INTO v_id_testsegment, v_testsegment_question_count, v_testsegment_point_count;

		IF v_finished = 1 THEN
			LEAVE get_testsegment;
		END IF;

		SELECT SUM(ts.time_to_answer) INTO v_testsegment_time_in_minutes 
		FROM testsection ts 
		WHERE ts.id_testsegment = v_id_testsegment;

		-- update testsegment
		UPDATE testsegment tg
		SET question_count = v_testsegment_question_count, point_count = v_testsegment_point_count, time_to_answer = v_testsegment_time_in_minutes
		WHERE tg.id_testsegment = v_id_testsegment;

	END LOOP get_testsegment;

	-- close the cursor
	CLOSE testsegmentCursor;


	-- Update Question and Point count at a Testsection Level
	SET v_finished = 0;

	-- open the cursor
	OPEN testsectionCursor;   

	-- Fetch in a loop
	get_testsection: LOOP

		FETCH testsectionCursor INTO v_id_testsection, v_testsection_question_count, v_testsection_point_count;

		IF v_finished = 1 THEN
			LEAVE get_testsection;
		END IF;

		-- update testsection
		UPDATE testsection ts
		SET question_count = v_testsection_question_count, point_count = v_testsection_point_count
		WHERE ts.id_testsection = v_id_testsection;

	END LOOP get_testsection;

	-- close the cursor
	CLOSE testsectionCursor;




END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_test_with_usertests
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_test_with_usertests`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_test_with_usertests` (IN idTest BIGINT, OUT status_code INT, OUT status_message VARCHAR(256))
BEGIN

DECLARE exit handler for sqlexception
  BEGIN
    SET status_code = -1;
    SET status_message = "Fail - SQL Error";
  ROLLBACK;
END;

DECLARE exit handler for sqlwarning
 BEGIN
    SET status_code = -1;
    SET status_message = "Fail - SQL Warning";
 ROLLBACK;
END;

START TRANSACTION;
    DELETE FROM testinstance_detail WHERE id_testinstance_detail > 0 AND id_testinstance IN (SELECT id_testinstance FROM testinstance WHERE id_test IN (idTest)); 
    DELETE FROM testinstance_section WHERE id_testinstance_section > 0 AND id_testinstance IN (SELECT id_testinstance FROM testinstance WHERE id_test IN (idTest)); 
    DELETE FROM testinstance WHERE id_testinstance > 0 AND id_test IN (idTest); 
    DELETE FROM usertestresponse WHERE id_usertestresponse > 0 AND id_usertest IN (SELECT id_usertest FROM usertest WHERE id_test IN (idTest)); 
    DELETE FROM usertest WHERE id_usertest > 0 AND id_test in (idTest); 
    DELETE FROM testsynopsislink WHERE id_testsynopsislink > 0 AND id_testsegment in (select id_testsegment from testsegment where id_test in (idTest));
    DELETE from testsection WHERE id_testsection > 0 AND id_testsegment in (select id_testsegment from testsegment where id_test in (idTest));
    DELETE from testsegment WHERE id_testsegment > 0 AND id_test in (idTest);
    DELETE from test where id_test in (idTest); 
    SET status_code = 0;
    SET status_message = "success";
COMMIT;
END 



$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_test
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_test`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_test` (IN idTest BIGINT, OUT status_code INT, OUT status_message VARCHAR(256))
BEGIN

DECLARE exit handler for sqlexception
  BEGIN
    SET status_code = -1;
    SET status_message = "Fail - SQL Error";
  ROLLBACK;
END;

DECLARE exit handler for sqlwarning
 BEGIN
    SET status_code = -1;
    SET status_message = "Fail - SQL Warning";
 ROLLBACK;
END;

START TRANSACTION;
    DELETE FROM testsynopsislink WHERE id_testsynopsislink > 0 AND id_testsegment in (select id_testsegment from testsegment where id_test in (idTest));
    DELETE FROM testsection WHERE id_testsection > 0 AND id_testsegment in (select id_testsegment from testsegment where id_test in (idTest));
    DELETE FROM testsegment WHERE id_testsegment > 0 AND id_test in (idTest);
    DELETE FROM test WHERE id_test in (idTest); 
    SET status_code = 0;
    SET status_message = "success";
COMMIT;
END 
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_derived_section
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_derived_section`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_derived_section` (IN idDerivedSection BIGINT, OUT status_code INT, OUT status_message VARCHAR(256))
BEGIN

DECLARE exit handler for sqlexception
  BEGIN
	SET status_code = -1;
	SET status_message = "Fail - SQL Error";
  ROLLBACK;
END;

DECLARE exit handler for sqlwarning
 BEGIN
	SET status_code = -1;
	SET status_message = "Fail - SQL Warning";
 ROLLBACK;
END;

START TRANSACTION;
	DELETE from derived_section_question where id_section in (idDerivedSection);
	DELETE from section where id_section in (idDerivedSection) AND section.section_type = 'ds';
	SET status_code = 0;
	SET status_message = "success";
COMMIT;
END
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_questions_for_derivedsection
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_questions_for_derivedsection`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_questions_for_derivedsection` (IN idDerivedSection BIGINT)
BEGIN
	DELETE from derived_section_question where id_section in (idDerivedSection);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure activate_usertest_with_redumption
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`activate_usertest_with_redumption`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`activate_usertest_with_redumption` (IN v_idTest BIGINT, IN v_idUser BIGINT, IN v_redumptionCode VARCHAR(16))
BEGIN

	-- insert a record into usertest table
	INSERT INTO `rulefree`.`usertest`(`id_provider`, `id_test`, `id_user`, `test_type`, `user_type`, `name`, `description`, 
										`test_assignment_date`, `test_status`, `active`)
	SELECT 0, v_idTest, v_idUser, t.test_type, 1, t.`name`, t.description, now(), 'assigned', 1
	FROM test t 
	WHERE t.id_test = v_idTest;

	-- update activation code table
	UPDATE redumption_code ac
	SET ac.current_uses = ac.current_uses + 1 
	WHERE ac.redumption_code = v_redumptionCode;


END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure update_attempt_quality_for_testinstance
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`update_attempt_quality_for_testinstance`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`update_attempt_quality_for_testinstance` (IN v_in_idTestinstance BIGINT)
BEGIN
	-- Declare Question and Point count variables at a Test Level
	DECLARE v_finished INTEGER DEFAULT 0;

	-- Declare count variables at a Testinstance Level
	DECLARE v_test_perfect_attempts_count INT DEFAULT 0;
	DECLARE v_test_inefficient_attempts_count INT DEFAULT 0;
	DECLARE v_test_bad_attempts_count INT DEFAULT 0;
	DECLARE v_test_wasted_attempts_count INT DEFAULT 0;
	DECLARE v_test_attempt_quality DECIMAL(3, 2) DEFAULT 0.00;

	-- Declare count variables at a Testinstance_section Level
	DECLARE v_testsection_perfect_attempts_count INT DEFAULT 0;
	DECLARE v_testsection_inefficient_attempts_count INT DEFAULT 0;
	DECLARE v_testsection_bad_attempts_count INT DEFAULT 0;
	DECLARE v_testsection_wasted_attempts_count INT DEFAULT 0;
	DECLARE v_testsection_attempt_quality DECIMAL(3, 2) DEFAULT 0.00;
	
	-- declare the loop section variable
	DECLARE v_id_testinstance_section BIGINT DEFAULT 0;

	-- Declare curson to get the testinstance_sections in a loop
	DECLARE testinstance_section_Cursor CURSOR FOR 
	  SELECT id_testinstance_section AS id_testinstance_section
	  FROM testinstance_section 
	  WHERE id_testinstance = v_in_idTestinstance;

	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET v_finished = 1;

	-- update at a test level
	SELECT count(*) INTO v_test_perfect_attempts_count FROM testinstance_detail ts WHERE id_testinstance = v_in_idTestinstance and attempt_quality = 4; 
	SELECT count(*) INTO v_test_inefficient_attempts_count FROM testinstance_detail ts WHERE id_testinstance = v_in_idTestinstance and attempt_quality = 3; 
	SELECT count(*) INTO v_test_bad_attempts_count FROM testinstance_detail ts WHERE id_testinstance = v_in_idTestinstance and attempt_quality = 2; 
	SELECT count(*) INTO v_test_wasted_attempts_count FROM testinstance_detail ts WHERE id_testinstance = v_in_idTestinstance and attempt_quality = 1; 
	SELECT CONVERT(sum(attempt_quality)/count(*), DECIMAL(3,2)) INTO v_test_attempt_quality FROM testinstance_detail WHERE id_testinstance = v_in_idTestinstance;
	
	-- update testinstance
	UPDATE testinstance ti
	SET perfect_attempts = v_test_perfect_attempts_count,
		inefficient_attempts = v_test_inefficient_attempts_count,
		bad_attempts = v_test_bad_attempts_count, 
		wasted_attempts = v_test_wasted_attempts_count,
		attempt_quality = v_test_attempt_quality
	WHERE ti.id_testinstance = v_in_idTestinstance;
	
	-- now do the same at the testinstance_section level in a cursor loop
	SET v_finished = 0;

	-- open the cursor
	OPEN testinstance_section_Cursor;   

	-- Fetch in a loop
	get_testinstance_section: LOOP

		FETCH testinstance_section_Cursor INTO v_id_testinstance_section;

		IF v_finished = 1 THEN
			LEAVE get_testinstance_section;
		END IF;

		SELECT count(*) INTO v_testsection_perfect_attempts_count FROM testinstance_detail ts WHERE id_testinstance_section = v_id_testinstance_section and attempt_quality = 4; 
		SELECT count(*) INTO v_testsection_inefficient_attempts_count FROM testinstance_detail ts WHERE id_testinstance_section = v_id_testinstance_section and attempt_quality = 3; 
		SELECT count(*) INTO v_testsection_bad_attempts_count FROM testinstance_detail ts WHERE id_testinstance_section = v_id_testinstance_section and attempt_quality = 2; 
		SELECT count(*) INTO v_testsection_wasted_attempts_count FROM testinstance_detail ts WHERE id_testinstance_section = v_id_testinstance_section and attempt_quality = 1; 
		SELECT CONVERT(sum(attempt_quality)/count(*), DECIMAL(3,2)) INTO v_testsection_attempt_quality FROM testinstance_detail WHERE id_testinstance_section = v_id_testinstance_section;

		-- update testinstance_section
		UPDATE testinstance_section tis
		SET perfect_attempts = v_testsection_perfect_attempts_count,
			inefficient_attempts = v_testsection_inefficient_attempts_count,
			bad_attempts = v_testsection_bad_attempts_count, 
			wasted_attempts = v_testsection_wasted_attempts_count,
			attempt_quality = v_testsection_attempt_quality
		WHERE tis.id_testinstance_section = v_id_testinstance_section;

	END LOOP get_testinstance_section;
	
	-- close the cursor
	CLOSE testinstance_section_Cursor;


END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure activate_usertest_for_free
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`activate_usertest_for_free`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`activate_usertest_for_free` (IN v_idTest BIGINT, IN v_idUser BIGINT, OUT v_status TEXT)
BEGIN

	DECLARE v_test_is_free INT DEFAULT 0;
	DECLARE v_test_in_free_period INT DEFAULT 0;
	DECLARE v_user_has_channel_subscription INT DEFAULT 0;

	-- is the test marked free (for turely free tests)
	SELECT IFNULL(t.is_free, 0) INTO v_test_is_free 
		FROM test t WHERE t.id_test = v_idTest; 
	
	-- is the test currently offered for free (for a promotion)
	SELECT IFNULL((ta.date_free_start <= Now() AND ta.date_free_end >= Now()), 0) INTO v_test_in_free_period
		FROM test t LEFT JOIN testalias ta ON t.id_test = ta.id_test WHERE t.id_test = v_idTest; 
	
	-- Does the user have channel subscriptions to the examtract the test belongs to?
	SELECT COUNT(*) > 0 INTO v_user_has_channel_subscription
		FROM system s LEFT JOIN channel_subscriptions cs ON s.id_system = cs.id_channel
				LEFT JOIN channel_examtrack ce ON s.id_system = ce.id_channel
				LEFT JOIN test t ON t.examtrack = ce.examtrack
		WHERE t.id_test = v_idTest AND cs.id_student = v_idUser AND cs.start_date <= NOW() AND cs.end_date >= NOW();


	IF (v_test_is_free = 1 OR (v_test_in_free_period = 1 AND v_user_has_channel_subscription = 1)) THEN
		BEGIN
			-- insert a record into usertest table
			INSERT INTO `rulefree`.`usertest`(`id_provider`, `id_test`, `id_user`, `test_type`, `user_type`, `name`, `description`, 
												`test_assignment_date`, `test_status`, `active`)
			SELECT 0, v_idtest, v_idUser, t.test_type, 1, t.`name`, t.description, now(), 'assigned', 1
			FROM test t 
			WHERE t.id_test = v_idtest;
		END;
	ELSEIF (v_test_in_free_period = 0) THEN
		BEGIN
			SELECT 'Test is not marked free.  Please purchase the test or enter a valid Activation Code.' INTO v_status;
		END;
	ELSEIF (v_user_has_channel_subscription = 0) THEN
		BEGIN
			SELECT 'Test is Free only for Channel Subscribers.  Please Subscribe to the Channel or enter a valid Activation Code.' INTO v_status;
		END;
	ELSE
		BEGIN
			SELECT 'Please purchase the test or enter a valid Activation Code.' INTO v_status;
		END;
	END IF;


END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure update_question_point_counts_time_for_test
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`update_question_point_counts_time_for_test`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`update_question_point_counts_time_for_test` (IN v_idTest BIGINT)
BEGIN

	-- Declare Question and Point count variables at a Test Level
	DECLARE v_finished INTEGER DEFAULT 0;

	DECLARE v_test_point_count INT DEFAULT 0;
	DECLARE v_test_question_count INT DEFAULT 0;
	DECLARE v_test_time_in_minutes INT DEFAULT 0;

	-- Declare Question and Point count variables at a Testsegment Level
	DECLARE v_id_testsegment BIGINT DEFAULT 0;
	DECLARE v_testsegment_question_count INT DEFAULT 0;
	DECLARE v_testsegment_point_count INT DEFAULT 0;
	DECLARE v_testsegment_time_in_minutes INT DEFAULT 0;
	
	-- Declare Question and Point count variables at a Testsection Level
	DECLARE v_id_testsection BIGINT DEFAULT 0;
	DECLARE v_testsection_question_count INT DEFAULT 0;
	
	-- declare the testsection cursor -- note that union is to account for cases where the sections are derived 
	-- note that Union work Sections can be non-derived (have questions of their own) or derived (no questions on their own) but not both
	DECLARE testsectionCursor CURSOR FOR 
		SELECT ts.id_testsection AS id_testsection, COUNT(q.id_question) AS question_count
		FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
			INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
			INNER JOIN section s ON ts.id_section_ref = s.id_section 
			INNER JOIN question  q ON q.id_section = s.id_section
		WHERE t.id_test = v_idTest
		GROUP BY 1	
	  UNION
		SELECT ts.id_testsection AS id_testsection, COUNT(q.id_question) AS question_count
		FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
			INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
			INNER JOIN section s ON ts.id_section_ref = s.id_section 
			INNER JOIN derived_section_question dsq ON dsq.id_section = s.id_section
			INNER JOIN question q ON dsq.id_question = q.id_question
		WHERE t.id_test = v_idTest
		GROUP BY 1;	
	
	-- declare the testsegment cursor 
	DECLARE testsegmentCursor CURSOR FOR 
		SELECT tg.id_testsegment AS id_testsegment, SUM(ts.question_count) AS question_count, SUM(ts.point_count) AS point_count, SUM(ts.time_to_answer) as time_to_answer
		FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
			INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
		WHERE t.id_test = v_idTest
		GROUP BY 1;

		
	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET v_finished = 1;


	-- Update Question and Point count at a Testsection Level
	SET v_finished = 0;
	-- open the cursor
	OPEN testsectionCursor;   
	-- Fetch in a loop
	get_testsection: LOOP
		FETCH testsectionCursor INTO v_id_testsection, v_testsection_question_count;
		IF v_finished = 1 THEN
			LEAVE get_testsection;
		END IF;
		-- update testsection
		UPDATE testsection ts
		SET question_count = v_testsection_question_count, point_count = IFNULL(ts.points_per_question, 1.0) * v_testsection_question_count
		WHERE ts.id_testsection = v_id_testsection;
	END LOOP get_testsection;
	-- close the cursor
	CLOSE testsectionCursor;


	-- Update Question and Point count at a Testsegment Level
	SET v_finished = 0;
	-- open the cursor
	OPEN testsegmentCursor;   
	-- Fetch in a loop
	get_testsegment: LOOP
		FETCH testsegmentCursor INTO v_id_testsegment, v_testsegment_question_count, v_testsegment_point_count, v_testsegment_time_in_minutes;
		IF v_finished = 1 THEN
			LEAVE get_testsegment;
		END IF;
		-- update testsegment
		UPDATE testsegment tg
		SET question_count = v_testsegment_question_count, point_count = v_testsegment_point_count, time_to_answer = v_testsegment_time_in_minutes
		WHERE tg.id_testsegment = v_id_testsegment;
	END LOOP get_testsegment;
	-- close the cursor
	CLOSE testsegmentCursor;


	-- Update Question Count, Point count and Time in Minutes at a Test Level
	SELECT SUM(ts.time_to_answer) INTO v_test_time_in_minutes
	FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
			INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
	WHERE t.id_test = v_idTest;

	SELECT SUM(ts.question_count) INTO v_test_question_count
	FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
			INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
	WHERE t.id_test = v_idTest;

	SELECT SUM(ts.point_count) INTO v_test_point_count
	FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
			INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
	WHERE t.id_test = v_idTest;

	UPDATE test t
	SET question_count = v_test_question_count, point_count = v_test_point_count, time_to_answer = v_test_time_in_minutes
	WHERE t.id_test = v_idTest;


END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_system
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_system`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_system` (IN idSystem BIGINT)
BEGIN
DELETE from answer where id_question in (
	select id_question from question where id_section in (
		select id_section from section where id_skill in (
			select id_skill from skill where id_topic in (
				select id_topic from topic where id_level in (
					select id_level from level where id_system in (idSystem))))));

DELETE from question where id_section in (
	select id_section from section where id_skill in (
		select id_skill from skill where id_topic in (
			select id_topic from topic where id_level in (
				select id_level from level where id_system in (idSystem)))));

DELETE from wl_passage where id_wordlist in (
	select id_section from section where id_skill in (
		select id_skill from skill where id_topic in (
			select id_topic from topic where id_level in (
				select id_level from level where id_system in (idSystem)))));
DELETE from wl_word where id_wordlist in (
	select id_section from section where id_skill in (
		select id_skill from skill where id_topic in (
			select id_topic from topic where id_level in (
				select id_level from level where id_system in (idSystem)))));
DELETE from wl_wordlist where id_wordlist in (
	select id_section from section where id_skill in (
		select id_skill from skill where id_topic in (
			select id_topic from topic where id_level in (
				select id_level from level where id_system in (idSystem)))));

DELETE from section where id_skill in (
	select id_skill from skill where id_topic in (
		select id_topic from topic where id_level in (
			select id_level from level where id_system in (idSystem))));
DELETE from gradeskill where id_skill in (
	select id_skill from skill where id_topic in (
		select id_topic from topic where id_level in (
			select id_level from level where id_system in (idSystem))));
DELETE from skill where id_topic in (
	select id_topic from topic where id_level in (
		select id_level from level where id_system in (idSystem)));
DELETE from topic where id_level in (
	select id_level from level where id_system in (idSystem));

DELETE from `level` where id_system in (idSystem);

END 
$$

DELIMITER ;

-- -----------------------------------------------------
-- function get_new_test_id
-- -----------------------------------------------------

USE `rulefree`;
DROP function IF EXISTS `rulefree`.`get_new_test_id`;

DELIMITER $$
USE `rulefree`$$
CREATE FUNCTION get_new_test_id()
  RETURNS BIGINT
BEGIN
	DECLARE new_id_test BIGINT;
	UPDATE `rulefree`.`sequence` SET `current` = last_insert_id(`current`+1) WHERE `key`='test';
	SELECT last_insert_id() INTO new_id_test;
	RETURN new_id_test;
END;
$$

DELIMITER ;

-- -----------------------------------------------------
-- function get_new_testsegment_id
-- -----------------------------------------------------

USE `rulefree`;
DROP function IF EXISTS `rulefree`.`get_new_testsegment_id`;

DELIMITER $$
USE `rulefree`$$
CREATE FUNCTION get_new_testsegment_id()
  RETURNS BIGINT
BEGIN
	DECLARE new_id_testsegment BIGINT;
	UPDATE `rulefree`.`sequence` SET `current` = last_insert_id(`current`+1) WHERE `key`='testsegment';
	SELECT last_insert_id() INTO new_id_testsegment;
	RETURN new_id_testsegment;
END;
$$

DELIMITER ;

-- -----------------------------------------------------
-- function get_new_testsection_id
-- -----------------------------------------------------

USE `rulefree`;
DROP function IF EXISTS `rulefree`.`get_new_testsection_id`;

DELIMITER $$
USE `rulefree`$$
CREATE FUNCTION get_new_testsection_id()
  RETURNS BIGINT
BEGIN
	DECLARE new_id_testsection BIGINT;
	UPDATE `rulefree`.`sequence` SET `current` = last_insert_id(`current`+1) WHERE `key`='testsection';
	SELECT last_insert_id() INTO new_id_testsection;
	RETURN new_id_testsection;
END;
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure change_test_id
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`change_test_id`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`change_test_id` (IN v_idTestOld BIGINT, IN v_idTestNew BIGINT, OUT status_code INT, OUT status_message VARCHAR(256))
main_procedure: BEGIN

	DECLARE v_old_test_count INT DEFAULT 0;
	DECLARE v_idTestsegmentOld BIGINT DEFAULT 0;
	DECLARE v_idTestsegmentNew BIGINT DEFAULT 0;
	DECLARE v_idTestsectionOld BIGINT DEFAULT 0;
	DECLARE v_idTestsectionNew BIGINT DEFAULT 0;
	DECLARE tg_loop_cntr INT DEFAULT 0;
	DECLARE ts_loop_cntr INT DEFAULT 0;

	DECLARE v_segment_finished INT DEFAULT FALSE;

	-- declare the testsegment cursor
	DECLARE cursor_testsegment CURSOR FOR 
		SELECT tg.id_testsegment AS id_testsegment
		FROM testsegment tg 
		WHERE tg.id_test = v_idTestOld
		ORDER BY 1;
    
    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET v_segment_finished = TRUE;

	DECLARE exit handler for sqlexception
		BEGIN
			SET status_code = -1;
			SET status_message = "Fail - SQL Error";
			ROLLBACK;
		END;

	DECLARE exit handler for sqlwarning
		BEGIN
			SET status_code = -1;
			SET status_message = "Fail - SQL Warning";
			ROLLBACK;
		END;

	-- truncate the debug table before getting started with the load
	TRUNCATE TABLE logtable;

	SET @enabled = TRUE;
	call write_debug_msg(@enabled, CONCAT('Starting execution on change_test_id. ', v_idTestOld, ' to ', v_idTestNew));

    -- See if a test exists with the old testid
    SELECT COUNT(*) INTO v_old_test_count 
    FROM test t 
    WHERE id_test = v_idTestOld;
    
    IF (v_old_test_count = 0) THEN 
        SET status_code = -1;
        SET status_message = CONCAT('Test Missing: ', v_idTestOld);
        call write_debug_msg(@enabled, status_message);
        LEAVE main_procedure;
    ELSE 
        call write_debug_msg(@enabled, CONCAT('Test Found.  Will Change it... ', v_idTestOld));
    END if;


	START TRANSACTION;

	-- open the cursor
	OPEN cursor_testsegment;   

	-- initialize loop variables
	SET tg_loop_cntr = 0;
	  
	-- Fetch in a loop
	get_testsegment: LOOP

		SET tg_loop_cntr = tg_loop_cntr + 1;

		FETCH cursor_testsegment INTO v_idTestsegmentOld;
		IF v_segment_finished THEN
			LEAVE get_testsegment;
		END IF;

		-- create the new id_testsegment
		SET v_idTestsegmentNew = v_idTestNew * 100 + tg_loop_cntr;
		call write_debug_msg(@enabled, CONCAT('Change Old v_idTestsegmentOld. ', v_idTestsegmentOld, ' to New v_idTestsegmentNew ', v_idTestsegmentNew));
		

		BLOCK2: BEGIN
			DECLARE v_section_finished INT DEFAULT FALSE;
			-- declare the testsection cursor
			DECLARE cursor_testsection CURSOR FOR 
				SELECT ts.id_testsection AS id_testsection
				FROM testsection ts 
				WHERE ts.id_testsegment = v_idTestsegmentOld
				ORDER BY 1;
		
			-- declare NOT FOUND handler
			DECLARE CONTINUE HANDLER
				FOR NOT FOUND SET v_section_finished = TRUE;

			-- open the cursor
			OPEN cursor_testsection;   

			-- initialize loop variables
			SET ts_loop_cntr = 0;

			-- Fetch in a loop
			get_testsection: LOOP

				SET ts_loop_cntr = ts_loop_cntr + 1;

				FETCH cursor_testsection INTO v_idTestsectionOld;
				IF v_section_finished THEN
					LEAVE get_testsection;
				END IF;

				SET v_idTestsectionNew = v_idTestsegmentNew * 100 + ts_loop_cntr;
				call write_debug_msg(@enabled, CONCAT('Change Old v_idTestsectionOld. ', v_idTestsectionOld, ' to New v_idTestsectionNew ', v_idTestsectionNew));

				-- Update idTestsection statement.  
				UPDATE testsection SET id_testsection = v_idTestsectionNew
				WHERE id_testsection = v_idTestsectionOld;

				call write_debug_msg(@enabled, CONCAT('Update Section Successful. to New v_idTestsectionNew ', v_idTestsectionNew));

			END LOOP get_testsection;
		END BLOCK2;
			
		-- now update the testsegment
		-- Update idTestsegment statement.  
		UPDATE testsegment SET id_testsegment = v_idTestsegmentNew
		WHERE id_testsegment = v_idTestsegmentOld;

		call write_debug_msg(@enabled, CONCAT('Update Segment Successful. to New v_idTestsegmentNew ', v_idTestsegmentNew));

	END LOOP get_testsegment;
			
	-- Update idTest statement.  This should also set the new Id on the testsegment due to FK being cascade on update
	UPDATE test SET id_test = v_idTestNew
	WHERE id_test = v_idTestOld;

	call write_debug_msg(@enabled, CONCAT('Update Test Successful. to New v_idTestNew ', v_idTestNew));

	COMMIT;

	SET status_code = 0;
	SET status_message = "Success!";

END main_procedure;

$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure update_topic_skill_counts
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`update_topic_skill_counts`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`update_topic_skill_counts` ()
BEGIN

    -- Declare Question and Point count variables at a Test Level
    DECLARE v_finished INTEGER DEFAULT 0;

    DECLARE v_id_level BIGINT DEFAULT 0;
    DECLARE v_topiccount INT DEFAULT 0;
    DECLARE v_skillcount INT DEFAULT 0;

    -- declare the testsegment cursor 
/*	This does not calculate skill_counts when a topic is referred...
		DECLARE levelWithCountsCursor CURSOR FOR 
		SELECT l.id_level, 
				count(distinct t.id_topic) AS topiccount, 
				count(distinct s.id_skill) AS skillcount 
		FROM level l LEFT JOIN topic t on t.id_level = l.id_level LEFT JOIN skill s ON s.id_topic = t.id_topic
		GROUP BY l.id_level;
*/
-- Include counts from referred topics 
    DECLARE levelWithCountsCursor CURSOR FOR 
		SELECT l.id_level, 
				count(distinct t.id_topic) AS topiccount, 
				count(distinct s.id_skill)  + count(distinct s2.id_skill) AS skillcount 
		FROM level l LEFT JOIN topic t on t.id_level = l.id_level 
					LEFT JOIN skill s ON s.id_topic = t.id_topic
					LEFT JOIN skill s2 ON s2.id_topic = t.id_topic_reference
		GROUP BY l.id_level;

    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET v_finished = 1;

    -- Update skill and topic counts for each level
    SET v_finished = 0;
    -- open the cursor
    OPEN levelWithCountsCursor;   
    -- Fetch in a loop
    get_level: LOOP
        FETCH levelWithCountsCursor INTO v_id_level, v_topiccount, v_skillcount;
        IF v_finished = 1 THEN
            LEAVE get_level;
        END IF;
        -- update testsection
        UPDATE level l
        SET l.topiccount = v_topiccount, l.skillcount = v_skillcount
        WHERE l.id_level = v_id_level;

    END LOOP get_level;
    -- close the cursor
    CLOSE levelWithCountsCursor;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- function get_new_crc_create_sequence
-- -----------------------------------------------------

USE `rulefree`;
DROP function IF EXISTS `rulefree`.`get_new_crc_create_sequence`;

DELIMITER $$
USE `rulefree`$$
CREATE FUNCTION get_new_crc_create_sequence(id_crc_type INT)
  RETURNS INT
BEGIN
	DECLARE new_crc_create_sequence INT;
	UPDATE `rulefree`.`sequence_channel_redumption_code` SET `create_current` = last_insert_id(`create_current`+1) WHERE `id_channel_redumption_code_type`= id_crc_type;
	SELECT last_insert_id() INTO new_crc_create_sequence;
	RETURN new_crc_create_sequence;
END;
$$

DELIMITER ;

-- -----------------------------------------------------
-- function get_new_crc_assign_sequence
-- -----------------------------------------------------

USE `rulefree`;
DROP function IF EXISTS `rulefree`.`get_new_crc_assign_sequence`;

DELIMITER $$
USE `rulefree`$$
CREATE FUNCTION get_new_crc_assign_sequence(id_crc_type INT)
  RETURNS INT
BEGIN
	DECLARE new_crc_assign_sequence INT;
	UPDATE `rulefree`.`sequence_channel_redumption_code` SET `assign_current` = last_insert_id(`assign_current`+1) WHERE `id_channel_redumption_code_type`= id_crc_type;
	SELECT last_insert_id() INTO new_crc_assign_sequence;
	RETURN new_crc_assign_sequence;
END;
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_profile
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_profile`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_profile` (IN idProfile BIGINT, OUT status_code INT, OUT status_message VARCHAR(256))
BEGIN

DECLARE exit handler for sqlexception
  BEGIN
    SET status_code = -1;
    SET status_message = "Fail - SQL Error";
  ROLLBACK;
END;

DECLARE exit handler for sqlwarning
 BEGIN
    SET status_code = -1;
    SET status_message = "Fail - SQL Warning";
 ROLLBACK;
END;

START TRANSACTION;
    DELETE FROM profiletest WHERE id_profiletest > 0 AND id_profilesegment in (select id_profilesegment from profilesegment where id_profile in (idProfile));
    DELETE FROM profilesegment WHERE id_profilesegment > 0 AND id_profile in (idProfile);
    DELETE FROM `profile` WHERE id_profile in (idProfile); 
    SET status_code = 0;
    SET status_message = "success";
COMMIT;
END 
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_profilesegments_for_profile
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_profilesegments_for_profile`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_profilesegments_for_profile` (IN idProfile BIGINT, OUT status_code INT, OUT status_message VARCHAR(256))
BEGIN

DECLARE exit handler for sqlexception
  BEGIN
    SET status_code = -1;
    SET status_message = "Fail - SQL Error";
  ROLLBACK;
END;

DECLARE exit handler for sqlwarning
 BEGIN
    SET status_code = -1;
    SET status_message = "Fail - SQL Warning";
 ROLLBACK;
END;

START TRANSACTION;
    DELETE FROM profiletest WHERE id_profiletest > 0 AND id_profilesegment in (select id_profilesegment from profilesegment where id_profile in (idProfile));
    DELETE FROM profilesegment WHERE id_profilesegment > 0 AND id_profile in (idProfile);
    SET status_code = 0;
    SET status_message = "success";
COMMIT;
END 
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure update_user_profile_test
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`update_user_profile_test`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`update_user_profile_test` (IN in_idUserprofile BIGINT, IN in_action INT, OUT out_status_code INT, OUT out_status_message VARCHAR(256))
BEGIN

DECLARE exit handler for sqlexception
  BEGIN
    SET out_status_code = -1;
    SET out_status_message = "Fail - SQL Error";
  ROLLBACK;
END;

DECLARE exit handler for sqlwarning
 BEGIN
    SET out_status_code = -1;
    SET out_status_message = "Fail - SQL Warning";
 ROLLBACK;
END;


START TRANSACTION;
-- 1= insert, 2 = delete, 3 = update
IF (in_action = 1) THEN

    INSERT INTO `userprofiletest` (`id_userprofile`, `id_profiletest`, `test_provision_date`, `test_removal_date`, `active`) 
    SELECT      up.id_userprofile, 
                pt.id_profiletest, 
                (CASE 
                   WHEN p.profile_type = 1 THEN pt.test_provision_date
                   WHEN p.profile_type = 2 THEN ADDDATE(up.profile_start_date, INTERVAL pt.test_provision_day DAY)
                   ELSE up.profile_start_date
                 END) AS test_provision_date, 
                (CASE 
                   WHEN p.profile_type = 1 THEN pt.test_removal_date
                   WHEN p.profile_type = 2 THEN ADDDATE(up.profile_start_date, INTERVAL pt.test_removal_day DAY)
                   ELSE null
                 END) AS test_removal_date,
                (CASE 
                   WHEN p.profile_type = 1 THEN 1
                   WHEN p.profile_type = 2 THEN 1 
                   ELSE pt.initial_active
                 END) AS active
    FROM userprofile up LEFT JOIN profile p ON p.id_profile = up.id_profile
                LEFT JOIN profilesegment ps ON ps.id_profile = up.id_profile
                LEFT JOIN profiletest pt ON pt.id_profilesegment = ps.id_profilesegment
     WHERE up.id_userprofile = in_idUserprofile;

ELSEIF (in_action = 2) THEN

    DELETE FROM `userprofiletest` 
    WHERE id_userprofiletest > 0 AND 
          id_userprofile = in_idUserprofile;

ELSEIF (in_action = 3) THEN

    UPDATE userprofiletest upt LEFT JOIN profiletest pt ON upt.id_profiletest = pt.id_profiletest
							 LEFT JOIN profilesegment ps ON pt.id_profilesegment = ps.id_profilesegment
							 LEFT JOIN profile p ON ps.id_profile = p.id_profile
							 LEFT JOIN userprofile up ON upt.id_userprofile =  up.id_userprofile
    SET     upt.test_provision_date = 
                (CASE 
                    WHEN p.profile_type = 1 THEN pt.test_provision_date
                    WHEN p.profile_type = 2 THEN ADDDATE(up.profile_start_date, INTERVAL pt.test_provision_day DAY)
                    ELSE up.profile_start_date
                 END),
            upt.test_removal_date = 
                (CASE
                    WHEN p.profile_type = 1 THEN pt.test_removal_date
                    WHEN p.profile_type = 2 THEN ADDDATE(up.profile_start_date, INTERVAL pt.test_removal_day DAY)
                    ELSE null
                END),
            upt.active = 
                (CASE 
                   WHEN p.profile_type = 1 THEN 1
                   WHEN p.profile_type = 2 THEN 1 
                   ELSE pt.initial_active
                 END)
    WHERE up.id_userprofile = in_idUserprofile;

-- ELSE 
    -- nothing to do here
END IF;

SET out_status_code = 0;
SET out_status_message = "success";



COMMIT;
END 

$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure userprofiletest_to_usertest_mover
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`userprofiletest_to_usertest_mover`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`userprofiletest_to_usertest_mover` (OUT v_rows_inserted INT, OUT v_rows_updated INT, OUT v_rows_deleted INT, OUT out_status_code INT, OUT out_status_message VARCHAR(256))
BEGIN

    -- declare variables
    DECLARE v_timestamp TIMESTAMP;

    -- declare cursor variables
    DECLARE v_id_provider BIGINT DEFAULT 0;
    DECLARE v_id_test BIGINT DEFAULT 0;
    DECLARE v_id_user BIGINT DEFAULT 0;
    DECLARE v_id_profile BIGINT DEFAULT 0;
    DECLARE v_test_type varchar(45);
    DECLARE v_user_type INT DEFAULT 1;
    DECLARE v_name varchar(100);
    DECLARE v_description varchar(200);
    DECLARE v_test_assignment_date TIMESTAMP;
    DECLARE v_test_status varchar(45);
    DECLARE v_id_profiletest BIGINT DEFAULT 0;
    DECLARE v_profile_name varchar(100);
    DECLARE v_profilesegment_name varchar(100);

    -- cursor exit variable
    DECLARE v_finished INTEGER DEFAULT 0;
  
    -- Temp variable to see if the row exists
    DECLARE v_exists INT DEFAULT 0;


    -- declare the cursor
    DECLARE cursor1 CURSOR FOR 
        SELECT  up.id_provider AS id_provider, 
                t.id_test AS id_test, 
                up.id_student AS id_user, 
                up.id_profile AS id_profile, 
                t.test_type AS test_type, 
                1 AS user_type, 
                pt.`name` AS `name`, 
                pt.description AS description, 
                upt.test_provision_date AS test_assignment_date, 
                'assigned' AS test_status,
                upt.id_profiletest AS id_profiletest, 
                p.`name` AS profile_name, 
                ps.`name` AS profilesegment_name
        FROM userprofiletest upt LEFT JOIN userprofile up ON upt.id_userprofile = up.id_userprofile
                                 LEFT JOIN profiletest pt ON upt.id_profiletest = pt.id_profiletest
                                 LEFT JOIN profilesegment ps ON pt.id_profilesegment = ps.id_profilesegment
                                 LEFT JOIN profile p ON ps.id_profile = p.id_profile
                                 LEFT JOIN test t ON pt.id_test_ref = t.id_test
        WHERE upt.test_provision_date < v_timestamp AND upt.active = 1;



    -- Error/exception handlers
    DECLARE exit handler for sqlexception
    BEGIN
        ROLLBACK;
        SET out_status_code = -1;
        SET out_status_message = "Fail - SQL Error";
    END;

    DECLARE exit handler for sqlwarning
    BEGIN
        ROLLBACK;
        SET out_status_code = -1;
        SET out_status_message = "Fail - SQL Warning";
    END;


    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET v_finished = 1;

    -- Initialize the return values
    SET v_rows_inserted = 0;
    SET v_rows_updated = 0;
    SET v_rows_deleted = 0;

    -- do everything in a transaction
    START TRANSACTION;

    -- Get the current date
    SELECT ADDDATE(now(), INTERVAL 1 DAY) INTO v_timestamp;


    -- open the cursor
    OPEN cursor1;   


    -- Fetch in a loop
    get_row: LOOP

        FETCH cursor1 INTO  v_id_provider, 
                            v_id_test, 
                            v_id_user, 
                            v_id_profile, 
                            v_test_type, 
                            v_user_type, 
                            v_name, 
                            v_description, 
                            v_test_assignment_date, 
                            v_test_status,
                            v_id_profiletest, 
                            v_profile_name, 
                            v_profilesegment_name;

        IF v_finished = 1 THEN
            LEAVE get_row;
        END IF;

        SELECT COUNT(*) INTO v_exists 
        FROM usertest 
        WHERE id_test = v_id_test AND id_user = v_id_user AND id_profile = v_id_profile;

        IF (v_exists = 0) THEN 
        
        -- if the key values do not exist in the usertest table, then insert them
            INSERT INTO `usertest`(`id_provider`, `id_test`, `id_user`, `id_profile`, `test_type`, `user_type`, `name`, `description`, `test_assignment_date`, `test_status`, `id_profiletest`, `profile_name`, `profilesegment_name`)
            VALUES (
                v_id_provider,
                v_id_test,
                v_id_user,
                v_id_profile,
                v_test_type,
                v_user_type,
                v_name,
                v_description,
                v_test_assignment_date,
                v_test_status,
                v_id_profiletest, 
                v_profile_name, 
                v_profilesegment_name );
            
            SET v_rows_inserted = v_rows_inserted + 1;

        ELSE 
        
        -- if the key values exist in the usertest table, then simply update the values with the new times etc.    
            UPDATE `usertest` 
            SET `id_provider` = v_id_provider,
                `test_type` = v_test_type,
                `name` = v_name,
                `description` = v_description,
                `test_assignment_date` = v_test_assignment_date, 
                `id_profiletest` = v_id_profiletest, 
                `profile_name` = v_profile_name, 
                `profilesegment_name` = v_profilesegment_name
            WHERE id_test = v_id_test AND id_user = v_id_user AND id_profile = v_id_profile;
            
            SET v_rows_updated = v_rows_updated + 1;

        END if;

    END LOOP get_row;
  
    -- close the cursor
    CLOSE cursor1;

    -- Next delete the corresponding userprofiletest records from the userprofiletest table
    DELETE upt 
    FROM `userprofiletest` upt LEFT JOIN userprofile up ON upt.id_userprofile =  up.id_userprofile
                            LEFT JOIN profile p ON p.id_profile = up.id_profile AND p.profile_type IN (1, 2)
    WHERE   upt.test_provision_date < v_timestamp AND upt.active = 1;

    SELECT ROW_COUNT() INTO v_rows_deleted;

    COMMIT;

    -- indicate success status
    SET out_status_code = 0;
    SET out_status_message = "success";

END 

$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure write_eventlog_msg
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`write_eventlog_msg`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.write_eventlog_msg (enabled INTEGER, event_type VARCHAR(45), msg VARCHAR(255))
	BEGIN
		IF enabled THEN 
			BEGIN
				INSERT INTO `rulefree`.`eventlog` (event_type, msg, date_time) SELECT event_type, msg, sysdate();
			END; 
		END IF;
    END 
    $$

DELIMITER ;

-- -----------------------------------------------------
-- procedure change_profile_id
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`change_profile_id`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`change_profile_id` (IN v_idProfileOld BIGINT, IN v_idProfileNew BIGINT, OUT status_code INT, OUT status_message VARCHAR(256))
main_procedure: BEGIN

    DECLARE v_old_profile_count INT DEFAULT 0;
    DECLARE v_idProfilesegmentOld BIGINT DEFAULT 0;
    DECLARE v_idProfilesegmentNew BIGINT DEFAULT 0;
    DECLARE v_idProfiletestOld BIGINT DEFAULT 0;
    DECLARE v_idProfiletestNew BIGINT DEFAULT 0;
    DECLARE pg_loop_cntr INT DEFAULT 0;
    DECLARE pt_loop_cntr INT DEFAULT 0;

    DECLARE v_segment_finished INT DEFAULT FALSE;

    -- declare the profilesegment cursor
    DECLARE cursor_profilesegment CURSOR FOR 
        SELECT pg.id_profilesegment AS id_profilesegment
        FROM profilesegment pg 
        WHERE pg.id_profile = v_idProfileOld
        ORDER BY 1;
    
    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET v_segment_finished = TRUE;

    DECLARE exit handler for sqlexception
        BEGIN
            SET status_code = -1;
            SET status_message = "Fail - SQL Error";
            ROLLBACK;
        END;

    DECLARE exit handler for sqlwarning
        BEGIN
            SET status_code = -1;
            SET status_message = "Fail - SQL Warning";
            ROLLBACK;
        END;

    -- truncate the debug table before getting started with the load
    TRUNCATE TABLE logtable;

    SET @enabled = TRUE;
    call write_debug_msg(@enabled, CONCAT('Starting execution on change_profile_id. ', v_idProfileOld, ' to ', v_idProfileNew));

    -- See if a profile exists with the old profileid
    SELECT COUNT(*) INTO v_old_profile_count 
    FROM profile p 
    WHERE id_profile = v_idProfileOld;
    
    IF (v_old_profile_count = 0) THEN 
        SET status_code = -1;
        SET status_message = CONCAT('Profile Missing: ', v_idProfileOld);
        call write_debug_msg(@enabled, status_message);
        LEAVE main_procedure;
    ELSE 
        call write_debug_msg(@enabled, CONCAT('Profile ', v_idProfileOld, ' Found.  Will Change it... to ', v_idProfileNew));
    END if;


    START TRANSACTION;

    -- open the cursor
    OPEN cursor_profilesegment;   

    -- initialize loop variables
    SET pg_loop_cntr = 0;
      
    -- Fetch in a loop
    get_profilesegment: LOOP

        SET pg_loop_cntr = pg_loop_cntr + 1;

        FETCH cursor_profilesegment INTO v_idProfilesegmentOld;
        IF v_segment_finished THEN
            LEAVE get_profilesegment;
        END IF;

        -- create the new id_profilesegment
        SET v_idProfilesegmentNew = v_idProfileNew * 100 + pg_loop_cntr;
        call write_debug_msg(@enabled, CONCAT('Change Old v_idProfilesegmentOld. ', v_idProfilesegmentOld, ' to New v_idProfilesegmentNew ', v_idProfilesegmentNew));
        

        BLOCK2: BEGIN
            DECLARE v_profiletest_finished INT DEFAULT FALSE;
            -- declare the profiletest cursor
            DECLARE cursor_profiletest CURSOR FOR 
                SELECT pt.id_profiletest AS id_profiletest
                FROM profiletest pt 
                WHERE pt.id_profilesegment = v_idProfilesegmentOld
                ORDER BY 1;
        
            -- declare NOT FOUND handler
            DECLARE CONTINUE HANDLER
                FOR NOT FOUND SET v_profiletest_finished = TRUE;

            -- open the cursor
            OPEN cursor_profiletest;   

            -- initialize loop variables
            SET pt_loop_cntr = 0;

            -- Fetch in a loop
            get_profiletest: LOOP

                SET pt_loop_cntr = pt_loop_cntr + 1;

                FETCH cursor_profiletest INTO v_idProfiletestOld;
                IF v_profiletest_finished THEN
                    LEAVE get_profiletest;
                END IF;

                SET v_idProfiletestNew = v_idProfilesegmentNew * 100 + pt_loop_cntr;
                call write_debug_msg(@enabled, CONCAT('Attempting to Change Profiletest: Old v_idProfiletestOld. ', v_idProfiletestOld, ' to New v_idProfiletestNew ', v_idProfiletestNew));

                -- Update idProfiletest statement.  
                UPDATE profiletest SET id_profiletest = v_idProfiletestNew
                WHERE id_profiletest = v_idProfiletestOld;

                call write_debug_msg(@enabled, CONCAT('Update Profiletest Successful.  Old v_idProfiletestOld. ', v_idProfiletestOld, ' Changed to New v_idProfiletestNew ', v_idProfiletestNew));

            END LOOP get_profiletest;
        END BLOCK2;
            
        -- now update the profilesegment
        -- Update idProfilesegment statement.  
        call write_debug_msg(@enabled, CONCAT('Attempting to Change Profilesegment: Old v_idProfilesegmentOld. ', v_idProfilesegmentOld, ' to New v_idProfilesegmentNew ', v_idProfilesegmentNew));

        UPDATE profilesegment SET id_profilesegment = v_idProfilesegmentNew
        WHERE id_profilesegment = v_idProfilesegmentOld;

        call write_debug_msg(@enabled, CONCAT('Update Profilesegment Successful.  Old v_idProfilesegmentOld. ', v_idProfilesegmentOld, ' Changed to New v_idProfilesegmentNew ', v_idProfilesegmentNew));

    END LOOP get_profilesegment;
            
    -- Update idProfile statement.  This should also set the new Id on the profilesegment due to FK being cascade on update
    call write_debug_msg(@enabled, CONCAT('Attempting to Change Profile: Old v_idProfileOld. ', v_idProfileOld, ' to New v_idProfileNew ', v_idProfileNew));

    UPDATE profile SET id_profile = v_idProfileNew
    WHERE id_profile = v_idProfileOld;

    call write_debug_msg(@enabled, CONCAT('Update Profile Successful.  Old v_idProfileOld. ', v_idProfileOld, ' Changed to New v_idProfileNew ', v_idProfileNew));

    COMMIT;

    SET status_code = 0;
    SET status_message = "Success!";

END main_procedure;

$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure copy_profile
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`copy_profile`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`copy_profile` (IN v_idProfileOld BIGINT, IN v_idProfileNew BIGINT, OUT status_code INT, OUT status_message VARCHAR(256))
main_procedure: BEGIN
    DECLARE v_old_profile_count INT DEFAULT 0;
    DECLARE v_new_profile_count INT DEFAULT 0;
    DECLARE v_idProfilesegmentOld BIGINT DEFAULT 0;
    DECLARE v_idProfilesegmentNew BIGINT DEFAULT 0;
    DECLARE v_idProfiletestOld BIGINT DEFAULT 0;
    DECLARE v_idProfiletestNew BIGINT DEFAULT 0;
    DECLARE pg_loop_cntr INT DEFAULT 0;
    DECLARE pt_loop_cntr INT DEFAULT 0;

    DECLARE v_segment_finished INT DEFAULT FALSE;

    -- declare the profilesegment cursor
    DECLARE cursor_profilesegment CURSOR FOR 
        SELECT pg.id_profilesegment AS id_profilesegment
        FROM profilesegment pg 
        WHERE pg.id_profile = v_idProfileOld
        ORDER BY 1;
    
    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET v_segment_finished = TRUE;

    DECLARE exit handler for sqlexception
        BEGIN
            SET status_code = -1;
            SET status_message = "Fail - SQL Error";
            ROLLBACK;
        END;

    DECLARE exit handler for sqlwarning
        BEGIN
            SET status_code = -1;
            SET status_message = "Fail - SQL Warning";
            ROLLBACK;
        END;

    -- truncate the debug table before getting started with the load
    TRUNCATE TABLE logtable;

    SET @enabled = TRUE;
    call write_debug_msg(@enabled, CONCAT('Starting execution on copy_profile. ', v_idProfileOld, ' to ', v_idProfileNew));

    -- See if the profile exists with the old profileid
    SELECT COUNT(*) INTO v_old_profile_count 
    FROM profile p 
    WHERE id_profile = v_idProfileOld;
    
    IF (v_old_profile_count = 0) THEN 
        SET status_code = -1;
        SET status_message = CONCAT('Profile Missing: ', v_idProfileOld);
        call write_debug_msg(@enabled, status_message);
        LEAVE main_procedure;
    ELSE 
        call write_debug_msg(@enabled, CONCAT('Profile ', v_idProfileOld, ' Found.  Will Copy it to... ', v_idProfileNew));
    END if;


    -- See if the COPY profile ID already exists 
    SELECT COUNT(*) INTO v_new_profile_count 
    FROM profile p 
    WHERE id_profile = v_idProfileNew;
    
    IF (v_new_profile_count > 0) THEN 
        SET status_code = -1;
        SET status_message = CONCAT('Profile already exists with ID: ', v_idProfileNew, '.  Please use a different NEW Profile ID.');
        call write_debug_msg(@enabled, status_message);
        LEAVE main_procedure;
    ELSE 
        call write_debug_msg(@enabled, CONCAT('Profile ', v_idProfileOld, ' Found.  Will Copy it to... ', v_idProfileNew));
    END if;


    START TRANSACTION;

    -- Copy idProfile statement. 
    call write_debug_msg(@enabled, CONCAT('Attempting to Copy Profile: Old v_idProfileOld. ', v_idProfileOld, ' to New v_idProfileNew ', v_idProfileNew));

    INSERT INTO `profile`
        (`id_profile`,
        `id_provider`,
        `id_organization`,
        `name`,
        `description`,
        `access_level`,
        `published`,
        `profile_type`)
    SELECT 
        v_idProfileNew, 
        `id_provider`,
        `id_organization`,
        CONCAT(`name`, '_copy'),
        `description`,
        `access_level`,
        `published`,
        `profile_type`
    FROM `profile`
    WHERE `id_profile` = v_idProfileOld;
    
    call write_debug_msg(@enabled, CONCAT('Copy Profile Successful.  Old v_idProfileOld. ', v_idProfileOld, ' Changed to New v_idProfileNew ', v_idProfileNew));

    -- open the cursor
    OPEN cursor_profilesegment;   

    -- initialize loop variables
    SET pg_loop_cntr = 0;
      
    -- Fetch in a loop
    get_profilesegment: LOOP

        SET pg_loop_cntr = pg_loop_cntr + 1;

        FETCH cursor_profilesegment INTO v_idProfilesegmentOld;
        IF v_segment_finished THEN
            LEAVE get_profilesegment;
        END IF;

        -- create the new id_profilesegment
        SET v_idProfilesegmentNew = v_idProfileNew * 100 + pg_loop_cntr;
        
        -- now insert the new profilesegment
        -- Insert Profilesegment statement.  
        call write_debug_msg(@enabled, CONCAT('Attempting to Copy Profilesegment: Old v_idProfilesegmentOld. ', v_idProfilesegmentOld, ' to New v_idProfilesegmentNew ', v_idProfilesegmentNew));

        INSERT INTO `profilesegment`
            (`id_profilesegment`,
            `id_profile`,
            `name`,
            `description`,
            `seq`,
            `profiletest_wrapper`)
        SELECT 
            v_idProfilesegmentNew,
            v_idProfileNew,
            `name`,
            `description`,
            `seq`,
            `profiletest_wrapper`
        FROM `profilesegment`
        WHERE `id_profilesegment` = v_idProfilesegmentOld;

        call write_debug_msg(@enabled, CONCAT('Copy Profilesegment Successful.  Old v_idProfilesegmentOld. ', v_idProfilesegmentOld, ' Changed to New v_idProfilesegmentNew ', v_idProfilesegmentNew));

        BLOCK2: BEGIN
            DECLARE v_profiletest_finished INT DEFAULT FALSE;
            -- declare the profiletest cursor
            DECLARE cursor_profiletest CURSOR FOR 
                SELECT pt.id_profiletest AS id_profiletest
                FROM profiletest pt 
                WHERE pt.id_profilesegment = v_idProfilesegmentOld
                ORDER BY 1;
        
            -- declare NOT FOUND handler
            DECLARE CONTINUE HANDLER
                FOR NOT FOUND SET v_profiletest_finished = TRUE;

            -- open the cursor
            OPEN cursor_profiletest;   

            -- initialize loop variables
            SET pt_loop_cntr = 0;

            -- Fetch in a loop
            get_profiletest: LOOP

                SET pt_loop_cntr = pt_loop_cntr + 1;

                FETCH cursor_profiletest INTO v_idProfiletestOld;
                IF v_profiletest_finished THEN
                    LEAVE get_profiletest;
                END IF;

                SET v_idProfiletestNew = v_idProfilesegmentNew * 100 + pt_loop_cntr;
                call write_debug_msg(@enabled, CONCAT('Attempting to Copy Profiletest: Old v_idProfiletestOld. ', v_idProfiletestOld, ' to New v_idProfiletestNew ', v_idProfiletestNew));

                -- Insert Profiletest statement.  
                INSERT INTO `profiletest`
                    (`id_profiletest`,
                    `id_profile`,
                    `id_profilesegment`,
                    `id_test_ref`,
                    `name`,
                    `description`,
                    `seq`,
                    `test_provision_day`,
                    `test_removal_day`,
                    `test_provision_date`,
                    `test_removal_date`,
                    `initial_active`)
                SELECT 
                    v_idProfiletestNew,
                    v_idProfileNew,
                    v_idProfilesegmentNew,
                    `id_test_ref`,
                    `name`,
                    `description`,
                    `seq`,
                    `test_provision_day`,
                    `test_removal_day`,
                    `test_provision_date`,
                    `test_removal_date`,
                    `initial_active`
                FROM `profiletest`
                WHERE `id_profiletest` = v_idProfiletestOld;                
                
                call write_debug_msg(@enabled, CONCAT('Copy Profiletest Successful.  Old v_idProfiletestOld. ', v_idProfiletestOld, ' Changed to New v_idProfiletestNew ', v_idProfiletestNew));

            END LOOP get_profiletest;
        END BLOCK2;
            
    END LOOP get_profilesegment;
            
    COMMIT;

    SET status_code = 0;
    SET status_message = "Success!";

END main_procedure;$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure mark_usertest_as_graded
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`mark_usertest_as_graded`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`mark_usertest_as_graded` (IN in_idUsertest BIGINT, OUT out_status_code INT, OUT out_status_message VARCHAR(256))
BEGIN

	DECLARE v_idUser BIGINT DEFAULT 0;
	DECLARE v_idProfiletest BIGINT DEFAULT 0;
	DECLARE v_idProfilesegment BIGINT DEFAULT 0;
	DECLARE v_profile_type INT DEFAULT 0;
	DECLARE v_idProfiletestNext BIGINT DEFAULT 0;
	DECLARE v_idProfiletestNextSequence INT DEFAULT 0;

	DECLARE exit handler for sqlexception
	  BEGIN
		SET out_status_code = -1;
		SET out_status_message = "Fail - SQL Error";
	  ROLLBACK;
	END;

	DECLARE exit handler for sqlwarning
	 BEGIN
		SET out_status_code = -1;
		SET out_status_message = "Fail - SQL Warning";
	 ROLLBACK;
	END;


	START TRANSACTION;

	-- Does not use usertest.id_profile (only uses usertest.id_profiletest)
	-- SELECT ut.id_profiletest, p.profile_type INTO v_idProfiletest, v_profile_type
	-- FROM usertest ut LEFT JOIN profiletest pt ON ut.id_profiletest = pt.id_profiletest
	-- 				 LEFT JOIN profilesegment ps ON pt.id_profilesegment = ps.id_profilesegment
	-- 				 LEFT JOIN profile p ON ps.id_profile = p.id_profile
	-- WHERE ut.id_usertest = in_idUsertest;

	-- Use the usertest.id_profile value for efficiency purpose
	SELECT ut.id_user, ut.id_profiletest, p.profile_type INTO v_idUser, v_idProfiletest, v_profile_type
	FROM usertest ut LEFT JOIN profile p ON ut.id_profile = p.id_profile
	WHERE ut.id_usertest = in_idUsertest;

	-- do this complicated logic only for a Sequenced profile (note that v_profile_type can be null for non-profiled usertest)
	IF (v_profile_type = 3) THEN
		-- Figure out the id_profilesegment to identify the series
		SELECT ps.id_profilesegment INTO v_idProfilesegment
		FROM profiletest pt LEFT JOIN profilesegment ps ON pt.id_profilesegment = ps.id_profilesegment 
		WHERE pt.id_profiletest = v_idProfiletest;

		-- figure out the next id_profiletest in the series
		-- SELECT MIN(upt.id_profiletest) INTO v_idProfiletestNext
		SELECT MIN(pt.seq) INTO v_idProfiletestNextSequence
		FROM userprofiletest upt LEFT JOIN profiletest pt ON upt.id_profiletest = pt.id_profiletest 
								 LEFT JOIN userprofile up ON upt.id_userprofile = up.id_userprofile
		WHERE pt.id_profilesegment = v_idProfilesegment AND 
			  up.id_student = v_idUser AND 
			  upt.active = 0;

		IF (v_idProfiletestNextSequence IS NOT null) THEN
			-- SELECT MIN(upt.id_profiletest) INTO v_idProfiletestNext
			SELECT upt.id_profiletest INTO v_idProfiletestNext
			FROM userprofiletest upt LEFT JOIN profiletest pt ON upt.id_profiletest = pt.id_profiletest 
									 LEFT JOIN userprofile up ON upt.id_userprofile = up.id_userprofile
			WHERE pt.id_profilesegment = v_idProfilesegment AND 
				  pt.seq = v_idProfiletestNextSequence;

			-- update its status to active (note that v_idProfiletestNext can be null)
			UPDATE userprofiletest upt LEFT JOIN userprofile up ON upt.id_userprofile = up.id_userprofile
			SET  active = 1 
			WHERE upt.id_profiletest = v_idProfiletestNext AND 
				  up.id_student = v_idUser;
		END IF;
	END IF;

	-- either way, update the usertest to the next status...
	UPDATE usertest ut SET test_status = 'corrections' WHERE ut.id_usertest = in_idUsertest;

	-- done
    COMMIT;

    -- indicate success status
    SET out_status_code = 0;
    SET out_status_message = "success";

END
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure update_topic_skill_counts_for_channel
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`update_topic_skill_counts_for_channel`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`update_topic_skill_counts_for_channel` (IN idChannel BIGINT)
BEGIN

    -- Declare Question and Point count variables at a Test Level
    DECLARE v_finished INTEGER DEFAULT 0;

    DECLARE v_id_level BIGINT DEFAULT 0;
    DECLARE v_topiccount INT DEFAULT 0;
    DECLARE v_skillcount INT DEFAULT 0;

    -- declare the testsegment cursor 
/*	This does not calculate skill_counts when a topic is referred...
		DECLARE levelWithCountsCursor CURSOR FOR 
		SELECT l.id_level, 
				count(distinct t.id_topic) AS topiccount, 
				count(distinct s.id_skill) AS skillcount 
		FROM level l LEFT JOIN topic t on t.id_level = l.id_level LEFT JOIN skill s ON s.id_topic = t.id_topic
		GROUP BY l.id_level;
*/
-- Include counts from referred topics 
    DECLARE levelWithCountsCursor CURSOR FOR 
		SELECT l.id_level, 
				count(distinct t.id_topic) AS topiccount, 
				count(distinct s.id_skill)  + count(distinct s2.id_skill) AS skillcount 
		FROM level l LEFT JOIN topic t on t.id_level = l.id_level 
					LEFT JOIN skill s ON s.id_topic = t.id_topic
					LEFT JOIN skill s2 ON s2.id_topic = t.id_topic_reference
		WHERE l.id_system = idChannel
		GROUP BY l.id_level;

    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET v_finished = 1;

    -- Update skill and topic counts for each level
    SET v_finished = 0;
    -- open the cursor
    OPEN levelWithCountsCursor;   
    -- Fetch in a loop
    get_level: LOOP
        FETCH levelWithCountsCursor INTO v_id_level, v_topiccount, v_skillcount;
        IF v_finished = 1 THEN
            LEAVE get_level;
        END IF;
        -- update testsection
        UPDATE level l
        SET l.topiccount = v_topiccount, l.skillcount = v_skillcount
        WHERE l.id_level = v_id_level;

    END LOOP get_level;
    -- close the cursor
    CLOSE levelWithCountsCursor;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `rulefree`.`vw_gradeleveldetail`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `rulefree`.`vw_gradeleveldetail` ;
DROP TABLE IF EXISTS `rulefree`.`vw_gradeleveldetail`;
USE `rulefree`;
CREATE OR REPLACE VIEW `rulefree`.`vw_gradeleveldetail` AS
SELECT l.id_system as id_system,
	   gl.id_gradelevel AS id_gradelevel,
       gs.grade_name as grade_name, 
       l.`subject` AS level_subject, 
       l.`id_level` AS id_level, 
       l.`name` AS level_name, 
       l.description AS level_description, 
       t.id_topic AS id_topic,
	   t.`name` AS topic_name, 
       t.`subject` AS topic_subject,
       t.description as topic_description, 
       s.id_skill AS id_skill,
	   s.`name` AS skill_name, 
       s.`subject` AS skill_subject,
       s.description AS skill_description, 
       s.`id_provider` AS id_provider
FROM gradeskill AS gs 
     INNER JOIN skill AS s ON gs.id_skill = s.id_skill 
     INNER JOIN topic AS t ON s.id_topic = t.id_topic 
     INNER JOIN `level` AS l ON t.id_level = l.id_level 
     INNER JOIN gradelevel AS gl ON gl.gradekey = gs.grade_name AND gl.`subject` = l.`subject`;
;

-- -----------------------------------------------------
-- View `rulefree`.`vw_profiletest`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `rulefree`.`vw_profiletest` ;
DROP TABLE IF EXISTS `rulefree`.`vw_profiletest`;
USE `rulefree`;
CREATE OR REPLACE VIEW `rulefree`.`vw_profiletest` AS
SELECT 	p.name AS profile_name, 
		pg.name AS profilesegment_name, 
		pt.name AS profiletest_name, 
		pt.* 
FROM profiletest pt LEFT JOIN profile p ON pt.id_profile = p.id_profile
					LEFT JOIN profilesegment pg ON pt.id_profilesegment = pg.id_profilesegment;

;

-- -----------------------------------------------------
-- View `rulefree`.`vw_profile`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `rulefree`.`vw_profile` ;
DROP TABLE IF EXISTS `rulefree`.`vw_profile`;
USE `rulefree`;
CREATE OR REPLACE VIEW `rulefree`.`vw_profile` AS
SELECT 	u.username AS provider_name, 
		o.name AS organization_name, 
		(CASE 
		   WHEN p.profile_type = 1 THEN 'Exact Dates'
		   WHEN p.profile_type = 2 THEN 'Fixed Days'
		   WHEN p.profile_type = 3 THEN 'Sequenced'
		   ELSE 'UNKNOWN'
		 END) AS profile_type_string,
		(CASE 
		   WHEN p.access_level = 1 THEN 'Private'
		   WHEN p.access_level = 2 THEN 'Organization'
		   WHEN p.access_level = 3 THEN 'Public'
		   ELSE 'UNKNOWN'
		 END) AS access_level_string,
		p.* 
FROM profile p LEFT JOIN user u ON p.id_provider = u.id_user
				LEFT JOIN organization_provider op ON p.id_provider = op.id_provider 
				LEFT JOIN organization o ON op.id_organization = o.id_organization;



;

-- -----------------------------------------------------
-- View `rulefree`.`vw_profilesegment`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `rulefree`.`vw_profilesegment` ;
DROP TABLE IF EXISTS `rulefree`.`vw_profilesegment`;
USE `rulefree`;
CREATE  OR REPLACE VIEW `rulefree`.`vw_profilesegment` AS
SELECT  p.name AS profile_name, 
		ps.* 
FROM profilesegment ps LEFT JOIN profile p ON ps.id_profile = p.id_profile;
;

-- -----------------------------------------------------
-- View `rulefree`.`vw_userprofile`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `rulefree`.`vw_userprofile` ;
DROP TABLE IF EXISTS `rulefree`.`vw_userprofile`;
USE `rulefree`;
CREATE OR REPLACE VIEW `rulefree`.`vw_userprofile` AS
SELECT  p.name AS profile_name, 
		provider.username AS provider_username,
		CONCAT(provider.first_name, ' ', provider.last_name) AS provider_full_name,
		student.username AS student_username,
		CONCAT(student.first_name, ' ', student.last_name) AS student_full_name,
		up.* 
FROM userprofile up LEFT JOIN profile p ON up.id_profile = p.id_profile
				 LEFT JOIN user provider ON up.id_provider = provider.id_user 
				 LEFT JOIN user student ON up.id_student = student.id_user;
;

-- -----------------------------------------------------
-- View `rulefree`.`vw_userprofiletest`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `rulefree`.`vw_userprofiletest` ;
DROP TABLE IF EXISTS `rulefree`.`vw_userprofiletest`;
USE `rulefree`;
CREATE OR REPLACE VIEW `rulefree`.`vw_userprofiletest` AS
SELECT  p.name AS profile_name, 
        t.name AS test_name, 
        provider.username AS provider_username,
        CONCAT(provider.first_name, ' ', provider.last_name) AS provider_full_name,
        student.username AS student_username,
        CONCAT(student.first_name, ' ', student.last_name) AS student_full_name,
        upt.* 
FROM userprofiletest upt LEFT JOIN profiletest pt ON upt.id_profiletest = pt.id_profiletest 
                 LEFT JOIN test t ON pt.id_test_ref = t.id_test 
                 LEFT JOIN userprofile up ON upt.id_userprofile = up.id_userprofile 
                 LEFT JOIN profile p ON up.id_profile = p.id_profile
                 LEFT JOIN user provider ON up.id_provider = provider.id_user 
                 LEFT JOIN user student ON up.id_student = student.id_user
ORDER BY id_userprofile;

;

-- -----------------------------------------------------
-- View `rulefree`.`vw_question`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `rulefree`.`vw_question` ;
DROP TABLE IF EXISTS `rulefree`.`vw_question`;
USE `rulefree`;
CREATE OR REPLACE VIEW `rulefree`.`vw_question` AS
SELECT  c.name AS system_name,
		c.id_system AS id_system,
		l.name AS level_name,
		l.id_level AS id_level,
		l.subject AS level_subject,
		t.name AS topic_name,
		t.id_topic AS id_topic, 
		t.subject AS topic_subject,
		sk.name AS skill_name, 
		sk.id_skill AS id_skill, 
		s.name AS section_name, 
		q.* 
FROM question q LEFT JOIN section s ON q.id_section = s.id_section
				LEFT JOIN skill sk ON s.id_skill = sk.id_skill
				LEFT JOIN topic t ON sk.id_topic = t.id_topic
				LEFT JOIN level l ON t.id_level = l.id_level
				LEFT JOIN system c ON l.id_system = c.id_system;






;

-- -----------------------------------------------------
-- View `rulefree`.`vw_section`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `rulefree`.`vw_section` ;
DROP TABLE IF EXISTS `rulefree`.`vw_section`;
USE `rulefree`;
CREATE OR REPLACE VIEW `rulefree`.`vw_section` AS
SELECT  c.name AS system_name,
		c.id_system AS id_system,
		l.name AS level_name,
		l.id_level AS id_level, 
		l.subject AS level_subject,
		t.name AS topic_name,
		t.id_topic AS id_topic, 
		t.subject AS topic_subject,
		sk.name AS skill_name, 
		s.* 
FROM section s LEFT JOIN skill sk ON s.id_skill = sk.id_skill
				LEFT JOIN topic t ON sk.id_topic = t.id_topic
				LEFT JOIN level l ON t.id_level = l.id_level
				LEFT JOIN system c ON l.id_system = c.id_system;

;

-- -----------------------------------------------------
-- View `rulefree`.`vw_skill`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `rulefree`.`vw_skill` ;
DROP TABLE IF EXISTS `rulefree`.`vw_skill`;
USE `rulefree`;
CREATE OR REPLACE VIEW `rulefree`.`vw_skill` AS 
SELECT  c.name AS system_name,
		c.id_system AS id_system,
		l.name AS level_name,
		l.id_level AS id_level, 
		l.subject AS level_subject,
		t.name AS topic_name,
		t.subject AS topic_subject,
		sk.* 
FROM skill sk LEFT JOIN topic t ON sk.id_topic = t.id_topic
				LEFT JOIN level l ON t.id_level = l.id_level
				LEFT JOIN system c ON l.id_system = c.id_system;
;

-- -----------------------------------------------------
-- View `rulefree`.`vw_topic`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `rulefree`.`vw_topic` ;
DROP TABLE IF EXISTS `rulefree`.`vw_topic`;
USE `rulefree`;
CREATE OR REPLACE VIEW `rulefree`.`vw_topic` AS
SELECT  c.name AS system_name,
		c.id_system AS id_system,
		l.name AS level_name,
		l.subject AS level_subject,
		t.* 
FROM topic t LEFT JOIN level l ON t.id_level = l.id_level
			 LEFT JOIN system c ON l.id_system = c.id_system;
;

-- -----------------------------------------------------
-- View `rulefree`.`vw_level`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `rulefree`.`vw_level` ;
DROP TABLE IF EXISTS `rulefree`.`vw_level`;
USE `rulefree`;
CREATE OR REPLACE VIEW `rulefree`.`vw_level` AS
SELECT  c.name AS system_name,
		l.* 
FROM level l LEFT JOIN system c ON l.id_system = c.id_system;
;

SET SQL_MODE = '';
GRANT USAGE ON *.* TO rulefree_user;
 DROP USER rulefree_user;
SET SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';
CREATE USER 'rulefree_user' IDENTIFIED BY 'rulefree_user';

GRANT ALL ON `rulefree`.* TO 'rulefree_user';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
