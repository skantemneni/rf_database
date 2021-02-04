FIX UPLOADER ISSUES with Ampersands in Question Text Fields...
----------------------------------------------------------------
For now, fix it in the database as follows...run this multiple times
------------------------------------------------------------------------

SELECT * FROM question WHERE text LIKE '%&amp;%';

UPDATE question SET text = REPLACE(text, '&amp;', '&') 
WHERE id_question > 0;




SELECT * FROM question WHERE addl_info LIKE '%&amp;%';

UPDATE question SET addl_info = REPLACE(addl_info, '&amp;', '&') 
WHERE id_question > 0;
