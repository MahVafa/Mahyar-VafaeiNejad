-- Part 1

-- Grouping Sets
-- Grand Total
-- Subtotal

Select EmployeeID, Year(orderDate) AS OrderYear, ShipCountry, Count(OrderID) AS [Order_cnt]
From Orders
GROUP BY GROUPING SETS ((EmployeeID,Year(OrderDate),ShipCountry),())




Select EmployeeID, Year(orderDate) AS OrderYear, ShipCountry, Count(OrderID) AS [Order_cnt]
From Orders
GROUP BY GROUPING SETS ((EmployeeID,Year(OrderDate),ShipCountry),(EmployeeID))





Select EmployeeID, Year(orderDate) AS OrderYear, ShipCountry, Count(OrderID) AS [Order_cnt]
From Orders
GROUP BY GROUPING SETS ((EmployeeID,Year(OrderDate),ShipCountry),(EmployeeID), ())




Select EmployeeID, Year(orderDate) AS OrderYear,  Count(OrderID) AS [Order_cnt]
From Orders
GROUP BY GROUPING SETS ((EmployeeID,Year(OrderDate)),(EmployeeID), (Year(OrderDate)), ())


-- Exercise --> Create a report (first column --> Employee ID, USA, Germany, UK, France, Total --> Order count ro be tafkik mikhaym)



Select Count(*) From Categories -- 8

Select Count(*) From Products -- 77

Select * from
Categories , Products -- 77 * 8 = 616

Select * from Categories
Select * from Products

-- Old Syntax
Select * from Categories, Products
Where Categories.CategoryID = Products.CategoryID

-- Old Syntax
Select Categories.CategoryID, CategoryName, ProductID, ProductName, UnitPrice from Categories, Products
Where Categories.CategoryID = Products.CategoryID 

-- Standard Syntax
Select * from Categories
INNER JOIN Products
ON Categories.CategoryID = Products.CategoryID



-- Match Making
-- Example? Kodam Karmandan ba kodam moshtariyan hamvatan hastan?

Select * from Customers, Employees
Where Customers.Country = Employees.Country 

-- OR

Select * from Customers CROSS JOIN Employees
Where Customers.Country = Employees.Country

-- Alias

Select * from Customers C CROSS JOIN Employees E
Where C.Country = E.Country

Select * from Customers, Employees
Where Customers.Country = Employees.Country AND (Customers.City = Employees.City)


Select C.CustomerID, C.ContactName, C.CompanyName, C.Country, E.EmployeeID, E.FirstName, E.LastName, E.Country, E.City
From Customers C CROSS JOIN Employees E
Where C.Country = E.Country AND C.City = E.City
Order BY C.CustomerID


-- Part 2
-- ERD (Entity Relationship Diagram)
-- Dar moghabele name har gorooh kala, tedad kalahaye on goroh va jame mojoodi anbare anha ra neshoon bede?
-- Categories JOIN Products (Categories (Master) ---> Products (Details) 
--(Chon 1 category binahayat kala darad vali 1 kala faghat male 1 category ast) --> Rabete 1 --> N

-- Select 
--FROM Master [INNER] JOIN Details
--ON Master.PK = Details.FK
-- WHERE
--GROUP BY
-- HAVING
-- ORDER BY
-- OUTPUT --> be tedade Details(be sharti k kelide khareji ghalat nadashte bashim --> if no relations has been defined)

Select C.CategoryID, C.CategoryName, Count(P.ProductID) AS [Products_Count], SUM(P.UnitsInStock) AS [Total_Inventory]
From Categories C INNER JOIN Products P
ON C.CategoryID = P.CategoryID
Where P.Discontinued = 0
GROUP BY C.CategoryID, C.CategoryName


-- Example --> dar moghabele har kamrmand usa, tedad sefareshate oo va jame freight dar sale 1997?

Select E.EmployeeID,  E.FirstName, E.LastName,E.Country, Count(O.OrderID) AS [Ord_cnt] ,sum(O.Freight) AS [Total_Freight]
From Employees E INNER JOIN Orders O
ON E.EmployeeID = O.EmployeeID
Where E.Country = 'USA' AND Year(O.OrderDate) = 1997
GROUP BY E.EmployeeID, E.FirstName, E.LastName, E.Country



-- By Grouping Sets
Select E.EmployeeID,  E.FirstName, E.LastName,E.Country,E.City, Count(O.OrderID) AS [Ord_cnt] ,sum(O.Freight) AS [Total_Freight]
From Employees E INNER JOIN Orders O
ON E.EmployeeID = O.EmployeeID
Where E.Country = 'USA' AND Year(O.OrderDate) = 1997
GROUP BY GROUPING SETS ((E.EmployeeID, E.FirstName, E.LastName, E.Country,E.City),())

Select * from Orders
Select * from Employees
Select * from Products
Select * from [Order Details]

-- Example --> moghabele name har kala, forooshe tedadi va foorooshe dolari ra bezan

Select P.ProductID, P.ProductName, count(O.ProductID) As [Prod_cnt], sum(O.Quantity) AS [Quantity], sum(O.Quantity * O.UnitPrice) AS [Total_Sales]
FROM Products P INNER JOIN [Order Details] O
ON P.ProductID = O.ProductID
GROUP BY P.ProductID, P.ProductName


-- Exercise --> moghable har sherkaye haml, be tafkike sale haml, tedade sefareshate haml shode va avg hazine haml
-- sefarehate null hazf gardand

select * from Shippers
select * from Employees

-- Self JOIN (Consider it Later!)

--Example  Dar moghabele name har karmand name modirash ra benevisid

-- Exercise --> Read about Derakht (1.Recursive CTE 2. Hierarchical ID)

Select Emp.EmployeeID, Emp.FirstName AS [Employee_First_Name], Emp.LastName AS [Employee_Last_Name], Mgr.FirstName AS [Manager_First_Name], Mgr.LastName AS [Manager_Last_Name]
FROM Employees Emp LEFT JOIN Employees Mgr
ON Emp.ReportsTo = Mgr.EmployeeID
ORDER BY Emp.EmployeeID

-- Query Designer --> Baraye zamani k jadavel ro nemishnasim --> Right click on the screen (Design Query Editor)
--> 
SELECT E.EmployeeID, COUNT(O.OrderID) AS Orders_Cnt, SUM(O.Freight) AS Total_Freight, E.Country, O.OrderDate
FROM     Employees AS E INNER JOIN
                  Orders AS O ON E.EmployeeID = O.EmployeeID
WHERE  (E.Country = N'USA') OR (E.Country = 'UK')
GROUP BY E.EmployeeID, E.Country, O.OrderDate
HAVING (SUM(O.Freight) > 200) AND (Year(O.OrderDate) = 1998)
ORDER BY Total_Freight DESC