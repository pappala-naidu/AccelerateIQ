CREATE OR REPLACE FUNCTION public.fnemaillistusesfeature(integer, character varying)
     RETURNS TABLE(usesfeature integer)
     LANGUAGE plpgsql
    AS $function$
    BEGIN
      RETURN QUERY 
      SELECT f.emaillistfeatureflaggid as usesfeature 
      FROM public.csn_notif_batch_dbo_tblplemaillists l
      LEFT JOIN LATERAL (
          SELECT * FROM public.tblplemailist_tblplemaillistfeatureflags f 
          WHERE f.featurename = $2
       ) f ON true 
       WHERE l.emaillistid = $1;
    END;
    $function$
    ;