--DROP TABLE IF EXISTS restful.t_user_d0200;
CREATE TABLE restful.t_user_d0200
(
  org_no      VARCHAR(16) NOT NULL,
  date_inst   TIMESTAMP   NOT NULL DEFAULT NOW(),
  date_updt   TIMESTAMP   NOT NULL DEFAULT NOW(),
  org_domain  VARCHAR(16) NOT NULL,
  is_active   SMALLINT    NOT NULL DEFAULT 1,
  org_no_prev VARCHAR(16) NOT NULL,
  org_layer   SMALLINT    NOT NULL DEFAULT 1,
  org_name    VARCHAR(32) NOT NULL,
  CONSTRAINT pk_t_user_d0200 PRIMARY KEY (org_no)
);


CREATE UNIQUE INDEX uni_t_user_d0200 ON restful.t_user_d0200 (org_domain);

CREATE INDEX idx_0_t_user_d0200 ON restful.t_user_d0200 (is_active);


COMMENT ON TABLE restful.t_user_d0200 IS '조직 기본정보';

COMMENT ON COLUMN restful.t_user_d0200.org_no IS '조직번호';
COMMENT ON COLUMN restful.t_user_d0200.date_inst IS '등록일시';
COMMENT ON COLUMN restful.t_user_d0200.date_updt IS '수정일시';
COMMENT ON COLUMN restful.t_user_d0200.org_domain IS '조직도메인';
COMMENT ON COLUMN restful.t_user_d0200.is_active IS '사용구분 - 0: 미사용, 1: 사용';
COMMENT ON COLUMN restful.t_user_d0200.org_no_prev IS '상위조직번호';
COMMENT ON COLUMN restful.t_user_d0200.org_layer IS '조직위치';
COMMENT ON COLUMN restful.t_user_d0200.org_name IS '조직이름';


INSERT INTO restful.t_user_d0200
(
	org_no
	, org_domain
	, org_no_prev
	, org_layer
	, org_name
)
VALUES
(
	REPEAT('0', 16)
	, 'seung'
	, ''
	, 0
	, 'seung'
)
;


SELECT * FROM restful.t_user_d0200;
















