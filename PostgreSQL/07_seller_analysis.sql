-- Query 1 — Overall Seller KPIs

SELECT
    COUNT(DISTINCT seller_id) AS total_sellers,
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

---------------------------------------------------------

-- Query 2 — Seller Performance Overview

SELECT
    seller_id,

    COUNT(DISTINCT order_id) AS total_orders,

    COUNT(DISTINCT customer_id) AS total_customers,

    COUNT(DISTINCT product_id) AS products_sold,

    COUNT(DISTINCT category) AS categories_sold,

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

GROUP BY seller_id

ORDER BY total_sales DESC;

----------------------------------------------------

-- Query 3 — Top 20 Sellers by Sales
SELECT
    seller_id,

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

GROUP BY seller_id

ORDER BY total_sales DESC

LIMIT 20;
---------------------------------------------------

-- Query 4 — Top 20 Sellers by Units Sold

SELECT
    seller_id,

    COUNT(DISTINCT order_id) AS total_orders,

    SUM(quantity) AS units_sold,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY seller_id

ORDER BY units_sold DESC

LIMIT 20;

---------------------------------------------------------------

-- Query 5 — Top 20 Sellers by Order Count

SELECT
    seller_id,

    COUNT(DISTINCT order_id) AS total_orders,

    COUNT(DISTINCT customer_id) AS total_customers,

    SUM(quantity) AS units_sold,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY seller_id

ORDER BY total_orders DESC

LIMIT 20;
------------------------------------------------------------
-- Query 6 — Seller Average Order Value
SELECT
    seller_id,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(
        AVG(total_amount),
        2
    ) AS average_order_value,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY seller_id

HAVING COUNT(DISTINCT order_id) >= 5

ORDER BY average_order_value DESC;

--------------------------------------------------------------------

-- Query 7 — Seller Product Diversity

SELECT
    seller_id,

    COUNT(DISTINCT product_id) AS unique_products,

    COUNT(DISTINCT category) AS unique_categories,

    COUNT(DISTINCT brand) AS unique_brands,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY seller_id

ORDER BY unique_products DESC;

-----------------------------------------------------------------

-- Query 8 — Seller Sales per Product

WITH seller_metrics AS (

    SELECT
        seller_id,

        COUNT(DISTINCT product_id) AS products,

        SUM(total_amount) AS sales

    FROM ecommerce.amazon_sales

    GROUP BY seller_id
)

SELECT
    seller_id,

    products,

    ROUND(
        sales,
        2
    ) AS total_sales,

    ROUND(
        sales / NULLIF(products, 0),
        2
    ) AS sales_per_product

FROM seller_metrics

ORDER BY sales_per_product DESC;

----------------------------------------------------------

-- Query 9 — Seller Customer Reach

SELECT
    seller_id,

    COUNT(DISTINCT customer_id) AS unique_customers,

    COUNT(DISTINCT order_id) AS total_orders,

    SUM(quantity) AS units_sold,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY seller_id

ORDER BY unique_customers DESC;
------------------------------------------------------------
-- Query 10 — Seller Sales Contribution

WITH seller_sales AS (

    SELECT
        seller_id,

        SUM(total_amount) AS sales

    FROM ecommerce.amazon_sales

    GROUP BY seller_id
)

SELECT
    seller_id,

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

FROM seller_sales

ORDER BY sales DESC;

--------------------------------------------------------------------

-- Query 11 — Seller Ranking

WITH seller_sales AS (

    SELECT
        seller_id,

        SUM(total_amount) AS sales

    FROM ecommerce.amazon_sales

    GROUP BY seller_id
)

SELECT
    seller_id,

    ROUND(
        sales,
        2
    ) AS total_sales,

    RANK() OVER (
        ORDER BY sales DESC
    ) AS seller_rank

FROM seller_sales

ORDER BY seller_rank;

---------------------------------------------------------------

-- Query 12 — Top 10% Seller Sales Contribution

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
    ) AS top_10_percent_seller_sales,

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
    ) AS top_10_percent_sales_contribution

