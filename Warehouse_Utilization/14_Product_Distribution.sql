-- Identify concentration risks, products with high/low demand and for inventory management
WITH ProductMetrics AS (
    SELECT 
        p.warehouseCode,
        p.productLine,
        COUNT(DISTINCT p.productCode) as unique_products,
        SUM(p.quantityInStock) as total_stock,
        SUM(p.quantityInStock * p.buyPrice) as inventory_value,
        COUNT(DISTINCT od.orderNumber) as number_of_orders
    FROM products p
    LEFT JOIN orderdetails od ON p.productCode = od.productCode
    GROUP BY p.warehouseCode, p.productLine
)
SELECT 
    warehouseCode,
    productLine,
    unique_products,
    total_stock,
    inventory_value,
    number_of_orders,
    (inventory_value / NULLIF(total_stock, 0)) as value_per_item,
    (number_of_orders / NULLIF(unique_products, 0)) as orders_per_product
FROM ProductMetrics
ORDER BY warehouseCode, inventory_value DESC;
