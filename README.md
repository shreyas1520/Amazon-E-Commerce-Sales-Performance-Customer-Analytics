# Amazon E-Commerce Sales Performance & Customer Analytics

An end-to-end e-commerce analytics project that transforms 100,000 transactional records into structured business insights using Python, Pandas, PostgreSQL, SQL, and Power BI.

The project evaluates sales performance, customer behavior, product and category performance, discount and pricing patterns, seller concentration, geographic trends, and order and payment behavior.

---

## Executive Summary

This project analyzes **100,000 e-commerce transactions** to identify sales trends, customer behavior, product performance, seller concentration, discount patterns, and geographic opportunities.

### Key Findings

* Generated **$84.24M in Net Product Sales** across 100,000 orders.
* **Electronics** was the highest-performing category, generating **$14.29M**, representing **16.96%** of Net Product Sales.
* **68.70% of customers were repeat buyers**, indicating a high level of repeat purchasing activity within the dataset.
* The **top 5 sellers contributed 38.53%** of observed sales, while the **top 10 sellers contributed 76.23%**, indicating significant seller concentration.
* The **United States generated $58.99M** in Net Product Sales, making it the highest-performing country.
* **Jeans** was the highest-selling product by Net Product Sales at **$343,506.76**.
* **Credit Card** was the most frequently used payment method, accounting for **35,038 orders**.

### Business Takeaway

The analysis indicates strong overall sales and repeat-customer activity, but also highlights concentration across sellers and geographies. These findings provide opportunities to investigate seller dependency, category growth, customer retention, and geographic performance.

---

## Business Objectives

The project addresses the following business questions:

* How are sales performing over time?
* Which products and categories generate the highest sales?
* Which customers contribute the most sales and repeat activity?
* How are discounts distributed across products and categories?
* Which sellers contribute the most to sales?
* How concentrated are sales among top sellers?
* Which countries, states, and cities perform best?
* Which payment methods are most frequently used?
* How does order activity vary across different order statuses?
* Which products and categories provide potential growth opportunities?
* What business risks and opportunities can be identified from the data?

---

## Dataset

The dataset contains transactional e-commerce data with information covering orders, customers, products, sellers, pricing, discounts, geography, payment methods, and order status.

| Dataset Metric   |   Value |
| ---------------- | ------: |
| Transactions     | 100,000 |
| Unique Orders    | 100,000 |
| Unique Customers |  43,233 |
| Unique Products  |      50 |
| Unique Sellers   |   1,999 |
| Categories       |       6 |
| Countries        |       5 |
| Cities           |      20 |
| Units Sold       | 300,140 |

---

## Technology Stack

### Data Processing & Analysis

* Python
* Pandas
* NumPy
* Matplotlib
* Seaborn

### Database & SQL

* PostgreSQL
* SQL
* Common Table Expressions (CTEs)
* Window Functions
* Aggregations
* Conditional Analysis

### Business Intelligence

* Power BI
* DAX
* Power Query

### Development & Documentation

* Jupyter Notebook
* GitHub

---

## Analytical Workflow

```text
Raw Data
   ↓
Python / Pandas
   ↓
Data Cleaning & Validation
   ↓
Feature Engineering
   ↓
PostgreSQL
   ↓
SQL Business Analysis
   ↓
Power BI / DAX
   ↓
Interactive Reporting
   ↓
Business Insights & Recommendations
```

### Role of Each Technology

**Python / Pandas**
Used for data profiling, cleaning, validation, feature engineering, and exploratory data analysis.

**PostgreSQL**
Used as the relational database layer to store the prepared dataset in a structured format.

**SQL**
Used to perform repeatable business analysis, aggregations, customer analysis, seller analysis, ranking, and contribution calculations.

**Power BI / DAX**
Used to create KPI measures, interactive dashboards, filtering, and business reporting.

---

# Data Cleaning & Validation

The dataset was validated before analysis to ensure consistency and reliability.

### Validation Checks

* **0** missing values
* **0** duplicate rows
* **0** duplicate OrderIDs
* No invalid or future dates detected
* No negative values in validated numeric fields
* Data types validated and standardized
* Date fields converted to appropriate date formats
* Derived metrics validated against source fields

### Feature Engineering

Additional analytical fields were created, including:

* GrossProductValue
* DiscountAmount
* NetProductSales
* EffectiveUnitPrice
* DiscountPercent
* Year
* Month
* MonthName
* Quarter
* YearMonth

