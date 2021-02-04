-- Create a Sequence table


USE `rulefree` ;

-- -----------------------------------------------------
-- Table `rulefree`.`sequence`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rulefree`.`sequence` ;

CREATE  TABLE IF NOT EXISTS `rulefree`.`sequence` (
  `key` VARCHAR(30) NOT NULL ,
  `current` BIGINT NOT NULL ,
  PRIMARY KEY (`key`) )
ENGINE = InnoDB;


-- Enter a row for test keys
INSERT INTO `rulefree`.`sequence`(`key`,`current`)VALUES('test', 9990000000000);




-- -----------------------------------------------------
-- function get_new_test_id
-- -----------------------------------------------------

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



