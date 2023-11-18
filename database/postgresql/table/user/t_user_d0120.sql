--DROP TABLE IF EXISTS restful.t_user_d0120;
CREATE TABLE restful.t_user_d0120
(
  username    VARCHAR(32) NOT NULL,
  date_inst   TIMESTAMP   NOT NULL DEFAULT NOW(),
  date_updt   TIMESTAMP   NOT NULL DEFAULT NOW(),
  user_no     VARCHAR(16) NOT NULL,
  password      VARCHAR(64) NOT NULL,
  password_expr TIMESTAMP   NOT NULL DEFAULT NOW() + '3 months'::INTERVAL,
  signin_fail SMALLINT    NOT NULL DEFAULT 0,
  is_temp     SMALLINT    NOT NULL DEFAULT 1,
  CONSTRAINT pk_t_user_d0120 PRIMARY KEY (username)
);


COMMENT ON TABLE restful.t_user_d0120 IS '사용자 계정정보';

COMMENT ON COLUMN restful.t_user_d0120.username IS '아이디';
COMMENT ON COLUMN restful.t_user_d0120.date_inst IS '등록일시';
COMMENT ON COLUMN restful.t_user_d0120.date_updt IS '수정일시';
COMMENT ON COLUMN restful.t_user_d0120.user_no IS '사용자번호 - t_user_d0100.user_no';
COMMENT ON COLUMN restful.t_user_d0120.password IS '비밀번호';
COMMENT ON COLUMN restful.t_user_d0120.password_expr IS '비밀번호만료일시 - Interval: 3 months';
COMMENT ON COLUMN restful.t_user_d0120.signin_fail IS '인증실패수';
COMMENT ON COLUMN restful.t_user_d0120.is_temp IS '임시비밀번호구분';


SELECT * FROM restful.t_user_d0120;











