CREATE FUNCTION dbo.fnGetMailingLibraComponents(
    _EmailListID INT,
    _Mailing INT
)
RETURNS TABLE AS
RETURN (
    WITH MailingComponents_CTE (EmailListID, Mailing, TargetID) AS (
        SELECT
            EmailListID,
            Mailing,
            Target
        FROM
            dbo.csn_notif_batch_dbo_tblMailing
        WITH (NOLOCK)
        UNION
        SELECT
            EmailListID,
            Mailing,
            HoldoutTarget
        FROM
            dbo.csn_notif_batch_dbo_tblMailing
        WITH (NOLOCK)
        UNION
        SELECT
            EmailListID,
            Mailing,
            Target
        FROM
            dbo.csn_marketingemail_dbo_tblMapTargetMailingBatch
        WITH (NOLOCK)
        UNION
        SELECT
            EmailListID,
            Mailing,
            Target
        FROM
            dbo.csn_marketingemail_dbo_tblMapTargetMailingVariation
        WITH (NOLOCK)
        UNION
        SELECT
            MailingVariation.EmailListID,
            MailingVariation.Mailing,
            EventTreatments.Target
        FROM
            dbo.csn_notif_batch_dbo_tblMailingVariation AS MailingVariation
        WITH (NOLOCK)
        INNER JOIN dbo.csn_marketingemail_dbo_tblEventContentStrategyTreatment AS EventTreatments
        WITH (NOLOCK) ON ISNULL(MailingVariation.EventContentStrategy, 1) = EventTreatments.EventContentStrategy
        AND MailingVariation.EmailListID = EventTreatments.EmailListID
        WHERE
            EventTreatments.Target IS NOT NULL
        UNION
        SELECT
            MailingVariation.EmailListID,
            MailingVariation.Mailing,
            SkuTreatments.Target
        FROM
            dbo.csn_notif_batch_dbo_tblMailingVariation AS MailingVariation
        WITH (NOLOCK)
        INNER JOIN dbo.csn_marketingemail_dbo_tblSKUContentStrategyTreatment AS SkuTreatments
        WITH (NOLOCK) ON ISNULL(MailingVariation.SKUContentStrategy, 1) = SkuTreatments.SKUContentStrategy
        AND MailingVariation.EmailListID = SkuTreatments.EmailListID
        WHERE
            SkuTreatments.Target IS NOT NULL
        UNION
        SELECT
            MailingVariation.EmailListID,
            MailingVariation.Mailing,
            ArbContentTreatments.Target
        FROM
            dbo.csn_notif_batch_dbo_tblMailingVariation AS MailingVariation
        WITH (NOLOCK)
        INNER JOIN dbo.csn_marketingemail_dbo_tblArbitraryContentStrategyTreatment AS ArbContentTreatments
        WITH (NOLOCK) ON ISNULL(MailingVariation.ArbitraryContentStrategy, 1) = ArbContentTreatments.ArbitraryContentStrategy
        AND MailingVariation.EmailListID = ArbContentTreatments.EmailListID
        WHERE
            ArbContentTreatments.Target IS NOT NULL
    ),
    InputMailingComponents_CTE (TargetID) AS (
        SELECT
            TargetID
        FROM
            MailingComponents_CTE
        WHERE
            EmailListID = _EmailListID
            AND Mailing = _Mailing
    )
    SELECT
        DISTINCT TestID,
        TestGroupID
    FROM
        InputMailingComponents_CTE
        CROSS JOIN dbo.fnGetTargetLibraComponents(_EmailListID, TargetID)
);