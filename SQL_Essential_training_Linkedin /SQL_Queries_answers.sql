/* Schema Information */
-- 1. List all tables in the public schema
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public';

-- 2. List columns in the customer table
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'customer';

-- 3. List columns and data types in the invoiceline table
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name ='invoiceline';

/* Basic Table Operations */
-- 4. Select all records from the invoice table
SELECT * FROM invoice;

-- 5. Add a column to the invoice table
ALTER TABLE invoice
ADD COLUMN hello INTEGER;

-- 6. Drop a column from the invoice table
ALTER TABLE invoice 
DROP COLUMN hello;

-- 7. Rename a column in the invoice table
ALTER TABLE invoice
RENAME COLUMN hello TO hello_oo;

-- 8. Change the data type of a column in the invoice table
ALTER TABLE invoice
ALTER COLUMN hello_oo TYPE TEXT;

-- 9. Begin a transaction
BEGIN;

-- 10. Select records from the invoice table where billing city is Ottawa
SELECT * FROM invoice
WHERE billingcity = 'Ottawa';

/* Data Cleaning and Updates */
-- 11. Update billing address fields in the invoice table to trimmed lower case
UPDATE invoice
SET
    billingaddress = TRIM(LOWER(billingaddress)),
    billingcity = TRIM(LOWER(billingcity)),
    billingstate = TRIM(LOWER(billingstate)),
    billingcountry = TRIM(LOWER(billingcountry));

-- 12. Correct misspelling in the billing city field
UPDATE invoice
SET billingcity = REPLACE(billingcity,'ottawaa', 'ottawa');

/* Counting and Aggregations */
-- 13. Count the total number of customers
SELECT COUNT(*) FROM customer;

-- 14. Find duplicate customers by first name and last name
SELECT firstname, lastname, COUNT(*) 
FROM customer
GROUP BY firstname, lastname
HAVING COUNT(*) > 1;

-- 15. Count the total number of employees
SELECT COUNT(*) FROM employee;

-- 16. Count the number of invoices created in the year 2010
SELECT COUNT(*) 
FROM invoice
WHERE date_part('year', invoicedate) = 2010;

-- 17. Calculate the total sales for the year 2010
SELECT SUM(total) 
FROM invoice
WHERE date_part('year', invoicedate) = 2010;

-- 18. Find the total number of transactions in each year
SELECT extract('year' FROM invoicedate) AS year_basis, COUNT(*)
FROM invoice
GROUP BY year_basis
ORDER BY year_basis;

-- 19. Find the total sales amount for each year
SELECT SUM(total), date_part('year', invoicedate)
FROM invoice
GROUP BY date_part('year', invoicedate);

-- 20. Find the number of invoices created in each month of 2012
SELECT date_part('month', invoicedate) AS monthwise, COUNT(*)
FROM invoice 
WHERE date_part('year', invoicedate) = 2012
GROUP BY monthwise;

/* Joins and Customer Analysis */
-- 21. Join the invoice table with the customer table on CustomerId
SELECT i.*, c.* 
FROM invoice i
JOIN customer c ON i.CustomerId = c.CustomerId;

