CREATE FUNCTION dbo.fnGetCustomerAttributeBannerContentBlockIdentifier ( 
    _StoreID INT, 
    _CustomerAttributeTypeID INT, 
    _CustomerAttribute INT, 
    _DayNumber INT 
) 
RETURNS TABLE 
AS 
RETURN ( 
    WITH LatestTargetCustomerAttribute_CTE (CustomerAttributeBannerBundleContentID, StoreID, CustomerAttributeTypeID, CustomerAttribute, DayNumber) 
    AS 
    ( 
        SELECT CustomerAttributeBannerBundleContentID, StoreID, CustomerAttributeTypeID, CustomerAttribute, DayNumber 
        FROM dbo.vwLatestCustomerAttributeBannerBundleContent 
        WHERE StoreID = _StoreID 
        AND CustomerAttributeTypeID = _CustomerAttributeTypeID 
        AND CustomerAttribute = _CustomerAttribute 
        AND DayNumber = _DayNumber 
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