# SQL & Data Interview Preparation

This repository includes SQL practice exercises from [DataLemur](https://datalemur.com/questions?category=SQL), inspired by the guide "How to Ace the Data Science Interview," to help prepare for data science and data analyst interviews at top tech companies.

## Histogram of Tweets

Assume you're given a table `tweets` with the following columns:
- `tweet_id` (integer)
- `user_id` (integer)
- `msg` (string)
- `tweet_date` (timestamp)

Write a query to obtain a histogram of tweets posted per user in 2022. Output the tweet count per user as the bucket and the number of Twitter users who fall into that bucket.

For the complete question, [click here](https://datalemur.com/questions/sql-histogram-tweets).

### SQL Code:
```sql
WITH twitter_data AS (
    SELECT 
        user_id, 
        COUNT(tweet_id) AS number_of_tweets
    FROM 
        tweets
    WHERE
        date_part('year', tweet_date) = 2022
    GROUP BY 
        user_id
)
SELECT 
    number_of_tweets AS tweet_bucket,
    COUNT(user_id) AS users_num
FROM 
    twitter_data
GROUP BY 
    number_of_tweets
ORDER BY 
    number_of_tweets;
```    

## Data Science Skills

Given a table `candidates` with the following columns:
- `candidate_id` (integer)
- `skill` (varchar)

You need to find candidates who are proficient in Python, Tableau, and PostgreSQL. Write a query to list the candidates who possess all of the required skills for the job. Sort the output by candidate ID in ascending order.

For the complete question, [click here](https://datalemur.com/questions/sql-histogram-tweets).

### SQL Code:
```sql
SELECT 
    candidate_id
FROM 
    candidates
WHERE 
    skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY 
    candidate_id
HAVING 
    COUNT(skill) = 3
ORDER BY 
    candidate_id; 
```

