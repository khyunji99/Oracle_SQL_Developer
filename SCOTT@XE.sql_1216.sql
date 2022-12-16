SELECT * FROM DEPT01;
DESC DEPT01;
INSERT INTO DEPT01 VALUES(10, '총무부', '서울');
INSERT INTO DEPT01 (DEPTNO, DNAME) VALUES(20,'개발부');

-- INSERT 구문의 오류 발생 예 1.
INSERT INTO DEPT01
(DEPTNO, DNAME, LOC) VALUES (30, 'ACCOUNTING', '서울', 20);

INSERT INTO DEPT01 VALUES (40, '영업부', NULL);

-- NULL 값을 삽입하는 방법
-- 암시적으로 NULL 값의 삽입
INSERT INTO DEPT01 (DEPTNO, DNAME) VALUES(20,'개발부');

-- 명시적으로 NULL 값의 삽입
INSERT INTO DEPT01 VALUES (40, '영업부', NULL);


-- 10-01-04. 서브쿼리로 데이터 삽입하기
DROP TABLE DEPT02;

CREATE TABLE DEPT02
AS
SELECT * FROM DEPT WHERE 1=0; -- 테이블 틀만 복사

SELECT * FROM DEPT02; -- 데이터 없이 테이블 틀만 복사된 것을 볼 수 있다.

INSERT INTO DEPT02 -- 메인 쿼리로 보는 것
--VALUES( ); -- 이걸로 안하고아래의 코드와 같이 데이터 삽입한다.
SELECT * FROM DEPT; -- 서브 쿼리로 보는 것,,




-- 다중 테이블에 다중행 입력하기
DESC EMP
SELECT * FROM EMP
WHERE DEPTNO=20;

DROP TABLE EMP_HIR;
CREATE TABLE EMP_HIR
AS 
SELECT EMPNO, ENAME, HIREDATE FROM EMP
WHERE 1=0;

SELECT * FROM EMP_HIR; 

DROP TABLE EMP_MGR;

CREATE TABLE EMP_MGR
AS 
SELECT EMPNO, ENAME, MGR FROM EMP
WHERE 1=0;

SELECT * FROM EMP_MGR;

INSERT ALL
INTO EMP_HIR VALUES(EMPNO, ENAME, HIREDATE)
INTO EMP_MGR VALUES(EMPNO, ENAME, MGR)
SELECT EMPNO, ENAME, HIREDATE, MGR
FROM EMP
WHERE DEPTNO=20;
-- 테이블 EMP_HIR과 EMP_MGR에 데이터를 동시에 넣고 있다.

SELECT EMPNO, ENAME, HIREDATE, MGR
FROM EMP
WHERE DEPTNO=20;
-- 여기 EMP 테이블에서의 각 컬럼에서 EMP_HIR에 필요한것만,
-- EMP_MGR에 필요한 컬럼들만 가져다가 삽입해준 것이다.

SELECT * FROM EMP_HIR;
SELECT * FROM EMP_MGR;



--- [ 실습 : INSERT ALL 명령에 조건 (WHEN)으로 다중 테이블에 다중행 입력하기 ] ----
DROP TABLE EMP_HIR02;

CREATE TABLE EMP_HIR02
AS
SELECT EMPNO, ENAME, HIREDATE FROM EMP
WHERE 1=0;

SELECT * FROM EMP_HIR02;

DROP TABLE EMP_SAL;

CREATE TABLE EMP_SAL
AS
SELECT EMPNO, ENAME, SAL FROM EMP
WHERE 1=0;

SELECT * FROM EMP_SAL;

INSERT ALL 
WHEN HIREDATE > '1982/01/01' THEN -- 이 조건을 만족하면 EMP_HIR02 테이블에 데이터 삽입하는 것
INTO EMP_HIR02 VALUES(EMPNO, ENAME, HIREDATE)
WHEN SAL > 2000 THEN
INTO EMP_SAL VALUES(EMPNO, ENAME, SAL)
SELECT EMPNO, ENAME, HIREDATE, SAL FROM EMP;
-- EMP 테이블에서 EMPNO, ENAME, HIREDATE, SAL 컬럼들을 가져와서
-- HIREDATE > '1982/01/01 조건을 만족하면 EMP_HIR02 테이블에
-- (EMPNO, ENAME, HIREDATE) 이 컬럼들의 데이터를 삽입해주고
--  SAL > 2000 조건을 만족하면 
-- EMP_SAL  테이블에 (EMPNO, ENAME, SAL) 컬럼들 데이터를 삽입해준다.

