# PostgreSQL

##### Information

```sql
SELECT * FROM public.f_database_info();
```

##### Tilt

```sql
SELECT CASE WHEN '1,2,3,4,5,6,7' !~ '1' THEN 1 ELSE 0 END AS contain;
```

##### Quarter

```sql
SELECT TO_CHAR(NOW(), 'Q');
```

##### Week Number of Year

```sql
SELECT TO_CHAR(NOW(), 'IW');
```

> ISO 8601, 01–53(the first Thursday of the year is in week 1)

##### Day of Year

```sql
SELECT TO_CHAR(NOW(), 'DDD');
```

##### Day of Week

```sql
SELECT TO_CHAR(NOW(), 'ID'), CASE WHEN TO_CHAR(NOW(), 'ID') = '7' THEN '1' ELSE '' END AS col01;--ISO 8601 day of the week, Monday (1) to Sunday (7)
```

> ISO 8601, Monday (1) to Sunday (7)

##### Date

```sql
SELECT TO_CHAR(NOW(), 'YYYY-MM-DD HH24:MI:SS.MS'), '2023-06-16'::TIMESTAMP;
```

##### Date Add

```sql
SELECT NOW() - '1 hour'::INTERVAL;
```

##### Date Diff

```sql
SELECT EXTRACT(EPOCH FROM (NOW() - TO_TIMESTAMP('202112101643', 'YYYYMMDDHH24MI')));
```

##### Power

```sql
SELECT POWER(36, 8);
```

##### Regex

```sql
SELECT REGEXP_REPLACE('010-1234-1234', '[^0-9]', '', 'g') AS only_number;
SELECT REGEXP_REPLACE(' 앞에 한칸 뒤에 두칸  ', '^\s+|\s+$', '', 'g') AS trim_text;
SELECT REGEXP_REPLACE('12341234123456', '(\d{4})(\d{4})(\d+)', '\1-\2-\3') AS format_text;
```
##### Pad

```sql
SELECT LPAD('123', 7, '0');
```

##### GENERATE_SERIES

```sql
SELECT
	t_items
FROM
	GENERATE_SERIES('2023-01-01'::TIMESTAMP, '2023-01-02'::TIMESTAMP, '1 hour') AS t_items
;
```
