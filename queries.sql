-- data flow test
SELECT *
FROM all_events
LIMIT 10;


-- MAIN DATA SET
-- find all users that have purchased and restrict data to up to first purchase date
-- UNION with original dataset to remove duplicate rows
WITH purchasers AS (
    SELECT DISTINCT user_id,
                    MIN(event_time) AS first_purchase_time
    FROM all_events
    WHERE event_type = 'purchase'
    GROUP BY 1
)

SELECT all_events.*
FROM all_events
JOIN purchasers
    ON all_events.user_id = purchasers.user_id
           AND all_events.event_time <= purchasers.first_purchase_time

UNION

SELECT all_events.*
FROM all_events
WHERE user_id NOT IN (
    SELECT DISTINCT user_id
    FROM all_events
    WHERE event_type = 'purchase'
 )


/* create recency, frequency, monetary value calculations (raw calc)
   then bin them into five quantiles and concatenate them to get RFM score bins
 */
WITH monetary_value_calc AS (
    SELECT user_id,
           AVG(added_cart_value) AS monetary_value
    FROM (
         SELECT user_id,
                user_session,
                SUM(price) AS added_cart_value
        FROM all_events
        WHERE (event_type = 'cart') AND (price > 0)
        GROUP BY 1, 2) AS total_value
    GROUP BY 1
),
rfm_raw AS (
    SELECT all_events.user_id,
           EXTRACT(DAY FROM CURRENT_DATE - MAX(event_time)) AS recency,
           COUNT(DISTINCT user_session) AS frequency,
           COALESCE(AVG(monetary_value), 0) AS monetary_value
    FROM all_events
    LEFT JOIN monetary_value_calc
        ON all_events.user_id = monetary_value_calc.user_id
    WHERE event_type != 'remove_from_cart'
    GROUP BY 1
    HAVING COUNT(DISTINCT user_session) > 1
),
rfm_scores AS (
    SELECT rfm_raw.user_id,
           NTILE(5) OVER(ORDER BY recency) AS r,
           NTILE(5) OVER(ORDER BY frequency) AS f,
           NTILE(5) OVER(ORDER BY monetary_value) AS m
    FROM all_events
    JOIN rfm_raw
    ON all_events.user_id = rfm_raw.user_id
)

SELECT DISTINCT user_id,
                rfm_raw.recency,
                rfm_raw.frequency,
                ROUND(rfm_raw.monetary_value, 2) AS monetary_value,
                r,
                f,
                m,
                CONCAT(r, f, m) AS rfm_score,
                CAST(CONCAT(r, f, m) AS INT) AS rfm_int
FROM rfm_raw
JOIN rfm_scores
USING(user_id);


-- count the number of actions of each type per user
SELECT user_id,
       SUM(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) AS num_views,
       SUM(CASE WHEN event_type = 'cart' THEN 1 ELSE 0 END) AS adds_to_cart,
FROM all_events
GROUP BY 1;


-- only users with more than one session
SELECT user_id,
       COUNT(user_session)
FROM all_events
GROUP BY 1
HAVING COUNT(user_session) > 1;


-- add to cart rate
WITH cart_sessions AS (
    SELECT all_events.user_id,
           add_to_cart_sessions,
           COUNT(user_session) AS total_sessions
    FROM all_events
    JOIN (
        SELECT user_id,
               COUNT(user_session) add_to_cart_sessions
        FROM all_events
        WHERE event_type = 'cart'
        GROUP BY 1) AS adds_to_cart
        ON all_events.user_id = adds_to_cart.user_id
    GROUP BY 1, 2
)

SELECT user_id,
       CASE WHEN total_sessions = 0 THEN 0 ELSE
           ROUND(CAST(add_to_cart_sessions AS decimal) / total_sessions, 2) END AS add_to_cart_rate
FROM cart_sessions;


-- segment by brand
-- fill brands that are null with 'other'
-- find total views and adds to cart per brand
-- divide number of views per brand per user over by that users total views
WITH brand_totals AS (
    SELECT user_id,
           COALESCE(brand, 'other') AS brand,
           SUM(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) AS num_views_per_brand,
           SUM(CASE WHEN event_type = 'cart' THEN 1 ELSE 0 END) AS num_carts_per_brand
    FROM all_events
    GROUP BY 1, 2
),
user_totals AS (
    SELECT DISTINCT user_id,
                    COALESCE(brand, 'other') AS brand,
                    SUM(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) OVER(PARTITION BY user_id) AS user_views,
                    SUM(CASE WHEN event_type = 'cart' THEN 1 ELSE 0 END) OVER(PARTITION BY user_id) AS user_carts
    FROM all_events
)

SELECT brand_totals.user_id,
       brand_totals.brand,
       CASE WHEN user_views = 0 THEN 0 ELSE
           ROUND(CAST(num_views_per_brand AS decimal) / user_views, 2) END AS perc_user_views,
       CASE WHEN user_carts = 0 THEN 0 ELSE
           ROUND(CAST(num_carts_per_brand AS decimal) / user_carts, 2) END AS perc_user_carts
FROM brand_totals
JOIN user_totals
    USING(user_id, brand);