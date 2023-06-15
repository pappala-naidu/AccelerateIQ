CREATE FUNCTION dbo.fnGetCustomerAttributeBannerContentBlockIdentifier ( 
    @StoreID INT, 
    @CustomerAttributeTypeID INT, 
    @CustomerAttribute INT, 
    @DayNumber INT 
) 
RETURNS TABLE 
AS 
RETURN ( 
    WITH LatestTargetCustomerAttribute_CTE (CustomerAttributeBannerBundleContentID, StoreID, CustomerAttributeTypeID, CustomerAttribute, DayNumber) 
    AS 
    ( 
        SELECT CustomerAttributeBannerBundleContentID, StoreID, CustomerAttributeTypeID, CustomerAttribute, DayNumber 
        FROM dbo.vwLatestCustomerAttributeBannerBundleContent 
        WHERE StoreID = @StoreID 
        AND CustomerAttributeTypeID = @CustomerAttributeTypeID 
        AND CustomerAttribute = @CustomerAttribute 
        AND DayNumber = @DayNumber 
    ) 
    SELECT ( 
            REPLACE(COALESCE(EmailList.NameShorthand, N'MissingEmailListNameShorhand'), ' ', '') + '_' + 
            REPLACE(REPLACE(COALESCE(CustomerAttributeType.Name, N'MissingCustomerAttributeTypeName'), ' ', ''), 'InMarket', 'IM') + '_' + 
            REPLACE(REPLACE(COALESCE(CustomerAttributeStore.Name, N'MissingCustomerAttributeStoreName'), ' ', ''), 'InMarket', 'IM') + '_' + 
            COALESCE(SUBSTRING(Weekdays.WeekdayName, 1, 3), N'MissingWeekdayName') + '_' + 
            CAST(BannerContent.CustomerAttributeBannerBundleContentID AS NVARCHAR) 
        ) AS ContentBlockIdentifier 
 
    FROM LatestTargetCustomerAttribute_CTE AS BannerContent 
 
    INNER JOIN dbo.csn_notif_batch_dbo_tblplEmailLists AS EmailList (NOLOCK) 
    ON (BannerContent.StoreID = EmailList.StoreID) 
 
    INNER JOIN dbo.dbo_tblplCustomerAttributeTypes AS CustomerAttributeType (NOLOCK) 
    ON (BannerContent.CustomerAttributeTypeID = CustomerAttributeType.CustomerAttributeTypeID) 
 
    INNER JOIN dbo.dbo_tblCustomerAttributeStore AS CustomerAttributeStore (NOLOCK) 
    ON (BannerContent.StoreID = CustomerAttributeStore.StoreID 
    AND BannerContent.CustomerAttributeTypeID = CustomerAttributeStore.CustomerAttributeTypeID 
    AND BannerContent.CustomerAttribute = CustomerAttributeStore.CustomerAttribute) 
 
    INNER JOIN dbo.dbo_tblplWeekday AS Weekdays 
    ON (BannerContent.DayNumber = Weekdays.WeekdayID) 
);