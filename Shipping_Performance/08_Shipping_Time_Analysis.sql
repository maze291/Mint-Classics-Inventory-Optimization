-- Analyzes current shipping performance against 24-hour goal grouped by warehouse.
WITH ShippingPerformance AS (
    SELECT 
        o.orderNumber,
        o.orderDate,
        o.shippedDate,
        o.requiredDate,
        p.warehouseCode,
        DATEDIFF(o.shippedDate, o.orderDate) as days_to_ship,
        CASE 
            WHEN DATEDIFF(o.shippedDate, o.orderDate) <= 1 THEN 1 
            ELSE 0 
        END as met_24hr_goal
    FROM orders o
    JOIN orderdetails od ON o.orderNumber = od.orderNumber
    JOIN products p ON od.productCode = p.productCode
    WHERE o.shippedDate IS NOT NULL
)
SELECT 
    warehouseCode,
    COUNT(*) as total_orders,
    AVG(days_to_ship) as avg_shipping_days,
    MIN(days_to_ship) as min_shipping_days,
    MAX(days_to_ship) as max_shipping_days,
    SUM(met_24hr_goal) * 100.0 / COUNT(*) as pct_met_24hr_goal
FROM ShippingPerformance
GROUP BY warehouseCode
ORDER BY pct_met_24hr_goal DESC;
