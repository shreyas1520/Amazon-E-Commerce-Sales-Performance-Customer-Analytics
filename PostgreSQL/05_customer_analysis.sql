-- Query 1 — Overall Customer KPIs
SELECT
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales,

    ROUND(
        AVG(total_amount),
        2
    ) AS overall_average_order_value
FROM ecommerce.amazon_sales;
---------------------------------------------

-- Query 2 — Customer Performance Overview

SELECT
    customer_id,
    customer_name,

    COUNT(DISTINCT order_id) AS total_orders,

    SUM(quantity) AS total_units_purchased,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_spent,

    ROUND(
        AVG(total_amount),
        2
    ) AS average_order_value,

    MIN(order_date) AS first_order_date,

    MAX(order_date) AS last_order_date

FROM ecommerce.amazon_sales

GROUP BY
    customer_id,
    customer_name

ORDER BY total_spent DESC;
------------------------------------------------

-- Query 3 — Top 20 Customers by Spending
SELECT
    customer_id,
    customer_name,

    COUNT(DISTINCT order_id) AS total_orders,

    SUM(quantity) AS total_units_purchased,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_spent,

    ROUND(
        AVG(total_amount),
        2
    ) AS average_order_value

FROM ecommerce.amazon_sales

GROUP BY
    customer_id,
    customer_name

ORDER BY total_spent DESC

LIMIT 20;
---------------------------------------------------

-- Query 4 — Top 20 Customers by Order Frequency

SELECT
    customer_id,
    customer_name,

    COUNT(DISTINCT order_id) AS total_orders,

    SUM(quantity) AS total_units_purchased,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_spent,

    ROUND(
        AVG(total_amount),
        2
    ) AS average_order_value

FROM ecommerce.amazon_sales

GROUP BY
    customer_id,
    customer_name

ORDER BY total_orders DESC,
         total_spent DESC

LIMIT 20;
--------------------------------------------------

-- Query 5 — Top Customers by Average Order Value

SELECT
    customer_id,
    customer_name,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(
        AVG(total_amount),
        2
    ) AS average_order_value,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_spent

FROM ecommerce.amazon_sales

GROUP BY
    customer_id,
    customer_name

HAVING COUNT(DISTINCT order_id) >= 3

ORDER BY average_order_value DESC

LIMIT 20;
------------------------------------------------------

-- Query 6 — Repeat Customer Analysis

WITH customer_orders AS (

    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders

    FROM ecommerce.amazon_sales

    GROUP BY customer_id
)

SELECT
    COUNT(*) AS total_customers,

    COUNT(*) FILTER (
        WHERE total_orders > 1
    ) AS repeat_customers,

    COUNT(*) FILTER (
        WHERE total_orders = 1
    ) AS one_time_customers

FROM customer_orders;
-------------------------------------------------------
-- Query 7 — Repeat Customer Percentage

WITH customer_orders AS (

    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders

    FROM ecommerce.amazon_sales

    GROUP BY customer_id
)

SELECT
    COUNT(*) AS total_customers,

    COUNT(*) FILTER (
        WHERE total_orders > 1
    ) AS repeat_customers,

    ROUND(
        COUNT(*) FILTER (
            WHERE total_orders > 1
        )::numeric
        / NULLIF(COUNT(*), 0)
        * 100,
        2
    ) AS repeat_customer_percentage

FROM customer_orders;
------------------------------------------------------

-- Query 8 — Customer Order Frequency Distribution

WITH customer_orders AS (

    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders

    FROM ecommerce.amazon_sales

    GROUP BY customer_id
)

SELECT
    total_orders,
    COUNT(*) AS number_of_customers

FROM customer_orders

GROUP BY total_orders

ORDER BY total_orders;
----------------------------------------------------

-- Query 9 — Customer Spending Segmentation

WITH customer_spending AS (

    SELECT
        customer_id,
        customer_name,

        SUM(total_amount) AS total_spent

    FROM ecommerce.amazon_sales

    GROUP BY
        customer_id,
        customer_name
),

