CREATE PROCEDURE [dbo].[spLogRunTimeStartProcedure] @ProcedureID INT,
@EmailListID INT = NULL,
@Mailing INT = NULL,
@ExternalUniqueID UNIQUEIDENTIFIER = NULL,
@LogID INT OUTPUT AS BEGIN
SET
    NOCOUNT ON EXEC spCreateExternalUniqueID @InputUniqueID = @Ex ternalUniqueID,
    @OutputUniqueID = @ExternalUniqueID OUTPUT;

DECLARE @ProcedureName NVARCHAR(256);

SELECT
    TOP 1 @ProcedureName = Name
FROM
    tblplProcedures WITH (NOLOCK)
WHERE
    ProcedureID = @ProcedureID;

PRINT 'Starting ' + CAST(@ProcedureName AS VARC HAR(128));

INSERT INTO
    tblLogRunTime (
        ProcedureName,
        ProcedureID,
        EmailListID,
        Mailing,
        StartedDatetime,
        FinishedDatetime,
        ExternalUniqueID
    )
VALUES
    (
        @ProcedureName,
        @ProcedureID,
        @EmailListID,
        @Mailing,
        GETDATE(),
        NULL,
        @ExternalUniqueI D
    );

SELECT
    @LogID = SCOPE_IDENTITY();

END