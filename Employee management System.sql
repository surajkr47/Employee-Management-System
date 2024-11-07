CREATE DATABASE Employees;
USE Employees;
CREATE TABLE Employees (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Salary DECIMAL(10, 2),
    HireDate DATE
);
DELIMITER //
CREATE PROCEDURE AddEmployee(
    IN p_FirstName VARCHAR(50),
    IN p_LastName VARCHAR(50),
    IN p_Salary DECIMAL(10, 2),
    IN p_HireDate DATE
)
BEGIN
    INSERT INTO Employees (FirstName, LastName, Salary, HireDate)
    VALUES (p_FirstName, p_LastName, p_Salary, p_HireDate);
END //

DELIMITER ;
CREATE TABLE SalaryChangeLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID INT,
    OldSalary DECIMAL(10, 2),
    NewSalary DECIMAL(10, 2),
    ChangeDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
DELIMITER //

CREATE TRIGGER BeforeSalaryUpdate
BEFORE UPDATE ON Employees
FOR EACH ROW
BEGIN
    IF OLD.Salary <> NEW.Salary THEN
        INSERT INTO SalaryChangeLog (EmployeeID, OldSalary, NewSalary)
        VALUES (OLD.EmployeeID, OLD.Salary, NEW.Salary);
    END IF;
END //

DELIMITER ;
CALL AddEmployee('Indu', 'Sharma', 60000, '2024-11-01');
CALL AddEmployee('Suraj', 'Kumar', 50000, '2024-11-02');
UPDATE Employees SET Salary = 65000 WHERE FirstName = 'Indu' AND LastName = 'Sharma';
UPDATE Employees SET Salary = 55000 WHERE FirstName = 'Suraj' AND LastName = 'Kumar';
SELECT * FROM SalaryChangeLog;
