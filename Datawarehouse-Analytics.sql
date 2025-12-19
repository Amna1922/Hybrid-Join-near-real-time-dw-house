USE walmart;

-- Q1. Top Revenue-Generating Products on Weekdays and Weekends with Monthly Drill-Down
SELECT 
    YEAR(fs.Date_ID) AS Year,
    MONTH(fs.Date_ID) AS Month,
    CASE WHEN dd.Is_Weekend = 1 THEN 'Weekend' ELSE 'Weekday' END AS Day_Type,
    fs.Product_ID,
    SUM(fs.Total_Amount) AS Total_Revenue
FROM FactSales fs
JOIN DimDate dd ON fs.Date_ID = dd.Date_ID
WHERE YEAR(fs.Date_ID) = 2015 
GROUP BY YEAR(fs.Date_ID), MONTH(fs.Date_ID), Day_Type, fs.Product_ID
ORDER BY Year, Month, Day_Type, Total_Revenue DESC
limit 5;

-- Q2. Customer Demographics by Purchase Amount with City Category Breakdown
SELECT 
    Gender,
    Age,
    City_Category,
    SUM(Total_Amount) AS Total_Spent,
    COUNT(*) AS Total_Purchases
FROM FactSales
GROUP BY Gender, Age, City_Category
ORDER BY Total_Spent DESC;

-- Q3. Product Category Sales by Occupation
SELECT 
    Occupation,
    Product_Category,
    SUM(Total_Amount) AS Category_Revenue,
    SUM(Quantity) AS Items_Sold
FROM FactSales
GROUP BY Occupation, Product_Category
ORDER BY Occupation, Category_Revenue DESC;

-- Q4. Total Purchases by Gender and Age Group with Quarterly Trend
SELECT 
    Gender,
    Age,
    QUARTER(Date_ID) AS Quarter,
    SUM(Total_Amount) AS Quarterly_Spending
FROM FactSales
WHERE YEAR(Date_ID) = 2015  
GROUP BY Gender, Age, Quarter
ORDER BY Quarter, Gender, Age;

-- Q5. Top Occupations by Product Category Sales
SELECT 
    Product_Category,
    Occupation,
    SUM(Total_Amount) AS Category_Revenue
FROM FactSales
GROUP BY Product_Category, Occupation
HAVING Category_Revenue > 0
ORDER BY Product_Category, Category_Revenue DESC
LIMIT 5;

-- Q6. City Category Performance by Marital Status with Monthly Breakdown
SELECT 
    City_Category,
    Marital_Status,
    MONTH(Date_ID) AS Month,
    SUM(Total_Amount) AS Monthly_Revenue
FROM FactSales
WHERE Date_ID >= DATE_SUB('2020-12-31', INTERVAL 6 MONTH)  -- Last 6 months
GROUP BY City_Category, Marital_Status, Month
ORDER BY City_Category, Marital_Status, Month;

-- Q7. Average Purchase Amount by Stay Duration and Gender
SELECT 
    Stay_In_Current_City_Years,
    Gender,
    AVG(Total_Amount) AS Avg_Spend_Per_Transaction,
    COUNT(*) AS Total_Transactions
FROM FactSales
GROUP BY Stay_In_Current_City_Years, Gender
ORDER BY Stay_In_Current_City_Years, Gender;

-- Q8. Top 5 Revenue-Generating Cities by Product Category
SELECT 
    City_Category,
    Product_Category,
    SUM(Total_Amount) AS Category_Revenue
FROM FactSales
GROUP BY City_Category, Product_Category
ORDER BY Product_Category, Category_Revenue DESC
LIMIT 5;

-- Q9. Monthly Sales Growth by Product Category
SELECT 
    Product_Category,
    YEAR(Date_ID) AS Year,
    MONTH(Date_ID) AS Month,
    SUM(Total_Amount) AS Monthly_Revenue
FROM FactSales
WHERE YEAR(Date_ID) = 2020
GROUP BY Product_Category, YEAR(Date_ID), MONTH(Date_ID)
ORDER BY Product_Category, Month;

-- Q10. Weekend vs. Weekday Sales by Age Group
SELECT 
    Age,
    CASE WHEN dd.Is_Weekend = 1 THEN 'Weekend' ELSE 'Weekday' END AS Day_Type,
    SUM(fs.Total_Amount) AS Total_Spending,
    COUNT(*) AS Number_of_Transactions
FROM FactSales fs
JOIN DimDate dd ON fs.Date_ID = dd.Date_ID
WHERE YEAR(fs.Date_ID) = 2020
GROUP BY Age, Day_Type
ORDER BY Age, Day_Type;

-- Q11. Top Revenue-Generating Products on Weekdays and Weekends with Monthly Drill-Down
SELECT 
    YEAR(fs.Date_ID) AS Year,
    MONTH(fs.Date_ID) AS Month,
    CASE WHEN dd.Is_Weekend = 1 THEN 'Weekend' ELSE 'Weekday' END AS Day_Type,
    fs.Product_ID,
    SUM(fs.Total_Amount) AS Total_Revenue
FROM FactSales fs
JOIN DimDate dd ON fs.Date_ID = dd.Date_ID
WHERE YEAR(fs.Date_ID) = 2020
GROUP BY YEAR(fs.Date_ID), MONTH(fs.Date_ID), Day_Type, fs.Product_ID
ORDER BY Year, Month, Day_Type, Total_Revenue DESC
LIMIT 5;

