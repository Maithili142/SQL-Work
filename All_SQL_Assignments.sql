use classicmodels;
SET SQL_SAFE_UPDATES = 0;

-- DAY 3
/* 1)	Show customer number, customer name, state and credit limit from customers table for below conditions. Sort the results 
by highest to lowest values of creditLimit.

	State should not contain null values
	credit limit should be between 50000 and 100000 */
select * from customers;

select
	customerNumber, customerName, state ,creditLimit
    from Customers
    where state is not null and creditLimit between 50000 and 100000
    order by creditLimit Desc;
    
    
-- 2)	Show the unique productline values containing the word cars at the end from products table.
select  Distinct productLine
from products
where productLine like "%cars";

-- Day 4

/* 1)	Show the orderNumber, status and comments from orders table for shipped status only.
 If some comments are having null values then show them as “-“.
 */
 select 
	orderNumber, `status`, ifnull(comments,"-")
    from orders
    where `status`= "Shipped" ;
 

/* 2)	Select employee number, first name, job title and job title abbreviation from employees table based on following conditions.
If job title is one among the below conditions, then job title abbreviation column should show below forms.
●	President then “P”
●	Sales Manager / Sale Manager then “SM”
●	Sales Rep then “SR”
●	Containing VP word then “VP”
*/
select 	
	employeeNumber, firstName, jobTitle,
    case
    when jobTitle="President" then "p"
    when jobTitle like "%Manager%" then "SM"
    WHEN jobTitle="Sales Rep" then "SR"
    WHEN jobTitle="VP" then "VP"
    end as jobTitleabbreviation 
    from employees
	ORDER BY jobTitle;
    
/* Day 5
1)	For every year, find the minimum amount value from payments table
    */
    select year(paymentDate) as `year`,min(amount)
    from payments
    group by `year` order by `year` asc;
    
  /*  2)	For every year and every quarter, find the unique customers and total orders from orders table. 
    Make sure to show the quarter as Q1,Q2 etc.
    */
    select 
		year(orderDate) as `year`,
        case
			when quarter(orderDate)=1 then  'Q1'
            when quarter(orderDate)=2 then  'Q2'
            when quarter(orderDate)=3 then  'Q3'
            when quarter(orderDate)=4 then  'Q4'
		end as`Quarter`,
		count(distinct customerNumber)  as "Unique Customer"  ,
        count(orderNumber) as "Total orders"
        from orders
		group by  `year`,`Quarter`;
    
    /* 3)	Show the formatted amount in thousands unit (e.g. 500K, 465K etc.)
    for every month (e.g. Jan, Feb etc.) with filter on total amount as 500000 to 1000000. 
    Sort the output by total amount in descending mode. [ Refer. Payments Table]*/
    
	select 
    left(monthname(paymentDate),3) as `Month`,
	concat((round(sum(amount)/1000)),"k") as formatted_amount
    from payments
    group by `Month`
    having  sum(amount)>=500000 and sum(amount)<=1000000
     order by  sum(amount) desc;
     
     
 /* Day 6
    1)	Create a journey table with following fields and constraints.

●	Bus_ID (No null values)
●	Bus_Name (No null values)
●	Source_Station (No null values)
●	Destination (No null values)
●	Email (must not contain any duplicates) */

create table journey(
			Bus_ID int Not null ,
			Bus_Name varchar(30) Not null ,
            Source_Station varchar(30) Not null,
			Destination varchar(30) Not null,
			Email varchar(20) unique);
select * from journey;
/*2)	Create vendor table with following fields and constraints.

●	Vendor_ID (Should not contain any duplicates and should not be null)
●	Name (No null values)
●	Email (must not contain any duplicates)
●	Country (If no data is available then it should be shown as “N/A”)*/

create table vendor(Vendor_ID int not null unique,
	`Name` varchar(30) Not null,
    Email varchar(30) unique,
	Country varchar(30) not null default "N/A");
    
    /* 3)	Create movies table with following fields and constraints.

●	Movie_ID (Should not contain any duplicates and should not be null)
●	Name (No null values)
●	Release_Year (If no data is available then it should be shown as “-”)
●	Cast (No null values)
●	Gender (Either Male/Female)
●	No_of_shows (Must be a positive number)  */

