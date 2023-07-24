CREATE OR REPLACE PROCEDURE public.splogerror(IN _emaillistid integer, IN _mailing integer, IN _externaluniqueid uuid, IN _comment text, OUT _logid integer)
     LANGUAGE plpgsql
    AS $procedure$
        DECLARE _procedureid integer;

    BEGIN
        call public.spcreateexternaluniqueid(_externaluniqueid, _externaluniqueid);

        SELECT
            TOP (1) _procedureid
        INTO _procedureid
        FROM
            public.tblplprocedures
        WHERE
            name = current_user;

        RAISE NOTICE 'Error: %s', current_exception;

        RAISE NOTICE '    in %s at line %d. Error # %d, state %d, severity %d.',
                   current_user,
                   current_line,
                   current_exception.number,
                   current_exception.state,
                   current_exception.severity;

        INSERT INTO public.tbllogerror(
            errordatetime,
            message,
            procedurename,
            line,
            errornumber,
            severity,
            state,
            emaillistid,
            mailing,
            externaluniqueid,
            procedureid,
            comment
        )
        VALUES(
            CURRENT_TIMESTAMP,
            current_exception.message,
            current_user,
            current_line,
            current_exception.number,
            current_exception.severity,
            current_exception.state,
            _emaillistid,
            _mailing,
            _externaluniqueid,
            _procedureid,
            _comment
        );

        SELECT currval(pg_get_serial_sequence('public.tbllogerror', 'logid')) INTO _logid;
    END
    $procedure$
    ;