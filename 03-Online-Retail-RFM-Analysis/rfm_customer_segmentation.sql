/* ============================================================================
   PROJECT 3: CUSTOMER SEGMENTATION USING RFM ANALYSIS (ONLINE RETAIL DATASET)
   Tools: SQL Server (SSMS)
   Key Skills: Data Cleaning, Date Conversion (CONVERT), DATEDIFF, Chained CTEs,
               Window Functions (NTILE), Conditional Logic (CASE WHEN)
   ============================================================================ */

-- 1. Data Inspection: Check missing CustomerIDs, returns, and invalid prices
SELECT 
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS Null_CustomerID,
    SUM(CASE WHEN Quantity <= 0 THEN 1 ELSE 0 END) AS Returns_Or_Negative_Qty,
    SUM(CASE WHEN UnitPrice <= 0 THEN 1 ELSE 0 END) AS Invalid_Price
FROM retail_raw;

-- 2. Data Cleaning: Create a clean table with valid transactions & proper DateTime format
SELECT 
    InvoiceNo, 
    StockCode, 
    Description, 
    Quantity, 
    TRY_CONVERT(DATETIME, InvoiceDate, 103) AS Invoice_Date,
    UnitPrice, 
    CustomerID, 
    Country,
    ROUND(Quantity * UnitPrice, 2) AS Total_Sales
INTO Retail_Clean 
FROM retail_raw
WHERE CustomerID IS NOT NULL 
  AND Quantity > 0 
  AND UnitPrice > 0;

-- 3. RFM Analysis: Calculate Metrics, Assign Scores (1-4), and Segment Customers
WITH CTE_RFM_Base AS (
    SELECT 
        CustomerID,
        DATEDIFF(DAY, MAX(Invoice_Date), (SELECT MAX(Invoice_Date) FROM Retail_Clean)) AS Recency,
        COUNT(DISTINCT InvoiceNo) AS Frequency,
        ROUND(SUM(Total_Sales), 2) AS Monetary
    FROM Retail_Clean
    GROUP BY CustomerID
),
CTE_RFM_Scores AS ( 
    SELECT 
        CustomerID,
        Recency,
        Frequency,
        Monetary,
        NTILE(4) OVER (ORDER BY Recency DESC) AS R_Score,
        NTILE(4) OVER (ORDER BY Frequency ASC) AS F_Score,
        NTILE(4) OVER (ORDER BY Monetary ASC) AS M_Score
    FROM CTE_RFM_Base 
)
SELECT 
    CustomerID,
    Recency,
    Frequency,
    Monetary,
    (R_Score + F_Score + M_Score) AS Total_RFM_Score,
    CASE 
        WHEN (R_Score + F_Score + M_Score) >= 10 THEN 'Champions'
        WHEN (R_Score + F_Score + M_Score) >= 8  THEN 'Loyal Customers'
        WHEN (R_Score + F_Score + M_Score) >= 5  THEN 'At Risk'
        ELSE 'Lost Customers'
    END AS Customer_Segment
FROM CTE_RFM_Scores
ORDER BY Total_RFM_Score DESC;
