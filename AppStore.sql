USE AppleStore;
SHOW TABLES;

-- Exploratory Data Analysis
-- Check the no. of unique apps in both AppStore & App tables
SELECT COUNT(DISTINCT id) AS UniqueIDs
FROM AppStore;
SELECT COUNT(DISTINCT id) AS UniqueIDs
FROM App;

-- Check for any missing values
SELECT COUNT(*) AS MissingValues
FROM AppStore
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL;

SELECT COUNT(*) AS MissingValues
FROM App
WHERE app_desc IS NULL;

-- Count the no.of apps per genre
SELECT prime_genre, COUNT(*) AS NumApps
FROM AppStore
GROUP BY prime_genre
ORDER BY NumApps DESC;

-- Statistics about the app's user ratings
SELECT 	max(user_rating) AS MaxRating,
		min(user_rating) AS MinRating,
        avg(user_rating) AS AvgRating
FROM AppStore;

-- Price distribution of the apps
SELECT PriceBinStart, PriceBinEnd, COUNT(*) AS NumApps
FROM (
    SELECT (FLOOR(price / 2) * 2) AS PriceBinStart,
           (FLOOR(price / 2) * 2) + 2 AS PriceBinEnd
    FROM AppStore
) AS Subquery
GROUP BY PriceBinStart, PriceBinEnd
ORDER BY PriceBinStart;

-- Data Analysis
-- Determine whether Paid Apps have higher ratings than Free Apps

SELECT CASE
	WHEN price > 0 THEN 'Paid'
    ELSE 'Free'
    END AS App_Type,
    avg(user_rating) as AvgRating
FROM AppStore
GROUP BY App_Type;

-- Determine whether apps with more supporting languages have higher ratings

SELECT CASE
			WHEN lang_num < 10 THEN '< 10 languages'
			WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
			ELSE '> 30 languages'
		END AS lang_available,
        avg(user_rating) AS AvgRating
FROM AppStore
GROUP BY lang_available
ORDER BY AvgRating DESC;

SELECT 	prime_genre,
		avg(user_rating) AS AvgRating
FROM AppStore
GROUP BY prime_genre
ORDER BY AvgRating ASC
LIMIT 10;

-- Determine if lengthy app description has higher user ratings

SELECT description_length,
       AVG(AvgRating) AS AvgRating,
       COUNT(*) AS DescriptionLengthCount
FROM (
    SELECT CASE
               WHEN LENGTH(b.app_desc) < 500 THEN 'Short'
               WHEN LENGTH(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
               ELSE 'Long'
           END AS description_length,
           a.user_rating AS AvgRating
    FROM AppStore AS a
    JOIN App AS b ON a.id = b.id
) AS SubqueryAlias
GROUP BY description_length
ORDER BY AvgRating DESC;

-- Check the top-rated apps in each genres
SELECT prime_genre, track_name, user_rating
FROM (
    SELECT prime_genre, track_name, user_rating,
           RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS ranking
    FROM AppStore
) AS a
WHERE a.ranking = 1;