-- 22. Find the customers associated with the employee who made the highest commission
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
),
highest_commission AS (
    SELECT 
        employeeid,
        MAX(commission_amount) AS max_commission
    FROM 
        commission_data
    GROUP BY 
        employeeid
),
highest_commission_employee AS (
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

-- 23. List all customers along with their support representatives' names
SELECT 
    c.customerid,
    c.firstname || ' ' || c.lastname AS "customer name",
    c.supportrepid, 
    e.firstname || ' ' || e.lastname AS "support representatives' names"
FROM 
    customer c
JOIN employee e ON c.supportrepid = e.employeeid
GROUP BY 
    c.customerid,
    c.firstname || ' ' || c.lastname,
    c.supportrepid, 
    e.firstname || ' ' || e.lastname;

-- 24. List all invoices along with the customer's name and email
SELECT
    i.customerid, 
    c.firstname || ' ' || c.lastname AS "Customer Name",
    c.email,
    i.invoiceid
FROM 
    invoice i
JOIN
    customer c ON c.customerid = i.customerid;

-- 25. Find the total number of invoices per customer
SELECT
    i.customerid, 
    c.firstname || ' ' || c.lastname AS "Customer Name",
    COUNT(i.invoiceid)
FROM 
    invoice i
JOIN 
    customer c ON c.customerid = i.customerid
GROUP BY 
    i.customerid, c.firstname, c.lastname;

/* Employee and Sales Analysis */
-- 26. Find the sales reps and total transaction amounts for each customer between 2011 and 2012
SELECT c.supportrepid, c.customerid, e.firstname || ' ' || e.lastname AS sales_rep, SUM(i.total)
FROM customer c 
JOIN employee e ON c.supportrepid = e.employeeid 
JOIN invoice i ON i.customerid = c.customerid
WHERE date_part('year', i.invoicedate) BETWEEN 2011 AND 2012
GROUP BY c.supportrepid, c.customerid, e.firstname, e.lastname
ORDER BY c.customerid DESC;

-- 27. Create a commission payout column that calculates 15% of the sales transaction amount for each employee
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

-- 28. List the top 3 employees by total commission earned
WITH employee_commissions AS (
    SELECT 
        e.employeeid,
        e.firstname || ' ' || e.lastname AS employee_name,
        e.title,
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
    total_commission
FROM 
    employee_commissions
ORDER BY 
    total_commission DESC
LIMIT 3;

-- 29. Find the average transaction amount for each customer
SELECT 
    c.customerid, 
    c.firstname, 
    c.lastname,
    AVG(i.total) AS average_transaction
FROM 
    customer c
JOIN 
    invoice i ON c.customerid = i.customerid
GROUP BY 
    c.customerid, c.firstname, c.lastname;

/* In-depth Customer and Financial Analysis */
-- 30. Find the customer who made the highest purchase
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

-- 31. Examine the record of the customer who made the highest purchase for any suspicious details
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

-- 32. Identify any employee whose total sales exceed the average transaction amount for 2011 and 2012
SELECT DISTINCT e.employeeid, e.firstname, e.lastname
FROM employee e
JOIN customer c ON c.supportrepid = e.employeeid
JOIN invoice i ON c.customerid = i.customerid
WHERE i.total > (SELECT AVG(i2.total) FROM invoice i2 WHERE date_part('year', i2.invoicedate) IN (2011, 2012))
AND date_part('year', i.invoicedate) IN (2011, 2012);

-- 33. Calculate the total sales per employee and per quarter
SELECT 
    e.employeeid, 
    e.firstname, 
    e.lastname,
    date_trunc('quarter', invoicedate) AS quarter,
    SUM(i.total) AS total_sales
FROM 
    employee e
JOIN 
    customer c ON c.supportrepid = e.employeeid 
JOIN 
    invoice i ON c.customerid = i.customerid
GROUP BY 
    e.employeeid, e.firstname, e.lastname, quarter
ORDER BY 
    e.employeeid, quarter;

-- 34. List the top 5 transactions by amount for each year
WITH transaction_amount AS (
    SELECT 
        date_trunc('year', i.invoicedate) AS year,
        i.total
    FROM 
        invoice i
),
ranked_transactions AS (
    SELECT 
        t.*, 
        RANK() OVER (PARTITION BY t.year ORDER BY t.total DESC) AS rank
    FROM 
        transaction_amount t
)
SELECT 
    *
FROM 
    ranked_transactions
WHERE 
    rank <= 5;

-- 35. Find customers who have made purchases in every year since 2011
WITH years AS (
    SELECT DISTINCT date_part('year', invoicedate) AS year
    FROM invoice
    WHERE date_part('year', invoicedate) >= 2011
),
customer_years AS (
    SELECT c.customerid, date_part('year', i.invoicedate) AS year
    FROM customer c
    JOIN invoice i ON c.customerid = i.customerid
    WHERE date_part('year', i.invoicedate) >= 2011
)
SELECT 
    c.customerid,
    c.firstname || ' ' || c.lastname AS "Customer Name"
FROM 
    customer c
WHERE NOT EXISTS (
    SELECT 1
    FROM years y
    LEFT JOIN customer_years cy ON c.customerid = cy.customerid AND y.year = cy.year
    WHERE cy.year IS NULL
)
ORDER BY c.customerid DESC;

/* Additional Analysis */
-- 36. List all support representatives (employees) who have supported customers from multiple countries
SELECT 
    e.employeeid, 
    e.firstname, 
    e.lastname,
    COUNT(DISTINCT c.country) AS country_count
FROM 
    employee e
JOIN 
    customer c ON e.employeeid = c.supportrepid
GROUP BY 
    e.employeeid, e.firstname, e.lastname
HAVING 
    COUNT(DISTINCT c.country) > 1;

-- 37. List all invoices along with the customer's name and the sales representative (employee) who supports them
SELECT 
    i.invoiceid,
    i.invoicedate,
    c.firstname || ' ' || c.lastname AS "Customer Name",
    e.firstname || ' ' || e.lastname AS "Sales Rep Name"
FROM 
    invoice i
JOIN 
    customer c ON i.customerid = c.customerid
JOIN 
    employee e ON c.supportrepid = e.employeeid
ORDER BY 
    i.invoiceid;

-- 38. Retrieve customers with missing information (e.g., no email or phone number)
SELECT 
    customerid, 
    firstname, 
    lastname
FROM 
    customer
WHERE 
    email IS NULL OR phone IS NULL;

-- 39. Find customers who have made purchases in every year since 2011
WITH years AS (
    SELECT DISTINCT date_part('year', invoicedate) AS year
    FROM invoice
    WHERE date_part('year', invoicedate) >= 2011
),
customer_years AS (
    SELECT c.customerid, date_part('year', i.invoicedate) AS year
    FROM customer c
    JOIN invoice i ON c.customerid = i.customerid
    WHERE date_part('year', i.invoicedate) >= 2011
)
SELECT 
    c.customerid,
    c.firstname || ' ' || c.lastname AS "Customer Name"
FROM 
    customer c
WHERE NOT EXISTS (
    SELECT 1
    FROM years y
    LEFT JOIN customer_years cy ON c.customerid = cy.customerid AND y.year = cy.year
    WHERE cy.year IS NULL
)
ORDER BY c.customerid DESC;

/* Additional Analysis */
-- 40. List all support representatives (employees) who have supported customers from multiple countries
SELECT 
    e.employeeid, 
    e.firstname, 
    e.lastname,
    COUNT(DISTINCT c.country) AS country_count
FROM 
    employee e
JOIN 
    customer c ON e.employeeid = c.supportrepid
GROUP BY 
    e.employeeid, e.firstname, e.lastname
HAVING 
    COUNT(DISTINCT c.country) > 1;

-- 41. List all invoices along with the customer's name and the sales representative (employee) who supports them
SELECT 
    i.invoiceid,
    i.invoicedate,
    c.firstname || ' ' || c.lastname AS "Customer Name",
    e.firstname || ' ' || e.lastname AS "Sales Rep Name"
FROM 
    invoice i
JOIN 
    customer c ON i.customerid = c.customerid
JOIN 
    employee e ON c.supportrepid = e.employeeid
ORDER BY 
    i.invoiceid;

-- 42. Retrieve customers with missing information (e.g., no email or phone number)
SELECT 
    customerid, 
    firstname, 
    lastname
FROM 
    customer
WHERE 
    email IS NULL OR phone IS NULL;

-- 43. Find the total sales per city
SELECT 
    billingcity,
    SUM(total) AS total_sales
FROM 
    invoice
GROUP BY 
    billingcity;

-- 44. Rank invoices by total amount within each billing country
SELECT
    i.*,
    RANK() OVER (PARTITION BY i.billingcountry ORDER BY i.total DESC) AS rank
FROM 
    invoice i;

/* Employee and Sales Analysis */
-- 45. Find employees who support customers with high total purchases
WITH employee_with_customer_purchase AS (
    SELECT 
        e.employeeid, 
        e.firstname AS employee_firstname, 
        e.lastname AS employee_lastname, 
        c.customerid, 
        c.firstname AS customer_firstname, 
        c.lastname AS customer_lastname,
        SUM(i.total) AS purchase
    FROM 
        employee e
    JOIN 
        customer c ON e.employeeid = c.supportrepid
    JOIN 
        invoice i ON i.customerid = c.customerid
    GROUP BY 
        e.employeeid, e.firstname, e.lastname, c.customerid, c.firstname, c.lastname
)
SELECT 
    employeeid, 
    employee_firstname, 
    employee_lastname,
    SUM(purchase) AS total_purchase
FROM 
    employee_with_customer_purchase
GROUP BY 
    employeeid, employee_firstname, employee_lastname
HAVING 
    SUM(purchase) > 1000;

-- 46. Find employees who support customers from different countries
SELECT 
    e.employeeid, 
    e.firstname, 
    e.lastname,
    COUNT(DISTINCT c.country) AS country_count
FROM 
    employee e
JOIN 
    customer c ON e.employeeid = c.supportrepid
GROUP BY 
    e.employeeid, e.firstname, e.lastname
HAVING 
    COUNT(DISTINCT c.country) > 1;

-- 47. Calculate the total sales per employee and per year
SELECT 
    e.employeeid, 
    e.firstname, 
    e.lastname, 
    DATE_TRUNC('year', i.invoicedate) AS year,
    SUM(i.total) AS total_sales
FROM 
    employee e
JOIN 
    customer c ON e.employeeid = c.supportrepid
JOIN 
    invoice i ON c.customerid = i.customerid
GROUP BY 
    e.employeeid, e.firstname, e.lastname, year
ORDER BY 
    year, total_sales DESC;

-- 48. Calculate the average number of invoices per customer per year
WITH yearly_invoices AS (
    SELECT 
        c.customerid,
        DATE_TRUNC('year', i.invoicedate) AS year,
        COUNT(i.invoiceid) AS invoice_count
    FROM 
        invoice i
    JOIN 
        customer c ON i.customerid = c.customerid
    GROUP BY 
        c.customerid, year
)
SELECT 
    year,
    AVG(invoice_count) AS avg_invoices_per_customer
FROM 
    yearly_invoices
GROUP BY 
    year
ORDER BY 
    year;

-- 49. List the top 3 employees by total sales for each year
WITH employee_sales AS (
    SELECT 
        e.employeeid,
        e.firstname || ' ' || e.lastname AS employee_name,
        DATE_TRUNC('year', i.invoicedate) AS year,
        SUM(i.total) AS total_sales
    FROM 
        employee e
    JOIN 
        customer c ON e.employeeid = c.supportrepid
    JOIN 
        invoice i ON c.customerid = i.customerid
    GROUP BY 
        e.employeeid, employee_name, year
)
SELECT 
    employeeid,
    employee_name,
    year,
    total_sales
FROM (
    SELECT 
        employeeid,
        employee_name,
        year,
        total_sales,
        RANK() OVER (PARTITION BY year ORDER BY total_sales DESC) AS rank
    FROM 
        employee_sales
) AS ranked_sales
WHERE 
    rank <= 3;

-- 50. Calculate the monthly sales growth rate
WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', invoicedate) AS month,
        SUM(total) AS monthly_sales
    FROM 
        invoice 
    GROUP BY 
        month
),
previous_month_sales AS (
    SELECT 
        month, 
        monthly_sales,
        LAG(monthly_sales) OVER (ORDER BY month) AS previous_month_sales
    FROM 
        monthly_sales
)
SELECT 
    month,
    monthly_sales,
    previous_month_sales,
    CASE
        WHEN previous_month_sales IS NULL THEN NULL
        ELSE ROUND(((monthly_sales - previous_month_sales) / previous_month_sales) * 100, 2)
    END AS growth_rate
FROM 
    previous_month_sales;

-- 51. Find the average invoice amount per support rep
SELECT 
    c.supportrepid, 
    AVG(i.total) AS avg_invoice_total
FROM 
    customer c
JOIN 
    invoice i ON c.customerid = i.customerid
GROUP BY 
    c.supportrepid;

/* Financial Analysis */
-- 52. Calculate the total commission for each employee based on 15% of their sales
SELECT 
    e.employeeid, 
    e.firstname, 
    e.lastname, 
    SUM(i.total) AS total_sales_amount, 
    SUM(i.total) * 0.15 AS commission_amount
FROM 
    employee e
JOIN 
    customer c ON c.supportrepid = e.employeeid 
JOIN 
    invoice i ON c.customerid = i.customerid
GROUP BY 
    e.employeeid, e.firstname, e.lastname;

-- 53. List the top 3 employees by total commission earned
WITH employee_commissions AS (
    SELECT 
        e.employeeid,
        e.firstname || ' ' || e.lastname AS employee_name,
        e.title,
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
    total_commission
FROM 
    employee_commissions
ORDER BY 
    total_commission DESC
LIMIT 3;

-- 54. Find customers with the highest transaction amounts in each country
WITH customer_transaction AS (
    SELECT 
        c.customerid, 
        c.firstname, 
        c.lastname, 
        i.billingcountry AS country,
        SUM(i.total) AS total_transaction
    FROM 
        customer c
    JOIN 
        invoice i ON i.customerid = c.customerid
    GROUP BY 
        c.customerid, c.firstname, c.lastname, country
)
SELECT 
    customerid, 
    firstname, 
    lastname, 
    country, 
    total_transaction
FROM (
    SELECT 
        customerid, 
        firstname, 
        lastname, 
        country, 
        total_transaction,
        RANK() OVER (PARTITION BY country ORDER BY total_transaction DESC) AS rank
    FROM 
        customer_transaction
) AS ranked_transactions
WHERE 
    rank <= 2;

/* Advanced Financial Analysis */
-- 55. List employees who exceeded the average transaction amount in 2011 and 2012
SELECT DISTINCT e.employeeid, e.firstname, e.lastname
FROM employee e
JOIN customer c ON c.supportrepid = e.employeeid 
JOIN invoice i ON c.customerid = i.customerid
WHERE i.total > (SELECT AVG(total) FROM invoice WHERE date_part('year', invoicedate) IN (2011, 2012))
AND date_part('year', i.invoicedate) IN (2011, 2012);

-- 56. Calculate the total sales per employee and per quarter
SELECT 
    e.employeeid, 
    e.firstname, 
    e.lastname,
    DATE_TRUNC('quarter', invoicedate) AS quarter,
    SUM(i.total) AS total_sales
FROM 
    employee e
JOIN 
    customer c ON c.supportrepid = e.employeeid 
JOIN 
    invoice i ON c.customerid = i.customerid
GROUP BY 
    e.employeeid, e.firstname, e.lastname, quarter
ORDER BY 
    e.employeeid, quarter;

-- 57. List the top 5 transactions by amount for each year
WITH transaction_amount AS (
    SELECT 
        DATE_TRUNC('year', i.invoicedate) AS year,
        i.total
    FROM 
        invoice i
),
ranked_transactions AS (
    SELECT 
        t.*, 
        RANK() OVER (PARTITION BY t.year ORDER BY t.total DESC) AS rank
    FROM 
        transaction_amount t
)
SELECT 
    *
FROM 
    ranked_transactions
WHERE 
    rank <= 5;

-- 58. Find customers who made purchases in multiple years
SELECT DISTINCT c.customerid, 
    c.firstname || ' ' || c.lastname AS "Customer Name",
    COUNT(DISTINCT date_part('year', i.invoicedate)) AS year_count
FROM customer c
JOIN invoice i ON c.customerid = i.customerid
GROUP BY c.customerid, c.firstname, c.lastname
HAVING COUNT(DISTINCT date_part('year', i.invoicedate)) > 1
ORDER BY year_count DESC;

/* Combining Multiple Conditions */
-- 59. Retrieve customers from a specific country who made purchases in 2011
SELECT 
    c.customerid, 
    c.firstname, 
    c.lastname,
    c.country,
    i.invoicedate
FROM 
    customer c
JOIN invoice i ON c.customerid = i.customerid
WHERE 
    date_part('year', invoicedate) = 2011
AND 
    country = 'Germany'
ORDER BY 
    i.invoicedate DESC;

-- 60. Find employees hired after a certain date who support customers from Canada
SELECT DISTINCT e.employeeid,
    e.firstname, 
    e.lastname, 
    e.hiredate
FROM 
    employee e
JOIN customer c ON c.supportrepid = e.employeeid
WHERE 
    e.hiredate > '2000-01-01'
AND 
    c.country = 'Canada'
ORDER BY 
    e.hiredate;