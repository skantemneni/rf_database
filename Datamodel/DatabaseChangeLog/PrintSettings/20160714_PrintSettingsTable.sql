SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;

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


USE `rulefree` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


