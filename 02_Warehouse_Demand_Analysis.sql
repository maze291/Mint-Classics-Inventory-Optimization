-- Calculate demand and stock for high-demand products in specific warehouses
WITH HighDemandProducts AS (
    SELECT 
        p.productCode, 
        p.productName, 
        SUM(od.quantityOrdered) AS total_quantity_sold 
    FROM 
        products p
    JOIN 
        orderdetails od ON p.productCode = od.productCode
    GROUP BY 
        p.productCode, 
        p.productName
    ORDER BY 
        total_quantity_sold DESC
    LIMIT 100
) -- using the highest demand products' code for this
SELECT 
    w.warehouseCode, 
    w.warehouseName, 
    p.productCode, 
    p.productName,
    SUM(od.quantityOrdered) AS quantity_sold_in_warehouse
FROM 
    warehouses w
JOIN 
    products p ON w.warehouseCode = p.warehouseCode
JOIN 
    orderdetails od ON p.productCode = od.productCode
WHERE 
    p.productCode IN (SELECT productCode FROM HighDemandProducts) -- filtering to show only the highest in demand product codes
GROUP BY 
    w.warehouseCode, 
    w.warehouseName, 
    p.productCode
ORDER BY 
    quantity_sold_in_warehouse DESC;