---

# Exploratory Data Analysis

The exploratory analysis examines:

* Sales distributions
* Sales trends over time
* Product and category performance
* Customer purchasing behavior
* Discount patterns
* Seller performance
* Geographic distribution
* Order status
* Payment methods

EDA was used to identify patterns and determine areas requiring deeper business analysis.

---

# Business Analysis

## 1. Sales Performance

The analysis evaluates:

* Total orders
* Total customers
* Total units sold
* Gross Product Value
* Discount Amount
* Net Product Sales
* Average Order Value
* Median Order Value
* Monthly sales trends
* Daily sales trends
* Sales growth

### Key Metrics

| Metric                     |   Value |
| -------------------------- | ------: |
| Net Product Sales          | $84.24M |
| Gross Product Value        | $91.02M |
| Discount Amount            |  $6.78M |
| Total Recorded Order Value | $91.83M |
| Average Order Value        | $918.26 |
| Median Order Value         | $714.32 |
| Average Discount Rate      |   7.42% |
| Weighted Discount Rate     |   7.45% |

---

## 2. Product & Category Analytics

The analysis evaluates:

* Top products by Net Product Sales
* Top products by units sold
* Category performance
* Brand performance
* Category contribution
* Top products within each category

### Key Finding

**Electronics** generated **$14.29M** in Net Product Sales, representing **16.96%** of total Net Product Sales.

**Jeans** was the highest-performing product by Net Product Sales at **$343,506.76**.

---

## 3. Customer Analytics

Customer analysis focuses on:

* Customer order frequency
* Customer sales contribution
* Repeat customer behavior
* Customer segmentation
* Customer-category purchasing behavior

### Key Finding

**68.70% of customers were repeat buyers**, indicating substantial repeat purchasing activity within the observed dataset.

---

## 4. Discount & Pricing Analytics

The analysis evaluates:

* Discount distribution
* Average discount
* Weighted discount
* Discount by category
* Discount by brand
* High-discount products
* Effective selling price

The analysis distinguishes between gross product value, discounts, and Net Product Sales to avoid mixing different financial measures.

---

## 5. Seller Analytics

The analysis evaluates:

* Seller sales performance
* Seller order volume
* Seller customer reach
* Seller product coverage
* Seller concentration
* Top sellers by category

### Key Finding

The top 5 sellers contributed **38.53%** of observed sales, while the top 10 sellers contributed **76.23%**.

### Business Implication

The high concentration indicates potential dependency on a relatively small number of sellers. Further analysis could evaluate seller diversification and performance stability.

---

## 6. Geographic Analytics

The analysis evaluates:

* Country performance
* State performance
* City performance
* Geographic sales contribution
* Country-category performance
* Geographic concentration

### Key Findings

* **United States:** $58.99M in Net Product Sales
* **Charlotte:** $3.03M in Net Product Sales, the highest city-level contribution

These results provide a basis for investigating geographic expansion opportunities and market concentration.

---

## 7. Order & Payment Analytics

The analysis evaluates:

* Order status distribution
* Payment method usage
* Payment method sales contribution
* Payment method by country
* Payment method by order status
* High-value orders

### Key Findings

* **Credit Card** was the most frequently used payment method with **35,038 orders**.
* **Delivered** was the most common order status with **74,628 orders**.

---

# SQL Analytics

PostgreSQL and SQL were used to perform structured business analysis on the transactional dataset.

### SQL techniques used

* `GROUP BY`
* Aggregate functions
* `CASE WHEN`
* Common Table Expressions (CTEs)
* Window Functions
* Ranking
* Conditional aggregation
* Percentage calculations
* Customer-level analysis
* Seller contribution analysis
* Time-based analysis

### Example Business Analysis

A CTE-based analysis was used to calculate the percentage of customers with more than one order, resulting in a **68.70% repeat customer rate**.

SQL analysis was designed around business questions rather than only technical demonstrations.

---

# Power BI Dashboard

The Power BI dashboard converts the analytical results into interactive business reporting.

### Dashboard capabilities

* KPI cards
* Sales performance analysis
* Customer analysis
* Product and category analysis
* Seller performance
* Geographic analysis
* Order and payment analysis
* Slicers
* Cross-filtering
* Interactive visualizations

### Dashboard Objective

