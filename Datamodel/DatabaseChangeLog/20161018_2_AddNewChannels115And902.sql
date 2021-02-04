-- Add new Systems for 'Basic Employment Skills Channel' (115) and Experimental channel 2 (902)

-- Basic Employment Skills Channel for Degree Students
INSERT INTO `rulefree`.`system`(`id_system`,`name`,`editable`,`published`)VALUES(115,'Basic Employment Skills Channel',1,1);
-- Make all channels belong to eTester organization by default
INSERT INTO `rulefree`.`organization_channel`(`id_organization`,`id_channel`)VALUES(100,115);

-- Experimental channel 2
INSERT INTO `rulefree`.`system`(`id_system`,`name`,`editable`,`published`)VALUES(902,'Experimental Channel',1,0);
-- Make all channels belong to eTester organization by default
INSERT INTO `rulefree`.`organization_channel`(`id_organization`,`id_channel`)VALUES(100,902);

-- Give access to sample students 
-- Access to channel 115 to Mary for 45 years, Student 3 and 4
INSERT INTO channel_subscriptions(id_channel,id_student,start_date,end_date)VALUES(115, 5, CURDATE(), DATE_ADD(CURDATE(),INTERVAL 45 YEAR));
INSERT INTO channel_subscriptions(id_channel,id_student,start_date,end_date)VALUES(115, 115, CURDATE(), DATE_ADD(CURDATE(),INTERVAL 2 YEAR));
INSERT INTO channel_subscriptions(id_channel,id_student,start_date,end_date)VALUES(115, 116, CURDATE(), DATE_ADD(CURDATE(),INTERVAL 2 YEAR));

-- Access to 902 to Mary for 45 years
INSERT INTO channel_subscriptions(id_channel,id_student,start_date,end_date)VALUES(902, 5, CURDATE(), DATE_ADD(CURDATE(),INTERVAL 45 YEAR));







-- Add new Systems for Experimental channel 3 (903)
-- Experimental channel 3
INSERT INTO `rulefree`.`system`(`id_system`,`name`,`editable`,`published`)VALUES(903,'Experimental Channel3',1,0);
-- Make all channels belong to eTester organization by default
INSERT INTO `rulefree`.`organization_channel`(`id_organization`,`id_channel`)VALUES(100,903);
-- Give Student Access to mary
INSERT INTO channel_subscriptions(id_channel,id_student,start_date,end_date)VALUES(903, 5, CURDATE(), DATE_ADD(CURDATE(),INTERVAL 45 YEAR));
