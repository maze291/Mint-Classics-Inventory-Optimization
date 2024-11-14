-- Analyzes how order volume affects shipping times
WITH DailyOrders AS (
    SELECT 
        o.orderDate,
        p.warehouseCode,
        COUNT(DISTINCT o.orderNumber) as daily_orders,
        AVG(DATEDIFF(o.shippedDate, o.orderDate)) as avg_ship_time
    FROM orders o
    JOIN orderdetails od ON o.orderNumber = od.orderNumber
    JOIN products p ON od.productCode = p.productCode
    WHERE o.shippedDate IS NOT NULL
    GROUP BY o.orderDate, p.warehouseCode
)
SELECT 
    warehouseCode,
    CASE 
        WHEN daily_orders <= 1 THEN 'Low Volume (<=1)'
        WHEN daily_orders <= 3 THEN 'Medium Volume (1.1-3)' -- depends on data set again
        ELSE 'High Volume (>3)'
   END as volume_category,
    COUNT(*) as days_in_category,
    AVG(daily_orders) as avg_daily_orders,
    AVG(avg_ship_time) as avg_shipping_days,
    COUNT(CASE WHEN avg_ship_time <= 1 THEN 1 END) * 100.0 / COUNT(*) as pct_met_24hr_goal -- count which achieved 24 hour goal achievement
FROM DailyOrders
GROUP BY 
    warehouseCode,
    CASE 
        WHEN daily_orders <= 1 THEN 'Low Volume (<=1)'
        WHEN daily_orders <= 3 THEN 'Medium Volume (1.1-3)'
        ELSE 'High Volume (>3)'
    END 
ORDER BY warehouseCode, volume_category;
