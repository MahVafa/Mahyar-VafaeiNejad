-- Part 1

/* Select [<Predicate>] <Expression List>
FROM <TableName> | <ViewName>  | <DerivedTable> | <CTE> | <TableValuedFunction> | <Synonym>
[Where <Boolean Expression>]
[Group By <Expression List>]
[Having <Boolean Expression>]
[Order By <Expression List>]

*/ --Comment Block

-- Comment line

Use NORTHWND
-- Select * from [Products]
--Select ProductID, ProductName, UnitPrice
--from [Products]
-- Intellisence
--Select P.ProductID, P.ProductName, P.UnitPrice, P.ReorderLevel, P.SupplierID
--from [Products] P
-- or by As (Alias)
--Intellisense
-- Also can be done by Columns adding from the left and by design query editor (right-click on the white screen)
--Select P.ProductName, P.UnitPrice, p.UnitPrice * 0.09 As TAX , TAX2 = UnitPrice * 0.09
--From Products As P
-- If Space is included in a column name, [] is crucial in sql queries.
Select O.OrderID, O.Quantity,O.Discount As N'ضریب تخفیف', O.UnitPrice, O.Quantity * O.UnitPrice As [SalesAmount],
O.UnitPrice * O.Discount As [Total Discount], O.UnitPrice * (1 -  O.Discount) As N'قیمت خالص', 
O.Quantity * O.UnitPrice - O.UnitPrice * O.Discount As [درآمد خالص]
From [Order Details] O
-- There are two ways to make the column names "Persian": 1- Unicode by 'N'  2- Using []
-- "Alias" name of a column can not be used anywhere in a query unless in "OrderBY"
--Select 4*7+4
--Select with no "From" acts like a calculator
-- If overwrite mode is activated, just click on the "Insert" button on the keyboard or click on the "INS" area in the blue line below





-- Part 2

-- String Expressions

-- Select * from Employees
Select ISNULL(E.TitleOfCourtesy, N'') + ' ' + ' ' + E.FirstName + ' ' + E.LastName As [FullName] -- concatenate with "+" sign
from Employees E
-- For putting null in a cell , click "CTRL + 0" in editing a table of datbase (left side)

-- Exercise1: Please search how to remove the space in the above Query!

-- Implicit Conversion (String->Int not Converse) -> تبدیل ضمنی
-- Select '2' + 5 = 25 -> Implicit Conversion
-- Select 2 + 5 = 7
-- Select 'A' + 5 -> Error! 

--Explicit Conversion
Select Convert(nvarchar(5), E.EmployeeID) + ' ' + E.FirstName  From Employees E  
Select Cast(E.EmployeeID As nvarchar(5)) + ' ' + E.FirstName + ' ' + E.LastName From Employees E

--Select Convert(nvarchar(20), GetDate(), 102) As [FullDate]
Select Convert(nvarchar(20), GetDate(), 111) As [FullDate]
--Select Cast(E.EmployeeID As nvarchar(5)) + ' ' + E.FirstName + ' ' + E.LastName + ' ' + Convert(nvarchar(20), E.BirthDate, 111) As [EmpInfo]
--From Employees E
Select Concat(E.FirstName, 123, null, E.LastName) from Employees E  -- Concat bunch of strings (ignores "Null")

-- Some Mathematical Functions
--Select Floor(3.99)
--Select Ceiling(3.14)
--Select Round(3.49,1)

-- String Functions : 
--Left -> ابتدای رشته
Select Left('ABCD', 2)
Select Left(N'فرادانش', 4)
--Right -> ته رشته
Select Right('ABCD', 2)
Select Right(N'فرادانش', 4)
--Substring
Select Substring('ABCD',2,3)
Select Substring(N'فرا تراز دانش', 3,8)

--CLR Integration -> Writing Functions in "SQL" using "C#"
--A sample of Reversing a string (write it by your own!)
-- Functions are stores in Programmability part {1.Table-Valued 2. Scalar-Valued (For calling, "dbo" is required) 3. Aggregate 4. System}

--Date Functions
Declare @BirthDateLouie DateTime = '1996-07-30'
--Select DATEPART(dw,@BirthDateLouie)
Declare @BirthDateMe DateTime = '1994-09-21'
--Select DATEPART(dw,@BirthDateMe)
--Select DATEDIFF(year,@BirthDateMe, GetDate())
--Select DATEDIFF(day,@BirthDateLouie, GetDate())/365.25
Select DATEADD(day,3000,@BirthDateMe)
--Exercise: Add years of age for each employee
Select E.FirstName, E.LastName, E.City, E.Region, E.Country ,DATEDIFF(year,E.BirthDate, GETDATE()) As [Age]  from Employees E 
