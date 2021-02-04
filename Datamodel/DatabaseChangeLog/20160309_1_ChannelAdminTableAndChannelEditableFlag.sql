-- Update System/Channel Table.  Add editable flag (indicates the channel can ingest data via core section upoads)
ALTER TABLE `rulefree`.`system` ADD COLUMN `editable` TINYINT NULL DEFAULT 0;
UPDATE `rulefree`.`system` set `editable` = 0 WHERE `id_system` >= 0;
ALTER TABLE `rulefree`.`system` MODIFY COLUMN `editable` TINYINT NOT NULL DEFAULT 0;

-- by default set the core channels as editable
UPDATE `rulefree`.`system` set `editable` = 1 WHERE `id_system` in (103, 104, 111);

-- channel_admin table - gives permissions to select users/providers to be able to upload data
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;

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

USE `rulefree` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- Add permissions to channel_admin
-- Nayaj has permissions for channel 104 (Foundation)
INSERT INTO `rulefree`.`channel_admin`(`id_channel`,`id_provider`,`upload_content`)VALUES(104,105,1);
-- Sai (siva) has permissions for channels 103, 111 and 104 (10+2, Banking and Foundation)
INSERT INTO `rulefree`.`channel_admin`(`id_channel`,`id_provider`,`upload_content`)VALUES(103,106,1);
INSERT INTO `rulefree`.`channel_admin`(`id_channel`,`id_provider`,`upload_content`)VALUES(111,106,1);
INSERT INTO `rulefree`.`channel_admin`(`id_channel`,`id_provider`,`upload_content`)VALUES(104,106,1);


