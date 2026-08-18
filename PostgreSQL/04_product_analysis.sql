-- Query 1 — Product Performance Overview

SELECT
    product_id,
    product_name,
    category,
    brand,


    COUNT(DISTINCT order_id) AS orders,


    COUNT(DISTINCT customer_id) AS customers,


    SUM(quantity) AS units_sold,


    ROUND(
        SUM(quantity * unit_price * (1 - discount)),
        2
    ) AS net_product_sales,


    ROUND(
        AVG(unit_price),
        2
    ) AS average_unit_price,


    ROUND(
        AVG(discount) * 100,
        2
    ) AS average_discount_percent


FROM ecommerce.amazon_sales


GROUP BY
    product_id,
    product_name,
    category,
    brand


ORDER BY net_product_sales DESC;

----------------------------------------------------

-- Query 2 — Top 20 Products by Sales

SELECT
    product_id,
    product_name,
    category,
    brand,


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
    category,
    brand


ORDER BY net_product_sales DESC


LIMIT 20;
-------------------------------------------------

-- Query 3 — Top 20 Products by Units Sold

SELECT
    product_id,
    product_name,
    category,
    brand,


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
    category,
    brand


ORDER BY units_sold DESC


LIMIT 20;

----------------------------------------------

-- Query 4 — Bottom 20 Products by Sales


SELECT
    product_id,
    product_name,
    category,
    brand,


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
    category,
    brand


ORDER BY net_product_sales ASC


LIMIT 20;

-------------------------------------------------

-- Query 5 — Category Performance


SELECT
    category,


    COUNT(DISTINCT product_id) AS products,


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
    ) AS average_order_value,


    ROUND(
        AVG(discount) * 100,
        2
    ) AS average_discount_percent


FROM ecommerce.amazon_sales


GROUP BY category


ORDER BY net_product_sales DESC;

--------------------------------------------------

-- Query 6 — Category Sales Contribution


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
        / NULLIF(SUM(sales) OVER (), 0)
        * 100,
        2
    ) AS sales_share_percent


FROM category_sales


ORDER BY sales DESC;
-------------------------------------------------------

--Query 7 — Category Ranking

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


    RANK() OVER (
        ORDER BY sales DESC
    ) AS category_rank


FROM category_sales


ORDER BY category_rank;

--------------------------------------------------

--Query 8 — Top Product in Each Category

WITH product_sales AS (


    SELECT
        category,
        product_id,
        product_name,
        brand,


        SUM(
            quantity * unit_price * (1 - discount)
        ) AS sales


    FROM ecommerce.amazon_sales


    GROUP BY
        category,
        product_id,
        product_name,
        brand
),


ranked_products AS (


    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY sales DESC
        ) AS product_rank


    FROM product_sales
)


SELECT
    category,
    product_id,
    product_name,
    brand,


    ROUND(
        sales,
        2
    ) AS net_product_sales,


    product_rank


FROM ranked_products


WHERE product_rank = 1


ORDER BY net_product_sales DESC;

---------------------------------------------------

-- Query 9 — Top 3 Products in Each Category

WITH product_sales AS (


    SELECT
        category,
        product_id,
        product_name,
        brand,


        SUM(
            quantity * unit_price * (1 - discount)
        ) AS sales


    FROM ecommerce.amazon_sales


    GROUP BY
        category,
        product_id,
        product_name,
        brand
),


ranked_products AS (


    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY sales DESC
        ) AS product_rank


    FROM product_sales
)


SELECT
    category,
    product_rank,
    product_id,
    product_name,
    brand,


    ROUND(
        sales,
        2
    ) AS net_product_sales


FROM ranked_products


WHERE product_rank <= 3


ORDER BY
    category,
    product_rank;

----------------------------------------------------------

--Query 10 — Brand Performance