median_spending AS (

    SELECT
        PERCENTILE_CONT(0.50)
        WITHIN GROUP (
            ORDER BY total_spent
        ) AS median_customer_spending

    FROM customer_spending
)

SELECT
    c.customer_id,
    c.customer_name,

    ROUND(
        c.total_spent,
        2
    ) AS total_spent,

    ROUND(
        m.median_customer_spending,
        2
    ) AS median_customer_spending,

    CASE
        WHEN c.total_spent >= m.median_customer_spending
            THEN 'High Value'
        ELSE 'Below Median'
    END AS customer_segment

FROM customer_spending c

CROSS JOIN median_spending m

ORDER BY c.total_spent DESC;
--------------------------------------------------

-- Query 10 — Customer RFM-Style Metrics

SELECT
    customer_id,
    customer_name,

    MAX(order_date) AS last_order_date,

    (
        MAX(order_date)
        - MAX(order_date) OVER ()
    ) AS recency_reference_difference,

    COUNT(DISTINCT order_id) AS frequency,

    ROUND(
        SUM(total_amount),
        2
    ) AS monetary_value

FROM ecommerce.amazon_sales

GROUP BY
    customer_id,
    customer_name;


WITH customer_metrics AS (
        customer_name,

        MAX(order_date) AS last_order_date,

        COUNT(DISTINCT order_id) AS frequency,

        SUM(total_amount) AS monetary_value

    FROM ecommerce.amazon_sales

    GROUP BY
        customer_id,
        customer_name
)

SELECT
    customer_id,
    customer_name,
    last_order_date,

    (
        SELECT MAX(order_date)
        FROM ecommerce.amazon_sales
    ) - last_order_date AS recency_days,

    frequency,

    ROUND(
        monetary_value,
        2
    ) AS monetary_value

FROM customer_metrics

ORDER BY monetary_value DESC;
-----------------------------------------------------------------------

-- Query 11 — RFM-Style Customer Segmentation

WITH customer_metrics AS (

    SELECT
        customer_id,
        customer_name,

        MAX(order_date) AS last_order_date,

        COUNT(DISTINCT order_id) AS frequency,

        SUM(total_amount) AS monetary_value

    FROM ecommerce.amazon_sales

    GROUP BY
        customer_id,
        customer_name
),

scored_customers AS (

    SELECT
        *,

        NTILE(5) OVER (
            ORDER BY last_order_date
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY frequency
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY monetary_value
        ) AS monetary_score

    FROM customer_metrics
)

SELECT
    customer_id,
    customer_name,
    last_order_date,

    frequency,
    ROUND(monetary_value, 2) AS monetary_value,

    recency_score,
    frequency_score,
    monetary_score,

    CASE
        WHEN frequency_score >= 4
             AND monetary_score >= 4
             AND recency_score >= 4
            THEN 'High Value Customer'

        WHEN frequency_score >= 4
             AND monetary_score >= 3
            THEN 'Frequent Customer'

        WHEN monetary_score >= 4
            THEN 'High Spender'

        WHEN recency_score <= 2
            THEN 'Needs Re-engagement'

        ELSE 'Regular Customer'
    END AS customer_segment

FROM scored_customers

ORDER BY monetary_value DESC;
------------------------------------------------------------

-- Query 12 — Customer Revenue Contribution

WITH customer_sales AS (

    SELECT
        customer_id,
        customer_name,

        SUM(total_amount) AS sales

    FROM ecommerce.amazon_sales

    GROUP BY
        customer_id,
        customer_name
)

SELECT
    customer_id,
    customer_name,

    ROUND(
        sales,
        2
    ) AS total_spent,

    ROUND(
        sales
        / NULLIF(SUM(sales) OVER (), 0)
        * 100,
        2
    ) AS sales_contribution_percent

FROM customer_sales

ORDER BY sales DESC;
--------------------------------------------------------------
-- Query 13 — Top 10% Customers' Revenue Contribution

WITH customer_sales AS (

    SELECT
        customer_id,
        SUM(total_amount) AS sales

    FROM ecommerce.amazon_sales

    GROUP BY customer_id
),

