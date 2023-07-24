CREATE OR REPLACE PROCEDURE public.splogruntimefinishprocedure(IN _logid integer)
     LANGUAGE plpgsql
    AS $procedure$
    BEGIN
        UPDATE tbllogruntime
        SET finisheddatetime = CURRENT_TIMESTAMP
        WHERE logid = _logid;

        SELECT Name 
        INTO _procedurename 
        FROM tblplprocedures 
        WHERE procedureid = _procedureid 
        LIMIT 1;
        RAISE NOTICE 'Finished %', _procedurename;
    END
    $procedure$
    ;