-- Identifying products and units that need redistribution, backup locations of products(reducing risk during redistribution), and which warehouses are high-priority based on their inventory value
WITH ProductRedistribution AS (
    SELECT 
        p1.warehouseCode as current_warehouse,
        COUNT(DISTINCT p1.productCode) as products_to_move,
        SUM(p1.quantityInStock) as units_to_move,
        SUM(p1.quantityInStock * p1.buyPrice) as value_to_move, -- total value of all products in the warehouse
        COUNT(DISTINCT CASE WHEN p2.productCode IS NOT NULL THEN p1.productCode END) as products_with_alternate_location, --P2 product is null(look at left join) only when p1 is not available at another location
        AVG(w.warehousePctCap) as current_capacity_used
    FROM products p1
    LEFT JOIN products p2 ON p1.productCode = p2.productCode AND p1.warehouseCode != p2.warehouseCode -- define p2 as a product in another warehouse and not the current and set condition for p2 null
    JOIN warehouses w ON p1.warehouseCode = w.warehouseCode -- joins p1 warehouse with warehouse table conditioned on the code(because warehouse table contains information not necessarily in products table(like warehouse Pct cap)).
    GROUP BY p1.warehouseCode
)
SELECT 
    *,
    (products_with_alternate_location * 100.0 / NULLIF(products_to_move, 0)) as pct_products_with_backup -- percentage of products(in the current warehouse) that have a backup location(To evaluate how many products can be redistributed without risk).
FROM ProductRedistribution
ORDER BY value_to_move DESC;