The dashboard allows users to explore sales, customer, product, seller, and geographic performance interactively and identify areas requiring further investigation.

---

# Key Business Insights

### Sales

**$84.24M** in Net Product Sales were generated across **100,000 orders**, with an Average Order Value of **$918.26**.

### Category

**Electronics** generated **$14.29M**, contributing **16.96%** of Net Product Sales.

### Customers

**68.70%** of customers were repeat buyers, highlighting strong repeat purchasing activity within the dataset.

### Sellers

The top 10 sellers contributed **76.23%** of observed sales, indicating significant seller concentration.

### Geography

The **United States** generated **$58.99M** in Net Product Sales, while **Charlotte** generated **$3.03M**, the highest city-level contribution.

### Products

**Jeans** generated the highest Net Product Sales among individual products at **$343,506.76**.

---

# Data-Driven Recommendations

### 1. Investigate Seller Concentration

With the top 10 sellers contributing **76.23%** of observed sales, seller diversification and dependency should be evaluated.

### 2. Investigate Electronics Growth

Electronics is the highest-performing category. Further analysis of products, brands, pricing, discounts, and sellers within the category could identify additional growth opportunities.

### 3. Leverage Repeat-Customer Behavior

With **68.70%** of customers identified as repeat buyers, customer retention and repeat-purchase patterns could be investigated further.

### 4. Analyze Geographic Concentration

The strong contribution from the United States provides an opportunity to analyze state- and city-level performance and identify areas for expansion or geographic dependency.

### 5. Evaluate Discount Effectiveness

Discount patterns should be evaluated alongside Net Product Sales and product/category performance to identify whether higher discounts correspond with stronger sales performance.

> **Note:** These are data-driven recommendations based on the observed dataset and are not claims of measured real-world business impact.

---

# Core Metrics

The project uses consistent metric definitions throughout the analytical workflow.

### Gross Product Value

```text
Quantity × UnitPrice
```

Represents the gross value of products before discounts.

### Discount Amount

```text
Gross Product Value × Discount
```

Represents the value reduced through discounts.

### Net Product Sales

```text
Gross Product Value − Discount Amount
```

Represents product sales after applying discounts.

### Effective Unit Price

```text
UnitPrice × (1 − Discount)
```

Represents the effective selling price per unit after discount.

### Total Recorded Order Value

```text
TotalAmount
```

Represents the recorded total value associated with the transaction.

---

# Data Quality & Analytical Considerations

The project prioritizes validation before analysis and distinguishes between descriptive findings and causal conclusions.

* High-value transactions were retained when they passed data-quality checks rather than being removed solely because of their magnitude.
* Seller and geographic concentration findings describe the observed dataset and should not automatically be generalized to the broader e-commerce market.
* Customer repeat-purchase analysis is based on transaction history available in the dataset.
* Relationships identified during analysis represent observed patterns and do not establish causality.

---

# Limitations

* The dataset represents an e-commerce analytical environment and may not reflect actual Amazon operational data.
* Analysis is based on the available transaction sample.
* The dataset does not include customer acquisition cost or marketing campaign data.
* Inventory, fulfillment, return-cost, and operational logistics data were not available.
* Observed relationships should not be interpreted as causal relationships.
* Seller concentration reflects the observed dataset and may differ from the broader marketplace.

---

# Project Structure

```text
Amazon-E-Commerce-Sales-Performance-Customer-Analytics/
│
├── data/
│   ├── raw/
│   └── processed/
│
├── notebooks/
│   ├── 01_Data_Cleaning.ipynb
│   ├── 02_EDA.ipynb
│   └── 03_Analysis.ipynb
│
├── sql/
│   ├── sales_analysis.sql
│   ├── customer_analysis.sql
│   ├── product_analysis.sql
│   ├── seller_analysis.sql
│   └── advanced_analysis.sql
│
├── powerbi/
│   └── Amazon_Ecommerce_Dashboard.pbix
│
├── screenshots/
│
├── README.md
└── requirements.txt
```

---

# Conclusion

This project demonstrates an end-to-end data analytics workflow using **Python, PostgreSQL, SQL, and Power BI** to transform transactional e-commerce data into structured business insights.

The analysis combines data preparation, exploratory analysis, SQL-based business questions, KPI development, interactive visualization, quantified findings, and data-driven recommendations to demonstrate practical data analyst capabilities.
