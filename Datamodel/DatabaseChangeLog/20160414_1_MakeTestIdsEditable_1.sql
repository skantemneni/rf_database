DROP TABLE IF EXISTS `rulefree`.`test_instance` ;
DROP TABLE IF EXISTS `rulefree`.`serialized_testsection` ;

DROP TABLE IF EXISTS `rulefree`.`delete_testresponse` ;
DROP TABLE IF EXISTS `rulefree`.`delete_test_instance_rollup` ;
DROP TABLE IF EXISTS `rulefree`.`delete_testsegment_instance` ;
DROP TABLE IF EXISTS `rulefree`.`delete_testsegment_instance_rollup` ;
DROP TABLE IF EXISTS `rulefree`.`delete_testsection_instance` ;
DROP TABLE IF EXISTS `rulefree`.`delete_testsection_instance_rollup` ;
DROP TABLE IF EXISTS `rulefree`.`delete_testsection_instance_detail` ;




-- Test Section Changes
ALTER TABLE `rulefree`.`testsection` DROP FOREIGN KEY `fk_testsection_to_testsegment`;
ALTER TABLE `rulefree`.`testsection` ADD CONSTRAINT `fk_testsection_to_testsegment` FOREIGN KEY (`id_testsegment` ) REFERENCES `rulefree`.`testsegment` (`id_testsegment` ) ON DELETE CASCADE ON UPDATE CASCADE;
-- get rid of auto increment
ALTER TABLE `rulefree`.`testsection` MODIFY `id_testsection` BIGINT NOT NULL;

-- Test Segment Changes
ALTER TABLE `rulefree`.`testsegment` DROP FOREIGN KEY `fk_testsegment_to_test`;
ALTER TABLE `rulefree`.`testsegment` ADD CONSTRAINT `fk_testsegment_to_test` FOREIGN KEY (`id_test` ) REFERENCES `rulefree`.`test` (`id_test` ) ON DELETE CASCADE ON UPDATE CASCADE;

-- get rid of auto increment - first you have to delete/disable all fk's that refer to the column being changed
ALTER TABLE `rulefree`.`testsection` DROP FOREIGN KEY `fk_testsection_to_testsegment`;
-- get rid of auto increment
ALTER TABLE `rulefree`.`testsegment` MODIFY `id_testsegment` BIGINT NOT NULL;
-- now you have to add/enable all fk's that refer to the column being changed
ALTER TABLE `rulefree`.`testsection` ADD CONSTRAINT `fk_testsection_to_testsegment` FOREIGN KEY (`id_testsegment` ) REFERENCES `rulefree`.`testsegment` (`id_testsegment` ) ON DELETE CASCADE ON UPDATE CASCADE;


-- Test Changes
-- get rid of auto increment
-- get rid of auto increment - first you have to delete/disable all fk's that refer to the column being changed
ALTER TABLE `rulefree`.`testsegment` DROP FOREIGN KEY `fk_testsegment_to_test`;
ALTER TABLE `rulefree`.`usertest` DROP FOREIGN KEY `fk_usertest_to_test`;
ALTER TABLE `rulefree`.`testinstance` DROP FOREIGN KEY `fk_testinstance_to_test`;
ALTER TABLE `rulefree`.`serialized_test` DROP FOREIGN KEY `fk_serialized_test_to_test`;
ALTER TABLE `rulefree`.`redumption_code_test` DROP FOREIGN KEY `fk_redumption_code_test_to_test`;
ALTER TABLE `rulefree`.`testalias` DROP FOREIGN KEY `fk_testalias_to_test`;
-- get rid of auto increment
ALTER TABLE `rulefree`.`test` MODIFY `id_test` BIGINT NOT NULL;
-- now you have to add/enable all fk's that refer to the column being changed
ALTER TABLE `rulefree`.`testsegment` ADD CONSTRAINT `fk_testsegment_to_test` FOREIGN KEY (`id_test` ) REFERENCES `rulefree`.`test` (`id_test` ) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `rulefree`.`usertest` ADD CONSTRAINT `fk_usertest_to_test` FOREIGN KEY (`id_test` ) REFERENCES `rulefree`.`test` (`id_test` ) ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE `rulefree`.`testinstance` ADD CONSTRAINT `fk_testinstance_to_test` FOREIGN KEY (`id_test` ) REFERENCES `rulefree`.`test` (`id_test` ) ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE `rulefree`.`serialized_test` ADD CONSTRAINT `fk_serialized_test_to_test` FOREIGN KEY (`id_test` ) REFERENCES `rulefree`.`test` (`id_test` ) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `rulefree`.`redumption_code_test` ADD CONSTRAINT `fk_redumption_code_test_to_test` FOREIGN KEY (`id_test` ) REFERENCES `rulefree`.`test` (`id_test` ) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `rulefree`.`testalias` ADD CONSTRAINT `fk_testalias_to_test` FOREIGN KEY (`id_test` ) REFERENCES `rulefree`.`test` (`id_test` ) ON DELETE CASCADE ON UPDATE CASCADE;


