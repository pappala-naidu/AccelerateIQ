USE AdventureWorks2022;
GO

CREATE VIEW HumanResources.EmployeeHireDate
AS
SELECT p.FirstName,
    p.LastName,
    e.HireDate
FROM HumanResources.Employee AS e
INNER JOIN Person.Person AS p
    ON e.BusinessEntityID = p.BusinessEntityID;
GO

-- Query the view
SELECT FirstName,
    LastName,
    HireDate
FROM HumanResources.EmployeeHireDate
ORDER BY LastName;
GO