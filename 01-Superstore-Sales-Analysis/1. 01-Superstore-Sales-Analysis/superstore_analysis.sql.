/* ============================================================================
   PROJECT 1: RETAIL SALES & PROFITABILITY ANALYSIS (SUPERSTORE DATASET)
   Tools: SQL Server (SSMS)
   Key Skills: Aggregations, HAVING, CTEs, Window Functions (DENSE_RANK, LAG), CASE WHEN
   ============================================================================ */

-- 1. Financial Overview by Category (Sales, Profit & Profit Margin %)
SELECT 
    Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND((SUM(Profit) / NULLIF(SUM(Sales), 0)) * 100, 2) AS Profit_Margin_Pct
FROM Orders
GROUP BY Category
ORDER BY Total_Sales DESC;

-- 2. Loss-Making Sub-Categories & Average Discount Impact
SELECT 
    Sub_Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(AVG(Discount) * 100, 2) AS Avg_Discount_Pct
FROM Orders
GROUP BY Sub_Category
HAVING SUM(Profit) < 0
ORDER BY Total_Profit ASC;

-- 3. Top 5 Most Profitable Cities per Region (Using CTE & DENSE_RANK)
WITH Top_Cities AS (
    SELECT 
        Region,
        City,
        ROUND(SUM(Profit), 2) AS Total_Profit,
        DENSE_RANK() OVER (PARTITION BY Region ORDER BY ROUND(SUM(Profit), 2) DESC) AS Rank_By_Region
    FROM Orders
    GROUP BY Region, City
)
SELECT 
    Region,
    City,
    Total_Profit,
    Rank_By_Region
FROM Top_Cities
WHERE Rank_By_Region <= 5;

-- 4. Month-over-Month (MoM) Sales Growth Analysis (Using Chained CTEs & LAG)
WITH Monthly_Sales AS (
    SELECT
        YEAR(Order_Date) AS Order_Year,
        MONTH(Order_Date) AS Order_Month,
        ROUND(SUM(Sales), 2) AS Total_Sales
    FROM Orders
    GROUP BY YEAR(Order_Date), MONTH(Order_Date)
),
Prev_Month_Calc AS (
    SELECT 
        Order_Year,
        Order_Month,
        Total_Sales,
        LAG(Total_Sales) OVER (ORDER BY Order_Year, Order_Month) AS Prev_Month_Sales
    FROM Monthly_Sales
)
SELECT 
    Order_Year,
    Order_Month,
    Total_Sales,
    Prev_Month_Sales,
    ROUND(((Total_Sales - Prev_Month_Sales) / NULLIF(Prev_Month_Sales, 0)) * 100, 2) AS MoM_Growth_Pct
FROM Prev_Month_Calc
ORDER BY Order_Year, Order_Month;

-- 5. Customer Value Segmentation (Using CTE & CASE WHEN)
WITH CTE_TotalSales AS (
    SELECT
        Customer_ID,
        Customer_Name,
        ROUND(SUM(Sales), 2) AS Total_Sales
    FROM Orders
    GROUP BY Customer_ID, Customer_Name
),
CTE_CustomerSegment AS (
    SELECT 
        Customer_ID,
        Customer_Name,
        Total_Sales, 
        CASE 
            WHEN Total_Sales >= 5000 THEN 'High Value'
            WHEN Total_Sales >= 2000 AND Total_Sales < 5000 THEN 'Medium Value'
            ELSE 'Low Value' 
        END AS Customer_Segment
    FROM CTE_TotalSales
)
SELECT
    Customer_Segment,
    COUNT(Customer_ID) AS Customer_Count,
    ROUND(SUM(Total_Sales), 2) AS Segment_Sales
FROM CTE_CustomerSegment
GROUP BY Customer_Segment
ORDER BY Segment_Sales DESC;
