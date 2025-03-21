SELECT user, host, plugin FROM mysql.user WHERE user = 'root';

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Password123';
FLUSH PRIVILEGES;


sudo systemctl restart MySQL
    ---------------------------------------------------------------------------------
Step 1: Create a Database
CREATE DATABASE IF NOT EXISTS testdb;
USE testdb;

Step 2: Create a Table with Integrity Constraints

CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,          -- Primary Key Constraint
    name VARCHAR(100) NOT NULL,       -- NOT NULL Constraint
    email VARCHAR(100) UNIQUE,        -- UNIQUE Constraint
    department_id INT,                -- Foreign Key Constraint
    salary DECIMAL(10,2) CHECK (salary > 0),  -- CHECK Constraint
    hire_date DATE DEFAULT (CURRENT_DATE) -- DEFAULT Constraint (Corrected)
);

Step 3: Insert Valid Data

INSERT INTO Employees (emp_id, name, email, department_id, salary, hire_date)
VALUES (1, 'Alice Johnson', 'alice@example.com', 101, 60000, '2024-01-15');

Step 4: Test NOT NULL Constraint
INSERT INTO Employees (emp_id, name, email, department_id, salary, hire_date)
VALUES (2, NULL, 'bob@example.com', 102, 50000, '2024-02-01');
-- This will fail as 'name' column does not allow NULL values

Step 7: Create a Foreign Key Constraint

CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

ALTER TABLE Employees
ADD CONSTRAINT fk_department FOREIGN KEY (department_id) REFERENCES Departments(dept_id);

--Step 8: Insert Data into Departments and Validate Foreign Key
INSERT INTO Departments (dept_id, dept_name) VALUES (101, 'HR');
INSERT INTO Employees (emp_id, name, email, department_id, salary, hire_date)
VALUES (5, 'Eve Adams', 'eve@example.com', 101, 65000, '2024-05-10');

SELECT * FROM Employees;
SELECT * FROM Departments;

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
#Definition of 2NF: A table is in 2NF if:
It is in 1NF.
All non-key columns entirely depend on the primary key (No partial dependencies).

#Solution:
Separate Students and StudentCourses into different tables.
#Definition of 2NF: A table is in 2NF if:
It is in 1NF.
All non-key columns are fully dependent on the whole primary key (No partial dependencies).

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

Observing the Issue:
In StudentCourses_2NF, the Marks attribute likely depends on both StudentID and Course, but if Course has additional attributes (such as Instructor, Credits), they should be separated.
Course should be an independent entity to avoid redundant data.
Solution:
We separate courses into their own table and use CourseID instead of Course in StudentCourses_2NF.

-- Students Table remains the same
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(50)
);

-- New Course Table to store unique courses
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(50)
);

-- StudentCourses table using CourseID instead of Course Name
CREATE TABLE StudentCourses (
    StudentID INT,
    CourseID INT,
    Marks INT,
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

Normalization Need.
Eliminated transitive dependency: Marks now depends on StudentID and CourseID,
    not on a non-key attribute (CourseName).
Avoids redundancy: Course details are stored separately, making updates efficient.
Meets 3NF: Every non-key attribute is now functionally dependent on the whole primary key and not on
    another non-key attribute.

############################################################################################################
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

###########################################################################
 Step 1: Insert Sample Data into Tables
INSERT INTO Traveler (first_name, last_name, email, phone) VALUES
('Alice', 'Johnson', 'alice@example.com', '1234567890'),
('Bob', 'Smith', 'bob@example.com', '9876543210'),
('Charlie', 'Brown', 'charlie@example.com', '5551234567');

INSERT INTO Trip (traveler_id, trip_name, start_date, end_date) VALUES
(1, 'Summer Vacation to Europe', '2025-06-10', '2025-06-25'),
(2, 'Business Trip to New York', '2025-07-15', '2025-07-20'),
(3, 'Family Holiday to Bali', '2025-08-05', '2025-08-15');


INSERT INTO Destination (name, country, description) VALUES
('Paris', 'France', 'The city of love and fashion.'),
('New York', 'USA', 'The city that never sleeps.'),
('Bali', 'Indonesia', 'A tropical paradise with beautiful beaches.');

INSERT INTO Trip_Destination (trip_id, destination_id) VALUES
(1, 1),  -- Alice goes to Paris
(2, 2),  -- Bob goes to New York
(3, 3);  -- Charlie goes to Bali

INSERT INTO Booking (traveler_id, trip_id, total_amount) VALUES
(1, 1, 2500.00),
(2, 2, 1800.00),
(3, 3, 3200.00);


INSERT INTO Payment (booking_id, amount, payment_method, status) VALUES
(1, 2500.00, 'Credit Card', 'Completed'),
(2, 1800.00, 'PayPal', 'Completed'),
(3, 3200.00, 'Bank Transfer', 'Pending');

INSERT INTO Transportation (transport_type, provider, details) VALUES
('Flight', 'Air France', 'Economy class ticket to Paris'),
('Train', 'Amtrak', 'Business class ticket to New York'),
('Flight', 'Garuda Indonesia', 'First-class ticket to Bali');

INSERT INTO Accommodation (name, location, room_type, price_per_night) VALUES
('Hilton Paris', 'Paris, France', 'Deluxe', 200.00),
('Marriott NYC', 'New York, USA', 'Executive Suite', 300.00),
('Bali Resort', 'Bali, Indonesia', 'Ocean View', 150.00);

INSERT INTO Review (traveler_id, booking_id, rating, comment) VALUES
(1, 1, 5, 'Amazing trip to Paris!'),
(2, 2, 4, 'Great business facilities in NYC.'),
(3, 3, 5, 'Bali was breathtaking!');

2: Fetch Meaningful Travel Insights
Fetch All Travelers Who Have Booked a Trip
SELECT t.first_name, t.last_name, b.booking_id, tr.trip_name 
FROM Traveler t
JOIN Booking b ON t.traveler_id = b.traveler_id
JOIN Trip tr ON b.trip_id = tr.trip_id;


Find the Most Expensive Trip Booked
SELECT t.first_name, t.last_name, tr.trip_name, b.total_amount
FROM Booking b
JOIN Traveler t ON b.traveler_id = t.traveler_id
JOIN Trip tr ON b.trip_id = tr.trip_id
ORDER BY b.total_amount DESC
LIMIT 1;

Retrieve Completed Payments
SELECT p.payment_id, t.first_name, t.last_name, p.amount, p.payment_method, p.status
FROM Payment p
JOIN Booking b ON p.booking_id = b.booking_id
JOIN Traveler t ON b.traveler_id = t.traveler_id
WHERE p.status = 'Completed';

Get the Most Popular Travel Destination
SELECT d.name AS destination, COUNT(td.trip_id) AS total_trips
FROM Trip_Destination td
JOIN Destination d ON td.destination_id = d.destination_id
GROUP BY d.name
ORDER BY total_trips DESC
LIMIT 1;
