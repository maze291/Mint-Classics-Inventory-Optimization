-- Checking the capacity utilization of each storage facility
WITH WarehouseUsage AS (
   SELECT 
       w.warehouseCode,
       w.warehouseName,
       w.warehousePctCap,
       SUM(p.quantityInStock) as total_items,
       COUNT(DISTINCT p.productCode) as unique_products,
       SUM(p.quantityInStock * p.buyPrice) as inventory_value
   FROM warehouses w
   LEFT JOIN products p ON w.warehouseCode = p.warehouseCode
   GROUP BY w.warehouseCode, w.warehouseName, w.warehousePctCap
)
SELECT
   warehouseCode,
   warehouseName,
   warehousePctCap as total_capacity_pct,
   total_items as current_stock,
   warehousePctCap as current_vs_capacity_pct, -- for readability
   unique_products,
   inventory_value,
   (inventory_value / NULLIF(total_items, 0)) as value_per_item -- null if avoids division by 0 if we have no items in the warehouses' stock
FROM WarehouseUsage
ORDER BY current_vs_capacity_pct DESC;
