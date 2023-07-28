"SELECT TOP (1000) [DBName]
  ,[NumberOfConnections]
  ,[LoginName]
  FROM [mssql_to_pgsql_pgloader].[dbo].[activeuserconnections];
 
 CREATE PROCEDURE uspFindProducts
 AS
 BEGIN
  SELECT
  [DBName]
  ,[NumberOfConnections]
  ,[LoginName]
  FROM 
  [mssql_to_pgsql_pgloader].[dbo].[activeuserconnections]
  ORDER BY
  [NumberOfConnections];
 END;
 
 ALTER PROCEDURE uspFindProducts(@min_list_price AS DECIMAL)
 AS
 BEGIN
  update [mssql_to_pgsql_pgloader].[dbo].[activeuserconnections]
  set [numberofconnections] = [numberofconnections]+1
  where [numberofconnections]<@min_list_price;
  
  update [mssql_to_pgsql_pgloader].[dbo].[activeuserconnections]
  set [numberofconnections] = [numberofconnections]-1
  where [numberofconnections]<@min_list_price;
  
 END;
 
 
 EXEC uspFindProducts 5;
 
 SELECT TOP (1000) [DBName]
  ,[NumberOfConnections]
  ,[LoginName]
  FROM [mssql_to_pgsql_pgloader].[dbo].[activeuserconnections];"
