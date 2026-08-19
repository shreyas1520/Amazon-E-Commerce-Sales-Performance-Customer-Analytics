-- Query 1 — Overall Order KPIs

Start with the overall order picture.

SELECT
    COUNT(DISTINCT order_id) AS total_orders,

    COUNT(DISTINCT customer_id) AS total_customers,

    SUM(quantity) AS total_units_sold,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales,

    ROUND(
        AVG(total_amount),
        2
    ) AS average_order_value

FROM ecommerce.amazon_sales;
----------------------------------------------------

-- Query 2 — Order Status Distribution
SELECT
    order_status,

    COUNT(DISTINCT order_id) AS total_orders,

    COUNT(DISTINCT customer_id) AS total_customers,

    SUM(quantity) AS units_sold,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY order_status

ORDER BY total_orders DESC;
--------------------------------------------------------------------

-- Query 3 — Order Status Percentage

WITH status_orders AS (

    SELECT
        order_status,

        COUNT(DISTINCT order_id) AS orders

    FROM ecommerce.amazon_sales

    GROUP BY order_status
)

SELECT
    order_status,

    orders,

    ROUND(
        orders::numeric
        / NULLIF(SUM(orders) OVER (), 0)
        * 100,
        2
    ) AS order_share_percent

FROM status_orders

ORDER BY orders DESC;
-------------------------------------------------------------------
---------------------------------------------------------------------
-- Query 4 — Sales by Order Status
SELECT
    order_status,

    COUNT(DISTINCT order_id) AS orders,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales,

    ROUND(
        AVG(total_amount),
        2
    ) AS average_order_value

FROM ecommerce.amazon_sales

GROUP BY order_status

ORDER BY total_sales DESC;
--------------------------------------------------------------

-- Query 5 — Order Status by Month

SELECT
    DATE_TRUNC(
        'month',
        order_date
    )::date AS month,

    order_status,

    COUNT(DISTINCT order_id) AS orders,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY
    1,
    order_status

ORDER BY
    month,
    orders DESC;
---------------------------------------------------------------

-- Query 6 — Monthly Order Volume
SELECT
    DATE_TRUNC(
        'month',
        order_date
    )::date AS month,

    COUNT(DISTINCT order_id) AS total_orders,

    COUNT(DISTINCT customer_id) AS total_customers,

    SUM(quantity) AS units_sold,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales,

    ROUND(
        AVG(total_amount),
        2
    ) AS average_order_value

FROM ecommerce.amazon_sales

GROUP BY 1

ORDER BY month;
----------------------------------------------------------------

-- Query 7 — Payment Method Distribution

SELECT
    payment_method,

    COUNT(DISTINCT order_id) AS total_orders,

    COUNT(DISTINCT customer_id) AS total_customers,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY payment_method

ORDER BY total_orders DESC;
-----------------------------------------------------

-- Query 8 — Payment Method Share
WITH payment_orders AS (

    SELECT
        payment_method,

        COUNT(DISTINCT order_id) AS orders

    FROM ecommerce.amazon_sales

    GROUP BY payment_method
)

SELECT
    payment_method,

    orders,

    ROUND(
        orders::numeric
        / NULLIF(SUM(orders) OVER (), 0)
        * 100,
        2
    ) AS order_share_percent

FROM payment_orders

ORDER BY orders DESC;
-------------------------------------------------------

-- Query 9 — Payment Method Sales Performance
SELECT
    payment_method,

    COUNT(DISTINCT order_id) AS orders,

    COUNT(DISTINCT customer_id) AS customers,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales,

    ROUND(
        AVG(total_amount),
        2
    ) AS average_order_value

FROM ecommerce.amazon_sales

GROUP BY payment_method

ORDER BY total_sales DESC;
------------------------------------------------------

-- Query 10 — Payment Method and Order Status

SELECT
    payment_method,
    order_status,

    COUNT(DISTINCT order_id) AS orders,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY
    payment_method,
    order_status

ORDER BY
    payment_method,
    orders DESC;
