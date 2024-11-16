-- Finds impact on shipping times if we close a warehouse
WITH WarehouseShipStats AS ( -- Common Table Expression to calculate shipping stats for each order
    SELECT 
        o.orderNumber,
        c.country,
        c.state,
        p.warehouseCode as current_warehouse, -- warehouse that fulfilled the order now
        DATEDIFF(o.shippedDate, o.orderDate) as current_ship_time, -- time taken in days to ship
        -- Subquery for getting the nearest warehouse by basic proximity (using country/state)
        (SELECT w2.warehouseCode 
         FROM products p2 
         JOIN warehouses w2 ON p2.warehouseCode = w2.warehouseCode
         WHERE p2.warehouseCode != p.warehouseCode -- excluding current warehouse
         AND EXISTS (SELECT 1 FROM products p3 WHERE p3.productCode = p.productCode AND p3.warehouseCode = w2.warehouseCode) -- make sure the alternate warehouse has the same product as current
         GROUP BY w2.warehouseCode
         ORDER BY w2.warehousePctCap ASC
         LIMIT 1) as alternate_warehouse -- limit to find the best alternate with lowest percentage of inventory capped.
    FROM orders o
    JOIN customers c ON o.customerNumber = c.customerNumber
    JOIN orderdetails od ON o.orderNumber = od.orderNumber
    JOIN products p ON od.productCode = p.productCode
    WHERE o.shippedDate IS NOT NULL -- only include orders already shipped
)
SELECT 
    current_warehouse,
    COUNT(DISTINCT orderNumber) as affected_orders,
    AVG(current_ship_time) as current_avg_shipping_time,
    -- Estimated impact assumes 20% longer shipping time with alternate warehouse
    AVG(current_ship_time * 1.2) as estimated_new_shipping_time,
    COUNT(DISTINCT CASE WHEN current_ship_time <= 1 THEN orderNumber END) as current_24hr_deliveries, -- count number of orders delivered <= 24hrs
    COUNT(DISTINCT CASE WHEN current_ship_time * 1.2 <= 1 THEN orderNumber END) as estimated_24hr_deliveries -- count number of orders deliverd from the alt. warehouse <= 24hrs
FROM WarehouseShipStats
GROUP BY current_warehouse
ORDER BY affected_orders DESC;
