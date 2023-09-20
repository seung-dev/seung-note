--DROP FUNCTION IF EXISTS public.f_encrypt;
CREATE OR REPLACE FUNCTION public.f_encrypt
(
	algorithm_name VARCHAR = 'aes'
	, secret_key VARCHAR
	, plain_text VARCHAR
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
	public.f_encrypt(algorithm_name := 'aes', secret_key := 'password', plain_text := '가나다라')
;


*/

RETURN ENCODE(
	ENCRYPT(
		CONVERT_TO(
			plain_text
			, 'utf8'
		)
		, secret_key
		, algorithm_name
	)
	, 'hex'
	);

END;
$function$
LANGUAGE plpgsql;

COMMIT;






