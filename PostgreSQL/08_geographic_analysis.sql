-- Query 1 — Overall Geographic Coverage

SELECT
    COUNT(DISTINCT country) AS total_countries,
    COUNT(DISTINCT state) AS total_states,
    COUNT(DISTINCT city) AS total_cities
FROM ecommerce.amazon_sales;
------------------------------------------------
-- Query 2 — Sales by Country
SELECT
    country,

    COUNT(DISTINCT order_id) AS total_orders,

    COUNT(DISTINCT customer_id) AS total_customers,

    COUNT(DISTINCT product_id) AS products_sold,

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

GROUP BY country

ORDER BY total_sales DESC;
------------------------------------------------------------
-- Query 3 — Country Sales Contribution

WITH country_sales AS (

    SELECT
        country,
        SUM(total_amount) AS sales

    FROM ecommerce.amazon_sales

    GROUP BY country
)

SELECT
    country,

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

FROM country_sales

ORDER BY sales DESC;
-------------------------------------------------------------

-- Query 4 — Sales by State
SELECT
    country,
    state,

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

GROUP BY
    country,
    state

ORDER BY total_sales DESC;
----------------------------------------------------------------------

-- Query 5 — Top 20 States by Sales

SELECT
    country,
    state,

    COUNT(DISTINCT order_id) AS total_orders,

    COUNT(DISTINCT customer_id) AS total_customers,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY
    country,
    state

ORDER BY total_sales DESC

LIMIT 20;
-------------------------------------------------------------
-- Query 6 — Sales by City

SELECT
    country,
    state,
    city,

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

GROUP BY
    country,
    state,
    city

ORDER BY total_sales DESC;
------------------------------------------------
-- Query 7 — Top 20 Cities by Sales
SELECT
    country,
    state,
    city,

    COUNT(DISTINCT order_id) AS total_orders,

    COUNT(DISTINCT customer_id) AS total_customers,

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

LIMIT 20;
--------------------------------------------------

-- Query 8 — Top Cities by Customer Count

SELECT
    country,
    state,
    city,

    COUNT(DISTINCT customer_id) AS unique_customers,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY
    country,
    state,
    city

ORDER BY unique_customers DESC
LIMIT 20;
------------------------------------------------

-- Query 9 — Geographic Average Order Value

SELECT
    country,
    state,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales,

    ROUND(
        AVG(total_amount),
        2
    ) AS average_order_value

FROM ecommerce.amazon_sales

GROUP BY
    country,
    state

HAVING COUNT(DISTINCT order_id) >= 10

ORDER BY average_order_value DESC;
--------------------------------------------------------------

-- Query 10 — Geographic Product Diversity

SELECT
    country,
    state,

    COUNT(DISTINCT product_id) AS unique_products,

    COUNT(DISTINCT category) AS categories,

    COUNT(DISTINCT brand) AS brands,

    COUNT(DISTINCT customer_id) AS customers,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY
    country,
    state

ORDER BY unique_products DESC;
----------------------------------------------------

-- Query 11 — Top Category in Each State

WITH state_category_sales AS (

    SELECT
        state,
        category,

        SUM(total_amount) AS sales

    FROM ecommerce.amazon_sales

    GROUP BY
        state,
        category
),

ranked_categories AS (

    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY state
            ORDER BY sales DESC
        ) AS category_rank

    FROM state_category_sales
)

SELECT
    state,
    category,

    ROUND(
        sales,
        2
    ) AS total_sales,

    category_rank

FROM ranked_categories

WHERE category_rank = 1

ORDER BY total_sales DESC;
----------------------------------------------------------

-- Query 12 — Top Product in Each State

WITH state_product_sales AS (

    SELECT
        state,
        product_id,
        product_name,

        SUM(total_amount) AS sales

    FROM ecommerce.amazon_sales

    GROUP BY
        state,
        product_id,
        product_name
),

ranked_products AS (

    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY state
            ORDER BY sales DESC
        ) AS product_rank

    FROM state_product_sales
)

SELECT
    state,
    product_id,
    product_name,

    ROUND(
        sales,
        2
    ) AS total_sales,

    product_rank

FROM ranked_products

WHERE product_rank = 1

ORDER BY total_sales DESC;

---------------------------------------------------------------

