--DROP FUNCTION IF EXISTS public.f_random_no;
CREATE OR REPLACE FUNCTION public.f_random_no
(
	text_length INT
)
RETURNS VARCHAR
AS
$function$
DECLARE
BEGIN

/*
[Summary]
	Generate Random Text
[Request]
[Response]
[Usage]
SELECT
	public.f_random_no(text_length := 12)
;


*/

RETURN
	SELECT
		STRING_AGG(
			CASE
				WHEN random_no > 10 THEN CHR(random_no::INT - 10 + 96)
				WHEN random_no = 10 THEN '0'
				ELSE random_no::text
				END
			, ''
		) AS random_text
	FROM
		(
			SELECT
				FLOOR(RANDOM() * 36 + 1)::INT AS random_no
			FROM
				GENERATE_SERIES(1, req_code_size)
		) AS t_item
	;

END;
$function$
LANGUAGE plpgsql;

COMMIT;









