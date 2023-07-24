CREATE OR REPLACE FUNCTION public.fnistestactive(testid integer, date date DEFAULT NULL)
     RETURNS TABLE(isactive boolean)
     LANGUAGE plpgsql
    AS $function$
    BEGIN
        RETURN QUERY
            SELECT
                CAST(COUNT(*) AS BOOLEAN) AS isactive
            FROM
                public.csn_libra_dbo_tbltest AS test
                CROSS JOIN (
                    SELECT
                        CAST(
                            COALESCE(date, CAST(CURRENT_TIMESTAMP AS DATE)) AS TIMESTAMP
                        ) AS inputdate
                ) AS date_cte
            WHERE
                test.testid = testid
                AND test.testlaunched IS NOT NULL
                AND test.testcancelled IS NULL
                AND date_cte.inputdate BETWEEN test.teststart
                AND test.testend;
    END;
    $function$
    ;