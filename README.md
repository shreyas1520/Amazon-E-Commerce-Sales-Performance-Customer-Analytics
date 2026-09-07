# Amazon E-Commerce Sales & Performance Analytics

An end-to-end e-commerce analytics project using **Python, PostgreSQL, SQL, Power BI, DAX, and Power Query** to analyze sales performance, customer behavior, products, categories, sellers, geography, discounts, orders, payments, and operational performance.

---

## Executive Summary

This project analyzes **100,000 e-commerce order records** to convert transactional data into structured business insights.


The analysis evaluates:

- Sales and order performance
- Product and category performance
- Customer purchasing behavior
- Repeat purchasing
- Discount and pricing patterns
- Seller performance and concentration
- Geographic performance
- Order status and payment behavior
- Shipping cost and operational performance
- Monthly sales and order trends

The final Power BI report provides four analytical dashboard pages:

1. **Amazon E-Commerce Sales & Performance**
2. **Product & Customer Analysis**
3. **Sales & Order Performance**
4. **Seller & Operational Analysis**

---

## Business Objectives

The project was designed to answer practical business questions such as:

- What is the overall sales and order performance?
- Which categories and products generate the highest sales?
- Which customers contribute the most sales or orders?
- What proportion of customers make repeat purchases?
- How are discounts distributed across categories?
- Which sellers contribute the most sales?
- How concentrated are sales among top sellers?
- Which countries and cities generate the highest sales?
- What is the most common order status?
- Which payment method is most frequently used?
- How do sales, orders, and shipping costs change over time?
- What operational patterns can be identified from seller and shipping data?

---

## Dataset

### Dataset Size

| Metric | Value |
|---|---:|
| Raw Rows | 100,000 |
| Raw Columns | 20 |
| Final Analytical Columns | 25 |
| Unique Orders | 100,000 |
| Unique Customers | 43,233 |
| Unique Products | 50 |
| Unique Sellers | 1,999 |
| Categories | 6 |
| Countries | 5 |
| Cities | 20 |
| Units Sold | 300,140 |

### Main Fields

The dataset contains fields covering:

- Order information
- Customer information
- Product information
- Category and brand
- Quantity and unit price
- Discount
- Tax
- Shipping cost
- Total order amount
- Payment method
- Order status
- Seller
- City, state, and country

### Derived Analytical Fields

The project created additional analytical fields including:

- `Year`
- `Month`
- `MonthName`
- `Quarter`
- `YearMonth`
- `GrossProductValue`
- `DiscountAmount`
- `NetProductSales`
- `EffectiveUnitPrice`
- `DiscountPercent`

---

## Tech Stack

| Area | Tools |
|---|---|
| Programming | Python |
| Data Analysis | Pandas, NumPy |
| Visualization | Matplotlib, Seaborn |
| Database | PostgreSQL |
| Querying | SQL |
| Business Intelligence | Power BI |
| BI Calculations | DAX |
| Data Transformation | Power Query |
| Development | Jupyter Notebook, VS Code |
| Version Control | Git, GitHub |

---

## Analytical Workflow

### 1. Data Understanding

Inspected:

- Dataset dimensions
- Column names
- Data types
- Numerical and categorical fields
- Date fields
- Identifier uniqueness
- Financial fields
- Business meaning of important columns

### 2. Data Cleaning & Validation

Performed checks for:

- Missing values
- Duplicate rows
- Duplicate OrderIDs
- Invalid dates
- Future dates
- Negative quantities
- Negative prices
- Negative discounts
- Negative tax values
- Negative shipping costs
- Categorical consistency
- Geographic consistency
- Financial calculation consistency

The validation showed:

- **0 missing values**
- **0 duplicate rows**
- **0 duplicate OrderIDs**
- **0 invalid/future dates**
- **0 negative values in the checked numerical fields**

The final analytical dataset contained **100,000 rows and 25 columns**.

Importantly, the project did not remove large numbers of records unnecessarily. The dataset was structurally clean, so the focus was on validation, transformation, and feature engineering.

