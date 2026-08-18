SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT product_id) AS total_products,
    COUNT(DISTINCT seller_id) AS total_sellers,
    SUM(quantity) AS total_units_sold,

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
        SUM(total_amount),
        2
    ) AS total_order_value,

    ROUND(
        AVG(total_amount),
        2
    ) AS average_order_value
FROM ecommerce.amazon_sales;


-- Monthly performance

SELECT
    DATE_TRUNC('month', order_date)::date AS month,

    COUNT(DISTINCT order_id) AS orders,

    COUNT(DISTINCT customer_id) AS customers,

    SUM(quantity) AS units_sold,

    ROUND(
        SUM(quantity * unit_price * (1 - discount)),
        2
    ) AS net_product_sales,

    ROUND(
        SUM(total_amount),
        2
    ) AS total_order_value,

    ROUND(
        AVG(total_amount),
        2
    ) AS average_order_value

FROM ecommerce.amazon_sales

GROUP BY 1

ORDER BY 1;



-- Daily Sales Performance

SELECT
    order_date AS order_day,

    COUNT(DISTINCT order_id) AS orders,

    COUNT(DISTINCT customer_id) AS customers,

    SUM(quantity) AS units_sold,

    ROUND(
        SUM(quantity * unit_price * (1 - discount)),
        2
    ) AS net_product_sales,

    ROUND(
        AVG(total_amount),
        2
    ) AS average_order_value

FROM ecommerce.amazon_sales

GROUP BY order_date

ORDER BY order_date;


-- Top 10 Sales Day

SELECT
    order_date AS order_day,

    COUNT(DISTINCT order_id) AS orders,

    SUM(quantity) AS units_sold,

    ROUND(
        SUM(quantity * unit_price * (1 - discount)),
        2
    ) AS net_product_sales

FROM ecommerce.amazon_sales

GROUP BY order_date

ORDER BY net_product_sales DESC

LIMIT 10;

-- Sales By Order

SELECT
    order_status,

    COUNT(DISTINCT order_id) AS orders,

    COUNT(DISTINCT customer_id) AS customers,

    SUM(quantity) AS units_sold,

    ROUND(
        SUM(quantity * unit_price * (1 - discount)),
        2
    ) AS net_product_sales,

    ROUND(
        AVG(total_amount),
        2
    ) AS average_order_value

FROM ecommerce.amazon_sales

GROUP BY order_status

ORDER BY net_product_sales DESC;



-- Order Status Share
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
        / SUM(orders) OVER ()
        * 100,
        2
    ) AS order_share_percent

FROM status_orders

ORDER BY orders DESC;

-- Top 20 Products by sale
SELECT
    product_id,
    product_name,
    category,

    COUNT(DISTINCT order_id) AS orders,

    SUM(quantity) AS units_sold,

    ROUND(
        SUM(quantity * unit_price * (1 - discount)),
        2
    ) AS net_product_sales

FROM ecommerce.amazon_sales

GROUP BY
    product_id,
    product_name,
    category

ORDER BY net_product_sales DESC

LIMIT 20;

-- Top 20 products by unit sold
SELECT
    product_id,
    product_name,
    category,

    SUM(quantity) AS units_sold,

    COUNT(DISTINCT order_id) AS orders,

    ROUND(
        SUM(quantity * unit_price * (1 - discount)),
        2
    ) AS net_product_sales

FROM ecommerce.amazon_sales

GROUP BY
    product_id,
    product_name,
    category

ORDER BY units_sold DESC

LIMIT 20;

-- Top 10 products by Average Order Value
SELECT
    product_id,
    product_name,
    category,

    COUNT(DISTINCT order_id) AS orders,

    ROUND(
        AVG(total_amount),
        2
    ) AS average_order_value,

    ROUND(
        SUM(quantity * unit_price * (1 - discount)),
        2
    ) AS net_product_sales

FROM ecommerce.amazon_sales

GROUP BY
    product_id,
    product_name,
    category

HAVING COUNT(DISTINCT order_id) >= 5

ORDER BY average_order_value DESC

LIMIT 10;


-- Sales by category

SELECT
    category,

    COUNT(DISTINCT order_id) AS orders,

    COUNT(DISTINCT product_id) AS products,

    SUM(quantity) AS units_sold,

    ROUND(
        SUM(quantity * unit_price * (1 - discount)),
        2
    ) AS net_product_sales,

    ROUND(
        AVG(total_amount),
        2
    ) AS average_order_value

FROM ecommerce.amazon_sales

GROUP BY category

ORDER BY net_product_sales DESC;

-- Category Sales Contribution

WITH category_sales AS (
    SELECT
        category,

        SUM(
            quantity * unit_price * (1 - discount)
        ) AS sales

    FROM ecommerce.amazon_sales

    GROUP BY category
)

SELECT
    category,

    ROUND(
        sales,
        2
    ) AS net_product_sales,

    ROUND(
        sales
        / SUM(sales) OVER ()
        * 100,
        2
    ) AS sales_share_percent

FROM category_sales

ORDER BY sales DESC;

-- Monthly Sales Growth

WITH monthly_sales AS (

    SELECT
        DATE_TRUNC('month', order_date)::date AS month,

        SUM(
            quantity * unit_price * (1 - discount)
        ) AS sales

    FROM ecommerce.amazon_sales

    GROUP BY 1
),

monthly_with_previous AS (

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
    ) AS net_product_sales,

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

FROM monthly_with_previous

ORDER BY month;

-- Highest Sales Month

SELECT
    DATE_TRUNC('month', order_date)::date AS month,

    ROUND(
        SUM(quantity * unit_price * (1 - discount)),
        2
    ) AS net_product_sales

FROM ecommerce.amazon_sales

GROUP BY 1

ORDER BY net_product_sales DESC

LIMIT 1;