FROM ranked_sellers;
-----------------------------------------------------------------
-- Query 13 — Seller Category Diversity
SELECT
    seller_id,

    COUNT(DISTINCT category) AS categories_sold,

    COUNT(DISTINCT product_id) AS products_sold,

    COUNT(DISTINCT brand) AS brands_sold,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY seller_id

ORDER BY categories_sold DESC,
         total_sales DESC;
-----------------------------------------------------------------
-- Query 14 — Seller Performance by Order Status

SELECT
    seller_id,
    order_status,

    COUNT(DISTINCT order_id) AS orders,

    SUM(quantity) AS units_sold,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY
    seller_id,
    order_status

ORDER BY
    seller_id,
    total_sales DESC;
-----------------------------------------------------------------

-- Query 15 — Seller Discount Profile

SELECT
    seller_id,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(
        AVG(discount) * 100,
        2
    ) AS average_discount_percent,

    ROUND(
        SUM(quantity * unit_price * discount),
        2
    ) AS total_discount_amount,

    ROUND(
        SUM(quantity * unit_price * (1 - discount)),
        2
    ) AS net_product_sales

FROM ecommerce.amazon_sales

GROUP BY seller_id

ORDER BY average_discount_percent DESC;

----------------------------------------------------------------

-- Query 16 — Seller Performance Segmentation

WITH seller_metrics AS (

    SELECT
        seller_id,

        COUNT(DISTINCT order_id) AS orders,

        SUM(total_amount) AS sales

    FROM ecommerce.amazon_sales

    GROUP BY seller_id
),

benchmarks AS (

    SELECT
        PERCENTILE_CONT(0.50)
        WITHIN GROUP (
            ORDER BY sales
        ) AS median_sales,

        PERCENTILE_CONT(0.50)
        WITHIN GROUP (
            ORDER BY orders
        ) AS median_orders

    FROM seller_metrics
)

SELECT
    s.seller_id,

    s.orders,

    ROUND(
        s.sales,
        2
    ) AS total_sales,

    CASE
        WHEN s.sales >= b.median_sales
             AND s.orders >= b.median_orders
            THEN 'High Sales / High Orders'

        WHEN s.sales >= b.median_sales
             AND s.orders < b.median_orders
            THEN 'High Sales / Low Orders'

        WHEN s.sales < b.median_sales
             AND s.orders >= b.median_orders
            THEN 'Low Sales / High Orders'

        ELSE 'Low Sales / Low Orders'
    END AS seller_segment

FROM seller_metrics s

CROSS JOIN benchmarks b

ORDER BY s.sales DESC;
----------------------------------------------------------------------

-- Query 17 — Top Seller in Each Category

WITH seller_category_sales AS (

    SELECT
        category,
        seller_id,

        SUM(total_amount) AS sales

    FROM ecommerce.amazon_sales

    GROUP BY
        category,
        seller_id
),

ranked_sellers AS (

    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY sales DESC
        ) AS seller_rank

    FROM seller_category_sales
)

SELECT
    category,
    seller_id,

    ROUND(
        sales,
        2
    ) AS total_sales,

    seller_rank

FROM ranked_sellers

WHERE seller_rank = 1

ORDER BY total_sales DESC;
--------------------------------------------------------------------------
-- Query 18 — Final Seller KPI Summary

WITH seller_metrics AS (

    SELECT
        seller_id,

        COUNT(DISTINCT order_id) AS orders,

        COUNT(DISTINCT customer_id) AS customers,

        COUNT(DISTINCT product_id) AS products,

        SUM(quantity) AS units_sold,

        SUM(total_amount) AS sales

    FROM ecommerce.amazon_sales

    GROUP BY seller_id
)

SELECT
    COUNT(*) AS total_sellers,

    ROUND(
        AVG(orders),
        2
    ) AS average_orders_per_seller,

    ROUND(
        AVG(customers),
        2
    ) AS average_customers_per_seller,

    ROUND(
        AVG(products),
        2
    ) AS average_products_per_seller,

    ROUND(
        AVG(units_sold),
        2
    ) AS average_units_per_seller,

    ROUND(
        AVG(sales),
        2
    ) AS average_sales_per_seller,

    ROUND(
        MAX(sales),
        2
    ) AS highest_seller_sales

FROM seller_metrics;
-------------------------------------------------------