create table movies(
		Movie_ID int not null unique,
		`Name` varchar(30), 
	Release_Year year(4)  not null default "-",
	Cast varchar(30) Not null,
    Gender enum('Male','female' ) not null,
	No_of_shows int  check(No_of_shows >0) 
    );
    
  /* 4)	Create the following tables. Use auto increment wherever applicable

a. Product
✔	product_id - primary key
✔	product_name - cannot be null and only unique values are allowed
✔	description
✔	supplier_id - foreign key of supplier table */
create table  product( product_id int  primary key  auto_increment,
			product_name varchar(30) not null unique,
			`description` varchar(100),	supplier_id int,
			constraint foreign key(supplier_id) references Suppliers(supplier_id)
            on update cascade 
            on delete cascade);
/*Suppliers
✔	supplier_id - primary key
✔	supplier_name
✔	location*/
create table Suppliers(
			supplier_id  int primary key auto_increment,
			supplier_name varchar(30),
			location varchar(25));

/*Stock
✔	id - primary key
✔	product_id - foreign key of product table
✔	balance_stock*/
create table Stock(
	id int primary key auto_increment,
	product_id int,
    balance_stock int,
    constraint foreign key(product_id) references product(product_id)
            on update cascade 
            on delete cascade);



-- day 7

/*1)	Show employee number, Sales Person (combination of first and last names of employees), 
unique customers for each employee number and sort the data by highest to lowest unique customers.
Tables: Employees, Customers
*/
select * from employees;
select * from customers;

select 
	 distinct employeeNumber ,
	concat(firstName,' ',lastName) as "Sales Person",
	 count(c.customerNumber) as `unique customer`
     from employees e join customers c on
     c.salesRepEmployeeNumber=e.employeeNumber
     group by e.employeeNumber
     order by `unique customer` desc;
/*2)	Show total quantities, total quantities in stock, 
left over quantities for each product and each customer. 
Sort the data by customer number.
Tables: Customers, Orders, Orderdetails, Products8 */
select * from customers;
select * from orders;
select * from orderdetails;
select * from products;
select 
	c.customerNumber,
	c.customerName,
	p.productCode,
	p.productName,
sum(d.quantityOrdered) as 'Ordered qty',
sum(p.quantityInStock) as 'Total inventory',
sum(p.quantityInStock)-sum(d.quantityOrdered) as 'Left Qty'
from customers c 
	inner join orders o on c.customerNumber=o.customerNumber
	inner join  Orderdetails d on o.orderNumber=d.orderNumber
    inner join products p on d.productCode=p.productCode
	group by c.customerNumber,p.productCode
	order by c.customerNumber
;

/*3)	Create below tables and fields. (You can add the data as per your wish)

●	Laptop: (Laptop_Name)
●	Colours: (Colour_Name)
Perform cross join between the two tables and find number of rows.
*/
create table Laptop(Laptop_Name varchar(20));
insert into Laptop values( 'DEll'),('Dell'),('HP'),('Macbook'),('HP'),('Lenovo');

create table Colours(Colour_Name varchar(20));
insert into Colours value('White'),('Black'),('Silver'),('WHite'),('Blue'),('Silver');

select 
	Laptop_Name,
    colour_Name
    from Colours  ,Laptop;
    
/*
4)	Create table project with below fields.

●	EmployeeID
●	FullName
●	Gender
●	ManagerID
Add below data into it.*/

create table project(
	EmployeeID int ,
	FullName varchar(40),
	Gender varchar(10),
	ManagerID int );
INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);

SELECT E.FullName AS "Employee Name",
       (SELECT M.FullName
        FROM project M
        WHERE E.ManagerId = M.EmployeeId) AS "Manager"
FROM project E;


use classicmodels;
SET SQL_SAFE_UPDATES = 0;

