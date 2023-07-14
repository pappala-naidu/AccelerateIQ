CREATE PROCEDURE dbo.spSetCustomerAttributeStoreDynamicBannerData(
    _StoreID INT,
    _CustomerAttributeTypeID INT,
    _CustomerAttribute INT,
    _DayNumber INT,
    _LaunchURL NVARCHAR(3000),
    _ImageURL NVARCHAR(3000),
    _AltText NVARCHAR(256),
    _SubjectLine NVARCHAR(128),
    _IsActive BIT,
    _Username NVARCHAR(64))
AS
BEGIN
    SET
        NOCOUNT ON;

    DECLARE _Now TIMESTAMP WITH TIME ZONE = CURRENT_TIMESTAMP;

    IF _IsActive = 0
    BEGIN
        UPDATE
            dbo.tblRulesCustomerAttributeBanner
        SET
            IsActive = _IsActive,
            LastUpdatedBy = _Username,
            DatetimeChanged = _Now
        WHERE
            StoreID = _StoreID
            AND CustomerAttributeTypeID = _CustomerAttributeTypeID
            AND CustomerAttribute = _CustomerAttribute
            AND DayNumber = _DayNumber;

    END
    ELSE
    BEGIN
        IF NOT EXISTS (
            SELECT
                TOP 1 1
            FROM
                dbo.vwLatestCustomerAttributeBannerBundleContent
            WHERE
                StoreID = _StoreID
                AND CustomerAttributeTypeID = _CustomerAttributeTypeID
                AND CustomerAttribute = _CustomerAttribute
                AND DayNumber = _DayNumber
                AND LaunchURL = _LaunchURL
                AND ImageURL = _ImageURL -- Perform a case-sensitive comparison
                AND CONVERT(VARBINARY(256), LTRIM(RTRIM(AltText))) = CONVERT(VARBINARY(256), LTRIM(RTRIM(_AltText)))
        )
        BEGIN
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
                    _StoreID,
                    _CustomerAttributeTypeID,
                    _CustomerAttribute,
                    _DayNumber,
                    _LaunchURL,
                    _ImageURL,
                    _AltText,
                    _Username,
                    _Now,
                    _SubjectLine
                );
        END;

        DECLARE _ContentBlockIdentifier NVARCHAR(256);

        SELECT
            _ContentBlockIdentifier = ContentBlockIdentifier
        FROM
            dbo.fnGetCustomerAttributeBannerContentBlockIdentifier(
                _StoreID,
                _CustomerAttributeTypeID,
                _CustomerAttribute,
                _DayNumber
            );

        UPDATE
            dbo.tblRulesCustomerAttributeBanner
        SET
            ContentBlock = _ContentBlockIdentifier,
            Subjectline = _SubjectLine,
            IsActive = _IsActive,
            LastUpdatedBy = _Username,
            DatetimeChanged = _Now
        WHERE
            StoreID = _StoreID
            AND CustomerAttributeTypeID = _CustomerAttributeTypeID
            AND CustomerAttribute = _CustomerAttribute
            AND DayNumber = _DayNumber;

    END;
END;