-- Part 1

-- Hard Code --> در کویری هاُ به کدها معنی بدهیم
/*Select P.ProductID, P.ProductName, P.CategoryID, CASE
                                                 When P.CategoryID = 1 Then 'Beverages'
												 When P.CategoryID = 2 Then 'X'
												 When P.CategoryID = 3 Then 'A'
												 When P.CategoryID = 4 Then 'B'
												 When P.CategoryID = 5 Then 'C'
												 When P.CategoryID = 6 Then 'D'
												 When P.CategoryID = 7 Then 'Y'
												 When P.CategoryID = 8 Then 'Z'
												 Else 'Unknown'
												 End 
												 As [Category_Name]
												 

from Products P */

-- A simpler way to do this ->

Select P.ProductID, P.ProductName, P.CategoryID, CASE P.CategoryID
                                                 When  1 Then 'Beverages'
												 When  2 Then 'X'
												 When  3 Then 'A'
												 When  4 Then 'B'
												 When  5 Then 'C'
												 When  6 Then 'D'
												 When  7 Then 'Y'
												 When  8 Then 'Z'
												 Else 'Unknown'
												 End 
												 As [Category_Name]
												 

from Products P


-- FROM <Table><View><DerivedTable><CTE><Table-Valued Functions><Synonym>

/* نام اشیا از ۴ قسمت تشکیل شده است */
-- <ServerName>.<DatabaseName>.<SchemaName>.<ObjectName>
-- Defalut server name is the server to whom we are logged-in. To find that server type:
Select @@SERVERNAME

Use NORTHWND
Go
Select *
From [Mahyar].NorthWnd.dbo.Products

-- Linked Server --> To report a query from a server to whom we are not logged-in, we must create a linked server for that server 
--(Server Objects -> Linked Servers -> Genral and security (To determine who are allowed to use the server) + Options : RPC & RPC --> TRUE (To use Stored Procedures remotely))


-- Distributed/Multi-Server Query

--PolyBase --> External Table

-- OpenQuery?


-- Part 2
Use NORTHWND
Select * from dbo.Products

Use AdventureWorks2019
Select * from Production.Product

--VIEW --> A saved select query 

Use NORTHWND
Go
Create OR Alter VIEW V_USCustomers
AS
Select * From Employees E
Where E.Country = 'USA'
Go
-- In View, there is no "Order By" except by "TOP" + all columns must have a name like a Table
-- To edit a view --> Script View as --> ALter To -> New Query Editor Window
-- Advantages -> 1- To limit access of some users to some rows or columns of a table (Right click on the view --> Properties
--Permissions 2- Using a useful queries for more than once

--Select * from V_USCustomers

Go

create or alter view V_Active_Customrs
as
select C.ContactName, C.City, C.[Address] from Customers C
where CustomerID in (select CustomerID from orders 
						where DATEDIFF (day, OrderDate, getDate()) < 10000)
Go

select * from V_Active_Customrs

-- Exercise: How to find active customers (< 180) at that time?

Declare @maxdate nvarchar(50)
set @maxdate = (select max(OrderDate) from dbo.Orders);
--Select @maxdate

with
customerorders as (select  Customers.ContactName, Customers.Country, Orders.OrderID, Orders.OrderDate
from Customers inner join Orders
on Customers.CustomerID = Orders.CustomerID)

select ContactName, max(OrderDate) As [Max_date] from customerorders
where DateDiff(day, OrderDate, @maxdate) < 180 And Country = 'Mexico'
Group BY ContactName
order by [Max_date] Desc


select * from Customers

select max(OrderDate) from orders
Select * from Customers
-- Derived Table --> Jadvale Majazi --> A query which is written in front of from in "Parenthesis" + For Queries which is going to be used not much (one time)
Select * from 
(Select C.CompanyName,C.ContactName,C.City From Customers C where Country = 'Sweden') 
AS Sweden_Customers_tbl


Select C.ContactName,C.City,C.[Address], O.OrderID
from Customers C INNER JOIN Orders O
ON C.CustomerID = O.CustomerID
Where Year(O.OrderDate) = 1996 And C.Country = 'Mexico'



-- Exercise -> How to determine distinct customers and their last orders?

with
customerorders as (select Customers.CustomerID, Customers.ContactName, Customers.Country, Orders.OrderID, Orders.OrderDate
from Customers inner join Orders
on Customers.CustomerID = Orders.CustomerID)

select CustomerID, ContactName, Country, max(OrderDate) as maxorderdate
from customerorders
group by CustomerID, ContactName, Country
order by CustomerID ASC, max(OrderDate) DESC

-- Include Actual Execution Plan --> To compare two queries in terms of speed, Optimization and Cost --> query optimization 


-- CTE --> Common Table Expression ->  afzayeshe khanayi nesbat be jadval majazi--> haman Derived tble --> Starts by "WITH" clause and is used in the main query
WITH 
    MEX AS (Select * from Customers where Country = 'Mexico'),
	Ords9697 AS (Select * from Orders where Year(OrderDate) = 1996 Or Year(OrderDate) = 1997)

	Select * 
	from MEX INNER JOIN Ords9697 
	ON MEX.CustomerID = Ords9697.CustomerID


WITH 
    P1 As (Select * from Products where CategoryID = 2),
	P2 AS (select * from P1 where unitprice <= 20)
Select * 
From P2

-- Exercise --> what is the 5th cheap product in terms of price( with derived table and cte do it!)
-- Derived Table
Select Top 1 *
From (Select Top 5 *
      from Products
	  order by UnitPrice ASC
	  ) As T5
Order By UnitPrice Desc
-- CTE
WITH 
   T5 As (Select Top 5 * from Products order by UnitPrice ASC)
Select Top 1 * 
from T5
order by UnitPrice Desc
-- With Ranking

-- Exercise -> Do it with Ranking


-- Recursive CTE
