-- 시스템 권한 : CREATE USER
CREATE USER USER10 IDENTIFIED BY USER10;
-- USER10을 생성하는데 Password가 USER10 이다.
-- USER를 생성하면 권한을 부여해줘야 한다.

GRANT CREATE SESSION TO USER10;

-- 사용자 비밀번호 변경
ALTER USER USER10 IDENTIFIED BY PWD;
-- 비밀번호를 USER10에서 PWD로 변경했다.

-- 권한을 부여하기 : GRANT
GRANT CREATE SESSION TO USER10; -- USER10에 권한 부여
GRANT CREATE TABLE TO USER10;
GRANT unlimited tablespace to USER10; -- 모든 테이블스페이스에 할당량을 줄 수 있는 권한 부여, 테이블스페이스에 대한 권한 부여
-- 권한을 부여 받아야 테이블을 만들고 그외 다른 객체들을 만들 수 있기 때문에 권한을 받아야한다,,



-- 테이블 스페이스 확인하기
SELECT USERNAME, DEFAULT_TABLESPACE
FROM DBA_USERS
WHERE USERNAME IN ('USER10', 'SCOTT');
-- USER 만들 때 테이블스페이스를 지정해서 만들 수 있다.
-- 위의 코드를 실행하면 각각의 계정이 어떠한 테이블을 사용하고 있는 알 수 있다.


-- USER10은 지금 SYSTEM 테이블스페이스로 되어 있다. USERS 테이블스페이스로 변경해보자
-- 테이블 스페이스 변경하기
ALTER USER USER10 DEFAULT TABLESPACE USERS;
ALTER USER USER10 TEMPORARY TABLESPACE TEMP;


-- 테이블스페이스의 쿼터 할당하기
ALTER USER USER10
QUOTA 1000M ON USERS;
-- USERS테이블에서 1기가를 쿼터 할당받아 사용하겠다..?
-- USERS라는 테이블스페이스에 SCOTT계정과 여러 데이터들이 존재한다..



-- WITH ADMIN OPTION
CREATE USER USER02 IDENTIFIED BY TIGER;
GRANT CREATE SESSION TO USER02 WITH ADMIN OPTION;
-- CREATE SESSION을 주면서 WITH ADMIN OPTION을 준것,,
-- WITH ADMIN OPTION : CREATE SESSION 권한의 DBA 관리자 권한을 다른 계정에게 부여할 수 있게끔 하는 권한을 부여해준다.

CREATE USER USER03 IDENTIFIED BY TIGER;
GRANT CREATE SESSION TO USER03;
-- USER03은 WITH ADMIN OPTION 권한 없이 CREATE SESSION 권한만 받아서
-- 다른 계정에게 CREATE SESSION 권한을 줄 수 없다.

CREATE USER USER01 IDENTIFIED BY TIGER; -- USER01은 권한 없이 만듦.


