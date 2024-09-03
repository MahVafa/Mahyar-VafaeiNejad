-- Part 1

-- GROUP BY --> It is used to categorize and aggregate

-- Aggregate Functions --> Count, Avg, min, max, sum, VAR, VARP, STDEV, STDEVP
--string_agg(<Exp>, seperator) from 2017,  --> hichkodoom "Null" ro pardazesh nemikonan

Select count(customerid) As Cust_count
from Customers
Where Country = 'UK' And Region IS Null

Select count(distinct(OrderID)) As Ord_count
from ORDERS
Where Year(OrderDate) = 1996


Select ShipCountry, count(distinct(OrderID)) As Ord_count
from ORDERS
Where Year(OrderDate) = 1996
Group By ShipCountry

Select * from Orders

Select * from Products

Select * from Customers

Select * from [Order Details]



Select P.CategoryID, sum(P.UnitsInStock) As inventory
from Products P
Where P.Discontinued = 0
Group By P.CategoryID


Select OD.OrderID, C.CustomerID, C.ContactName, C.Country, sum(OD.Quantity) As [Total_Boxes] , Sum(OD.UnitPrice * OD.Quantity) As Total_Sales 
from Orders [OR] INNER JOIN [Order Details] OD 
ON [OR].OrderID = OD.OrderID
INNER JOIN Customers C
ON [OR].CustomerID = C.CustomerID
Group BY OD.OrderID,  C.CustomerID, C.ContactName, C.Country
order by C.CustomerID



select * from orders
select * from [Order Details]
select * from [Order Details]


SELECT CONVERT(DECIMAL(10,1),Avg([UnitPrice] * [Quantity])) -- > 10  inja tedad kole argham ast dar yek adad -- float is also can be used with no input
AS [Average_Sales]
From [Order Details] 

-- Part 2

--Exercsise --> Determine the oldest & Youngest ages?

--Method 1
Select MIN (DATEDIFF(year, BirthDate, GetDate())) AS Youngest , 
MAX (DATEDIFF(year, BirthDate, GetDate())) AS Oldest
FROm Employees

--Method 2
Select DATEDIFF(year, MIN(BirthDate), GetDate()) AS Youngest , 
DATEDIFF(year, MAX(BirthDate), GetDate()) AS Oldest
FROm Employees

Select MIN(ProductName) As MINN, MAX(ProductName) AS MAXX 
from Products --> min and max for strings does not have anything to do with lengths. 
--It is merely aphabetically determined


--> Exercise --> Find the last order by employee number 5 in 1998??

Select Max(OrderID), Max(OrderDate) As Maxx
from Orders
Where EmployeeID = 5 AND Year(OrderDate) = 1998



--String_Agg

--Example --> name kalahaye category 1 ra ba comma bechasboonid be ham!

Select * from Products

Select STRING_AGG(ProductName, ',') As ProductNames
From Products
Where CategoryID = 1


--Concatenating Row values of T-SQL in simple talk (RedGate Website) --> especiaaly blackbox xml


-- Distinct Aggregate Functions
-- Count/Sum/Avg/Min/Max(Distinct<Exp>)

Select Distinct(CustomerID)
From Orders
Where Year(OrderDate) = 1997


Select Count(Distinct(CustomerID))
From Orders
Where Year(OrderDate) = 1997

Select Count(Distinct(Year(OrderDate))) As [DistinctYears]
From Orders 


-- Example --> har moshtari miyangin chand sefaresh dade ast?
Select count(OrderID) As [Total_Orders], count(Distinct(CustomerID)) As [Total_Customers]
, count(OrderID)/count(Distinct(CustomerID)) AS [Average_Purchase_By_Customer]
From Orders

-- Exercise -> name keshvarhaye moshtariyan ra be soorate distinct bechasboon be ham (21 keshvar ba comma)

With D
AS
    (Select distinct Country From Customers)

Select STRING_AGG(Country, ',')  WITHIN GROUP (Order BY Country) As Countries
From D

SELECT NAME, COMPATIBILITY_LEVEL FROM sys.databases

ALTER DATABASE NorthWnd
SET COMPATIBILITY_LEVEL = 110

-- GROUP BY
Select Country, count(CustomerID) AS [Cust_Count]
From Customers -- ERROR!
 -- hargah dar moghabele select, ebarate tajmei va gheyre tajmie bashand, angah groupby vajeb ast
 -- va hameye ebarete gheyre tajmie bayad jeloye group by gharar girand

Select Country, count(CustomerID) AS [Cust_Count]
From Customers 
-- Where
GROUP BY Country
-- HAVING
ORDER BY [Cust_Count]


Select EmployeeID, Count(OrderID) AS [Orders_Count], SUM(Freight) AS [Total_Weight]
From Orders
Where Year(OrderDate) = 1997
GROUP BY EmployeeID
ORDER BY [Orders_Count] DESC

select * from orders

-- Example --> Har karmand dar har sal, chand sefaresh dashte ast?

Select EmployeeID, Year(OrderDate) As [Year], Count(OrderID) AS [Orders_Count]
From Orders
GROUP BY EmployeeID, Year(OrderDate)
ORDER BY [Orders_Count] DESC


-- Exercise --> har karmand, dar har mah az sale 1997 chand sefaresh dashte ast?

Select EmployeeID, Month(OrderDate) As [Month], Count(OrderID) AS [Orders_Count]
From Orders
Where Year(OrderDate) = 1997
GROUP BY EmployeeID, Month(OrderDate)
ORDER BY [Orders_Count] DESC