-- Part 1

Use NORTHWND

/*Select Country, STRING_AGG(CustomerID, ',') WITHIN GROUP (ORDER BY CustomerID) 
From Customers
GROUP BY Country
Order By Country
*/
Select @@VERSION

-- GROUP BY RULES
/* 1- agar hame ebarati k dar select estefade shodand, gheyre tajmie bashand, dar in sooray group by niaz nist.
   2- Hargah dar select, faghat ebarate tajmie dashte bashim, baz ham be grouo by niazi nist. tabe tajmie bedoone 
   group by 1 satr mide khorooji faghat
   3- agar dar moghabele select ebarate tajmie va gheyre tajmie gar do amade bashand, GROUP BY vajeb ast 
   va hame ebarate gheyre tajmie bayad GROUP BY shavand
*/

Select count(ProductID) , sum(Unitsinstock), avg(unitprice)
from products

select count(CustomerID)
from Customers
GROUP BY Country

select country,count(CustomerID)
from Customers
GROUP BY Country

-- Having --> baraye tayin shart rooye maghadir Tajmie

select EmployeeID, count(OrderID) as [order_cnt] 
from Orders
Where Year(OrderDate) = 1997
GROUP BY EmployeeID
Having count(OrderID)> 50
Order BY [order_cnt] DESC


select * from [order details]

Select  ProductID , sum(UnitPrice * Quantity) AS [Total_Sales] from [Order Details]
GROUP BY ProductID
Having sum(UnitPrice * Quantity) > 10000
ORDER BY [Total_Sales] DESC

-- baraye sootoonhayi k group by darand, mishe joloye having sharte gheyre tajmie nevesht
-- Generally, for not non-accumulative conditions, use "WHERE" and for accumulative ones use "HAVING"

Select  ProductID , sum(UnitPrice * Quantity) AS [Total_Sales] from [Order Details]
GROUP BY ProductID
Having sum(UnitPrice * Quantity) > 10000 AND ProductID > 60
ORDER BY [Total_Sales] DESC

-- ORDER BY Rules:
/*
1- agar dar select group by nabood, angah rooye har ebarati gozaresh ra moratab konim hata ebarati k
dar select nist (vali tosiye nemishe)
2- agar dar select group by bashad, angah dar moghabele order by mahdoodiyati baraye ebarate tajmie nadarim
3- dar moghabele order by, faghat ebarati k dar select hast bayad bashad.


*/

--SELECT EMPLOYEEID, customerID, orderdate
--from Orders
--order by freight --> ridiculous (rule 1)


-- Exercise -- moshtariyan ra be tartibe zir list konid
-- aval US bad alman bad english bad france va baghiye moshtariyan be tartibe name keshvar (horrof alefba)

WITH country_sort
AS
   (Select CustomerID, ContactName, Country, CASE
                                                 When Country = 'USA' THEN 1
												 When Country = 'Germany' THEN 2
												 When Country = 'UK' THEN 3
												 When Country = 'France' THEN 4
												 Else 5
												 End
												 AS [Country_Code]
From Customers)



Select * from country_sort
GROUP BY CustomerID, ContactName, [Country_Code], Country
Order BY [Country_Code] ASC, Country




Select CustomerID, ContactName From Customers
Order By Case
             When 


Select EmployeeID, Year(OrderDate) AS OrderYear , count(OrderID) AS ORDERCOUNT
FROM Orders
GROUP BY EMPLOYEEID, Year(OrderDate)
--ORDER BY EmployeeID        OK
--ORDER BY Year(OrderDate)      OK
--ORDER BY count(OrderID)       OK
--ORDER BY SUM(Freight)      OK BUT Koshher
-- ORDER BY CustomerID    BULLSHIT!!
-- ORDERBY 3 DESC
ORDER BY 1,2


