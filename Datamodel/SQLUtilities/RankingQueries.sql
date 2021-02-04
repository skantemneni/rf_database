-- Ranking with Self Joins...
SELECT ad1.id_usertest AS id_usertest, 
        ad1.percentage AS percentage, 
        COUNT(DISTINCT ad2.percentage) AS rank
FROM anal_test_data ad1 JOIN anal_test_data ad2 ON (ad1.percentage <= ad2.percentage)
WHERE ad1.id_test = 1045000200001
GROUP BY ad1.id_usertest
ORDER BY rank;

-- Ranking without Self Joins (increases ranks with in same percentages......)
SELECT id_usertest, percentage, rank 
FROM (
        SELECT ad1.id_usertest, ad1.percentage,
                @prev := @curr AS previous_percentage,
                (@curr := ad1.percentage) AS current_percentage,
                @rank := IF(@prev = @curr, @rank+1, @rank+1) AS rank
        FROM anal_test_data ad1, (SELECT @curr := null, @prev := null, @rank := 0) somename_1
ORDER BY ad1.percentage DESC, ad1.id_usertest) sel2;


-- Ranking without Self Joins (ranks same for same percentages......)
SELECT id_usertest, percentage, rank 
FROM (
        SELECT ad1.id_usertest, ad1.percentage,
                @prev := @curr AS previous_percentage,
                (@curr := ad1.percentage) AS current_percentage,
                @rank := IF(@prev = @curr, @rank+1, @rank+1) AS rank
        FROM anal_test_data ad1, (SELECT @curr := null, @prev := null, @rank := 0) somename_1
ORDER BY ad1.percentage DESC, ad1.id_usertest) sel2;


