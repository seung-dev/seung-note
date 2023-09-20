--DROP TABLE IF EXISTS public.t_partition_range;
CREATE TABLE public.t_partition_range (
	date_updt TIMESTAMP NOT NULL DEFAULT NOW()
	, contents VARCHAR(4) DEFAULT ''
	, CONSTRAINT pk_t_partition_range PRIMARY KEY (date_updt)
) PARTITION BY RANGE(date_updt);


COMMENT ON TABLE public.t_partition_range IS '파티션 범위 테이블';

COMMENT ON COLUMN public.t_partition_range.date_updt  IS '수정일시';
COMMENT ON COLUMN public.t_partition_range.contents   IS '내용';


CREATE TABLE public.t_partition_range_202308 PARTITION OF public.t_partition_range FOR VALUES FROM ('2023-08-01 00:00:00') TO ('2023-09-01 00:00:00');
CREATE TABLE public.t_partition_range_202309 PARTITION OF public.t_partition_range FOR VALUES FROM ('2023-09-01 00:00:00') TO ('2023-10-01 00:00:00');
CREATE TABLE public.t_partition_range_202310 PARTITION OF public.t_partition_range FOR VALUES FROM ('2023-10-01 00:00:00') TO ('2023-11-01 00:00:00');
CREATE TABLE public.t_partition_range_202311 PARTITION OF public.t_partition_range FOR VALUES FROM ('2023-11-01 00:00:00') TO ('2023-12-01 00:00:00');


SELECT * FROM realinfo.t_rest_hist ORDER BY 1 DESC;
SELECT * FROM realinfo.t_rest_hist_202309 ORDER BY 1 DESC;


EXPLAIN ANALYZE
SELECT * FROM realinfo.t_rest_hist
WHERE
	date_updt > '2023-09-01'
ORDER BY
1 DESC
;



















