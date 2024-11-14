-- General Warehouse Metrics such As Total orders handled, Avg items per product, Avg items per order, Avg revenue per order and Avg processing time in days
WITH WarehouseMetrics AS (
    SELECT 
        p.warehouseCode,
        COUNT(DISTINCT o.orderNumber) as total_orders,
        COUNT(DISTINCT p.productCode) as products_handled,
        SUM(od.quantityOrdered) as items_shipped,
        SUM(od.quantityOrdered * od.priceEach) as revenue_generated,
        AVG(DATEDIFF(o.shippedDate, o.orderDate)) as avg_processing_time
    FROM products p
    JOIN orderdetails od ON p.productCode = od.productCode
    JOIN orders o ON od.orderNumber = o.orderNumber
    WHERE o.shippedDate IS NOT NULL
    GROUP BY p.warehouseCode
)
SELECT 
    warehouseCode,
    total_orders,
    items_shipped / NULLIF(products_handled, 0) as items_per_product,
    revenue_generated / NULLIF(total_orders, 0) as revenue_per_order,
    items_shipped / NULLIF(total_orders, 0) as items_per_order,
    avg_processing_time
FROM WarehouseMetrics
ORDER BY revenue_generated DESC;
