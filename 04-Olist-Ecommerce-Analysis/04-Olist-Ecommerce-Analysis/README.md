# Multi-Table E-Commerce Analysis — Olist Dataset (SQL)

## Project Overview
This project explores a relational database of **100,000+ e-commerce orders** from the Brazilian Olist dataset using **SQL Server**. By joining five core tables (`orders`, `order_items`, `order_payments`, `customers`, and `products`), the analysis uncovers order fulfillment metrics, top-performing product categories, and geographic revenue concentration.

## Key Business Questions Answered
1. **Order Fulfillment & Revenue:** Evaluated order counts and total payment values across different order statuses (`delivered`, `shipped`, `canceled`, etc.) while preventing double-counting on multi-installment orders.
2. **Product Category Performance:** Joined transactional items, product metadata, and order statuses to rank the top 10 revenue-generating product categories for delivered orders.
3. **Geographic Market Leaders:** Identified the top 3 Brazilian states (*SP*, *RJ*, and *MG*) driving revenue and unique customer acquisition using `CTE` and `DENSE_RANK()`.

## SQL Techniques Used
- **Relational Joins:** Multi-table `LEFT JOIN` across 3+ normalized tables
- **Data Integrity:** `COUNT(DISTINCT ...)` to handle one-to-many payment and customer relationships
- **Window Functions & CTEs:** `DENSE_RANK() OVER (ORDER BY ...)` wrapped in Common Table Expressions
