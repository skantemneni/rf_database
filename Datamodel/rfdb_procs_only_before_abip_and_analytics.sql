SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `rulefree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `rulefree` ;
USE `rulefree` ;

-- -----------------------------------------------------
-- procedure delete_section
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_section`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_section` (IN idSection BIGINT, OUT status_code INT, OUT status_message VARCHAR(256))
BEGIN

DECLARE exit handler for sqlexception
  BEGIN
	SET status_code = -1;
	SET status_message = "Fail - SQL Error";
  ROLLBACK;
END;

DECLARE exit handler for sqlwarning
 BEGIN
	SET status_code = -1;
	SET status_message = "Fail - SQL Warning";
 ROLLBACK;
END;

START TRANSACTION;
	DELETE from derived_section_question where id_section in (idSection);
	DELETE from answer where id_question in (select id_question from question where id_section in (idSection));
	DELETE from question where id_section in (idSection);
	DELETE from wl_passage where id_wordlist in (idSection);
	DELETE from wl_word where id_wordlist in (idSection);
	DELETE from wl_wordlist where id_wordlist in (idSection);
	DELETE from questionset where id_section in (idSection);
	DELETE from section where id_section in (idSection);
	SET status_code = 0;
	SET status_message = "success";
COMMIT;
END 
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_skill
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_skill`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_skill` (IN idSkill BIGINT)
BEGIN
	DELETE from derived_section_question where id_section in (select id_section from section where id_skill in (idSkill));
	DELETE from answer where id_question in (select id_question from question where id_section in (select id_section from section where id_skill in (idSkill)));
	DELETE from question where id_section in (select id_section from section where id_skill in (idSkill));

	DELETE from wl_passage where id_wordlist in (select id_section from section where id_skill in (idSkill));
	DELETE from wl_word where id_wordlist in (select id_section from section where id_skill in (idSkill));
	DELETE from wl_wordlist where id_wordlist in (select id_section from section where id_skill in (idSkill));

	DELETE from section where id_skill in (idSkill);
	DELETE from gradeskill where id_skill in (idSkill);
	DELETE from skill where id_skill in (idSkill);
END 
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_topic
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_topic`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_topic` (IN idTopic BIGINT)
BEGIN
	DELETE from answer where id_question in (select id_question from question where id_section in (select id_section from section where id_skill in (select id_skill from skill where id_topic in (idTopic))));
	DELETE from question where id_section in (select id_section from section where id_skill in (select id_skill from skill where id_topic in (idTopic)));

	DELETE from wl_passage where id_wordlist in (select id_section from section where id_skill in (select id_skill from skill where id_topic in (idTopic)));
	DELETE from wl_word where id_wordlist in (select id_section from section where id_skill in (select id_skill from skill where id_topic in (idTopic)));
	DELETE from wl_wordlist where id_wordlist in (select id_section from section where id_skill in (select id_skill from skill where id_topic in (idTopic)));

	DELETE from section where id_skill in (select id_skill from skill where id_topic in (idTopic));
	DELETE from gradeskill where id_skill in (select id_skill from skill where id_topic in (idTopic));
	DELETE from skill where id_topic in (idTopic);
	DELETE from topic where id_topic in (idTopic);
END 
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_level
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_level`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_level` (IN idLevel BIGINT)
BEGIN
	DELETE from answer where id_question in (select id_question from question where id_section in (select id_section from section where id_skill in (select id_skill from skill where id_topic in (select id_topic from topic where id_level in (idLevel)))));
	DELETE from question where id_section in (select id_section from section where id_skill in (select id_skill from skill where id_topic in (select id_topic from topic where id_level in (idLevel))));

	DELETE from wl_passage where id_wordlist in (select id_section from section where id_skill in (select id_skill from skill where id_topic in (select id_topic from topic where id_level in (idLevel))));
	DELETE from wl_word where id_wordlist in (select id_section from section where id_skill in (select id_skill from skill where id_topic in (select id_topic from topic where id_level in (idLevel))));
	DELETE from wl_wordlist where id_wordlist in (select id_section from section where id_skill in (select id_skill from skill where id_topic in (select id_topic from topic where id_level in (idLevel))));

	DELETE from section where id_skill in (select id_skill from skill where id_topic in (select id_topic from topic where id_level in (idLevel)));
	DELETE from gradeskill where id_skill in (select id_skill from skill where id_topic in (select id_topic from topic where id_level in (idLevel)));
	DELETE from skill where id_topic in (select id_topic from topic where id_level in (idLevel));
	DELETE from topic where id_level in (idLevel);
	DELETE from `level` where id_level in (idLevel);
END 
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_testsegments_for_test
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_testsegments_for_test`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_testsegments_for_test` (IN idTest BIGINT)
BEGIN
	DELETE from testsection where id_testsegment in (select id_testsegment from testsegment where id_test in (idTest));
	DELETE from testsegment where id_test in (idTest);
END
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_testsegment
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_testsegment`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_testsegment` (IN idTestsegment BIGINT)
BEGIN
	DELETE from testsection where id_testsegment in (idTestsegment);
	DELETE from testsegment where id_testsegment in (idTestsegment);
END
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_testinstance
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_testinstance`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_testinstance` (IN idUsertest BIGINT)
BEGIN
	DELETE FROM testinstance_detail WHERE id_testinstance IN (SELECT id_testinstance FROM testinstance WHERE id_usertest = idUsertest); 
	DELETE FROM testinstance_section WHERE id_testinstance IN (SELECT id_testinstance FROM testinstance WHERE id_usertest = idUsertest); 
	DELETE FROM testinstance WHERE id_usertest = idUsertest; 
END
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_usergroup
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_usergroup`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_usergroup` (IN username VARCHAR(50))
BEGIN
	DELETE from usergroupmember where id_usergroup in (select id_usergroup from usergroup where provider_username in (username));
	DELETE from usergroup where provider_username in (username);
END
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_usertest
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_usertest`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_usertest` (IN idProvider BIGINT)
BEGIN
	DELETE from usertest where id_provider in (idProvider);
END
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_wordlist
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_wordlist`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_wordlist` (IN idWordlist BIGINT)
BEGIN
	DELETE from answer where id_question in (select id_question from question where id_section in (idWordlist));
	DELETE from question where id_section in (idWordlist);
	DELETE from wl_passage where id_wordlist in (idWordlist);
	DELETE from wl_word where id_wordlist in (idWordlist);
	DELETE from wl_wordlist where id_wordlist in (idWordlist);
	DELETE from section where id_section in (idWordlist);
END 
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure write_debug_msg
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`write_debug_msg`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE write_debug_msg(enabled INTEGER, msg VARCHAR(255))
BEGIN
  IF enabled THEN BEGIN
    INSERT INTO logtable (msg, date_time) SELECT msg, sysdate();
  END; END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure create_cword_grade_level_skills_sections
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`create_cword_grade_level_skills_sections`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`create_cword_grade_level_skills_sections` ()
BEGIN

  -- Declare constants
  DECLARE v_MAX_WORD_LIST_SIZE INTEGER DEFAULT 25;
  -- declare variables
  DECLARE v_finished INTEGER DEFAULT 0;
  DECLARE loop_cntr INT DEFAULT 0;
  DECLARE word_cntr INT DEFAULT 0;
  DECLARE v_new_id_skill BIGINT DEFAULT 0;
  DECLARE v_id_topic BIGINT;
  DECLARE v_prev_id_topic BIGINT DEFAULT 0;
  DECLARE v_topic_name varchar(200);
  DECLARE v_grade varchar(10);
  DECLARE v_word_count int;

  -- declare the cursor
  DECLARE cursor1 CURSOR FOR 
    SELECT t.id_topic AS id_topic, t.name AS topic_name, c.rank AS grade, count(c.id_cword) AS word_count
    FROM topic t INNER JOIN skill s on t.id_topic = s.id_topic INNER JOIN cword c on LOCATE (s.addl_info, c.themes) > 0 
    WHERE s.id_topic in (SELECT id_topic FROM topic WHERE id_level = 101308)
	-- AND s.id_topic = 101308001
    GROUP BY t.id_topic, t.name, c.rank
    ORDER BY 1, 3;
    
  -- declare NOT FOUND handler
  DECLARE CONTINUE HANDLER
    FOR NOT FOUND SET v_finished = 1;

  -- truncate the debug table before getting started with the load
  TRUNCATE TABLE logtable;

  SET @enabled = TRUE;
  call write_debug_msg(@enabled, "Starting execution on create_cword_grade_level_sections");

  -- open the cursor
  OPEN cursor1;   


  -- Fetch in a loop
  get_row: LOOP

	SET loop_cntr = loop_cntr + 1;

    FETCH cursor1 INTO v_id_topic, v_topic_name, v_grade, v_word_count;
    IF v_finished = 1 THEN
        LEAVE get_row;
    END IF;
    -- build email list
	call write_debug_msg(@enabled, CONCAT('v_id_topic: ', v_id_topic));

	IF (v_prev_id_topic <> v_id_topic) THEN 
		SET v_prev_id_topic = v_id_topic;
		SET loop_cntr = 1;
		call write_debug_msg(@enabled, CONCAT('NEW v_id_topic: ', v_id_topic));
	ELSE 
		call write_debug_msg(@enabled, CONCAT('SAME OLD v_id_topic: ', v_id_topic));
    END if;


	SET v_new_id_skill = (v_id_topic * 100) + 20 + loop_cntr;

	call write_debug_msg(@enabled, CONCAT('v_new_id_skill: ', v_new_id_skill));

	-- clean up any remnents from a previous run
	-- DELETE FROM `rulefree`.`skill` WHERE id_skill = v_new_id_skill;
	-- DELETE FROM `rulefree`.`gradeskill` WHERE id_skill = v_new_id_skill;
	

	-- add the skill to the skill table
	INSERT INTO `rulefree`.`skill` (`id_skill`,`id_topic`,`id_provider`,`name`, `addl_info`,`published`,`derived_skill`) 
    VALUES (v_new_id_skill, v_id_topic, 0, CONCAT(v_topic_name, ' - ', v_grade), v_topic_name, 1, 1);

	-- add data to the gradeskill table
    IF (v_grade = 'Grade 1-2') THEN
        INSERT INTO `rulefree`.`gradeskill` (`grade_name`, `id_skill`) VALUES ('I', v_new_id_skill);
        INSERT INTO `rulefree`.`gradeskill` (`grade_name`, `id_skill`) VALUES ('II', v_new_id_skill);
    ELSEIF (v_grade = 'Grade 3') THEN
        INSERT INTO `rulefree`.`gradeskill` (`grade_name`, `id_skill`) VALUES ('III', v_new_id_skill);
    ELSEIF (v_grade = 'Grade 4') THEN
        INSERT INTO `rulefree`.`gradeskill` (`grade_name`, `id_skill`) VALUES ('IV', v_new_id_skill);
    ELSEIF (v_grade = 'Grade 5-6') THEN
        INSERT INTO `rulefree`.`gradeskill` (`grade_name`, `id_skill`) VALUES ('V', v_new_id_skill);
        INSERT INTO `rulefree`.`gradeskill` (`grade_name`, `id_skill`) VALUES ('VI', v_new_id_skill);
    ELSEIF (v_grade = 'Grade 7-8') THEN
        INSERT INTO `rulefree`.`gradeskill` (`grade_name`, `id_skill`) VALUES ('VII', v_new_id_skill);
        INSERT INTO `rulefree`.`gradeskill` (`grade_name`, `id_skill`) VALUES ('VIII', v_new_id_skill);
    ELSEIF (v_grade = 'HighSchool') THEN
        INSERT INTO `rulefree`.`gradeskill` (`grade_name`, `id_skill`) VALUES ('VIII', v_new_id_skill);
	ELSE 
		SELECT v_id_topic, 'Something is Wrong';
    END IF;

	
	IF (v_word_count > 0) THEN 
	  BEGIN
		DECLARE v2_finished INTEGER DEFAULT 0;
		DECLARE loop2_cntr INT DEFAULT 0;
		DECLARE loop2_section_cntr INT DEFAULT 0;
		DECLARE v2_new_id_section BIGINT DEFAULT 0;
		DECLARE v2_new_section_name varchar(200);
		DECLARE v2_id_topic BIGINT;
		DECLARE v2_topic_name varchar(200);
		DECLARE v2_id_cword BIGINT;
		DECLARE v2_cword_name varchar(200);
		DECLARE v2_first_cword_name varchar(200);
		DECLARE v2_last_cword_name varchar(200);

		-- declare the cursor
		DECLARE cursor2 CURSOR FOR 
			SELECT t.id_topic AS id_topic, t.name AS topic_name, c.id_cword AS id_word, c.name AS word_name
			FROM topic t INNER JOIN skill s on t.id_topic = s.id_topic INNER JOIN cword c on LOCATE (s.addl_info, c.themes) > 0 
			WHERE s.id_topic = v_id_topic AND 
				  s.id_skill = v_new_id_skill AND
				c.rank = v_grade
			ORDER BY 1, 3 limit 0, 1000;
			
		-- declare NOT FOUND handler
		DECLARE CONTINUE HANDLER
			FOR NOT FOUND SET v2_finished = 1;

		call write_debug_msg(@enabled, CONCAT('Starting execution on inner loop for: ', v_id_topic));

		-- open the cursor
		OPEN cursor2;   


		-- Fetch in a loop
		SET loop2_cntr = 0;
		SET loop2_section_cntr = 1;
		SET v2_new_id_section = v_new_id_skill * 10000 + loop2_section_cntr;

		get_word: LOOP

			SET loop2_cntr = loop2_cntr + 1;

			FETCH cursor2 INTO v2_id_topic, v2_topic_name, v2_id_cword, v2_cword_name;
			IF v2_finished = 1 THEN
				LEAVE get_word;
			END IF;
			-- copy first word name
		    IF (loop2_cntr = 1) THEN
				SET v2_first_cword_name = v2_cword_name;
			END IF;
			
			-- insert cgradeword
			INSERT INTO `rulefree`.`cgradeword` (`id_section`, `id_cword`) VALUES (v2_new_id_section, v2_id_cword);
			-- Limit the section size to v_MAX_WORD_LIST_SIZE words
			IF (loop2_cntr = v_MAX_WORD_LIST_SIZE) THEN
				-- create and insert a new section
				SET v2_last_cword_name = v2_cword_name;
				SET v2_new_section_name = CONCAT('Section ', loop2_section_cntr, ': ', v2_topic_name, ' Topic Words - (', v2_first_cword_name, ' - ', v2_last_cword_name, ')');
				INSERT INTO `rulefree`.`section` (`id_section`,`id_skill`,`id_provider`,`name`,`is_external`,`section_type`)
								VALUES (v2_new_id_section, v_new_id_skill, 0, v2_new_section_name, 1, 'wr');
				-- reset all counters and numbers
				SET loop2_section_cntr = loop2_section_cntr + 1;
				SET v2_new_id_section = v_new_id_skill * 10000 + loop2_section_cntr;
				SET loop2_cntr = 0;
			END IF;

		END LOOP get_word;
		-- insert into Section table if necessary
		IF (loop2_cntr <> 0) THEN
			SET v2_last_cword_name = v2_cword_name;
			SET v2_new_section_name = CONCAT('Section ', loop2_section_cntr, ': ', v2_topic_name, ' Topic Words - (', v2_first_cword_name, ' - ', v2_last_cword_name, ')');
			INSERT INTO `rulefree`.`section` (`id_section`,`id_skill`,`id_provider`,`name`,`is_external`,`section_type`)
									VALUES (v2_new_id_section, v_new_id_skill, 0, v2_new_section_name, 1, 'wr');
		END IF;
		-- close the cursor
		CLOSE cursor2;


		END;
	END IF;
		
    -- SELECT v_word_count;
    -- SET email_list = CONCAT(v_email,";",email_list);
  END LOOP get_row;

  -- close the cursor
  CLOSE cursor1;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure create_cword_subject_sections
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`create_cword_subject_sections`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`create_cword_subject_sections` ()
BEGIN

  -- Declare constants
  DECLARE v_MAX_WORD_LIST_SIZE INTEGER DEFAULT 25;
  -- declare variables
  DECLARE v_finished INTEGER DEFAULT 0;
  DECLARE loop_cntr INT DEFAULT 0;
  DECLARE v_id_skill BIGINT DEFAULT 0;
  DECLARE v_skill_name varchar(200);
  DECLARE v_skill_key varchar(200);
  DECLARE v_word_count int;

  -- declare the cursor
  DECLARE cursor1 CURSOR FOR 
	SELECT s.id_skill AS id_skill, s.name AS skill_name, s.addl_info AS skill_key, count(c.id_cword) AS word_count
	FROM skill s INNER JOIN cword c on LOCATE (s.addl_info, c.themes) > 0 
		INNER JOIN topic t ON s.id_topic = t.id_topic
	WHERE s.derived_skill = 0 AND
		t.id_level = 101308
	GROUP BY id_skill, skill_name, skill_key
	ORDER BY id_skill;
    
  -- declare NOT FOUND handler
  DECLARE CONTINUE HANDLER
    FOR NOT FOUND SET v_finished = 1;

  -- truncate the debug table before getting started with the load
  TRUNCATE TABLE logtable;

  SET @enabled = TRUE;
  call write_debug_msg(@enabled, "Starting execution on create_cword_subject_sections");

  -- open the cursor
  OPEN cursor1;   


  -- Fetch in a loop
  get_row: LOOP

	SET loop_cntr = loop_cntr + 1;

    FETCH cursor1 INTO v_id_skill, v_skill_name, v_skill_key, v_word_count;
    IF v_finished = 1 THEN
        LEAVE get_row;
    END IF;
    -- build email list
	call write_debug_msg(@enabled, CONCAT('v_skill: ', v_id_skill, ', ', v_skill_name));

	IF (v_word_count > 0) THEN 
	  BEGIN
		DECLARE v2_finished INTEGER DEFAULT 0;
		DECLARE loop2_cntr INT DEFAULT 0;
		DECLARE loop2_section_cntr INT DEFAULT 0;
		DECLARE v2_new_id_section BIGINT DEFAULT 0;
		DECLARE v2_new_section_name varchar(100);
		DECLARE v2_new_section_description varchar(200);
		DECLARE v2_id_cword BIGINT;
		DECLARE v2_cword_name varchar(200);

		DECLARE v2_first_cword_name varchar(200);
		DECLARE v2_last_cword_name varchar(200);

		-- declare the cursor
		DECLARE cursor2 CURSOR FOR 
			SELECT c.id_cword AS id_word, c.name AS word_name
			FROM skill s INNER JOIN cword c on LOCATE (s.addl_info, c.themes) > 0 
			WHERE s.id_skill = v_id_skill
			ORDER BY id_word limit 0, 3000;
			
		-- declare NOT FOUND handler
		DECLARE CONTINUE HANDLER
			FOR NOT FOUND SET v2_finished = 1;

		call write_debug_msg(@enabled, CONCAT('Starting execution on inner loop for: ', v_id_skill));

		-- open the cursor
		OPEN cursor2;   


		-- Fetch in a loop
		SET loop2_cntr = 0;
		SET loop2_section_cntr = 1;
		SET v2_new_id_section = v_id_skill * 10000 + loop2_section_cntr;

		get_word: LOOP

			SET loop2_cntr = loop2_cntr + 1;

			FETCH cursor2 INTO v2_id_cword, v2_cword_name;
			IF v2_finished = 1 THEN
				LEAVE get_word;
			END IF;
			-- copy first word name
		    IF (loop2_cntr = 1) THEN
				SET v2_first_cword_name = v2_cword_name;
			END IF;
			
			-- insert cgradeword
			INSERT INTO `rulefree`.`cgradeword` (`id_section`, `id_cword`) VALUES (v2_new_id_section, v2_id_cword);
			-- Limit the section size to v_MAX_WORD_LIST_SIZE words
			IF (loop2_cntr = v_MAX_WORD_LIST_SIZE) THEN
				-- create and insert a new section
				SET v2_last_cword_name = v2_cword_name;
				SET v2_new_section_name = CONCAT('Section ', loop2_section_cntr, ': ', v_skill_key, ' Skill Words - (', v2_first_cword_name, ' - ', v2_last_cword_name, ')');
				SET v2_new_section_description = CONCAT('Section ', loop2_section_cntr, ': ', v_skill_name, ' Skill Words - (', v2_first_cword_name, ' - ', v2_last_cword_name, ')');
				INSERT INTO `rulefree`.`section` (`id_section`,`id_skill`,`id_provider`,`name`,`description`,`is_external`,`section_type`)
								VALUES (v2_new_id_section, v_id_skill, 0, v2_new_section_name, v2_new_section_description, 1, 'wr');
				-- reset all counters and numbers
				SET loop2_section_cntr = loop2_section_cntr + 1;
				SET v2_new_id_section = v_id_skill * 10000 + loop2_section_cntr;
				SET loop2_cntr = 0;
			END IF;

		END LOOP get_word;
		-- insert into Section table if necessary
		IF (loop2_cntr <> 0) THEN
			SET v2_last_cword_name = v2_cword_name;
			SET v2_new_section_name = CONCAT('Section ', loop2_section_cntr, ': ', v_skill_key, ' Skill Words - (', v2_first_cword_name, ' - ', v2_last_cword_name, ')');
			SET v2_new_section_description = CONCAT('Section ', loop2_section_cntr, ': ', v_skill_name, ' Skill Words - (', v2_first_cword_name, ' - ', v2_last_cword_name, ')');
			INSERT INTO `rulefree`.`section` (`id_section`,`id_skill`,`id_provider`,`name`,`description`,`is_external`,`section_type`)
									VALUES (v2_new_id_section, v_id_skill, 0, v2_new_section_name, v2_new_section_description, 1, 'wr');
		END IF;
		-- close the cursor
		CLOSE cursor2;


		END;
	END IF;
		
    -- SELECT v_word_count;
    -- SET email_list = CONCAT(v_email,";",email_list);
  END LOOP get_row;

  -- close the cursor
  CLOSE cursor1;


END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure update_question_point_counts_time_for_test_old
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`update_question_point_counts_time_for_test_old`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`update_question_point_counts_time_for_test_old` (IN v_idTest BIGINT)
BEGIN

	-- Declare Question and Point count variables at a Test Level
	DECLARE v_finished INTEGER DEFAULT 0;

	DECLARE v_test_point_count INT DEFAULT 0;
	DECLARE v_test_question_count INT DEFAULT 0;
	DECLARE v_test_point_count_for_derived_sections INT DEFAULT 0;
	DECLARE v_test_question_count_for_derived_sections INT DEFAULT 0;
	DECLARE v_test_time_in_minutes INT DEFAULT 0;

	-- Declare Question and Point count variables at a Testsegment Level
	DECLARE v_id_testsegment BIGINT DEFAULT 0;
	DECLARE v_testsegment_question_count INT DEFAULT 0;
	DECLARE v_testsegment_point_count INT DEFAULT 0;
	DECLARE v_testsegment_time_in_minutes INT DEFAULT 0;
	
	-- Declare Question and Point count variables at a Testsection Level
	DECLARE v_id_testsection BIGINT DEFAULT 0;
	DECLARE v_testsection_question_count INT DEFAULT 0;
	DECLARE v_testsection_point_count INT DEFAULT 0;
	
	-- declare the testsegment cursor -- note that union is to account for cases where the sections are derived 
	-- note that Union work Sections can be non-derived (have questions of their own) or derived (no questions on their own) but not both
	DECLARE testsegmentCursor CURSOR FOR 
	  SELECT id_testsegment AS id_testsegment, SUM(question_count) AS question_count, SUM(point_count) AS point_count
	  FROM (
			SELECT tg.id_testsegment AS id_testsegment, COUNT(q.id_question) AS question_count, SUM(IFNULL(q.points, 1)) AS point_count
			FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
				INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
				INNER JOIN section s ON ts.id_section_ref = s.id_section 
				INNER JOIN question  q ON q.id_section = s.id_section
			WHERE t.id_test = v_idTest
			GROUP BY 1
		  UNION
			SELECT tg.id_testsegment AS id_testsegment, COUNT(q.id_question) AS question_count, SUM(IFNULL(q.points, 1)) AS point_count
			FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
				INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
				INNER JOIN section s ON ts.id_section_ref = s.id_section 
				INNER JOIN derived_section_question dsq ON dsq.id_section = s.id_section
				INNER JOIN question q ON dsq.id_question = q.id_question
			WHERE t.id_test = v_idTest
			GROUP BY 1
		) AS union_table
	  GROUP BY id_testsegment;	

		
	-- declare the testsection cursor -- note that union is to account for cases where the sections are derived 
	-- note that Union work Sections can be non-derived (have questions of their own) or derived (no questions on their own) but not both
	DECLARE testsectionCursor CURSOR FOR 
		SELECT ts.id_testsection AS id_testsection, COUNT(q.id_question) AS question_count, SUM(IFNULL(q.points, 1)) AS point_count
		FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
			INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
			INNER JOIN section s ON ts.id_section_ref = s.id_section 
			INNER JOIN question  q ON q.id_section = s.id_section
		WHERE t.id_test = v_idTest
		GROUP BY 1	
	  UNION
		SELECT ts.id_testsection AS id_testsection, COUNT(q.id_question) AS question_count, SUM(IFNULL(q.points, 1)) AS point_count
		FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
			INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
			INNER JOIN section s ON ts.id_section_ref = s.id_section 
			INNER JOIN derived_section_question dsq ON dsq.id_section = s.id_section
			INNER JOIN question q ON dsq.id_question = q.id_question
		WHERE t.id_test = v_idTest
		GROUP BY 1;	
	
	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET v_finished = 1;

	-- Update Question Count, Point count and Time in Minutes at a Test Level
	-- Add point and question counts for derived sections also
	SELECT IFNULL(SUM(IFNULL(q.points, 1)), 0) INTO v_test_point_count
	FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
			INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
			INNER JOIN section s ON ts.id_section_ref = s.id_section 
			INNER JOIN question  q ON q.id_section = s.id_section
	WHERE t.id_test = v_idTest;

	SELECT IFNULL(SUM(IFNULL(q.points, 1)), 0) INTO v_test_point_count_for_derived_sections
	FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
			INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
			INNER JOIN section s ON ts.id_section_ref = s.id_section 
			INNER JOIN derived_section_question dsq ON dsq.id_section = s.id_section
			INNER JOIN question q ON dsq.id_question = q.id_question
	WHERE t.id_test = v_idTest;

	SELECT COUNT(q.id_question) INTO v_test_question_count 
	FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
			INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
			INNER JOIN section s ON ts.id_section_ref = s.id_section 
			INNER JOIN question  q ON q.id_section = s.id_section
	WHERE t.id_test = v_idTest;

	SELECT COUNT(q.id_question) INTO v_test_question_count_for_derived_sections 
	FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
			INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
			INNER JOIN section s ON ts.id_section_ref = s.id_section 
			INNER JOIN derived_section_question dsq ON dsq.id_section = s.id_section
			INNER JOIN question q ON dsq.id_question = q.id_question
	WHERE t.id_test = v_idTest;

	SELECT SUM(ts.time_to_answer) INTO v_test_time_in_minutes 
	FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
			INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
	WHERE t.id_test = v_idTest;

	UPDATE test t
	SET question_count = v_test_question_count + v_test_question_count_for_derived_sections, 
		point_count = v_test_point_count + v_test_point_count_for_derived_sections, 
		time_to_answer = v_test_time_in_minutes
	WHERE t.id_test = v_idTest;


	-- Update Question and Point count at a Testsegment Level
	SET v_finished = 0;

	-- open the cursor
	OPEN testsegmentCursor;   

	-- Fetch in a loop
	get_testsegment: LOOP

		FETCH testsegmentCursor INTO v_id_testsegment, v_testsegment_question_count, v_testsegment_point_count;

		IF v_finished = 1 THEN
			LEAVE get_testsegment;
		END IF;

		SELECT SUM(ts.time_to_answer) INTO v_testsegment_time_in_minutes 
		FROM testsection ts 
		WHERE ts.id_testsegment = v_id_testsegment;

		-- update testsegment
		UPDATE testsegment tg
		SET question_count = v_testsegment_question_count, point_count = v_testsegment_point_count, time_to_answer = v_testsegment_time_in_minutes
		WHERE tg.id_testsegment = v_id_testsegment;

	END LOOP get_testsegment;

	-- close the cursor
	CLOSE testsegmentCursor;


	-- Update Question and Point count at a Testsection Level
	SET v_finished = 0;

	-- open the cursor
	OPEN testsectionCursor;   

	-- Fetch in a loop
	get_testsection: LOOP

		FETCH testsectionCursor INTO v_id_testsection, v_testsection_question_count, v_testsection_point_count;

		IF v_finished = 1 THEN
			LEAVE get_testsection;
		END IF;

		-- update testsection
		UPDATE testsection ts
		SET question_count = v_testsection_question_count, point_count = v_testsection_point_count
		WHERE ts.id_testsection = v_id_testsection;

	END LOOP get_testsection;

	-- close the cursor
	CLOSE testsectionCursor;




END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_test_with_usertests
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_test_with_usertests`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_test_with_usertests` (IN idTest BIGINT, OUT status_code INT, OUT status_message VARCHAR(256))
BEGIN

DECLARE exit handler for sqlexception
  BEGIN
    SET status_code = -1;
    SET status_message = "Fail - SQL Error";
  ROLLBACK;
END;

DECLARE exit handler for sqlwarning
 BEGIN
    SET status_code = -1;
    SET status_message = "Fail - SQL Warning";
 ROLLBACK;
END;

START TRANSACTION;
    DELETE FROM testinstance_detail WHERE id_testinstance_detail > 0 AND id_testinstance IN (SELECT id_testinstance FROM testinstance WHERE id_test IN (idTest)); 
    DELETE FROM testinstance_section WHERE id_testinstance_section > 0 AND id_testinstance IN (SELECT id_testinstance FROM testinstance WHERE id_test IN (idTest)); 
    DELETE FROM testinstance WHERE id_testinstance > 0 AND id_test IN (idTest); 
    DELETE FROM usertestresponse WHERE id_usertestresponse > 0 AND id_usertest IN (SELECT id_usertest FROM usertest WHERE id_test IN (idTest)); 
    DELETE FROM usertest WHERE id_usertest > 0 AND id_test in (idTest); 
    DELETE FROM testsynopsislink WHERE id_testsynopsislink > 0 AND id_testsegment in (select id_testsegment from testsegment where id_test in (idTest));
    DELETE from testsection WHERE id_testsection > 0 AND id_testsegment in (select id_testsegment from testsegment where id_test in (idTest));
    DELETE from testsegment WHERE id_testsegment > 0 AND id_test in (idTest);
    DELETE from test where id_test in (idTest); 
    SET status_code = 0;
    SET status_message = "success";
COMMIT;
END 



$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_test
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_test`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_test` (IN idTest BIGINT, OUT status_code INT, OUT status_message VARCHAR(256))
BEGIN

DECLARE exit handler for sqlexception
  BEGIN
    SET status_code = -1;
    SET status_message = "Fail - SQL Error";
  ROLLBACK;
END;

DECLARE exit handler for sqlwarning
 BEGIN
    SET status_code = -1;
    SET status_message = "Fail - SQL Warning";
 ROLLBACK;
END;

START TRANSACTION;
    DELETE FROM testsynopsislink WHERE id_testsynopsislink > 0 AND id_testsegment in (select id_testsegment from testsegment where id_test in (idTest));
    DELETE FROM testsection WHERE id_testsection > 0 AND id_testsegment in (select id_testsegment from testsegment where id_test in (idTest));
    DELETE FROM testsegment WHERE id_testsegment > 0 AND id_test in (idTest);
    DELETE FROM test WHERE id_test in (idTest); 
    SET status_code = 0;
    SET status_message = "success";
COMMIT;
END 
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_derived_section
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_derived_section`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_derived_section` (IN idDerivedSection BIGINT, OUT status_code INT, OUT status_message VARCHAR(256))
BEGIN

DECLARE exit handler for sqlexception
  BEGIN
	SET status_code = -1;
	SET status_message = "Fail - SQL Error";
  ROLLBACK;
END;

DECLARE exit handler for sqlwarning
 BEGIN
	SET status_code = -1;
	SET status_message = "Fail - SQL Warning";
 ROLLBACK;
END;

START TRANSACTION;
	DELETE from derived_section_question where id_section in (idDerivedSection);
	DELETE from section where id_section in (idDerivedSection) AND section.section_type = 'ds';
	SET status_code = 0;
	SET status_message = "success";
COMMIT;
END
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_questions_for_derivedsection
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_questions_for_derivedsection`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_questions_for_derivedsection` (IN idDerivedSection BIGINT)
BEGIN
	DELETE from derived_section_question where id_section in (idDerivedSection);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure activate_usertest_with_redumption
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`activate_usertest_with_redumption`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`activate_usertest_with_redumption` (IN v_idTest BIGINT, IN v_idUser BIGINT, IN v_redumptionCode VARCHAR(16))
BEGIN

	-- insert a record into usertest table
	INSERT INTO `rulefree`.`usertest`(`id_provider`, `id_test`, `id_user`, `test_type`, `user_type`, `name`, `description`, 
										`test_assignment_date`, `test_status`, `active`)
	SELECT 0, v_idTest, v_idUser, t.test_type, 1, t.`name`, t.description, now(), 'assigned', 1
	FROM test t 
	WHERE t.id_test = v_idTest;

	-- update activation code table
	UPDATE redumption_code ac
	SET ac.current_uses = ac.current_uses + 1 
	WHERE ac.redumption_code = v_redumptionCode;


END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure update_attempt_quality_for_testinstance
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`update_attempt_quality_for_testinstance`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`update_attempt_quality_for_testinstance` (IN v_in_idTestinstance BIGINT)
BEGIN
	-- Declare Question and Point count variables at a Test Level
	DECLARE v_finished INTEGER DEFAULT 0;

	-- Declare count variables at a Testinstance Level
	DECLARE v_test_perfect_attempts_count INT DEFAULT 0;
	DECLARE v_test_inefficient_attempts_count INT DEFAULT 0;
	DECLARE v_test_bad_attempts_count INT DEFAULT 0;
	DECLARE v_test_wasted_attempts_count INT DEFAULT 0;
	DECLARE v_test_attempt_quality DECIMAL(3, 2) DEFAULT 0.00;

	-- Declare count variables at a Testinstance_section Level
	DECLARE v_testsection_perfect_attempts_count INT DEFAULT 0;
	DECLARE v_testsection_inefficient_attempts_count INT DEFAULT 0;
	DECLARE v_testsection_bad_attempts_count INT DEFAULT 0;
	DECLARE v_testsection_wasted_attempts_count INT DEFAULT 0;
	DECLARE v_testsection_attempt_quality DECIMAL(3, 2) DEFAULT 0.00;
	
	-- declare the loop section variable
	DECLARE v_id_testinstance_section BIGINT DEFAULT 0;

	-- Declare curson to get the testinstance_sections in a loop
	DECLARE testinstance_section_Cursor CURSOR FOR 
	  SELECT id_testinstance_section AS id_testinstance_section
	  FROM testinstance_section 
	  WHERE id_testinstance = v_in_idTestinstance;

	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET v_finished = 1;

	-- update at a test level
	SELECT count(*) INTO v_test_perfect_attempts_count FROM testinstance_detail ts WHERE id_testinstance = v_in_idTestinstance and attempt_quality = 4; 
	SELECT count(*) INTO v_test_inefficient_attempts_count FROM testinstance_detail ts WHERE id_testinstance = v_in_idTestinstance and attempt_quality = 3; 
	SELECT count(*) INTO v_test_bad_attempts_count FROM testinstance_detail ts WHERE id_testinstance = v_in_idTestinstance and attempt_quality = 2; 
	SELECT count(*) INTO v_test_wasted_attempts_count FROM testinstance_detail ts WHERE id_testinstance = v_in_idTestinstance and attempt_quality = 1; 
	SELECT CONVERT(sum(attempt_quality)/count(*), DECIMAL(3,2)) INTO v_test_attempt_quality FROM testinstance_detail WHERE id_testinstance = v_in_idTestinstance;
	
	-- update testinstance
	UPDATE testinstance ti
	SET perfect_attempts = v_test_perfect_attempts_count,
		inefficient_attempts = v_test_inefficient_attempts_count,
		bad_attempts = v_test_bad_attempts_count, 
		wasted_attempts = v_test_wasted_attempts_count,
		attempt_quality = v_test_attempt_quality
	WHERE ti.id_testinstance = v_in_idTestinstance;
	
	-- now do the same at the testinstance_section level in a cursor loop
	SET v_finished = 0;

	-- open the cursor
	OPEN testinstance_section_Cursor;   

	-- Fetch in a loop
	get_testinstance_section: LOOP

		FETCH testinstance_section_Cursor INTO v_id_testinstance_section;

		IF v_finished = 1 THEN
			LEAVE get_testinstance_section;
		END IF;

		SELECT count(*) INTO v_testsection_perfect_attempts_count FROM testinstance_detail ts WHERE id_testinstance_section = v_id_testinstance_section and attempt_quality = 4; 
		SELECT count(*) INTO v_testsection_inefficient_attempts_count FROM testinstance_detail ts WHERE id_testinstance_section = v_id_testinstance_section and attempt_quality = 3; 
		SELECT count(*) INTO v_testsection_bad_attempts_count FROM testinstance_detail ts WHERE id_testinstance_section = v_id_testinstance_section and attempt_quality = 2; 
		SELECT count(*) INTO v_testsection_wasted_attempts_count FROM testinstance_detail ts WHERE id_testinstance_section = v_id_testinstance_section and attempt_quality = 1; 
		SELECT CONVERT(sum(attempt_quality)/count(*), DECIMAL(3,2)) INTO v_testsection_attempt_quality FROM testinstance_detail WHERE id_testinstance_section = v_id_testinstance_section;

		-- update testinstance_section
		UPDATE testinstance_section tis
		SET perfect_attempts = v_testsection_perfect_attempts_count,
			inefficient_attempts = v_testsection_inefficient_attempts_count,
			bad_attempts = v_testsection_bad_attempts_count, 
			wasted_attempts = v_testsection_wasted_attempts_count,
			attempt_quality = v_testsection_attempt_quality
		WHERE tis.id_testinstance_section = v_id_testinstance_section;

	END LOOP get_testinstance_section;
	
	-- close the cursor
	CLOSE testinstance_section_Cursor;


END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure activate_usertest_for_free
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`activate_usertest_for_free`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`activate_usertest_for_free` (IN v_idTest BIGINT, IN v_idUser BIGINT, OUT v_status TEXT)
BEGIN

	DECLARE v_test_is_free INT DEFAULT 0;
	DECLARE v_test_in_free_period INT DEFAULT 0;
	DECLARE v_user_has_channel_subscription INT DEFAULT 0;

	-- is the test marked free (for turely free tests)
	SELECT IFNULL(t.is_free, 0) INTO v_test_is_free 
		FROM test t WHERE t.id_test = v_idTest; 
	
	-- is the test currently offered for free (for a promotion)
	SELECT IFNULL((ta.date_free_start <= Now() AND ta.date_free_end >= Now()), 0) INTO v_test_in_free_period
		FROM test t LEFT JOIN testalias ta ON t.id_test = ta.id_test WHERE t.id_test = v_idTest; 
	
	-- Does the user have channel subscriptions to the examtract the test belongs to?
	SELECT COUNT(*) > 0 INTO v_user_has_channel_subscription
		FROM system s LEFT JOIN channel_subscriptions cs ON s.id_system = cs.id_channel
				LEFT JOIN channel_examtrack ce ON s.id_system = ce.id_channel
				LEFT JOIN test t ON t.examtrack = ce.examtrack
		WHERE t.id_test = v_idTest AND cs.id_student = v_idUser AND cs.start_date <= NOW() AND cs.end_date >= NOW();


	IF (v_test_is_free = 1 OR (v_test_in_free_period = 1 AND v_user_has_channel_subscription = 1)) THEN
		BEGIN
			-- insert a record into usertest table
			INSERT INTO `rulefree`.`usertest`(`id_provider`, `id_test`, `id_user`, `test_type`, `user_type`, `name`, `description`, 
												`test_assignment_date`, `test_status`, `active`)
			SELECT 0, v_idtest, v_idUser, t.test_type, 1, t.`name`, t.description, now(), 'assigned', 1
			FROM test t 
			WHERE t.id_test = v_idtest;
		END;
	ELSEIF (v_test_in_free_period = 0) THEN
		BEGIN
			SELECT 'Test is not marked free.  Please purchase the test or enter a valid Activation Code.' INTO v_status;
		END;
	ELSEIF (v_user_has_channel_subscription = 0) THEN
		BEGIN
			SELECT 'Test is Free only for Channel Subscribers.  Please Subscribe to the Channel or enter a valid Activation Code.' INTO v_status;
		END;
	ELSE
		BEGIN
			SELECT 'Please purchase the test or enter a valid Activation Code.' INTO v_status;
		END;
	END IF;


END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure update_question_point_counts_time_for_test
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`update_question_point_counts_time_for_test`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`update_question_point_counts_time_for_test` (IN v_idTest BIGINT)
BEGIN

	-- Declare Question and Point count variables at a Test Level
	DECLARE v_finished INTEGER DEFAULT 0;

	DECLARE v_test_point_count INT DEFAULT 0;
	DECLARE v_test_question_count INT DEFAULT 0;
	DECLARE v_test_time_in_minutes INT DEFAULT 0;

	-- Declare Question and Point count variables at a Testsegment Level
	DECLARE v_id_testsegment BIGINT DEFAULT 0;
	DECLARE v_testsegment_question_count INT DEFAULT 0;
	DECLARE v_testsegment_point_count INT DEFAULT 0;
	DECLARE v_testsegment_time_in_minutes INT DEFAULT 0;
	
	-- Declare Question and Point count variables at a Testsection Level
	DECLARE v_id_testsection BIGINT DEFAULT 0;
	DECLARE v_testsection_question_count INT DEFAULT 0;
	
	-- declare the testsection cursor -- note that union is to account for cases where the sections are derived 
	-- note that Union work Sections can be non-derived (have questions of their own) or derived (no questions on their own) but not both
	DECLARE testsectionCursor CURSOR FOR 
		SELECT ts.id_testsection AS id_testsection, COUNT(q.id_question) AS question_count
		FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
			INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
			INNER JOIN section s ON ts.id_section_ref = s.id_section 
			INNER JOIN question  q ON q.id_section = s.id_section
		WHERE t.id_test = v_idTest
		GROUP BY 1	
	  UNION
		SELECT ts.id_testsection AS id_testsection, COUNT(q.id_question) AS question_count
		FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
			INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
			INNER JOIN section s ON ts.id_section_ref = s.id_section 
			INNER JOIN derived_section_question dsq ON dsq.id_section = s.id_section
			INNER JOIN question q ON dsq.id_question = q.id_question
		WHERE t.id_test = v_idTest
		GROUP BY 1;	
	
	-- declare the testsegment cursor 
	DECLARE testsegmentCursor CURSOR FOR 
		SELECT tg.id_testsegment AS id_testsegment, SUM(ts.question_count) AS question_count, SUM(ts.point_count) AS point_count, SUM(ts.time_to_answer) as time_to_answer
		FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
			INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
		WHERE t.id_test = v_idTest
		GROUP BY 1;

		
	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET v_finished = 1;


	-- Update Question and Point count at a Testsection Level
	SET v_finished = 0;
	-- open the cursor
	OPEN testsectionCursor;   
	-- Fetch in a loop
	get_testsection: LOOP
		FETCH testsectionCursor INTO v_id_testsection, v_testsection_question_count;
		IF v_finished = 1 THEN
			LEAVE get_testsection;
		END IF;
		-- update testsection
		UPDATE testsection ts
		SET question_count = v_testsection_question_count, point_count = IFNULL(ts.points_per_question, 1.0) * v_testsection_question_count
		WHERE ts.id_testsection = v_id_testsection;
	END LOOP get_testsection;
	-- close the cursor
	CLOSE testsectionCursor;


	-- Update Question and Point count at a Testsegment Level
	SET v_finished = 0;
	-- open the cursor
	OPEN testsegmentCursor;   
	-- Fetch in a loop
	get_testsegment: LOOP
		FETCH testsegmentCursor INTO v_id_testsegment, v_testsegment_question_count, v_testsegment_point_count, v_testsegment_time_in_minutes;
		IF v_finished = 1 THEN
			LEAVE get_testsegment;
		END IF;
		-- update testsegment
		UPDATE testsegment tg
		SET question_count = v_testsegment_question_count, point_count = v_testsegment_point_count, time_to_answer = v_testsegment_time_in_minutes
		WHERE tg.id_testsegment = v_id_testsegment;
	END LOOP get_testsegment;
	-- close the cursor
	CLOSE testsegmentCursor;


	-- Update Question Count, Point count and Time in Minutes at a Test Level
	SELECT SUM(ts.time_to_answer) INTO v_test_time_in_minutes
	FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
			INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
	WHERE t.id_test = v_idTest;

	SELECT SUM(ts.question_count) INTO v_test_question_count
	FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
			INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
	WHERE t.id_test = v_idTest;

	SELECT SUM(ts.point_count) INTO v_test_point_count
	FROM test t INNER JOIN testsegment tg ON tg.id_test = t.id_test
			INNER JOIN testsection ts ON ts.id_testsegment = tg.id_testsegment
	WHERE t.id_test = v_idTest;

	UPDATE test t
	SET question_count = v_test_question_count, point_count = v_test_point_count, time_to_answer = v_test_time_in_minutes
	WHERE t.id_test = v_idTest;


END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_system
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_system`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_system` (IN idSystem BIGINT)
BEGIN
DELETE from answer where id_question in (
	select id_question from question where id_section in (
		select id_section from section where id_skill in (
			select id_skill from skill where id_topic in (
				select id_topic from topic where id_level in (
					select id_level from level where id_system in (idSystem))))));

DELETE from question where id_section in (
	select id_section from section where id_skill in (
		select id_skill from skill where id_topic in (
			select id_topic from topic where id_level in (
				select id_level from level where id_system in (idSystem)))));

DELETE from wl_passage where id_wordlist in (
	select id_section from section where id_skill in (
		select id_skill from skill where id_topic in (
			select id_topic from topic where id_level in (
				select id_level from level where id_system in (idSystem)))));
DELETE from wl_word where id_wordlist in (
	select id_section from section where id_skill in (
		select id_skill from skill where id_topic in (
			select id_topic from topic where id_level in (
				select id_level from level where id_system in (idSystem)))));
DELETE from wl_wordlist where id_wordlist in (
	select id_section from section where id_skill in (
		select id_skill from skill where id_topic in (
			select id_topic from topic where id_level in (
				select id_level from level where id_system in (idSystem)))));

DELETE from section where id_skill in (
	select id_skill from skill where id_topic in (
		select id_topic from topic where id_level in (
			select id_level from level where id_system in (idSystem))));
DELETE from gradeskill where id_skill in (
	select id_skill from skill where id_topic in (
		select id_topic from topic where id_level in (
			select id_level from level where id_system in (idSystem))));
DELETE from skill where id_topic in (
	select id_topic from topic where id_level in (
		select id_level from level where id_system in (idSystem)));
DELETE from topic where id_level in (
	select id_level from level where id_system in (idSystem));

DELETE from `level` where id_system in (idSystem);

END 
$$

DELIMITER ;

-- -----------------------------------------------------
-- function get_new_test_id
-- -----------------------------------------------------

USE `rulefree`;
DROP function IF EXISTS `rulefree`.`get_new_test_id`;

DELIMITER $$
USE `rulefree`$$
CREATE FUNCTION get_new_test_id()
  RETURNS BIGINT
BEGIN
	DECLARE new_id_test BIGINT;
	UPDATE `rulefree`.`sequence` SET `current` = last_insert_id(`current`+1) WHERE `key`='test';
	SELECT last_insert_id() INTO new_id_test;
	RETURN new_id_test;
END;
$$

DELIMITER ;

-- -----------------------------------------------------
-- function get_new_testsegment_id
-- -----------------------------------------------------

USE `rulefree`;
DROP function IF EXISTS `rulefree`.`get_new_testsegment_id`;

DELIMITER $$
USE `rulefree`$$
CREATE FUNCTION get_new_testsegment_id()
  RETURNS BIGINT
BEGIN
	DECLARE new_id_testsegment BIGINT;
	UPDATE `rulefree`.`sequence` SET `current` = last_insert_id(`current`+1) WHERE `key`='testsegment';
	SELECT last_insert_id() INTO new_id_testsegment;
	RETURN new_id_testsegment;
END;
$$

DELIMITER ;

-- -----------------------------------------------------
-- function get_new_testsection_id
-- -----------------------------------------------------

USE `rulefree`;
DROP function IF EXISTS `rulefree`.`get_new_testsection_id`;

DELIMITER $$
USE `rulefree`$$
CREATE FUNCTION get_new_testsection_id()
  RETURNS BIGINT
BEGIN
	DECLARE new_id_testsection BIGINT;
	UPDATE `rulefree`.`sequence` SET `current` = last_insert_id(`current`+1) WHERE `key`='testsection';
	SELECT last_insert_id() INTO new_id_testsection;
	RETURN new_id_testsection;
END;
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure change_test_id
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`change_test_id`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`change_test_id` (IN v_idTestOld BIGINT, IN v_idTestNew BIGINT, OUT status_code INT, OUT status_message VARCHAR(256))
main_procedure: BEGIN

	DECLARE v_old_test_count INT DEFAULT 0;
	DECLARE v_idTestsegmentOld BIGINT DEFAULT 0;
	DECLARE v_idTestsegmentNew BIGINT DEFAULT 0;
	DECLARE v_idTestsectionOld BIGINT DEFAULT 0;
	DECLARE v_idTestsectionNew BIGINT DEFAULT 0;
	DECLARE tg_loop_cntr INT DEFAULT 0;
	DECLARE ts_loop_cntr INT DEFAULT 0;

	DECLARE v_segment_finished INT DEFAULT FALSE;

	-- declare the testsegment cursor
	DECLARE cursor_testsegment CURSOR FOR 
		SELECT tg.id_testsegment AS id_testsegment
		FROM testsegment tg 
		WHERE tg.id_test = v_idTestOld
		ORDER BY 1;
    
    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET v_segment_finished = TRUE;

	DECLARE exit handler for sqlexception
		BEGIN
			SET status_code = -1;
			SET status_message = "Fail - SQL Error";
			ROLLBACK;
		END;

	DECLARE exit handler for sqlwarning
		BEGIN
			SET status_code = -1;
			SET status_message = "Fail - SQL Warning";
			ROLLBACK;
		END;

	-- truncate the debug table before getting started with the load
	TRUNCATE TABLE logtable;

	SET @enabled = TRUE;
	call write_debug_msg(@enabled, CONCAT('Starting execution on change_test_id. ', v_idTestOld, ' to ', v_idTestNew));

    -- See if a test exists with the old testid
    SELECT COUNT(*) INTO v_old_test_count 
    FROM test t 
    WHERE id_test = v_idTestOld;
    
    IF (v_old_test_count = 0) THEN 
        SET status_code = -1;
        SET status_message = CONCAT('Test Missing: ', v_idTestOld);
        call write_debug_msg(@enabled, status_message);
        LEAVE main_procedure;
    ELSE 
        call write_debug_msg(@enabled, CONCAT('Test Found.  Will Change it... ', v_idTestOld));
    END if;


	START TRANSACTION;

	-- open the cursor
	OPEN cursor_testsegment;   

	-- initialize loop variables
	SET tg_loop_cntr = 0;
	  
	-- Fetch in a loop
	get_testsegment: LOOP

		SET tg_loop_cntr = tg_loop_cntr + 1;

		FETCH cursor_testsegment INTO v_idTestsegmentOld;
		IF v_segment_finished THEN
			LEAVE get_testsegment;
		END IF;

		-- create the new id_testsegment
		SET v_idTestsegmentNew = v_idTestNew * 100 + tg_loop_cntr;
		call write_debug_msg(@enabled, CONCAT('Change Old v_idTestsegmentOld. ', v_idTestsegmentOld, ' to New v_idTestsegmentNew ', v_idTestsegmentNew));
		

		BLOCK2: BEGIN
			DECLARE v_section_finished INT DEFAULT FALSE;
			-- declare the testsection cursor
			DECLARE cursor_testsection CURSOR FOR 
				SELECT ts.id_testsection AS id_testsection
				FROM testsection ts 
				WHERE ts.id_testsegment = v_idTestsegmentOld
				ORDER BY 1;
		
			-- declare NOT FOUND handler
			DECLARE CONTINUE HANDLER
				FOR NOT FOUND SET v_section_finished = TRUE;

			-- open the cursor
			OPEN cursor_testsection;   

			-- initialize loop variables
			SET ts_loop_cntr = 0;

			-- Fetch in a loop
			get_testsection: LOOP

				SET ts_loop_cntr = ts_loop_cntr + 1;

				FETCH cursor_testsection INTO v_idTestsectionOld;
				IF v_section_finished THEN
					LEAVE get_testsection;
				END IF;

				SET v_idTestsectionNew = v_idTestsegmentNew * 100 + ts_loop_cntr;
				call write_debug_msg(@enabled, CONCAT('Change Old v_idTestsectionOld. ', v_idTestsectionOld, ' to New v_idTestsectionNew ', v_idTestsectionNew));

				-- Update idTestsection statement.  
				UPDATE testsection SET id_testsection = v_idTestsectionNew
				WHERE id_testsection = v_idTestsectionOld;

				call write_debug_msg(@enabled, CONCAT('Update Section Successful. to New v_idTestsectionNew ', v_idTestsectionNew));

			END LOOP get_testsection;
		END BLOCK2;
			
		-- now update the testsegment
		-- Update idTestsegment statement.  
		UPDATE testsegment SET id_testsegment = v_idTestsegmentNew
		WHERE id_testsegment = v_idTestsegmentOld;

		call write_debug_msg(@enabled, CONCAT('Update Segment Successful. to New v_idTestsegmentNew ', v_idTestsegmentNew));

	END LOOP get_testsegment;
			
	-- Update idTest statement.  This should also set the new Id on the testsegment due to FK being cascade on update
	UPDATE test SET id_test = v_idTestNew
	WHERE id_test = v_idTestOld;

	call write_debug_msg(@enabled, CONCAT('Update Test Successful. to New v_idTestNew ', v_idTestNew));

	COMMIT;

	SET status_code = 0;
	SET status_message = "Success!";

END main_procedure;

$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure update_topic_skill_counts
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`update_topic_skill_counts`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`update_topic_skill_counts` ()
BEGIN

    -- Declare Question and Point count variables at a Test Level
    DECLARE v_finished INTEGER DEFAULT 0;

    DECLARE v_id_level BIGINT DEFAULT 0;
    DECLARE v_topiccount INT DEFAULT 0;
    DECLARE v_skillcount INT DEFAULT 0;

    -- declare the testsegment cursor 
/*	This does not calculate skill_counts when a topic is referred...
		DECLARE levelWithCountsCursor CURSOR FOR 
		SELECT l.id_level, 
				count(distinct t.id_topic) AS topiccount, 
				count(distinct s.id_skill) AS skillcount 
		FROM level l LEFT JOIN topic t on t.id_level = l.id_level LEFT JOIN skill s ON s.id_topic = t.id_topic
		GROUP BY l.id_level;
*/
-- Include counts from referred topics 
    DECLARE levelWithCountsCursor CURSOR FOR 
		SELECT l.id_level, 
				count(distinct t.id_topic) AS topiccount, 
				count(distinct s.id_skill)  + count(distinct s2.id_skill) AS skillcount 
		FROM level l LEFT JOIN topic t on t.id_level = l.id_level 
					LEFT JOIN skill s ON s.id_topic = t.id_topic
					LEFT JOIN skill s2 ON s2.id_topic = t.id_topic_reference
		GROUP BY l.id_level;

    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET v_finished = 1;

    -- Update skill and topic counts for each level
    SET v_finished = 0;
    -- open the cursor
    OPEN levelWithCountsCursor;   
    -- Fetch in a loop
    get_level: LOOP
        FETCH levelWithCountsCursor INTO v_id_level, v_topiccount, v_skillcount;
        IF v_finished = 1 THEN
            LEAVE get_level;
        END IF;
        -- update testsection
        UPDATE level l
        SET l.topiccount = v_topiccount, l.skillcount = v_skillcount
        WHERE l.id_level = v_id_level;

    END LOOP get_level;
    -- close the cursor
    CLOSE levelWithCountsCursor;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- function get_new_crc_create_sequence
-- -----------------------------------------------------

USE `rulefree`;
DROP function IF EXISTS `rulefree`.`get_new_crc_create_sequence`;

DELIMITER $$
USE `rulefree`$$
CREATE FUNCTION get_new_crc_create_sequence(id_crc_type INT)
  RETURNS INT
BEGIN
	DECLARE new_crc_create_sequence INT;
	UPDATE `rulefree`.`sequence_channel_redumption_code` SET `create_current` = last_insert_id(`create_current`+1) WHERE `id_channel_redumption_code_type`= id_crc_type;
	SELECT last_insert_id() INTO new_crc_create_sequence;
	RETURN new_crc_create_sequence;
END;
$$

DELIMITER ;

-- -----------------------------------------------------
-- function get_new_crc_assign_sequence
-- -----------------------------------------------------

USE `rulefree`;
DROP function IF EXISTS `rulefree`.`get_new_crc_assign_sequence`;

DELIMITER $$
USE `rulefree`$$
CREATE FUNCTION get_new_crc_assign_sequence(id_crc_type INT)
  RETURNS INT
BEGIN
	DECLARE new_crc_assign_sequence INT;
	UPDATE `rulefree`.`sequence_channel_redumption_code` SET `assign_current` = last_insert_id(`assign_current`+1) WHERE `id_channel_redumption_code_type`= id_crc_type;
	SELECT last_insert_id() INTO new_crc_assign_sequence;
	RETURN new_crc_assign_sequence;
END;
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_profile
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_profile`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_profile` (IN idProfile BIGINT, OUT status_code INT, OUT status_message VARCHAR(256))
BEGIN

DECLARE exit handler for sqlexception
  BEGIN
    SET status_code = -1;
    SET status_message = "Fail - SQL Error";
  ROLLBACK;
END;

DECLARE exit handler for sqlwarning
 BEGIN
    SET status_code = -1;
    SET status_message = "Fail - SQL Warning";
 ROLLBACK;
END;

START TRANSACTION;
    DELETE FROM profiletest WHERE id_profiletest > 0 AND id_profilesegment in (select id_profilesegment from profilesegment where id_profile in (idProfile));
    DELETE FROM profilesegment WHERE id_profilesegment > 0 AND id_profile in (idProfile);
    DELETE FROM `profile` WHERE id_profile in (idProfile); 
    SET status_code = 0;
    SET status_message = "success";
COMMIT;
END 
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_profilesegments_for_profile
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`delete_profilesegments_for_profile`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`delete_profilesegments_for_profile` (IN idProfile BIGINT, OUT status_code INT, OUT status_message VARCHAR(256))
BEGIN

DECLARE exit handler for sqlexception
  BEGIN
    SET status_code = -1;
    SET status_message = "Fail - SQL Error";
  ROLLBACK;
END;

DECLARE exit handler for sqlwarning
 BEGIN
    SET status_code = -1;
    SET status_message = "Fail - SQL Warning";
 ROLLBACK;
END;

START TRANSACTION;
    DELETE FROM profiletest WHERE id_profiletest > 0 AND id_profilesegment in (select id_profilesegment from profilesegment where id_profile in (idProfile));
    DELETE FROM profilesegment WHERE id_profilesegment > 0 AND id_profile in (idProfile);
    SET status_code = 0;
    SET status_message = "success";
COMMIT;
END 
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure update_user_profile_test
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`update_user_profile_test`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`update_user_profile_test` (IN in_idUserprofile BIGINT, IN in_action INT, OUT out_status_code INT, OUT out_status_message VARCHAR(256))
BEGIN

DECLARE exit handler for sqlexception
  BEGIN
    SET out_status_code = -1;
    SET out_status_message = "Fail - SQL Error";
  ROLLBACK;
END;

DECLARE exit handler for sqlwarning
 BEGIN
    SET out_status_code = -1;
    SET out_status_message = "Fail - SQL Warning";
 ROLLBACK;
END;


START TRANSACTION;
-- 1= insert, 2 = delete, 3 = update
IF (in_action = 1) THEN

    INSERT INTO `userprofiletest` (`id_userprofile`, `id_profiletest`, `test_provision_date`, `test_removal_date`, `active`) 
    SELECT      up.id_userprofile, 
                pt.id_profiletest, 
                (CASE 
                   WHEN p.profile_type = 1 THEN pt.test_provision_date
                   WHEN p.profile_type = 2 THEN ADDDATE(up.profile_start_date, INTERVAL pt.test_provision_day DAY)
                   ELSE up.profile_start_date
                 END) AS test_provision_date, 
                (CASE 
                   WHEN p.profile_type = 1 THEN pt.test_removal_date
                   WHEN p.profile_type = 2 THEN ADDDATE(up.profile_start_date, INTERVAL pt.test_removal_day DAY)
                   ELSE null
                 END) AS test_removal_date,
                (CASE 
                   WHEN p.profile_type = 1 THEN 1
                   WHEN p.profile_type = 2 THEN 1 
                   ELSE pt.initial_active
                 END) AS active
    FROM userprofile up LEFT JOIN profile p ON p.id_profile = up.id_profile
                LEFT JOIN profilesegment ps ON ps.id_profile = up.id_profile
                LEFT JOIN profiletest pt ON pt.id_profilesegment = ps.id_profilesegment
     WHERE up.id_userprofile = in_idUserprofile;

ELSEIF (in_action = 2) THEN

    DELETE FROM `userprofiletest` 
    WHERE id_userprofiletest > 0 AND 
          id_userprofile = in_idUserprofile;

ELSEIF (in_action = 3) THEN

    UPDATE userprofiletest upt LEFT JOIN profiletest pt ON upt.id_profiletest = pt.id_profiletest
							 LEFT JOIN profilesegment ps ON pt.id_profilesegment = ps.id_profilesegment
							 LEFT JOIN profile p ON ps.id_profile = p.id_profile
							 LEFT JOIN userprofile up ON upt.id_userprofile =  up.id_userprofile
    SET     upt.test_provision_date = 
                (CASE 
                    WHEN p.profile_type = 1 THEN pt.test_provision_date
                    WHEN p.profile_type = 2 THEN ADDDATE(up.profile_start_date, INTERVAL pt.test_provision_day DAY)
                    ELSE up.profile_start_date
                 END),
            upt.test_removal_date = 
                (CASE
                    WHEN p.profile_type = 1 THEN pt.test_removal_date
                    WHEN p.profile_type = 2 THEN ADDDATE(up.profile_start_date, INTERVAL pt.test_removal_day DAY)
                    ELSE null
                END),
            upt.active = 
                (CASE 
                   WHEN p.profile_type = 1 THEN 1
                   WHEN p.profile_type = 2 THEN 1 
                   ELSE pt.initial_active
                 END)
    WHERE up.id_userprofile = in_idUserprofile;

-- ELSE 
    -- nothing to do here
END IF;

SET out_status_code = 0;
SET out_status_message = "success";



COMMIT;
END 

$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure userprofiletest_to_usertest_mover
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`userprofiletest_to_usertest_mover`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`userprofiletest_to_usertest_mover` (OUT v_rows_inserted INT, OUT v_rows_updated INT, OUT v_rows_deleted INT, OUT out_status_code INT, OUT out_status_message VARCHAR(256))
BEGIN

    -- declare variables
    DECLARE v_timestamp TIMESTAMP;

    -- declare cursor variables
    DECLARE v_id_provider BIGINT DEFAULT 0;
    DECLARE v_id_test BIGINT DEFAULT 0;
    DECLARE v_id_user BIGINT DEFAULT 0;
    DECLARE v_id_profile BIGINT DEFAULT 0;
    DECLARE v_test_type varchar(45);
    DECLARE v_user_type INT DEFAULT 1;
    DECLARE v_name varchar(100);
    DECLARE v_description varchar(200);
    DECLARE v_test_assignment_date TIMESTAMP;
    DECLARE v_test_status varchar(45);
    DECLARE v_id_profiletest BIGINT DEFAULT 0;
    DECLARE v_profile_name varchar(100);
    DECLARE v_profilesegment_name varchar(100);

    -- cursor exit variable
    DECLARE v_finished INTEGER DEFAULT 0;
  
    -- Temp variable to see if the row exists
    DECLARE v_exists INT DEFAULT 0;


    -- declare the cursor
    DECLARE cursor1 CURSOR FOR 
        SELECT  up.id_provider AS id_provider, 
                t.id_test AS id_test, 
                up.id_student AS id_user, 
                up.id_profile AS id_profile, 
                t.test_type AS test_type, 
                1 AS user_type, 
                pt.`name` AS `name`, 
                pt.description AS description, 
                upt.test_provision_date AS test_assignment_date, 
                'assigned' AS test_status,
                upt.id_profiletest AS id_profiletest, 
                p.`name` AS profile_name, 
                ps.`name` AS profilesegment_name
        FROM userprofiletest upt LEFT JOIN userprofile up ON upt.id_userprofile = up.id_userprofile
                                 LEFT JOIN profiletest pt ON upt.id_profiletest = pt.id_profiletest
                                 LEFT JOIN profilesegment ps ON pt.id_profilesegment = ps.id_profilesegment
                                 LEFT JOIN profile p ON ps.id_profile = p.id_profile
                                 LEFT JOIN test t ON pt.id_test_ref = t.id_test
        WHERE upt.test_provision_date < v_timestamp AND upt.active = 1;



    -- Error/exception handlers
    DECLARE exit handler for sqlexception
    BEGIN
        ROLLBACK;
        SET out_status_code = -1;
        SET out_status_message = "Fail - SQL Error";
    END;

    DECLARE exit handler for sqlwarning
    BEGIN
        ROLLBACK;
        SET out_status_code = -1;
        SET out_status_message = "Fail - SQL Warning";
    END;


    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET v_finished = 1;

    -- Initialize the return values
    SET v_rows_inserted = 0;
    SET v_rows_updated = 0;
    SET v_rows_deleted = 0;

    -- do everything in a transaction
    START TRANSACTION;

    -- Get the current date
    SELECT ADDDATE(now(), INTERVAL 1 DAY) INTO v_timestamp;


    -- open the cursor
    OPEN cursor1;   


    -- Fetch in a loop
    get_row: LOOP

        FETCH cursor1 INTO  v_id_provider, 
                            v_id_test, 
                            v_id_user, 
                            v_id_profile, 
                            v_test_type, 
                            v_user_type, 
                            v_name, 
                            v_description, 
                            v_test_assignment_date, 
                            v_test_status,
                            v_id_profiletest, 
                            v_profile_name, 
                            v_profilesegment_name;

        IF v_finished = 1 THEN
            LEAVE get_row;
        END IF;

        SELECT COUNT(*) INTO v_exists 
        FROM usertest 
        WHERE id_test = v_id_test AND id_user = v_id_user AND id_profile = v_id_profile;

        IF (v_exists = 0) THEN 
        
        -- if the key values do not exist in the usertest table, then insert them
            INSERT INTO `usertest`(`id_provider`, `id_test`, `id_user`, `id_profile`, `test_type`, `user_type`, `name`, `description`, `test_assignment_date`, `test_status`, `id_profiletest`, `profile_name`, `profilesegment_name`)
            VALUES (
                v_id_provider,
                v_id_test,
                v_id_user,
                v_id_profile,
                v_test_type,
                v_user_type,
                v_name,
                v_description,
                v_test_assignment_date,
                v_test_status,
                v_id_profiletest, 
                v_profile_name, 
                v_profilesegment_name );
            
            SET v_rows_inserted = v_rows_inserted + 1;

        ELSE 
        
        -- if the key values exist in the usertest table, then simply update the values with the new times etc.    
            UPDATE `usertest` 
            SET `id_provider` = v_id_provider,
                `test_type` = v_test_type,
                `name` = v_name,
                `description` = v_description,
                `test_assignment_date` = v_test_assignment_date, 
                `id_profiletest` = v_id_profiletest, 
                `profile_name` = v_profile_name, 
                `profilesegment_name` = v_profilesegment_name
            WHERE id_test = v_id_test AND id_user = v_id_user AND id_profile = v_id_profile;
            
            SET v_rows_updated = v_rows_updated + 1;

        END if;

    END LOOP get_row;
  
    -- close the cursor
    CLOSE cursor1;

    -- Next delete the corresponding userprofiletest records from the userprofiletest table
    DELETE upt 
    FROM `userprofiletest` upt LEFT JOIN userprofile up ON upt.id_userprofile =  up.id_userprofile
                            LEFT JOIN profile p ON p.id_profile = up.id_profile AND p.profile_type IN (1, 2)
    WHERE   upt.test_provision_date < v_timestamp AND upt.active = 1;

    SELECT ROW_COUNT() INTO v_rows_deleted;

    COMMIT;

    -- indicate success status
    SET out_status_code = 0;
    SET out_status_message = "success";

END 

$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure write_eventlog_msg
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`write_eventlog_msg`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.write_eventlog_msg (enabled INTEGER, event_type VARCHAR(45), msg VARCHAR(255))
	BEGIN
		IF enabled THEN 
			BEGIN
				INSERT INTO `rulefree`.`eventlog` (event_type, msg, date_time) SELECT event_type, msg, sysdate();
			END; 
		END IF;
    END 
    $$

DELIMITER ;

-- -----------------------------------------------------
-- procedure change_profile_id
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`change_profile_id`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`change_profile_id` (IN v_idProfileOld BIGINT, IN v_idProfileNew BIGINT, OUT status_code INT, OUT status_message VARCHAR(256))
main_procedure: BEGIN

    DECLARE v_old_profile_count INT DEFAULT 0;
    DECLARE v_idProfilesegmentOld BIGINT DEFAULT 0;
    DECLARE v_idProfilesegmentNew BIGINT DEFAULT 0;
    DECLARE v_idProfiletestOld BIGINT DEFAULT 0;
    DECLARE v_idProfiletestNew BIGINT DEFAULT 0;
    DECLARE pg_loop_cntr INT DEFAULT 0;
    DECLARE pt_loop_cntr INT DEFAULT 0;

    DECLARE v_segment_finished INT DEFAULT FALSE;

    -- declare the profilesegment cursor
    DECLARE cursor_profilesegment CURSOR FOR 
        SELECT pg.id_profilesegment AS id_profilesegment
        FROM profilesegment pg 
        WHERE pg.id_profile = v_idProfileOld
        ORDER BY 1;
    
    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET v_segment_finished = TRUE;

    DECLARE exit handler for sqlexception
        BEGIN
            SET status_code = -1;
            SET status_message = "Fail - SQL Error";
            ROLLBACK;
        END;

    DECLARE exit handler for sqlwarning
        BEGIN
            SET status_code = -1;
            SET status_message = "Fail - SQL Warning";
            ROLLBACK;
        END;

    -- truncate the debug table before getting started with the load
    TRUNCATE TABLE logtable;

    SET @enabled = TRUE;
    call write_debug_msg(@enabled, CONCAT('Starting execution on change_profile_id. ', v_idProfileOld, ' to ', v_idProfileNew));

    -- See if a profile exists with the old profileid
    SELECT COUNT(*) INTO v_old_profile_count 
    FROM profile p 
    WHERE id_profile = v_idProfileOld;
    
    IF (v_old_profile_count = 0) THEN 
        SET status_code = -1;
        SET status_message = CONCAT('Profile Missing: ', v_idProfileOld);
        call write_debug_msg(@enabled, status_message);
        LEAVE main_procedure;
    ELSE 
        call write_debug_msg(@enabled, CONCAT('Profile ', v_idProfileOld, ' Found.  Will Change it... to ', v_idProfileNew));
    END if;


    START TRANSACTION;

    -- open the cursor
    OPEN cursor_profilesegment;   

    -- initialize loop variables
    SET pg_loop_cntr = 0;
      
    -- Fetch in a loop
    get_profilesegment: LOOP

        SET pg_loop_cntr = pg_loop_cntr + 1;

        FETCH cursor_profilesegment INTO v_idProfilesegmentOld;
        IF v_segment_finished THEN
            LEAVE get_profilesegment;
        END IF;

        -- create the new id_profilesegment
        SET v_idProfilesegmentNew = v_idProfileNew * 100 + pg_loop_cntr;
        call write_debug_msg(@enabled, CONCAT('Change Old v_idProfilesegmentOld. ', v_idProfilesegmentOld, ' to New v_idProfilesegmentNew ', v_idProfilesegmentNew));
        

        BLOCK2: BEGIN
            DECLARE v_profiletest_finished INT DEFAULT FALSE;
            -- declare the profiletest cursor
            DECLARE cursor_profiletest CURSOR FOR 
                SELECT pt.id_profiletest AS id_profiletest
                FROM profiletest pt 
                WHERE pt.id_profilesegment = v_idProfilesegmentOld
                ORDER BY 1;
        
            -- declare NOT FOUND handler
            DECLARE CONTINUE HANDLER
                FOR NOT FOUND SET v_profiletest_finished = TRUE;

            -- open the cursor
            OPEN cursor_profiletest;   

            -- initialize loop variables
            SET pt_loop_cntr = 0;

            -- Fetch in a loop
            get_profiletest: LOOP

                SET pt_loop_cntr = pt_loop_cntr + 1;

                FETCH cursor_profiletest INTO v_idProfiletestOld;
                IF v_profiletest_finished THEN
                    LEAVE get_profiletest;
                END IF;

                SET v_idProfiletestNew = v_idProfilesegmentNew * 100 + pt_loop_cntr;
                call write_debug_msg(@enabled, CONCAT('Attempting to Change Profiletest: Old v_idProfiletestOld. ', v_idProfiletestOld, ' to New v_idProfiletestNew ', v_idProfiletestNew));

                -- Update idProfiletest statement.  
                UPDATE profiletest SET id_profiletest = v_idProfiletestNew
                WHERE id_profiletest = v_idProfiletestOld;

                call write_debug_msg(@enabled, CONCAT('Update Profiletest Successful.  Old v_idProfiletestOld. ', v_idProfiletestOld, ' Changed to New v_idProfiletestNew ', v_idProfiletestNew));

            END LOOP get_profiletest;
        END BLOCK2;
            
        -- now update the profilesegment
        -- Update idProfilesegment statement.  
        call write_debug_msg(@enabled, CONCAT('Attempting to Change Profilesegment: Old v_idProfilesegmentOld. ', v_idProfilesegmentOld, ' to New v_idProfilesegmentNew ', v_idProfilesegmentNew));

        UPDATE profilesegment SET id_profilesegment = v_idProfilesegmentNew
        WHERE id_profilesegment = v_idProfilesegmentOld;

        call write_debug_msg(@enabled, CONCAT('Update Profilesegment Successful.  Old v_idProfilesegmentOld. ', v_idProfilesegmentOld, ' Changed to New v_idProfilesegmentNew ', v_idProfilesegmentNew));

    END LOOP get_profilesegment;
            
    -- Update idProfile statement.  This should also set the new Id on the profilesegment due to FK being cascade on update
    call write_debug_msg(@enabled, CONCAT('Attempting to Change Profile: Old v_idProfileOld. ', v_idProfileOld, ' to New v_idProfileNew ', v_idProfileNew));

    UPDATE profile SET id_profile = v_idProfileNew
    WHERE id_profile = v_idProfileOld;

    call write_debug_msg(@enabled, CONCAT('Update Profile Successful.  Old v_idProfileOld. ', v_idProfileOld, ' Changed to New v_idProfileNew ', v_idProfileNew));

    COMMIT;

    SET status_code = 0;
    SET status_message = "Success!";

END main_procedure;

$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure copy_profile
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`copy_profile`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`copy_profile` (IN v_idProfileOld BIGINT, IN v_idProfileNew BIGINT, OUT status_code INT, OUT status_message VARCHAR(256))
main_procedure: BEGIN
    DECLARE v_old_profile_count INT DEFAULT 0;
    DECLARE v_new_profile_count INT DEFAULT 0;
    DECLARE v_idProfilesegmentOld BIGINT DEFAULT 0;
    DECLARE v_idProfilesegmentNew BIGINT DEFAULT 0;
    DECLARE v_idProfiletestOld BIGINT DEFAULT 0;
    DECLARE v_idProfiletestNew BIGINT DEFAULT 0;
    DECLARE pg_loop_cntr INT DEFAULT 0;
    DECLARE pt_loop_cntr INT DEFAULT 0;

    DECLARE v_segment_finished INT DEFAULT FALSE;

    -- declare the profilesegment cursor
    DECLARE cursor_profilesegment CURSOR FOR 
        SELECT pg.id_profilesegment AS id_profilesegment
        FROM profilesegment pg 
        WHERE pg.id_profile = v_idProfileOld
        ORDER BY 1;
    
    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET v_segment_finished = TRUE;

    DECLARE exit handler for sqlexception
        BEGIN
            SET status_code = -1;
            SET status_message = "Fail - SQL Error";
            ROLLBACK;
        END;

    DECLARE exit handler for sqlwarning
        BEGIN
            SET status_code = -1;
            SET status_message = "Fail - SQL Warning";
            ROLLBACK;
        END;

    -- truncate the debug table before getting started with the load
    TRUNCATE TABLE logtable;

    SET @enabled = TRUE;
    call write_debug_msg(@enabled, CONCAT('Starting execution on copy_profile. ', v_idProfileOld, ' to ', v_idProfileNew));

    -- See if the profile exists with the old profileid
    SELECT COUNT(*) INTO v_old_profile_count 
    FROM profile p 
    WHERE id_profile = v_idProfileOld;
    
    IF (v_old_profile_count = 0) THEN 
        SET status_code = -1;
        SET status_message = CONCAT('Profile Missing: ', v_idProfileOld);
        call write_debug_msg(@enabled, status_message);
        LEAVE main_procedure;
    ELSE 
        call write_debug_msg(@enabled, CONCAT('Profile ', v_idProfileOld, ' Found.  Will Copy it to... ', v_idProfileNew));
    END if;


    -- See if the COPY profile ID already exists 
    SELECT COUNT(*) INTO v_new_profile_count 
    FROM profile p 
    WHERE id_profile = v_idProfileNew;
    
    IF (v_new_profile_count > 0) THEN 
        SET status_code = -1;
        SET status_message = CONCAT('Profile already exists with ID: ', v_idProfileNew, '.  Please use a different NEW Profile ID.');
        call write_debug_msg(@enabled, status_message);
        LEAVE main_procedure;
    ELSE 
        call write_debug_msg(@enabled, CONCAT('Profile ', v_idProfileOld, ' Found.  Will Copy it to... ', v_idProfileNew));
    END if;


    START TRANSACTION;

    -- Copy idProfile statement. 
    call write_debug_msg(@enabled, CONCAT('Attempting to Copy Profile: Old v_idProfileOld. ', v_idProfileOld, ' to New v_idProfileNew ', v_idProfileNew));

    INSERT INTO `profile`
        (`id_profile`,
        `id_provider`,
        `id_organization`,
        `name`,
        `description`,
        `access_level`,
        `published`,
        `profile_type`)
    SELECT 
        v_idProfileNew, 
        `id_provider`,
        `id_organization`,
        CONCAT(`name`, '_copy'),
        `description`,
        `access_level`,
        `published`,
        `profile_type`
    FROM `profile`
    WHERE `id_profile` = v_idProfileOld;
    
    call write_debug_msg(@enabled, CONCAT('Copy Profile Successful.  Old v_idProfileOld. ', v_idProfileOld, ' Changed to New v_idProfileNew ', v_idProfileNew));

    -- open the cursor
    OPEN cursor_profilesegment;   

    -- initialize loop variables
    SET pg_loop_cntr = 0;
      
    -- Fetch in a loop
    get_profilesegment: LOOP

        SET pg_loop_cntr = pg_loop_cntr + 1;

        FETCH cursor_profilesegment INTO v_idProfilesegmentOld;
        IF v_segment_finished THEN
            LEAVE get_profilesegment;
        END IF;

        -- create the new id_profilesegment
        SET v_idProfilesegmentNew = v_idProfileNew * 100 + pg_loop_cntr;
        
        -- now insert the new profilesegment
        -- Insert Profilesegment statement.  
        call write_debug_msg(@enabled, CONCAT('Attempting to Copy Profilesegment: Old v_idProfilesegmentOld. ', v_idProfilesegmentOld, ' to New v_idProfilesegmentNew ', v_idProfilesegmentNew));

        INSERT INTO `profilesegment`
            (`id_profilesegment`,
            `id_profile`,
            `name`,
            `description`,
            `seq`,
            `profiletest_wrapper`)
        SELECT 
            v_idProfilesegmentNew,
            v_idProfileNew,
            `name`,
            `description`,
            `seq`,
            `profiletest_wrapper`
        FROM `profilesegment`
        WHERE `id_profilesegment` = v_idProfilesegmentOld;

        call write_debug_msg(@enabled, CONCAT('Copy Profilesegment Successful.  Old v_idProfilesegmentOld. ', v_idProfilesegmentOld, ' Changed to New v_idProfilesegmentNew ', v_idProfilesegmentNew));

        BLOCK2: BEGIN
            DECLARE v_profiletest_finished INT DEFAULT FALSE;
            -- declare the profiletest cursor
            DECLARE cursor_profiletest CURSOR FOR 
                SELECT pt.id_profiletest AS id_profiletest
                FROM profiletest pt 
                WHERE pt.id_profilesegment = v_idProfilesegmentOld
                ORDER BY 1;
        
            -- declare NOT FOUND handler
            DECLARE CONTINUE HANDLER
                FOR NOT FOUND SET v_profiletest_finished = TRUE;

            -- open the cursor
            OPEN cursor_profiletest;   

            -- initialize loop variables
            SET pt_loop_cntr = 0;

            -- Fetch in a loop
            get_profiletest: LOOP

                SET pt_loop_cntr = pt_loop_cntr + 1;

                FETCH cursor_profiletest INTO v_idProfiletestOld;
                IF v_profiletest_finished THEN
                    LEAVE get_profiletest;
                END IF;

                SET v_idProfiletestNew = v_idProfilesegmentNew * 100 + pt_loop_cntr;
                call write_debug_msg(@enabled, CONCAT('Attempting to Copy Profiletest: Old v_idProfiletestOld. ', v_idProfiletestOld, ' to New v_idProfiletestNew ', v_idProfiletestNew));

                -- Insert Profiletest statement.  
                INSERT INTO `profiletest`
                    (`id_profiletest`,
                    `id_profile`,
                    `id_profilesegment`,
                    `id_test_ref`,
                    `name`,
                    `description`,
                    `seq`,
                    `test_provision_day`,
                    `test_removal_day`,
                    `test_provision_date`,
                    `test_removal_date`,
                    `initial_active`)
                SELECT 
                    v_idProfiletestNew,
                    v_idProfileNew,
                    v_idProfilesegmentNew,
                    `id_test_ref`,
                    `name`,
                    `description`,
                    `seq`,
                    `test_provision_day`,
                    `test_removal_day`,
                    `test_provision_date`,
                    `test_removal_date`,
                    `initial_active`
                FROM `profiletest`
                WHERE `id_profiletest` = v_idProfiletestOld;                
                
                call write_debug_msg(@enabled, CONCAT('Copy Profiletest Successful.  Old v_idProfiletestOld. ', v_idProfiletestOld, ' Changed to New v_idProfiletestNew ', v_idProfiletestNew));

            END LOOP get_profiletest;
        END BLOCK2;
            
    END LOOP get_profilesegment;
            
    COMMIT;

    SET status_code = 0;
    SET status_message = "Success!";

END main_procedure;$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure mark_usertest_as_graded
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`mark_usertest_as_graded`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`mark_usertest_as_graded` (IN in_idUsertest BIGINT, OUT out_status_code INT, OUT out_status_message VARCHAR(256))
BEGIN

	DECLARE v_idUser BIGINT DEFAULT 0;
	DECLARE v_idProfiletest BIGINT DEFAULT 0;
	DECLARE v_idProfilesegment BIGINT DEFAULT 0;
	DECLARE v_profile_type INT DEFAULT 0;
	DECLARE v_idProfiletestNext BIGINT DEFAULT 0;
	DECLARE v_idProfiletestNextSequence INT DEFAULT 0;

	DECLARE exit handler for sqlexception
	  BEGIN
		SET out_status_code = -1;
		SET out_status_message = "Fail - SQL Error";
	  ROLLBACK;
	END;

	DECLARE exit handler for sqlwarning
	 BEGIN
		SET out_status_code = -1;
		SET out_status_message = "Fail - SQL Warning";
	 ROLLBACK;
	END;


	START TRANSACTION;

	-- Does not use usertest.id_profile (only uses usertest.id_profiletest)
	-- SELECT ut.id_profiletest, p.profile_type INTO v_idProfiletest, v_profile_type
	-- FROM usertest ut LEFT JOIN profiletest pt ON ut.id_profiletest = pt.id_profiletest
	-- 				 LEFT JOIN profilesegment ps ON pt.id_profilesegment = ps.id_profilesegment
	-- 				 LEFT JOIN profile p ON ps.id_profile = p.id_profile
	-- WHERE ut.id_usertest = in_idUsertest;

	-- Use the usertest.id_profile value for efficiency purpose
	SELECT ut.id_user, ut.id_profiletest, p.profile_type INTO v_idUser, v_idProfiletest, v_profile_type
	FROM usertest ut LEFT JOIN profile p ON ut.id_profile = p.id_profile
	WHERE ut.id_usertest = in_idUsertest;

	-- do this complicated logic only for a Sequenced profile (note that v_profile_type can be null for non-profiled usertest)
	IF (v_profile_type = 3) THEN
		-- Figure out the id_profilesegment to identify the series
		SELECT ps.id_profilesegment INTO v_idProfilesegment
		FROM profiletest pt LEFT JOIN profilesegment ps ON pt.id_profilesegment = ps.id_profilesegment 
		WHERE pt.id_profiletest = v_idProfiletest;

		-- figure out the next id_profiletest in the series
		-- SELECT MIN(upt.id_profiletest) INTO v_idProfiletestNext
		SELECT MIN(pt.seq) INTO v_idProfiletestNextSequence
		FROM userprofiletest upt LEFT JOIN profiletest pt ON upt.id_profiletest = pt.id_profiletest 
								 LEFT JOIN userprofile up ON upt.id_userprofile = up.id_userprofile
		WHERE pt.id_profilesegment = v_idProfilesegment AND 
			  up.id_student = v_idUser AND 
			  upt.active = 0;

		IF (v_idProfiletestNextSequence IS NOT null) THEN
			-- SELECT MIN(upt.id_profiletest) INTO v_idProfiletestNext
			SELECT upt.id_profiletest INTO v_idProfiletestNext
			FROM userprofiletest upt LEFT JOIN profiletest pt ON upt.id_profiletest = pt.id_profiletest 
									 LEFT JOIN userprofile up ON upt.id_userprofile = up.id_userprofile
			WHERE pt.id_profilesegment = v_idProfilesegment AND 
				  pt.seq = v_idProfiletestNextSequence;

			-- update its status to active (note that v_idProfiletestNext can be null)
			UPDATE userprofiletest upt LEFT JOIN userprofile up ON upt.id_userprofile = up.id_userprofile
			SET  active = 1 
			WHERE upt.id_profiletest = v_idProfiletestNext AND 
				  up.id_student = v_idUser;
		END IF;
	END IF;

	-- either way, update the usertest to the next status...
	UPDATE usertest ut SET test_status = 'corrections' WHERE ut.id_usertest = in_idUsertest;

	-- done
    COMMIT;

    -- indicate success status
    SET out_status_code = 0;
    SET out_status_message = "success";

END
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure update_topic_skill_counts_for_channel
-- -----------------------------------------------------

USE `rulefree`;
DROP procedure IF EXISTS `rulefree`.`update_topic_skill_counts_for_channel`;

DELIMITER $$
USE `rulefree`$$
CREATE PROCEDURE `rulefree`.`update_topic_skill_counts_for_channel` (IN idChannel BIGINT)
BEGIN

    -- Declare Question and Point count variables at a Test Level
    DECLARE v_finished INTEGER DEFAULT 0;

    DECLARE v_id_level BIGINT DEFAULT 0;
    DECLARE v_topiccount INT DEFAULT 0;
    DECLARE v_skillcount INT DEFAULT 0;

    -- declare the testsegment cursor 
/*	This does not calculate skill_counts when a topic is referred...
		DECLARE levelWithCountsCursor CURSOR FOR 
		SELECT l.id_level, 
				count(distinct t.id_topic) AS topiccount, 
				count(distinct s.id_skill) AS skillcount 
		FROM level l LEFT JOIN topic t on t.id_level = l.id_level LEFT JOIN skill s ON s.id_topic = t.id_topic
		GROUP BY l.id_level;
*/
-- Include counts from referred topics 
    DECLARE levelWithCountsCursor CURSOR FOR 
		SELECT l.id_level, 
				count(distinct t.id_topic) AS topiccount, 
				count(distinct s.id_skill)  + count(distinct s2.id_skill) AS skillcount 
		FROM level l LEFT JOIN topic t on t.id_level = l.id_level 
					LEFT JOIN skill s ON s.id_topic = t.id_topic
					LEFT JOIN skill s2 ON s2.id_topic = t.id_topic_reference
		WHERE l.id_system = idChannel
		GROUP BY l.id_level;

    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET v_finished = 1;

    -- Update skill and topic counts for each level
    SET v_finished = 0;
    -- open the cursor
    OPEN levelWithCountsCursor;   
    -- Fetch in a loop
    get_level: LOOP
        FETCH levelWithCountsCursor INTO v_id_level, v_topiccount, v_skillcount;
        IF v_finished = 1 THEN
            LEAVE get_level;
        END IF;
        -- update testsection
        UPDATE level l
        SET l.topiccount = v_topiccount, l.skillcount = v_skillcount
        WHERE l.id_level = v_id_level;

    END LOOP get_level;
    -- close the cursor
    CLOSE levelWithCountsCursor;

END$$

DELIMITER ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
