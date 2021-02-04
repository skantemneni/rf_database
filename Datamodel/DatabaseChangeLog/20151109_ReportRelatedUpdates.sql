-- Add columns to testinstance_section
ALTER TABLE `rulefree`.`testinstance_section` ADD COLUMN     `unanswered_points_per_question` DECIMAL(3,2) NULL DEFAULT 0.0;
ALTER TABLE `rulefree`.`testinstance_section` ADD COLUMN     `seq` INT NULL DEFAULT 1;
ALTER TABLE `rulefree`.`testinstance_section` ADD COLUMN     `distributed_scoring` INT NULL DEFAULT 0;
ALTER TABLE `rulefree`.`testinstance_section` ADD COLUMN     `question_start_index` INT NULL DEFAULT 1;
ALTER TABLE `rulefree`.`testinstance_section` ADD COLUMN     `id_testsection` BIGINT NULL;

-- Add columns to the testinstance table
ALTER TABLE `rulefree`.`testinstance` ADD COLUMN     `report_by_subject` INT NULL DEFAULT 0 COMMENT 'Boolean to indicate if a report needs to be generated based on subjects - not sections';

-- Add columns to the test table
ALTER TABLE `rulefree`.`test` ADD COLUMN     `report_by_subject` INT NULL DEFAULT 0 COMMENT 'Boolean to indicate if a report needs to be generated based on subjects - not sections';

-- Update testsection for sequence to go for the test instead of a testsegment
-- note that this goas along with a code change (and not I got lucky since no testsegment has more than 1 testsection)
-- VERIFY
select * from testsection where seq > 1; 
-- (should return no rows)

UPDATE testsection ts INNER JOIN testsegment tg ON ts.id_testsegment = tg.id_testsegment 
SET     ts.seq = tg.seq; 



UPDATE testinstance_section tis INNER JOIN testinstance ti ON tis.id_testinstance = ti.id_testinstance 
                                INNER JOIN test t ON ti.id_test = t.id_test 
                                INNER JOIN testsegment tg ON tg.id_test = t.id_test 
                                INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
SET  tis.report_subject = ts.report_subject,
     tis.seq = ts.seq, 
     tis.points_per_question = ts.points_per_question,
     tis.negative_points_per_question = ts.negative_points_per_question,
     tis.unanswered_points_per_question = ts.unanswered_points_per_question,
     tis.distributed_scoring = ts.distributed_scoring,
     tis.question_start_index = ts.question_start_index,
     tis.id_testsection = ts.id_testsection
WHERE tis.testsection_name = ts.name AND 
      t.id_test in (39, 40, 41, 1335000220010);


-- truncate any existing serialized_testinstance;
select count(*) from serialized_testinstance;
truncate serialized_testinstance;

