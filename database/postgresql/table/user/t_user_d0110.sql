--DROP TABLE IF EXISTS restful.t_user_d0110;
CREATE TABLE restful.t_user_d0110
(
  user_no      VARCHAR(16) NOT NULL,
  user_role    VARCHAR(1)  NOT NULL,
  date_inst    TIMESTAMP   NOT NULL DEFAULT NOW(),
  date_updt    TIMESTAMP   NOT NULL DEFAULT NOW(),
  user_no_updt VARCHAR(16) NOT NULL,
  CONSTRAINT pk_t_user_d0110 PRIMARY KEY (user_no, user_role)
);


COMMENT ON TABLE restful.t_user_d0110 IS '사용자 권한목록';

COMMENT ON COLUMN restful.t_user_d0110.user_no IS '사용자번호';
COMMENT ON COLUMN restful.t_user_d0110.user_role IS '사용자권한 - S: Seung, C: Cheif, D: Director, M: Manager, U: User';
COMMENT ON COLUMN restful.t_user_d0110.date_inst IS '등록일시';
COMMENT ON COLUMN restful.t_user_d0110.date_updt IS '수정일시';
COMMENT ON COLUMN restful.t_user_d0110.user_no_updt IS '수정사용자번호 - t_user_d0100.user_no';


SELECT * FROM restful.t_user_d0110;







