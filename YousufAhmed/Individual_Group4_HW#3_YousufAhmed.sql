-- Query 1: Highest priced invoices with customer names and phone numbers
SELECT
	ct.InvoiceID,
	(ct.AmountExcludingTax + ct.TaxAmount) AS Total,
	c.CustomerName,
	c.PhoneNumber
FROM Sales.CustomerTransactions ct
INNER JOIN Sales.Customers c
    ON ct.CustomerID = c.CustomerID
WHERE ct.InvoiceID IS NOT NULL
ORDER BY (ct.AmountExcludingTax + ct.TaxAmount) DESC;

-- Query 2: All customers with their latest placed order date
SELECT
	c.CustomerID,
	c.CustomerName,
	MAX(i.InvoiceDate) AS LastInvoiceDate
FROM
	Sales.Customers c
LEFT JOIN Sales.Invoices i
  ON
	c.CustomerID = i.CustomerID
GROUP BY
	c.CustomerID,
	c.CustomerName;



-- Query 3: Filter for invoices without customers
SELECT
	i.InvoiceID,
	i.InvoiceDate
FROM
	Sales.Customers c
RIGHT JOIN Sales.Invoices i
  ON
	c.CustomerID = i.CustomerID
WHERE
	c.CustomerID IS NULL;


-- Query 4: Customers who haven't placed an order on Black Friday
SELECT
	c.CustomerID,
	c.CustomerName,
	c.FaxNumber 
FROM
	Sales.Customers c
LEFT JOIN Sales.CustomerTransactions ct
    ON
	c.CustomerID = ct.CustomerID
	AND ct.TransactionDate = '2015-11-27'
WHERE
	ct.TransactionDate IS NULL;


-- Query 5: Top 10 largest transactions, with some customer info
SELECT TOP 10
    ct.CustomerTransactionID ,
    ct.CustomerID,
    ct.TransactionAmount,
    c.CustomerName,
    c.PhoneNumber,
    c.DeliveryPostalCode 
FROM Sales.CustomerTransactions AS ct
LEFT JOIN Sales.Customers c
  ON
	ct.CustomerID = c.CustomerID
ORDER BY ct.TransactionAmount DESC;


-- Query 6: Most frequently sold stock items with names
SELECT TOP 20
    il.StockItemID,
    si.StockItemName,
    SUM(il.Quantity) AS TotalQuantitySold
FROM Sales.InvoiceLines il
LEFT JOIN Warehouse.StockItems si
  ON il.StockItemID = si.StockItemID
GROUP BY il.StockItemID, si.StockItemName
ORDER BY TotalQuantitySold DESC;


-- Query 7: See number of customers per city
SELECT
    c.PostalCityID,
    ci.CityName,
    COUNT(c.CustomerID) AS NumberOfCustomers
FROM Sales.Customers c
INNER JOIN Application.Cities ci
    ON c.PostalCityID = ci.CityID
GROUP BY c.PostalCityID, ci.CityName
ORDER BY NumberOfCustomers DESC;



-- Query 8: Customers with invoices over $25,000
SELECT 
    c.CustomerID,
    c.CustomerName,
    i.InvoiceID,
    i.InvoiceDate,
    SUM(il.Quantity * il.UnitPrice) AS InvoiceAmount
FROM Sales.Customers c
INNER JOIN Sales.Invoices i
    ON c.CustomerID = i.CustomerID
INNER JOIN Sales.InvoiceLines il
    ON i.InvoiceID = il.InvoiceID
GROUP BY c.CustomerID, c.CustomerName, i.InvoiceID, i.InvoiceDate
HAVING SUM(il.Quantity * il.UnitPrice) > 25000
ORDER BY InvoiceAmount DESC;

-- Query 9: Suppliers with No orders in 2016
SELECT s.SupplierID, s.SupplierName
FROM Purchasing.Suppliers s
LEFT JOIN Purchasing.PurchaseOrders po
    ON s.SupplierID = po.SupplierID
   AND YEAR(po.OrderDate) = 2016
WHERE po.PurchaseOrderID IS NULL;

-- Query 10 : Monthly sales based on revenue
SELECT 
    YEAR(i.InvoiceDate) AS Year,
    MONTH(i.InvoiceDate) AS Month,
    SUM(il.Quantity * il.UnitPrice) AS MonthlySales
FROM Sales.Invoices i
INNER JOIN Sales.InvoiceLines il
    ON i.InvoiceID = il.InvoiceID
WHERE YEAR(i.InvoiceDate) = 2016
GROUP BY YEAR(i.InvoiceDate), MONTH(i.InvoiceDate)
ORDER BY Year, Month;