SELECT * FROM EMP_HIR02;
SELECT * FROM EMP_SAL;




-- UPDATE문
DROP TABLE EMP01;

CREATE TABLE EMP01
AS
SELECT * FROM EMP;

SELECT * FROM EMP01
ORDER BY SAL ASC;

UPDATE EMP01
SET DEPTNO = 30; -- 테이블 모든 행 변경

UPDATE EMP01
SET SAL = SAL * 1.1;

ROLLBACK; -- 롤백하면 그 앞에 업데이트 하기 완전 전으로 돌아간다,,

UPDATE EMP01
SET HIREDATE = SYSDATE;

SELECT * FROM EMP01;

--- 2. 테이블 특정 행만 변경 ---
DROP TABLE EMP01;

CREATE TABLE EMP01
AS
SELECT * FROM EMP;

SELECT * FROM EMP01;

UPDATE EMP01
SET DEPTNO=30
WHERE DEPTNO=10; -- 특정 행만 변경


UPDATE EMP01
SET SAL = SAL * 1.1
WHERE SAL < 3000;


UPDATE EMP01
SET HIREDATE = SYSDATE
WHERE SUBSTR(HIREDATE, 1, 2) = '87';
-- HIREDATE에서 첫번째에서 두개를 추출했을 때 87인 경우


--- 3. 테이블에서 2개 이상의 컬럼값 변경 ---
-- 앞서서는 계속 컬럼 1개의 값만 변경했음 --
DROP TABLE EMP01;

CREATE TABLE EMP01
AS
SELECT * FROM EMP;

SELECT * FROM EMP01;

UPDATE EMP01
SET DEPTNO=20, JOB='MANAGER'
WHERE ENAME='SCOTT';

UPDATE EMP01
SET HIREDATE = SYSDATE, SAL = 3500, COMM = 4000
WHERE ENAME = 'SCOTT';


-- 서브 쿼리를 이용한 데이터 수정 --
SELECT * FROM DEPT01;

UPDATE DEPT01
SET LOC = (SELECT LOC FROM DEPT WHERE DEPTNO=20);



-- DELETE 문 --
-- 1. DELETE문 이용하여 행 삭제
DELETE FROM DEPT01; -- DEPT01 테이블에 있는 데이터 모두 지움
SELECT * FROM DEPT01;
ROLLBACK; -- DELETE하기 전으로 데이터 복구 가능

DELETE FROM DEPT01
WHERE DEPTNO=30; -- 2. 조건 제시하여 특정 행만 삭제

DELETE FROM DEPT01
WHERE DEPTNO = ( SELECT DEPTNO FROM DEPT WHERE DNAME = 'RESEARCH' ); -- 3. 서브 쿼리를 이용한 데이터 삭제

SELECT DEPTNO FROM DEPT WHERE DNAME = 'RESEARCH'; -- DEPTNO = 20




----- MERGE ----
DROP TABLE EMP01;

CREATE TABLE EMP01
AS 
SELECT * FROM EMP;

SELECT * FROM EMP01;

DROP TABLE EMP02;

CREATE TABLE EMP02
AS
SELECT * FROM EMP
WHERE JOB='MANAGER';

SELECT * FROM EMP02;

UPDATE EMP02
SET JOB='TEST';

SELECT * FROM EMP02;

-- 기존에 없던 데이터 새롭게 추가 --
INSERT INTO EMP02
VALUES(8000, 'SYJ', 'TOP', 7566, '2009/01/12', 1200, 10, 20);


-- EMP02를 가지고 EMP01에 MERGE 합병 하려는 것 --
-- EMP02 -- MERGE --> EMP01
-- MERGE 를 할땐 UPDATE를 해줘야하는데 EMP02에 기존에 있던건 UPDATE로 MERGE해주고
-- EMP02에 새롭게 추가한 데이터는 INSERT해서 EMP01에 MERGE해줘야한다.
MERGE INTO EMP01
USING EMP02
ON(EMP01.EMPNO=EMP02.EMPNO) -- EMPNO을 가지고 데이터가 같은지 아닌지 확인하겠다.
WHEN MATCHED THEN
UPDATE SET
EMP01.ENAME=EMP02.ENAME,
EMP01.JOB=EMP02.JOB,
EMP01.MGR=EMP02.MGR,
EMP01.HIREDATE=EMP02.HIREDATE,
EMP01.SAL=EMP02.SAL,
EMP01.COMM=EMP02.COMM,
EMP01.DEPTNO=EMP02.DEPTNO
WHEN NOT MATCHED THEN -- 매치가 안된다는 건 EMP01.EMPNO != EMP02.EMPNO 이라는 거고 그건 EMP01에는 없고 EMP02엔 있다는 거니깐 새로 추가된 데이터라는 뜻
INSERT VALUES(EMP02.EMPNO, EMP02.ENAME, EMP02.JOB, 
EMP02.MGR, EMP02.HIREDATE, EMP02.SAL, 
EMP02.COMM, EMP02.DEPTNO);
-- JOB이 MANAGER 였던 사람들은 UPDATE 되어서 MERGE 되었고
-- ENAME 'SYJ' 인 애는 기존에 없던 데이터여서 INSERT 되어서 MERGE 되었다.

