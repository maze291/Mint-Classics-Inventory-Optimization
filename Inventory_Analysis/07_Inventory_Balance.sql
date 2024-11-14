-- Find how evenly distributed inventory and inventory value is in each warehouse, along with finding product line distribution.
WITH WarehouseMetrics AS (
    SELECT 
        w.warehouseCode,
        w.warehouseName,
        COUNT(DISTINCT p.productCode) as unique_products,
        SUM(p.quantityInStock) as total_inventory,
        SUM(p.quantityInStock * p.buyPrice) as inventory_value,
        COUNT(DISTINCT p.productLine) as number_of_product_lines
    FROM warehouses w
    LEFT JOIN products p ON w.warehouseCode = p.warehouseCode
    GROUP BY w.warehouseCode, w.warehouseName
)
SELECT 
    *,
    total_inventory * 100.0 / (SELECT SUM(total_inventory) FROM WarehouseMetrics) as inventory_percentage,
    inventory_value * 100.0 / (SELECT SUM(inventory_value) FROM WarehouseMetrics) as value_percentage
FROM WarehouseMetrics
ORDER BY inventory_value DESC;
