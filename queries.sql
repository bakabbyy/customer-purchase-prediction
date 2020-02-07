-- data flow test
SELECT *
FROM all_events
LIMIT 10;

/* create recency, frequency, monetary value calculations (raw calc)
   then bin them into five quantiles and concatenate them to get RFM scores
 */
WITH rfm_raw AS (
    SELECT user_id,
           EXTRACT(DAY FROM CURRENT_DATE - MAX(event_time)) AS recency,
           COUNT(DISTINCT user_session) AS frequency,
           SUM(CASE WHEN event_type != 'purchase' THEN price END) AS monetary_value
    FROM all_events
    GROUP BY 1
),
rfm_scores AS (
    SELECT rfm_raw.user_id,
           NTILE(5) OVER(ORDER BY recency DESC) AS r,
           NTILE(5) OVER(ORDER BY frequency DESC) AS f,
           NTILE(5) OVER(ORDER BY monetary_value DESC) AS m
    FROM all_events
    JOIN rfm_raw
    ON all_events.user_id = rfm_raw.user_id
)

SELECT DISTINCT user_id,
       CONCAT(r, f, m) AS rfm_score
FROM rfm_scores;

-- count the number of actions of each type per user
SELECT user_id,
       SUM(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS num_purchases,
       SUM(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) AS num_views,
       SUM(CASE WHEN event_type = 'cart' THEN 1 ELSE 0 END) AS adds_to_cart,
       SUM(CASE WHEN event_type = 'remove_from_cart' THEN 1 ELSE 0 END) AS removals_from_cart
FROM all_events
GROUP BY 1;

-- modify query above so that it only includes adds to cart where there wasn't a purchase
-- add an add to cart rate
WITH num_actions AS (
    SELECT user_id,
           SUM(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS num_purchases,
           SUM(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) AS num_views,
           SUM(CASE WHEN event_type = 'cart' AND event_type != 'purchase' THEN 1
               ELSE 0 END) AS adds_to_cart
    FROM all_events
    GROUP BY 1
)

SELECT user_id,
       num_purchases,
       num_views,
       adds_to_cart,
       adds_to_cart / num_views AS cart_rate
FROM num_actions;

-- only users with more tha one session
SELECT user_id,
       COUNT(user_session)
FROM all_events
GROUP BY 1
HAVING COUNT(user_session) > 1;

-- average cart amount per user --> indicator of...like income honestly
SELECT user_id,
       aslkjfklsd;
FROM all_events