SELECT * FROM EMP01;
INSERT INTO EMP01 (EMPNO, ENAME) VALUES (7369, '홍길동');
-- 이미 EMPNO이 7369인 사람이 존재하지만 위의 데이터가 또 추가가 된다.

DESC EMP;
-- 여기서 보면 EMPNO 은 NOT NULL이다.
-- EMPNO : 제약조건(PRIMARY KEY = NOT NULL + UNIQUE, 기본키) <-- 값을 꼭 넣어줘야한다. 값을 안넣어주면 안된다.
INSERT INTO EMP (EMPNO, ENAME) VALUES (7369, '홍길동'); --  ORA-00001: unique constraint (SCOTT.PK_EMP) violated 오류 발생
-- 이미 EMPNO에 7369가 있기 때문에 또 EMPNO이 7369인 데이터를 추가할 수가 없다. 왜? 중복되니깐
-- EMPNO은 NOT NULL + UNIQUE인 제약조건이 있기 때문에 중복된 데이터 들어갈 수 없다.
-- 그래서 위에서 중복된 값 추가하려고 하니 오류가 발생한것이다.




----------------------------------------------------------------------------------------------------------------------------------------------------

-- 11. 트랜잭션

DROP TABLE DEPT01;

CREATE TABLE DEPT01
AS
SELECT * FROM DEPT;

SELECT * FROM DEPT01;



---- 3. 자동 커밋 --
-- 실습 : CREATE문에 의한 자동 커밋
DROP TABLE DEPT02;

CREATE TABLE DEPT02
AS
SELECT * FROM DEPT;

SELECT * FROM DEPT02;

DELETE FROM DEPT02
WHERE DEPTNO=40; -- 아직 COMMIT 안함, 그래서 ROLLBACK 하면 데이터 복구 됨
ROLLBACK;

-- DDL 문은 AUTO COMMIT이 실행된다.
-- 따라서 CREATE DEPT03 하고나서 ROLLBACK을 해서 DEPT02 삭제 전으로 돌아가려고 ROLLBACK을 해도
-- ROLLBACK이 안된다,, CREATE는 DDL! DDL은 자동으로 COMMIT이 되기 때문에 ROLLBACK이 안됨,,
CREATE TABLE DEPT03
AS
SELECT * FROM DEPT;



-- 실습 : DDL의 실패에 의한 자동 커밋
DROP TABLE DEPT03;

CREATE TABLE DEPT03
AS
SELECT * FROM DEPT;

SELECT * FROM DEPT03;

DELETE FROM DEPT03
WHERE DEPTNO=20;

ROLLBACK; -- ROLLBACK하면 DEPTNO=20 삭제 전으로 돌아갈 수 있음


TRUNCATE TABLE DEPTPPP;  -- DEPTPPP 이름의 테이블이 없으므로 이 구문은 실행 실패가 된다.
-- 이 실행 실패되는 TRUNCATE 문을 실행 시킨 이후에 다시 앞으로 가서 ROLLBACK 해서
-- DEPT03 테이블 삭제 전으로 돌아가려고 하지만 TRUNCATE문이 실행되면서 자동 커밋되어
-- ROLLBACK 이 안된다.



--- SAVEPOINT -----
DROP TABLE DEPT01;

CREATE TABLE DEPT01
AS
SELECT * FROM DEPT;

SELECT * FROM DEPT01;

DELETE FROM DEPT01
WHERE DEPTNO=40;
COMMIT; -- DELETE=40;

DELETE FROM DEPT01
WHERE DEPTNO=30;
SAVEPOINT C1; -- DELETE=30;

DELETE FROM DEPT01
WHERE DEPTNO=20;
SELECT * FROM DEPT01;
SAVEPOINT C2; --DELETE 20

