--- Part 1 
--- Check for Sample Data
select * from air_quality;

--- Row Count
select count(*) from air_quality;

--- Column Count
select count(*)
from information_schema.columns 
where table_name = 'air_quality';

--- Shape (Row Count and Column Count Combined)
select 
	(select count(*) as row_count from air_quality),
	(select count(*) as column_count
from information_schema.columns 
where table_name = 'air_quality');

--- Column Names
select column_name
from information_schema.columns
where table_name = 'air_quality';

--- lower entries  and trimming , COMMON TABLE EXPRESSION
update air_quality 
set location_in_aus = upper(trim(location_in_aus));
select *from air_quality;

WITH updated AS (
    UPDATE air_quality 
    SET location_in_aus = upper(TRIM(location_in_aus))
    RETURNING *
)
SELECT * FROM updated;



--- Sort Records in Ascending Order,descending Order
select * from air_quality 
order by value desc
limit 10;

--- IS NULL Check 
select * from air_quality
where value is null and parameter is null;

--- IS NOT NULL Check
select * from air_quality
where location_in_aus is not null and value is not null;

---  duplicate check
select  location_in_aus count(*) from air_quality
group by location_in_aus
having count(*) > 1;

SELECT longitude, location_in_aus, COUNT(*) AS count
FROM air_quality
GROUP BY longitude, location_in_aus
HAVING COUNT(*) > 1;


--- Find Distinct Entries
select distinct unit from air_quality;

--- Count for Distinct Entries
select count(distinct parameter) as unique_parametr_number from air_quality;

--- Minimum Value of a Column
select min(value) from air_quality;

--- Maximum Value of a Column
select max(value) from air_quality;

--- Average Value of a Column
select avg(value) from air_quality;

--- Sum of a Column
select sum(value) from air_quality;


--- Part - 2
--- Filter Records Based on Condition
--- Comparison operators: equal to, not equal to, greater than, less than, greater than or equal to, less than or equal to
select * from air_quality
where id = 5;
select * from air_quality
where value <> 0;
select * from air_quality
where value > 9;
select * from air_quality
where value >= 9;
select * from air_quality
where value <= 9;

--- Logical operators: AND, OR, NOT
select * from air_quality
where value = 9.9 and parameter = 'pm25';

select * from air_quality
where value > 5 and lower(location_in_aus) = 'bathurst';

SELECT * FROM air_quality
WHERE not value > 10;

--- Pattern matching: LIKE
-- Find records where the pattern starts in the beginning
select * from air_quality 
where lower(location_in_aus) like 'roz%';

-- Find records where the pattern is at the end;
select * from air_quality
where lower(location_in_aus) like '%e';

-- find records any where 
select * from air_quality
where lower(location_in_aus) like '%ll%';

-- find records with exact match
select * from air_quality
where lower(location_in_aus) like 'sydney';

--- Range checks: BETWEEN (provide range and is inclusive), IN (in is like combination of or )
select * from air_quality 
where value between 1 and 2;

select * from air_quality
where date_utc between '2020-01-01' and '2020-02-29'
order by date_utc 
limit 10;

select * from air_quality 
where parameter in ('co','no','so2');

--- Date and time: date comparisons (e.g., date = '2024-07-01')
select * from air_quality 
where date_utc = '2020-02-29';
--- Extracting parts of a date: YEAR(date), MONTH(date), DAY(date)
select *, extract(year from date_utc) as Year
from air_quality;

SELECT *, EXTRACT(YEAR FROM date_utc) AS Year
FROM air_quality
WHERE EXTRACT(YEAR FROM date_utc) = 2020 or EXTRACT(YEAR FROM date_utc) = 2021;

select *, extract(month from date_utc) 
from air_quality
where  extract(month from date_utc) =1;

select *,extract(day from date_utc)
from air_quality 
where extract(day from date_utc) between 1 and 15
and extract (month from date_utc) = 1
and extract (year from date_utc) = 2024;

--- Date arithmetic: date + INTERVAL '1 DAY', date - INTERVAL '1 MONTH', CURRENT_DATE - INTERVAL '7 DAY'

-- Find records and add 1 day to the date
SELECT *, date_utc + INTERVAL '1 DAY' AS new_date
FROM air_quality;

-- Find records and subtract 1 month from the date
SELECT *, date_utc - INTERVAL '1 MONTH' AS new_date
FROM air_quality;

-- Find records where the date is within the last 7 days
SELECT * FROM air_quality
WHERE date_utc >= CURRENT_DATE - INTERVAL '7 DAY'
order by  date_utc desc;





--- Part-1
--- Check for Sample Data
--- Row Count
--- Column Count
--- Shape (Row Count and Column Count Combined)
--- Column Names
--- Lower Entries and Trimming (Common Table Expression)
--- Sort Records in Ascending Order, Descending Order
--- IS NULL Check
--- IS NOT NULL Check
--- Duplicate Check
--- Find Distinct Entries
--- Count for Distinct Entries
--- Minimum Value of a Column
--- Maximum Value of a Column
--- Average Value of a Column
--- Sum of a Column

--- Part-2
--- Comparison operators: equal to, not equal to, greater than, less than, greater than or equal to, less than or equal to
--- Logical operators: AND, OR, NOT
--- Find records where the pattern starts in the beginning
--- Find records where the pattern is at the end
--- Find records anywhere
--- Find records with exact match
--- Date and time: date comparisons (e.g., date = '2024-07-01')
--- Extracting parts of a date: YEAR(date), MONTH(date), DAY(date)
--- Date arithmetic: date + INTERVAL '1 DAY', date - INTERVAL '1 MONTH', CURRENT_DATE - INTERVAL '7 DAY'

--- Part -3

--- Rename a Column
--- Replace Entries in a Column
--- Change Column Data Type
--- Add a New Column
--- Drop a Column






















