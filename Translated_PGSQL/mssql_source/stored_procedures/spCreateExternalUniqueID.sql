CREATE OR REPLACE PROCEDURE public.spcreateexternaluniqueid(IN _inputuniqueid uuid, OUT _outputuniqueid uuid)
                     LANGUAGE plpgsql
                    AS $procedure$
                    DECLARE
                        _externalUniqueID UUID;
                    BEGIN
                        _externalUniqueID := _inputUniqueID;
                        IF _externalUniqueID IS NULL AND current_setting('context_info', true) IS NULL THEN
                            _externalUniqueID := gen_random_uuid();
                        END IF;
                        IF _externalUniqueID IS NOT NULL then
                        select  _externalUniqueID into _outputUniqueID ;
                        END IF;



                    END;
                    $procedure$
                    ;