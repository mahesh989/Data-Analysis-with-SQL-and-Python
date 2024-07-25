/* 
Overview:
In this document, we will perform various SQL queries to analyze 
and manipulate data from the WSDA Music Database. The database 
consists of several interconnected tables: `employee`, `customer`, 
`invoice`, and `invoiceline`. We will cover schema information 
retrieval, basic table operations, data cleaning, counting and 
aggregations, joins, customer analysis, employee and sales analysis, 

Database Schema:
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
+-------------+ 
*/

/* Schema Information */
```SQL
-- 1. List all tables in the public schema
-- 2. List columns in the customer table
-- 3. List columns and data types in the invoiceline table ```

/* Basic Table Operations */
-- 4. Select all records from the invoice table
-- 5. Add a column to the invoice table
-- 6. Drop a column from the invoice table
-- 7. Rename a column in the invoice table
-- 8. Change the data type of a column in the invoice table
-- 9. Begin a transaction
-- 10. Select records from the invoice table where billing city is Ottawa

/* Data Cleaning and Updates */
-- 11. Update billing address fields in the invoice table to trimmed lower case
-- 12. Correct misspelling in the billing city field

/* Counting and Aggregations */
-- 13. Count the total number of customers
-- 14. Find duplicate customers by first name and last name
-- 15. Count the total number of employees
-- 16. Count the number of invoices created in the year 2010
-- 17. Calculate the total sales for the year 2010
-- 18. Find the total number of transactions in each year
-- 19. Find the total sales amount for each year
-- 20. Find the number of invoices created in each month of 2012
-- 21. Find the average transaction amount in the invoice table
-- 22. Find the number of transactions above the average transaction amount
-- 23. Find the customers who made purchases between 2011 and 2012
-- 24. Find the total sales amount for each customer

/* Joins and Customer Analysis */
-- 25. Join the invoice table with the customer table on CustomerId
-- 26. Find the customers associated with the employee who made the highest commission
-- 27. List all customers along with their support representatives' names
-- 28. List all invoices along with the customer's name and email
-- 29. Find the total number of invoices per customer
-- 30. Retrieve all customers who have an invoice and include the invoice details
-- 31. Find customers who made purchases in multiple years
-- 32. Retrieve the highest and lowest invoice totals
-- 33. Find customers who have never made a purchase
-- 34. List employees who have not been assigned any customers
-- 35. Retrieve customers who made their first purchase in 2011
-- 36. Find the top 5 customers by total purchases

/* Employee and Sales Analysis */
-- 37. Find the sales reps and total transaction amounts for each customer between 2011 and 2012
-- 38. Create a commission payout column that calculates 15% of the sales transaction amount for each employee
-- 39. List the top 3 employees by total commission earned
-- 40. Find the average transaction amount for each customer
-- 41. Find employees who support customers with high total purchases
-- 42. Find employees who support customers from different countries
-- 43. Calculate the total sales per employee and per year
-- 44. Calculate the average number of invoices per customer per year
-- 45. List the top 3 employees by total sales for each year
-- 46. Calculate the monthly sales growth rate
-- 47. Find the average invoice amount per support rep
-- 48. Calculate the total commission for each employee based on 15% of their sales
-- 49. Find employees who have generated sales above a certain threshold

/* In-depth Customer and Financial Analysis */
-- 50. Find the customer who made the highest purchase
-- 51. Examine the record of the customer who made the highest purchase for any suspicious details
-- 52. Identify any employee whose total sales exceed the average transaction amount for 2011 and 2012
-- 53. Calculate the total sales per employee and per quarter
-- 54. List the top 5 transactions by amount for each year
-- 55. Find customers who have made purchases in every year since 2011
-- 56. List all support representatives (employees) who have supported customers from multiple countries
-- 57. List all invoices along with the customer's name and the sales representative (employee) who supports them
-- 58. Retrieve customers with missing information (e.g., no email or phone number)
-- 59. Find the total sales per city
-- 60. Rank invoices by total amount within each billing country