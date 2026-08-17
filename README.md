# Amazon E-Commerce Sales Performance & Customer Analytics

An end-to-end e-commerce analytics project that transforms raw Amazon transaction data into actionable business insights using Python, Pandas, SQL, and data analytics techniques.

---

## Project Overview

This project analyzes Amazon e-commerce transaction data to understand sales performance, customer behavior, product and category performance, discount and pricing patterns, seller performance, geographic trends, and order and payment behavior.

The project follows a complete analytical workflow:

Raw Data → Data Cleaning → Exploratory Data Analysis → Business Analysis → SQL Analytics → Business Insights

The goal is to demonstrate practical data analyst skills by converting transactional data into structured analysis and decision-oriented insights.

---

## Business Objectives

The project addresses questions such as:

- How are sales performing over time?
- Which products and categories generate the highest sales?
- Which customers contribute the most revenue and repeat activity?
- How are discounts distributed across products and categories?
- Which sellers contribute the most to sales?
- Which countries, states, and cities perform best?
- Which payment methods are most frequently used?
- How does order activity vary across different statuses?
- Where is sales concentration highest?
- What business opportunities and risks can be identified from the data?

---

## Analytical Areas

### 1. Data Cleaning

- Data type validation
- Missing-value analysis
- Duplicate checks
- Invalid-value detection
- Date conversion
- Numeric validation
- Dataset consistency checks

### 2. Exploratory Data Analysis

- Distribution analysis
- Sales trends
- Product and category exploration
- Customer behavior
- Discount patterns
- Geographic analysis
- Order and payment analysis

### 3. Sales Performance

- Total orders
- Total customers
- Total units sold
- Gross Product Value
- Discount Amount
- Net Product Sales
- Average Order Value
- Monthly and daily sales trends

### 4. Product & Category Analytics

- Top products by sales
- Top products by units
- Category performance
- Brand performance
- Category sales contribution
- Top products within each category

### 5. Customer Analytics

- Customer order frequency
- Customer sales contribution
- Repeat customer analysis
- Customer segmentation
- Customer-category behavior

### 6. Discount & Pricing Analytics

- Discount distribution
- Average discount
- Weighted discount
- Discount by category
- Discount by brand
- High-discount products

### 7. Seller Analytics

- Seller sales performance
- Seller order volume
- Seller customer reach
- Seller product coverage
- Seller concentration
- Top sellers by category

### 8. Geographic Analytics

- Country performance
- State performance
- City performance
- Geographic sales contribution
- Country-category performance
- Geographic concentration

### 9. Order & Payment Analytics

- Order status analysis
- Payment method analysis
- Payment method sales contribution
- Payment method by country
- Payment method by order status
- High-value orders

### 10. Final Business Insights

The final analysis consolidates the findings into:

- Key business KPIs
- Sales opportunities
- Customer insights
- Product opportunities
- Pricing observations
- Seller insights
- Geographic opportunities
- Business risks
- Data-driven recommendations

---
---

## Core Metrics

The project uses the following core business metrics consistently across the analytical workflow.

### Gross Product Value

Quantity × UnitPrice

Represents the gross value of products before discounts.

### Discount Amount
Gross Product Value × Discount

Represents the value reduced through discounts.

### Net Product Sales
Gross Product Value − Discount Amount

Represents product sales after applying discounts.

### Effective Unit Price
UnitPrice × (1 − Discount)

Represents the effective selling price per unit after discount.

### Total Order Value
TotalAmount

Represents the recorded total value associated with the transaction.
