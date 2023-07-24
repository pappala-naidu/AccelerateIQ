CREATE OR REPLACE FUNCTION public.fnlogtographite(data text, host text DEFAULT 'statsd.csnzoo.com', port integer DEFAULT 8125)
RETURNS boolean
LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN call graphite.graphite.logtographite(data, host, port);
END;
$function$
;