---

## Financial Metric Definitions

A major analytical consideration in this project was keeping different financial fields separate.

### Gross Product Value

```text
Gross Product Value = Quantity × UnitPrice
```

### Discount Amount

```text
Discount Amount = Gross Product Value × Discount
```

### Net Product Sales

```text
Net Product Sales = Gross Product Value − Discount Amount
```

### Effective Unit Price

```text
Effective Unit Price = UnitPrice × (1 − Discount)
```

### Total Recorded Order Value

```text
Total Recorded Order Value = TotalAmount
```

`TotalAmount` is the dataset's recorded order amount and includes the recorded tax and shipping components.

### Important Metric Distinction

**Net Product Sales and Total Recorded Order Value are not interchangeable.**

The Power BI dashboard's **Total Sales** measure uses `TotalAmount`, while several deeper analytical findings use `Net Product Sales`.

This distinction is maintained throughout the project to avoid mixing different financial concepts.

---

## Core Business KPIs

| KPI | Verified Value |
|---|---:|
| Gross Product Value | **$91.02M** |
| Discount Amount | **$6.78M** |
| Net Product Sales | **$84.24M** |
| Total Recorded Order Value | **$91.83M** |
| Average Order Value | **$918.26** |
| Median Order Value | **$714.32** |
| Average Discount Rate | **7.42%** |
| Weighted Discount Rate | **7.45%** |
| Repeat Customer Rate | **68.70%** |
| Top 5 Seller Sales Share | **38.53%** |
| Top 10 Seller Sales Share | **76.23%** |

### Power BI Dashboard KPI Verification

The uploaded Power BI screenshots were checked against the project calculations.

The Executive and Sales & Order Performance pages display:

- **Total Sales:** approximately **$91.82M** on the dashboard card; underlying project value is **$91.83M Total Recorded Order Value**
- **Average Order Value:** **$918.26**
- **Total Quantity Sold:** **300K** displayed; underlying value **300,140**
- **Total Orders:** **100K** displayed; underlying value **100,000**
- **Total Customers:** **43K** displayed; underlying value **43,233**

The Seller & Operational Analysis page displays:

- **Total Sellers:** **2K** displayed; underlying value **1,999**
- **Average Seller Sales:** **$45.94K**
- **Average Shipping Cost:** **$7.41**
- **Total Shipping Cost:** **$740.67K**

---

## Exploratory Data Analysis

The exploratory analysis examined the distribution and behavior of:

- Sales
- Orders
- Quantity
- Unit price
- Discount
- Shipping cost
- Customer purchasing frequency
- Product performance
- Seller performance
- Geographic sales
- Order status
- Payment methods
- Monthly trends

Visualization techniques included:

- Bar charts
- Line charts
- Histograms
- Boxplots
- Category comparisons
- Customer rankings
- Seller rankings
- Geographic comparisons
- Discount-versus-sales analysis

---

## Product & Category Analysis

The project compared product and category performance using:

- Net Product Sales
- Total Recorded Order Value
- Orders
- Units sold
- Customers
- Average Order Value
- Average discount

### Key Finding — Electronics

**Electronics** was the strongest category based on Net Product Sales.

- Net Product Sales: **$14,288,614.19**
- Sales Share: **16.96%**
- Average Order Value: approximately **$924.71**

This indicates that Electronics was one of the strongest categories in the dataset and may deserve attention in areas such as product availability, inventory planning, and cross-selling.

### Highest-Selling Product

The highest-selling product based on Net Product Sales was:

**Jeans — $343,506.76**

---

## Customer Analysis

Customer-level analysis was performed using:

- Distinct customers
- Orders per customer
- Products purchased
- Categories purchased
- Units purchased
- Net Product Sales
- Total Recorded Order Value
- Average Order Value

### Repeat Customer Rate

The project defines a repeat customer as a customer with more than one order in the dataset.

