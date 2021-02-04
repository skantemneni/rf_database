-- Here is how you update a Test ID (in this example from 9990000000027 to 1030000000001)

-- first make sure the foreign keys are enabled
SET FOREIGN_KEY_CHECKS=1;

-- call the stored proc to update the test and print out the results and logs
CALL change_test_id(9990000000027, 1030000000001, @status_code, @status_message);
select @status_code, @status_message;
SELECT * FROM logtable; 
