-- New table to hold synopsis related information

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;

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

USE `rulefree` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;







-- insert links to the new table

-- Channel 103

INSERT INTO `rulefree`.`synopsis_link`(`id_core_artifact`,`core_artifact_type`,`synopsis_link`)VALUES(,'topic','');

1.) 
-------
Replace 
, 
with 
,'topic','Intermediate/Physics//



2.)
-------
Replace 
^ 
with 
INSERT INTO `rulefree`.`synopsis_link`\(`id_core_artifact`,`core_artifact_type`,`synopsis_link`\)VALUES\(

3.) 
-------
Replace 
$
with 
.html'\);
