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



-----------------------------------Exercise-------------------------For 1NF-to-2NF-----Ends-------------