-- OFFSET/FETCH --> hatman bad az order by --> karborde asli paging hast (GMAIL OR Website)
Select * from Products
Order By ProductID
OFFSET 10 ROWS FETCH Next 5 ROWS ONLY


-- Exercise --> 
 Declare @Page int = 2
 Declare @RowsPerPage int = 20

 Select * from Orders
 ORDER BY OrderID
 OFFSET 20 * (@Page - 1) ROWS FETCH Next @RowsPerPage ROWS ONLY
 


 -- Part 2

 -- GROUP BY CASE

 -- Exercise --> be tafkik damane gheymat chand kala darim?

 Select Count(ProductID) AS [Prod_cnt], avg(UnitPrice) as Price_Avg, CASE
                                                        When UnitPrice Between 0 And 20 Then 'Cheap'
														When UnitPrice Between 21 And 50 Then 'Medium'
														When UnitPrice Between 50 And 150 Then 'Expensive'
														Else  'Luxurious'
														End
														AS [Price_Status]

 from Products
 GROUP BY CASE
                                                        When UnitPrice Between 0 And 20 Then 'Cheap'
														When UnitPrice Between 21 And 50 Then 'Medium'
														When UnitPrice Between 50 And 150 Then 'Expensive'
														Else  'Luxurious'
														End ;
														

 -- Exercise --> Tedade sefaresh be tafkik employeeID , taeein karman kamkar, porkar (kamkar zire 50, porkar balaye 100)
 /* WITH CTEE 
 AS
    (Select EmployeeID, Count(OrderID) AS [Ord_Cnt]
	From Orders
	GROUP BY EmployeeID)



 Select  sum([Ord_Cnt]),   CASE
                                                                   WHEN [Ord_Cnt] < 50 THEN 'Kamkar'
																   WHEN [Ord_Cnt] < 120  THEN 'Motevaset'
																   Else 'Porkar'
																   End
																   AS [Kar_Status]

 from CTEE
 group by CASE
                                                                   WHEN [Ord_Cnt] < 50 THEN 'Kamkar'
																   WHEN [Ord_Cnt] < 120  THEN 'Motevaset'
																   Else 'Porkar'
																   End

*/

Select * from Orders



 Select  CASE
                                                                   WHEN DATEDIFF(Year, BirthDate, GETDATE()) Between 40 AND 65 THEN 'Young'
																   WHEN DATEDIFF(Year, BirthDate, GETDATE()) Between 66 AND 75 THEN 'Old'
																   Else 'Octogenerian'
																   End
																   AS [Age_Range], count(EmployeeID) AS [Employee_cnt]

 from Employees
 GROUP BY CASE 
                                                                   WHEN DATEDIFF(Year, BirthDate, GETDATE()) Between 40 AND 65 THEN 'Young'
																   WHEN DATEDIFF(Year, BirthDate, GETDATE()) Between 66 AND 75 THEN 'Old'
																   Else 'Octogenerian'
																   End;

WITH Ages
AS
	 (Select  EmployeeID, FirstName, LastName, CASE
                                                                   WHEN DATEDIFF(Year, BirthDate, GETDATE()) Between 40 AND 65 THEN 'Young'
																   WHEN DATEDIFF(Year, BirthDate, GETDATE()) Between 66 AND 75 THEN 'Old'
																   Else 'Octogenerian'
																   End AS [Age_Ranges]
      From Employees	
)

select Age_Ranges, count(EmployeeID) AS [Employee_cnt] from Ages
GROUP BY Age_Ranges
Order BY [Employee_cnt] DESC


-- Conditional Aggregate Functions

/*
EmployeeID  Count96    Count97     Count98    Total
1             10          2          3          15
2
3
4


*/
 -- Pivot --> maghadire tajmie to = CrossTab = Matrix	
 

 -- be tafkike employeeID, pivot ba sum freight ro dar biyarid

 Select EmployeeID, sum(CASE WHEN Year(OrderDate) = 1996 THEN Freight else 0 end)AS [Fre_1996],
                    sum(CASE WHEN Year(OrderDate) = 1997 THEN Freight else 0 end) AS [Fre_1997],
                    sum(CASE WHEN Year(OrderDate) = 1998 THEN Freight else 0 end) AS [Fre_1998],
					sum(Freight) as Total_Freight
                        

