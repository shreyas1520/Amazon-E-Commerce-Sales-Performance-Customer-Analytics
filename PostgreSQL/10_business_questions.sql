-- Query 1 — What is the overall business performance?
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT product_id) AS total_products,
    COUNT(DISTINCT seller_id) AS total_sellers,
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
---------------------------------------------------------------

-- Query 2 — Which month generated the highest sales?
SELECT
    DATE_TRUNC(
        'month',
        order_date
    )::date AS month,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales,

    COUNT(DISTINCT order_id) AS orders

FROM ecommerce.amazon_sales

GROUP BY 1

ORDER BY total_sales DESC

LIMIT 1;
--------------------------------------------------------------------

-- Query 3 — Which month had the highest number of orders?
SELECT
    DATE_TRUNC(
        'month',
        order_date
    )::date AS month,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY 1

ORDER BY total_orders DESC

LIMIT 1;
------------------------------------------------------

-- Query 4 — Which category is the strongest?
SELECT
    category,

    COUNT(DISTINCT order_id) AS orders,

    COUNT(DISTINCT product_id) AS products,

    SUM(quantity) AS units_sold,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY category

ORDER BY total_sales DESC

LIMIT 1;
----------------------------------------------------------------------

-- Query 5 — Which product is the best seller?
SELECT
    product_id,
    product_name,
    category,
    brand,

    SUM(quantity) AS units_sold,

    COUNT(DISTINCT order_id) AS orders,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY
    product_id,
    product_name,
    category,
    brand

ORDER BY total_sales DESC

LIMIT 1;

-- Query 6 — Which product sells the most units?

SELECT
    product_id,
    product_name,
    category,
    brand,

    SUM(quantity) AS units_sold,

    COUNT(DISTINCT order_id) AS orders,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY
    product_id,
    product_name,
    category,
    brand

ORDER BY units_sold DESC

LIMIT 1;

-- Query 7 — Who is the highest-value customer?
SELECT
    customer_id,
    customer_name,

    COUNT(DISTINCT order_id) AS total_orders,

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

LIMIT 1;
---------------------------------------------------------------

-- Query 8 — What percentage of customers are repeat customers?
WITH customer_orders AS (

    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS orders

    FROM ecommerce.amazon_sales

    GROUP BY customer_id
)

SELECT
    COUNT(*) AS total_customers,

    COUNT(*) FILTER (
        WHERE orders > 1
    ) AS repeat_customers,

    ROUND(
        COUNT(*) FILTER (
            WHERE orders > 1
        )::numeric
        / NULLIF(COUNT(*), 0)
        * 100,
        2
    ) AS repeat_customer_percentage

FROM customer_orders;
------------------------------------------------------------------

-- Query 9 — Which seller generates the highest sales?
SELECT
    seller_id,

    COUNT(DISTINCT order_id) AS orders,

    COUNT(DISTINCT customer_id) AS customers,

    COUNT(DISTINCT product_id) AS products,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY seller_id

ORDER BY total_sales DESC

LIMIT 1;

-- Query 10 — How concentrated are sales among the top sellers?

WITH seller_sales AS (

    SELECT
        seller_id,
        SUM(total_amount) AS sales

    FROM ecommerce.amazon_sales

    GROUP BY seller_id
),

ranked_sellers AS (

    SELECT
        *,
        NTILE(10) OVER (
            ORDER BY sales DESC
        ) AS seller_decile

    FROM seller_sales
)

SELECT
    ROUND(
        SUM(
            CASE
                WHEN seller_decile = 1
                    THEN sales
                ELSE 0
            END
        ),
        2
    ) AS top_10_percent_sales,

    ROUND(
        SUM(sales),
        2
    ) AS total_sales,

    ROUND(
        SUM(
            CASE
                WHEN seller_decile = 1
                    THEN sales
                ELSE 0
            END
        )
        / NULLIF(SUM(sales), 0)
        * 100,
        2
    ) AS top_10_percent_sales_share

FROM ranked_sellers;
-----------------------------------------------------------------

-- Query 11 — Which country generates the most sales?
SELECT
    country,

    COUNT(DISTINCT order_id) AS orders,

    COUNT(DISTINCT customer_id) AS customers,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY country

