UPDATE section sec INNER JOIN skill sk ON sec.id_skill = sk.id_skill 
                                INNER JOIN topic t ON sk.id_topic = t.id_topic 
                                INNER JOIN level l ON t.id_level = l.id_level 
                                INNER JOIN system sys ON l.id_system = sys.id_system
SET  sec.is_practice = false
WHERE sys.id_system in (103, 131);
