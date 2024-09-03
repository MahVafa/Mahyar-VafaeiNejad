-- Part 1
Use NORTHWND
Select * from Employees 
Select ISNULL(E.TitleOfCourtesy , N'') + E.FirstName + N' ' + E.LastName As [FullName]
from Employees E

Select len(Trim(' Kamyar  Vaf ae i   '))
Select len(RTrim(' Kamyar  Vafaei  '))
-- Also Check "LTrim" 

--CASE--
Select * from Products
Select P.ProductID, P.ProductName, P.UnitPrice, CASE
                                                    When P.UnitPrice < 15 Then 'Cheap'
													When P.UnitPrice Between 15 And 45 Then 'Mediocre'
													When P.UnitPrice >= 45 Then 'Expensive'
													Else 'Not Specified'
												END    
												As [Price_Status]
From Products P 

-- To hide and unhide the result area, use "CTRL + R"

/*Select EmployeeID, E.FirstName, DATEDIFF(year,E.BirthDate, GETDATE()) As [Age], 
                                                   CASE
                                                    When DATEDIFF(year,E.BirthDate, GETDATE()) < 40 Then 'Young'
													When DATEDIFF(year,E.BirthDate, GETDATE()) < 65 Then 'Middle-Aged'
													Else 'Old'
												END    
												As [Age_Status]
From Employees E */

-- Computed Column
/*Alter Table Employees
Add [Age] int*/;
-- or */
/*Alter Table Employees
Add [Age] As DATEDIFF(year, BirthDate, GETDATE()) PERSISTED;*/
UPDATE Employees
SET Age = DATEDIFF(day, BirthDate, GETDATE()) / 365
--WHERE Age IS NULL;
Select * from Employees

-- IIF -> Immediate IF ( there is no IF in SQL. We just have IFF) -> for two conditions only
Select P.ProductName, P.UnitPrice, IIF(P.UnitPrice < 40, 'Cheap', 'Expensive') AS [Price_Range]
From Products P
Select P.ProductName, P.UnitPrice, IIF(P.Discontinued = 'False', 'Active', 'Inactive') As [Active?]
From Products P 


-- Part 2

-- Prediacte -> specifies the level of showing of selected rows
-- 1- All 2- Distinct (Generally, is used when duplicate values is there) 3- TOP <n>

Select All * 
from Products 
Where (UnitPrice < 10) 

Select * from Customers -- 91 Customers

Select Distinct C.Country -- 21 Countries
From Customers C

Select Distinct C.City, C.Country -- 69 unique Cities
From Customers C

Select TOP 10 C.CustomerID
From Customers C

/*
Employee ID     Name        Family        FatherName
-----------    -------      -----         ----------
89065           Ali         Hosseini       Ahmad
96089           Javad       Hosseini       Mohammad
56789           Ali         Hosseini       Reza

Select Distinct Family -- 1
Select Distinct Name, Family -- 2
Select Distinct Name, Family, FatherName -- 3
Select Employee ID, Family -- 3

*/

Select Distinct Year(O.OrderDate) As [Unique_Recorded_Years]
From Orders O
Order By [Unique_Recorded_Years] Desc

Select Distinct(O.CustomerID), Year(O.OrderDate) As [Year]
From Orders O
Where  Year(O.OrderDate)= 1996

Select O.CustomerID , count(O.OrderID) As [Orders_Count]
From Orders O
--Where  Year(O.OrderDate)= 1996
Group BY O.CustomerID
Order By [Orders_Count] Desc
--Order By count(O.OrderID) Desc

Select O.CustomerID , Year(O.OrderDate) As [Year], count(O.OrderID) As [Order_Counts]
From Orders O
Group BY O.CustomerID, Year(O.OrderDate)
Order by [Order_Counts] Desc

Select TOP 40 *
From Products P
Order By P.CategoryID Desc--P.UnitPrice Desc 

Select TOP 1 *
From Products P
Order By  P.UnitPrice Desc

Select Top (1) EmployeeID, FirstName, LastName
From Employees 
Order By Year(BirthDate)

Select Top (12) WITH TIES * from Products
Order By UnitPrice

Select TOP 10 PERCENT *
From Products
Order By UnitPrice Desc

Select * from Orders
--Exercise-> The last Order by Employee number 5 in 1998

Select O.OrderID, O.OrderDate, O.CustomerID, O.ShipCountry
From Orders O
Where O.EmployeeID = 5 And Year(O.OrderDate) = 1998
Order By O.OrderDate Desc, O.OrderID Desc


