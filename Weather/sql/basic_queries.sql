---Basic SQL Query Questions (20)

-- Select all columns from the dataset.
select column_name
	from information_schema.columns
	where table_name = 'air_quality';

-- Retrieve the first 10 records from the dataset.
select * 
	from air_quality
	limit 10;

-- Find all unique cities from the dataset.
select distinct city
	from air_quality;
	
-- Count the number of rows in the dataset.
select count(*)
	from air_quality;

-- Select the "location_in_aus" and "city" columns where "country" is 'Australia'.
select location_in_aus, city
	from air_quality
	where country= 'AU';

-- Retrieve all columns where the "parameter" is 'PM2.5'.
select * from air_quality limit 5;

select * 
	from air_quality
	where lower(parameter) = 'pm25';

-- Get the current date and time.
select  current_timestamp;

-- Retrieve all records where "value" is between 10 and 20.
select * 
	from air_quality
	where value between 10 and 20;
	
-- Find the maximum "value" from the dataset.
select max(value)
	from air_quality;
	
-- Select the "city" and "value" where "unit" is 'µg/m³'.
select location_in_aus, value
	from air_quality
	where unit ='µg/m³';
		
-- List all records where "date_utc" is '2023-01-01'.
SELECT *
	FROM air_quality
	WHERE date_utc = '2023-01-01';

-- Find the minimum "value" for "PM10" parameter.
select  min(value) 
	from air_quality
	where parameter = 'pm10';

-- Retrieve all columns where the "latitude" is greater than -30.
select * 
	from air_quality
	where latitude > -30;

-- Select the "longitude" and "value" where the "city" is 'Sydney'.
select longitude, value
	from air_quality
	where location_in_aus = 'north maclean';
	
-- List all unique "parameters" in the dataset.
select distinct parameter
	from air_quality;
	
-- Count the number of records for each "city".
select location_in_aus, count(*)
	from air_quality
	group by location_in_aus;
	
-- Retrieve all columns where "value" is greater than 50.
select * 
	from air_quality
	where value > 50;
	
-- Find the average "value" for each "parameter".
select parameter, avg(value)
	from air_quality
	group by parameter;
	
-- Select the "location_in_aus" and "date_measured" for records measured in '2023'.
select location_in_aus, date_measured 
	from air_quality 
	where extract(year from date_measured) = 2023;

	
-- Retrieve all records where the "parameter" is 'PM10' and the "value" is greater than 50.
select * 
	from air_quality
	where parameter = 'pm10' 
	and value > 50;

-- Select the "city" and "value" for the highest recorded measurement.
select location_in_aus, value 
	from air_quality
	order by value desc
	limit 1;

-- Find the total number of measurements taken in 'Melbourne' in 2022.

-- Find the total number of measurements taken in 'Melbourne' in 2022.
SELECT COUNT(*)
FROM air_quality
WHERE LOWER(location_in_aus) = 'rz' AND date_part('year', date_measured) = 2022;

	
-- List all records where the "country" is 'Australia' and the "unit" is 'µg/m³'.
select * from air_quality 
limit 5;


select * from air_quality
where country = 'AU' 
and unit = 'µg/m³'
limit 5;

--Calculate the sum of all "values" recorded in 'Brisbane'.
select location_in_aus,sum(value)
from air_quality
where location_in_aus = 'prospect'
group by location_in_aus;

-- Retrieve the "location_in_aus" with the lowest recorded "value".
select location_in_aus, min(value)
from air_quality
group by location_in_aus
order by location_in_aus asc
limit 1;

-- Select all records where "latitude" is between -35 and -30.
select * 
from air_quality
where latitude between -35 and -30;

-- Retrieve the "location_in_aus" and "date_measured" for the first 10 records in 2023.
select location_in_aus, date_measured 
from air_quality
where date_part('year', date_measured) =2023
order by  date_measured
limit 10;

select location_in_aus, date_measured 
from air_quality
where date_part('year',date_measured) = 2023
order by date_measured
limit 10;

-- Count the number of records with a "value" greater than the average "value" for 'prospect'.87
select count(*)
from air_quality
where value >
(select avg(value)
from air_quality
where location_in_aus = 'prospect');





-- Count the number of records with a "value" greater than the average "value" for 'prospect'.
select count(*)
from air_quality
where value > (
    select avg(value)
    from air_quality
    where location_in_aus = 'prospect'
);

-- Intermediate SQL Query Questions (40)

-- Retrieve the total "value" for each "city".
select location_in_aus, sum(value) from air_quality
group by location_in_aus;


-- List all "locations_in_aus" with more than 100 records.
select location_in_aus, count(*)
from air_quality
group by location_in_aus
having count(*) > 100
order by count(*);

-- Find the total number of measurements taken in each "location_in_aus".
select * from air_quality
limit 5;

