CREATE OR REPLACE PROCEDURE public.spcancelcleanup(IN _emaillistid integer, IN _mailing integer, IN _externaluniqueid uuid)
     LANGUAGE plpgsql
    AS $procedure$
    DECLARE _logid integer;
    DECLARE _logprocedurecleanup integer := 3001;

    BEGIN
        _logid := -1;

        CALL splogruntimestartprocedure(_logprocedurecleanup, _emaillistid, _mailing, _externaluniqueid, _logid);

        DECLARE _cancelcleanupstatuscode integer := 2;

        UPDATE tblregistrycleanup
        SET
            statuscode = _cancelcleanupstatuscode
        WHERE
            emaillistid = _emaillistid
            AND mailing = _mailing
            AND starteddatetime IS NULL;

        CALL splogruntimefinishprocedure(_logid);

    END;
    $procedure$
    ;