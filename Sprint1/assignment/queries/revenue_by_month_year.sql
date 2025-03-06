-- TODO: This query will return a table with the revenue by month and year. It
-- will have different columns: month_no, with the month numbers going from 01
-- to 12; month, with the 3 first letters of each month (e.g. Jan, Feb);
-- Year2016, with the revenue per month of 2016 (0.00 if it doesn't exist);
-- Year2017, with the revenue per month of 2017 (0.00 if it doesn't exist) and
-- Year2018, with the revenue per month of 2018 (0.00 if it doesn't exist).
WITH orders_clean AS (
    SELECT
        DISTINCT o.order_id,
        o.order_purchase_timestamp,
        op.payment_value
    FROM
        olist_order_payments op
        JOIN olist_orders o ON op.order_id = o.order_id
)
SELECT 
    CAST(
        STRFTIME('%m', oc.order_purchase_timestamp) AS INTEGER
    ) AS month_no,
    CASE
        CAST(
            STRFTIME('%m', oc.order_purchase_timestamp) AS INTEGER
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
    SUM(
        CASE
            WHEN STRFTIME('%Y', oc.order_purchase_timestamp) = '2016' THEN oc.payment_value
            ELSE 0.00
        END
    ) AS Year2016,
    SUM(
        CASE
            WHEN STRFTIME('%Y', oc.order_purchase_timestamp) = '2017' THEN oc.payment_value
            ELSE 0.00
        END
    ) AS Year2017,
    SUM(
        CASE
            WHEN STRFTIME('%Y', oc.order_purchase_timestamp) = '2018' THEN oc.payment_value
            ELSE 0.00
        END
    ) AS Year2018
FROM
    orders_clean oc
GROUP BY
    month_no
ORDER BY
    month_no;