from Orders
group by EmployeeID
order by EmployeeID



Select EmployeeID, count(CASE WHEN Year(OrderDate) = 1996 THEN 'True' END)AS [ord_cnt_1996],
       count(CASE WHEN Year(OrderDate) = 1997 THEN 'True' END) AS [ord_cnt_1997],
	   count(CASE WHEN Year(OrderDate) = 1998 THEN 'True' END) AS [ord_cnt_1998],
	   Count(OrderID) AS [Total_Orders]

From Orders
GROUP BY EmployeeID

Select * From Employees


Select CategoryID, IsNull(sum(CASE WHEN UnitPrice < 10  THEN UnitsInStock END),0) AS [Cheap_Stocks],
                   IsNull(sum(CASE WHEN UnitPrice Between 11 AND 50 THEN UnitsInStock END),0) AS [Medium_Stocks],
	               IsNull(sum(CASE WHEN UnitPrice Between 51 AND 130 THEN UnitsInStock END),0) AS [Expensive_Stocks],
				   IsNull(sum(CASE WHEN UnitPrice Between 131 AND 290 THEN UnitsInStock END),0) AS [Luxurious_Stocks],
	               SUM(UnitsInStock) AS [Total_Inventory]

From Products
GROUP BY CategoryID

--Select * from [Products]

-- Exercise --> Create a Table Name Personnel (PersonnelID, Name, Family, Age, Gender, Salary)

/*
Age_Range    Male_Count      Female_Count     Total_Count      Male_Avg_Salary     Female_Avg_Salary   Total_Avg_Salary

Young
Middle_Aged
Old




*/


--Create DataBase Pivot_DB

--Use Pivot_DB

Create Table Emplo_Inf (Emp_ID int NOT NULL PRIMARY KEY IDENTITY,
FirstName nvarchar(50),
                        LastName nvarchar(50),
Gender nvarchar(50) Check (Gender in ('F','M')),
Salary int Check (Salary Between 1 AND 80000)
)

--Use Northwind
--DROP Table dbo.Emplo_Inf

Insert into Emplo_Inf (FirstName, LastName, Gender, Salary) Values ('Mahyar', 'Vafaeinejad', 'M', 27000),
  ('Kamyar', 'Vafaeinejad', 'M', 33000),
  ('Ramtin', 'Rostamian', 'M', 5000),
  ('Mozhgan', 'Rafie', 'F', 10000),
  ('Sara', 'Bayat', 'F', 20000),
  ('Ali', 'Fazli', 'M', 75000),
  ('Narges', 'Shahgholi', 'F', 45000),
  ('Maryam', 'Iranshahi', 'F', 55000),
  ('Reza', 'Koohi', 'M', 4700),
  ('Shideh', 'Safaei', 'F', 16000),
  ('Afsaneh', 'Soltani', 'F', 64000),
  ('MohammadHossein', 'Vafaeinejad', 'M', 31000)



/* Male count    Female Count    Total Count      Male Salary      Female Salary    Total Salary

Young
Middle-Aged
Old

*/


Create DataBase Pivot_DB

Use Pivot_DB

Create Table Emplo_Inf (Emp_ID int NOT NULL PRIMARY KEY IDENTITY,
FirstName nvarchar(50),
                        LastName nvarchar(50),
Gender nvarchar(50) Check (Gender in ('F','M')),
Salary int Check (Salary Between 1 AND 80000)
)

--Use Northwind
--DROP Table dbo.Emplo_Inf

