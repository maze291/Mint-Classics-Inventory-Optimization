-- Turnover by product line(a broader category than products) for best selling, revenue by category and efficiency in each product line
SELECT 
    pl.productLine,
    COUNT(DISTINCT p.productCode) as num_products,
    SUM(p.quantityInStock) as total_inventory,
    COALESCE(SUM(od.quantityOrdered), 0) as total_sold, -- NUll to 0 instead of NUll
    COALESCE(SUM(od.quantityOrdered * od.priceEach), 0) as total_revenue,
    CASE 
        WHEN SUM(p.quantityInStock) > 0 THEN 
            COALESCE(SUM(od.quantityOrdered), 0) / SUM(p.quantityInStock)
        ELSE 0 
    END as line_turnover_rate
FROM productlines pl
LEFT JOIN products p ON pl.productLine = p.productLine
LEFT JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY pl.productLine
ORDER BY total_revenue DESC;
