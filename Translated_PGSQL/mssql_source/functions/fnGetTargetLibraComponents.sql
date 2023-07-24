CREATE OR REPLACE FUNCTION public.fngettargetlibracomponents(integer, integer)
     RETURNS TABLE(testid integer, testgroupid integer)
     LANGUAGE plpgsql
    AS $function$
    WITH targetcomponents_cte(uniqueid) AS (
        SELECT
            uniqueid
        FROM
            dbo.tblmaptargetinclude
        WHERE
            emaillistid = $1
            AND target = $2
        UNION
        SELECT
            uniqueid
        FROM
            dbo.tblmaptargetexclude
        WHERE
            emaillistid = $1
            AND target = $2
    )
    SELECT
        DISTINCT testid,
        testgroupid
    FROM
        dbo.csn_libra_dbo_tbltestgroup AS testgroup
        INNER JOIN targetcomponents_cte AS targetcomponents ON (
            testgroup.testgroupguid = targetcomponents.uniqueid
        )
    $function$
    ;