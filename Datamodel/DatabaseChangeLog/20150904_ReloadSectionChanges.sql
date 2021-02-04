-- Deleting this FK allows me to reload sections while they are still assigned as adaptive sections
ALTER TABLE `rulefree`.`adaptive_test` DROP foreign key `fk_adaptive_test_section`;
ALTER TABLE `rulefree`.`adaptive_test` DROP foreign key `fk_adaptive_testing_section`;

