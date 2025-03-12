CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15)
);

CREATE TABLE Programs (
    ProgramID INT PRIMARY KEY,
    ProgramName VARCHAR(100),
    Duration INT -- Duration in years
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    ProgramID INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (ProgramID) REFERENCES Programs(ProgramID)
);

-----------------------------------Insertion----------------------------Starts---------------------------
-- Insert data into Students table
INSERT INTO Students (StudentID, Name, Email, Phone) VALUES
(1, 'Alice Johnson', 'alice.johnson@example.com', '1234567890'),
(2, 'Bob Smith', 'bob.smith@example.com', '0987654321'),
(3, 'Charlie Brown', 'charlie.brown@example.com', '1122334455');

-- Insert data into Programs table
INSERT INTO Programs (ProgramID, ProgramName, Duration) VALUES
(101, 'Computer Science', 4),
(102, 'Mechanical Engineering', 4),
(103, 'Business Administration', 3);

-- Insert data into Enrollments table
INSERT INTO Enrollments (EnrollmentID, StudentID, ProgramID, EnrollmentDate) VALUES
(1, 1, 101, '2024-01-15'),
(2, 2, 102, '2024-02-10'),
(3, 3, 103, '2024-03-05'),
(4, 1, 103, '2024-03-20'); -- A student enrolling in multiple programs


-----------------------------------Insertion----------------------------Ends-----------------------------
-----------------------------------join--query-------------------------starts-------------
SELECT 
    e.EnrollmentID,
    s.StudentID, 
    s.Name AS StudentName, 
    s.Email, 
    s.Phone, 
    p.ProgramID, 
    p.ProgramName, 
    p.Duration AS ProgramDuration, 
    e.EnrollmentDate
FROM Enrollments e
JOIN Students s ON e.StudentID = s.StudentID
JOIN Programs p ON e.ProgramID = p.ProgramID;

-----------------------------------join--query-------------------------ends-------------

-----------------------------------Exercise-------------------------For 1NF-to-2NF-----Starts-------------
Exercise: Normalize the Student_Courses Table to 1NF and 2NF
Given Unnormalized Table (UNF)
#A university stores student enrollment details in the following table:

Student_Courses
+-----------+---------+----------------------+------------+
| StudentID | Name    | Courses              | Instructors|
+-----------+---------+----------------------+------------+
| 201       | Alice   | Math, Physics        | Dr. A, Dr. B|
| 202       | Bob     | Chemistry            | Dr. C      |
| 203       | Charlie | Math, Biology        | Dr. A, Dr. D|
+-----------+---------+----------------------+------------+
Issues:
The Courses column contains multiple values (not atomic).
The Instructors column also contains multiple values.
It violates the First Normal Form (1NF) rule.

Step 1: Convert to First Normal Form (1NF)
Definition of 1NF: A table is in 1NF if:
It has a primary key.
All columns contain atomic (indivisible) values.
There are no repeating groups or arrays.

#Definition of 2NF: A table is in 2NF if:
It is in 1NF.
All non-key columns are fully dependent on the whole primary key (No partial dependencies).
Solution:
Create a separate Students table for student information.
Create a Student_Courses_2NF table for course enrollment details.

######--Solution-----##########################################
Converting the table to 1NF
To bring the table into 1NF, we separate each course into a new row:
CREATE TABLE Students_1NF (
    StudentID INT,
    StudentName VARCHAR(50),
    Course VARCHAR(50),
    Marks INT,
    PRIMARY KEY (StudentID, Course)
);

1NF Table:
StudentID	StudentName	Course	Marks
1	        Alice	    Math	85
1	        Alice	    Science	90
2	        Bob	        Math	78
3	        Charlie	    Science	92
3	        Charlie	    Art	88

#Solution:
Separate Students and StudentCourses into different tables.
CREATE TABLE Students_2NF (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(50)
);

CREATE TABLE StudentCourses_2NF (
    StudentID INT,
    Course VARCHAR(50),
    Marks INT,
    PRIMARY KEY (StudentID, Course),
    FOREIGN KEY (StudentID) REFERENCES Students_2NF(StudentID)
);

1. Understanding 2NF Issues
From our 2NF tables:

Students_2NF Table:
StudentID	StudentName
1	        Alice
2	        Bob
3	        Charlie
StudentCourses_2NF Table:
StudentID	Course	Marks
1	        Math	85
1	        Science	90
2	        Math	78
3	        Science	92
3	        Art	88
Issues in 2NF Table:
Suppose we introduce a Teacher column in the StudentCourses_2NF table:
StudentID	Course	Marks	Teacher
1	        Math	    85	Mr. Smith
1	        Science	    90	Mrs. Davis
2	        Math	    78	Mr. Smith
3	        Science	    92	Mrs. Davis
3	        Art        	88	Mr. Lee
Problem:
Teacher depends on Course, not on StudentID.
This creates a transitive dependency, violating 3NF.

