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
