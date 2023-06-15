CREATE PROCEDURE dbo.spSetCustomerAttributeStoreDynamicBannerData @StoreID INT,
@CustomerAttributeTypeID INT,
@CustomerAttribute INT,
@DayNumber INT,
@LaunchURL NVARCHAR(3000),
@ImageURL NVARCHAR(3000),
@AltText NVARCHAR(256),
@SubjectLine NVARCHAR(128),
@IsActive BIT,
@Username NVARCHAR(64) AS BEGIN
SET
	NOCOUNT ON DECLARE @Now DATETIMEOFFSET(4) = CAST(GETDATE() AS DATETIMEOFFSET(4));

IF @IsActive = 0 BEGIN
UPDATE
	dbo.tblRulesCustomerAttributeBanner
SET
	IsActive = @IsActive,
	LastUpdatedBy = @Username,
	DatetimeChanged = @Now
WHERE
	StoreID = @StoreID
	AND CustomerAttributeTypeID = @CustomerAttributeTypeID
	AND CustomerAttribute = @CustomerAttribute
	AND DayNumber = @DayNumber;

END
ELSE BEGIN IF NOT EXISTS (
	SELECT
		TOP 1 1
	FROM
		dbo.vwLatestCustomerAttributeBannerBundleContent
	WHERE
		StoreID = @StoreID
		AND CustomerAttributeTypeID = @CustomerAttributeTypeID
		AND CustomerAttribute = @CustomerAttribute
		AND DayNumber = @DayNumber
		AND LaunchURL = @LaunchURL
		AND ImageURL = @ImageURL -- Perform a case-sensitive comparison
		AND CONVERT(VARBINARY(256), LTRIM(RTRIM(AltText))) = CONVERT(VARBINARY(256), LTRIM(RTRIM(@AltText)))
) BEGIN
INSERT INTO
	dbo.tblCustomerAttributeBannerBundleContent (
		StoreID,
		CustomerAttributeTypeID,
		CustomerAttribute,
		DayNumber,
		LaunchURL,
		ImageURL,
		AltText,
		Username,
		DatetimeAdded,
		SubjectLine
	)
VALUES
	(
		@StoreID,
		@CustomerAttributeTypeID,
		@CustomerAttribute,
		@DayNumber,
		@LaunchURL,
		@ImageURL,
		@AltText,
		@Username,
		@Now,
		@SubjectLine
	)
END DECLARE @ContentBlockIdentifier NVARCHAR(256);

SELECT
	@ContentBlockIdentifier = ContentBlockIdentifier
FROM
	dbo.fnGetCustomerAttributeBannerContentBlockIdentifier(
		@StoreID,
		@CustomerAttributeTypeID,
		@CustomerAttribute,
		@DayNumber
	)
UPDATE
	dbo.tblRulesCustomerAttributeBanner
SET
	ContentBlock = @ContentBlockIdentifier,
	Subjectline = @SubjectLine,
	IsActive = @IsActive,
	LastUpdatedBy = @Username,
	DatetimeChanged = @Now
WHERE
	StoreID = @StoreID
	AND CustomerAttributeTypeID = @CustomerAttributeTypeID
	AND CustomerAttribute = @CustomerAttribute
	AND DayNumber = @DayNumber;

END
END