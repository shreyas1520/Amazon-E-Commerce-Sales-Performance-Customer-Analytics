-- Query 1 — Overall Discount KPIs

SELECT
    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS gross_product_value,

    ROUND(
        SUM(quantity * unit_price * discount),
        2
    ) AS total_discount_amount,

    ROUND(
        SUM(quantity * unit_price * (1 - discount)),
        2
    ) AS net_product_sales,

    ROUND(
        AVG(discount) * 100,
        2
    ) AS average_discount_percent,

    ROUND(
        SUM(quantity * unit_price * discount)
        / NULLIF(SUM(quantity * unit_price), 0)
        * 100,
        2
    ) AS weighted_discount_percent

FROM ecommerce.amazon_sales;

-------------------------------------------------------

-- Query 2 — Discount Distribution

SELECT
    ROUND(MIN(discount) * 100, 2)
        AS minimum_discount_percent,

    ROUND(
        PERCENTILE_CONT(0.25)
        WITHIN GROUP (ORDER BY discount)::numeric * 100,
        2
    ) AS p25_discount_percent,

    ROUND(
        PERCENTILE_CONT(0.50)
        WITHIN GROUP (ORDER BY discount)::numeric * 100,
        2
    ) AS median_discount_percent,

    ROUND(
        PERCENTILE_CONT(0.75)
        WITHIN GROUP (ORDER BY discount)::numeric * 100,
        2
    ) AS p75_discount_percent,

    ROUND(MAX(discount) * 100, 2)
        AS maximum_discount_percent

FROM ecommerce.amazon_sales;
------------------------------------------------------------
-- Query 3 — Discount by Category

SELECT
    category,

    COUNT(DISTINCT order_id) AS orders,

    SUM(quantity) AS units_sold,

    ROUND(
        AVG(discount) * 100,
        2
    ) AS average_discount_percent,

    ROUND(
        SUM(quantity * unit_price * discount),
        2
    ) AS discount_amount,

    ROUND(
        SUM(quantity * unit_price * (1 - discount)),
        2
    ) AS net_product_sales

FROM ecommerce.amazon_sales

GROUP BY category

ORDER BY average_discount_percent DESC;
----------------------------------------------------------

-- Query 4 — Weighted Discount by Category

SELECT
    category,

    ROUND(
        SUM(quantity * unit_price * discount),
        2
    ) AS discount_amount,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS gross_product_value,

    ROUND(
        SUM(quantity * unit_price * discount)
        / NULLIF(
            SUM(quantity * unit_price),
            0
        )
        * 100,
        2
    ) AS weighted_discount_percent,

    ROUND(
        SUM(quantity * unit_price * (1 - discount)),
        2
    ) AS net_product_sales

FROM ecommerce.amazon_sales

GROUP BY category

ORDER BY weighted_discount_percent DESC;
-------------------------------------------------------------

-- Query 5 — Discount Tiers

SELECT
    CASE
        WHEN discount = 0
            THEN '0%'

        WHEN discount > 0
             AND discount <= 0.10
            THEN '1-10%'

        WHEN discount > 0.10
             AND discount <= 0.20
            THEN '11-20%'

        WHEN discount > 0.20
             AND discount <= 0.30
            THEN '21-30%'

        ELSE 'Above 30%'
    END AS discount_tier,

    COUNT(*) AS transactions,

    COUNT(DISTINCT order_id) AS orders,

    SUM(quantity) AS units_sold,

    ROUND(
        SUM(quantity * unit_price * (1 - discount)),
        2
    ) AS net_product_sales

FROM ecommerce.amazon_sales

GROUP BY 1

ORDER BY
    MIN(discount);
----------------------------------------------------------------

-- Query 6 — Discount Tier Sales Contribution

WITH discount_tiers AS (

    SELECT
        CASE
            WHEN discount = 0
                THEN '0%'

            WHEN discount <= 0.10
                THEN '1-10%'

            WHEN discount <= 0.20
                THEN '11-20%'

            WHEN discount <= 0.30
                THEN '21-30%'

            ELSE 'Above 30%'
        END AS discount_tier,

        SUM(
            quantity * unit_price * (1 - discount)
        ) AS sales

    FROM ecommerce.amazon_sales

    GROUP BY 1
)

SELECT
    discount_tier,

    ROUND(
        sales,
        2
    ) AS net_product_sales,

    ROUND(
        sales
        / NULLIF(SUM(sales) OVER (), 0)
        * 100,
        2
    ) AS sales_share_percent

FROM discount_tiers

ORDER BY sales DESC;

----------------------------------------------------------
-- Query 7 — Discount vs Units Sold

SELECT
    CASE
        WHEN discount = 0
            THEN '0%'

        WHEN discount <= 0.10
            THEN '1-10%'

        WHEN discount <= 0.20
            THEN '11-20%'

        WHEN discount <= 0.30
            THEN '21-30%'

        ELSE 'Above 30%'
    END AS discount_tier,

    SUM(quantity) AS units_sold,

    ROUND(
        AVG(quantity),
        2
    ) AS average_units_per_row,

    COUNT(DISTINCT order_id) AS orders

FROM ecommerce.amazon_sales

GROUP BY 1

ORDER BY
    MIN(discount);
------------------------------------------------------------

-- Query 8 — Discount vs Average Order Value
SELECT
    CASE
        WHEN discount = 0
            THEN '0%'

        WHEN discount <= 0.10
            THEN '1-10%'

        WHEN discount <= 0.20
            THEN '11-20%'

        WHEN discount <= 0.30
            THEN '21-30%'

        ELSE 'Above 30%'
    END AS discount_tier,

    COUNT(DISTINCT order_id) AS orders,

    ROUND(
        AVG(total_amount),
        2
    ) AS average_order_value,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_order_value

