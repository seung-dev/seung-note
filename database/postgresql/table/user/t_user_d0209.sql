--DROP TABLE IF EXISTS restful.t_user_d0209;
CREATE TABLE restful.t_user_d0209
(
  org_no       VARCHAR(16) NOT NULL,
  user_no      VARCHAR(16) NOT NULL,
  created_at    TIMESTAMP   NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMP   NOT NULL DEFAULT NOW(),
  updated_by VARCHAR(16) NOT NULL,
  CONSTRAINT pk_t_user_d0209 PRIMARY KEY (org_no, user_no)
);


COMMENT ON TABLE restful.t_user_d0209 IS '조직 사용자목록';

COMMENT ON COLUMN restful.t_user_d0209.org_no IS '조직번호 - t_user_d0200.org_no';
COMMENT ON COLUMN restful.t_user_d0209.user_no IS '사용자번호 - t_user_d0100.user_no';
COMMENT ON COLUMN restful.t_user_d0209.created_at IS '등록일시';
COMMENT ON COLUMN restful.t_user_d0209.updated_at IS '수정일시';
COMMENT ON COLUMN restful.t_user_d0209.updated_by IS '수정사용자번호 - t_user_d0100.user_no';


SELECT * FROM restful.t_user_d0209;

















