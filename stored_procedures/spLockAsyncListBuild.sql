CREATE PROCEDURE [dbo].[spLockAsyncListBuild] @EmailListID INT,
@ProcedureName NVARCHAR (256),
@ExternalUniqueID UNIQUEIDENTIFIER = NULL,
@LockID INT = -1 OUTPUT AS BEGIN
SET
	NOCOUNT ON -- LOCK TYPES 
	DECLARE @LockTypeListBuild INT = 1;

DECLARE @LockTypeAsyncProcess INT = 2;

-- IS LOCKED 
DECLARE @IsLockedAsyncProc BIT = 1;

BEGIN TRANSACTION -- CHECK LOCKED 
EXEC @IsLockedAsyncProc = spIsLocked @EmailListID,
@LockTypeAsyncProcess;

IF @IsLockedAsyncProc = 0 BEGIN -- ASYNC PROCESS LOCK 
EXEC @LockID = spLock @EmailListID,
@LockTypeListBuild,
N'spAsyncListBuild',
@ExternalUniqueID;

END COMMIT RETURN @LockID;

END