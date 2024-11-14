-- SQL Code to Analyze Price Impact on Demand and Revenue
-- This code divides products into four price quarters to observe how price affects sales volume and revenue.
-- The following metrics are calculated for each price quarter:
-- 1. Product Count: The total number of unique products within each price quarter.
-- 2. Total Quantity Sold: The sum of units sold within each price quarter, representing demand in said price range.
-- 3. Total Revenue: The total revenue generated from sales in each price quarter.
-- 4. Average Price: The average price within each price quarter, confirming that products fall into the intended price ranges.

-- By analyzing these metrics, this code helps identify patterns in price sensitivity and revenue distribution. For example:
-- - Lower price quarters may have higher quantities sold but generate less revenue.
-- - Higher price quarters may show lower quantities sold but contribute more revenue per unit.
-- Using this we can analyze and determine the optimal price range where revenue and demand are balanced.

SELECT 
    CASE 
        WHEN od.priceEach BETWEEN 26.55 AND 73.49 THEN 'Q1: $26.55 - $73.49'
        WHEN od.priceEach BETWEEN 73.50 AND 120.44 THEN 'Q2: $73.50 - $120.44'
        WHEN od.priceEach BETWEEN 120.45 AND 167.39 THEN 'Q3: $120.45 - $167.39'
        ELSE 'Q4: $167.40 - $214.30'
    END AS price_quarter,
    COUNT(od.productCode) AS product_count,
    SUM(od.quantityOrdered) AS total_quantity_sold,
    SUM(od.priceEach * od.quantityOrdered) AS total_revenue,
    AVG(od.priceEach) AS average_price
FROM 
    orderdetails od
GROUP BY 
    price_quarter
ORDER BY 
    price_quarter;


