CREATE OR REPLACE FUNCTION public.sp_log_error(
  email_list_id integer,
  mailing integer,
  external_unique_id uuid,
  comment text,
  log_id integer DEFAULT NULL::integer
)
RETURNS integer
AS
BEGIN
  SET
    NOCOUNT ON;

  BEGIN TRY
    SELECT
      external_unique_id
    FROM
      public.tblpl_procedures
    WHERE
      name = ERROR_PROCEDURE();

    RAISE NOTICE(
      '%s - %s',
      CONVERT(text, CURRENT_TIMESTAMP, 21),
      ERROR_MESSAGE()
    );

    RAISE NOTICE(
      '    in %s at line %d. Error # %d, state %d, severity %d.',
      ERROR_PROCEDURE(),
      ERROR_LINE(),
      ERROR_NUMBER(),
      ERROR_STATE(),
      ERROR_SEVERITY()
    );

  END TRY
  BEGIN CATCH
  END CATCH;

  INSERT INTO
    public.tbl_log_error(
      error_date_time,
      message,
      procedure_name,
      line,
      error_number,
      severity,
      state,
      email_list_id,
      mailing,
      external_unique_id,
      procedure_id,
      comment
    )
  VALUES
    (
      CURRENT_TIMESTAMP,
      ERROR_MESSAGE(),
      ERROR_PROCEDURE(),
      ERROR_LINE(),
      ERROR_NUMBER(),
      ERROR_SEVERITY(),
      ERROR_STATE(),
      email_list_id,
      mailing,
      external_unique_id,
      NULL::integer,
      comment
    );

  SELECT
    log_id = SCOPE_IDENTITY();

END;