SELECT 
    *
FROM
    parks_and_recreation.user_sub_sql_mentor06nov;
-- Q.1 List all distinct users and their stats (return user_name, total_submissions, points earned)
-- Q.2 Calculate the daily average points for each user.
-- Q.3 Find the top 3 users with the most positive submissions for each day.
-- Q.4 Find the top 5 users with the highest number of incorrect submissions.
-- Q.5 Find the top 10 performers for each week.
--------------------
-- My Solutions
--------------------
-- Answer of Question 1(List all distinct users and their stats (return user_name, total_submissions, points earned))
select 
username as 'return user_name' ,
count( id ) as total_submission ,
sum(points) as 'points earned' 
from user_sub_sql_mentor06nov
group by username 
order by sum(points) desc
;
-- Answer of Question 2 (Calculate the daily average points for each user)
SELECT 
    username,
    DATE_FORMAT(submitted_at, '%d-%m') AS Date,
    AVG(points) AS 'Daily Average Points'
FROM
    user_sub_sql_mentor06nov
GROUP BY username , DATE_FORMAT(submitted_at, '%d-%m')
ORDER BY username , AVG(points) DESC

;
-- Answer of Question 3(Find the top 3 users with the most positive submissions for each day.)

with ranking as (
    select
        username,
        date_format(submitted_at, '%d-%m') as date,
        sum(if(points > 0, 1, 0)) as `daily points`
    from user_sub_sql_mentor06nov
    group by username, date_format(submitted_at, '%d-%m')
),
ranked as (
    select
        username,
        `daily points`,
        dense_rank() over (
            partition by username 
            order by `daily points` desc
        ) as ranks
    from ranking
)
select *
from ranked
where ranks <= 3
order by username, ranks;
-- Answer of Question 4 ( Find the top 5 users with the highest number of incorrect submissions)
SELECT 
    username,
    SUM(IF(points > 0, 0, 1)) AS 'incorrect submissions'
FROM
    user_sub_sql_mentor06nov
GROUP BY username
ORDER BY SUM(IF(points > 0, 0, 1)) DESC
LIMIT 5
;
-- Answer of Question 5(Find the top 10 performers for each week)

with  ranking as
(
SELECT
  EXTRACT(WEEK FROM submitted_at) AS 'week_no',
  username,
  SUM(points) AS 'total_points',
  DENSE_RANK() OVER (
    PARTITION BY EXTRACT(WEEK FROM submitted_at)
    ORDER BY SUM(points) DESC
  ) AS 'rank'
FROM user_sub_sql_mentor06nov

GROUP BY week_no
ORDER BY week_no DESC 
)
select *
from ranking
where 'rank' <= 10
;


