CREATE OR REPLACE PROCEDURE public.splockasynclistbuild(IN _emaillistid integer, IN _procedurename varchar(256), IN _externaluniqueid uuid, OUT _lockid integer)
     LANGUAGE plpgsql
                    AS $procedure$
                    DECLARE
                        _locktypelistbuild integer := 1;
                        _locktypeasyncprocess integer := 2;
                        _islockedasyncproc boolean := 1;
                    BEGIN
                        BEGIN;
                        SELECT _islockedasyncproc INTO _islockedasyncproc
                        FROM public.spislocked(_emaillistid, _locktypeasyncprocess);
                        IF _islockedasyncproc = 0 THEN
                            CALL public.splock(_emaillistid, _locktypelistbuild, _procedurename, _externaluniqueid);
                        END IF;
                        COMMIT;
                        SELECT currval(pg_get_serial_sequence('public.tbllock', 'lockid')) INTO _lockid;
                    END;
                    $procedure$
                    ;