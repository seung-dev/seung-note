--DROP FUNCTION IF EXISTS public.f_item_no;
CREATE OR REPLACE FUNCTION public.f_item_no
(
	sequence_name VARCHAR
	, date_format VARCHAR = 'YY'
	, padding INT = 9
	, prefix VARCHAR = 'A'
	, suffix VARCHAR = ''
)
RETURNS VARCHAR
AS
$function$
DECLARE
BEGIN

/*
[Summary]
	Generate unique key
[Request]
[Response]
[Usage]
SELECT
	public.f_item_no(sequence_name := 'public.s_public_doc', suffix := 'A')
;


*/

RETURN CONCAT(
	prefix
	, TO_CHAR(NOW(), date_format)
	, RIGHT(CONCAT(REPEAT('0', padding), NEXTVAL(sequence_name)::VARCHAR), padding)
	, suffix
	);

END;
$function$
LANGUAGE plpgsql;

COMMIT;