FROM ecommerce.amazon_sales

GROUP BY 1

ORDER BY
    MIN(discount);

-- Query 9 — Brand Discount Analysis
SELECT
    brand,

    COUNT(DISTINCT product_id) AS products,

    COUNT(DISTINCT order_id) AS orders,

    ROUND(
        AVG(discount) * 100,
        2
    ) AS average_discount_percent,

    ROUND(
        SUM(quantity * unit_price * discount),
        2
    ) AS discount_amount,

    ROUND(
        SUM(quantity * unit_price * (1 - discount)),
        2
    ) AS net_product_sales

FROM ecommerce.amazon_sales

GROUP BY brand

ORDER BY average_discount_percent DESC;
---------------------------------------------------------

-- Query 10 — Top 20 Products by Average Discount

SELECT
    product_id,
    product_name,
    category,
    brand,

    COUNT(DISTINCT order_id) AS orders,

    ROUND(
        AVG(discount) * 100,
        2
    ) AS average_discount_percent,

    SUM(quantity) AS units_sold,

    ROUND(
        SUM(quantity * unit_price * (1 - discount)),
        2
    ) AS net_product_sales

FROM ecommerce.amazon_sales

GROUP BY
    product_id,
    product_name,
    category,
    brand

ORDER BY average_discount_percent DESC

LIMIT 20;
------------------------------------------------
-- Query 11 — Highest Discount Amount by Product

SELECT
    product_id,
    product_name,
    category,
    brand,

    ROUND(
        SUM(quantity * unit_price * discount),
        2
    ) AS total_discount_amount,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS gross_product_value,

    ROUND(
        SUM(quantity * unit_price * (1 - discount)),
        2
    ) AS net_product_sales

FROM ecommerce.amazon_sales

GROUP BY
    product_id,
    product_name,
    category,
    brand

ORDER BY total_discount_amount DESC

LIMIT 20;
-----------------------------------------------

-- Query 12 — High Discount + High Sales Products

WITH product_metrics AS (

    SELECT
        product_id,
        product_name,
        category,
        brand,

        AVG(discount) AS avg_discount,

        SUM(
            quantity * unit_price * (1 - discount)
        ) AS sales

    FROM ecommerce.amazon_sales

    GROUP BY
        product_id,
        product_name,
        category,
        brand
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
    p.brand,

    ROUND(
        p.avg_discount * 100,
        2
    ) AS average_discount_percent,

    ROUND(
        p.sales,
        2
    ) AS net_product_sales

FROM product_metrics p

CROSS JOIN benchmarks b

WHERE p.avg_discount >= b.median_discount
  AND p.sales >= b.median_sales

ORDER BY p.sales DESC;
------------------------------------------------------------

-- Query 13 — High Discount + Low Sales Products

WITH product_metrics AS (

    SELECT
        product_id,
        product_name,
        category,
        brand,

        AVG(discount) AS avg_discount,

        SUM(
            quantity * unit_price * (1 - discount)
        ) AS sales

    FROM ecommerce.amazon_sales

    GROUP BY
        product_id,
        product_name,
        category,
        brand
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
    p.brand,

    ROUND(
        p.avg_discount * 100,
        2
    ) AS average_discount_percent,

    ROUND(
        p.sales,
        2
    ) AS net_product_sales

FROM product_metrics p

CROSS JOIN benchmarks b

WHERE p.avg_discount >= b.median_discount
  AND p.sales < b.median_sales

ORDER BY
    p.avg_discount DESC;
-----------------------------------------------------------

-- Query 14 — Discount Impact on Gross vs Net Sales

SELECT
    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS gross_product_value,

    ROUND(
        SUM(quantity * unit_price * discount),
        2
    ) AS discount_amount,

    ROUND(
        SUM(quantity * unit_price * (1 - discount)),
        2
    ) AS net_product_sales,

    ROUND(
        (
            SUM(quantity * unit_price)
            -
            SUM(quantity * unit_price * (1 - discount))
        ),
        2
    ) AS gross_to_net_reduction

FROM ecommerce.amazon_sales;
--------------------------------------------------------------------------

-- Query 15 — Category Discount Efficiency

SELECT
    category,

    ROUND(
        SUM(quantity * unit_price * discount),
        2
    ) AS discount_amount,

    ROUND(
        SUM(quantity * unit_price * (1 - discount)),
        2
    ) AS net_product_sales,

    ROUND(
        SUM(quantity * unit_price * (1 - discount))
        /
        NULLIF(
            SUM(quantity * unit_price * discount),
            0
        ),
        2
    ) AS sales_per_discount_rupee

FROM ecommerce.amazon_sales

GROUP BY category

ORDER BY sales_per_discount_rupee DESC;
-----------------------------------------------------------------------
-- Query 16 — Final Discount KPI Summary

SELECT
    COUNT(*) AS total_transactions,

    ROUND(
        AVG(discount) * 100,
        2
    ) AS average_discount_percent,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS gross_product_value,

    ROUND(
        SUM(quantity * unit_price * discount),
        2
    ) AS total_discount_amount,

    ROUND(
        SUM(quantity * unit_price * (1 - discount)),
        2
    ) AS net_product_sales,

    ROUND(
        SUM(quantity * unit_price * discount)
        /
        NULLIF(
            SUM(quantity * unit_price),
            0
        )
        * 100,
        2
    ) AS weighted_discount_percent,

    COUNT(*) FILTER (
        WHERE discount = 0
    ) AS no_discount_transactions,

    COUNT(*) FILTER (
        WHERE discount > 0.30
    ) AS high_discount_transactions

FROM ecommerce.amazon_sales;

-------------------------------------------------------