-- Query 13 — State Sales Contribution Within Country

WITH state_sales AS (

    SELECT
        country,
        state,

        SUM(total_amount) AS sales

    FROM ecommerce.amazon_sales

    GROUP BY
        country,
        state
)

SELECT
    country,
    state,

    ROUND(
        sales,
        2
    ) AS state_sales,

    ROUND(
        sales
        /
        NULLIF(
            SUM(sales) OVER (
                PARTITION BY country
            ),
            0
        )
        * 100,
        2
    ) AS country_sales_contribution_percent

FROM state_sales

ORDER BY
    country,
    state_sales DESC;

SUM(sales) OVER (
    PARTITION BY country
)
------------------------------------------------------------

-- Query 14 — City Sales Concentration

WITH city_sales AS (

    SELECT
        city,

        SUM(total_amount) AS sales

    FROM ecommerce.amazon_sales

    GROUP BY city
),

ranked_cities AS (

    SELECT
        *,
        NTILE(10) OVER (
            ORDER BY sales DESC
        ) AS city_decile

    FROM city_sales
)

SELECT
    ROUND(
        SUM(
            CASE
                WHEN city_decile = 1
                    THEN sales
                ELSE 0
            END
        ),
        2
    ) AS top_10_percent_city_sales,

    ROUND(
        SUM(sales),
        2
    ) AS total_sales,

    ROUND(
        SUM(
            CASE
                WHEN city_decile = 1
                    THEN sales
                ELSE 0
            END
        )
        / NULLIF(SUM(sales), 0)
        * 100,
        2
    ) AS top_10_percent_city_sales_contribution

FROM ranked_cities;
----------------------------------------------------------------------

-- Query 15 — Customer Spending by Geography

SELECT
    country,
    state,

    COUNT(DISTINCT customer_id) AS customers,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales,

    ROUND(
        SUM(total_amount)
        /
        NULLIF(COUNT(DISTINCT customer_id), 0),
        2
    ) AS sales_per_customer

FROM ecommerce.amazon_sales

GROUP BY
    country,
    state

ORDER BY sales_per_customer DESC;
-------------------------------------------------------------------------
-- Query 16 — Orders per Customer by Geography
SELECT
    country,
    state,

    COUNT(DISTINCT customer_id) AS customers,

    COUNT(DISTINCT order_id) AS orders,

    ROUND(
        COUNT(DISTINCT order_id)::numeric
        /
        NULLIF(COUNT(DISTINCT customer_id), 0),
        2
    ) AS orders_per_customer

FROM ecommerce.amazon_sales

GROUP BY
    country,
    state

ORDER BY orders_per_customer DESC;
-------------------------------------------------------------------
-- Query 17 — Seller Performance by Geography

SELECT
    country,
    state,
    seller_id,

    COUNT(DISTINCT order_id) AS orders,

    COUNT(DISTINCT customer_id) AS customers,

    SUM(quantity) AS units_sold,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY
    country,
    state,
    seller_id

ORDER BY total_sales DESC;
--------------------------------------------------------------------------

-- Query 18 — Geographic Order Status Analysis

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
    total_sales DESC;
------------------------------------------------------------------
-- Query 19 — Geographic Discount Analysis

SELECT
    country,
    state,


    ROUND(
        AVG(discount) * 100,
        2
    ) AS average_discount_percent,

    ROUND(
        SUM(quantity * unit_price * discount),
        2
    ) AS total_discount_amount,


    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales

FROM ecommerce.amazon_sales

GROUP BY
    country,
    state

ORDER BY average_discount_percent DESC;

-- Query 20 — Final Geographic KPI Summary

SELECT
    COUNT(DISTINCT country) AS total_countries,

    COUNT(DISTINCT state) AS total_states,

    COUNT(DISTINCT city) AS total_cities,

    COUNT(DISTINCT customer_id) AS total_customers,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_sales,

    ROUND(
        SUM(total_amount)
        /
        NULLIF(COUNT(DISTINCT customer_id), 0),
        2
    ) AS sales_per_customer,

    ROUND(
        SUM(total_amount)
        /
        NULLIF(COUNT(DISTINCT order_id), 0),
        2
    ) AS average_order_value

FROM ecommerce.amazon_sales;
