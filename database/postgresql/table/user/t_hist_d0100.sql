
--DROP TABLE IF EXISTS restful.t_hist_d0100 CASCADE;
CREATE TABLE restful.t_hist_d0100
(
  updated_at     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  trace_id      VARCHAR(18)  NOT NULL,
  request_time  TIMESTAMP    NOT NULL,
  response_time TIMESTAMP    NOT NULL,
  http_method   VARCHAR(7)   NOT NULL,
  scheme        VARCHAR(8)   NOT NULL,
  host          VARCHAR(32)  NOT NULL,
  port          VARCHAR(5)   NOT NULL,
  url_path      VARCHAR(64) ,
  url_query     VARCHAR(256),
  remote_addr   VARCHAR(15) ,
  content_type  VARCHAR(128),
  user_agent    VARCHAR(256),
  referer       VARCHAR(256),
  http_status   VARCHAR(3)   NOT NULL,
  user_no       VARCHAR(32) ,
  user_roles    VARCHAR(32) ,
  error_code    VARCHAR(8)  ,
  CONSTRAINT pk_t_hist_d0100 PRIMARY KEY (updated_at, trace_id)
) PARTITION BY RANGE(updated_at);


COMMENT ON TABLE restful.t_hist_d0100 IS 'REST 요청내역';

COMMENT ON COLUMN restful.t_hist_d0100.updated_at IS '수정일시';
COMMENT ON COLUMN restful.t_hist_d0100.trace_id IS 'Trace ID';
COMMENT ON COLUMN restful.t_hist_d0100.request_time IS 'Request Time';
COMMENT ON COLUMN restful.t_hist_d0100.response_time IS 'Response Time';
COMMENT ON COLUMN restful.t_hist_d0100.http_method IS 'HTTP Method';
COMMENT ON COLUMN restful.t_hist_d0100.scheme IS 'Protocol';
COMMENT ON COLUMN restful.t_hist_d0100.host IS 'Domain Name';
COMMENT ON COLUMN restful.t_hist_d0100.port IS 'Port';
COMMENT ON COLUMN restful.t_hist_d0100.url_path IS 'Path to Resource';
COMMENT ON COLUMN restful.t_hist_d0100.url_query IS 'Parameters';
COMMENT ON COLUMN restful.t_hist_d0100.remote_addr IS 'Remote Address';
COMMENT ON COLUMN restful.t_hist_d0100.content_type IS 'Request Content Type';
COMMENT ON COLUMN restful.t_hist_d0100.user_agent IS 'User Agent';
COMMENT ON COLUMN restful.t_hist_d0100.referer IS 'Referer';
COMMENT ON COLUMN restful.t_hist_d0100.http_status IS 'Http Status Code';
COMMENT ON COLUMN restful.t_hist_d0100.user_no IS 'User Unique Number';
COMMENT ON COLUMN restful.t_hist_d0100.user_roles IS 'User Roles';
COMMENT ON COLUMN restful.t_hist_d0100.error_code IS 'Result Code';


CREATE TABLE restful.t_hist_d0100_202311 PARTITION OF restful.t_hist_d0100 FOR VALUES FROM ('2023-11-01 00:00:00') TO ('2023-12-01 00:00:00');
CREATE TABLE restful.t_hist_d0100_202312 PARTITION OF restful.t_hist_d0100 FOR VALUES FROM ('2023-12-01 00:00:00') TO ('2024-01-01 00:00:00');
CREATE TABLE restful.t_hist_d0100_202401 PARTITION OF restful.t_hist_d0100 FOR VALUES FROM ('2024-01-01 00:00:00') TO ('2024-02-01 00:00:00');
CREATE TABLE restful.t_hist_d0100_202402 PARTITION OF restful.t_hist_d0100 FOR VALUES FROM ('2024-02-01 00:00:00') TO ('2024-03-01 00:00:00');
CREATE TABLE restful.t_hist_d0100_202403 PARTITION OF restful.t_hist_d0100 FOR VALUES FROM ('2024-03-01 00:00:00') TO ('2024-04-01 00:00:00');
CREATE TABLE restful.t_hist_d0100_202404 PARTITION OF restful.t_hist_d0100 FOR VALUES FROM ('2024-04-01 00:00:00') TO ('2024-05-01 00:00:00');
CREATE TABLE restful.t_hist_d0100_202405 PARTITION OF restful.t_hist_d0100 FOR VALUES FROM ('2024-05-01 00:00:00') TO ('2024-06-01 00:00:00');
CREATE TABLE restful.t_hist_d0100_202406 PARTITION OF restful.t_hist_d0100 FOR VALUES FROM ('2024-06-01 00:00:00') TO ('2024-07-01 00:00:00');
CREATE TABLE restful.t_hist_d0100_202407 PARTITION OF restful.t_hist_d0100 FOR VALUES FROM ('2024-07-01 00:00:00') TO ('2024-08-01 00:00:00');
CREATE TABLE restful.t_hist_d0100_202408 PARTITION OF restful.t_hist_d0100 FOR VALUES FROM ('2024-08-01 00:00:00') TO ('2024-09-01 00:00:00');
CREATE TABLE restful.t_hist_d0100_202409 PARTITION OF restful.t_hist_d0100 FOR VALUES FROM ('2024-09-01 00:00:00') TO ('2024-10-01 00:00:00');
CREATE TABLE restful.t_hist_d0100_202410 PARTITION OF restful.t_hist_d0100 FOR VALUES FROM ('2024-10-01 00:00:00') TO ('2024-11-01 00:00:00');
CREATE TABLE restful.t_hist_d0100_202411 PARTITION OF restful.t_hist_d0100 FOR VALUES FROM ('2024-11-01 00:00:00') TO ('2024-12-01 00:00:00');
CREATE TABLE restful.t_hist_d0100_202412 PARTITION OF restful.t_hist_d0100 FOR VALUES FROM ('2024-12-01 00:00:00') TO ('2025-01-01 00:00:00');


SELECT * FROM restful.t_hist_d0100;




