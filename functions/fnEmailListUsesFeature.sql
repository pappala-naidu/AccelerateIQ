
CREATE   FUNCTION [dbo].[fnEmailListUsesFeature] (@EmailListID INT, @FeatureName VARCHAR(30)) 
RETURNS TABLE 
AS 
	RETURN ( 
		SELECT f.EmailListFeatureFlagId AS UsesFeature 
		FROM [dbo].[csn_notif_batch_dbo_tblplEmailLists] l WITH(NOLOCK) 
		CROSS JOIN [dbo].[tblplEmailLists_tblplEmailListFeatureFlags] f WITH(NOLOCK) 
		WHERE f.FeatureName = @FeatureName 
		  AND l.EmailListID = @EmailListID 
	) 