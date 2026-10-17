/*
4.2 Relation schema:
Department (DeptNo, DeptName)
Lecturer (LecturerID, LecturerName, DeptNo*)
Student (StudentID, StudentName, DoB, Major)
Course (CourseID, CourseName)
LecturerPhone (LecturerID*, Phone)
Register (StudentID*, CourseID*, Grade)
Teach (CourseID*, LecturerID*)

Lecturer[DeptNo]     ⊆ Department[DeptNo]
Register[StudentID]  ⊆ Student[StudentID]
Register[CourseID]   ⊆ Course[CourseID]
*/

DROP DATABASE IF EXISTS CourseManagement;

CREATE DATABASE CourseManagement;

USE CourseManagement;

SELECT DATABASE();

CREATE TABLE Department (
    DeptNo CHAR(4) NOT NULL,
    DeptName VARCHAR(60) NOT NULL,
    CONSTRAINT PK_Department PRIMARY KEY (DeptNo),
    CONSTRAINT UQ_Department Unique (DeptName)
) ENGINE=InnoDB;

CREATE TABLE Student (
    StudentID CHAR(10) NOT NULL,
    StudentName VARCHAR(60) NOT NULL,
    DoB DATE NOT NULL,
    Major VARCHAR(40) NULL,

    CONSTRAINT PK_Student PRIMARY KEY (StudentID),
    CONSTRAINT CHK_Student_DoB CHECK (DoB <= '2026-12-31')
) ENGINE=InnoDB;

CREATE TABLE Lecturer (
    LecturerID CHAR(10) NOT NULL,
    LecturerName VARCHAR(60) NOT NULL,
    DeptNo CHAR(4) NOT NULL,

    CONSTRAINT PK_LecturerID PRIMARY KEY (LecturerID),

    CONSTRAINT FK_Department FOREIGN KEY (DeptNo)
        REFERENCES Department(DeptNo)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Course (
    CourseID CHAR(10) NOT NULL,
    CourseName VARCHAR(60) NOT NULL,

    CONSTRAINT PK_Course PRIMARY KEY (CourseID)
) ENGINE=InnoDB;

CREATE TABLE Register (
    CourseID CHAR(10) NOT NULL,
    StudentID CHAR(10) NOT NULL,
    Grade DECIMAL(4,2) NULL,
 
    CONSTRAINT PK_Register PRIMARY KEY (StudentID, CourseID),
    CONSTRAINT FK_Register_Student FOREIGN KEY (StudentID)
    REFERENCES Student (StudentID)
    ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT FK_Register_Course FOREIGN KEY (CourseID)
    REFERENCES Course (CourseID),

    CONSTRAINT CK_Register_Grade CHECK (Grade BETWEEN 0 AND 100)
) ENGINE=InnoDB;

CREATE TABLE Teach (
    LecturerID CHAR(10) NOT NULL,
    CourseID CHAR(10) NOT NULL,

    CONSTRAINT PK_Teach PRIMARY KEY (LecturerID, CourseID),

    CONSTRAINT FK_Teach_Lecturer FOREIGN KEY (LecturerID)
    REFERENCES Lecturer (LecturerID)
    ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT FK_Teach_Course FOREIGN KEY (CourseID)
    REFERENCES Course (CourseID)
) ENGINE=InnoDB;

CREATE TABLE LecturerPhone (
    Phone VARCHAR(11) NOT NULL,
    LecturerID CHAR(10) NOT NULL,

    CONSTRAINT PK_LecturerPhone PRIMARY KEY (Phone, LecturerID),

    CONSTRAINT FK_LecturerPhone_Lecturer FOREIGN KEY (LecturerID)
    REFERENCES Lecturer (LecturerID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE VIEW StudentWithAge AS
SELECT 
    StudentID,
    StudentName,
    DoB,
    Major,
    TIMESTAMPDIFF(YEAR, DoB, CURDATE()) AS Age
FROM Student;

INSERT INTO Department (DeptNo, DeptName) VALUES
('MATH', 'Department of Mathematics'),
('CS01', 'Computer Science and Engineering'),
('FIN0', 'Finance and Risk Management');

INSERT INTO Student (StudentID, StudentName, DoB, Major) VALUES
('STU0000001', 'Nguyen Van An', '2004-03-15', 'Applied Mathematics'),
('STU0000002', 'Tran Thi Bich', '2004-07-22', 'Computer Science'),
('STU0000003', 'Le Hoang Cuong', '2003-11-05', 'Financial Engineering'),
('STU0000004', 'Pham Minh Dung', '2005-01-18', 'Applied Mathematics'),
('STU0000005', 'Vo Ngoc Ha', '2004-09-30', 'Data Science'),
('STU0000006', 'Dang Quoc Khanh', '2003-05-12', 'Computer Science'),
('STU0000007', 'Bui Thu Lan', '2004-12-08', 'Financial Engineering'),
('STU0000008', 'Doan Thanh Nam', '2005-04-25', 'Applied Mathematics');

INSERT INTO Course (CourseID, CourseName) VALUES
('MATH101', 'Linear Algebra'),
('MATH102', 'Multivariable Calculus'),
('CS201', 'Database Systems'),
('CS202', 'Data Structures and Algorithms'),
('FIN301', 'Quantitative Risk Modeling');

INSERT INTO Lecturer (LecturerID, LecturerName, DeptNo) VALUES
('LEC01', 'Nguyen Duc Toan', 'MATH'),
('LEC02', 'Le Xuan Hai', 'CS01'),
('LEC03', 'Pham Minh Tri', 'FIN0'),
('LEC04', 'Tran Bao Yen', 'MATH'),
('LEC05', 'Vo Van Kiet', 'CS01');

INSERT INTO LecturerPhone (LecturerID, Phone) VALUES
('LEC01', '0903123456'),
('LEC01', '0918123456'),
('LEC02', '0987654321'),
('LEC03', '0933456789'),
('LEC03', '0908889999');

INSERT INTO Register (StudentID, CourseID, Grade) VALUES
('STU0000001', 'MATH101', 88.50),
('STU0000001', 'CS201', 92.00),
('STU0000002', 'CS201', 85.00),
('STU0000002', 'CS202', 78.50),
('STU0000003', 'FIN301', 90.00),
('STU0000003', 'MATH101', 81.00),
('STU0000004', 'MATH102', 75.00),
('STU0000004', 'CS201', 84.00),
('STU0000005', 'CS201', 95.50),
('STU0000006', 'CS202', 89.00),
('STU0000007', 'FIN301', 86.50),
('STU0000008', 'MATH101', 79.00);

INSERT INTO Teach (CourseID, LecturerID) VALUES
('MATH101', 'LEC01'),
('MATH102', 'LEC04'),
('CS201', 'LEC02'),
('CS202', 'LEC05'),
('FIN301', 'LEC03');