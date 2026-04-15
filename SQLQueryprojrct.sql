-- ============================================================
-- Project: Library Database Management System

-- ============================================================



-- ============================================================
-- STEP 1 : CREATE DATABASE
-- ============================================================

CREATE DATABASE LibraryDB;
GO

USE LibraryDB;
GO



-- ============================================================
-- STEP 2 : CREATE TABLES
-- ============================================================



-- ============================================================
-- TABLE 1 : Categories
-- Books classifications
-- ============================================================

CREATE TABLE Categories(

    ID INT PRIMARY KEY IDENTITY(1,1),

    Name VARCHAR(50) NOT NULL,

    Description VARCHAR(200)

);



-- ============================================================
-- TABLE 2 : Books
-- Connected with Categories
-- ============================================================

CREATE TABLE Books(

    ID INT PRIMARY KEY IDENTITY(1,1),

    Title VARCHAR(100) NOT NULL,

    Author VARCHAR(100) NOT NULL,

    Genre VARCHAR(50),

    PublicationYear INT,

    AvailabilityStatus VARCHAR(20),

    CategoryID INT,

    FOREIGN KEY (CategoryID)
    REFERENCES Categories(ID)

);



-- ============================================================
-- TABLE 3 : Members
-- ============================================================

CREATE TABLE Members(

    ID INT PRIMARY KEY IDENTITY(1,1),

    Name VARCHAR(100) NOT NULL,

    ContactInfo VARCHAR(50),

    MembershipType VARCHAR(30)
    CHECK (MembershipType IN ('Student','Teacher','Visitor')),

    RegistrationDate DATE

);



-- ============================================================
-- TABLE 4 : MemberBook
-- Borrowing Table (Many-to-Many)
-- ============================================================

CREATE TABLE MemberBook(

    ID INT PRIMARY KEY IDENTITY(1,1),

    MemberID INT NOT NULL,

    BookID INT NOT NULL,

    BorrowingDate DATE,

    DueDate DATE,

    ReturnDate DATE,

    FOREIGN KEY (MemberID)
    REFERENCES Members(ID),

    FOREIGN KEY (BookID)
    REFERENCES Books(ID)

);



-- ============================================================
-- TABLE 5 : LibraryStaff
-- ============================================================

CREATE TABLE LibraryStaff(

    ID INT PRIMARY KEY IDENTITY(1,1),

    Name VARCHAR(100),

    ContactInfo VARCHAR(50),

    AssignedSection VARCHAR(50),

    EmploymentDate DATE

);



-- ============================================================
-- TABLE 6 : Reservations
-- ============================================================

CREATE TABLE Reservations(

    ID INT PRIMARY KEY IDENTITY(1,1),

    MemberID INT,

    BookID INT,

    ReservationDate DATE,

    Status VARCHAR(30)
    CHECK (Status IN ('Pending','Cancelled','Completed')),

    FOREIGN KEY (MemberID)
    REFERENCES Members(ID),

    FOREIGN KEY (BookID)
    REFERENCES Books(ID)

);



-- ============================================================
-- TABLE 7 : FinancialFines
-- ============================================================

CREATE TABLE FinancialFines(

    ID INT PRIMARY KEY IDENTITY(1,1),

    MemberID INT,

    Amount DECIMAL(10,2),

    PaymentStatus VARCHAR(20)
    CHECK (PaymentStatus IN ('Paid','Unpaid')),

    FOREIGN KEY (MemberID)
    REFERENCES Members(ID)

);



-- ============================================================
-- STEP 3 : INSERT DATA
-- Minimum 5 records each table
-- ============================================================



-- ============================================================
-- Categories
-- ============================================================

INSERT INTO Categories VALUES
('Programming','Coding and software books'),
('Science Fiction','Future and space stories'),
('Fantasy','Magic and adventure stories'),
('Education','Learning resources'),
('History','Historical books');



-- ============================================================
-- Books
-- ============================================================

INSERT INTO Books VALUES
('Database Fundamentals','John Smith','Education',2020,'Available',4),
('SQL for Beginners','David Lee','Programming',2021,'Borrowed',1),
('C# Programming','Ahmed Ali','Programming',2019,'Available',1),
('Harry Potter','J.K Rowling','Fantasy',2005,'Borrowed',3),
('Dune','Frank Herbert','Science Fiction',1965,'Available',2);



-- ============================================================
-- Members
-- ============================================================

INSERT INTO Members VALUES
('Aya','0791111111','Student','2025-01-01'),
('Lina','0792222222','Teacher','2025-02-10'),
('Khaled','0793333333','Visitor','2024-01-07'),
('Sara','0794444444','Student','2024-01-09'),
('Yousef','0795555555','Teacher','2024-03-01');



