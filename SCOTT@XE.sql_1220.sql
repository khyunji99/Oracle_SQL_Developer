SELECT * FROM EMP;

-- SEQUENCE 생성하기
CREATE SEQUENCE DEPT_DEPTNO_SQ
INCREMENT BY 10
START WITH 10;
-- 숫자 10부터 시작하여 10씩 증가하는 SEQUENCE 생성

-- SEQUENCE 조회
DESC USER_SEQUENCES;

SELECT SEQUENCE_NAME, MIN_VALUE, MAX_VALUE, INCREMENT_BY, CYCLE_FLAG
FROM USER_SEQUENCES;
-- 현 계정이 가지고 있는 SEQUENCE들에 대한
-- SEQUENCE_NAME, MIN_VALUE, MAX_VALUE, INCREMENT_BY, CYCLE_FLAG 정보들 출력


-- SEQUENCE 값 확인 : CURVAL, NEXTVAL
SELECT DEPT_DEPTNO_SQ.NEXTVAL FROM DUAL; -- 계속 실행할 때마다 10씩 증가하는 결과를 도출한다
-- 실행할 때마다 시퀀스의 다음 값을 알려준다. <-- NEXTVAL
SELECT DEPT_DEPTNO_SQ.CURRVAL FROM DUAL;
-- 현재의 값을 알려준다. <-- CURRVAL




-- SEQUENCE 실무
CREATE SEQUENCE EMP_SEQ
START WITH 1
INCREMENT BY 1
MAXVALUE 100000;

DROP TABLE EMP01;

CREATE TABLE EMP01(
    EMPNO NUMBER(4) PRIMARY KEY,
--    ENAME VARCHAR2(10),  -- ORACLE 문자열 자료형
    ENAME VARCHAR(10),     -- ANSI 문자열 자료형
    HIREDATE DATE
);
-- VARCHAR2 = VARCHAR

INSERT INTO EMP01 VALUES (EMP_SEQ.NEXTVAL, 'JULIA', SYSDATE);
-- EMPNO 에는 우리가 만든 EMP_SEQ 시퀀스의 다음 값을 넣어준다.

SELECT * FROM EMP01;
-- INSERT INTO EMP01 값 추가를 5번 해줬더니 다음과 같이 출력된다.



-- SEQUENCE 제거와 수정
SELECT SEQUENCE_NAME, MAX_VALUE, INCREMENT_BY, CYCLE_FLAG
FROM USER_SEQUENCES;
-- 삭제하고 싶은 SEQUENCE를 찾기 위해 먼저 SEQUENCE들을 조회한다.

-- DEPT_DEPTNO_SQ 삭제
DROP SEQUENCE DEPT_DEPTNO_SQ;

-- EMP_SEQ 의 MAX_VALUE 값을 수정
ALTER SEQUENCE EMP_SEQ
MAXVALUE 100;
-- MAXVALUE 값 100000 에서 100 으로 수정한다.


-- Q1. 최소값 1, 최대값 99999999, 1000부터 시작해서 1씩 증가하는 ORDERS_SEQ 라는 시퀀스를 만들어보자.
DROP SEQUENCE ORDERS_SEQ;

CREATE SEQUENCE ORDERS_SEQ
START WITH 1000
INCREMENT BY 1
MAXVALUE 99999999
MINVALUE 1;

SELECT ORDERS_SEQ.NEXTVAL FROM DUAL;
SELECT ORDERS_SEQ.CURRVAL FROM DUAL;



-----------------------------------------------------------------------------------------------------------------

-- 16. 인덱스 INDEX : 색인

-- 인덱스 정보 조회하기
SELECT INDEX_NAME, TABLE_NAME, COLUMN_NAME
FROM USER_IND_COLUMNS
WHERE TABLE_NAME IN ('EMP',  'DEPT');
-- 'EMP'와  'DEPT' 테이블에 인덱스가 있다면 인덱스의 이름, 테이블의 이름, 칼럼의 이름을 출력하는 것
-- PK 는 기본적으로 인덱스에 걸린다,,
-- PK 용도가 데이터를 찾기 위한 용도이므로 인덱스의 용도와 같기에 걸린다.



