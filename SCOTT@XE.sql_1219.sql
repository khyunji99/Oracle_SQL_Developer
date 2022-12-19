
-- 3. 제약조건 확인하기
SELECT * FROM DEPT;

INSERT INTO DEPT VALUES(10, 'TEST', 'SEOUL'); -- unique constraint (SCOTT.PK_DEPT) violated 오류발생
-- DEPTNO 의 PRIMARY KEY 제약조건을 위반해서 오류가 발생한것
-- PRIMARY KEY 제약조건이란 NULL 허용 X + 중복된 값 허용 X

DESC DEPT;

DESC USER_CONSTRAINTS;

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME
FROM USER_CONSTRAINTS
WHERE TABLE_NAME='DEPT';


-- NOT NULL 제약 조건을 설정하지 않고 테이블 생성하기
DROP TABLE EMP01;

CREATE TABLE EMP01(
    EMPNO NUMBER(4),
    ENAME VARCHAR2(10),
    JOB VARCHAR2(9),
    DEPTNO NUMBER(2)
);

SELECT * FROM EMP01;

INSERT INTO EMP01 VALUES(NULL, NULL, 'SALESMAN', 30); -- 데이터 추가가 된다.
-- EMPNO와 ENAME은 값이 무조건 있어야하는데 NOT NULL 제약조건이 없어서 NULL값이 그냥 들어가버림,,


-- NOT NULL 제약조건을 설정하여 테이블 생성하기
DROP TABLE EMP02;

CREATE TABLE EMP02(
    EMPNO NUMBER(4) NOT NULL,
    ENAME VARCHAR2(10) NOT NULL,
    JOB VARCHAR2(9),
    DEPTNO NUMBER(2)
);

INSERT INTO EMP02 VALUES(NULL, NULL, 'SALESMAN', 30); -- cannot insert NULL into ("SCOTT"."EMP02"."EMPNO") 오류 발생
-- NOT NULL 제약 조건을 추가함으로써 EMPNO와 ENAME 에 우리가 원하는 것처럼 NULL값이 추가가 안된다.

INSERT INTO EMP02 VALUES(1, NULL, 'SALESMAN', 30); -- cannot insert NULL into ("SCOTT"."EMP02"."ENAME") 오류 발생

INSERT INTO EMP02 VALUES(1, '홍길동', 'SALESMAN', 30); -- 다 값이 있게 데이터 추가하니깐 추가가 된다.

SELECT * FROM EMP02;





-- UNIQUE 제약 조건을 설정하여 테이블 생성하기
DROP TABLE EMP03;

CREATE TABLE EMP03(
    EMPNO NUMBER(4) UNIQUE,
    ENAME VARCHAR2(10) NOT NULL,
    JOB VARCHAR2(9),
    DEPTNO NUMBER(2)
);

INSERT INTO EMP03 VALUES(1499, 'ALLEN', 'SALESMAN', 30);

SELECT * FROM EMP03;

INSERT INTO EMP03 VALUES(1499, 'JONES', 'MANAGER', 20); -- unique constraint (SCOTT.SYS_C007006) violated 오류 발생으로 데이터 추가 안됨
-- EMPNO의 UNIQUE 조건을 위배했으므로 오류발생함

INSERT INTO EMP03 VALUES(NULL, 'JONES', 'MANAGER', 20); -- 데이터 추가 O
INSERT INTO EMP03 VALUES(NULL, 'JONES2', 'MANAGER', 20); -- 데이터 추가 O
INSERT INTO EMP03 VALUES(NULL, 'JONES3', 'MANAGER', 20); -- 데이터 추가 O
-- UNIQUE 조건에서는 NULL은 여러개 추가가 가능하다.
-- NULL은 UNIQUE한지 안한지 알 수 없기 때문이다.





--- 4. 칼럼 레벨로 제약 조건명을 명시하여 제약조건 설정   VS  테이블 레벨로 제약조건명을 명시하여 제약조건 설정

DROP TABLE EMP03;

CREATE TABLE EMP03(
    EMPNO NUMBER(4) CONSTRAINT EMP03_EMPNO_UQ UNIQUE, -- 칼럼 레벨의 방식
    ENAME VARCHAR2(10) NOT NULL,
    JOB VARCHAR2(9),
    DEPTNO NUMBER(2)
);

INSERT INTO EMP03 VALUES(1499, 'ALLEN', 'SALESMAN', 30);

