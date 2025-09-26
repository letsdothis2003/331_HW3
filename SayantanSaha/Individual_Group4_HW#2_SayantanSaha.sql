/* 1. Orders with respective customer name and date (INNER JOIN) */
SELECT o.OrderID, c.CustomerName, o.OrderDate
FROM WideWorldImporters.Sales.Orders AS o
INNER JOIN WideWorldImporters.Sales.Customers AS c
  ON c.CustomerID = o.CustomerID
ORDER BY o.OrderDate DESC;

/* 2. Invoices with respective salesperson (LEFT JOIN) */
SELECT i.InvoiceID, p.FullName AS Salesperson, i.InvoiceDate
FROM WideWorldImporters.Sales.Invoices AS i
LEFT JOIN WideWorldImporters.Application.People AS p
  ON p.PersonID = i.SalespersonPersonID
ORDER BY i.InvoiceDate DESC;

/* 3. Invoice lines with their item names (CROSS JOIN + WHERE for match) */
SELECT il.InvoiceID, si.StockItemName, il.Quantity, il.UnitPrice, il.ExtendedPrice
FROM WideWorldImporters.Sales.InvoiceLines AS il
CROSS JOIN WideWorldImporters.Warehouse.StockItems AS si
WHERE si.StockItemID = il.StockItemID
ORDER BY il.InvoiceID, si.StockItemName;

/* 4. Stock items with their suppliers (FULL OUTER JOIN) */
SELECT si.StockItemID, si.StockItemName, s.SupplierName, si.UnitPrice
FROM WideWorldImporters.Warehouse.StockItems AS si
FULL OUTER JOIN WideWorldImporters.Purchasing.Suppliers AS s
  ON s.SupplierID = si.SupplierID
ORDER BY s.SupplierName, si.StockItemName;

/* 5. Customers with their delivery city (LEFT JOIN) */
SELECT c.CustomerID, c.CustomerName, ci.CityName
FROM WideWorldImporters.Sales.Customers AS c
LEFT JOIN WideWorldImporters.Application.Cities AS ci
  ON ci.CityID = c.DeliveryCityID
ORDER BY ci.CityName, c.CustomerName;

/* 6. Invoices with respective delivery method (RIGHT JOIN) */
SELECT i.InvoiceID, dm.DeliveryMethodName, i.InvoiceDate
FROM WideWorldImporters.Application.DeliveryMethods AS dm
RIGHT JOIN WideWorldImporters.Sales.Invoices AS i
  ON dm.DeliveryMethodID = i.DeliveryMethodID
ORDER BY i.InvoiceDate DESC;

/* 7. Orders with picker name and date (INNER JOIN) */
SELECT o.OrderID, p.FullName AS PickedBy, o.PickingCompletedWhen
FROM WideWorldImporters.Sales.Orders AS o
INNER JOIN WideWorldImporters.Application.People AS p
  ON p.PersonID = o.PickedByPersonID
WHERE o.PickingCompletedWhen IS NOT NULL
ORDER BY o.PickingCompletedWhen DESC;

/* 8. Order count by salesperson (SELF JOIN + INNER JOIN) */
SELECT p.FullName AS Salesperson, COUNT(*) AS OrdersCount
FROM WideWorldImporters.Application.People AS p
INNER JOIN WideWorldImporters.Application.People AS p_self
  ON p_self.PersonID = p.PersonID   -- self-join (1:1) for demonstration
INNER JOIN WideWorldImporters.Sales.Orders AS o
  ON o.SalespersonPersonID = p.PersonID
GROUP BY p.FullName
ORDER BY OrdersCount DESC, Salesperson;

/* 9. Product revenue (multi-join across three tables) */
SELECT si.StockItemName, SUM(il.ExtendedPrice) AS TotalRevenue
FROM WideWorldImporters.Sales.InvoiceLines AS il
INNER JOIN WideWorldImporters.Warehouse.StockItems AS si
  ON si.StockItemID = il.StockItemID
INNER JOIN WideWorldImporters.Sales.Invoices AS i
  ON i.InvoiceID = il.InvoiceID
GROUP BY si.StockItemName
ORDER BY TotalRevenue DESC, si.StockItemName;

/* 10. Customers with respective category (RIGHT JOIN) */
SELECT c.CustomerID, c.CustomerName, cc.CustomerCategoryName
FROM WideWorldImporters.Sales.CustomerCategories AS cc
RIGHT JOIN WideWorldImporters.Sales.Customers AS c
  ON cc.CustomerCategoryID = c.CustomerCategoryID
ORDER BY c.CustomerName;