ranked_customers AS (

    SELECT
        *,
        NTILE(10) OVER (
            ORDER BY sales DESC
        ) AS customer_decile

    FROM customer_sales
)

SELECT
    ROUND(
        SUM(
            CASE
                WHEN customer_decile = 1
                    THEN sales
                ELSE 0
            END
        ),
        2
    ) AS top_10_percent_customer_sales,

    ROUND(
        SUM(sales),
        2
    ) AS total_sales,

    ROUND(
        SUM(
            CASE
                WHEN customer_decile = 1
                    THEN sales
                ELSE 0
            END
        )
        / NULLIF(SUM(sales), 0)
        * 100,
        2
    ) AS top_10_percent_sales_contribution

FROM ranked_customers;

-----------------------------------------------------------

-- Query 14 — Customer Purchase Category Diversity

SELECT
    customer_id,
    customer_name,

    COUNT(DISTINCT category) AS categories_purchased,

    COUNT(DISTINCT product_id) AS products_purchased,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_spent

FROM ecommerce.amazon_sales

GROUP BY
    customer_id,
    customer_name

ORDER BY categories_purchased DESC,
         total_spent DESC;
------------------------------------------------------------------------
-- Query 15 — Customer First and Last Purchase
SELECT
    customer_id,
    customer_name,

    MIN(order_date) AS first_order_date,

    MAX(order_date) AS last_order_date,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_spent

FROM ecommerce.amazon_sales

GROUP BY
    customer_id,
    customer_name

ORDER BY first_order_date;

-- Query 16 — Customer Lifetime Duration
SELECT
    customer_id,
    customer_name,

    MIN(order_date) AS first_order_date,

    MAX(order_date) AS last_order_date,

    MAX(order_date) - MIN(order_date)
        AS customer_lifetime_days,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_spent

FROM ecommerce.amazon_sales

GROUP BY
    customer_id,
    customer_name

ORDER BY customer_lifetime_days DESC;
-------------------------------------------------------

-- Query 17 — Customers with High Spend but Low Frequency

WITH customer_metrics AS (

    SELECT
        customer_id,
        customer_name,

        COUNT(DISTINCT order_id) AS total_orders,

        SUM(total_amount) AS total_spent,

        AVG(total_amount) AS average_order_value

    FROM ecommerce.amazon_sales

    GROUP BY
        customer_id,
        customer_name
),

benchmarks AS (

    SELECT
        PERCENTILE_CONT(0.75)
        WITHIN GROUP (
            ORDER BY total_spent
        ) AS high_spend_threshold,

        PERCENTILE_CONT(0.25)
        WITHIN GROUP (
            ORDER BY total_orders
        ) AS low_frequency_threshold

    FROM customer_metrics
)

SELECT
    c.customer_id,
    c.customer_name,

    c.total_orders,

    ROUND(
        c.total_spent,
        2
    ) AS total_spent,

    ROUND(
        c.average_order_value,
        2
    ) AS average_order_value

FROM customer_metrics c

CROSS JOIN benchmarks b

WHERE c.total_spent >= b.high_spend_threshold
  AND c.total_orders <= b.low_frequency_threshold

ORDER BY c.total_spent DESC;
---------------------------------------------------------

-- Query 18 — Customer KPI Summary

WITH customer_metrics AS (

    SELECT
        customer_id,

        COUNT(DISTINCT order_id) AS orders,

        SUM(total_amount) AS spending

    FROM ecommerce.amazon_sales

    GROUP BY customer_id
)

SELECT
    COUNT(*) AS total_customers,

    COUNT(*) FILTER (
        WHERE orders = 1
    ) AS one_time_customers,

    COUNT(*) FILTER (
        WHERE orders > 1
    ) AS repeat_customers,

    ROUND(
        AVG(orders),
        2
    ) AS average_orders_per_customer,

    ROUND(
        AVG(spending),
        2
    ) AS average_customer_spending,

    ROUND(
        SUM(spending),
        2
    ) AS total_customer_sales,

    ROUND(
        MAX(spending),
        2
    ) AS highest_customer_spending

FROM customer_metrics;

---------------------------------------------------------------------------