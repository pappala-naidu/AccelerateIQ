CREATE OR REPLACE FUNCTION public.fngetmailinglibracomponents(integer, integer)
     RETURNS TABLE(testid integer, testgroupid integer)
     LANGUAGE plpgsql
    AS $function$
    BEGIN
        RETURN QUERY
            WITH mailingcomponents_cte AS (
                SELECT
                    EmailListID,
                    Mailing,
                    Target
                FROM
                    csn_notif_batch_dbo_tblmailing
                UNION
                SELECT
                    EmailListID,
                    Mailing,
                    HoldoutTarget
                FROM
                    csn_notif_batch_dbo_tblmailing
                UNION
                SELECT
                    EmailListID,
                    Mailing,
                    Target
                FROM
                    csn_marketingemail_dbo_tblmaptargetmailingbatch
                UNION
                SELECT
                    EmailListID,
                    Mailing,
                    Target
                FROM
                    csn_marketingemail_dbo_tblmaptargetmailingvariation
                UNION
                SELECT
                    MailingVariation.EmailListID,
                    MailingVariation.Mailing,
                    EventTreatments.Target
                FROM
                    csn_notif_batch_dbo_tblmailingvariation AS MailingVariation
                    INNER JOIN csn_marketingemail_dbo_tbleventcontentstrategytreatment AS EventTreatments ON ISNULL(MailingVariation.EventContentStrategy, 1) = EventTreatments.EventContentStrategy
                    AND MailingVariation.EmailListID = EventTreatments.EmailListID
                WHERE
                    EventTreatments.Target IS NOT NULL
                UNION
                SELECT
                    MailingVariation.EmailListID,
                    MailingVariation.Mailing,
                    SkuTreatments.Target
                FROM
                    csn_notif_batch_dbo_tblmailingvariation AS MailingVariation
                    INNER JOIN csn_marketingemail_dbo_tblskucontentstrategytreatment AS SkuTreatments ON ISNULL(MailingVariation.SKUContentStrategy, 1) = SkuTreatments.SKUContentStrategy
                    AND MailingVariation.EmailListID = SkuTreatments.EmailListID
                WHERE
                    SkuTreatments.Target IS NOT NULL
                UNION
                SELECT
                    MailingVariation.EmailListID,
                    MailingVariation.Mailing,
                    ArbContentTreatments.Target
                FROM
                    csn_notif_batch_dbo_tblmailingvariation AS MailingVariation
                    INNER JOIN csn_marketingemail_dbo_tblarbitrarycontentstrategytreatment AS ArbContentTreatments ON ISNULL(MailingVariation.ArbitraryContentStrategy, 1) = ArbContentTreatments.ArbitraryContentStrategy
                    AND MailingVariation.EmailListID = ArbContentTreatments.EmailListID
                WHERE
                    ArbContentTreatments.Target IS NOT NULL
            ),
            inputmailingcomponents_cte AS (
                SELECT
                    TargetID
                FROM
                    mailingcomponents_cte
                WHERE
                    EmailListID = $1
                    AND Mailing = $2
            )
            SELECT
                DISTINCT TestID,
                TestGroupID
            FROM
                inputmailingcomponents_cte
                CROSS JOIN public.fngettargetlibracomponents($1, TargetID);
    $function$
    ;