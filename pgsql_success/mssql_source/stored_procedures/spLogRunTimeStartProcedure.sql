CREATE OR REPLACE PROCEDURE public.splogruntimestartprocedure(IN _procedureid integer, IN _emaillistid integer, IN _mailing integer, IN _externaluniqueid uuid, OUT _logid integer)
                     LANGUAGE plpgsql
                    AS $procedure$
                       DECLARE _procedurename VARCHAR(256);
                      declare _external_id uuid;

                    BEGIN
                       call spCreateExternalUniqueID(_externaluniqueid, _externaluniqueid);


                       SELECT Name 
                        INTO _procedurename 
                        FROM tblplprocedures 
                        WHERE procedureid = _procedureid 
                        LIMIT 1;
                        RAISE NOTICE 'Starting %', _procedurename;

                        INSERT INTO tbllogruntime (
                            procedurename,
                            procedureid,
                            emaillistid,
                            mailing,
                            starteddatetime,
                            finisheddatetime,
                            externaluniqueid
                        )VALUES(
                            _procedurename,
                            _procedureid,
                            _emaillistid,
                            _mailing,
                            CURRENT_TIMESTAMP, 
                            null, 
                            _externaluniqueid
                        );



                    SELECT currval(pg_get_serial_sequence('tblLogRunTime', 'logid')) INTO _logid;
                    END
                    $procedure$
                    ;