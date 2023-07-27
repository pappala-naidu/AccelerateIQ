CREATE PROCEDURE [dbo].[spLogRunTimeFinishProcedure] @LogID INT AS BEGIN
SET
	NOCOUNT ON -- LOG FINISH 
UPDATE
	tblLogRunTime
SET
	FinishedDatetime = GETDATE()
WHERE
	LogID = @LogID;

DECLARE @ProcedureName NVARCHAR(128);

DECLARE @ProcedureStart DATETIME;

DECLARE @ProcedureEnd DATETIME;

SELECT
	@ProcedureName = p.Name,
	@ProcedureStart = r.StartedDatetime,
	@ProcedureEnd = r.FinishedDatetime
FROM
	dbo.tblLogRunTime AS r WITH (NOLOCK)
	JOIN dbo.tblplProcedures AS p WITH (NOLOCK) ON r.ProcedureID = p.ProcedureID
WHERE
	LogID = @LogID;

PRINT 'Finished ' + @ProcedureName;

END