SELECT
    COUNT(*) FILTER (WHERE order_id IS NULL) AS null_order_id,
    COUNT(*) FILTER (WHERE order_date IS NULL) AS null_order_date,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer_id,
    COUNT(*) FILTER (WHERE customer_name IS NULL) AS null_customer_name,
    COUNT(*) FILTER (WHERE product_id IS NULL) AS null_product_id,
    COUNT(*) FILTER (WHERE product_name IS NULL) AS null_product_name,
    COUNT(*) FILTER (WHERE category IS NULL) AS null_category,
    COUNT(*) FILTER (WHERE brand IS NULL) AS null_brand,
    COUNT(*) FILTER (WHERE quantity IS NULL) AS null_quantity,
    COUNT(*) FILTER (WHERE unit_price IS NULL) AS null_unit_price,
    COUNT(*) FILTER (WHERE discount IS NULL) AS null_discount,
    COUNT(*) FILTER (WHERE tax IS NULL) AS null_tax,
    COUNT(*) FILTER (WHERE shipping_cost IS NULL) AS null_shipping_cost,
    COUNT(*) FILTER (WHERE total_amount IS NULL) AS null_total_amount,
    COUNT(*) FILTER (WHERE payment_method IS NULL) AS null_payment_method,
    COUNT(*) FILTER (WHERE order_status IS NULL) AS null_order_status,
    COUNT(*) FILTER (WHERE city IS NULL) AS null_city,
    COUNT(*) FILTER (WHERE state IS NULL) AS null_state,
    COUNT(*) FILTER (WHERE country IS NULL) AS null_country,
    COUNT(*) FILTER (WHERE seller_id IS NULL) AS null_seller_id
FROM ecommerce.amazon_sales;


SELECT
    order_id,
    product_id,
    order_date,
    customer_id,
    quantity,
    unit_price,
    COUNT(*) AS duplicate_count
FROM ecommerce.amazon_sales
GROUP BY
    order_id,
    product_id,
    order_date,
    customer_id,
    quantity,
    unit_price
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


SELECT
    order_id,
    COUNT(*) AS row_count
FROM ecommerce.amazon_sales
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY row_count DESC
LIMIT 20;

SELECT
    MIN(quantity) AS min_quantity,
    MAX(quantity) AS max_quantity,
    MIN(unit_price) AS min_unit_price,
    MAX(unit_price) AS max_unit_price,
    MIN(discount) AS min_discount,
    MAX(discount) AS max_discount,
    MIN(total_amount) AS min_total_amount,
    MAX(total_amount) AS max_total_amount
FROM ecommerce.amazon_sales;


SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM ecommerce.amazon_sales;

SELECT
    COUNT(*) FILTER (WHERE order_id IS NULL) AS null_order_id,
    COUNT(*) FILTER (WHERE order_date IS NULL) AS null_order_date,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer_id,
    COUNT(*) FILTER (WHERE product_id IS NULL) AS null_product_id,
    COUNT(*) FILTER (WHERE quantity IS NULL) AS null_quantity,
    COUNT(*) FILTER (WHERE unit_price IS NULL) AS null_unit_price,
    COUNT(*) FILTER (WHERE discount IS NULL) AS null_discount,
    COUNT(*) FILTER (WHERE total_amount IS NULL) AS null_total_amount
FROM ecommerce.amazon_sales;



SELECT
    COUNT(*) AS invalid_quantity_rows
FROM ecommerce.amazon_sales
WHERE quantity <= 0;



SELECT
    MIN(quantity) AS minimum_quantity,
    MAX(quantity) AS maximum_quantity,
    ROUND(AVG(quantity), 2) AS average_quantity
FROM ecommerce.amazon_sales;


SELECT
    COUNT(*) AS invalid_price_rows
FROM ecommerce.amazon_sales
WHERE unit_price <= 0;

SELECT
    ROUND(MIN(unit_price), 2) AS minimum_unit_price,
    ROUND(MAX(unit_price), 2) AS maximum_unit_price,
    ROUND(AVG(unit_price), 2) AS average_unit_price
FROM ecommerce.amazon_sales;