SELECT * FROM EMP03;

INSERT INTO EMP03 VALUES(1499, 'JONES', 'MANAGER', 20); -- unique constraint (SCOTT.EMP03_EMPNO_UQ) violated
-- 다음과 같이 오류 발생 시 출력될 때 내가 지정한 제약조건의 이름으로 출력된다

INSERT INTO EMP03 VALUES(NULL, 'JONES', 'MANAGER', 20); -- 데이터 추가 O
INSERT INTO EMP03 VALUES(NULL, 'JONES2', 'MANAGER', 20); -- 데이터 추가 O
INSERT INTO EMP03 VALUES(NULL, 'JONES3', 'MANAGER', 20); -- 데이터 추가 O


SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME
FROM USER_CONSTRAINTS
WHERE TABLE_NAME='EMP03';


-- PRIMARY KEY(기본키) 제약조건 설정하기
DROP TABLE EMP05;

CREATE TABLE EMP05(
    EMPNO NUMBER(4) CONSTRAINT EMP05_EMPNO_PK PRIMARY KEY,
    ENAME VARCHAR2(10) CONSTRAINT EMP05_ENAME_NN NOT NULL,
    JOB VARCHAR2(9),
    DEPTNO NUMBER(2)
);

INSERT INTO EMP05 VALUES(7499, 'ALLEN', 'SALESMAN', 30);
SELECT * FROM EMP05; 
INSERT INTO EMP05 VALUES(7499, 'JONES', 'MANAGER', 20);
-- SQL Error: ORA-00001: unique constraint (SCOTT.EMP05_EMPNO_PK) violated
-- 제약조건 EMPNO_PK 에 위배되어 데이터 추가가 안된다.
INSERT INTO EMP05 VALUES(NULL, 'JONES', 'MANAGER', 20);
-- SQL Error: ORA-01400: cannot insert NULL into ("SCOTT"."EMP05"."EMPNO")



--  EMP, DEPT 테이블의 제약조건 확인 (FOREIGN KEY 제약 조건)

-- EMP, DEPT 테이블의 제약조건 확인
SELECT TABLE_NAME, CONSTRAINT_TYPE, 
CONSTRAINT_NAME, R_CONSTRAINT_NAME
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN ('DEPT', 'EMP');

-- 왜래 키(FOREIGN KEY) 제약조건 설정하기
DROP TABLE EMP06;
CREATE TABLE EMP06( 
EMPNO NUMBER(4) CONSTRAINT EMP06_EMPNO_PK PRIMARY KEY ,
ENAME VARCHAR2(10) CONSTRAINT EMP06_ENAME_NN NOT NULL, 
JOB VARCHAR2(9),
DEPTNO NUMBER(2) CONSTRAINT EMP06_DEPTNO_FK REFERENCES DEPT(DEPTNO)
);

INSERT INTO EMP06 VALUES(7499, 'ALLEN','SALESMAN', 30);
SELECT * FROM EMP06;
INSERT INTO EMP06 VALUES(7498, 'JONES', 'MANAGER', 50);
-- ORA-02291: integrity constraint (SCOTT.EMP06_DEPTNO_FK) violated - parent key not found
-- EMP의 DEPTNO 은 DEPT 테이블의 DEPTNO을 참조하는데
-- EMP 테이블 DEPTNO을 지금 DEPT 테이블에는 없는 DEPTNO 50을 추가하려고 해서
-- DEPT 테이블의 DEPTNO 칼럼에 50 값이 있는지 봤더니 50이라는 값이 없어서
-- 참조해야 하는 제약조건이 위배되어서 오류가 난 것이다.

SELECT * FROM DEPT;

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME, R_CONSTRAINT_NAME
FROM USER_CONSTRAINTS
WHERE TABLE_NAME='EMP06';



-- CHECK 제약 조건 설정하기
DROP TABLE EMP07;

CREATE TABLE EMP07(
    EMPNO NUMBER(4) CONSTRAINT EMP07_EMPNO_PK PRIMARY KEY,
    ENAME VARCHAR2(10) CONSTRAINT EMP07_ENAME_NN NOT NULL,
    SAL NUMBER(7, 2) CONSTRAINT EMP07_SAL_CK CHECK(SAL BETWEEN 500 AND 5000), -- SAL 은 값이 500에서 5000인지 확인해주는 CHECK 제약조건
    GENDER VARCHAR2(1) CONSTRAINT EMP07_GENDER_CK CHECK(GENDER IN('M', 'F')) -- GENDER 의 값이 F 또는 M 만 들어왔는지 확인해주는 CHECK 제약조건 
);

