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
select  location_in_aus, count(*) from air_quality
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




--- for practice next time 
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






