Insert into Emplo_Inf (FirstName, LastName, Gender, Salary) Values ('Mahyar', 'Vafaeinejad', 'M', 27000),
  ('Kamyar', 'Vafaeinejad', 'M', 33000),
  ('Ramtin', 'Rostamian', 'M', 5000),
  ('Mozhgan', 'Rafie', 'F', 10000),
  ('Sara', 'Bayat', 'F', 20000),
  ('Ali', 'Fazli', 'M', 75000),
  ('Narges', 'Shahgholi', 'F', 45000),
  ('Maryam', 'Iranshahi', 'F', 55000),
  ('Reza', 'Koohi', 'M', 4700),
  ('Shideh', 'Safaei', 'F', 16000),
  ('Afsaneh', 'Soltani', 'F', 64000),
  ('MohammadHossein', 'Vafaeinejad', 'M', 31000)


Alter Table Emplo_Inf
add BirthDate DateTime Not Null Default('1996-07-30')

update Emplo_Inf
set BirthDate = '1994-09-21' where Emp_ID = 1

update Emplo_Inf
set BirthDate = '1994-03-09' where Emp_ID = 3

update Emplo_Inf
set BirthDate = '1978-05-28' where FirstName = 'Mozhgan'

update Emplo_Inf
set BirthDate = '2006-11-03' where FirstName = 'Sara'

update Emplo_Inf
set BirthDate = '1946-12-06' where Emp_ID = 6

update Emplo_Inf
set BirthDate = '1952-04-14' where Emp_ID = 7

update Emplo_Inf
set BirthDate = '1974-01-17' where Emp_ID = 8

update Emplo_Inf
set BirthDate = '1985-07-20' where Emp_ID = 9

update Emplo_Inf
set BirthDate = '2001-06-10' where Emp_ID = 10

update Emplo_Inf
set BirthDate = '1969-04-23' where Emp_ID = 11

update Emplo_Inf
set BirthDate = '1961-07-24' where Emp_ID = 12


Alter Table Emplo_Inf
Add [Salary_Range] nvarchar(20)

Update Emplo_Inf
Set [Salary_Range] = Case
WHEN Salary Between 0 AND 6000 THEN 'Poor'
WHEN Salary Between 6001 AND 20000 THEN 'Normal'
WHEN Salary Between 20001 AND 50000 THEN 'Rich'
Else 'Wealthy'
END



select * from Emplo_Inf

Alter Table Emplo_Inf
Add [Age] int

Update Emplo_Inf
Set [Age] = DateDiff(Year, BirthDate, GetDate())


Alter Table Emplo_Inf
Add [Age_Range] nvarchar(50)

Update Emplo_Inf
Set [Age_Range] = Case
when [Age] <= 35 then 'Young'
when [Age] between 36 and 60 then 'MiddleAged'
when [Age] >= 61 then 'Octogenerian'
end





Select Emp_ID, FirstName, Gender, Salary,  CASE WHEN Gender = 'M' Then 1 else 0 END AS [Male],
                                   CASE WHEN Gender = 'F' Then 1 else 0 END AS [Female],
  CASE WHEN Gender = 'M' Then Salary else 0 END AS [Male_Salary],
  CASE WHEN Gender = 'F' Then Salary else 0 END AS [Female_Salary]
From Emplo_Inf

select * from Emplo_Inf

Select [Age_Range], sum(CASE WHEN Gender = 'M' Then 1 else 0 END) AS [Male],
					sum(CASE WHEN Gender = 'F' Then 1 else 0 END) AS [Female],
					Count(FirstName) As [Total_Person],
					sum(CASE WHEN Gender = 'M' Then Salary else 0 END) AS [Male_Salary],
					sum(CASE WHEN Gender = 'F' Then Salary else 0 END) AS [Female_Salary],
					sum(Salary) As [Total_Salary]
From Emplo_Inf
GROUP BY [Age_Range]
--GROUP BY Grouping Sets (([Age_Range]), ())