SELECT
    COUNT(*) AS invalid_discount_rows
FROM ecommerce.amazon_sales
WHERE discount < 0
   OR discount > 1;


SELECT
    ROUND(MIN(discount) * 100, 2) AS minimum_discount_percent,
    ROUND(AVG(discount) * 100, 2) AS average_discount_percent,
    ROUND(MAX(discount) * 100, 2) AS maximum_discount_percent
FROM ecommerce.amazon_sales;


SELECT
    COUNT(*) FILTER (WHERE tax < 0) AS negative_tax_rows,
    COUNT(*) FILTER (WHERE shipping_cost < 0) AS negative_shipping_rows
FROM ecommerce.amazon_sales;


SELECT
    COUNT(*) AS invalid_total_amount_rows
FROM ecommerce.amazon_sales
WHERE total_amount < 0;



SELECT
    ROUND(MIN(total_amount), 2) AS minimum_total_amount,
    ROUND(MAX(total_amount), 2) AS maximum_total_amount,
    ROUND(AVG(total_amount), 2) AS average_total_amount
FROM ecommerce.amazon_sales;


SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM ecommerce.amazon_sales;


SELECT COUNT(*) AS incorrect_year_rows
FROM ecommerce.amazon_sales
WHERE year <> EXTRACT(YEAR FROM order_date);


SELECT COUNT(*) AS incorrect_month_rows
FROM ecommerce.amazon_sales
WHERE month <> EXTRACT(MONTH FROM order_date);


SELECT COUNT(*) AS incorrect_quarter_rows
FROM ecommerce.amazon_sales
WHERE quarter <> EXTRACT(QUARTER FROM order_date);


SELECT
    category,
    COUNT(*) AS row_count
FROM ecommerce.amazon_sales
GROUP BY category
ORDER BY row_count DESC;


SELECT
    payment_method,
    COUNT(*) AS row_count
FROM ecommerce.amazon_sales
GROUP BY payment_method
ORDER BY row_count DESC;


SELECT
    order_status,
    COUNT(*) AS row_count
FROM ecommerce.amazon_sales
GROUP BY order_status
ORDER BY row_count DESC;


SELECT COUNT(*) AS suspicious_text_rows
FROM ecommerce.amazon_sales
WHERE order_id <> TRIM(order_id)
   OR customer_id <> TRIM(customer_id)
   OR product_id <> TRIM(product_id)
   OR category <> TRIM(category)
   OR brand <> TRIM(brand)
   OR payment_method <> TRIM(payment_method)
   OR order_status <> TRIM(order_status)
   OR seller_id <> TRIM(seller_id)
   OR city <> TRIM(city)
   OR state <> TRIM(state)
   OR country <> TRIM(country);


SELECT
    COUNT(*) AS inconsistent_rows
FROM ecommerce.amazon_sales
WHERE ABS(
    total_amount
    - (
        quantity * unit_price * (1 - discount)
        + tax
        + shipping_cost
    )
) > 0.01;




SELECT
    COUNT(*) AS total_rows,

    COUNT(*) FILTER (
        WHERE order_id IS NULL
    ) AS null_order_ids,

    COUNT(*) FILTER (
        WHERE order_date IS NULL
    ) AS null_dates,

    COUNT(*) FILTER (
        WHERE customer_id IS NULL
    ) AS null_customers,

    COUNT(*) FILTER (
        WHERE product_id IS NULL
    ) AS null_products,

    COUNT(*) FILTER (
        WHERE quantity <= 0
    ) AS invalid_quantities,

    COUNT(*) FILTER (
        WHERE unit_price <= 0
    ) AS invalid_prices,

    COUNT(*) FILTER (
        WHERE discount < 0 OR discount > 1
    ) AS invalid_discounts,

    COUNT(*) FILTER (
        WHERE total_amount < 0
    ) AS invalid_total_amounts,

    COUNT(DISTINCT order_id) AS unique_orders,

    COUNT(DISTINCT customer_id) AS unique_customers,

    COUNT(DISTINCT product_id) AS unique_products,

    COUNT(DISTINCT seller_id) AS unique_sellers

FROM ecommerce.amazon_sales;





































































