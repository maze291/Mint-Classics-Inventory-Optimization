-- Track revenue metrics and find order value patterns
WITH OrderProcessing AS (
    SELECT 
        p.warehouseCode,
        COUNT(DISTINCT o.orderNumber) as total_orders,
        COUNT(DISTINCT p.productCode) as unique_products,
        SUM(od.quantityOrdered) as total_items_shipped,
        SUM(od.quantityOrdered * od.priceEach) as total_revenue
    FROM products p
    JOIN orderdetails od ON p.productCode = od.productCode
    JOIN orders o ON od.orderNumber = o.orderNumber
    GROUP BY p.warehouseCode
)
SELECT 
    op.warehouseCode,
    w.warehouseName,
    op.total_orders,
    op.total_revenue,
    op.total_items_shipped,
    (op.total_revenue / NULLIF(op.total_orders, 0)) as revenue_per_order,
    (op.total_items_shipped / NULLIF(op.total_orders, 0)) as items_per_order,
    (op.total_revenue / NULLIF(op.total_items_shipped, 0)) as revenue_per_item
FROM OrderProcessing op
JOIN warehouses w ON op.warehouseCode = w.warehouseCode
ORDER BY op.total_revenue DESC;
