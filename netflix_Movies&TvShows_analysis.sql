-- 1 problem :-
select 
type,
COUNT(*) as counts 
from netflix_data
group by type;
-- 2 problem:-
select
type ,
rating 
from (
select 
type, 
rating,
count(*) as counts,
rank() over(partition by type order by count(*) desc)as ranking
from netflix_data
group by type ,rating
) as t1
where ranking=1;
--problem 3
select * from netflix_data
where type='Movie' and release_year=2020;
--problem 4
SELECT top 5
    trim(value) AS new_country,
    COUNT(show_id) AS total_content
FROM netflix_data
CROSS APPLY STRING_SPLIT(country, ',')
GROUP BY trim(value) 
order by 2 desc ;
--problem 5
SELECT 
    title
FROM netflix_data
WHERE 
    type = 'Movie' 
    AND CAST(LEFT(duration, CHARINDEX(' ', duration + ' ') - 1) AS INT) = 
        (SELECT MAX(CAST(LEFT(duration, CHARINDEX(' ', duration + ' ') - 1) AS INT))
         FROM netflix_data 
         WHERE type = 'Movie');

-- problem 6
SELECT *, 
       CAST(date_added AS DATE) AS converted_date
FROM netflix_data
WHERE CAST(date_added AS DATE) >= DATEADD(YEAR, -5, GETDATE());
-- problem 7
select * from netflix_data where director LIKE '%Rajiv Chilaka%';
--problem 8
SELECT 
    *, 
    CAST(LEFT(duration, CHARINDEX(' ', duration + ' ') - 1) AS INT) AS sessions
FROM netflix_data
WHERE type = 'TV Show'
  AND CAST(LEFT(duration, CHARINDEX(' ', duration + ' ') - 1) AS INT) > 5;
  --problem 9
  select 
  COUNT(show_id) AS total_content,
  trim(value) as genre
  from netflix_data cross apply string_split(listed_in,',')  
  group by TRIM(value) 
  order by count(show_id) desc
-- problem 10
SELECT 
    YEAR(CONVERT(DATE, date_added, 101)) AS year,  -- Convert to date and extract the year
    COUNT(*) AS yearly_content,
    ROUND(
        CAST(COUNT(*) AS FLOAT) / 
        (SELECT COUNT(*) FROM netflix_data WHERE country = 'India') * 100, 2
    ) AS avg_content_per_year
FROM netflix_data
WHERE country = 'India'
GROUP BY YEAR(CONVERT(DATE, date_added, 101))
order by avg_content_per_year desc;
-- problem 11
with table1 as(
select trim(value) as genre from netflix_data cross apply string_split(listed_in,',')  
  group by TRIM(value) 
  )
  select * from netflix_data n,table1 t1 where t1.genre='documentaries' and n.type='Movie'
  --problem 12
  select * from netflix_data where director is null
  --problem 13
  select 
  count(show_id) as no_of_movies
  from netflix_data 
  where cast like'%Salman Khan%'
  and cast like '%salman khan%' 
  and release_year> year(GETDATE())-10

  -- problem 14

  select top 10 trim(value)as actors , count(*) as total_content 
  from netflix_data cross apply string_split(cast,',')
  where country like'%India%' or country like'%india%'
  group by TRIM(value)
  order by total_content desc , actors asc;
  -- problem 15
 SELECT 
    CASE 
        WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
        ELSE 'Good'
    END AS content_category,
    COUNT(*) AS content_count
FROM netflix_data
GROUP BY 
    CASE 
        WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
        ELSE 'Good'
    END
