-- Identify top 5-10 highest-demand products across all storage facilities
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
    LIMIT 10  -- Adjusting based on available data
)
SELECT * FROM HighDemandProducts;
