--DROP TABLE IF EXISTS restful.t_user_d0209;
CREATE TABLE restful.t_user_d0209
(
  org_no       VARCHAR(16) NOT NULL,
  user_no      VARCHAR(16) NOT NULL,
  date_inst    TIMESTAMP   NOT NULL DEFAULT NOW(),
  date_updt    TIMESTAMP   NOT NULL DEFAULT NOW(),
  user_no_updt VARCHAR(16) NOT NULL,
  CONSTRAINT pk_t_user_d0209 PRIMARY KEY (org_no, user_no)
);


COMMENT ON TABLE restful.t_user_d0209 IS '조직 사용자목록';

COMMENT ON COLUMN restful.t_user_d0209.org_no IS '조직번호 - t_user_d0200.org_no';
COMMENT ON COLUMN restful.t_user_d0209.user_no IS '사용자번호 - t_user_d0100.user_no';
COMMENT ON COLUMN restful.t_user_d0209.date_inst IS '등록일시';
COMMENT ON COLUMN restful.t_user_d0209.date_updt IS '수정일시';
COMMENT ON COLUMN restful.t_user_d0209.user_no_updt IS '수정사용자번호 - t_user_d0100.user_no';


SELECT * FROM restful.t_user_d0209;

















