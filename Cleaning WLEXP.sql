-- World Life Expectancy Project (Data Cleaning)
SELECT *
FROM world_life_expectancy.world_life_expectancy
;

-- Finding Duplicates

SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy.world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1
;

-- Removing Duplicates

SELECT *
FROM (
     SELECT Row_id,
     CONCAT(Country, Year),
      ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, year) ORDER BY CONCAT(Country, Year)) as Row_Num
      FROM world_life_expectancy.world_life_expectancy
) AS Row_table
WHERE Row_Num > 1
;

DELETE FROM world_life_expectancy.world_life_expectancy
WHERE
     Row_ID IN (
SELECT Row_ID
FROM (     
	SELECT Row_id,
     CONCAT(Country, Year),
      ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, year) ORDER BY CONCAT(Country, Year)) as Row_Num
      FROM world_life_expectancy.world_life_expectancy
) AS Row_table
WHERE Row_Num > 1
)
;

-- Checking the table again
SELECT *
FROM world_life_expectancy.world_life_expectancy
;

-- Checking blanks and nulls

SELECT *
FROM world_life_expectancy.world_life_expectancy
WHERE Status = ''
;

SELECT DISTINCT(Status)
FROM world_life_expectancy.world_life_expectancy
WHERE Status <> ''
;

SELECT DISTINCT(Country)
FROM world_life_expectancy.world_life_expectancy
WHERE Status = 'Developing'
;

-- This does not work
UPDATE world_life_expectancy.world_life_expectancy
SET Status = 'Developing'
WHERE Country IN (SELECT DISTINCT(Country)
       FROM world_life_expectancy.world_life_expectancy
  WHERE Status = 'Developing')
  ;
  
  
  -- This works
  UPDATE world_life_expectancy.world_life_expectancy t1
  JOIN world_life_expectancy.world_life_expectancy t2
      ON t1.country = t2.country
 SET t1.Status = 'Developing'
 WHERE t1.Status = ''
 AND t2.Status <> ''
 AND t2.Status = 'Developing'
 ;
 
 SELECT *
FROM world_life_expectancy.world_life_expectancy
WHERE Country = 'United States of America'
;

-- We did 'Developing' and now we have to do 'Developed'

  UPDATE world_life_expectancy.world_life_expectancy t1
  JOIN world_life_expectancy.world_life_expectancy t2
      ON t1.country = t2.country
 SET t1.Status = 'Developed'
 WHERE t1.Status = ''
 AND t2.Status <> ''
 AND t2.Status = 'Developed'
 ;
 
 -- Check the table again
 
  SELECT *
FROM world_life_expectancy.world_life_expectancy
;

-- Handeling Life expectancy column

SELECT *
FROM world_life_expectancy.world_life_expectancy
WHERE `Life expectancy` = ''
;


-- We will poulate the blanks with average of the year befroe and the year after

SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy.world_life_expectancy
-- WHERE `Life expectancy` = ''
;

SELECT t1.Country, t1.Year, t1.`Life expectancy`, t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1 )
FROM world_life_expectancy.world_life_expectancy t1
JOIN world_life_expectancy.world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.YEAR = t2.YEAR - 1
JOIN world_life_expectancy.world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.YEAR = t3.YEAR + 1
WHERE t1.`Life expectancy` = ''   
;

UPDATE world_life_expectancy.world_life_expectancy t1
JOIN world_life_expectancy.world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.YEAR = t2.YEAR - 1
JOIN world_life_expectancy.world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.YEAR = t3.YEAR + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1 )
WHERE t1.`Life expectancy` = ''
;

SELECT *
FROM world_life_expectancy.world_life_expectancy
-- WHERE `Life expectancy` = ''
;
   