-- Day 8
/*Create table facility. Add the below fields into it.
●	Facility_ID
●	Name
●	State
●	Country
*/
create table facility(
	Facility_ID int ,
	`Name` varchar(30), 
	State varchar(20),
	Country varchar(20));
    
-- i) Alter the table by adding the primary key and auto increment to Facility_ID column.
	alter table facility modify column Facility_ID INT auto_increment primary KEY;
    
-- ii) Add a new column city after name with data type as varchar which should not accept any null values.
	ALTER TABLE facility add column city varchar(50) not null after name; 
	
	describe facility;
    
    use classicmodels;
SET SQL_SAFE_UPDATES = 0;

-- Day 9
/*Create table university with below fields.
●	ID
●	Name*/
create table University(ID int,Name varchar(100));
select * from University;
                drop table University;
-- Add the below data into it as it is.
INSERT INTO University
VALUES (1, "       Pune          University     "), 
               (2, "  Mumbai          University     "),
              (3, "     Delhi   University     "),
              (4, "Madras University"),
              (5, "Nagpur University");
-- Remove the spaces from everywhere and update the column like Pune University etc.
SELECT
     ID,
    LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(`Name`,CHAR(32),'()'),')(',''),'()',CHAR(32)))) as `Name`
FROM University;

/*Day 10
Create the view products status. Show year wise total products sold. Also find the percentage of total value for each year.
The output should look as shown in below figure.*/
 
-- create view products_status as
USE classicmodels;
create view products_status
    AS
    select 
    year(o.orderDate) as 'YEAR',
    concat(count(d.quantityordered),'(',round((count(d.quantityordered)/
    (select count(quantityordered)from orderdetails))*100),'%',')') as `value`
     from orders o
    join orderdetails d on o.orderNumber = d.orderNumber
    where o.orderNumber = d.orderNumber
    group by YEAR
    order by count(d.quantityordered) desc;
    SELECT * FROM products_status;
   
   -- day 11
    use  classicmodels;
-- 1) Create a stored procedure GetCustomerLevel which takes input as customer number and 
--    gives the output as either Platinum, Gold or Silver as per below criteria.
-- Table: Customers
-- ●	Platinum: creditLimit > 100000
-- ●	Gold: creditLimit is between 25000 to 100000
-- ●	Silver: creditLimit < 25000
	USE classicmodels;
    SELECT * FROM customers;
	DELIMITER //
		CREATE PROCEDURE GetCustomerLevel(IN custN INT, OUT CreditCategory VARCHAR(20))
		BEGIN
        SELECT 
			customerNumber, 
       CASE
			WHEN creditLimit > 100000 THEN 'Platinum'
			WHEN creditLimit BETWEEN 25000 AND 100000 THEN 'Gold'
			ELSE 'Silver'
	   END AS CreditLevel
	   FROM customers;
	END //
		DELIMITER ;
		CALL GetCustomerLevel(103, @CreditCategory);
-- -------------------------------------------------------------------------------------------------------------
-- 2)	Create a stored procedure Get_country_payments which takes in year and country as inputs and gives year wise, 
--      country wise total amount as an output. Format the total amount to nearest thousand unit (K)
-- Tables: Customers, Payments

   USE classicmodels;
   SELECT * FROM Customers;
   SELECT * FROM Payments;
   DROP PROCEDURE Get_payments;
   DELIMITER //
        CREATE PROCEDURE Get_payments(IN loc VARCHAR(30),IN yr varchar(10))
        BEGIN
			SELECT 
            Year(p.paymentDate) AS `Year`,
            c.Country,
			CONCAT(ROUND(SUM(p.amount)/1000 ),'K') AS 'totalAmount'     
		    FROM Customers c INNER JOIN Payments p ON c.customerNumber = p.customerNumber
            GROUP BY `YEAR`, country
            HAVING country = loc AND `Year` = yr;
            END // 
        DELIMITER ; 
            
   SET @country = 'France';
   SET @yr = '2003';
   CALL Get_payments(@country,@yr);
-- ----------------------------------------------------------------------------
-- day 12
-- 1) Calculate year wise, month name wise count of orders and year over year (YoY) percentage change. 
--    Format the YoY values in no decimals and show in % sign.
--    Table: Orders

