-- Data Produk
WITH main_cte AS (
    SELECT 
        t2.orderDate, t2.orderNumber, 
        t1.customerNumber,t1.customerName,t1.country,
        t4.productLine, productName,quantityOrdered,
        priceEach, buyPrice,
        priceEach*quantityOrdered as Sales, 
buyPrice*quantityOrdered as Cost
    FROM customers t1 
    INNER JOIN orders t2 ON t1.customerNumber = t2.customerNumber 
    INNER JOIN orderdetails t3 ON t2.orderNumber = t3.orderNumber 
    INNER JOIN products t4 ON t3.productCode = t4.productCode
    group by t2.orderDate, t2.orderNumber,
        t1.customerNumber,
        t1.customerName,
        t1.country,
        t4.productLine,productName,quantityOrdered, priceEach, buyPrice
) 
SELECT *,
Sales-Cost as Profit,
CONCAT(DENSE_RANK() OVER(PARTITION BY customerNumber ORDER BY orderDate)) AS purchaseNumber
FROM main_cte 
ORDER BY orderDate;

