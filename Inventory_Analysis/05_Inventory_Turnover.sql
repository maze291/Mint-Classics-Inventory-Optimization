-- Calculate and rank in descending order turnover rate within warehouses. Which indicates how fast products are sold
WITH ProductTurnover AS (
    SELECT 
        p.productCode,
        p.productName,
        p.warehouseCode,
        p.quantityInStock,
        COALESCE(SUM(od.quantityOrdered), 0) as total_sold,
        CASE 
            WHEN p.quantityInStock > 0 THEN 
                COALESCE(SUM(od.quantityOrdered), 0) / p.quantityInStock
            ELSE 0 
        END as turnover_rate
    FROM products p
    LEFT JOIN orderdetails od ON p.productCode = od.productCode
    GROUP BY p.productCode, p.productName, p.warehouseCode, p.quantityInStock
)
SELECT 
    warehouseCode,
    AVG(turnover_rate) as avg_turnover,
    COUNT(CASE WHEN turnover_rate < 0.5 THEN 1 END) as low_turnover_products,
    COUNT(CASE WHEN turnover_rate >= 0.5 AND turnover_rate < 1 THEN 1 END) as medium_turnover_products,
    COUNT(CASE WHEN turnover_rate >= 1 THEN 1 END) as high_turnover_products
FROM ProductTurnover
GROUP BY warehouseCode -- each warehouse only
ORDER BY avg_turnover DESC; -- highest first
