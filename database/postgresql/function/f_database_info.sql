DROP FUNCTION IF EXISTS public.f_database_info;
CREATE OR REPLACE FUNCTION public.f_database_info
	(
	)
RETURNS
	TABLE (
		dbms_name VARCHAR
		, dbms_version VARCHAR
		, dbms_os VARCHAR
		, database_name VARCHAR
		, database_encoding VARCHAR
	)
AS
$function$
DECLARE
BEGIN

/*
[Summary]
- Database Information
[Request]
[Response]
[Usage]
SELECT
	*
FROM
	public.f_database_info()
;
*/

RETURN QUERY
	SELECT
		SPLIT_PART(info.ver, ' ', 1)::VARCHAR AS dbms_name
		, SPLIT_PART(info.ver, ' ', 2)::VARCHAR AS dbms_version
		, SPLIT_PART(info.ver, ' ', 4)::VARCHAR AS dbms_os
		, info.datname::VARCHAR AS database_name
		, pg_catalog.PG_ENCODING_TO_CHAR(info.encoding)::VARCHAR AS database_encoding
	FROM
		(
		SELECT
			pg_catalog.VERSION()::VARCHAR AS ver
			, db.datname
			, db.encoding
		FROM
			pg_catalog.pg_database AS db
		WHERE 1 = 1
			AND db.datname = pg_catalog.CURRENT_DATABASE()
		) AS info
;

END;
$function$
LANGUAGE plpgsql;
