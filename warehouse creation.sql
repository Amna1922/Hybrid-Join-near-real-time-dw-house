
DROP DATABASE IF EXISTS walmart;
CREATE DATABASE walmart;
USE walmart;

CREATE TABLE DimCustomer (
	Customer_ID INT PRIMARY KEY,
	Gender VARCHAR(10),
	Age VARCHAR(10),           
	Occupation VARCHAR(50),    
	City_Category VARCHAR(10), 
	Stay_In_Current_City_Years VARCHAR(10),
	Marital_Status INT 
);

 CREATE TABLE DimProduct (
	Product_ID VARCHAR(10) PRIMARY KEY,
	Product_Category VARCHAR(50),
	Price float,
	StoreID INT,
	SupplierID INT,
	StoreName VARCHAR(100),
	SupplierName VARCHAR(100)
);

 CREATE TABLE DimDate (
	Date_ID DATE PRIMARY KEY,
	Year INT,
	Month INT,
	Day INT,
	Weekday_Name VARCHAR(20),
	Is_Weekend TINYINT(1),
	Quarter INT
);

 CREATE TABLE FactSales (
	Sales_ID INT AUTO_INCREMENT PRIMARY KEY,
	-- Core transactional data
	Customer_ID INT,
	Product_ID VARCHAR(10),
	Order_ID INT,
	Date_ID DATE,
	Quantity INT,
	
	Gender VARCHAR(10),
	Age VARCHAR(10),
	Occupation VARCHAR(50),
	City_Category VARCHAR(10),
	Stay_In_Current_City_Years VARCHAR(10),
	Marital_Status INT,
	
	Product_Category VARCHAR(50),
	Price DECIMAL(10,2),
	StoreID INT,
	StoreName VARCHAR(100),
	SupplierID INT,
	SupplierName VARCHAR(100),
	
	Total_Amount DECIMAL(10,2),
	
	FOREIGN KEY (Customer_ID) REFERENCES DimCustomer(Customer_ID),
	FOREIGN KEY (Product_ID) REFERENCES DimProduct(Product_ID),
	FOREIGN KEY (Date_ID) REFERENCES DimDate(Date_ID)
);


