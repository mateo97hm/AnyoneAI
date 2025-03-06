-- TODO: This query will return a table with two columns; order_status, and
-- Ammount. The first one will have the different order status classes and the
-- second one the total ammount of each.
SELECT
    o.order_status,
    op.payment_value as Ammount
FROM
    olist_order_payments op
    JOIN olist_orders o ON o.order_id = op.order_id;