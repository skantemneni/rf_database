-- Add new Systems for 'Foundation Overlay channels' (145-149)

-- Basic Employment Skills Channel for Degree Students
INSERT INTO `rulefree`.`system`(`id_system`,`name`,`editable`,`published`)VALUES(145,'Foundation 6',0,1);
INSERT INTO `rulefree`.`system`(`id_system`,`name`,`editable`,`published`)VALUES(146,'Foundation 7',0,1);
INSERT INTO `rulefree`.`system`(`id_system`,`name`,`editable`,`published`)VALUES(147,'Foundation 8',0,1);
INSERT INTO `rulefree`.`system`(`id_system`,`name`,`editable`,`published`)VALUES(148,'Foundation 9',0,1);
INSERT INTO `rulefree`.`system`(`id_system`,`name`,`editable`,`published`)VALUES(149,'Foundation 10',0,1);

-- Make all channels belong to eTester organization by default
INSERT INTO `rulefree`.`organization_channel`(`id_organization`,`id_channel`)VALUES(100,145);
INSERT INTO `rulefree`.`organization_channel`(`id_organization`,`id_channel`)VALUES(100,146);
INSERT INTO `rulefree`.`organization_channel`(`id_organization`,`id_channel`)VALUES(100,147);
INSERT INTO `rulefree`.`organization_channel`(`id_organization`,`id_channel`)VALUES(100,148);
INSERT INTO `rulefree`.`organization_channel`(`id_organization`,`id_channel`)VALUES(100,149);

-- Give access to sample students 
-- Access to channel 145-149 to Mary for 45 years, sesi for 45 years and Student 5 and 6 for 2 year
INSERT INTO channel_subscriptions(id_channel,id_student,start_date,end_date)VALUES(145, 5, CURDATE(), DATE_ADD(CURDATE(),INTERVAL 45 YEAR));
INSERT INTO channel_subscriptions(id_channel,id_student,start_date,end_date)VALUES(146, 5, CURDATE(), DATE_ADD(CURDATE(),INTERVAL 45 YEAR));
INSERT INTO channel_subscriptions(id_channel,id_student,start_date,end_date)VALUES(147, 5, CURDATE(), DATE_ADD(CURDATE(),INTERVAL 45 YEAR));
INSERT INTO channel_subscriptions(id_channel,id_student,start_date,end_date)VALUES(148, 5, CURDATE(), DATE_ADD(CURDATE(),INTERVAL 45 YEAR));
INSERT INTO channel_subscriptions(id_channel,id_student,start_date,end_date)VALUES(149, 5, CURDATE(), DATE_ADD(CURDATE(),INTERVAL 45 YEAR));

INSERT INTO channel_subscriptions(id_channel,id_student,start_date,end_date)VALUES(145, 1, CURDATE(), DATE_ADD(CURDATE(),INTERVAL 45 YEAR));
INSERT INTO channel_subscriptions(id_channel,id_student,start_date,end_date)VALUES(146, 1, CURDATE(), DATE_ADD(CURDATE(),INTERVAL 45 YEAR));
INSERT INTO channel_subscriptions(id_channel,id_student,start_date,end_date)VALUES(147, 1, CURDATE(), DATE_ADD(CURDATE(),INTERVAL 45 YEAR));
INSERT INTO channel_subscriptions(id_channel,id_student,start_date,end_date)VALUES(148, 1, CURDATE(), DATE_ADD(CURDATE(),INTERVAL 45 YEAR));
INSERT INTO channel_subscriptions(id_channel,id_student,start_date,end_date)VALUES(149, 1, CURDATE(), DATE_ADD(CURDATE(),INTERVAL 45 YEAR));

INSERT INTO channel_subscriptions(id_channel,id_student,start_date,end_date)VALUES(145, 117, CURDATE(), DATE_ADD(CURDATE(),INTERVAL 2 YEAR));
INSERT INTO channel_subscriptions(id_channel,id_student,start_date,end_date)VALUES(146, 117, CURDATE(), DATE_ADD(CURDATE(),INTERVAL 2 YEAR));
INSERT INTO channel_subscriptions(id_channel,id_student,start_date,end_date)VALUES(147, 117, CURDATE(), DATE_ADD(CURDATE(),INTERVAL 2 YEAR));
INSERT INTO channel_subscriptions(id_channel,id_student,start_date,end_date)VALUES(148, 117, CURDATE(), DATE_ADD(CURDATE(),INTERVAL 2 YEAR));
INSERT INTO channel_subscriptions(id_channel,id_student,start_date,end_date)VALUES(149, 117, CURDATE(), DATE_ADD(CURDATE(),INTERVAL 2 YEAR));

INSERT INTO channel_subscriptions(id_channel,id_student,start_date,end_date)VALUES(145, 118, CURDATE(), DATE_ADD(CURDATE(),INTERVAL 2 YEAR));
INSERT INTO channel_subscriptions(id_channel,id_student,start_date,end_date)VALUES(146, 118, CURDATE(), DATE_ADD(CURDATE(),INTERVAL 2 YEAR));
INSERT INTO channel_subscriptions(id_channel,id_student,start_date,end_date)VALUES(147, 118, CURDATE(), DATE_ADD(CURDATE(),INTERVAL 2 YEAR));
INSERT INTO channel_subscriptions(id_channel,id_student,start_date,end_date)VALUES(148, 118, CURDATE(), DATE_ADD(CURDATE(),INTERVAL 2 YEAR));
INSERT INTO channel_subscriptions(id_channel,id_student,start_date,end_date)VALUES(149, 118, CURDATE(), DATE_ADD(CURDATE(),INTERVAL 2 YEAR));

