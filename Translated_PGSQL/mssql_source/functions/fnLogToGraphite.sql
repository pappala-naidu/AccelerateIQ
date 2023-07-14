ALTER FUNCTION public.fn_log_to_graphite(
    _data text,
    _host text = 'statsd.csnzoo.com',
    _port integer = 8125
) RETURNS boolean AS
$$
BEGIN
    RETURN (
        SELECT 1
        FROM graphite.graphite.log_to_graphite(
            _data,
            _host,
            _port
        )
    );
END;
$$ LANGUAGE plpgsql;