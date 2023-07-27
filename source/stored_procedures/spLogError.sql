SET
  ANSI_NULLS ON
GO
SET
  QUOTED_IDENTIFIER ON
GO
  ALTER PROCEDURE [dbo].[spLogError] @EmailListID INT = NULL,
  @Mailing INT = NULL,
  @ExternalUniqueID UNIQUEIDENTIFIER = NULL,
  @Comment VARCHAR(256) = NULL,
  @LogID INT = NULL OUTPUT AS BEGIN
SET
  NOCOUNT ON BEGIN TRY EXEC spCreateExternalUniqueID @InputUniqueID = @ExternalUniqueID,
  @OutputUniqueID = @ExternalUniqueID OUTPUT;

DECLARE @ProcedureID INT = NULL;

SELECT
  TOP (1) @ProcedureID = ProcedureID
FROM
  tblplProcedures WITH (NOLOCK)
WHERE
  Name = ERROR_PROCEDURE();

PRINT FORMATMESSAGE(
  '%s - %s',
  CONVERT(VARCHAR(100), GETDATE(), 21),
  ERROR_MESSAGE()
);

PRINT FORMATMESSAGE(
  '    in %s at line %d. Error # %d, state %d, severity %d.',
  ERROR_PROCEDURE(),
  ERROR_LINE(),
  ERROR_NUMBER(),
  ERROR_STATE(),
  ERROR_SEVERITY()
);

END TRY BEGIN CATCH
END CATCH;

INSERT INTO
  tblLogError(
    ErrorDateTime,
    Message,
    ProcedureName,
    Line,
    ErrorNumber,
    Severity,
    State,
    EmailListID,
    Mailing,
    ExternalUniqueID,
    ProcedureID,
    Comment
  )
VALUES
  (
    SYSDATETIME(),
    ERROR_MESSAGE(),
    ERROR_PROCEDURE(),
    ERROR_LINE(),
    ERROR_NUMBER(),
    ERROR_SEVERITY(),
    ERROR_STATE(),
    @EmailListID,
    @Mailing,
    @ExternalUniqueID,
    @ProcedureID,
    @Comment
  );

SELECT
  @LogID = SCOPE_IDENTITY();

END
GO