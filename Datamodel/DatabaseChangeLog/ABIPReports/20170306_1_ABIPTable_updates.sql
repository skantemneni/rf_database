ALTER TABLE `rulefree`.`usertest` ADD COLUMN 
`administered_offline` INT NULL DEFAULT 0 COMMENT 'Indicates if the exam has been taken offline.  The default report format for Offline exams is ABIP report.';

ALTER TABLE `rulefree`.`testinstance_detail` ADD COLUMN 
`user_points` DECIMAL(7,2) NOT NULL DEFAULT 0.0 ;






ALTER TABLE `rulefree`.`testinstance` ADD COLUMN 
  `percentile` INT NULL DEFAULT 0 COMMENT 'Gets  here after a lengthy calculation.';
  
ALTER TABLE `rulefree`.`abiptestinstance` ADD COLUMN 
  `percentile` INT NULL DEFAULT 0 COMMENT 'Gets  here after a lengthy calculation.';
  

ALTER TABLE `rulefree`.`testinstance_section` ADD COLUMN 
  `percentile` INT NULL DEFAULT 0 COMMENT 'Gets  here after a lengthy calculation.';
  
ALTER TABLE `rulefree`.`abiptestinstance_section` ADD COLUMN 
  `percentile` INT NULL DEFAULT 0 COMMENT 'Gets  here after a lengthy calculation.';
  




ALTER TABLE `rulefree`.`anal_testsubject_data` ADD COLUMN 
  `percentile` INT NULL DEFAULT 0 COMMENT 'Gets  here after a lengthy calculation.';
  
ALTER TABLE `rulefree`.`anal_testlevel_data` ADD COLUMN 
  `percentile` INT NULL DEFAULT 0 COMMENT 'Gets  here after a lengthy calculation.';
  
ALTER TABLE `rulefree`.`anal_testtopic_data` ADD COLUMN 
  `percentile` INT NULL DEFAULT 0 COMMENT 'Gets  here after a lengthy calculation.';
  



ALTER TABLE `rulefree`.`anal_test_rollup` ADD COLUMN 
  `percentile_distribution` VARCHAR(2000) NULL;
  
ALTER TABLE `rulefree`.`anal_testsection_rollup` ADD COLUMN 
  `percentile_distribution` VARCHAR(2000) NULL;
  
ALTER TABLE `rulefree`.`anal_testsubject_rollup` ADD COLUMN 
  `percentile_distribution` VARCHAR(2000) NULL;
  
ALTER TABLE `rulefree`.`anal_testlevel_rollup` ADD COLUMN 
  `percentile_distribution` VARCHAR(2000) NULL;
  
ALTER TABLE `rulefree`.`anal_testtopic_rollup` ADD COLUMN 
  `percentile_distribution` VARCHAR(2000) NULL;

