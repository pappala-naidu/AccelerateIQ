CREATE PROCEDURE public.sp_log_run_time_finish_procedure(
    _log_id integer
)
AS
BEGIN
    SET
        NOCOUNT ON; -- LOG FINISH

    UPDATE
        log_run_time
    SET
        finished_datetime = CURRENT_TIMESTAMP
    WHERE
        log_id = _log_id;

    DECLARE
        _procedure_name character varying(128);

    DECLARE
        _procedure_start timestamp without time zone;

    DECLARE
        _procedure_end timestamp without time zone;

    SELECT
        _procedure_name = p.name,
        _procedure_start = r.started_datetime,
        _procedure_end = r.finished_datetime
    FROM
        log_run_time AS r
        JOIN pl_procedures AS p ON r.procedure_id = p.procedure_id
    WHERE
        log_id = _log_id;

    PRINT 'Finished ' + _procedure_name;

END;