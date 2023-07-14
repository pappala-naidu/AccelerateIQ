CREATE FUNCTION dbo.fnIsTestActive(
    _TestID INT,
    _Date DATE = NULL
) RETURNS TABLE AS
RETURN (
    WITH Date_CTE (InputDate) AS (
        SELECT
            CAST(
                COALESCE(_Date, CAST(CURRENT_TIMESTAMP AS DATE)) AS TIMESTAMP
            ) AS InputDate
    ),
    IsActive_CTE (IsActive) AS (
        SELECT
            TOP 1 1
        FROM
            dbo.csn_libra_dbo_tblTest AS Test WITH(NOLOCK)
            CROSS JOIN Date_CTE
        WHERE
            Test.TestId = _TestId
            AND Test.TestLaunched IS NOT NULL
            AND Test.TestCancelled IS NULL
            AND Date_CTE.InputDate BETWEEN Test.TestStart
            AND Test.TestEnd
    )
    SELECT
        CAST(COUNT(*) AS BIT) AS IsActive
    FROM
        IsActive_CTE
);