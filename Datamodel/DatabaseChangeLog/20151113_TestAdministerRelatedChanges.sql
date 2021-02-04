-- Create a testsection_instructions table
DROP TABLE IF EXISTS `rulefree`.`testsection_instructions` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`testsection_instructions` (
  `instructions_name` VARCHAR(100) NOT NULL ,
  `description` VARCHAR(200) NULL ,
  `text` MEDIUMTEXT NULL ,
  `addl_info` MEDIUMTEXT NULL ,
  PRIMARY KEY (`instructions_name`) )
ENGINE = InnoDB;

INSERT INTO `rulefree`.`testsection_instructions`(`instructions_name`,`text`)
VALUES('IITAdvanceMultipleChoice', '<h1>This is for Lord Shiva</h1><br/><p>Please forgive me if I have done something wrong. And please help me!</p>');



-- Add columns to test table to indicate if we want to combine sections while administering a test
ALTER TABLE `rulefree`.`testsection` ADD COLUMN       `instructions_name` VARCHAR(100) NULL ;

ALTER TABLE `rulefree`.`testsection` ADD CONSTRAINT `fk_testsection_to_testsection_instructions`
    FOREIGN KEY (`instructions_name` )
    REFERENCES `rulefree`.`testsection_instructions` (`instructions_name` )
    ON DELETE SET NULL
    ON UPDATE CASCADE;



-- Add columns to indicate what instructions we want to show while administering a testsection
ALTER TABLE `rulefree`.`test` ADD COLUMN     `combine_sections` INT NULL DEFAULT 0 COMMENT '0=NoCombineSections, 1=CombineSectionsForSegment, 2=CombineSectionsForTest, Else 0';


-- Truncate serialized_test;
truncate serialized_test;

