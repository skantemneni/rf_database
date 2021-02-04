SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;

-- -----------------------------------------------------
-- Table `rulefree`.`testalias`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`testalias` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`testalias` (
  `id_testalias` BIGINT NOT NULL AUTO_INCREMENT ,
  `id_test` BIGINT NOT NULL ,
  `name` VARCHAR(100) NULL ,
  `description` VARCHAR(200) NULL ,
  `examtrack` VARCHAR(45) NULL ,
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

USE `rulefree` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;




insert into testalias(id_test, name, description, is_free, examtrack) select id_test, name, description, is_free, examtrack from test;
select * from testalias;
-- delete from testalias where id_test > 0;

update testalias set date_free_start = '2015-04-01T00:00:00', date_free_end = '2015-05-15T00:00:00' where id_test = 3;
update testalias set date_free_start = '2015-04-10', date_free_end = '2015-05-15' where id_test = 4;
update testalias set date_free_start = '2015-04-14', date_free_end = '2015-05-15' where id_test = 5;
update testalias set date_free_start = '2015-04-17', date_free_end = '2015-05-15' where id_test = 11;
update testalias set date_free_start = '2015-04-20', date_free_end = '2015-05-15' where id_test = 12;
update testalias set date_free_start = '2015-04-22', date_free_end = '2015-05-15' where id_test = 13;
update testalias set date_free_start = '2015-04-24', date_free_end = '2015-05-15' where id_test = 14;
update testalias set date_free_start = '2015-04-26', date_free_end = '2015-05-15' where id_test = 15;
update testalias set date_free_start = '2015-04-28', date_free_end = '2015-05-15' where id_test = 16;
update testalias set date_free_start = '2015-04-30', date_free_end = '2015-05-15' where id_test = 17;
update testalias set date_free_start = '2015-05-01', date_free_end = '2015-05-15' where id_test = 18;
update testalias set date_free_start = '2015-05-02', date_free_end = '2015-05-15' where id_test = 19;
update testalias set date_free_start = '2015-05-03', date_free_end = '2015-05-15' where id_test = 20;

update testalias set date_free_start = '2015-04-01T00:00:00', date_free_end = '2015-05-25T00:00:00' where id_test = 8;
update testalias set date_free_start = '2015-04-10', date_free_end = '2015-05-25' where id_test = 9;
update testalias set date_free_start = '2015-04-14', date_free_end = '2015-05-25' where id_test = 10;
update testalias set date_free_start = '2015-04-17', date_free_end = '2015-05-15' where id_test = 21;
update testalias set date_free_start = '2015-04-20', date_free_end = '2015-05-15' where id_test = 22;
update testalias set date_free_start = '2015-04-22', date_free_end = '2015-05-15' where id_test = 23;
update testalias set date_free_start = '2015-04-24', date_free_end = '2015-05-15' where id_test = 24;
update testalias set date_free_start = '2015-04-26', date_free_end = '2015-05-15' where id_test = 25;
update testalias set date_free_start = '2015-04-28', date_free_end = '2015-05-15' where id_test = 26;
update testalias set date_free_start = '2015-04-30', date_free_end = '2015-05-15' where id_test = 27;
update testalias set date_free_start = '2015-05-01', date_free_end = '2015-05-15' where id_test = 28;
update testalias set date_free_start = '2015-05-02', date_free_end = '2015-05-15' where id_test = 29;
update testalias set date_free_start = '2015-05-03', date_free_end = '2015-05-15' where id_test = 30;

