-- 04_Dead_Stock_Analysis.sql
-- Identifies products with no sales and their warehouse locations
WITH ProductSales AS (
    SELECT 
        p.productCode,
        p.productName,
        p.warehouseCode,
        p.quantityInStock,
        p.buyPrice,
        COALESCE(SUM(od.quantityOrdered), 0) as total_sold
    FROM products p
    LEFT JOIN orderdetails od ON p.productCode = od.productCode
    GROUP BY p.productCode, p.productName, p.warehouseCode, p.quantityInStock, p.buyPrice
) -- total quantity sold
SELECT 
    ps.warehouseCode,
    ps.productCode,
    ps.productName,
    ps.quantityInStock,
    ps.buyPrice,
    ps.quantityInStock * ps.buyPrice as tied_up_cost, 
    ps.total_sold
FROM ProductSales ps
WHERE ps.total_sold = 0
ORDER BY ps.tied_up_cost DESC; -- highest unsold cost