DELETE FROM DEPT01
WHERE DEPTNO=10;
SELECT * FROM DEPT01;

ROLLBACK TO C2; -- C2로 가면 20까지 삭제했던 때로 돌아감 -> DEPTNO = 10 출력됨
ROLLBACK TO C1; -- C1로 가면 30까지 삭제했던 때로 돌아감 -> DEPTNO = 10, 20 출력됨
ROLLBACK; -- 커밋된 때로 돌아감,,? -> DEPTNO = 10, 20, 30 출력됨




SELECT * FROM EMP01
WHERE ENAME = 'SCOTT';

DELETE FROM EMP01
WHERE ENAME = 'SCOTT';
-- 여기서 DELETE 해줘서 여기서는 안보이는데 cmd 창에서는 잘만 보인다.

ROLLBACK;

SELECT * FROM EMP01;

SELECT SAL FROM EMP01
WHERE ENAME='SCOTT';

COMMIT;



-- SET UNUSED
DROP TABLE EMP02;

CREATE TABLE EMP02
AS
SELECT * FROM EMP;

SELECT * FROM EMP02;


ALTER TABLE EMP02
SET UNUSED (COMM); -- COMM 컬럼을 UNUSED 하고 EMP02를 보게되면 삭제된것처럼 안보이게 된다! 실제로 삭제된건 아님!!

--  컬럼을 지우는 과정에 다른 사람이 그 컬럼을 가지고 막 변경하고 있으면 락이 걸리게 된다,,


-- DDL 명령의 롤백
DROP TABLE EMP01;

CREATE TABLE EMP01
AS
SELECT * FROM EMP;

SELECT * FROM EMP01; -- EMP01 은 원본 테이블

DROP TABLE EMP02;

CREATE TABLE EMP02 -- EMP02는 EMP01 복제한 테이블
AS
SELECT * FROM EMP01;

SELECT * FROM EMP02;

ALTER TABLE EMP01
DROP COLUMN JOB; -- 이 코드,, 실행 안됨,, 앞에서 JOB 컬럼에 UNUSED 해서 락이 걸렸다..!
                             -- 그래서 DROP 하려고 하니깐 오류 발생,, 어떡하지,,?
                             
                             
ROLLBACK;

DROP TABLE EMP01;
SELECT * FROM EMP02;




--- TRUNCATE 와 DELETE 차이점
-- 둘다 테이블의 모든 행을 삭제한다. TRUNCATE = DELETE + COMMIT
-- 작업 시 TRUNCATE 보다는 DELETE 를 사용하자!!
-- DELTET는 ROLLBACK이 가능하니깐,,, 혹,,시나 하는 위험을 방지할 수 있다.
DROP TABLE EMP01;
CREATE TABLE EMP01
AS
SELECT * FROM EMP;
SELECT * FROM EMP01;

TRUNCATE TABLE EMP01; -- DDL 명령어로서 자동 커밋이 발생하기 때문에 이전으로 되돌릴 수 없다.

SELECT * FROM EMP01;
ROLLBACK; -- ROLLBACK을 해도 데이터 복구 안된다.
SELECT * FROM EMP01;

DROP TABLE EMP02;
CREATE TABLE EMP02
AS
SELECT * FROM EMP;

SELECT * FROM EMP02;

DELETE FROM EMP02; -- DML 명령어이기 때문에 롤백을 수행하면 삭제 이전으로 되돌릴 수 있다.
SELECT * FROM EMP02;
ROLLBACK; -- ROLLBACK 하면 데이터 복구 된다.
SELECT * FROM EMP02;

DROP TABLE EMP03;
CREATE TABLE EMP03
AS
SELECT * FROM EMP;
SELECT * FROM EMP03;

DELETE FROM EMP03
WHERE DEPTNO =10 OR DEPTNO=20;

SELECT * FROM EMP03;
COMMIT; -- 커밋 후에는 트랜잭션이 종료된 것이므로 롤백 이미지가 제거된다.
ROLLBACK; -- 따라서 삭제 이전 상태로 돌아갈 수 없다.

SELECT * FROM EMP03;




--13장
SELECT * FROM EMP;
DESC EMP; -- EMPNO 컬럼이 NOT NULL 제약조건을 가지고 있다. --> EMPNO 컬럼에는 데이터가 없을 수 가 없다. NULL이 있을 수가 없다.
-- 그리고 EMPNO 컬럼은 NOT NULL 이면서 UNIQUE 한 PRIMARY KEY 제약조건이 있다.



















