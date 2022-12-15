-- 지난 시간 복습
-- ORACLE OUTER JOIN
SELECT E.ENAME, M.ENAME
FROM EMP E, EMP M
WHERE E.MGR = M.EMPNO;
--> ENAME에는 KING이 나오지 않음

SELECT E.ENAME, M.ENAME
FROM EMP E, EMP M
WHERE E.MGR = M.EMPNO(+); -- LEFT OUTER JOIN 과 같은 결과
--> ENAME 에 KING도 포함해서 출력됨

SELECT E.ENAME, M.ENAME
FROM EMP E, EMP M
WHERE E.MGR(+) = M.EMPNO; -- RIGHT OUTER JOIN과 같은 결과


-- ANSI OUTER JOIN

-- (1) ANSI LEFT OUTER JOIN
-- 조인문이 왼쪽에 있는 테이블의 모든 결과를 가져온 후
-- 오른쪽 테이블의 데이터를 매칭하고, 매칭되는 데이터가 없는 경우 NULL로 표시한다.
SELECT E.ENAME, M.ENAME
FROM EMP E LEFT OUTER JOIN EMP M
ON E.MGR = M.EMPNO;



-- 08. 서브쿼리 : 조인으로 한 것을 서브쿼리로 바꿔서 적을 수 있다.
SELECT DNAME
FROM DEPT
WHERE DEPTNO = (SELECT DEPTNO
                           FROM EMP
                           WHERE ENAME='SCOTT');

-- 위의 코드를 JOIN 조인으로 한 방법
SELECT DNAME
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO
AND EMP.ENAME='SCOTT';



-- 08-02. 단일행 서브 쿼리 : 비교연산자 사용 가능
SELECT ENAME, SAL
FROM EMP
WHERE SAL > ( SELECT AVG(SAL) FROM EMP);

SELECT AVG(SAL) FROM EMP;



-- 08-03. 다중행 서브 쿼리 : 비교연산자 사용 불가

--03-01. IN 연산자 : 서브 쿼리의 결과 중 하나라도 일치하면 메인 쿼리의 WHERE 절은 참이 된다.
SELECT ENAME, SAL, DEPTNO
FROM EMP
WHERE DEPTNO IN ( SELECT DISTINCT DEPTNO
    FROM EMP
    WHERE SAL >= 3000);
-- DEPTNO =10 일때랑 DEPTNO=20일때 두 경우 해당하는 것 다 출력

SELECT DISTINCT DEPTNO
    FROM EMP
    WHERE SAL >= 3000;
-- DEPTNO = 10, 20 두개 출력



-- 03-02. ALL 연산자 : 메인 쿼리의 비교 조건이 서브 쿼리의 검색 결과와 모든 값이 일치하면 참
SELECT ENAME, SAL
FROM EMP
WHERE SAL > ALL ( SELECT SAL
    FROM EMP
    WHERE DEPTNO = 30);
-- 서브 쿼리의 출력 결과의 모든것을 다 만족해서 그 모든것들 보다 큰 SAL을 찾는게 WHERE절
-- 서브 쿼리 검색한 결과 가장 큰 값은 2850이다. 그러니깐 WHERE절은 2850보다 큰 SAL인 조건이 된다.

SELECT SAL
    FROM EMP
    WHERE DEPTNO = 30;
-- 6개의 SAL 값 출력 ( 그중 가장 큰 SAL 값은 2850, 가장 작은 SAL 값은 950 이다.)



-- 03-03. ANY 연산자 : 서브 쿼리의 검색 결과와 하나만 이라도 일치하면 메인 쿼리의 WHERE절은 참
SELECT ENAME, SAL
FROM EMP
WHERE SAL > ANY ( SELECT SAL
    FROM EMP
    WHERE DEPTNO = 30);
-- 서브 쿼리의 결과 중 가장 작은 SAL값인 950 보다만 메인 쿼리의 SAL 값이 크면 하나 이상 다
-- 만족하게 되면 WHERE 절은 참이 된다.



