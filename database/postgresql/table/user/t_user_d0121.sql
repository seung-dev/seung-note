--DROP TABLE IF EXISTS restful.t_user_d0121;
CREATE TABLE restful.t_user_d0121
(
  edit_no   VARCHAR(16) NOT NULL,
  created_at TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
  username  VARCHAR(32) NOT NULL,
  expired_at TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP + '10 minutes'::INTERVAL,
  email     VARCHAR(64) NOT NULL,
  date_done TIMESTAMP  ,
  CONSTRAINT pk_t_user_d0121 PRIMARY KEY (edit_no)
);


COMMENT ON TABLE restful.t_user_d0121 IS '사용자 비밀번호 변경요청';

COMMENT ON COLUMN restful.t_user_d0121.edit_no IS '수정번호';
COMMENT ON COLUMN restful.t_user_d0121.created_at IS '등록일시';
COMMENT ON COLUMN restful.t_user_d0121.updated_at IS '수정일시';
COMMENT ON COLUMN restful.t_user_d0121.username IS '로그인아이디 - d0120.username';
COMMENT ON COLUMN restful.t_user_d0121.expired_at IS '수정만료일시';
COMMENT ON COLUMN restful.t_user_d0121.email IS '이메일';
COMMENT ON COLUMN restful.t_user_d0121.date_done IS '처리일시';


SELECT * FROM restful.t_user_d0121;













