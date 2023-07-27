CREATE PROCEDURE [dbo].[spCancelCleanup] @EmailListID INT,
@Mailing INT,
@ExternalUniqueID UNIQUEIDENTIFIER = NULL AS BEGIN
SET
  NOCOUNT ON DECLARE @LogID INT = -1;

DECLARE @LogProcedureCleanup INT = 3001;

EXEC spLogRunTimeStartProcedure @LogProcedureCleanup,
@EmailListID,
@Mailing,
@ExternalUniqueID,
@LogID OUTPUT;

DECLARE @CancelCleanupStatusCode INT = 2;

UPDATE
  dbo.tblRegistryCleanup
SET
  StatusCode = @CancelCleanupStatusCode
WHERE
  EmailListID = @EmailListID
  AND Mailing = @Mailing
  AND StartedDatetime IS NULL;

EXEC spLogRunTimeFinishProcedure @LogID;

END;

;