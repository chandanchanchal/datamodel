-----------------------------------------DWH---------------------------------------Starts----------------------
What is Data Warehousing?
A Data Warehouse (DWH) is a system used for reporting and data analysis. It integrates data from multiple sources and stores historical data for business intelligence.

🔹 Key Characteristics of a Data Warehouse:
✔ Subject-Oriented – Focuses on a specific business area (e.g., Travel).
✔ Integrated – Combines data from multiple sources.
✔ Time-Variant – Stores historical data.
✔ Non-Volatile – Data is read-only, not updated frequently.

Section 2: Travel Domain Data Warehouse
 Business Case: Travel Data Warehouse
A travel agency wants to analyze:

Bookings & Revenue trends.
Popular travel destinations.
Customer behavior (frequent travelers, spending patterns).
 Data Warehouse Schema Approach
Fact Table: Stores measurable business transactions (e.g., Bookings).
Dimension Tables: Store descriptive data (e.g., Traveler, Destination, Payment).
Schema Types:
Star Schema – Simpler structure with direct relationships.
Snowflake Schema – Normalized structure for better data integrity.

Section 3: Designing the Data Warehouse Schema
 Step 1: Identify Fact & Dimension Tables
Fact Table	                    Measures	                        Granularity (1 row per...)
Fact_Booking	                Total amount, booking count	        Booking ID

Dimension Tables	            Attributes
Dim_Traveler	                Traveler Name, Email, Phone
Dim_Destination	                Destination Name, Country, City
Dim_Payment                    	Payment Method, Payment Status
Dim_Date	                    Date, Year, Month, Day
Section 4: Implementing the Data Warehouse in MySQL (Star Schema)
Step 2: Create the Database in DBeaver
Open DBeaver.
Connect to MySQL → Click New Connection → Select MySQL.
Create a new database

CREATE DATABASE TravelDWH;
USE TravelDWH;

Step 3: Create the Dimension Tables
1. Dim_Traveler
CREATE TABLE Dim_Traveler (
    traveler_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20)
);
2. Dim_Destination
CREATE TABLE Dim_Destination (
    destination_id INT PRIMARY KEY AUTO_INCREMENT,
    destination_name VARCHAR(100),
    country VARCHAR(50),
    city VARCHAR(50)
);

3. Dim_Payment
CREATE TABLE Dim_Payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    payment_method ENUM('Credit Card', 'PayPal', 'Bank Transfer'),
    payment_status ENUM('Completed', 'Pending', 'Failed')
);

4. Dim_Date
CREATE TABLE Dim_Date (
    date_id INT PRIMARY KEY AUTO_INCREMENT,
    full_date DATE,
    year INT,
    month INT,
    day INT
);

Step 4: Create the Fact Table (Fact_Booking)
CREATE TABLE Fact_Booking (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    traveler_id INT,
    destination_id INT,
    payment_id INT,
    date_id INT,
    total_amount DECIMAL(10,2),
    booking_count INT,
    FOREIGN KEY (traveler_id) REFERENCES Dim_Traveler(traveler_id),
    FOREIGN KEY (destination_id) REFERENCES Dim_Destination(destination_id),
    FOREIGN KEY (payment_id) REFERENCES Dim_Payment(payment_id),
    FOREIGN KEY (date_id) REFERENCES Dim_Date(date_id)
);

Section 5: Snowflake Schema Optimization
 Step 5: Normalize Dim_Destination for Snowflake Schema

1. Create a Dim_Country Table
CREATE TABLE Dim_Country (
    country_id INT PRIMARY KEY AUTO_INCREMENT,
    country_name VARCHAR(50)
);

2. Modify Dim_Destination
CREATE TABLE Dim_Destination (
    destination_id INT PRIMARY KEY AUTO_INCREMENT,
    destination_name VARCHAR(100),
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES Dim_Country(country_id)
);
