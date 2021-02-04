-- alter authorities table....
ALTER TABLE `authorities` DROP FOREIGN KEY `fk_authorities_to_user`;
ALTER TABLE `authorities` ADD CONSTRAINT `fk_authorities_to_user` FOREIGN KEY (`username` ) REFERENCES `rulefree`.`user` (`username` ) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `authorities` DROP FOREIGN KEY `fk_authorities_to_role`;
ALTER TABLE `authorities` ADD CONSTRAINT `fk_authorities_to_role` FOREIGN KEY (`authority` ) REFERENCES `rulefree`.`role` (`authority` ) ON DELETE CASCADE ON UPDATE CASCADE;


-- alter webuser table
ALTER TABLE `webuser` DROP FOREIGN KEY `fk_webuser_to_user`;
ALTER TABLE `webuser` ADD CONSTRAINT `fk_webuser_to_user` FOREIGN KEY (`username` ) REFERENCES `rulefree`.`user` (`username` ) ON DELETE CASCADE ON UPDATE CASCADE;

-- alter providerstudent table
ALTER TABLE `providerstudent` DROP FOREIGN KEY `fk_providerstudent_to_user1`;
ALTER TABLE `providerstudent` ADD CONSTRAINT `fk_providerstudent_to_userAsProvider` FOREIGN KEY (`provider_username` ) REFERENCES `rulefree`.`user` (`username` ) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `providerstudent` DROP FOREIGN KEY `fk_providerstudent_to_user2`;
ALTER TABLE `providerstudent` ADD CONSTRAINT `fk_providerstudent_to_userAsStudent` FOREIGN KEY (`student_username` ) REFERENCES `rulefree`.`user` (`username` ) ON DELETE CASCADE ON UPDATE CASCADE;
-- Alter Unique order
ALTER TABLE `providerstudent` DROP INDEX `pk_providerstudent_alt_key`;
ALTER TABLE `providerstudent` ADD UNIQUE INDEX `pk_providerstudent_alt_key` (`student_username` ASC, `provider_username` ASC);


-- alter usergroupmember table
ALTER TABLE `usergroupmember` DROP FOREIGN KEY `fk_usergroupmember_to_user`;
ALTER TABLE `usergroupmember` ADD CONSTRAINT `fk_usergroupmember_to_user` FOREIGN KEY (`username` ) REFERENCES `rulefree`.`user` (`username` ) ON DELETE CASCADE ON UPDATE CASCADE;

-- alter usergroup table
ALTER TABLE `usergroup` DROP FOREIGN KEY `fk_usergroup_to_user`;
ALTER TABLE `usergroup` ADD CONSTRAINT `fk_usergroup_to_user` FOREIGN KEY (`provider_username` ) REFERENCES `rulefree`.`user` (`username` ) ON DELETE CASCADE ON UPDATE CASCADE;

-- alter webuser_password_transaction table
ALTER TABLE `webuser_password_transaction` DROP FOREIGN KEY `fk_webuser_password_transaction_to_user`;
ALTER TABLE `webuser_password_transaction` ADD CONSTRAINT `fk_webuser_password_transaction_to_user`FOREIGN KEY (`username` ) REFERENCES `rulefree`.`user` (`username` ) ON DELETE CASCADE ON UPDATE CASCADE;

-- alter permissions table
ALTER TABLE `permissions` DROP FOREIGN KEY `fk_permissions_to_user`;
ALTER TABLE `permissions` ADD CONSTRAINT `fk_permissions_to_user`FOREIGN KEY (`username` ) REFERENCES `rulefree`.`user` (`username` ) ON DELETE CASCADE ON UPDATE CASCADE;

-- This is what started me down this path in the first place
-- delete from user where username = 'prathyushavedula@yahoo.com';
-- update user set username = 'prathyushavedula@yahoo.com' where username = 'prathyushavedula@gmail.com'