---------------------------------------------------------------
-- Query 11 — Most Common Payment Method for Each Order Status

WITH payment_status_orders AS (

    SELECT
        order_status,
        payment_method,

        COUNT(DISTINCT order_id) AS orders

    FROM ecommerce.amazon_sales

    GROUP BY
        order_status,
        payment_method
),

ranked_payments AS (

    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY order_status
            ORDER BY orders DESC
        ) AS payment_rank

    FROM payment_status_orders
)

SELECT
    order_status,
    payment_method,
    orders

FROM ranked_payments

WHERE payment_rank = 1
--------------------------------------------

-- Query 12 — Average Order Value by Payment Method
SELECT
    payment_method,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(
        AVG(total_amount),
        2
    ) AS average_order_value,

    ROUND(
        MIN(total_amount),
        2
    ) AS minimum_order_value,

    ROUND(
        MAX(total_amount),
        2
    ) AS maximum_order_value

FROM ecommerce.amazon_sales

GROUP BY payment_method

ORDER BY average_order_value DESC;

--Query 13 — Payment Method by Category
SELECT
    category,
    payment_method,

    COUNT(DISTINCT order_id) AS orders,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY
    category,
    payment_method

ORDER BY
    category,
    orders DESC;
---------------------------------------------------------
-- Query 14 — Most Common Payment Method by Category
WITH category_payments AS (

    SELECT
        category,
        payment_method,

        COUNT(DISTINCT order_id) AS orders

    FROM ecommerce.amazon_sales

    GROUP BY
        category,
        payment_method
),

ranked_payments AS (

    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY orders DESC
        ) AS payment_rank

    FROM category_payments
)

SELECT
    category,
    payment_method,
    orders

FROM ranked_payments

WHERE payment_rank = 1

-- Query 15 — Payment Method by Country
SELECT
    country,
    payment_method,

    COUNT(DISTINCT order_id) AS orders,

    COUNT(DISTINCT customer_id) AS customers,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY
    country,
    payment_method

ORDER BY
    country,
    orders DESC;

-- Query 16 — Most Common Payment Method by Country
WITH country_payments AS (

    SELECT
        country,
        payment_method,

        COUNT(DISTINCT order_id) AS orders

    FROM ecommerce.amazon_sales

    GROUP BY
        country,
        payment_method
),

ranked_payments AS (

    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY country
            ORDER BY orders DESC
        ) AS payment_rank

    FROM country_payments
)

SELECT
    country,
    payment_method,
    orders

FROM ranked_payments

WHERE payment_rank = 1

ORDER BY country;

-- Query 17 — Payment Method by Seller

SELECT
    seller_id,
    payment_method,

    COUNT(DISTINCT order_id) AS orders,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY
    seller_id,
    payment_method

ORDER BY
    seller_id,
    total_sales DESC;

-- Query 18 — Order Status by Geography

SELECT
    country,
    state,
    order_status,

    COUNT(DISTINCT order_id) AS orders,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY
    country,
    state,
    order_status

ORDER BY
    country,
    state,
    orders DESC;

-- Query 19 — Payment Method Sales Contribution

WITH payment_sales AS (

    SELECT
        payment_method,

        SUM(total_amount) AS sales

    FROM ecommerce.amazon_sales

    GROUP BY payment_method
)

SELECT
    payment_method,

    ROUND(
        sales,
        2
    ) AS total_sales,

    ROUND(
        sales
        / NULLIF(SUM(sales) OVER (), 0)
        * 100,
        2
    ) AS sales_contribution_percent

FROM payment_sales

ORDER BY sales DESC;

-- Query 20 — Final Order & Payment KPI Summary

SELECT
    COUNT(DISTINCT order_id) AS total_orders,

    COUNT(DISTINCT customer_id) AS total_customers,

    COUNT(DISTINCT payment_method) AS payment_methods,

    COUNT(DISTINCT order_status) AS order_statuses,

    SUM(quantity) AS total_units_sold,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales,

    ROUND(
        AVG(total_amount),
        2
    ) AS average_order_value

FROM ecommerce.amazon_sales;