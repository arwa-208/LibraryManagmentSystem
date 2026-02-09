CREATE DATABASE LibraryDBS;
USE LibraryDBS;

CREATE TABLE Library (
    LibraryID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE,
    Location VARCHAR(100) NOT NULL,
    ContactNumber VARCHAR(20) NOT NULL,
    EstablishedYear INT
);

CREATE TABLE Book (
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    ISBN VARCHAR(20) NOT NULL UNIQUE,
    Title VARCHAR(150) NOT NULL,
    Genre VARCHAR(20) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    IsAvailable BIT DEFAULT 1,
    ShelfLocation VARCHAR(50) NOT NULL,
    LibraryID INT NOT NULL,

    CONSTRAINT FK_Book_Library 
        FOREIGN KEY (LibraryID) 
        REFERENCES Library(LibraryID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

	CONSTRAINT CK_Book_Genre 
        CHECK (Genre IN ('Fiction','Non-fiction','Reference','Children')),

    CONSTRAINT CK_Book_Price 
        CHECK (Price > 0)
);

CREATE TABLE Member (
    MemberID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PhoneNumber VARCHAR(20),
    MembershipStartDate DATE NOT NULL
);

CREATE TABLE Staff (
    StaffID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Position VARCHAR(50),
    ContactNumber VARCHAR(20),
    LibraryID INT NOT NULL,

    CONSTRAINT FK_Staff_Library 
        FOREIGN KEY (LibraryID) 
        REFERENCES Library(LibraryID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Loan (
    LoanID INT IDENTITY(1,1) PRIMARY KEY,
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    LoanDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    ReturnDate DATE NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'Issued',

    CONSTRAINT FK_Loan_Member 
        FOREIGN KEY (MemberID) 
        REFERENCES Member(MemberID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
   CONSTRAINT FK_Loan_Book 
        FOREIGN KEY (BookID) 
        REFERENCES Book(BookID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT CK_Loan_Status 
        CHECK (Status IN ('Issued','Returned','Overdue')),

    CONSTRAINT CK_ReturnDate 
        CHECK (ReturnDate IS NULL OR ReturnDate >= LoanDate)
);

CREATE TABLE Payment (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    LoanID INT NOT NULL,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    Method VARCHAR(30),

    CONSTRAINT FK_Payment_Loan 
        FOREIGN KEY (LoanID) 
        REFERENCES Loan(LoanID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT CK_Payment_Amount 
        CHECK (Amount > 0)
);

CREATE TABLE Review (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    ReviewDate DATE NOT NULL,
    Rating INT NOT NULL,
    Comments VARCHAR(255) DEFAULT 'No comments',

    CONSTRAINT FK_Review_Member 
        FOREIGN KEY (MemberID) 
        REFERENCES Member(MemberID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
CONSTRAINT FK_Review_Book 
        FOREIGN KEY (BookID) 
        REFERENCES Book(BookID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT CK_Review_Rating 
        CHECK (Rating BETWEEN 1 AND 5)
);

INSERT INTO Library (Name, Location, ContactNumber, EstablishedYear) VALUES
('Central Library','Muscat','+96890001111',1995),
('City Library','Seeb','+96890002222',2000),
('Knowledge Hub','Bawshar','+96890003333',2010),
('National Library','Muttrah','+96890004444',1980),
('Community Library','Al Amerat','+96890005555',2015),
('University Library','SQU','+96890006666',1998),
('Digital Library','Azaiba','+96890007777',2022),
('Kids Library','Qurum','+96890008888',2018),
('Science Library','Ghala','+96890009999',2005),
('Public Library','Ruwi','+96890001010',1990);

INSERT INTO Book (ISBN, Title, Genre, Price, ShelfLocation, LibraryID) VALUES
('ISBN-1001','The Great Story','Fiction',5.5,'A1',1),
('ISBN-1002','Science Basics','Non-fiction',7.0,'B2',1),
('ISBN-1003','World Atlas','Reference',10.0,'C3',2),
('ISBN-1004','Kids Fairy Tales','Children',4.5,'D1',2),
('ISBN-1005','Space Adventure','Fiction',6.0,'A2',3),
('ISBN-1006','History 101','Non-fiction',8.0,'B3',3),
('ISBN-1007','Dictionary','Reference',12.0,'C1',4),
('ISBN-1008','Animal Stories','Children',5.0,'D2',4),
('ISBN-1009','Mystery Book','Fiction',6.5,'A3',5),
('ISBN-1010','Math Guide','Non-fiction',9.0,'B1',5);

INSERT INTO Member (FullName, Email, PhoneNumber, MembershipStartDate) VALUES
('Ali Ahmed','ali1@email.com','90000001','2023-01-10'),
('Sara Khalid','sara2@email.com','90000002','2023-02-15'),
('Omar Saleh','omar3@email.com','90000003','2023-03-20'),
('Mona Hassan','mona4@email.com','90000004','2023-04-05'),
('Yousef Ali','yousef5@email.com','90000005','2023-05-10'),
('Aisha Noor','aisha6@email.com','90000006','2023-06-12'),
('Khaled Nasser','khaled7@email.com','90000007','2023-07-01'),
('Fatima Said','fatima8@email.com','90000008','2023-08-18'),
('Hassan Omar','hassan9@email.com','90000009','2023-09-09'),
('Layla Ahmed','layla10@email.com','90000010','2023-10-10');

INSERT INTO Staff (FullName, Position, ContactNumber, LibraryID) VALUES
('Ahmed Manager','Manager','90011111',1),
('Sara Assistant','Assistant','90022222',1),
('Omar Librarian','Librarian','90033333',2),
('Mona Clerk','Clerk','90044444',2),
('Yousef Supervisor','Supervisor','90055555',3),
('Aisha Staff','Staff','90066666',3),
('Khaled Worker','Worker','90077777',4),
('Fatima Admin','Admin','90088888',4),
('Hassan Guard','Security','90099999',5),
('Layla Helper','Helper','90010101',5);

INSERT INTO Loan (MemberID, BookID, LoanDate, DueDate, ReturnDate, Status) VALUES
(1,1,'2024-01-01','2024-01-10','2024-01-08','Returned'),
(2,2,'2024-01-05','2024-01-15',NULL,'Issued'),
(3,3,'2024-01-07','2024-01-17','2024-01-20','Overdue'),
(4,4,'2024-02-01','2024-02-10','2024-02-09','Returned'),
(5,5,'2024-02-05','2024-02-15',NULL,'Issued'),
(6,6,'2024-02-07','2024-02-17','2024-02-16','Returned'),
(7,7,'2024-03-01','2024-03-10','2024-03-12','Overdue'),
(8,8,'2024-03-05','2024-03-15',NULL,'Issued'),
(9,9,'2024-03-07','2024-03-17','2024-03-16','Returned'),
(10,10,'2024-03-10','2024-03-20',NULL,'Issued');

INSERT INTO Payment (LoanID, PaymentDate, Amount, Method) VALUES
(1,'2024-01-09',2.5,'Cash'),
(2,'2024-01-16',3.0,'Card'),
(3,'2024-01-21',5.0,'Cash'),
(4,'2024-02-10',2.0,'Online'),
(5,'2024-02-16',4.5,'Cash'),
(6,'2024-02-18',1.5,'Card'),
(7,'2024-03-11',6.0,'Cash'),
(8,'2024-03-16',3.5,'Online'),
(9,'2024-03-18',2.2,'Cash'),
(10,'2024-03-21',4.0,'Card');


INSERT INTO Review (MemberID, BookID, ReviewDate, Rating, Comments) VALUES
(1,1,'2024-01-09',5,'Excellent book'),
(2,2,'2024-01-16',4,'Very useful'),
(3,3,'2024-01-21',3,'Good but long'),
(4,4,'2024-02-10',5,'Kids loved it'),
(5,5,'2024-02-16',4,'Nice story'),
(6,6,'2024-02-18',2,'Difficult'),
(7,7,'2024-03-11',5,'Perfect reference'),
(8,8,'2024-03-16',4,'Fun book'),
(9,9,'2024-03-18',3,'Okay'),
(10,10,'2024-03-21',5,'Amazing');