SELECT
    brand,


    COUNT(DISTINCT product_id) AS products,


    COUNT(DISTINCT order_id) AS orders,


    COUNT(DISTINCT customer_id) AS customers,


    SUM(quantity) AS units_sold,


    ROUND(
        SUM(quantity * unit_price * (1 - discount)),
        2
    ) AS net_product_sales,


    ROUND(
        AVG(discount) * 100,
        2
    ) AS average_discount_percent


FROM ecommerce.amazon_sales


GROUP BY brand


ORDER BY net_product_sales DESC;

----------------------------------------------------

-- Query 11 — Top 20 Brands

For a cleaner output:

SELECT
    brand,


    COUNT(DISTINCT product_id) AS products,


    COUNT(DISTINCT order_id) AS orders,


    SUM(quantity) AS units_sold,


    ROUND(
        SUM(quantity * unit_price * (1 - discount)),
        2
    ) AS net_product_sales


FROM ecommerce.amazon_sales


GROUP BY brand


ORDER BY net_product_sales DESC


LIMIT 20;
----------------------------------------------------------

-- Query 12 — Brand Sales per Product

WITH brand_summary AS (


    SELECT
        brand,


        COUNT(DISTINCT product_id) AS products,


        SUM(
            quantity * unit_price * (1 - discount)
        ) AS sales


    FROM ecommerce.amazon_sales


    GROUP BY brand
)


SELECT
    brand,


    products,


    ROUND(
        sales,
        2
    ) AS net_product_sales,


    ROUND(
        sales / NULLIF(products, 0),
        2
    ) AS sales_per_product


FROM brand_summary


ORDER BY sales_per_product DESC;
--------------------------------------------------------

-- Query 13 — Product Sales Concentration Within Category

WITH product_sales AS (


    SELECT
        category,
        product_id,
        product_name,


        SUM(
            quantity * unit_price * (1 - discount)
        ) AS product_sales


    FROM ecommerce.amazon_sales


    GROUP BY
        category,
        product_id,
        product_name
),


category_totals AS (


    SELECT
        category,
        SUM(product_sales) AS category_sales


    FROM product_sales


    GROUP BY category
)


SELECT
    p.category,
    p.product_id,
    p.product_name,


    ROUND(
        p.product_sales,
        2
    ) AS product_sales,


    ROUND(
        c.category_sales,
        2
    ) AS category_sales,


    ROUND(
        p.product_sales
        / NULLIF(c.category_sales, 0)
        * 100,
        2
    ) AS category_sales_contribution_percent


FROM product_sales p


JOIN category_totals c
    ON p.category = c.category


ORDER BY
    p.category,
    category_sales_contribution_percent DESC;
---------------------------------------------------------

-- Query 14 — Product Price vs Sales

SELECT
    product_id,
    product_name,
    category,


    ROUND(
        AVG(unit_price),
        2
    ) AS average_unit_price,


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


ORDER BY average_unit_price DESC;
--------------------------------------------------

-- Query 15 — Product Discount vs Sales

SELECT
    product_id,
    product_name,
    category,


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
    category


ORDER BY average_discount_percent DESC;
----------------------------------------------------------

-- Query 16 — Product Performance Segmentation

WITH product_sales AS (


    SELECT
        product_id,
        product_name,
        category,


        SUM(
            quantity * unit_price * (1 - discount)
        ) AS sales


    FROM ecommerce.amazon_sales


    GROUP BY
        product_id,
        product_name,
        category
),


median_sales AS (


    SELECT
        PERCENTILE_CONT(0.50)
        WITHIN GROUP (
            ORDER BY sales
        ) AS median_product_sales


    FROM product_sales
)


SELECT
    p.product_id,
    p.product_name,
    p.category,


    ROUND(
        p.sales,
        2
    ) AS net_product_sales,


    ROUND(
        m.median_product_sales,
        2
    ) AS median_product_sales,


    CASE
        WHEN p.sales >= m.median_product_sales
            THEN 'Above Median'
        ELSE 'Below Median'
    END AS performance_segment


FROM product_sales p


CROSS JOIN median_sales m


ORDER BY p.sales DESC;
--------------------------------------------------------------
