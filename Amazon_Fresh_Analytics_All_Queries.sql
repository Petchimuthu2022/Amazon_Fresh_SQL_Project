-- Amazon Fresh Analytics SQL Queries
-- Task 3: Write a query to:  
○ Retrieve all customers from a specific city.  
○ Fetch all products under the "Fruits" category.  

SELECT * FROM customers WHERE City='South James';
SELECT * FROM products WHERE Category='Fruits';

---ask 4: Write DDL statements to recreate the Customers table with the following  constraints:  
○ CustomerID as the primary key.  
○ Ensure Age cannot be null and must be greater than 18.  
○ Add a unique constraint for Name.  

CREATE TABLE Customers(
CustomerID INT PRIMARY KEY,
Name VARCHAR(100) UNIQUE,
City VARCHAR(50),
Age INT NOT NULL CHECK(Age>18),
PrimeMember VARCHAR(10));

---Task 5:Insert 3 new rows into the Products table using INSERT statements.

INSERT INTO products(ProductID,ProductName,Category,Subcategory,PricePerUnit,StockQuantity,SupplierID)
VALUES
(201,'Milk','Dairy','Fresh Milk',60,100,1),
(202,'Apple Juice','Beverages','Juice',120,80,2),
(203,'Brown Bread','Bakery','Bread',45,150,3);

---Task 6: Update the stock quantity of a product where ProductID matches a specific ID.  
UPDATE products SET StockQuantity=250 WHERE ProductID=201;

● Task 7: Delete a supplier from the Suppliers table where their city matches a specific  value.  
DELETE FROM suppliers WHERE SupplierID=10;

---● Task 8: Use SQL constraints to:  
○ Add a CHECK constraint to ensure that ratings in the Reviews table are  between 1 and 5.  

ALTER TABLE Reviews ADD CONSTRAINT chk_rating CHECK(Rating BETWEEN 1 AND 5);

--○ Add a DEFAULT constraint for the PrimeMember column in the Customers  table (default value: "No").  
ALTER TABLE Customers MODIFY PrimeMember VARCHAR(10) DEFAULT 'No';

---● Task 9: Write queries using:  
○ WHERE clause to find orders placed after 2024-01-01.  
○ HAVING clause to list products with average ratings greater than 4.  ○ GROUP BY and ORDER BY clauses to rank products by total sales.  

SELECT * FROM Orders WHERE OrderDate>'2024-01-01';
SELECT ProductID,AVG(Rating) as AverageRating FROM Reviews GROUP BY ProductID HAVING AVG(Rating)>4;

SELECT ProductID,SUM(unitprice) as TotalSales FROM Order_Details GROUP BY ProductID ORDER BY TotalSales DESC;

SELECT c.CustomerID,c.Name,SUM(o.orderAmount) as TotalSpending
FROM Customers as c JOIN Orders as o 
ON c.CustomerID=o.CustomerID
GROUP BY c.CustomerID,c.Name HAVING SUM(o.orderAmount)>5000 ORDER BY TotalSpending DESC;

---Join the Orders and OrderDetails tables to calculate total revenue per order.  
SELECT o.OrderID,SUM(od.UnitPrice * od.quantity) AS TotalRevenue
FROM Orders as o JOIN Order_Details as od
    ON o.OrderID = od.OrderID
GROUP BY o.OrderID;

--Identify customers who placed the most orders in a specific time period.  
SELECT CustomerID,COUNT(OrderID) as OrdersPlaced FROM Orders GROUP BY CustomerID ORDER BY OrdersPlaced DESC;

--Find the supplier with the most products in stock.  
SELECT SupplierID,SUM(StockQuantity) as TotalStock FROM Products GROUP BY SupplierID ORDER BY TotalStock limit 1;

----Task 12: Normalize the Products table to 3NF:  
○ Separate product categories and subcategories into a new table.  
○ Create foreign keys to maintain relationships.  

CREATE TABLE Categories(CategoryID INT PRIMARY KEY,CategoryName VARCHAR(50),SubCategory VARCHAR(50));
ALTER TABLE Products ADD CategoryID INT;
ALTER TABLE Products ADD CONSTRAINT fk_category FOREIGN KEY(CategoryID) REFERENCES Categories(CategoryID);

---Task 13: Write a subquery to:  
○ Identify the top 3 products based on sales revenue.  
○ Find customers who haven’t placed any orders yet

SELECT ProductID,SUM(unitprice) as Revenue FROM Order_Details GROUP BY ProductID ORDER BY Revenue DESC LIMIT 3;
SELECT * FROM Customers WHERE CustomerID NOT IN (SELECT CustomerID FROM Orders);

--● Task 14: Provide actionable insights:  
○ Which cities have the highest concentration of Prime members?  
○ What are the top 3 most frequently ordered categories?  

SELECT City,COUNT(*) PrimeMembers FROM Customers WHERE PrimeMember='Yes' GROUP BY City ORDER BY PrimeMembers DESC;
SELECT p.Category,COUNT(*) as TotalOrders FROM Order_Details as od 
JOIN Products as p 
ON od.ProductID=p.ProductID GROUP BY p.Category ORDER BY TotalOrders DESC LIMIT 3;