ORDER BY total_sales DESC

LIMIT 1;

-- Query 12 — Which state generates the most sales?
SELECT
    country,
    state,

    COUNT(DISTINCT order_id) AS orders,

    COUNT(DISTINCT customer_id) AS customers,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY
    country,
    state

ORDER BY total_sales DESC

LIMIT 1;

-- Query 13 — Which city generates the most sales?
SELECT
    country,
    state,
    city,

    COUNT(DISTINCT order_id) AS orders,

    COUNT(DISTINCT customer_id) AS customers,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY
    country,
    state,
    city

ORDER BY total_sales DESC

LIMIT 1;

-- Query 14 — Which payment method is most popular?
SELECT
    payment_method,

    COUNT(DISTINCT order_id) AS orders,

    COUNT(DISTINCT customer_id) AS customers,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY payment_method

ORDER BY orders DESC

LIMIT 1;

-- Query 15 — Which payment method has the highest AOV?
SELECT
    payment_method,

    COUNT(DISTINCT order_id) AS orders,

    ROUND(
        AVG(total_amount),
        2
    ) AS average_order_value,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY payment_method

HAVING COUNT(DISTINCT order_id) >= 10

ORDER BY average_order_value DESC

LIMIT 1;

-- Query 16 — Which category receives the highest average discount?
SELECT
    category,

    ROUND(
        AVG(discount) * 100,
        2
    ) AS average_discount_percent,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY category

ORDER BY average_discount_percent DESC

LIMIT 1;

-- Query 17 — Which products have high discounts but low sales?


WITH product_metrics AS (

    SELECT
        product_id,
        product_name,
        category,

        AVG(discount) AS avg_discount,

        SUM(total_amount) AS sales

    FROM ecommerce.amazon_sales

    GROUP BY
        product_id,
        product_name,
        category
),

benchmarks AS (

    SELECT
        PERCENTILE_CONT(0.50)
        WITHIN GROUP (
            ORDER BY avg_discount
        ) AS median_discount,

        PERCENTILE_CONT(0.50)
        WITHIN GROUP (
            ORDER BY sales
        ) AS median_sales

    FROM product_metrics
)

SELECT
    p.product_id,
    p.product_name,
    p.category,

    ROUND(
        p.avg_discount * 100,
        2
    ) AS average_discount_percent,

    ROUND(
        p.sales,
        2
    ) AS total_sales

FROM product_metrics p

CROSS JOIN benchmarks b

WHERE p.avg_discount >= b.median_discount
  AND p.sales < b.median_sales

ORDER BY p.avg_discount DESC;
--------------------------------------------------------------

-- Query 18 — Which products generate high sales with relatively low discounts?

WITH product_metrics AS (
        SUM(total_amount) AS sales

    FROM ecommerce.amazon_sales

    GROUP BY
        product_id,
        product_name,
        category
),
benchmarks AS (

    SELECT
        PERCENTILE_CONT(0.50)
        WITHIN GROUP (
            ORDER BY avg_discount
        ) AS median_discount,

        PERCENTILE_CONT(0.50)
        WITHIN GROUP (
            ORDER BY sales
        ) AS median_sales

    FROM product_metrics
)

SELECT
    p.product_id,
    p.product_name,
    p.category,

    ROUND(
        p.avg_discount * 100,
        2
    ) AS average_discount_percent,

    ROUND(
        p.sales,
        2
    ) AS total_sales

FROM product_metrics p

CROSS JOIN benchmarks b

WHERE p.avg_discount < b.median_discount
  AND p.sales >= b.median_sales

ORDER BY p.sales DESC;
---------------------------------------------------

-- Query 19 — Which order status has the highest sales?
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

ORDER BY total_sales DESC

LIMIT 1;
---------------------------------------------------

-- Query 20 — What is the monthly sales growth?
WITH monthly_sales AS (

    SELECT
        DATE_TRUNC(
            'month',
            order_date
        )::date AS month,

        SUM(total_amount) AS sales

    FROM ecommerce.amazon_sales

    GROUP BY 1
),

monthly_growth AS (

    SELECT
        month,
        sales,

        LAG(sales) OVER (
            ORDER BY month
        ) AS previous_month_sales

    FROM monthly_sales
)

