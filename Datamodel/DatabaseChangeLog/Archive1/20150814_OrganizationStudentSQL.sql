SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;

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

USE `rulefree` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;



-- Create an organization
INSERT INTO `rulefree`.`organization`(`id_organization`,`name`,`description`) VALUES (301, 'Sri Surya Jr College', 'Sri Surya Jr College');

-- create students in the organization
INSERT INTO `rulefree`.`organization_student`(`id_organization`,`id_student`)  
(SELECT 301, u.id_user 
FROM user u JOIN webuser wu ON wu.username = u.username
WHERE UPPER(wu.institution) like '%SURYA%');

-- create an Organization Provider user and give him ROLE_PROVIDER
INSERT INTO `rulefree`.`user`(`username`,`password`,`enabled`,`first_name`,`last_name`,`email_address`)VALUES
('suryateacher','221a545535df6761e615ea5157a4884a021841d1117112978d92ddca45b03902',1,'Surya','Teacher','sesi.kantemneni@gmail.com');

INSERT INTO `rulefree`.`authorities`(`username`,`authority`)VALUES('suryateacher','ROLE_PROVIDER');

-- Associated the new provider with the organization
INSERT INTO `rulefree`.`organization_provider`(`id_organization`,`id_provider`) VALUES (301,
(SELECT id_user FROM user WHERE username = 'suryateacher'));



