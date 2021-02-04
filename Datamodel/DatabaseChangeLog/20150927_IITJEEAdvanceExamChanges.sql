-- This allows us to display index numbers on the TestSectionView starting from the question_start_index (instead of typical 1)
ALTER TABLE `rulefree`.`testsection` ADD COLUMN `question_start_index` INT NULL DEFAULT 1;
ALTER TABLE `rulefree`.`testsection` ADD COLUMN `unanswered_points_per_question` DECIMAL(3,2) NULL DEFAULT 0.0;
ALTER TABLE `rulefree`.`testsection` ADD COLUMN `distributed_scoring` INT NULL DEFAULT 0;

-- Add prer and post context text columns to the Question table.  
ALTER TABLE `rulefree`.`question` ADD COLUMN `text_precontext` MEDIUMTEXT NULL;
ALTER TABLE `rulefree`.`question` ADD COLUMN `text_postcontext` MEDIUMTEXT NULL;
