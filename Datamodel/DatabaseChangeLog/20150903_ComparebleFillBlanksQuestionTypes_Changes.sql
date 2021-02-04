ALTER TABLE `rulefree`.`answer` ADD COLUMN 
    `answer_compare_type` TINYINT NULL COMMENT 'answer_compare_type can be one of 3 values: 1=text, 2=integer, 3=numeric.\nDefault is text compare (1).';
    
ALTER TABLE `rulefree`.`answer` ADD COLUMN 
  `answer_compare_addl_info` VARCHAR(3) NULL COMMENT 'Value here depends on whats entered on the answer_compare_type values.\n1.) For Text compare (1) this value is a 3 char string for, the characters representing the following:\n    a.) 1st char: 0=case insensitive, 1= case sensitive\n    b.) 2nd char: 0=do no /* comment truncated */ /*t trim surrounding white space, 1 = trim surrounding white space
    c.) 3rd char: 0= trim interior white spaces to one white space, 1 = leave interior white spaces alone
2.) For Integer Compare (2) this value has no significance
3.) For Decimal Compare (3) this value is a number indicating the number of digits of precision to compare
*/';



