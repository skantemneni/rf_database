-- Drop foreign key constraint on adaptive_test (not as important)
ALTER TABLE `rulefree`.`adaptive_test` DROP foreign key `fk_adaptive_test_section`;

-- Add foreign key constraint on testsection (related to test) (very important)
ALTER TABLE `rulefree`.`testsection` ADD CONSTRAINT `fk_testsection_to_section`
    FOREIGN KEY (`id_section_ref` )
    REFERENCES `rulefree`.`section` (`id_section` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE;




