SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public';

-- Preparatory Questions for WSDA Music Database
-- Write a query to select all records from the invoice table.
select * from invoice;
select column_name
from information_schema.columns
where table_name = 'customer';

alter table invoice
add column hello integer;
alter table invoice 
drop column hello;

alter table invoice
rename column hello to hello_oo;

select column_name, data_type
from information_schema.columns
where table_name ='invoiceline';

alter table invoice
alter column hello_oo type text;

begin;
select * from invoice
where billingcity = 'ottawa';

update invoice
set
	billingaddress = trim(lower(billingaddress)),
	billingcity = trim(lower(billingcity)),
	billingstate = trim(lower(billingstate)),
	billingcountry = trim(lower(billingcountry));

update invoice
set billingcity = replace(billingcity,'ottawaa', 'ottawa');





-- Write a query to count the total number of customers in the customer table.
select count(*) from customer;
select firstname, lastname, count(*) from customer
group by firstname, lastname
having count(*) > 1;

select * from customer;

-- Write a query to count the total number of employees in the employee table.
select count(*) from employee;

-- Write a query to count the number of invoices created in the year 2010 in the invoice table.
select * from invoice;

select count(*) from invoice
where date_part('year',invoicedate) = 2010;

-- Write a query to calculate the total sales for the year 2010 in the invoice table.
select * from invoice;

select sum(total) from invoice
where date_part('year', invoicedate) = 2010;

-- Write a query to find the total number of transactions in each year in the invoice table.
select * from invoice;

select extract('year' from invoicedate) as year_basis, count(*) from invoice
group by year_basis
order by year_basis;

-- Write a query to join the invoice table with the customer table on CustomerId.
select i.*,c.* from invoice i
join customer c on i.CustomerId = c.CustomerId;


-- Write a query to find the total sales amount for each customer in the invoice table.
select * from invoice;
select customerid, sum(total) as sales_amount from invoice
group by customerid
order by sales_amount  desc;

-- Write a query to find the average transaction amount in the invoice table.
select avg(total) from invoice;

-- Write a query to find the number of transactions above the average transaction amount in the invoice table.
select count(*) from invoice
where total > (select avg(total) from invoice);

-- Write a query to find the customers who made purchases between 2011 and 2012 in the invoice table.
SELECT DISTINCT customerid
FROM invoice
WHERE date_part('year', invoicedate) BETWEEN 2011 AND 2012;



-- Write a query to find the sales reps and total transaction amounts for each customer 
-- between 2011 and 2012 in the invoice table.

select * from customer;
select * from invoice;
select * from employee;

select c.supportrepid, sum(i.total), c.customerid
from customer c 
join employee e 
on c.supportrepid = e.employeeid 
join invoice i 
on i.customerid = c.customerid
where date_part('year',i.invoicedate) between 2011 and 2012
group by c.customerid
order by c.customerid desc;

-- Write a query to find the sales reps and total transaction amounts for each customer 
-- between 2011 and 2012 in the invoice table.

select * from customer;
select * from invoice;
select * from employee;

select c.supportrepid,c.customerid,e.firstname ||' '|| e.lastname, sum(i.total)
from customer c 
join employee e 
on c.supportrepid = e.employeeid 
join invoice i 
on i.customerid = c.customerid
where date_part('year',i.invoicedate) between 2011 and 2012
group by c.supportrepid,c.customerid,e.firstname, e.lastname
order by c.customerid desc;




-- Write a query to create a commission payout column that calculates 15% of the sales 
-- transaction amount for each employee in the invoice table.
WITH commission_data AS (
    SELECT 
        e.employeeid,
        e.firstname || ' ' || e.lastname AS Name,
        e.title,
        i.total AS sales_amount
    FROM 
        employee e
    JOIN 
        customer c ON e.employeeid = c.supportrepid
    JOIN 
        invoice i ON c.customerid = i.customerid
)
SELECT 
    employeeid,
    Name, 
    title, 
    SUM(sales_amount) AS total_sales_amount, 
    SUM(sales_amount) * 0.15 AS commission_amount
FROM 
    commission_data
GROUP BY 
    employeeid, Name, title
ORDER BY 
    employeeid;


WITH commission_data AS (
    SELECT 
        e.employeeid,
        e.firstname || ' ' || e.lastname AS Name,
        e.title,
        SUM(i.total) AS total_sales_amount,
        SUM(i.total) * 0.15 AS commission_amount
    FROM 
        employee e
    JOIN 
        customer c ON e.employeeid = c.supportrepid
    JOIN 
        invoice i ON c.customerid = i.customerid
    GROUP BY 
        e.employeeid, e.firstname, e.lastname, e.title
)
SELECT 
    employeeid,
    Name, 
    title, 
    total_sales_amount, 
    commission_amount
FROM 
    commission_data