-- 조회 속도 비교

-- 칼럼으로 검색하기
-- 사원 테이블 복사하기
DROP TABLE EMP01;

CREATE TABLE EMP01
AS 
SELECT * FROM EMP;

SELECT TABLE_NAME, INDEX_NAME, COLUMN_NAME
FROM USER_IND_COLUMNS
WHERE TABLE_NAME IN ('EMP', 'EMP01');
-- EMP 테이블을 복사한 EMP01 테이블에도 과연 인덱스가 있을까??
-- 테이블 전체를 복사해도 데이터와 테이블 틀만 복사가 되지 인덱스는 복사되지 않는다. 

-- 인덱스가 아닌 칼럼으로 검색하기
-- 테이블 자체 복사를 여러번 반복해서 상당히 많은 양의 행을 생성한다.
INSERT INTO EMP01
SELECT * FROM EMP01;
-- 자기 자신은 SELECT 해서 넣는다..
-- 넣을 때마다 2배의 행의 개수가 된다.
-- 이렇게 칼럼의 수를 계속 어마무시하게 추가하게 된 후에 내가 원하는 데이터를 검색해서 찾으려고 하면
-- 시간이 얼마나 걸릴까,,, 아무래도 좀 오래 걸릴 것이다,,

SELECT COUNT(*) FROM EMP01;

INSERT INTO EMP01 (EMPNO, ENAME) VALUES(1111, 'SES');

SET TIMING ON
SELECT DISTINCT EMPNO, ENAME
FROM EMP01
WHERE ENAME='SES';



-- 4. 인덱스로 조회하기 --
-- 인덱스 설정하기
CREATE INDEX IDX_EMP01_ENAME
ON EMP01(ENAME);

-- 인덱스 설정 후 데이터 검색
SET TIMING ON
SELECT DISTINCT EMPNO, ENAME
FROM EMP01
WHERE ENAME='SES';


-- 인덱스 제거하기
DROP INDEX IDX_EMP01_ENAME;

-- 인덱스 제거하고 데이터 찾기
SET TIMING ON
SELECT DISTINCT EMPNO, ENAME
FROM EMP01
WHERE ENAME='SES';
-- 인덱스를 제거했기 때문에 다시 칼럼으로 데이터 조회가 되어 찾는데 시간이 걸린다.



-----------------------------------------------------------------------------------------------------------
-- 17. 사용자 관리

--시스템 권한 : CREATE USER
CREATE USER USER10 IDENTIFIED BY USER10;
-- 권한이 없어서 안만들어짐




SHOW USER;
-- 객체 권한 부여
GRANT SELECT ON EMP TO USER01;

SELECT * FROM SCOTT.EMP; -- 원칙적으로는 이렇게 표현해서 코드를 적어줘야한다. 하지만 아래의 코드처럼 적어도 출력이 된다.
SELECT * FROM EMP;

-- 부여하고 부여된 권한 조회
SELECT * FROM USER_TAB_PRIVS_MADE;  -- 자신이 부여한 객체권한
SELECT * FROM USER_TAB_PRIVS_RECD;  -- 자신이 받은 객체권한


-- 객체 권한 제거하기
REVOKE SELECT ON EMP FROM USER01;


-- WITH GRANT OPTION
GRANT SELECT ON SCOTT.EMP TO USER02
WITH GRANT OPTION;
-- SCOTT이 가지고 있는 EMP 객체에 접근할 수 있는 권한을 USER02에게 부여함
-- WITH GRANT OPTION 권한을 받았기 때문에 USER02에서도 이제 다른 계정에게 권한을 부여할 수 있게 되었다.