SELECT
    month,

    ROUND(
        sales,
        2
    ) AS total_sales,

    ROUND(
        previous_month_sales,
        2
    ) AS previous_month_sales,

    ROUND(
        (
            sales - previous_month_sales
        )
        / NULLIF(previous_month_sales, 0)
        * 100,
        2
    ) AS month_over_month_growth_percent

FROM monthly_growth

ORDER BY month;
---------------------------------------------------------

-- Query 21 — Which month experienced the largest growth?
WITH monthly_sales AS (

    SELECT
        DATE_TRUNC(
            'month',
            order_date
        )::date AS month,

        SUM(total_amount) AS sales

    FROM ecommerce.amazon_sales

    GROUP BY 1
),

monthly_growth AS (

    SELECT
        month,
        sales,

        LAG(sales) OVER (
            ORDER BY month
        ) AS previous_month_sales

    FROM monthly_sales
)

SELECT
    month,

    ROUND(
        sales,
        2
    ) AS total_sales,

    ROUND(
        previous_month_sales,
        2
    ) AS previous_month_sales,

    ROUND(
        (
            sales - previous_month_sales
        )
        / NULLIF(previous_month_sales, 0)
        * 100,
        2
    ) AS growth_percent

FROM monthly_growth

WHERE previous_month_sales IS NOT NULL

ORDER BY growth_percent DESC

LIMIT 1;
-------------------------------------------------------------------
-- Query 22 — What percentage of sales comes from the top 20 products?

WITH product_sales AS (

    SELECT
        product_id,

        SUM(total_amount) AS sales

    FROM ecommerce.amazon_sales

    GROUP BY product_id
),

ranked_products AS (

    SELECT
        *,
        ROW_NUMBER() OVER (
            ORDER BY sales DESC
        ) AS product_rank

    FROM product_sales
)

SELECT
    ROUND(
        SUM(
            CASE
                WHEN product_rank <= 20
                    THEN sales
                ELSE 0
            END
        ),
        2
    ) AS top_20_product_sales,

    ROUND(
        SUM(sales),
        2
    ) AS total_sales,

    ROUND(
        SUM(
            CASE
                WHEN product_rank <= 20
                    THEN sales
                ELSE 0
            END
        )
        / NULLIF(SUM(sales), 0)
        * 100,
        2
    ) AS top_20_sales_contribution_percent

FROM ranked_products;
----------------------------------------------------------------------

-- Query 23 — What percentage of sales comes from repeat customers?
WITH customer_orders AS (

    SELECT
        customer_id,

        COUNT(DISTINCT order_id) AS orders,

        SUM(total_amount) AS sales

    FROM ecommerce.amazon_sales

    GROUP BY customer_id
)

SELECT
    ROUND(
        SUM(
            CASE
                WHEN orders > 1
                    THEN sales
                ELSE 0
            END
        ),
        2
    ) AS repeat_customer_sales,

    ROUND(
        SUM(sales),
        2
    ) AS total_sales,

    ROUND(
        SUM(
            CASE
                WHEN orders > 1
                    THEN sales
                ELSE 0
            END
        )
        / NULLIF(SUM(sales), 0)
        * 100,
        2
    ) AS repeat_customer_sales_percent

FROM customer_orders;

-- Query 24 — Identify the strongest seller-category combination
SELECT
    seller_id,
    category,

    COUNT(DISTINCT order_id) AS orders,

    COUNT(DISTINCT product_id) AS products,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY
    seller_id,
    category

ORDER BY total_sales DESC

LIMIT 20;


-- Query 25 — Final Business KPI Dashboard Query


SELECT
    COUNT(DISTINCT order_id) AS total_orders,

    COUNT(DISTINCT customer_id) AS total_customers,

    COUNT(DISTINCT product_id) AS total_products,

    COUNT(DISTINCT seller_id) AS total_sellers,

    COUNT(DISTINCT country) AS total_countries,

    COUNT(DISTINCT category) AS total_categories,

    SUM(quantity) AS total_units_sold,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales,

    ROUND(
        AVG(total_amount),
        2
    ) AS average_order_value,

    ROUND(
        AVG(discount) * 100,
        2
    ) AS average_discount_percent

FROM ecommerce.amazon_sales;