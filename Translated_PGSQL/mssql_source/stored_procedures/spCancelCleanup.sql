CREATE PROCEDURE spCancelCleanup(
    _EmailListID INT,
    _Mailing INT,
    _ExternalUniqueID UNIQUEIDENTIFIER = NULL)
AS
BEGIN

  SET
    NOCOUNT ON;

  DECLARE _LogID INT = -1;

  DECLARE _LogProcedureCleanup INT = 3001;

  EXEC spLogRunTimeStartProcedure(_LogProcedureCleanup,
                                 _EmailListID,
                                 _Mailing,
                                 _ExternalUniqueID,
                                 _LogID OUTPUT);

  DECLARE _CancelCleanupStatusCode INT = 2;

  UPDATE
    tblRegistryCleanup
  SET
    StatusCode = _CancelCleanupStatusCode
  WHERE
    EmailListID = _EmailListID
    AND Mailing = _Mailing
    AND StartedDatetime IS NULL;

  EXEC spLogRunTimeFinishProcedure(_LogID);

END;

;