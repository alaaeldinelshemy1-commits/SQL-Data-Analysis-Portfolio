# Retail Sales & Profitability Analysis (SQL)

## Project Overview
This project analyzes retail transaction data (~10,000 records) from the Superstore dataset using **SQL Server** to evaluate financial profitability, uncover discount-driven losses, track monthly sales growth, and segment customers by spending behavior.

## Key Business Questions Answered
1. **Category Profitability:** Evaluated total revenue, net profit, and profit margins across main product categories.
2. **Loss & Discount Analysis:** Identified sub-categories generating net losses (such as *Tables* and *Bookcases*) due to excessive discounting.
3. **Regional Top Performers:** Ranked the top 5 most profitable cities within each geographic region using `DENSE_RANK()`.
4. **Time-Series Growth:** Calculated Month-over-Month (MoM) revenue growth trends using `LAG()`.
5. **Customer Segmentation:** Classified customers into *High*, *Medium*, and *Low Value* tiers using `CASE WHEN` and CTEs.

## SQL Techniques Used
- **Aggregations & Filtering:** `SUM()`, `AVG()`, `COUNT()`, `GROUP BY`, `HAVING`, `NULLIF()`
- **Window Functions:** `DENSE_RANK() OVER (PARTITION BY ...)`, `LAG() OVER (ORDER BY ...)`
- **Query Organization:** Common Table Expressions (`CTEs`) & Conditional Logic (`CASE WHEN`)
