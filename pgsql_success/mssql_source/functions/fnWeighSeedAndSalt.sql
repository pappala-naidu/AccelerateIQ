CREATE OR REPLACE FUNCTION public.fnweighseedandsalt1(seed uuid, salt uuid DEFAULT NULL::uuid)
     RETURNS TABLE(weight integer)
     LANGUAGE sql
    AS $function$
        SELECT CAST(
            SUBSTRING(
                MD5(CONCAT(CAST(Seed AS TEXT), COALESCE(CAST(Salt AS TEXT), '')))::text,
                1,
                4
            )::integer
            AS INTEGER
        ) AS Weight;
    $function$
    ;