USE classicmodels;    
SELECT * FROM orders;                                                         -- PREVIOUS order date
SELECT  DISTINCT         
YEAR(orderDate) AS `YEAR`,
MONTHNAME(orderDate) AS `MONTH`,
COUNT(customerNumber) AS 'Total Orders',
CONCAT(FORMAT((COUNT(customerNumber)/(LAG(COUNT(customerNumber)) OVER (PARTITION BY YEAR(orderDate)))-1)*100,'0'),"%")
       AS '% YoY Change'
FROM orders	
GROUP BY `YEAR`, `MONTH`;
-- ---------------------------------------------------------------------------------------------------------

-- 2)	Create the table emp_udf with below fields.
-- ●	Emp_ID
-- ●	Name
-- ●	DOB
-- Add the data as shown in below query.
-- INSERT INTO Emp_UDF(Name, DOB)
-- VALUES ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");
-- Create a user defined function calculate_age which returns the age in years and months (e.g. 30 years 5 months) 
-- by accepting DOB column as a parameter.

CREATE DATABASE emp_udf;
USE emp_udf;
CREATE TABLE emp_udf (
EMP_ID INT PRIMARY KEY AUTO_INCREMENT,
`Name` VARCHAR(20),
DOB DATE NOT NULL,
Age INT
);
INSERT INTO emp_udf (Name, DOB) VALUES ("Piyush", "1990-03-30"),
									   ("Aman", "1992-08-15"),
									   ("Meena", "1998-07-28"),
									   ("Ketan", "2000-11-21"),
									   ("Sanjay", "1995-05-21");
SELECT DISTINCT * FROM emp_udf;

DELIMITER //
	CREATE FUNCTION get_Age(DOB DATE)
	RETURNS VARCHAR(30) 
    DETERMINISTIC
	BEGIN 
		DECLARE Age varchar(30);
		SET Age = CONCAT(DATE_FORMAT(FROM_DAYS(DATEDIFF(NOW(), DOB)), '%Y')+0, ' Years ',
                         DATE_FORMAT(FROM_DAYS(DATEDIFF(NOW(), DOB)), '%m')-1,' months') ;
		RETURN (Age);
     END //
        DELIMITER ;
      
SELECT EMP_ID, `Name`, DOB , get_Age(DOB) AS Age FROM emp_udf;
-- --------------------------------------------------------------------------------------------------

-- day13
   -- 1)	Display the customer numbers and customer names from customers table who have not placed any orders using subquery
-- Table: Customers, Orders
USE classicmodels;
	SELECT
		customerNumber,customerName
	FROM customers
    WHERE customerNumber NOT IN (SELECT DISTINCT customerNumber FROM orders )
    ORDER BY customerNumber ASC;
    
-- -------------------------------------------------------------------------------------------------------
-- 2) Write a full outer join between customers and orders using union and get the customer number, customer name, 
--    count of orders for every customer.
-- Table: Customers, Orders
USE classicmodels;
SELECT 
	c.customerNumber , c.customerName , COUNT(orderNumber) AS 'Total'
FROM Customers c INNER JOIN Orders o ON c.customerNumber = o.customerNumber
GROUP BY  c.customerNumber;

-- --------------------------------------------------------------------------------------------------------
-- 3) Show the second highest quantity ordered value for each order number.
-- Table: Orderdetails
USE classicmodels;
SELECT * FROM Orderdetails;
SELECT 
	orderNumber, quantityOrdered 
	FROM  
    ( SELECT orderNumber, quantitYOrdered ,
	DENSE_RANK ()OVER (PARTITION BY orderNumber ORDER BY quantitYOrdered DESC ) AS _rnk
	FROM Orderdetails) d
	WHERE _rnk=2;
        	
-- ------------------------------------------------------------------------------------------------
-- 4) For each order number count the number of products and then find the min and max of the values among count of orders.
-- Table: Orderdetails

