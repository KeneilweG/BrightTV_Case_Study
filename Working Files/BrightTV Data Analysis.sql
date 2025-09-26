--Examining the tables
SELECT * FROM brighttv.public.userprofile;
SELECT * FROM brighttv.public.viewership;

--number of records we have in the userprofile(5375)
SELECT COUNT(*)
FROM brighttv.public.userprofile;

--number of records we have in the viewership(10000)
SELECT COUNT(*)
FROM brighttv.public.viewership_tb;

--Checking missing values viewership (No Missing values record) 
SELECT *
FROM brighttv.public.viewership
WHERE userid IS NULL OR channel2 IS NULL OR recorddate2 IS NULL OR duration_2 IS NULL OR userid2 IS NULL OR "RecordDate2-new" IS NULL OR date IS NULL OR month IS NULL OR days IS NULL OR time IS NULL;

--Checking missing values userprofile (231 Missing values record) 
SELECT *
FROM brighttv.public.userprofile
WHERE userid IS NULL OR  name IS NULL OR surname IS NULL OR email IS NULL OR gender IS NULL OR
race IS NULL OR age IS NULL OR province IS NULL OR
social_media_handle IS NULL;

--Checking duplicates values for user profiles (No duplicates)
SELECT *, Count(*)
FROM brighttv.public.userprofile
GROUP BY ALL
HAVING Count(*)>1;

--Checking duplicates values for viewership (5 duplicates discovered)
SELECT *, Count(*)
FROM brighttv.public.viewership
GROUP BY ALL
HAVING Count(*)>1;

--Remove the Duplicates by selecting the unique values from viewship 
CREATE OR REPLACE TABLE brighttv.public.new_viewership AS
SELECT DISTINCT * 
FROM brighttv.public.viewership;

--Replacing and creating the new table with 'None' whenever there a NULL
CREATE OR REPLACE TABLE brighttv.public.new_userprofile AS
SELECT 
  COALESCE(userid, 0) AS userid,
  COALESCE(name, 'None') AS name,
  COALESCE(surname, 'None') AS surname,
  COALESCE(email, 'None') AS email,
  COALESCE(gender, 'None') AS gender,
  COALESCE(age, 0) AS age,
  COALESCE(race, 'None') AS race,
  COALESCE(province, 'None') AS province,
  COALESCE(social_media_handle,'None') AS social_media_handle
FROM brighttv.public.userprofile;

--Run the replaced or new datasets
SELECT * FROM brighttv.public.new_userprofile;
SELECT * FROM brighttv.public.new_viewership;

--Checking Again missing values userprofile (No Missing values record) 
SELECT *
FROM brighttv.public.new_userprofile
WHERE userid IS NULL OR  name IS NULL OR surname IS NULL OR email IS NULL OR gender IS NULL OR
race IS NULL OR age IS NULL OR province IS NULL OR
social_media_handle IS NULL;

--Checking duplicates values Again for user profiles (No duplicates)
SELECT *, Count(*)
FROM brighttv.public.new_viewership
GROUP BY ALL
HAVING Count(*)>1;

--number of rows in the new viewership table (9995)
SELECT COUNT(*)
FROM brighttv.public.new_viewership;

--number of rows in the new userprofile table (5375)
SELECT COUNT(*)
FROM brighttv.public.new_userprofile;

--Case
--Age Min
SELECT MIN(age)
FROM brighttv.public.new_userprofile
WHERE age>0;

--Age Max
SELECT MAX(age)
FROM brighttv.public.new_userprofile;

--Case Age Bucket Created
SELECT
    CASE 
  WHEN age <= 17 THEN 'below or equal to 17'
  WHEN age BETWEEN 18 AND 30 THEN '18-30'
  WHEN age BETWEEN 31 AND 43 THEN '31-43'
  WHEN age BETWEEN 44 AND 56 THEN '44–56'
  WHEN age BETWEEN 57 AND 69 THEN '57–69'
  ELSE 'Not Classified'
END AS age_bucket
FROM brighttv.public.new_userprofile;

--Time Bucket Created
SELECT 
CASE
    WHEN time BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
    WHEN  time BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
    WHEN  time BETWEEN '16:00:00' AND '20:00:00' THEN 'Evening'
    ELSE 'Night'
    END AS time_bucket
 FROM brighttv.public.new_viewership;
 
 --Checking Minimum duration
SELECT MIN(duration_2)
FROM brighttv.public.new_viewership;

--Checking Maximum duration
SELECT MAX(duration_2)
FROM brighttv.public.new_viewership;

--Creating a bucket Duration
SELECT 
CASE 
  WHEN duration_2 BETWEEN '00:00:00' AND '00:05:00' THEN '0–5 min'
  WHEN duration_2 BETWEEN '00:05:01' AND '00:15:00' THEN '6–15 min'
  WHEN duration_2 BETWEEN '00:15:01' AND '00:30:00' THEN '16–30 min'
  WHEN duration_2 BETWEEN '00:30:01' AND '01:00:00' THEN '31–60 min'
  WHEN duration_2 BETWEEN '01:00:01' AND '03:00:00' THEN '1–3 hrs'
  WHEN duration_2 BETWEEN '03:00:01' AND '06:00:00' THEN '3–6 hrs'
  ELSE 'Not Specified'
END AS duration_bucket
FROM brighttv.public.new_viewership;

--Checking Unique channels
SELECT DISTINCT channel2
FROM brighttv.public.new_viewership;

--Checking Unique genders
SELECT DISTINCT gender
FROM brighttv.public.new_userprofile;

--Checking Unique provinces
SELECT DISTINCT province
FROM brighttv.public.new_userprofile;

--Checking Unique races
SELECT DISTINCT race
FROM brighttv.public.new_userprofile;

SELECT
    COUNT(DISTINCT B.userid) AS viewers_count,
    COUNT(*) AS total_profiles,

    days,
    month AS months,
    time,
    date,
    duration_2,
    channel2,
    race,
    province,
    gender,

    CASE 
      WHEN age <= 17 THEN 'below or equal to 17'
      WHEN age BETWEEN 18 AND 30 THEN '18-30'
      WHEN age BETWEEN 31 AND 43 THEN '31-43'
      WHEN age BETWEEN 44 AND 56 THEN '44–56'
      WHEN age BETWEEN 57 AND 69 THEN '57–69'
      ELSE 'Not Classified'
    END AS age_bucket,

    CASE
      WHEN time BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
      WHEN  time BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
      WHEN  time BETWEEN '16:00:00' AND '20:00:00' THEN 'Evening'
      ELSE 'Night'
    END AS time_bucket,

    CASE 
      WHEN duration_2 BETWEEN '00:00:00' AND '00:05:00' THEN '0–5 min'
      WHEN duration_2 BETWEEN '00:05:01' AND '00:15:00' THEN '6–15 min'
      WHEN duration_2 BETWEEN '00:15:01' AND '00:30:00' THEN '16–30 min'
      WHEN duration_2 BETWEEN '00:30:01' AND '01:00:00' THEN '31–60 min'
      WHEN duration_2 BETWEEN '01:00:01' AND '03:00:00' THEN '1–3 hrs'
      WHEN duration_2 BETWEEN '03:00:01' AND '06:00:00' THEN '3–6 hrs'
      ELSE 'Not Specified'
    END AS duration_bucket

    FROM brighttv.public.new_userprofile AS A
    INNER JOIN brighttv.public.new_viewership AS B
    ON A.userid=B.userid
    GROUP BY ALL;