select location_in_aus, count(*)
from air_quality
group by location_in_aus;

-- Select the "location_in_aus" and the total "value" measured in 2023.
select location_in_aus, sum(value)
from air_quality
where date_part('year',date_measured) = 2023
group by location_in_aus;

-- Retrieve the location_in_aus of cities with an average "value" greater than 25.
select location_in_aus
from air_quality 
group by location_in_aus
having avg(value) > 25;

-- Find the second highest "value" in the dataset.

select max(value) from air_quality
where value < (select max(value) from air_quality);

-- Find the second highest "value" in the dataset.
select distinct value
from air_quality
order by value asc
offset 0 limit 1;

-- Retrieve the top 5 highest "values" recorded.
select distinct value
from air_quality 
order by value desc
limit 5;

-- Find the total number of measurements for each "parameter".
select parameter,  count(*) from air_quality
group by parameter;

-- Select the "location_in_aus" and "date_measured" for measurements taken in 2023.
select location_in_aus, date_measured from air_quality
where date_part('year',date_measured) = 2023;

-- List all location with no measurements in the last 6 months.
/* hello */
select  location_in_aus from air_quality
group by location_in_aus
having max(date_measured)  >= current_date - interval '6 months';

-- Retrieve the total "value" measured in each month.
select date_part('month', date_measured) as month_of, sum(value) from air_quality
group by month_of
order by month_of;



-- Find the average "value" for each "location".
select location_in_aus, avg(value) from air_quality
group by location_in_aus;

-- Select the "parameter" and the number of records for each "parameter".
select parameter, count(*) from air_quality 
group by parameter
order by parameter asc;

-- List all "location" with a "value" greater than the average "value".

select  location_in_aus from air_quality
where value > (select avg(value) from air_quality); 


-- Retrieve the total "value" for each day.
select date_part('day', date_measured) as each_day,sum(value) from air_quality
group by each_day 
order by each_day;

-- Find the highest and lowest "values" for each "parameter".
select parameter, max(value),min(value) from air_quality
group by parameter;

-- List all location with measurements greater than 50 in 2023.
select location_in_aus, date_measured,value
from air_quality
where value > 50 
and date_part('year',date_measured) = 2023
order by value asc
limit 5;

-- Retrieve the names of locations with measurements in the last month.
select location_in_aus, value, date_measured
from air_quality
where date_measured >= current_date - interval '1 month'
order by date_measured asc;


-- Find the average "value" for each "parameter".
select parameter, avg(value)
from air_quality
group by parameter;

-- Select the "location_in_aus" and the total "value" measured in each location.
select location_in_aus, sum(value) as summ
from air_quality
group by location_in_aus
order by summ asc;

-- List all "parameters" measured more than 100 times.
select parameter, count(*)
from air_quality
group by parameter
having count(*)>100;


-- Retrieve the names of location with measurements in the last month.
select distinct location_in_aus
from air_quality
where date_measured < current_date - interval '1 month';

-- Find the average "value" for each month.
select date_part('month', date_measured) as month_date, avg(value)
from air_quality
group by month_date
order by month_date asc;


-- Find the average "value" for each month by year
select date_part('year', date_measured) as year_date, date_part('month', date_measured) as month_date, avg(value)
from air_quality
group by year_date, month_date
order by year_date asc, month_date asc;

-- Retrieve the cumulative "value" for each day.
select 
    date_measured, 
    value, 
    sum(value) over(order by date_measured)
from air_quality
order by date_measured asc;

SELECT 
    date_measured, 
    value, 
    SUM(value) OVER (ORDER BY date_measured) AS cumulative_value
FROM 
    air_quality
ORDER BY 
    date_measured;

-- Find the average "value" per city.
SELECT
    avg(value),
    location_in_aus
from 
    air_quality
group by
    location_in_aus;

-- Retrieve the total number of measurements in the last year.
SELECT 
    date_part('year', date_measured) AS last_year,
    COUNT(*)
FROM 
    air_quality
WHERE 
    date_measured >= current_date - interval '1 year'
GROUP BY 
    date_part('year', date_measured);




--Scalar Subqueries
-- Retrieve the "location_in_aus" with the highest average "value".
select 
    location_in_aus, 
     avg(value) 
from 
    air_quality
group by
    location_in_aus
order by avg(value)  desc
offset 0 limit 1;

-- Find the "parameter" with the most measurements.
select
	parameter,
	count(*)
from air_quality
group by parameter
order by count(*) desc
limit 1;

-- List the "location" with the latest measurement date.
select 
	distinct location_in_aus
from 
	air_quality
where
	date_measured > current_date - interval '1 month';


-- List the "location_in_aus" with the latest measurement date.
SELECT location_in_aus
FROM air_quality
WHERE date_measured = (
    SELECT MAX(date_measured)
    FROM air_quality
);




























