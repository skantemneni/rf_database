update skill sk set published = true where published is null;
update skill sk set published = false where name like 'Topic Tests -%';