3. Solution: Breaking Transitive Dependency
Separate courses and teachers into a new table (Courses table).
CREATE TABLE Students_3NF (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(50)
);

CREATE TABLE Courses_3NF (
    Course VARCHAR(50) PRIMARY KEY,
    Teacher VARCHAR(50)
);

CREATE TABLE StudentCourses_3NF (
    StudentID INT,
    Course VARCHAR(50),
    Marks INT,
    PRIMARY KEY (StudentID, Course),
    FOREIGN KEY (StudentID) REFERENCES Students_3NF(StudentID),
    FOREIGN KEY (Course) REFERENCES Courses_3NF(Course)
);




-----------------------------------Exercise-------------------------For 1NF-to-2NF-----Ends-------------
-----------------------------------Data Modeling Exercise: Travel Domain-----Starts-------------
Step 1: Conceptual Model (High-Level Design)
Entities & Relationships
In the travel domain, key entities and their relationships can be defined as follows:

Traveler: A person booking trips.
Trip: Represents a journey taken by a traveler.
Destination: Places where trips are made.
Booking: A record of a trip booked by a traveler.
Payment: Details of payments made for bookings.
Transportation: Modes of transport (Flight, Train, Bus, etc.).
Accommodation: Hotels or places travelers stay.
Review: Ratings & feedback by travelers.


Step 2: Logical Model (Detailed Attributes & Relationships)
Now, we define attributes and relationships.

ER Diagram for Travel Domain
One traveler can have many bookings.
One trip can cover multiple destinations.
One booking can have one or more payments.
One booking involves one transportation mode and may have one accommodation.
One traveler can give multiple reviews for different bookings.

Step 3: Physical Model (Table Structure for MySQL)
Tables & Schema Design
1. Traveler (Stores traveler details)
CREATE TABLE Traveler (
    traveler_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

2. Trip (Records trips with start and end dates)
CREATE TABLE Trip (
    trip_id INT PRIMARY KEY AUTO_INCREMENT,
    traveler_id INT,
    trip_name VARCHAR(100),
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (traveler_id) REFERENCES Traveler(traveler_id)
);
3. Destination (Stores travel locations)
CREATE TABLE Destination (
    destination_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    country VARCHAR(50),
    description TEXT
);

4. Trip_Destination (Many-to-Many Relationship Between Trip & Destination)
CREATE TABLE Trip_Destination (
    trip_id INT,
    destination_id INT,
    PRIMARY KEY (trip_id, destination_id),
    FOREIGN KEY (trip_id) REFERENCES Trip(trip_id),
    FOREIGN KEY (destination_id) REFERENCES Destination(destination_id)
);

5. Booking (Links Travelers, Trips, and Accommodations)
CREATE TABLE Booking (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    traveler_id INT,
    trip_id INT,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (traveler_id) REFERENCES Traveler(traveler_id),
    FOREIGN KEY (trip_id) REFERENCES Trip(trip_id)
);

6. Payment (Stores payment details for bookings)
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2),
    payment_method ENUM('Credit Card', 'Debit Card', 'PayPal', 'Bank Transfer'),
    status ENUM('Pending', 'Completed', 'Failed'),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

7. Transportation (Types of travel modes)
CREATE TABLE Transportation (
    transport_id INT PRIMARY KEY AUTO_INCREMENT,
    transport_type ENUM('Flight', 'Train', 'Bus', 'Car Rental'),
    provider VARCHAR(100),
    details TEXT
);

8. Accommodation (Hotels, stays linked to bookings)
CREATE TABLE Accommodation (
    accommodation_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    location VARCHAR(100),
    room_type VARCHAR(50),
    price_per_night DECIMAL(10,2)
);