```text
Repeat Customer Rate = Customers with >1 order / Total Customers × 100
```

Verified result:

**68.70%**

This is an observed repeat-purchasing signal within the dataset. It should not be interpreted as a formal customer-retention or churn metric because the dataset does not contain complete customer lifecycle or churn information.

### Customer Segmentation

Customers were grouped according to observed order frequency:

- **High Frequency:** 5 or more orders
- **Medium Frequency:** 3–4 orders
- **Repeat Customer:** 2 orders
- **Single Order:** 1 order

The Power BI dashboard also provides:

- Top 10 Customers by Sales
- Top 10 Customers by Orders

---

## Discount & Pricing Analysis

Discount behavior was analyzed at both overall and category levels.

### Verified Overall Discount Metrics

- Average Discount Rate: **7.42%**
- Weighted Discount Rate: **7.45%**
- Total Discount Amount: **$6.78M**

The weighted discount rate is calculated as:

```text
Weighted Discount Rate =
Total Discount Amount / Total Gross Product Value × 100
```

### Analytical Interpretation

A high discount rate may coexist with strong sales, but the dataset does not contain product cost, seller commission, or other complete profitability information.

Therefore, discount analysis is interpreted as a **pricing and sales pattern**, not as proof of profitability or discount effectiveness.

---

## Seller Analysis

Seller performance was analyzed using:

- Sales
- Orders
- Customers
- Products
- Categories
- Units
- Average Order Value
- Average Discount
- Shipping Cost

### Highest-Selling Seller

**SELL00806 — $65,834.21 Net Product Sales**

### Seller Concentration

| Seller Group | Share of Net Product Sales |
|---|---:|
| Top 5 Sellers | **38.53%** |
| Top 10 Sellers | **76.23%** |

The results indicate that a relatively small group of sellers contributes a large share of observed sales.

This should be treated as a **seller concentration indicator**, not proof of a serious business risk.

The Power BI dashboard includes:

- Top 10 Sellers by Sales
- Shipping Cost by Country
- Seller Sales vs Shipping Cost
- Monthly Shipping Cost Trend

---

## Geographic Analysis

The project analyzed performance by:

- Country
- State
- City

### Highest-Selling Country

**United States — $58,994,016.27 Net Product Sales**

### Highest-Selling City

**Charlotte, NC, United States — $3,033,620.31 Net Product Sales**

The dashboard provides a country-level sales comparison across:

- United States
- India
- Canada
- United Kingdom
- Australia

The United States is the strongest observed market in the dataset.

---

## Order & Payment Analysis

Order performance was evaluated using:

- Order status
- Order count
- Customer count
- Units
- Sales
- Average Order Value
- Payment method

### Most Common Order Status

**Delivered — 74,628 orders**

### Most Popular Payment Method

**Credit Card — 35,038 orders**

The Sales & Order Performance dashboard also analyzes:

- Sales by Order Status
- Order Status by Country
- Monthly Order Trend
- Monthly Sales Growth %

### Sales by Order Status

The dashboard shows:

- Delivered: **$68.37M (74.46%)**
- Shipped: **$14.08M (15.34%)**
- Pending: **$2.85M (3.1%)**
- Remaining sales are associated with Cancelled and Returned orders.

These dashboard percentages are based on the report's Total Sales / `TotalAmount` context.

---

## Shipping & Operational Analysis

Shipping cost was analyzed by:

- Country
- Seller
- Month
- Total sales

### Verified Dashboard KPIs

- Total Shipping Cost: **$740.67K**
- Average Shipping Cost: **$7.41**
- Average Seller Sales: **$45.94K**
- Total Sellers: **1,999**

### Operational Views

The dashboard contains:

- Shipping Cost by Country
- Top 10 Sellers by Sales
- Seller Sales vs Shipping Cost
- Monthly Shipping Cost Trend

The seller-versus-shipping scatter plot provides an exploratory view of the relationship between observed seller sales and shipping costs.

This should be interpreted as an observed relationship rather than proof of causation.

