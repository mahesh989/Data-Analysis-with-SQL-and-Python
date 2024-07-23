# WSDA Music Database SQL Queries

## Overview

This repository contains a collection of SQL queries designed to analyze and manipulate data from the WSDA Music Database. The database consists of several interconnected tables: `employee`, `customer`, `invoice`, and `invoiceline`. We cover schema information retrieval, basic table operations, data cleaning, counting and aggregations, joins, customer analysis, employee and sales analysis, and more.

## Database Schema

| employee    | customer     | invoice      | invoiceline  |
|-------------|--------------|--------------|--------------|
| employeeid  | supportrepid | invoiceid    | invoiceid    |
| lastname    | customerid   | customerid   | trackid      |
| firstname   | firstname    | invoicedate  | unitprice    |
| title       | lastname     | billingaddress | quantity    |
| reportsto   | company      | billingcity  |              |
| birthdate   | address      | billingstate |              |
| hiredate    | city         | billingcountry |              |
| address     | state        | billingpostalcode |          |
| city        | country      | total        |              |
| state       | postalcode   |              |              |
| country     | phone        |              |              |
| postalcode  | fax          |              |              |
| phone       | email        |              |              |
| fax         | supportrepid |              |              |
| email       |              |              |              |

## Categories of SQL Queries

### Schema Information
1. List all tables in the public schema
2. List columns in the customer table
3. List columns and data types in the invoiceline table

### Basic Table Operations
4. Select all records from the invoice table
5. Add a column to the invoice table
6. Drop a column from the invoice table
7. Rename a column in the invoice table
8. Change the data type of a column in the invoice table
9. Begin a transaction
10. Select records from the invoice table where billing city is Ottawa

### Data Cleaning and Updates
11. Update billing address fields in the invoice table to trimmed lower case
12. Correct misspelling in the billing city field

### Counting and Aggregations
13. Count the total number of customers
14. Find duplicate customers by first name and last name
15. Count the total number of employees
16. Count the number of invoices created in the year 2010
17. Calculate the total sales for the year 2010
18. Find the total number of transactions in each year
19. Find the total sales amount for each year
20. Find the number of invoices created in each month of 2012
21. Find the average transaction amount in the invoice table

### Joins and Customer Analysis
25. Join the invoice table with the customer table on CustomerId
26. Find the customers associated with the employee who made the highest commission
27. List all customers along with their support representatives' names
28. List all invoices along with the customer's name and email
29. Find the total number of invoices per customer

### Employee and Sales Analysis
30. Find the sales reps and total transaction amounts for each customer between 2011 and 2012
31. Create a commission payout column that calculates 15% of the sales transaction amount for each employee
32. List the top 3 employees by total commission earned
33. Find the average transaction amount for each customer
34. Calculate the total sales per employee and per year
35. Calculate the average number of invoices per customer per year
36. List the top 3 employees by total sales for each year
37. Calculate the monthly sales growth rate
38. Find the average invoice amount per support rep

### In-depth Customer and Financial Analysis
39. Find the customer who made the highest purchase
40. Examine the record of the customer who made the highest purchase for any suspicious details
41. Identify any employee whose total sales exceed the average transaction amount for 2011 and 2012
42. Calculate the total sales per employee and per quarter
43. List the top 5 transactions by amount for each year
44. Find customers who have made purchases in every year since 2011

### Additional Analysis
45. List all support representatives (employees) who have supported customers from multiple countries
46. List all invoices along with the customer's name and the sales representative (employee) who supports them
47. Retrieve customers with missing information (e.g., no email or phone number)
48. Find the total sales per city
49. Rank invoices by total amount within each billing country

### Combining Multiple Conditions
50. Retrieve customers from a specific country who made purchases in 2011
51. Find employees hired after a certain date who support customers from Canada

## Setup Instructions

1. Clone the repository to your local machine.
2. Open pgAdmin 4 and connect to your PostgreSQL database.
3. Use the provided SQL scripts in the appropriate categories to perform your analysis.
4. Ensure to switch databases and execute commands in the correct context when necessary.
