--DROP VIEW public.v_table_schema;
CREATE OR REPLACE VIEW public.v_table_schema
AS
SELECT
	t_items.table_schema
	, t_items.table_name
	, t_items.table_comment
	, t_items.column_name
	, t_items.ordinal_position
	, t_items.column_comment
	, t_items.column_default
	, t_items.is_nullable
	, t_items.data_type
	, t_items.column_precision
	, t_items.column_scale
FROM
	(
		SELECT
			t_column.table_schema
			, t_column.table_name
			, OBJ_DESCRIPTION(CONCAT(t_column.table_schema, '.', t_column.table_name)::REGCLASS::OID, 'pg_class'::name) AS table_comment
			, t_column.column_name
			, t_column.ordinal_position
			, COL_DESCRIPTION(CONCAT(t_column.table_schema, '.', t_column.table_name)::REGCLASS::OID, t_column.ordinal_position) AS column_comment
			, t_column.column_default
			, t_column.is_nullable
			, t_column.data_type
			, CASE
				WHEN t_column.data_type = 'num' THEN t_column.numeric_precision
				WHEN t_column.data_type ~ 'int' THEN t_column.numeric_precision
				ELSE t_column.character_maximum_length
				END AS column_precision
			, CASE
				WHEN t_column.data_type ~ 'char' THEN 0
				ELSE t_column.numeric_scale
				END AS column_scale
		FROM
			information_schema.columns AS t_column
	) AS t_items
WHERE
	table_name ~ '^t_'
ORDER BY
	2 ASC
	, 5 ASC
;










