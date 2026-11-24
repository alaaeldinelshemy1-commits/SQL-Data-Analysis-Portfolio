/* ============================================================================
   PROJECT 4: MULTI-TABLE E-COMMERCE ANALYSIS (OLIST BRAZILIAN DATASET)
   Tools: SQL Server (SSMS)
   Key Skills: Multi-Table Joins (LEFT JOIN), Distinct Aggregations, CTEs,
               Window Functions (DENSE_RANK), Business KPIs
   ============================================================================ */

-- 1. Order Status Distribution & Total Revenue
SELECT 
    o.order_status,
    COUNT(DISTINCT o.order_id) AS Total_Orders,
    ROUND(SUM(op.payment_value), 2) AS Total_Revenue
FROM orders o
LEFT JOIN order_payments op
    ON o.order_id = op.order_id
GROUP BY o.order_status
ORDER BY Total_Revenue DESC;

-- 2. Top 10 Product Categories by Revenue & Units Sold (Delivered Orders Only)
SELECT TOP 10
    p.product_category_name,
    COUNT(oi.order_item_id) AS Total_Items_Sold,
    ROUND(SUM(oi.price), 2) AS Total_Revenue
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN orders o
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY p.product_category_name
ORDER BY Total_Revenue DESC;

-- 3. Top 3 States by Revenue & Unique Customer Count (Using CTE & DENSE_RANK)
WITH CTE_State_Revenue AS (
    SELECT 
        c.customer_state,
        COUNT(DISTINCT c.customer_unique_id) AS Unique_Customers,
        ROUND(SUM(op.payment_value), 2) AS Total_Revenue,
        DENSE_RANK() OVER (ORDER BY ROUND(SUM(op.payment_value), 2) DESC) AS State_Rank
    FROM orders o
    LEFT JOIN customers c
        ON o.customer_id = c.customer_id
    LEFT JOIN order_payments op
        ON o.order_id = op.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_state
)
SELECT 
    State_Rank,
    customer_state,
    Unique_Customers,
    Total_Revenue
FROM CTE_State_Revenue
WHERE State_Rank <= 3
ORDER BY State_Rank ASC;
