USE WideWorldImporters;

-- Proposition 1: Return all customers and their orders, including customers who have no orders
/* What it does:
 * Shows every customer and, when they exist, the orders they placed. 
 * Customers with no orders still appear with blank (NULL) order info.*/

SELECT c.CustomerID, c.CustomerName, o.OrderID, o.OrderDate
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
    ON c.CustomerID = o.CustomerID;

-- Proposition 2: Find all customers who never placed an order
/* What it does:
 Lists only customers who have never placed an order.*/

SELECT c.CustomerID, c.CustomerName
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

-- Proposition 3: Return each order with the employee (salesperson) who handled it
/* What it does:
 Connects each order to the employee (salesperson) responsible for it.*/

SELECT 
    o.OrderID, 
    o.OrderDate, 
    e.PersonID      AS EmployeeID, 
    e.FullName      AS EmployeeName
FROM Sales.Orders AS o
INNER JOIN Application.People AS e
    ON o.SalespersonPersonID = e.PersonID
    
 -- Proposition 4: List all products with the supplier who provides them
 /* What it does:
 Lists each stock item with the supplier who provides it.*/
    
SELECT p.StockItemID, p.StockItemName, s.SupplierID, s.SupplierName
FROM Warehouse.StockItems AS p
INNER JOIN Purchasing.Suppliers AS s
    ON p.SupplierID = s.SupplierID;

 -- Proposition 5: Find total number of orders per customer
/* What it does:
 Counts how many orders each customer has placed.*/

SELECT c.CustomerID, c.CustomerName, COUNT(o.OrderID) AS NumOrders
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName;

-- Proposition 6: Return orders placed on February 12, 2016 with their customers
/* What it does:
 Returns all orders placed on 2016-02-12 with their customers. */
SELECT c.CustomerID, c.CustomerName, o.OrderID, o.OrderDate
FROM Sales.Customers AS c
INNER JOIN Sales.Orders AS o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderDate = '2016-02-12';

-- Proposition 7: Show all customers and whether they placed an order on Feb 12, 2016
/* What it does:
 Lists every customer with a Yes/No flag indicating whether they ordered on 2016-02-12.*/
SELECT c.CustomerID, c.CustomerName,
       CASE WHEN EXISTS (
            SELECT 1
            FROM Sales.Orders AS o
            WHERE o.CustomerID = c.CustomerID
              AND o.OrderDate = '2016-02-12')
            THEN 'Yes' ELSE 'No' END AS HasOrderOn20160212
FROM Sales.Customers AS c;

-- Proposition 8: Show each order with its customer and ordered products
/* What it does:
 Displays each order’s customer and the specific products and quantities on that order—one row per line item. */
SELECT o.OrderID, c.CustomerName, od.StockItemID, od.Quantity
FROM Sales.Orders AS o
INNER JOIN Sales.Customers AS c
    ON o.CustomerID = c.CustomerID
INNER JOIN Sales.OrderLines AS od
    ON o.OrderID = od.OrderID;

-- Proposition 9: Find pairs of employees without duplicates
/* What it does:
 Generates every unique pair of employees without duplicates or self-pairs 
 (“Alice–Bob” appears once; “Bob–Alice” is suppressed).*/

SELECT 
    e1.PersonID AS Emp1, 
    e1.FullName AS Emp1Name,
    e2.PersonID AS Emp2, 
    e2.FullName AS Emp2Name
FROM Application.People AS e1
INNER JOIN Application.People AS e2
    ON e1.PersonID < e2.PersonID
WHERE e1.IsEmployee = 1
  AND e2.IsEmployee = 1;

-- Proposition 10: List all suppliers and their products, even if supplier has none
/* What it does:
 Lists all suppliers, and, when present, the products they supply. 
 Suppliers with no products still show up with blank product fields.*/

SELECT s.SupplierID, s.SupplierName, p.StockItemID, p.StockItemName
FROM Purchasing.Suppliers AS s
LEFT JOIN Warehouse.StockItems AS p
    ON s.SupplierID = p.SupplierID;