9. Review (Traveler feedback on bookings)
CREATE TABLE Review (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    traveler_id INT,
    booking_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (traveler_id) REFERENCES Traveler(traveler_id),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

Step 4: Implementing in DBeaver
Steps to Follow in DBeaver
Connect to MySQL in DBeaver

Open DBeaver.
Click Database → New Connection → MySQL.
Enter MySQL host, port, username, password.
Click Finish.
Create a New Database
CREATE DATABASE TravelDB;
USE TravelDB;

Execute Table Creation Queries

Copy & Paste the SQL scripts provided above into DBeaver’s SQL Editor.
Click Run to execute.
Verify Table Structure

Go to Database Navigator in DBeaver.
Expand TravelDB to view tables.
Insert Sample Data (For Exercise)
INSERT INTO Traveler (first_name, last_name, email, phone)
VALUES ('Alice', 'Brown', 'alice@example.com', '1234567890');

INSERT INTO Destination (name, country, description)
VALUES ('Paris', 'France', 'City of Light and Romance');

INSERT INTO Trip (traveler_id, trip_name, start_date, end_date)
VALUES (1, 'Europe Tour', '2025-06-01', '2025-06-15');

INSERT INTO Trip_Destination (trip_id, destination_id)
VALUES (1, 1);
Run Queries to Fetch Data
Example: Get all bookings with traveler details
SELECT b.booking_id, t.first_name, t.last_name, tr.trip_name, b.booking_date, b.total_amount
FROM Booking b
JOIN Traveler t ON b.traveler_id = t.traveler_id
JOIN Trip tr ON b.trip_id = tr.trip_id;

Step 3: ER Diagram Explanation
Traveler → Trip (1:N)
A traveler can take multiple trips.
Trip → Trip_Destination (1:N)
A trip can include multiple destinations.
Destination → Trip_Destination (1:N)
A destination can be part of multiple trips.
Traveler → Booking (1:N)
A traveler can make multiple bookings.
Booking → Payment (1:N)
A booking can have multiple payments.
Booking → Transportation (1:1)

A booking is linked to one transportation mode.
Booking → Accommodation (1:1)

A booking may include accommodation.
Traveler → Review (1:N)

A traveler can give multiple reviews for different bookings.

CREATE INDEX idx_traveler_phone ON Traveler(phone);




-----------------------------------Data Modeling Exercise: Travel Domain-----Ends-------------

use travelDB

db.destinations.insertMany([
  {
    "city": "Paris",
    "country": "France",
    "attractions": ["Eiffel Tower", "Louvre Museum"],
    "average_cost": 1500,
    "rating": 4.8
  },
  {
    "city": "New York",
    "country": "USA",
    "attractions": ["Statue of Liberty", "Times Square"],
    "average_cost": 2000,
    "rating": 4.7
  },
  {
    "city": "Tokyo",
    "country": "Japan",
    "attractions": ["Shibuya Crossing", "Mount Fuji"],
    "average_cost": 1800,
    "rating": 4.9
  }
]);

###########################################################################################
4. Query Data for Meaningful Insights

4.1 Fetch all destinations:

db.destinations.find().pretty()

4.2 Find destinations in a specific country:

db.destinations.find({ "country": "France" }).pretty()

4.3 Find destinations with a rating above 4.7:

db.destinations.find({ "rating": { $gt: 4.7 } }).pretty()

4.4 Find destinations that include a specific attraction:

db.destinations.find({ "attractions": "Eiffel Tower" }).pretty()

4.5 Sort destinations by rating in descending order:

db.destinations.find().sort({ "rating": -1 }).pretty()

4.6 Calculate the average cost of travel to all destinations:
db.destinations.aggregate([
  {
    $group: {
      _id: null,
      avgCost: { $avg: "$average_cost" }
    }
  }
]);
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


INSERT INTO Dim_Traveler (full_name, email, phone)
VALUES ('Alice Johnson', 'alice@example.com', '1234567890');

INSERT INTO Dim_Destination (destination_name, country, city)
VALUES ('Paris', 'France', 'Paris');

INSERT INTO Dim_Payment (payment_method, payment_status)
VALUES ('Credit Card', 'Completed');

INSERT INTO Dim_Date (full_date, year, month, day)
VALUES ('2025-06-15', 2025, 6, 15);

INSERT INTO Fact_Booking (traveler_id, destination_id, payment_id, date_id, total_amount, booking_count)
VALUES (1, 1, 1, 1, 1200.00, 1);

Section 7: Querying the Data Warehouse
1. Total Revenue by Destination

SELECT d.destination_name, SUM(f.total_amount) AS total_revenue
FROM Fact_Booking f
JOIN Dim_Destination d ON f.destination_id = d.destination_id
GROUP BY d.destination_name;

2. Most Popular Travel Destinations
SELECT d.destination_name, COUNT(f.booking_id) AS total_bookings
FROM Fact_Booking f
JOIN Dim_Destination d ON f.destination_id = d.destination_id
GROUP BY d.destination_name
ORDER BY total_bookings DESC
LIMIT 5;

3. Total Bookings by Month
SELECT dt.year, dt.month, COUNT(f.booking_id) AS total_bookings
FROM Fact_Booking f
JOIN Dim_Date dt ON f.date_id = dt.date_id
GROUP BY dt.year, dt.month;




-----------------------------------------DWH---------------------------------------Ends----------------------


