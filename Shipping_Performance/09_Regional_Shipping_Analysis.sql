-- Analyzes shipping performance by customers' state and country(shipping time by geography). And identifies which region a warehouse delivers to best
WITH CustomerShipping AS (
    SELECT 
        o.orderNumber,
        c.country,
        c.state,
        p.warehouseCode,
        DATEDIFF(o.shippedDate, o.orderDate) as days_to_ship
    FROM orders o
    JOIN customers c ON o.customerNumber = c.customerNumber
    JOIN orderdetails od ON o.orderNumber = od.orderNumber
    JOIN products p ON od.productCode = p.productCode
    WHERE o.shippedDate IS NOT NULL -- filter out NULL values, Customer Shipping creates a regional dataset of order shipping times per warehouse.
)
SELECT 
    warehouseCode,
    country,
    state,
    COUNT(*) as order_count,
    AVG(days_to_ship) as avg_shipping_days,
    MIN(days_to_ship) as fastest_shipping,
    MAX(days_to_ship) as slowest_shipping,
    COUNT(CASE WHEN days_to_ship <= 1 THEN 1 END) * 100.0 / COUNT(*) as pct_24hr_delivery
FROM CustomerShipping
GROUP BY warehouseCode, country, state
HAVING order_count >= 5  -- Filter out statistically unimportant regions
ORDER BY warehouseCode, avg_shipping_days;
