ALTER TABLE `rulefree`.`usertest` 
  ADD COLUMN `auto_grade` INT NOT NULL DEFAULT 1 COMMENT 'auto_grade can be 1 or 0.  1 indicates that the test moves from Submitted to Corrections stage without any interaction from the provider.  0 indicates that the test must be graded and approved by the provider.'  AFTER `id_profile`;
ALTER TABLE `rulefree`.`usertest` 
  ADD COLUMN `auto_publish_results` INT NOT NULL DEFAULT 1 COMMENT 'This only applies to TEST test_type objects.  auto_publish_results can take values of 1 and 0.  1 indicates that the results are published for stat purposes automatically.  0 indicates that the user needs to approve such a publish explicitely.'  AFTER `auto_grade`;

ALTER TABLE `rulefree`.`usertest` 
  ADD COLUMN `id_profiletest` BIGINT NULL COMMENT 'ID of the Profiletest record - if the usertest ic created from a Profile Assignment.  Null otherwise.';
ALTER TABLE `rulefree`.`usertest` 
  ADD COLUMN `profile_name` VARCHAR(100) NULL COMMENT 'Name of the profile - if the usertest record is the result of a profile test assignment.  Null otherwise.  This will help us avoid a link to the profile table when querying for usertests.';
ALTER TABLE `rulefree`.`usertest` 
  ADD COLUMN `profilesegment_name` VARCHAR(100) NULL COMMENT 'Name of the profilesegment associated with the profiletest - if the usertest record is the result of a profile test assignment.  Null otherwise.  This will help us avoid a link to the profilesegment table when querying for usertests.';
 

    
    