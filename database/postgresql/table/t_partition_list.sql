--DROP TABLE IF EXISTS public.t_partition_list;
CREATE TABLE public.t_partition_list (
	username VARCHAR(32) NOT NULL
	, userstate VARCHAR(1) DEFAULT 'A'
	, date_inst TIMESTAMP NOT NULL DEFAULT NOW()
	, date_updt TIMESTAMP NOT NULL DEFAULT NOW()
	, mobile_no VARCHAR(17) DEFAULT ''
	, CONSTRAINT pk_t_partition_list PRIMARY KEY (username, userstate)
) PARTITION BY RANGE(username, userstate);


COMMENT ON TABLE public.t_partition_list IS '파티션 구분 테이블';

COMMENT ON COLUMN public.t_partition_list.username   IS '회원계정';
COMMENT ON COLUMN public.t_partition_list.userstate  IS '회원상태 - A: Active, L: Locked, H: Holding, C: Closed';
COMMENT ON COLUMN public.t_partition_list.date_inst  IS '등록일시';
COMMENT ON COLUMN public.t_partition_list.date_updt  IS '수정일시';
COMMENT ON COLUMN public.t_partition_list.mobile_no  IS '휴대전화번호';


CREATE TABLE public.t_partition_list_active PARTITION OF public.t_partition_list DEFAULT;
CREATE TABLE public.t_partition_list_closed PARTITION OF public.t_partition_list FOR VALUES IN ('C');


INSERT INTO public.t_partition_list (username, mobile_no) VALUES ('abc@email.com', '010-1234-1234'), ('efg@email.com', '010-9876-9876');


SELECT * FROM public.t_partition_list ORDER BY 1 DESC;
SELECT * FROM public.t_partition_list_default ORDER BY 1 DESC;
SELECT * FROM public.t_partition_list_active ORDER BY 1 DESC;
SELECT * FROM public.t_partition_list_closed ORDER BY 1 DESC;


UPDATE public.t_partition_list SET date_updt = NOW(), userstate = 'C' WHERE username = 'abc@email.com';


SELECT * FROM public.t_partition_list ORDER BY 1 DESC;
SELECT * FROM public.t_partition_list_default ORDER BY 1 DESC;
SELECT * FROM public.t_partition_list_active ORDER BY 1 DESC;
SELECT * FROM public.t_partition_list_closed ORDER BY 1 DESC;


EXPLAIN ANALYZE
SELECT * FROM public.t_partition_list
WHERE
	userstate = 'C'
	AND mobile_no ~ '1234'
ORDER BY 1 DESC
;