-- 03-04. EXISTS 연산자 : 서브 쿼리의 결과값이 하나만이라도 존재한다면
--                               메인 쿼리의 조건식은 모두 TRUE, 존재하지 않으면 조건식은 FALSE

SELECT *
FROM EMP
WHERE 1=1;
-- 1=1 은 무조건 참이다. -> WHERE 조건절 참이니 모든 컬럼 다 출력됨

SELECT *
FROM EMP
WHERE EXISTS ( SELECT DNAME
    FROM DEPT
    WHERE DEPTNO=10 );
-- SELECT DNAME FROM DEPT WHERE DEPTNO=10 의 값이 ACCOUNTING 으로 하나 존재한다.
-- 따라서 서브 쿼리의 결과 값이 ACCOUNTING 으로 하나 존재하므로 메인 쿼리는 출력 된다.


SELECT DNAME
    FROM DEPT
    WHERE DEPTNO=60;

SELECT *
FROM EMP
WHERE EXISTS ( SELECT DNAME
    FROM DEPT
    WHERE DEPTNO=60 );
-- SELECT DNAME FROM DEPT WHERE DEPTNO=60 의 값은 하나도 존재하지 않는다.
-- 따라서 서브 쿼리의 결과값이 하나도 존재하지 않아 WHERE절 조건식은 FALSE가 되어
-- 메인 쿼리는 아무것도 출력이 안된다. 


-- 8장 08-02-02번 과제 문제
-- IN연산자를 이용하여 부서별로 가장 많은 급여를 받는 사원의 정보
-- (사원번호,사원명,급여,부서번호)를 출력하는 SQL문을 작성 하세요.

UPDATE EMP SET SAL=2850
WHERE ENAME='SMITH';

SELECT *
FROM EMP;

SELECT EMPNO, ENAME, SAL, DEPTNO
FROM EMP
WHERE (DEPTNO, SAL) IN (SELECT DEPTNO, MAX(SAL)
FROM EMP
GROUP BY DEPTNO
);
-- DEPTNO 와 SAL 을 같이 비교해줘야 하는 이유!
-- SMITH는 DEPTNO = 20인데 DEPTNO=30의 MAX(SAL) = 2850의 SAL값을 가지고 있다.
-- 그래서 DEPTNO 을 같이 비교 안해주면 DETPNO=20에서의 MAX(SAL)=3000인데
-- SMITH는 2850이라서 출력되면 안되는데 SAL만 비교하면 출력이된다..!
-- 그래서 DEPTNO과 SAL을 같이 비교해줘야 각 DEPTNO에서의 MAX(SAL)값을 가지고
-- 각 DEPTNO에서 많이 받는 사람들만 출력이된다!!


SELECT EMPNO, ENAME, SAL, DEPTNO
FROM EMP
WHERE SAL IN (SELECT MAX(SAL)
FROM EMP
GROUP BY DEPTNO
);



-- 09. DDL : CREATE, ALTER, RENAME, TRUNCATE, DROP
--      --> 데이터베이스 설계 시에 잠깐 사용,, 그 후에는 잘 사용 안함
-- DML : INSERT, UPDATE, DELETE, SELECT

-- 01. CREATE TABLE
CREATE TABLE EX2_1 (
    COLUMN1 CHAR(10),
    COLUMN2 VARCHAR2(10),
    COLUMN3 VARCHAR2(10),
    COLUMN4 NUMBER
);

DESC EX2_1;

-- CREATE TABLE [실습 1 : 새로운 테이블 생성하기]
SELECT * FROM EMP01;

CREATE TABLE EMP01 (
    EMPNO NUMBER(4),
    ENAME VARCHAR2(20),
    SAL NUMBER(7, 2)
);

DESC EMP01;
SELECT * FROM EMP01;


