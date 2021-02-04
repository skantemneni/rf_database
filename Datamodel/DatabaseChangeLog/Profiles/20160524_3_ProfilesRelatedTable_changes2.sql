ALTER TABLE `rulefree`.`usertest` 
    ADD COLUMN `id_profile` BIGINT NOT NULL DEFAULT 0 COMMENT '0 indicates that this Record has no associated Profile' AFTER `id_user`;

-- WILL LIVE WITHOUT THE FOLLOWING INDEX BECAUSE IT SEEMS TO BE OK FOR MULTIPLE PROVIDERS TO ASSIGN THE SAME TEST TO A USER
-- ALTER TABLE `rulefree`.`usertest` DROP INDEX `uk_id_test_id_profile`;
-- ALTER TABLE `rulefree`.`usertest` 
--     ADD UNIQUE INDEX `uk_id_test_id_profile` (`id_user` ASC, `id_test` ASC, `id_profile` ASC);
 
ALTER TABLE `rulefree`.`usertest` 
    DROP INDEX `id_usertest_UNIQUE`;
    
 
 
 
 
 
--  YOU MAY HAVE TO DO THIS IN PROD...I ALREADY DID
 select * from usertest where id_user = 271 AND id_test = 1331000011012;
 select * from usertestresponse where id_usertest in (380, 381);
 delete from usertest where id_user = 271 AND id_test = 1331000011012 AND id_usertest = 381;


    
    