WHERE 
    commission_amount = (SELECT MAX(commission_amount) FROM commission_data)
ORDER BY 
    employeeid;



-- Write a query to list the customers associated with the employee who made the highest commission in the invoice table.

WITH commission_data AS (
    SELECT 
        e.employeeid,
        e.firstname || ' ' || e.lastname AS employee_name,
        e.title,
        c.customerid,
        c.firstname || ' ' || c.lastname AS customer_name,
        SUM(i.total) AS total_sales_amount,
        SUM(i.total) * 0.15 AS commission_amount
    FROM 
        employee e
    JOIN 
        customer c ON e.employeeid = c.supportrepid
    JOIN 
        invoice i ON c.customerid = i.customerid
    GROUP BY 
        e.employeeid, e.firstname, e.lastname, e.title, c.customerid, c.firstname, c.lastname
)
, highest_commission AS (
    SELECT 
        employeeid,
        MAX(commission_amount) AS max_commission
    FROM 
        commission_data
    GROUP BY 
        employeeid
)
, highest_commission_employee AS (
    SELECT 
        h.employeeid,
        c.employee_name,
        c.title,
        c.customerid,
        c.customer_name,
        c.total_sales_amount,
        c.commission_amount
    FROM 
        highest_commission h
    JOIN 
        commission_data c ON h.employeeid = c.employeeid
    WHERE 
        h.max_commission = (SELECT MAX(max_commission) FROM highest_commission)
)
SELECT 
    employeeid,
    employee_name,
    title,
    customerid,
    customer_name,
    total_sales_amount,
    commission_amount
FROM 
    highest_commission_employee
ORDER BY 
    employeeid, customerid;

select * from invoice;

-- Write a query to find the customer who made the highest purchase in the invoice table.
SELECT 
    customerid,
    SUM(total) AS total_purchase_amount
FROM 
    invoice
GROUP BY 
    customerid
ORDER BY 
    total_purchase_amount DESC
LIMIT 1;


-- Write a query to examine the record of the customer who made the highest purchase for any suspicious details in the customer table.
WITH highest_purchaser AS (
    SELECT 
        customerid,
        SUM(total) AS total_purchase_amount
    FROM 
        invoice
    GROUP BY 
        customerid
    ORDER BY 
        total_purchase_amount DESC
    LIMIT 1
)
SELECT 
    c.*
FROM 
    customer c
JOIN 
    highest_purchaser hp ON c.customerid = hp.customerid;

-- Write a query to identify any employee whose total sales exceed the average transaction amount for 2011 and 2012 in the invoice table.
WITH highest_purchaser AS (
    SELECT 
        customerid,
        SUM(total) AS total_purchase_amount
    FROM 
        invoice
    GROUP BY 
        customerid
    ORDER BY 
        total_purchase_amount DESC
    LIMIT 1
)
SELECT 
    c.*
FROM 
    customer c
JOIN 
    highest_purchaser hp ON c.customerid = hp.customerid;


-- Write a query to determine the prime suspect based on financial motivation from the data analyzed in the employee table.


WITH employee_commissions AS (
    SELECT 
        e.employeeid,
        e.firstname || ' ' || e.lastname AS employee_name,
        e.title,
        SUM(i.total) AS total_sales,
        SUM(i.total) * 0.15 AS total_commission
    FROM 
        employee e
    JOIN 
        customer c ON e.employeeid = c.supportrepid
    JOIN 
        invoice i ON c.customerid = i.customerid
    GROUP BY 
        e.employeeid, e.firstname, e.lastname, e.title
)
SELECT 
    employeeid,
    employee_name,
    title,
    total_sales,
    total_commission
FROM 
    employee_commissions
ORDER BY 
    total_commission DESC
LIMIT 1;


-- Invoice Analysis:
-- What is the total amount of all invoices?
select * from invoice;
select sum(total) from invoice;

-- How many invoices were created each year?
select date_part('year',invoicedate) as year_basis,count(*) from invoice
group by year_basis
order by year_basis;

-- What is the average transaction amount per invoice?
select avg(total) from invoice;

-- How many transactions are above the average transaction amount?
select count(*) from invoice
where total > (select avg(total) from invoice);

-- What is the total sales amount for each year?
select sum(total), date_part('year', invoicedate)
from invoice
group by date_part('year', invoicedate);

-- How many invoices were created in each month of 2012?
select date_part('month',invoicedate) as monthwise,count(*) from invoice 
where date_part('year', invoicedate) = 2012
group by monthwise;

-- Customer Insights:
-- Who are the top 10 customers by total sales amount?
select * from invoice;

select distinct customerid, sum(total) as total_sales from invoice
group by customerid
order by total_sales desc
limit 10;

-- What is the total transaction amount for each customer?
select distinct customerid, sum(total) from invoice
group by customerid
order by sum(total) desc;

