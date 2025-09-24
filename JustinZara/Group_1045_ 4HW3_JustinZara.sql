USE WideWorldImporters;
--Proposition 1: List out the total amount of orders from each customer, sorted from highest to lowest.

SELECT c.CustomerID, c.CustomerName, count(o.OrderID) as countOfOrders
FROM Sales.Customers as c
LEFT OUTER JOIN Sales.Orders as o
ON c.customerID = o.customerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY countOfOrders DESC;

--The resulting query left outer  joins the tables "Customers" and "Orders", and returns all the rows from the Customer table and some of the rows from the orders table. The result outputs the customer id, customer name, and the number of orders from each customer. The output is also ordered from highest number of orders to lowest.
--This query can be used by businesses to identify which customers make the most orders.

--Proposition 2: List out for each customer, their ID for their order, the delivery method of their order, and the expected Days from order date until delivery date.

SELECT o. OrderID, c.CustomerID, c.DeliveryMethodID,DATEDIFF(DAY,  o.OrderDate, o.ExpectedDeliveryDate) as DaysUntilExpectedDelivery
FROM Sales.Customers as c
INNER JOIN Sales.Orders as o
on c.CustomerID = o.CustomerID
ORDER BY c.CustomerID;

--The resulting query inner joins the tables "Customers" and "Orders", and returns rows that have matching values in both tables. The result outputs the customer ID, the customer's delivery method, and the number of days until delivery is expected. Also the output is ordererd by customer ID.
--This proposition can be usedful for identifying the efficiency of each delivery method.

--Proposition 3: Listing out the order date and expected delivery date for customer with an ID of 1.

SELECT o.OrderDate, o.ExpectedDeliveryDate, c.CustomerName, c.CustomerID
FROM Sales.Customers AS c
INNER JOIN Sales.Orders AS o 
ON c.CustomerID = o.CustomerID
WHERE c.CustomerID = 1

--The resulting query inner joins the tables "Customers", and "Orders", outputs the order date, the expected delivery date,  customer name, and the customer ID. The output only returns rows where the Customer ID is equal to 1.
--This can be useful for tracking all the orders for specific customers, and seeing when they are expected to arrive.

--Proposition 4: list out all the delivery address and invoice date for each customer during january 1, 2013.

SELECT DISTINCT i.InvoiceDate, i.BillToCustomerID, c.CustomerName,  c.DeliveryAddressLine1, c.DeliveryAddressLine2
FROM Sales.Customers AS c
INNER JOIN Sales.Invoices AS i 
ON c.CustomerID = i.BillToCustomerID
WHERE i.InvoiceDate = '2013-01-01';

--The resulting query inner joins the tables Customers and Invoices, and outputs the date of invoice, the bill to customer ID, the customer name, and the delivery address of the customer. The output only returns rows where the invoice date is January 1, 2013.
--This can be useful for retrieving information about a customer's invoice on a given date.

--Proposition 5: List out each order that has no listed delivery method in their invoice.

SELECT o.OrderID, i.DeliveryMethodID, o.DeliveryInstructions
FROM Sales.Invoices AS i
FULL OUTER JOIN Sales.Orders AS o 
ON i.OrderID = o.OrderID
WHERE i.DeliveryMethodID IS NULL;

--The resulting query full outer joins the tables Invoices and Orders, and outputs the Order ID, the Delivery method, and the Delivery Instructions. The output only returns rows where the delivery method is null.
--This query can be useful for identifying orders that dont have a specified delivery method.

--Proposition 6: Get the category name of each supplier, and their method of delivery

SELECT s.SupplierID, s.SupplierName, sc.SupplierCategoryName,  s.DeliveryMethodID, dm.DeliveryMethodName
FROM Purchasing.Suppliers AS s
INNER JOIN Application.DeliveryMethods AS dm 
ON s.DeliveryMethodID = dm.DeliveryMethodID
INNER JOIN Purchasing.SupplierCategories AS sc 
ON s.SupplierCategoryID = sc.SupplierCategoryID

--The resulting query inner joins Suppliers with DeliveryMethods, and DeliveryMethods with Supplier categories. The result outputs the supplier ID and supplier name, the category name of the supplier, and the  delivery method's name and ID.
--This query can be used for identifying and the type of goods they supply, and how each supplier delivers their goods,

--Proposition 7: Get the time of transaction for each stock item, forthe first 10 purchase orders.

SELECT sit.TransactionOccurredWhen, si.StockItemName, si.StockItemID, sit.PurchaseOrderID
FROM Warehouse.StockItems AS si
INNER JOIN Warehouse.StockItemTransactions AS sit 
ON si.StockItemID = sit.StockItemID
WHERE sit.PurchaseOrderID IS NOT NULL AND PurchaseOrderID < 11;

--The resulting query inner  joins the table  "Stock Items" with "Stock Item Transactions". The result outputs the time that the transaction occured, the stock item's name and id, and the ID of the purchase order. The output filters out rows where the purchase order Id is greater than 11, or is null.
--This query can be used to identify the time of transaction for specific items and orders that have a specific ID.

--Proposition 8: list out the transaction quantity of each stock item that has a quantity of less than 25, along with their stock item ID, in descending order of quantity.

SELECT sit.Quantity, si.StockItemName, si.StockItemID    
FROM Warehouse.StockItems AS si
LEFT OUTER JOIN Warehouse.StockItemTransactions AS sit 
ON si.StockItemID = sit.StockItemID
WHERE sit.Quantity > 0 AND sit.Quantity < 25
ORDER BY sit.Quantity DESC;

--The resulting query left outer joins the tables Stock Items with Stock item Transactions. The result outputs the quantity of the stock item transaction, the stock item's name and ID. The rows are ordered from greatest quantity to least.
--This query can be used to check which stock item has a specific number transaction quantities.

--Proposition 9: Get the package type name for each stock item.

SELECT si.StockItemName, pt.PackageTypeName
FROM Warehouse.StockItems AS si
FULL OUTER JOIN Warehouse.PackageTypes AS pt 
ON si.OuterPackageID = pt.PackageTypeID
ORDER BY pt.PackageTypeName;

--The resulting query full outer joins the tables Stock items  andPackage Types. The result outputs the stock item name, and the package type name. The rows are ordered by package type name.
--This query can be used to identify what packaging is needed for each stock item

--Proposition 10: Get the transaction amount of each customer on the date 01-02-2013, in ascending order.

SELECT ct.TransactionDate, c.CustomerID, c.CustomerName, ct.TransactionAmount
FROM Sales.CustomerTransactions AS ct
INNER JOIN Sales.Customers AS c 
ON ct.CustomerID = c.CustomerID
WHERE ct.TransactionDate = '2013-01-02'
ORDER BY ct.TransactionAmount DESC;

--The resulting query inner joins the table Customer Transactions with Customers. The result outputs the transaction date, the customer id, the customer name, and the transaction amount. The rows are ordered from greatest transaction amount to least.
--This query can be used to keep track the transaction amount of each customer on specific dates.




