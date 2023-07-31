USE AdventureWorks2022;
GO

IF OBJECT_ID('HumanResources.EmployeeHireDate', 'V') IS NOT NULL
    DROP VIEW HumanResources.EmployeeHireDate;
GO


USE AdventureWorks2022;
GO

DROP VIEW IF EXISTS HumanResources.EmployeeHireDate;
GO