INSERT INTO EMP07 VALUES(7499,'ALLEN',500,'M');
INSERT INTO EMP07 VALUES(7499,'ALLEN',7000,'A'); -- ORA-02290: check constraint (SCOTT.EMP07_GENDER_CK) violated

SELECT TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME, SEARCH_CONDITION
FROM USER_CONSTRAINTS
WHERE TABLE_NAME='EMP07';



-- DEFAULT 제약 조건 설정하기
DROP TABLE DEPT01;

CREATE TABLE DEPT01(
    DEPTNO NUMBER(2) PRIMARY KEY,
    DNAME VARCHAR2(14),
    LOC VARCHAR2(13) DEFAULT 'SEOUL' -- 원래는 값을 따로 지정해서 값을 추가해주지 않으면 NULL 값이 들어간다. 그런데 DEFAULT 제약조건을 해주면 LOC 칼럼에 값을 따로 지정해서 값을 추가해주지 않으면 SEOUL 값이 들어간다.  
);

INSERT INTO DEPT01(DEPTNO,DNAME) VALUES(10, 'ACCOUNTING');

SELECT * FROM DEPT01;




-- 컬럼 레벨로 제약 조건을 지정하는 방법
DROP TABLE EMP01;

CREATE TABLE EMP01(
    EMPNO NUMBER(4) PRIMARY KEY,
    ENAME VARCHAR2(10) NOT NULL,
    JOB VARCHAR2(9) UNIQUE,
    DEPTNO NUMBER(4) REFERENCES DEPT(DEPTNO)
);

-- 테이블 레벨로 제약 조건을 지정하는 방법
DROP TABLE EMP02;

CREATE TABLE EMP02(
    EMPNO NUMBER(4),
    ENAME VARCHAR2(10) NOT NULL,
    JOB VARCHAR2(9),
    DEPTNO NUMBER(4),
    PRIMARY KEY(EMPNO),
    UNIQUE(JOB),
    FOREIGN KEY(DEPTNO) REFERENCES DEPT(DEPTNO)
);



-- CASCADE 옵션으로 제약 조건 연속적으로 비활성화하기
--DROP TABLE DEPT01 CASCADE CONSTRAINTS;
DROP TABLE DEPT01;

CREATE TABLE DEPT01
AS
SELECT * FROM DEPT;
-- 제약조건은 복사가 안된다!! 데이터랑 테이블 틀만 복사가 됨,,

DESC DEPT;

SELECT * FROM DEPT01;
DESC DEPT01;
-- DEPT 테이블에는 있는 NOT NULL 제약조건이 없음. 따라서 따로 제약조건을 추가해줘야함

ALTER TABLE DEPT01
ADD CONSTRAINT DEPT01_DEPTNO_PK PRIMARY KEY (DEPTNO); --  <-- 테이블 레벨 방식으로 제약조건 설정해주는 것


DROP TABLE EMP01;

CREATE TABLE EMP01
AS
SELECT * FROM EMP WHERE 1=0;
-- 테이블 틀만 복사

SELECT * FROM EMP01;
DESC EMP01;
-- 제약조건 없음, 틀만 복사했기 때문

ALTER TABLE EMP01
ADD CONSTRAINT EMP01_DEPTNO_FK FOREIGN KEY (DEPTNO) REFERENCES DEPT01(DEPTNO);
-- 제약조건 EMP01 테이블에 추가해줌 
--ON DELETE CASCADE;

ALTER TABLE EMP01
ADD CONSTRAINT EMP01_DEPTNO_FK FOREIGN KEY (DEPTNO) REFERENCES DEPT01(DEPTNO)
ON DELETE CASCADE;
-- ON DELETE CASCAD 이 옵션이 추가되면 어떻게 되느냐?
-- 위의 ON DELETE CASCAD 옵션이 없는 제약조건을 추가해줬을 때는 
-- 부모 테이블에 있는 값을 지우려고 할 때 자식 테이블을 먼저 지우고 그다음에 부모 테이블 값을 
-- 지워줬어야하는데
-- ON DELETE CASCAD 옵션을 추가한 제약조건을 추가해주면
-- 자식 테이블을 먼저 지우지 않고도 그냥 바로 부모 테이블에서 원하는 값을 지우면 지워진다!
-- 설사 자식 테이블이 있더라도 자식 테이블에 영향 주지 않으면서
-- 부모 테이블을 DROP 할수도 부모 테이블에서 원하는 값을 DELETE할 수도 있는 것이다!! 

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME, R_CONSTRAINT_NAME, STATUS
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN ('DEPT01', 'EMP01');
-- 우리가 만든 DEPT01와 EMP01 테이블에 있는 제약조건 확인하는 코드

