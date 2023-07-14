CREATE FUNCTION dbo.spCreateExternalUniqueID(
  _InputUniqueID UNIQUEIDENTIFIER = NULL,
  _OutputUniqueID UNIQUEIDENTIFIER OUTPUT)
RETURNS void
AS
BEGIN
  SET
    NOCOUNT ON;

  DECLARE _ExternalUniqueID UNIQUEIDENTIFIER = _InputUniqueID;

  IF _ExternalUniqueID IS NULL
  AND CONTEXT_INFO() IS NULL
  BEGIN
    SET
      _ExternalUniqueID = NEWID();
  END;

  IF _ExternalUniqueID IS NOT NULL
  BEGIN
    SET
      CONTEXT_INFO _ExternalUniqueID;
  END;

  ELSE IF CONTEXT_INFO() IS NOT NULL
  BEGIN
    SET
      _ExternalUniqueID = CAST(CONTEXT_INFO() AS UNIQUEIDENTIFIER);
  END;

  SET
    _OutputUniqueID = _ExternalUniqueID;
END;