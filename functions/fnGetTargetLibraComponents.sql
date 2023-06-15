CREATE FUNCTION dbo.fnGetTargetLibraComponents (@EmailListID INT, @Target INT) RETURNS TABLE AS RETURN (
    WITH TargetComponents_CTE (UniqueID) AS (
        SELECT
            UniqueID
        FROM
            dbo.tblMapTargetInclude (NOLOCK)
        WHERE
            EmailListID = @EmailListID
            AND Target = @Target
        UNION
        SELECT
            UniqueID
        FROM
            dbo.tblMapTargetExclude (NOLOCK)
        WHERE
            EmailListID = @EmailListID
            AND Target = @Target
    )
    SELECT
        DISTINCT TestID,
        TestGroupID
    FROM
        dbo.csn_libra_dbo_tblTestGroup AS TestGroup (NOLOCK)
        INNER JOIN TargetComponents_CTE AS TargetComponents ON (
            TestGroup.TestGroupGuid = TargetComponents.UniqueID
        )
)