SELECT * FROM DEPT01;
SELECT * FROM EMP01; 
-- 부모 DEPT01 테이블의 DEPTNO 을 참조하게된 DEPTNO 칼럼이 추가되었다..?

INSERT INTO EMP01 (DEPTNO) VALUES (10);
-- DEPT01 테이블의 DEPTNO에 10 값이 있기 때문에 EMP01의 DEPTNO 칼럼에 값 10이 추가된다.

--DEPT 테이블에서 DEPTNO이 10인 ROW를 지워보자
DELETE FROM DEPT01
WHERE DEPTNO=10;
-- ORA-02292: integrity constraint (SCOTT.EMP01_DEPTNO_FK) violated - child record found 오류 발생
-- FOREIGN KEY 에 의해 자식 EMP01 테이블이 DEPT01테이블의 DEPTNO=10인 값을 사용하고 있기 때문에
-- 함부로 지울 수 없어서 위와같은 오류 발생한다. DEPT01 테이블에서 DEPTNO=10을 지우고 싶다면 자식을 먼저 지워야한다.

DELETE FROM EMP01; -- EMP01 테이블을 지우고 위의 코드 DELTE FROM DEPT01 WHERE DEPTNO=10 코드를 실행하면 아주 잘된다.
SELECT * FROM DEPT01; -- 지우고 DEPT01 테이블을 보게 되면 DEPTNO=10인 ROW가 사라진것을 확인할 수 있다.





--------------------------------------------------------------------------------------------------------------------
-- 14. 가상 테이블 뷰

SELECT * FROM EMP;
-- 2개의 칼럼을 가져와서 보이는 것
SELECT EMPNO, ENAME FROM EMP;

-- 특정 ROW의 데이터만 가져오는 것
SELECT * FROM EMP
WHERE DEPTNO = 10;



-- 14-1-1. 뷰의 기본 테이블 생성하기
DROP TABLE DEPT_COPY;

CREATE TABLE DEPT_COPY
AS
SELECT * FROM DEPT;

SELECT * FROM DEPT_COPY; -- 뷰의 기본 테이블 1 

DROP TABLE EMP_COPY;

CREATE TABLE EMP_COPY
AS
SELECT * FROM EMP;

SELECT * FROM EMP_COPY; -- 뷰의 기본 테이블 2


-- 뷰 정의하기
-- 뷰는 마치 테이블과 같이 사용한다.
-- 칼럼이 많아지고 복잡해지면 SELECT 다음으로 나오는 서브쿼리들을
-- 뷰로 만들어서 간편하게 테이블처럼 사용할 수 있다.
DROP VIEW EMP_VIEW30;

CREATE VIEW EMP_VIEW30
AS
SELECT EMPNO, ENAME, SAL, DEPTNO FROM EMP_COPY
WHERE DEPTNO=30;
-- EMP_COPY 테이블에서 EMPNO, ENAM, SAL, DEPTNO 칼럼을 가져오는데
-- DEPTNO=30인 데이터만 가져와서 뷰를 만드는 것

SELECT * FROM EMP_VIEW30;




-- 14-2-2. 단순 뷰와 복합 뷰
-- 각 부서마다 봐야하는 칼럼들이 다르다.
-- 그래서 데이터를 제한시켜서 특정 칼럼의 데이터만 가져와서 뷰로 만들어
-- 필요한 사람이 볼 수 있도록 하는 것,,

-- 여러개의 테이블을 조인해서 만드는 뷰 : 복합 뷰
-- 하나의 테이블을 가지고 만드는 뷰 : 단순 뷰

-- 단순 뷰의 칼럼에 별칭 부여하기
DESC EMP_VIEW30;

CREATE OR REPLACE
VIEW EMP_VIEW (사원번호, 사원명, 부서번호)  -- 칼럼의 별칭을 각각 사원번호, 사원명, 부서번호로 지정해줬다.
AS
SELECT EMPNO, ENAME, DEPTNO
FROM EMP_COPY;

