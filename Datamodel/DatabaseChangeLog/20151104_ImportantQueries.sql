1.)
SELECT * FROM test WHERE id_test = 41;



2.)
SELECT tg.* FROM testsegment tg LEFT JOIN test t ON tg.id_test = t.id_test 
WHERE t.id_test = 41 
ORDER BY tg.id_testsegment;




3.)
SELECT ts.* FROM testsection ts LEFT JOIN testsegment tg ON ts.id_testsegment = tg.id_testsegment 
                                LEFT JOIN test t ON tg.id_test = t.id_test
WHERE t.id_test = 41 
ORDER BY tg.id_testsegment, ts.id_testsection;