-- How many transactions has each customer made?
select  customerid, count(*) from invoice
group by customerid;
-- Which customers made purchases between 2011 and 2012?
select distinct customerid from invoice
where date_part('year',invoicedate) between 2011 and 2012;

-- What is the average invoice total for each customer?
select * from invoice;
select customerid, avg(total) from invoice
group by customerid
order by customerid;

-- How many customers are from each country?
select * from customer;

select country, count(*) from customer
group by country
order by count(*) desc;


select * from customer limit 5;
select * from employee limit 5;
select * from invoice limit 5;
select * from invoiceline limit 5;

-- Basic Queries
-- Retrieve all customer details.
-- Retrieve all employee details.
-- Find customers from a specific country (e.g., "Germany").
select 
	customerid, 
	firstname, 
	lastname 
from 
	customer
where country = 'Germany';

-- Retrieve customers who have a fax number.
select 
	customerid, 
	firstname, 
	lastname 
from 
	customer
where fax is not null;


select * from customer limit 5;
/*
+-------------+      +-------------+      +-------------+      +-------------+
|  employee   |      |  customer   |      |   invoice   |      | invoiceline |
+-------------+      +-------------+      +-------------+      +-------------+
| employeeid  |<-----| supportrepid|      | invoiceid   |<-----| invoiceid   |
| lastname    |      | customerid  |<-----| customerid  |      | trackid     |
| firstname   |      | firstname   |      | invoicedate |      | unitprice   |
| title       |      | lastname    |      | billingaddress |   | quantity    |
| reportsto   |      | company     |      | billingcity  |      +-------------+
| birthdate   |      | address     |      | billingstate |
| hiredate    |      | city        |      | billingcountry |
| address     |      | state       |      | billingpostalcode |
| city        |      | country     |      | total        |
| state       |      | postalcode  |      +-------------+
| country     |      | phone       |
| postalcode  |      | fax         |
| phone       |      | email       |
| fax         |      | supportrepid|
| email       |      +-------------+
+-------------+ */


-- Joins
-- List all customers along with their support representatives' names.

select 
	c.customerid,
	c.firstname ||' '|| c.lastname as "customer name",
	c.supportrepid, 
	e.firstname ||' '|| e.lastname as "support representatives' names"
from 
	customer c
join employee e
	on c.supportrepid = e.employeeid
group by 
	c.customerid,
	c.firstname ||' '|| c.lastname,
	c.supportrepid, 
	e.firstname ||' '|| e.lastname;

-- List all invoices along with the customer's name and email.
select
	i.customerid, 
	c.firstname ||' '|| c.lastname as "Customer Name",
	c.email,
	i.invoiceid
from 
	invoice i
join
	customer c
on 
	c.customerid = i.customerid;
	
-- Find the total number of invoices per customer.
select
	i.customerid, 
	c.firstname ||' '|| c.lastname as "Customer Name",
	count(i.invoiceid)
from 
	invoice i
join 
	customer c
on
	c.customerid = i.customerid
group by 
		i.customerid, 
	 	c.firstname, c.lastname;

-- Retrieve all customers who have an invoice and include the invoice details.
select
	i.*,
	c.firstname ||' '|| c.lastname as "Customer Name",
	count(i.invoiceid)
from 
	invoice i
join 
	customer c
on
	c.customerid = i.customerid
group by 
		i.invoiceid, 
    i.customerid,
    i.invoicedate,
    i.billingaddress,
    i.billingcity,
    i.billingstate,
    i.billingcountry,
    i.billingpostalcode,
    i.total,
    c.firstname, 
    c.lastname
having 
	count(i.invoiceid) > 0;

-- Filtering and Aggregation
-- Find customers who made purchases in a specific year (e.g., 2011).
select
	distinct c.firstname ||' '|| c.lastname,
	c.customerid
from 
	customer c
join invoice i
	on c.customerid = i.customerid
where
	date_part('year', invoicedate) = 2011
order by 
	customerid;

-- Retrieve employees who were hired before a specific date (e.g., "2002-01-01").
select
	*
from 
	employee
where hiredate < '2002-01-01';

-- Calculate the total number of customers per country.
select
	country, count(*)
from
	customer
where 
	country is not null
group by
	country
order by
	count(*) desc;

-- Find the average invoice total per customer.
select
	i.customerid, 
	c.firstname ||' '|| c.lastname as "customer name", 
	avg(total) as "average invoice total per customer"
from 
	invoice i
join 
	customer c
on 
	c.customerid = i.customerid
group by
	i.customerid, c.firstname, c.lastname
order by 
	"customer name";


-- List customers who have made purchases above a certain amount (e.g., $50).
select 
	c.firstname ||' '|| c.lastname as "Customer Name",
	c.customerid, 
	sum(i.total) as "total purchase"
