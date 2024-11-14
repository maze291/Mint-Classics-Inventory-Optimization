-- Identifies patterns in delayed shipments, Highlights warehouses with most delays
SELECT 
    p.warehouseCode,
    COUNT(DISTINCT o.orderNumber) as total_orders,
    COUNT(DISTINCT CASE 
        WHEN DATEDIFF(o.shippedDate, o.orderDate) > 1 THEN o.orderNumber 
    END) as late_shipments,
    AVG(CASE 
        WHEN DATEDIFF(o.shippedDate, o.orderDate) > 1 
        THEN DATEDIFF(o.shippedDate, o.orderDate) 
    END) as avg_delay_days,
    COUNT(DISTINCT CASE 
        WHEN o.shippedDate > o.requiredDate THEN o.orderNumber 
    END) as missed_required_date,
    COUNT(DISTINCT CASE 
        WHEN od.quantityOrdered > p.quantityInStock THEN o.orderNumber 
    END) as potential_stock_issues -- ie if orders are more than current stock
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN products p ON od.productCode = p.productCode
WHERE o.shippedDate IS NOT NULL
GROUP BY p.warehouseCode
ORDER BY late_shipments DESC; -- highest on top
