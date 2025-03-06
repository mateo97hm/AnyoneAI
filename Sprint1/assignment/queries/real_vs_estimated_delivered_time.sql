-- TODO: This query will return a table with the differences between the real 
-- and estimated delivery times by month and year. It will have different 
-- columns: month_no, with the month numbers going from 01 to 12; month, with 
-- the 3 first letters of each month (e.g. Jan, Feb); Year2016_real_time, with 
-- the average delivery time per month of 2016 (NaN if it doesn't exist); 
-- Year2017_real_time, with the average delivery time per month of 2017 (NaN if 
-- it doesn't exist); Year2018_real_time, with the average delivery time per 
-- month of 2018 (NaN if it doesn't exist); Year2016_estimated_time, with the 
-- average estimated delivery time per month of 2016 (NaN if it doesn't exist); 
-- Year2017_estimated_time, with the average estimated delivery time per month 
-- of 2017 (NaN if it doesn't exist) and Year2018_estimated_time, with the 
-- average estimated delivery time per month of 2018 (NaN if it doesn't exist).
-- HINTS
-- 1. You can use the julianday function to convert a date to a number.
-- 2. order_status == 'delivered' AND order_delivered_customer_date IS NOT NULL
-- 3. Take distinct order_id.
WITH distinct_orders AS (
    SELECT
        DISTINCT o.order_id,
        o.order_purchase_timestamp,
        o.order_delivered_customer_date,
        o.order_estimated_delivery_date
    FROM
        olist_orders o
    WHERE
        o.order_status = 'delivered'
        AND o.order_delivered_customer_date IS NOT NULL
)
SELECT
    CAST(
        STRFTIME('%m', do.order_delivered_customer_date) AS INTEGER
    ) AS month_no,
    CASE
        CAST(
            STRFTIME('%m', do.order_delivered_customer_date) AS INTEGER
        )
        WHEN 1 THEN 'Jan'
        WHEN 2 THEN 'Feb'
        WHEN 3 THEN 'Mar'
        WHEN 4 THEN 'Apr'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'Jun'
        WHEN 7 THEN 'Jul'
        WHEN 8 THEN 'Aug'
        WHEN 9 THEN 'Sep'
        WHEN 10 THEN 'Oct'
        WHEN 11 THEN 'Nov'
        WHEN 12 THEN 'Dec'
    END AS month,
    AVG(
        CASE
            WHEN STRFTIME('%Y', do.order_delivered_customer_date) = '2016' THEN julianday(do.order_delivered_customer_date) - julianday(do.order_purchase_timestamp)
        END
    ) AS Year2016_real_time,
    AVG(
        CASE
            WHEN STRFTIME('%Y', do.order_delivered_customer_date) = '2017' THEN julianday(do.order_delivered_customer_date) - julianday(do.order_purchase_timestamp)
        END
    ) AS Year2017_real_time,
    AVG(
        CASE
            WHEN STRFTIME('%Y', do.order_delivered_customer_date) = '2018' THEN julianday(do.order_delivered_customer_date) - julianday(do.order_purchase_timestamp)
        END
    ) AS Year2018_real_time,
    AVG(
        CASE
            WHEN STRFTIME('%Y', do.order_delivered_customer_date) = '2016' THEN julianday(do.order_estimated_delivery_date) - julianday(do.order_purchase_timestamp)
        END
    ) AS Year2016_estimated_time,
    AVG(
        CASE
            WHEN STRFTIME('%Y', do.order_delivered_customer_date) = '2017' THEN julianday(do.order_estimated_delivery_date) - julianday(do.order_purchase_timestamp)
        END
    ) AS Year2017_estimated_time,
    AVG(
        CASE
            WHEN STRFTIME('%Y', do.order_delivered_customer_date) = '2018' THEN julianday(do.order_estimated_delivery_date) - julianday(do.order_purchase_timestamp)
        END
    ) AS Year2018_estimated_time
FROM
    distinct_orders do
GROUP BY
    month_no
ORDER BY
    month_no;