CREATE OR REPLACE FUNCTION public.login()
RETURNS void
LANGUAGE plpgsql
AS $function$
BEGIN
    RAISE NOTICE 'Logged in';
END;
$function$;