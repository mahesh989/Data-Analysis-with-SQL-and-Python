--- the number of rows
select count(*) from air_quality;

--- save the data in csv format by downloading
select * from air_quality;

--- the number of columns
select count(*) 
from information_schema.columns 
where table_name = 'air_quality';



--- shape
select 
(select count(*) from air_quality) as row_count,
(select count(*) 
from information_schema.columns 
where table_name = 'air_quality') as column_count;


--- column names
select column_name
from information_schema.columns 
where table_name = 'air_quality';

--- Convert Entries to Lowercase
UPDATE air_quality
SET location_in_Aus = LOWER(location_in_Aus);

---Remove Leading and Trailing Spaces
UPDATE air_quality
SET location_in_Aus = TRIM(location_in_Aus);

--- to find unique values in a particular column
SELECT DISTINCT parameter as distinct_parameters
FROM air_quality;

--- to find number of unique values in a particular column
SELECT count(DISTINCT parameter) as number_of_distinct_parameters
FROM air_quality;


--- removing time-stamp
ALTER TABLE air_quality
ALTER COLUMN date_utc TYPE DATE
USING date(date_utc);

---  number of locations by count
SELECT location_in_aus, COUNT(*)
FROM air_quality
GROUP BY location_in_aus
order by count desc;


---
SELECT location_in_aus, AVG(value) AS average_value
FROM air_quality
GROUP BY location_in_aus
ORDER BY average_value DESC;