SELECT * FROM EMP_VIEW;


-- 복합 뷰 만들기
DROP VIEW EMP_VIEW_DEPT;

CREATE VIEW EMP_VIEW_DEPT
AS
SELECT E.EMPNO, E.ENAME, E.SAL, E.DEPTNO, D.DNAME, D.LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
ORDER BY EMPNO DESC;

-- 다음의 코드는 서브쿼리
SELECT E.EMPNO, E.ENAME, E.SAL, E.DEPTNO, D.DNAME, D.LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
ORDER BY EMPNO DESC;

SELECT * FROM EMP_VIEW_DEPT;
-- EMP와 DEPT 테이블을 조인하여 특정한 칼럼만 가져와서 뷰를 만든 것
-- 복잡한 쿼리문장을 뷰로 만들어서 필요한 데이터만 골라서 가져오는,, 뷰의 장점,,?


-- 뷰 삭제하기
SELECT VIEW_NAME, TEXT
FROM USER_VIEWS;
-- 뷰 이름 모를 때 위와 같은 코드를 사용하여 뷰의 이름 알아내기

DROP VIEW EMP_VIEW;
-- DROP 하고 다시 SELECT 해보면 사라진걸 확인할 수 있다.



-- 14.3 뷰 생성에 사용되는 다양한 옵션
-- 14-3-1. 뷰 수정 : OR REPLACE 옵션
-- 뷰를 수정하려면 기존에 있던 뷰를 DROP 해서 지운 후
-- 수정한 뷰를 다시 새로 만들어줘야 한다. --> 너무 번거로움,,
-- OR REPLACE VIEW를 사용하면 기존에 있는 뷰면 내용을 변경해주고
-- 없는 뷰이면 새로 만들어주는 역할을 한다.
CREATE OR REPLACE VIEW EMP_VIEW_DEPT
AS
SELECT EMPNO, ENAME, D.DNAME, D.LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
ORDER BY EMPNO DESC;


-- 14.3.2 기본 테이블 없이 뷰를 생성 : FORCE 옵션

DESC EMPLOYEES;

CREATE OR REPLACE FORCE VIEW EMPLOYEES_VIEW
AS
SELECT EMPNO, ENAME, DEPTNO
FROM EMPLOYEES
WHERE DEPTNO=30;
-- EMPLOYEES 라는 기본테이블이 없는 상태에서 EMPLOYEES_VIEW 뷰를 만들려고 함 --> 원래는 뷰 생성안됨
-- 하지만 FORCE 키워드를 적어서 옵션을 해주면 경고와 함께 뷰가 생성된다,,

SELECT VIEW_NAME, TEXT
FROM USER_VIEWS;
--  EMPLOYEES_VIEW 뷰가 생성된것을 볼 수 있다.



-- 14-3-3. WITH CHECK OPTION
-- 뷰 생성할 때 조건 제시에 사용된 컬럼 값을 변경 못하도록 하는 기능

CREATE OR REPLACE VIEW VIEW_CHK30
AS
SELECT EMPNO, ENAME, SAL, COMM, DEPTNO
FROM EMP_COPY
WHERE DEPTNO=30 WITH CHECK OPTION;

SELECT * FROM VIEW_CHK30;
-- EMP_COPY 테이블에서 DEPTNO=30인 EMPNO, ENAME, SAL, COMM, DEPTNO 칼럼들을 가져와서 VIEW_CHK30 뷰를 생성한다.

SELECT * FROM VIEW_CHK30
WHERE DEPTNO=20;
-- VIEW_CHK30 뷰는 DEPTNO=30인 애들밖에 없어서 DEPTNO=20인 데이터를 찾으려고 하면 아무것도 안나온다.

UPDATE VIEW_CHK30
SET DEPTNO=20
WHERE SAL>=1200;
-- 데이터를 업데이트 하는데 SAL 값이 1200일때 DEPTNO 값을 20으로 바꾸라는 것. 
-- 그런데 위에서 VIEW_CHK30을 만들때 WITH CHECK OPTION 옵션을 적어줘서
-- DEPTNO=30을 DEPTNO=20으로 변경하는 것을 바꾸지 못하게 막혀있기 때문에 실행이 안된다.




