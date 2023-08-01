SELECT TOP 1 [NumberOfConnections]
FROM 
    (SELECT TOP 3 [NumberOfConnections]
     FROM [mssql_to_pgsql_pgloader].[dbo].[activeuserconnections] 
     ORDER BY[NumberOfConnections] DESC ) AS Comp 
ORDER BY [NumberOfConnections];
