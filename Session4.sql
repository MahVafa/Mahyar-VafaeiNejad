-- Part 1

Select * from Customers C;


With Poland
    As
	(Select C.ContactName, C.City, C.Country from Customers C
	Where C.Country = 'Poland')


Select * from Poland
	
-- "GO" is required before create (view or function or sp)

-- Table Valued Function (TVF)

--Inline TVF

Go
Create Or alter Function Fn_CustomerByCountry (@Country nvarchar(20))
Returns TABLE
AS

    Return (Select C.ContactName, C.CompanyName, C.Phone, C.Country, C.City, C.[Address] from Customers C
	       Where Country = @Country)

Go 

Declare @c nvarchar(20) = 'Germany'
Select * from Fn_CustomerByCountry(@c)

-- To modify the function, go to "Modify" or "Script functions as --> Alter to" 
-- Just for scalar functions, dbo is required. It is not required for a "TVF".	


Go
Create Or alter Function Fn_OrderByYear (@Year int, @shipcountry nvarchar(20))
Returns TABLE
AS

    Return (Select O.OrderID , O.OrderDate, O.CustomerID, C.ContactName, C.City, C.Phone, C.Country, O.ShipCity, O.ShipCountry, O.Freight  
	        from Orders O  INNER JOIN Customers C
	        ON O.CustomerID = C.CustomerID
	        Where ShipCountry = @shipcountry AND year(OrderDate) = @Year)

Go 


Select * from Orders

Declare @y int = 1996
Declare @s_c nvarchar(20) = 'France'

Select * from Fn_OrderByYear(@y , @s_c)

Select * from Fn_OrderByYear(1997 , 'USA')

-- Exercise --> Create a function (nth product) --> @n --> single argument

Go
Create Or alter Function Fn_nthexpensgood (@n int)
Returns TABLE
AS
    
    Return (With temp
	AS
	(Select Top (@n) P.ProductID, P.ProductName, P.CategoryID, P.UnitPrice
	 From Products P
	 Order By P.UnitPrice ASC)
	 Select Top(1) ProductID, ProductName,CategoryID, UnitPrice
	        From temp)

Go 


Select * from Fn_nthexpensgood (1)


-- Exercise --> Fn_kalarange(@N1 int, @N2 int)

Go
Create Or alter Function Fn_n1_n2thexpensgood (@n1 int, @n2 int)
Returns TABLE
AS

  Return
  SELECT *
  FROM (
      SELECT 
          *,
          ROW_NUMBER() OVER (ORDER BY UnitPrice DESC) AS rank
          FROM products
        ) ranked_products
       WHERE rank BETWEEN @n1 AND @n2;

Go

Select * from Fn_n1_n2thexpensgood (3, 7)

-- Synonym --> The main advantage is for the times when we may change the name of the objects later

Go 
Create Synonym C FOR [MAHYAR].[Northwnd].[dbo].[Customers]
Go

Select * from C


-- WHERE <Booolean Expression>


/*

<Expression1><Comparison_Operator><Expression2>
              =
			  <> OR !=
			  <=
			  >=
			  <
			  >
AND
OR
NOT
NOT (P AND Q) --> NOT P OR NOT Q

*/

Select * from products 
WHERE Unitprice >= 10 AND UnitPrice <= 20

Select * from products 
Where NOT (unitprice >= 10 AND unitprice <= 20)

Select * from products 
Where NOT (unitprice >= 10) OR Not (unitprice <= 20)


Select * from Products
WHERE CategoryID = 1 OR (CategoryID = 3 AND Unitprice < 10)


-- Part 2

-- Four important comparing operators in SQL : 1.IS[NOT]  2.[NOT]BETWEEN  3.[NOT]IN  4.[NOT]LIKE

Select * from Customers
where Region = NULL --> Returns nothing!!

Select * from Customers
where Region IS NULL

Select * from Customers
where Region IS NOT NULL --> Ansi (American National Standard Institute) Standard

-- To set off ANSI standard, 
SET ANSI_NULLS OFF

Select * from Customers
where Region = NULL

-- To change the settings, you may go to Query--> ANSI --> Set default ON (OFF)

Select * from Products
where UnitPrice BETWEEN 10 AND 20


Select * from Products
where UnitPrice NOT BETWEEN 10 AND 20