-- CREATE TABLE [실습 2 : 서브 쿼리로 테이블 생성하기, 컬럼을 따로 지정 안해주고 이미 있는 테이블을 가지고 와서 그대로 새로운 테이블 만드는 것(이때, 값들도 다 똑같이 가져오게 된다.) , 즉 복사한 것이라고 생각하면 된다..! ]
CREATE TABLE EMP02
AS
SELECT * FROM EMP;
-- EMP 테이블을 가지고 와서 EMP02 테이블을 만들어라

DESC EMP02;


-- CREATE TABLE [ 실습 3 : 특정한 컬럼으로 구성된 복제 테이블 생성하기]
CREATE TABLE EMP03
AS
SELECT EMPNO, ENAME FROM EMP;

SELECT * FROM EMP03;


-- CREATE TABLE [ 실습 4 : 원하는 행(ROW)으로 구성된 복제 테이블 생성하기]
CREATE TABLE EMP05
AS
SELECT * FROM EMP
WHERE DEPTNO=10;

SELECT * FROM EMP05;



-- 테이블의 구조만 복사하기 ( 데이터 값은 없고 틀만 있는 것 )
CREATE TABLE EMP06
AS
SELECT * FROM EMP
WHERE 1=0;

SELECT * FROM EMP06;
DESC EMP06;



-- 9-2. 테이블 구조 변경하는 ALTER TABLE

-- 새로운 테이블 추가 [ 실습 : EMP01 테이블 JOB 컬럼 추가하기 ]
DESC EMP01;
-- EMPNO, ENAME, SAL 컬럼 가지고 있다.
ALTER TABLE EMP01
ADD (JOB VARCHAR2(9));
-- JOB 컬럼 추가함
-- 다시 EMP01 DESC 해보면 JOB 컬럼이 추가된 것을 볼 수 있다.


-- 기존 테이블 속성 변경
ALTER TABLE EMP01
MODIFY (JOB VARCHAR2(30));
-- JOB 컬럼의 개수 9에서 30으로 늘리기
DESC EMP01;



-- 기존 컬럼 삭제
ALTER TABLE EMP01
DROP COLUMN JOB;

DESC EMP01;




-- SET UNUSED
SELECT * FROM EMP02;

ALTER TABLE EMP02
SET UNUSED(JOB);
-- JOB 컬럼 락 걸어서 안보이게 함



-- DROP TABLE : 테이블 삭제
DROP TABLE EMP01;
SELECT * FROM EMP01;

DROP TABLE EMP02;
SELECT * FROM EMP02;


-- TRUNCATE : 모든 로우 삭제
SELECT * FROM EMP03;
DELETE FROM EMP03;  -- DML : DELETE, INSERT, UPDATE , SELECT  --> DML 은 운영환경에서 함부로,, 하면 안된다.
ROLLBACK;
TRUNCATE TABLE EMP03; -- DDL : TRUNCATE = DELETE + COMMIT, CREATE, ALTER, RENAME, DROP
-- DELETE 는 메모리에 있는 것을 지우는 것! 디스크에 있는 걸 메모리에 가져온 걸 지우는 것
-- 그래서 DELETE 하고 ROLLBACK  해도 디스크에서 다시 데이터를 가져와서 데이터 복구가 된다..
-- COMMIT 은 메모리에 있는 것을 지운걸 디스크에 반영을 하는것
-- 따라서 TRUNCATE는 COMMIT이 포함된 걸 의미하는데 디스크에서 가져온 데이터 메모리에 가져와
-- 메모리에 있는 데이터를 지우고 그 메모리에서 지운것을 디스크에 반영을 시켜서 디스크에서도 지워지게 된다.
-- 그래서 TRUNCATE 는 ROLLBACK 을 해도 지웠던 데이터가 다시 돌아오지 못한다,,,