from 
	customer c
join 
	invoice i
on 
	c.customerid = i.customerid
group by 
	c.firstname, c.lastname, c.customerid
having 
	sum(i.total) > 10
order by 
	sum(i.total) desc;

-- Date Range Queries
-- Retrieve customers who made purchases between two dates.
select
	c.customerid, 
	i.invoiceid,
	c.firstname ||' '|| c.lastname,
	i.invoicedate
from
	customer c
join 
	invoice i on c.customerid = i.customerid
where 
	i.invoicedate between '2009-01-01' and '2013-01-01';

-- List all invoices issued in a specific year.
select 
	*
from
	invoice
where 
	date_part('year',invoicedate) = 2009
order by	
	invoicedate;

select * from employee;
-- Find employees who were hired within a specific date range.
select
	e.firstname ||' '|| e.lastname,
	e.hiredate
from 
	employee e
where 
		e.hiredate between '2000-01-01' and '2013-01-01';
	

-- Calculate the total sales for each month each year. 
select
	date_part('year', invoicedate) as "Year",
	date_part('month',invoicedate) as "Month",
	sum(total)
from 
	invoice
group by 
	date_part('year', invoicedate),
	date_part('month',invoicedate)
order by
	date_part('year', invoicedate) desc,
	date_part('month',invoicedate) asc;
	
	
-- Retrieve all invoices for the year 2012.
select 
	* 
from 
	invoice
where 
	date_part('year',invoicedate) = 2012;

-- Advanced Joins
-- List all employees along with the customers they support.
-- Find the total sales generated by each employee.
-- List all invoices along with the track details from the invoiceline table.
-- Find customers who have multiple support reps.
-- Retrieve the highest and lowest invoice totals.

-- Subqueries
-- Find customers who have never made a purchase.
-- List employees who have not been assigned any customers.
-- Retrieve customers who made their first purchase in 2011.
-- Find the top 5 customers by total purchases.
-- List invoices that have more than a certain number of line items (e.g., 5).

-- Grouping and Aggregation
-- Calculate the total sales per country.
-- Find the average transaction amount per employee.
-- List the number of invoices issued per month.
-- Calculate the total number of customers per support rep.
-- Find the average invoice total for each year.

-- Advanced Filtering
-- Retrieve customers who made purchases in multiple years.
-- List employees who support customers from different countries.
-- Find invoices with a total amount greater than the average invoice total.
-- Retrieve the most recent purchase date for each customer.
-- List customers who have made purchases in every year since 2011.

-- Combining Multiple Conditions
-- Retrieve customers from a specific country who made purchases in 2011.
-- Find employees hired after a certain date who support customers from Canada.
-- List invoices with a total amount greater than a certain value and issued in 2012.
-- Find customers with no support rep who made purchases in 2011.
-- Retrieve employees who support customers from more than one country.

-- Complex Aggregations
-- Calculate the total sales per employee and per year.
-- Find the average number of invoices per customer per year.
-- List the top 3 employees by total sales for each year.
-- Calculate the monthly sales growth rate.
-- Find the average invoice amount per support rep.

-- Analyzing Transactions
-- List customers with the highest total transaction amounts.
-- Find employees with the highest number of customers supported.
-- Calculate the average transaction amount for each customer.
-- Retrieve the top 10 transactions by amount.
-- List employees who have generated sales above a certain threshold.

-- Additional Scenarios
-- Find customers who made purchases but do not have a support rep.
-- List employees who support customers with high total purchases.
-- Retrieve customers with missing information (e.g., no email or phone number).
-- Find the total sales per city.
-- List the top 5 customers by number of transactions.

-- Financial Analysis
-- Calculate the total sales per employee and per month.
-- Find the average transaction amount for each customer per year.
-- List the top 3 employees by total commission earned.
-- Calculate the total commission for each employee based on 15% of their sales.
-- Find customers with the highest transaction amounts in each country.

-- Advanced Financial Analysis
-- List employees who exceeded the average transaction amount in 2011 and 2012.
-- Calculate the total sales per employee and per quarter.
-- Find the average invoice total for each employee.
-- List the top 5 transactions by amount for each year.
-- Calculate the average sales growth rate per employee.

-- Suspicious Activity Analysis
-- Find employees with transactions significantly higher than the average.
-- List customers with unusually high purchases.
-- Retrieve the highest single transaction per customer.
-- Find employees with a sudden increase in sales.
-- List the top 5 customers with the most transactions in a single month.

-- Predictive Analysis
-- Calculate the total sales forecast for the next year.
-- Find customers likely to make high purchases based on past behavior.
-- List employees who are likely to generate the most sales next year.
-- Calculate the expected commission for each employee next year.
-- Find trends in customer purchasing behavior over the last 5 years.