-- Exercise --> List orders which has been written in september and 1997

-- First Method
Select * from Orders
Where year(OrderDate) = 1997 AND Month(OrderDate) = 9

-- Between

-- Second Method
Select * from Orders
Where OrderDate Between '1997-09-01' AND '1997-09-30'

Select * from Orders
Where OrderDate Between '1997-09-01' AND '1997-09-30 23:59:00'

-- To see t-sql queries of a table, right click on a table, then click on edit top 200 rows, and then "CTRL + 3"

-- To convert English date to persian date:
SELECT FORMAT(GETDATE(), 'yyyy/MM/dd-HH:mm:ss', 'fa')

SELECT O.[OrderID], O.[CustomerID],  O.[OrderDate] AS [Miladi_Date], C.ContactName, C.Country, 
FORMAT(O.OrderDate, 'yyyy/MM/dd-HH:mm:ss', 'fa') AS [Persian_Date] , [Freight], [ShipCity], [ShipRegion], [ShipCountry]
From Orders O
INNER JOIN Customers C
ON O.CustomerID = C.CustomerID


-- IN 
Select * from Products
Where CategoryID IN (1,4)

Select * from Products
Where CategoryID NOT IN (1,4)

-- Exercise --> list customers who live in "France", "Germany", or "England"

Select * from Customers
Where Country = 'France' OR Country = 'Germany' OR Country = 'UK'


Select * from Customers
Where Country IN ('France', 'Germany','UK')



-- LIKE --> vaghti moghayese daghigh nemikhaym

Select * from Products
where ProductName LIKE 's%'

Select * from Products
where ProductName LIKE 'sir%'

Select * from Products
where ProductName LIKE '%s'

Select * from Products
where ProductName LIKE '%es'

Select * from Products
where ProductName LIKE '%e%'

Select * from Products
where ProductName LIKE '%ou%'

Select * from Products
where ProductName LIKE '%e[s,r]%'

Select * from Products
where ProductName LIKE '%e[sr]%'

Select * from Products
where ProductName LIKE '%e[r-t]%'

Select * from Products
where ProductName LIKE '%e[r-t]%'

Select * from Products
where ProductName LIKE '%es%er%'

Select * from Products
where ProductName LIKE 'ch[a-p]%'

Select * from Products
where ProductName LIKE '%e[^rst]%'

Select * from Products
where QuantityPerUnit LIKE '%[7,9]%'

Select * from Products
where ProductName LIKE '_____M%' 

Select * from Products
where ProductName LIKE 'M____M%' 

Select * from Products
where ProductName LIKE 'A_____M%' 

Select * from Products
where ProductName LIKE '__z_________i_G%' 

-- Exercise --> List orders which their Third number is 2 and the fourth number is 5
Select * from Orders
Where OrderID LIKE '__25%'

--> To extract names which contain "'" in their name
Select * from Products
Where ProductName LIKE '%''%'

Select * from Products
Where QuantityPerUnit NOT LIKE '%[-]%' --> products which do not contain "-" character

Select * from Products
Where QuantityPerUnit LIKE '%[%]20%' --> products which contain "%" and 20 character

Select * from Products
Where ProductName LIKE '%$[$%$_$]%' ESCAPE '$' --> products which contain "[" or % or _


-- Regular Expressions
-- CLR Integration --> Writing Function with C# in SQL
-- To search case-sensitively, go to design a table -> Collation -> WIndows Collation --> Dictionary Sort -> Case-Sensitive
-- To search case-sensitively, look below
Select * 
From Products 
Where ProductName = 'geitost' COLLATE PERSIAN_100_CS_AS

Select * 
From Products 
Where ProductName = 'Geitost' COLLATE PERSIAN_100_CS_AS


Select * from Products
Except 
Select Top(10) * from Products
order by UnitPrice Desc



Go
Create Or alter Function n1th_n2th (@N1 int, @N2 int)
Returns TABLE
AS

  Return
        (Select ProductID, ProductName, CategoryID, UnitPrice
		FROM Products
		ORDER BY UnitPrice DESC
		OFFSET @N1 - 1 ROWS FETCH NEXT @N2 - @N1 + 1 ROWS ONLY)

Go


Select * from n1th_n2th (2,7)