---

## SQL Analysis

PostgreSQL was used to store the cleaned dataset and SQL was used for structured business analysis.

The project used:

- `SELECT`
- `WHERE`
- `GROUP BY`
- `ORDER BY`
- `DISTINCT`
- `COUNT`
- `SUM`
- `AVG`
- `CASE`
- `FILTER`
- CTEs
- Window functions
- Ranking
- Date functions
- Business-oriented aggregations

### Example Business Questions

SQL analysis addressed questions such as:

- Which month generated the highest sales?
- Which product generated the highest sales?
- Which seller generated the highest sales?
- Which country generated the highest sales?
- Which city generated the highest sales?
- Which payment method was most popular?
- What was the most common order status?
- What percentage of customers were repeat customers?
- How concentrated were sales among top sellers?

### Repeat Customer SQL Concept

The repeat-customer analysis used a customer-level aggregation to:

1. Count distinct orders per customer.
2. Identify customers with more than one order.
3. Calculate the percentage of repeat customers.

Verified result:

**68.70%**

---

## Power BI Dashboard

The final Power BI report contains four analytical pages.

### 1. Amazon E-Commerce Sales & Performance

Provides the executive overview with:

- Total Sales
- Average Order Value
- Total Quantity Sold
- Total Orders
- Total Customers
- Monthly Sales Trend
- Sales by Country
- Sales by Category
- Interactive filters for:
  - Year Month
  - Category
  - Country
  - Order Status

### 2. Product & Customer Analysis

Provides:

- Top 10 Products by Sales
- Sales by Brand
- Top 10 Customers by Sales
- Top 10 Customers by Orders
- Discount vs Sales

### 3. Sales & Order Performance

Provides:

- Total Sales
- Total Orders
- Average Order Value
- Total Quantity Sold
- Monthly Sales Growth %
- Sales by Country
- Order Status by Country
- Sales by Order Status
- Monthly Order Trend

### 4. Seller & Operational Analysis

Provides:

- Total Sellers
- Average Seller Sales
- Average Shipping Cost
- Total Shipping Cost
- Shipping Cost by Country
- Top 10 Sellers by Sales
- Seller Sales vs Shipping Cost
- Monthly Shipping Cost Trend

---

## DAX Measures

The Power BI report uses dynamic DAX measures rather than hardcoded KPI values.

### Total Sales

```DAX
Total Sales =
SUM('ecommerce amazon_sales'[TotalAmount])
```

### Total Orders

```DAX
Total Orders =
DISTINCTCOUNT('ecommerce amazon_sales'[OrderID])
```

### Average Order Value

```DAX
Average Order Value =
DIVIDE(
    [Total Sales],
    [Total Orders]
)
```

### Total Customers

```DAX
Total Customers =
DISTINCTCOUNT('ecommerce amazon_sales'[CustomerID])
```

### Total Sellers

```DAX
Total Sellers =
DISTINCTCOUNT('ecommerce amazon_sales'[SellerID])
```

### Total Shipping Cost

```DAX
Total Shipping Cost =
SUM('ecommerce amazon_sales'[ShippingCost])
```

### Average Shipping Cost

```DAX
Average Shipping Cost =
AVERAGE('ecommerce amazon_sales'[ShippingCost])
```

### Additional Measures

The dashboard also contains measures for:

- Average Seller Sales
- Sales Growth %

The exact period definition used by the Sales Growth % measure should be verified directly in the Power BI model before describing it as MoM, YoY, or another specific comparison.

---

## Key Business Insights

### 1. Electronics was the strongest category

Electronics generated **$14.29M in Net Product Sales**, representing **16.96%** of total Net Product Sales.

### 2. Repeat purchasing was substantial

**68.70%** of customers had placed more than one order in the dataset.

This indicates a strong observed repeat-purchasing pattern within the available data.

### 3. Seller sales were concentrated

The top 5 sellers contributed **38.53%** of Net Product Sales, while the top 10 contributed **76.23%**.