USE classicmodels;
SELECT * FROM Orderdetails;
	SELECT
		MAX(orderLineNumber) AS 'MAX(Total)',
		MIN(orderLineNumber) AS 'MIN(Total)'
	FROM Orderdetails;
-- ---------------------------------------------------------------------------------------------------------
-- 5) Find out how many product lines are there for which the buy price value is greater than the average of buy price value. 
--    Show the output as product line and its count.

USE classicmodels;
		SELECT productLine, COUNT(productLine)  AS 'Total'
		FROM products p
		WHERE buyPrice > (SELECT (AVG (buyPrice))
        FROM products p
		WHERE productLine =p.productLine)
        GROUP BY p.productLine 
        ORDER BY COUNT(productLine) DESC;
-- -------------------------------------------------------------------------------------------------------------------------------------
-- day 14
-- Create the table Emp_EH. Below are its fields.
-- ●	EmpID (Primary Key)
-- ●	EmpName
-- ●	EmailAddress
-- Create a procedure to accept the values for the columns in Emp_EH. Handle the error using exception handling concept. 
-- Show the message as “Error occurred” in case of anything wrong.

CREATE DATABASE Emp_EH;
USE Emp_EH;
CREATE TABLE Emp_EH (
        EmpID INT PRIMARY KEY,	
        EmpName VARCHAR(50),
        EmailAddress VARCHAR(50)
        );
INSERT INTO Emp_EH VALUES(1,'Aman','aman@gmail.com');
INSERT INTO Emp_EH VALUES(2,'Ankita','ankita@gmail.com');
SELECT * FROM Emp_EH;

DELIMITER // 
CREATE PROCEDURE EH()
BEGIN

	DECLARE EmpID INT ;
    DECLARE EmpName VARCHAR(50);
    DECLARE EEmailAddress VARCHAR(50);
	
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    SELECT "Error occurred";
    SELECT * FROM Emp_EH;
    INSERT INTO Emp_EH VALUES(A,'Ankita','ankita@gmail.com');

END //
DELIMITER ;   
CALL EH();
SELECT * FROM Emp_EH;
-- --------------------------------------------------------------------------

-- day 15
-- Create the table Emp_BIT. Add below fields in it.
-- ●	Name
-- ●	Occupation
-- ●	Working_date
-- ●	Working_hours
-- Insert the data as shown in below query.
-- INSERT INTO Emp_BIT VALUES
--	('Robin', 'Scientist', '2020-10-04', 12),  
--	('Warner', 'Engineer', '2020-10-04', 10),  
--	('Peter', 'Actor', '2020-10-04', 13),  
--	('Marco', 'Doctor', '2020-10-04', 14),  
--	('Brayden', 'Teacher', '2020-10-04', 12),  
--	('Antonio', 'Business', '2020-10-04', 11);  
/* Create before insert trigger to make sure any new value of
 Working_hours, if it is negative, then it should be inserted as positive.*/

CREATE DATABASE Emp_BIT;
USE Emp_BIT;
CREATE TABLE Emp_BIT (
`Name` VARCHAR(45) NOT NULL,
Occupation VARCHAR(35),
Working_date DATE,
Working_hours VARCHAR(10)
);
INSERT INTO Emp_BIT VALUES
	('Robin', 'Scientist', '2020-10-04', 12),
	('Warner', 'Engineer', '2020-10-04', 10),  
	('Peter', 'Actor', '2020-10-04', 13),  
	('Marco', 'Doctor', '2020-10-04', 14),  
	('Brayden', 'Teacher', '2020-10-04', 12),  
	('Antonio', 'Business', '2020-10-04', 11); 
    SELECT  * FROM Emp_BIT;

DELIMITER // 
CREATE TRIGGER before_insert_Working_hours
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
	BEGIN
    SET NEW.Working_hours =  ABS(NEW.Working_hours);
	END //
DELIMITER //
INSERT INTO Emp_BIT VALUES ('Markus','Leader','2020-10-05',-23);
INSERT INTO Emp_BIT VALUES('AMAN','Data Analyst','2020-10-09', -70);
SELECT  * FROM Emp_BIT;
-- -------------------------------------------------------------------