-- WITH CHECK OPTION 옵션 사용 안하는 경우
CREATE OR REPLACE VIEW VIEW_CHK30
AS
SELECT EMPNO, ENAME, SAL, COMM, DEPTNO
FROM EMP_COPY
WHERE DEPTNO=30;

SELECT * FROM VIEW_CHK30;

SELECT * FROM VIEW_CHK30
WHERE DEPTNO=20;

UPDATE VIEW_CHK30
SET DEPTNO=20
WHERE SAL>=1200;
-- 업데이트가 된다!



-- WITH READ ONLY 옵션


CREATE OR REPLACE VIEW VIEW_CHK30
AS
SELECT EMPNO, ENAME, SAL, COMM, DEPTNO
FROM EMP_COPY
WHERE DEPTNO=30;

UPDATE VIEW_CHK30
SET DEPTNO=20;

SELECT * FROM VIEW_CHK30;

SELECT * FROM EMP_COPY;
-- VIEW_CHK30 뷰를 바꾼건데 EMP_COPY테이블의 데이터 값도 같이 수정이 되었다.
-- EMP_COPY에서 DEPTNO=30이 다 DEPTNO=20으로 바뀌었다.
-- 우리는 이걸 원치 않는다!! 뷰를 통해서 테이블이 변경되지 않도록 하고 싶다!!

CREATE OR REPLACE VIEW VIEW_READ30
AS
SELECT EMPNO, ENAME, SAL, COMM, DEPTNO
FROM EMP_COPY
WHERE DEPTNO=30 WITH READ ONLY;

SELECT * FROM VIEW_READ30;

UPDATE VIEW_READ30
SET DEPTNO=20;
-- cannot perform a DML operation on a read-only view 오류 발생


SELECT EMPNO, ENAME, SAL, COMM, DEPTNO
FROM EMP_COPY
WHERE DEPTNO=30;
-- 아무것도 안나온다.
-- 위에서 DEPTNO=30이 다 DEPTNO=20으로 바뀌었기 때문에 아무것도 안나온다.



-- 14-4-1. ROWNUM 컬럼의 성격 파악하기
-- 해당 테이블에 데이터가 입력된 순서를 나타낸다.
SELECT ROWNUM, EMPNO, ENAME, HIREDATE
FROM EMP;

-- ENAME으로 정렬을 해보면 ROWNUM 값이 순서대로 안나온다.
SELECT ROWNUM, EMPNO, ENAME, HIREDATE
FROM EMP
ORDER BY ENAME ASC;
-- SMITH 는 ROWNUM 1번이다.



--14-4-2. 인라인 뷰로 구하는 TOP-N 의 개념

-- 급여(SAL)를 많이 받는 6~10째 사원을 출력하기
SELECT * FROM EMP ORDER BY SAL DESC;
-- 얘를 서브 쿼리로 사용해서 출력한다!
-- KING 이 1번이다.


SELECT ROWNUM, ENAME, SAL
FROM (SELECT * FROM EMP ORDER BY SAL DESC);
-- SMITH는 ROWNUM 5번이다.
-- (SELECT * FROM EMP ORDER BY SAL DESC)로부터 새로운 가상의 테이블을 만든 것이다.

SELECT RNUM, ENAME, SAL
FROM (SELECT ROWNUM RNUM, ENAME, SAL
FROM (SELECT * FROM EMP ORDER BY SAL DESC))
WHERE RNUM BETWEEN 6 AND 10;
-- RNUM이 일종의 칼럼이 되는 것이다


(SELECT ROWNUM RNUM, ENAME, SAL
FROM (SELECT * FROM EMP ORDER BY SAL DESC));



-- 사원 테이블(EMP)에서 가장 최근에 입사한 사원들중에 3~5번째의 사번과 사원명을 출력하는 SQL문을 작성하세요
SELECT EMPNO, ENAME
FROM (SELECT ROWNUM RNUM, EMPNO, ENAME
FROM (SELECT * FROM EMP ORDER BY HIREDATE ASC))
WHERE RNUM BETWEEN 3 AND 5;


SELECT ROWNUM, EMPNO, ENAME
FROM (SELECT * FROM EMP ORDER BY HIREDATE ASC);

SELECT * FROM EMP ORDER BY HIREDATE ASC;

SELECT EMPNO, ENAME
FROM (SELECT ROWNUM RNUM, ENAME, SAL
FROM (SELECT * FROM EMP ORDER BY HIREDATE ASC))
WHERE RNUM BETWEEN 3 AND 5;


