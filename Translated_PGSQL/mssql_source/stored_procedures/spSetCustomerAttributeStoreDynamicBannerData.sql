CREATE OR REPLACE PROCEDURE public.spsetcustomerattributestoredynamicbannerdata(
    IN _storeid integer,
    IN _customerattributetypeid integer,
    IN _customerattribute integer,
    IN _daynumber integer,
    IN _launchurl character varying(3000),
    IN _imageurl character varying(3000),
    IN _alttext character varying(256),
    IN _subjectline character varying(128),
    IN _isactive boolean,
    IN _username character varying(64))
     LANGUAGE plpgsql
    AS $procedure$
        DECLARE
            _now timestamp with time zone := CURRENT_TIMESTAMP;
        BEGIN
            IF _isactive = 0 THEN
                UPDATE public.tblrulescustomerattributebanner
                SET
                    active = _isactive,
                    lastupdatedby = _username,
                    datetimechanged = _now
                WHERE
                    storeid = _storeid
                    AND customerattributetypeid = _customerattributetypeid
                    AND customerattribute = _customerattribute
                    AND daynumber = _daynumber;
            ELSE
                IF NOT EXISTS (
                    SELECT
                        1
                    FROM
                        public.vwlatestcustomerattributebannerbundlecontent
                    WHERE
                        storeid = _storeid
                        AND customerattributetypeid = _customerattributetypeid
                        AND customerattribute = _customerattribute
                        AND daynumber = _daynumber
                        AND launchurl = _launchurl
                        AND imageurl = _imageurl
                        AND position(_alttext in _alttext) = 1
                ) THEN
                    INSERT INTO public.tblcustomerattributebannerbundlecontent (
                        storeid,
                        customerattributetypeid,
                        customerattribute,
                        daynumber,
                        launchurl,
                        imageurl,
                        alttext,
                        username,
                        datetimeadded,
                        subjectline
                    )
                    VALUES (
                        _storeid,
                        _customerattributetypeid,
                        _customerattribute,
                        _daynumber,
                        _launchurl,
                        _imageurl,
                        _alttext,
                        _username,
                        _now,
                        _subjectline
                    );
                END IF;

                SELECT
                    contentblockidentifier
                FROM
                    public.fngetcustomerattributebannercontentblockidentifier(
                        _storeid,
                        _customerattributetypeid,
                        _customerattribute,
                        _daynumber
                    )
                INTO _contentblockidentifier;

                UPDATE public.tblrulescustomerattributebanner
                SET
                    contentblock = _contentblockidentifier,
                    subjectline = _subjectline,
                    active = _isactive,
                    lastupdatedby = _username,
                    datetimechanged = _now
                WHERE
                    storeid = _storeid
                    AND customerattributetypeid = _customerattributetypeid
                    AND customerattribute = _customerattribute
                    AND daynumber = _daynumber;
            END IF;
        END;
    $procedure$
    ;