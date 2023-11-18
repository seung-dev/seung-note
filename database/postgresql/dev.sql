SELECT
	*
	, CONCAT(
		'"desc_', column_name, '": "', column_comment, '",'
		, '"', column_name, '": "', column_name, '",'
	) AS request_body_postman
FROM
	public.v_table_schema
WHERE
	table_schema ~ 'restful'
	AND table_name ~ 't_user_d0100'
;


-- hist
SELECT * FROM restful.t_hist_d0100 ORDER BY 1 DESC;


-- user
SELECT * FROM restful.t_user_d0100;
SELECT * FROM restful.t_user_d0110;
SELECT * FROM restful.t_user_d0120;
SELECT * FROM restful.t_user_d0121;
SELECT * FROM restful.t_user_d0200;
SELECT * FROM restful.t_user_d0209;