-- Usertest Changes
ALTER TABLE `rulefree`.`usertest` DROP FOREIGN KEY `fk_usertest_to_test`;
ALTER TABLE `rulefree`.`usertest` ADD CONSTRAINT `fk_usertest_to_test` FOREIGN KEY (`id_test` ) REFERENCES `rulefree`.`test` (`id_test` ) ON DELETE CASCADE ON UPDATE CASCADE;

-- usertestresponse Changes
ALTER TABLE `rulefree`.`usertestresponse` DROP FOREIGN KEY `fk_usertestresponse_to_usertest`;
ALTER TABLE `rulefree`.`usertestresponse` ADD CONSTRAINT `fk_usertestresponse_to_usertest` FOREIGN KEY (`id_usertest` ) REFERENCES `rulefree`.`usertest` (`id_usertest` ) ON DELETE CASCADE ON UPDATE CASCADE;

-- testinstance Changes
ALTER TABLE `rulefree`.`testinstance` DROP FOREIGN KEY `fk_testinstance_to_test`;
ALTER TABLE `rulefree`.`testinstance` ADD CONSTRAINT `fk_testinstance_to_test` FOREIGN KEY (`id_test` ) REFERENCES `rulefree`.`test` (`id_test` ) ON DELETE CASCADE ON UPDATE CASCADE;

-- testinstance_detail Changes
ALTER TABLE `rulefree`.`testinstance_detail` DROP FOREIGN KEY `fk_testinstance_detail_to_testinstance`;
ALTER TABLE `rulefree`.`testinstance_detail` ADD CONSTRAINT `fk_testinstance_detail_to_testinstance` FOREIGN KEY (`id_testinstance` ) REFERENCES `rulefree`.`testinstance` (`id_testinstance` ) ON DELETE CASCADE ON UPDATE CASCADE;

-- testinstance_section Changes
ALTER TABLE `rulefree`.`testinstance_section` DROP FOREIGN KEY `fk_testinstance_section_to_testinstance`;
ALTER TABLE `rulefree`.`testinstance_section` ADD CONSTRAINT `fk_testinstance_section_to_testinstance` FOREIGN KEY (`id_testinstance` ) REFERENCES `rulefree`.`testinstance` (`id_testinstance` ) 
ON DELETE CASCADE ON UPDATE CASCADE;

-- serialized_test Changes
ALTER TABLE `rulefree`.`serialized_test` DROP FOREIGN KEY `fk_serialized_test_to_test`;
ALTER TABLE `rulefree`.`serialized_test` ADD CONSTRAINT `fk_serialized_test_to_test` FOREIGN KEY (`id_test` ) REFERENCES `rulefree`.`test` (`id_test` ) ON DELETE CASCADE ON UPDATE CASCADE;

-- redumption_code_test Changes
ALTER TABLE `rulefree`.`redumption_code_test` DROP FOREIGN KEY `fk_redumption_code_test_to_test`;
ALTER TABLE `rulefree`.`redumption_code_test` ADD CONSTRAINT `fk_redumption_code_test_to_test` FOREIGN KEY (`id_test` ) REFERENCES `rulefree`.`test` (`id_test` ) ON DELETE CASCADE ON UPDATE CASCADE;

-- testalias Changes
ALTER TABLE `rulefree`.`testalias` DROP FOREIGN KEY `fk_testalias_to_test`;
ALTER TABLE `rulefree`.`testalias` ADD CONSTRAINT `fk_testalias_to_test` FOREIGN KEY (`id_test` ) REFERENCES `rulefree`.`test` (`id_test` ) ON DELETE CASCADE ON UPDATE CASCADE;
