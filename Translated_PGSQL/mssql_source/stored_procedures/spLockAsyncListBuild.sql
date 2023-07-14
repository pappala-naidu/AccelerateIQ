CREATE PROCEDURE public.sp_lock_async_list_build(
    _email_list_id integer,
    _procedure_name character varying(256),
    _external_unique_id uuid DEFAULT NULL,
    _lock_id integer = -1::integer OUT)
AS
BEGIN
    SET
        NOCOUNT ON;

    -- LOCK TYPES

    DECLARE _lock_type_list_build integer = 1;

    DECLARE _lock_type_async_process integer = 2;

    -- IS LOCKED

    DECLARE _is_locked_async_proc boolean = 1;

    BEGIN TRANSACTION;

    -- CHECK LOCKED

    EXECUTE _is_locked_async_proc = sp_is_locked(
        _email_list_id,
        _lock_type_async_process);

    IF _is_locked_async_proc = 0 THEN
        -- ASYNC PROCESS LOCK

        EXECUTE _lock_id = sp_lock(
            _email_list_id,
            _lock_type_list_build,
            N'sp_async_list_build',
            _external_unique_id);

    END;

    COMMIT;

    RETURN _lock_id;

END;