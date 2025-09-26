-- Fahim Tanvir
--Group_1045_4
-- CSCI-331
-- HW3
-- intro: These are 10 theories using stuff I learned in chapters 3 using multi-join tables.

/*Include this or some of the queries won’t work*/
USE WideWorldImporters;
GO

-- 1.)
/*This is just using concatenation to find all the users, as a way to audit everyone affiliated with the company. Main purpose of this is mainly for checking how many employees in the company and their designation.
  Main purpose of this in terms of the assignment is to show the transition from chapter 2 material with chapter 3, as a lot of the next propositions and queries shown here will use the same concept but at a bigger scale*/
-- Find all employees
SELECT PersonID,
CONCAT(PreferredName, ' ,', FullName) AS USERS
FROM Application.People
WHERE
IsEmployee = 1;

-- 2.)
/*This is to create duo partnerships between workers by using a self- join to match employee ids, this would help managers assign partner roles for groups doing certain tasks by giving each member a choice for their partner. Query is designed so an employee doesn’t have themselves as an option using the != or not equal to.*/
SELECT
A.FullName AS PartnerA,
B.FullName AS PartnerBChoices
FROM Application.People AS A
JOIN Application.People AS B ON B.PersonID != A.PersonID;


-- 3.)
/*This one is meant to calculate employee sales performance based on the number of orders or commission they made. This was done through an inner join which links the sales people and the orders through their respective tables and records. Purpose of this is to track performance, which management would definitely look at and consider.*/
SELECT
P.FullName AS Salesperson,
COUNT(O.OrderID) AS NumberOfOrders
FROM Application.People AS P
LEFT JOIN Sales. Orders AS O ON O.SalespersonPersonID = P.PersonID
WHERE P.IsEmployee = 1
GROUP BY P.FullName
ORDER BY NumberOfOrders DESC;




-- 4)
/*This is one meant to just check inventory using the tables for orders and stock items. This is similar to something from the previous homework, just expanded upon by using information that isn’t limited to a specific single table.*/

SELECT S.StockItemName,
OL.Quantity,
OL.UnitPrice
FROM Sales.OrderLines AS OL
JOIN Warehouse. StockItems AS S ON OL.StockItemID = S.StockItemID

--5.)
/*This is meant to track payments and transactions methods, using a cross join between those respective tables. This would help with keeping track of invoices.*/
SELECT
PT.PaymentMethodID,
PT.PaymentMethodName,
TT.TransactionTypeName
FROM Application.PaymentMethods AS PT
CROSS JOIN Application.TransactionTypes AS TT;


--6.)
/* This also would help with keeping track of invoices. Using a join between the following tables, this is used to track cities and states, which can help with locations for orders and deliveries.  */
SELECT 
C.CityName,
0.OrderID,
0.OrderDate
FROM Sales.Orders AS O
JOIN Application.Cities AS C
ON O.OrderId = C.CityID
ORDER BY
C.CityName,
O.OrderDate;

--7.)
/* This query is meant to check and audit regarding customers and orders. Can help keep track of company consumerbase along with delivery invoices. This is done through a left order join, which will match customers with their orders using IDs*/

SELECT C.CustomerName, O.OrderID
FROM Sales.Customers AS C
LEFT OUTER JOIN Sales.Orders AS O ON C.CustomerID = O.CustomerID;


-- 8.)
/* Similar to last query, this one is used to check employees that haven’t made a sale at all. This would be used to check employee performance. This is done by a join between the sales people table and the orders one respectively. */

SELECT P.FullName, O.OrderID
FROM Application.People AS P
LEFT OUTER JOIN Sales.Orders AS O ON P.PersonID = O.SalespersonPersonID
WHERE O.SalespersonPersonID IS NULL AND P.IsEmployee = 1;

--9.)
/*Match supplies and items to help keep track of records within the company warehouse*/
SELECT
S.StockItemName,
P.SupplierName
FROM Warehouse. StockItems AS S
INNER JOIN Purchasing. Suppliers AS P ON S.SupplierID = P.SupplierID
ORDER BY
S.StockItemName;



--10
/*This one checks all the items related to T-shirts using a series of right joins with the warehouse. CTG is short for category by the way.*/
SELECT S.StockItemName, SC.StockGroupName
FROM Warehouse. StockItems AS S
RIGHT JOIN Warehouse. StockItemStockGroups AS CTG ON S.StockItemID = CTG.StockItemID
RIGHT JOIN Warehouse.StockGroups AS SC ON CTG.StockGroupID = SC.StockGroupID
WHERE
SC.StockGroupName = 'T-Shirts';