-- Q12. Trend Analysis of Store Revenue Growth Rate Quarterly for 2017
SELECT 
    dp.StoreName,
    QUARTER(fs.Date_ID) AS Quarter,
    SUM(fs.Total_Amount) AS Quarterly_Revenue
FROM FactSales fs
JOIN DimProduct dp ON fs.Product_ID = dp.Product_ID
WHERE YEAR(fs.Date_ID) = 2017
GROUP BY dp.StoreName, QUARTER(fs.Date_ID)
ORDER BY dp.StoreName, Quarter;

-- Q13. Detailed Supplier Sales Contribution by Store and Product Name
SELECT 
    dp.StoreName,
    dp.SupplierName,
    fs.Product_ID,
    SUM(fs.Total_Amount) AS Total_Revenue,
    SUM(fs.Quantity) AS Total_Units_Sold
FROM FactSales fs
JOIN DimProduct dp ON fs.Product_ID = dp.Product_ID
GROUP BY dp.StoreName, dp.SupplierName, fs.Product_ID
ORDER BY dp.StoreName, dp.SupplierName, Total_Revenue DESC;

-- Q14. Seasonal Analysis of Product Sales Using Dynamic Drill-Down
SELECT 
    Product_ID,
    CASE 
        WHEN MONTH(Date_ID) IN (3,4,5) THEN 'Spring'
        WHEN MONTH(Date_ID) IN (6,7,8) THEN 'Summer'
        WHEN MONTH(Date_ID) IN (9,10,11) THEN 'Fall'
        ELSE 'Winter'
    END AS Season,
    SUM(Total_Amount) AS Seasonal_Revenue,
    SUM(Quantity) AS Seasonal_Units
FROM FactSales
GROUP BY Product_ID, Season
ORDER BY Product_ID, 
         FIELD(Season, 'Spring', 'Summer', 'Fall', 'Winter');
         
-- Q15. Store-Wise and Supplier-Wise Monthly Revenue Volatility
SELECT 
    dp.StoreName,
    dp.SupplierName,
    YEAR(fs.Date_ID) AS Year,
    MONTH(fs.Date_ID) AS Month,
    SUM(fs.Total_Amount) AS Monthly_Revenue
FROM FactSales fs
JOIN DimProduct dp ON fs.Product_ID = dp.Product_ID
GROUP BY dp.StoreName, dp.SupplierName, YEAR(fs.Date_ID), MONTH(fs.Date_ID)
ORDER BY dp.StoreName, dp.SupplierName, Year, Month;

-- Q16. Top 5 Products Purchased Together Across Multiple Orders (Product Affinity Analysis)
-- connection lost alwaysss--------idk why :(
SELECT 
    a.Product_ID AS Product1,
    b.Product_ID AS Product2,
    COUNT(*) AS Times_Bought_Together
FROM FactSales a
JOIN FactSales b ON a.Order_ID = b.Order_ID 
                 AND a.Product_ID < b.Product_ID  -- Avoid duplicates
WHERE a.Order_ID = b.Order_ID
GROUP BY a.Product_ID, b.Product_ID
ORDER BY Times_Bought_Together DESC
LIMIT 5;

-- Q17. Yearly Revenue Trends by Store, Supplier, and Product with ROLLUP

SELECT 
    dp.StoreName,
    dp.SupplierName,
    fs.Product_ID,
    YEAR(fs.Date_ID) AS Year,
    SUM(fs.Total_Amount) AS Total_Revenue
FROM FactSales fs
JOIN DimProduct dp ON fs.Product_ID = dp.Product_ID
GROUP BY dp.StoreName, dp.SupplierName, fs.Product_ID, YEAR(fs.Date_ID)
WITH ROLLUP;


-- Q18. Revenue and Volume-Based Sales Analysis for Each Product for H1 and H2
SELECT 
    Product_ID,
    CASE 
        WHEN MONTH(Date_ID) BETWEEN 1 AND 6 THEN 'First Half'
        ELSE 'Second Half'
    END AS Half_Year,
    SUM(Total_Amount) AS Half_Year_Revenue,
    SUM(Quantity) AS Half_Year_Units
FROM FactSales
WHERE YEAR(Date_ID) = 2018
GROUP BY Product_ID, Half_Year
ORDER BY Product_ID, Half_Year;

-- Q19. Identify High Revenue Spikes in Product Sales and Highlight Outliers
-- always connection lost..:(
SELECT 
    Product_ID,
    Date_ID,
    SUM(Total_Amount) AS ddaily_revenue,
    (SELECT AVG(Total_Amount) FROM FactSales fs2 WHERE fs2.Product_ID = fs1.Product_ID) AS Avg_Daily_Sales
FROM FactSales fs1
GROUP BY Product_ID, Date_ID
HAVING ddaily_revenue > 2 * Avg_Daily_Sales
ORDER BY (ddaily_revenue / Avg_Daily_Sales) DESC;

-- Q20. Create a View STORE_QUARTERLY_SALES for Optimized Sales Analysis
CREATE VIEW STORE_QUARTERLY_SALES_view AS
SELECT 
    StoreName,
    YEAR(Date_ID) AS Year,
    QUARTER(Date_ID) AS Quarter,
    SUM(Total_Amount) AS Quarterly_Revenue,
    SUM(Quantity) AS Quarterly_Units_Sold,
    COUNT(*) AS Number_of_Transactions
FROM FactSales
GROUP BY StoreName, Year, Quarter
ORDER BY StoreName, Year, Quarter;


SELECT * FROM STORE_QUARTERLY_SALES_view
WHERE Year = 2020
ORDER BY Quarterly_Revenue DESC;

