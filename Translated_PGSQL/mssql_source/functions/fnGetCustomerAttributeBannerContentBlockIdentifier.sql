CREATE OR REPLACE FUNCTION public.fngetcustomerattributebannercontentblockidentifier(
    _storeid integer,
    _customerattributetypeid integer,
    _customerattribute integer,
    _daynumber integer)
     RETURNS TABLE(contentblockidentifier text)
     LANGUAGE plpgsql
    AS $function$
    BEGIN
        RETURN QUERY
            SELECT (
                    coalesce(emaillist.nameshorthand, 'MissingEmailListNameShorhand') || '_' ||
                    coalesce(replace(replace(customerattributetype.name, 'InMarket', 'IM'), ' ', ''), 'MissingCustomerAttributeTypeName') || '_' ||
                    coalesce(replace(replace(customerattributestore.name, 'InMarket', 'IM'), ' ', ''), 'MissingCustomerAttributeStoreName') || '_' ||
                    coalesce(substr(weekdays.weekdayname, 1, 3), 'MissingWeekdayName') || '_' ||
                    cast(bannercontent.customerattributebannerbundlecontentid as text)
                ) AS contentblockidentifier

        FROM latesttargetcustomerattribute_cte AS bannercontent

        INNER JOIN dbo.csn_notif_batch_dbo_tblplemaillists AS emaillist (nolock)
            ON (bannercontent.storeid = emaillist.storeid)

        INNER JOIN dbo.dbo_tblplcustomerattributetypes AS customerattributetype (nolock)
            ON (bannercontent.customerattributetypeid = customerattributetype.customerattributetypeid)

        INNER JOIN dbo.dbo_tblcustomerattributestore AS customerattributestore (nolock)
            ON (bannercontent.storeid = customerattributestore.storeid
                AND bannercontent.customerattributetypeid = customerattributestore.customerattributetypeid
                AND bannercontent.customerattribute = customerattributestore.customerattribute)

        INNER JOIN dbo.dbo_tblplweekday AS weekdays
            ON (bannercontent.daynumber = weekdays.weekdayid)
    END;
    $function$
    ;