-- 디스크에서 데이터를 메모리에 가져온다.
-- DELETE 는 그 메모리에 있는 데이터를 지우는 것!
-- 그래서 DELTE는 ROLLBACK을 하면 디스크에서 다시 데이터를 가져오면 되어서 데이터 복구가 가능하다.
-- 하지만 TRUNCATE 는 DELTE 에 COMMIT 까지 포함한 내용이라서 ROLLBACK해도 데이터 복구가 안된다.



-- RENAME TABLE : 테이블명 변경
RENAME EMP03 TO TEST;
SELECT * FROM EMP03;
SELECT * FROM TEST;
-- 이름을 TEST 로 바꾸면 EMP03을 찾으려고 해도 안찾아진다,,



-- USER_ 데이터 딕셔너리
SHOW USER;  -- 'SCOTT' 

DESC USER_TABLES;

SELECT TABLE_NAME FROM USER_TABLES
ORDER BY TABLE_NAME ASC;
--현 USER 인 SCOTT이 만든 테이블의 이름들이 오름차순으로 정렬해서 출력된다.
-- USER_ 로 시작하는 테이블들로 부터 테이블의 이름들 출력,,?


-- ALL_ 데이터 딕셔너리 
-- 오라클은 사용자 기반으로 테이블을 만든다. 
-- 계정을 만들 떄마다 그 안에 테이블들이 자동으로 만들어진다.
-- 테이블을 객체라고 생각하면 되는데,,
-- 스키마 (SCHEMA) = USER(의 객체들) = 계정들

SELECT * FROM DEPT;
SELECT * FROM SYSTEM.HELP; -- 다른 계정에서도 볼 수 있도록 권한을 준것,, (SCOTT 계정에서 SYSTEM 계정의 정보 본것)
-- 원래는 다른 계정에 있는 것들을 보려면 접근 권한? 이 있어야 한다.
-- 하지만 ALL_ 데이터  딕셔너리는 타 계정에서도 접근할 수 있는 데이터들이 담겨져있는 곳이다.


-- ALL_ 데이터 딕셔너리 : 내가 있는 계정에서 내꺼 말고 다른 계정의 다른 객체들(객체 중 하나가 테이블,,)을 사용할 수 있도록 정보를 제공해주는 것들을 가지고 있는 곳,,
DESC ALL_TABLES;
SELECT OWNER, TABLE_NAME FROM ALL_TABLES; -- SCOTT에서 접근이 가능한 테이블이름과 그 테이블이 있는 계정이름



-- SYS (SUPER),
-- SYSTEM (DBA),
-- SCOTT (USER)


SHOW USER;
SELECT TABLE_NAME, OWNER FROM DBA_TABLES;
-- SCOTT 계정에서는 DBA_ 데이터 딕셔너리에 접근 불가
--> 아마도,, SCOTT 계정은 DBA_ 데이터 딕셔너리에 접근할 수 있는 접근 권한이 없기 때문,,?
--> SYSTEM 계정에서는 DBA_TABLES 에 접근 가능해서 출력된다.




-- 10. DML ( Data Manipulation Language, 데이터 조작어) : INSERT, UPDATE, DELETE, SELECT
--     데이터 조작은 CRUD(CREATE / READ / UPDATE / DATE) 라고 할 수 있다.
--     CRUD = DB 개발자의 ????


-- 1. INSERT문
DESC DEPT01;

ALTER TABLE DEPT01
ADD(LOC VARCHAR2(10)); 

INSERT INTO DEPT01 VALUES(10, 'ACCOUNTING', 'NEW YORK');
SELECT * FROM DEPT01;

INSERT INTO DEPT01 VALUES(30, 'DEVELOPMENT', 'NULL');

-- INSERT INTO DEPT01 VALUES(30, 'DEVELOPMENT');
-- 이렇게 컬럼의 갯수 맞추지 않고 INSERT 하려고 하면 안들어간다.

INSERT INTO DEPT01 (DEPTNO, DNAME) VALUES (40, 'SALES');
-- 특정 컬럼에만 값을 INSERT 하고 싶다면 위에와 같은 형식으로 INSERT 해줘야 한다.