-- ============================================================
-- MemberBook
-- ============================================================

INSERT INTO MemberBook VALUES
(1,2,'2024-01-02','2024-01-07','2024-01-05'),
(2,3,'2024-01-04','2024-01-08','2024-01-10'),
(3,3,'2024-01-05','2024-01-10',NULL),
(4,5,'2024-01-06','2024-01-11','2024-01-15'),
(5,2,'2024-01-08','2024-01-12','2024-01-10');



-- ============================================================
-- Library Staff
-- ============================================================

INSERT INTO LibraryStaff VALUES
('Mona','0798881111','Science','2020-05-01'),
('Ali','0798882222','Programming','2021-06-10'),
('Rama','0798883333','Children','2022-07-15'),
('Yousef','0798884444','History','2019-03-22'),
('Huda','0798885555','Reception','2023-01-01');



-- ============================================================
-- Reservations
-- ============================================================

INSERT INTO Reservations VALUES
(1,1,'2025-01-02','Pending'),
(2,2,'2025-01-03','Completed'),
(3,3,'2025-01-04','Cancelled'),
(4,5,'2025-01-05','Pending'),
(5,4,'2025-01-06','Completed');



-- ============================================================
-- Financial Fines
-- ============================================================

INSERT INTO FinancialFines VALUES
(1,5.00,'Paid'),
(2,2.50,'Unpaid'),
(3,0.00,'Paid'),
(4,7.00,'Unpaid'),
(5,1.50,'Paid');



-- ============================================================
-- STEP 4 : REQUIRED TASK
-- Add Email Column
-- ============================================================

ALTER TABLE Members
ADD Email VARCHAR(100);



-- ============================================================
-- Insert Omar
-- ============================================================

INSERT INTO Members
(Name,ContactInfo,MembershipType,RegistrationDate,Email)
VALUES
('Omar','9876543210','Student','2024-06-05','Omar@gmail.com');



-- ============================================================
-- STEP 5 : REQUIRED QUERIES
-- ============================================================



-- 1 Members registered on 01-01-2025
SELECT *
FROM Members
WHERE RegistrationDate = '2025-01-01';



-- 2 Book titled Database Fundamentals
SELECT *
FROM Books
WHERE Title = 'Database Fundamentals';



-- 3 Members who made reservations
SELECT DISTINCT M.Name
FROM Members M
JOIN Reservations R
ON M.ID = R.MemberID;



-- 4 Members who borrowed SQL for Beginners
SELECT DISTINCT M.Name
FROM Members M
JOIN MemberBook MB ON M.ID = MB.MemberID
JOIN Books B ON MB.BookID = B.ID
WHERE B.Title = 'SQL for Beginners';



-- 5 Members who borrowed and returned C# Programming
SELECT DISTINCT M.Name
FROM Members M
JOIN MemberBook MB ON M.ID = MB.MemberID
JOIN Books B ON MB.BookID = B.ID
WHERE B.Title = 'C# Programming'
AND MB.ReturnDate IS NOT NULL;



-- 6 Members who returned after due date
SELECT DISTINCT M.Name
FROM Members M
JOIN MemberBook MB ON M.ID = MB.MemberID
WHERE MB.ReturnDate > MB.DueDate;



-- 7 Books borrowed more than 3 times
SELECT B.Title, COUNT(*) AS BorrowCount
FROM Books B
JOIN MemberBook MB ON B.ID = MB.BookID
GROUP BY B.Title
HAVING COUNT(*) > 3;



-- 8 Members borrowed between dates
SELECT DISTINCT M.Name
FROM Members M
JOIN MemberBook MB ON M.ID = MB.MemberID
WHERE MB.BorrowingDate
BETWEEN '2024-01-01' AND '2024-01-10';



-- 9 Count total books
SELECT COUNT(*) AS TotalBooks
FROM Books;



-- ============================================================
-- OPTIONAL QUERIES
-- ============================================================



-- Members borrowed but not returned
SELECT DISTINCT M.Name
FROM Members M
JOIN MemberBook MB ON M.ID = MB.MemberID
WHERE MB.ReturnDate IS NULL;



-- Members borrowed Science Fiction books
SELECT DISTINCT M.Name
FROM Members M
JOIN MemberBook MB ON M.ID = MB.MemberID
JOIN Books B ON MB.BookID = B.ID
JOIN Categories C ON B.CategoryID = C.ID
WHERE C.Name = 'Science Fiction';


