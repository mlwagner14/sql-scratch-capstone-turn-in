SELECT COUNT(DISTINCT utm_campaign) as 'Campaign Count'  
FROM page_visits;
SELECT COUNT(DISTINCT utm_source) as 'Source Count' 
FROM page_visits;
SELECT DISTINCT utm_campaign as 'Campaign Name', utm_source as 'Source Name'
from page_visits;

SELECT DISTINCT page_name as 'Page Name'
from page_visits;

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attrib AS (
	  SELECT ft.user_id,
           ft.first_touch_at,
           pv.utm_source,
		       pv.utm_campaign
    FROM first_touch ft
    JOIN page_visits pv
    	ON ft.user_id = pv.user_id
    	AND ft.first_touch_at = pv.timestamp
  )
SELECT ft_attrib.utm_source,
       ft_attrib.utm_campaign,
       COUNT(*)
FROM ft_attrib
GROUP BY 2
ORDER BY 3 DESC;

WITH last_touch AS (
  SELECT user_id,
    MAX(timestamp) as last_touch_at
  FROM page_visits
  GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source,
       lt_attr.utm_campaign,
       COUNT(*)
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;


SELECT COUNT(DISTINCT user_id)
  FROM page_visits
  WHERE page_name = '4 - purchase';

WITH last_touch AS (
  SELECT user_id,
    MAX(timestamp) as last_touch_at
  FROM page_visits
  WHERE page_name = '4 - purchase'
  GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source,
       lt_attr.utm_campaign,
       COUNT(*)
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;