This concentration can be monitored as an indicator of marketplace dependency on a smaller group of high-performing sellers.

### 4. United States was the strongest geographic market

The United States generated **$58.99M in Net Product Sales**, making it the strongest country in the dataset.

### 5. Delivered orders dominated order status

**74,628 orders** were classified as Delivered, making it the most common order status.

### 6. Credit Card was the most common payment method

Credit Card accounted for **35,038 orders**.

### 7. Sales and shipping costs were analyzed together

The Seller & Operational Analysis dashboard compares seller sales and shipping costs to identify observable operational patterns and areas for further investigation.

---

## Data-Driven Recommendations

### Category Strategy

- Prioritize high-performing categories such as Electronics for inventory and availability analysis.
- Investigate category-level sales and discount patterns before changing pricing strategies.
- Explore cross-selling opportunities around high-performing categories.

### Customer Strategy

- Use repeat-purchasing behavior to support loyalty and retention analysis.
- Extend the analysis with RFM segmentation.
- Investigate high-frequency customers separately from one-time purchasers.

### Seller Strategy

- Monitor sales concentration among top sellers.
- Develop additional high-performing sellers to diversify marketplace contribution.
- Combine seller sales with seller ratings, returns, inventory, and service metrics in future analysis.

### Geographic Strategy

- Prioritize high-performing markets for deeper category and customer analysis.
- Compare geographic performance with population, market size, delivery time, and shipping cost when those variables become available.

### Operational Strategy

- Monitor shipping cost trends over time.
- Investigate sellers or markets with unusually high shipping costs relative to sales.
- Combine shipping analysis with delivery performance and distance data in future iterations.

---

## Limitations

The dataset does not contain:

- Product cost
- Profit or profit margin
- Seller commission
- Seller rating
- Customer rating/review
- Inventory level
- Return amount
- Payment processing cost
- Fraud labels
- Shipping distance
- Latitude/longitude
- Regional market size
- Marketing spend

Therefore:

- The project is primarily **sales and operational analytics**, not profitability analytics.
- Sales patterns should not be interpreted as causal relationships.
- Repeat purchasing is an observed dataset-level signal, not a formal churn/retention model.
- Seller concentration is an indicator for investigation, not proof of business risk.
- Dashboard and analytical metrics must be interpreted according to their defined metric context.

---

## Future Scope

Potential improvements include:

- Profitability analysis
- Cost of Goods Sold integration
- Seller commission analysis
- Return and refund analysis
- RFM customer segmentation
- Customer Lifetime Value
- Inventory analysis
- Delivery-time analysis
- Product and seller ratings
- Predictive sales forecasting
- Customer behavior prediction
- Seller risk/concentration monitoring
- Anomaly detection
- More advanced geographic analysis

The project should not attempt to predict profitability from the current dataset because the required cost information is not available.

---

## Project Outcome

The main learning outcome was understanding that data analytics is not only about creating dashboards. Reliable analysis requires:

- Understanding the dataset
- Validating data quality
- Defining metrics correctly
- Asking meaningful business questions
- Separating analytical metrics carefully
- Connecting findings to business decisions
- Recognizing limitations before making conclusions

---

## Conclusion

The Amazon E-Commerce Sales & Performance Analytics project converts **100,000 transactional records** into an interactive analytical solution covering sales, customers, products, categories, sellers, geography, orders, payments, discounts, and shipping operations.

The analysis identified:

- **$91.83M Total Recorded Order Value**
- **$84.24M Net Product Sales**
- **$918.26 Average Order Value**
- **68.70% Repeat Customer Rate**
- **16.96% Net Product Sales share for Electronics**
- **38.53% Top 5 Seller Sales Share**
- **76.23% Top 10 Seller Sales Share**

The project demonstrates practical use of **Python, PostgreSQL, SQL, Power BI, DAX, and Power Query** to transform raw transactional data into structured business insights and decision-support reporting.


---

## Author

**Shreyas Kadam**
