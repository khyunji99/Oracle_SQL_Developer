
-- 3. �������� Ȯ���ϱ�
SELECT * FROM DEPT;

INSERT INTO DEPT VALUES(10, 'TEST', 'SEOUL'); -- unique constraint (SCOTT.PK_DEPT) violated �����߻�
-- DEPTNO �� PRIMARY KEY ���������� �����ؼ� ������ �߻��Ѱ�
-- PRIMARY KEY ���������̶� NULL ��� X + �ߺ��� �� ��� X

DESC DEPT;

DESC USER_CONSTRAINTS;

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME
FROM USER_CONSTRAINTS
WHERE TABLE_NAME='DEPT';


-- NOT NULL ���� ������ �������� �ʰ� ���̺� �����ϱ�
DROP TABLE EMP01;

CREATE TABLE EMP01(
    EMPNO NUMBER(4),
    ENAME VARCHAR2(10),
    JOB VARCHAR2(9),
    DEPTNO NUMBER(2)
);

SELECT * FROM EMP01;

INSERT INTO EMP01 VALUES(NULL, NULL, 'SALESMAN', 30); -- ������ �߰��� �ȴ�.
-- EMPNO�� ENAME�� ���� ������ �־���ϴµ� NOT NULL ���������� ��� NULL���� �׳� ������,,


-- NOT NULL ���������� �����Ͽ� ���̺� �����ϱ�
DROP TABLE EMP02;

CREATE TABLE EMP02(
    EMPNO NUMBER(4) NOT NULL,
    ENAME VARCHAR2(10) NOT NULL,
    JOB VARCHAR2(9),
    DEPTNO NUMBER(2)
);

INSERT INTO EMP02 VALUES(NULL, NULL, 'SALESMAN', 30); -- cannot insert NULL into ("SCOTT"."EMP02"."EMPNO") ���� �߻�
-- NOT NULL ���� ������ �߰������ν� EMPNO�� ENAME �� �츮�� ���ϴ� ��ó�� NULL���� �߰��� �ȵȴ�.

INSERT INTO EMP02 VALUES(1, NULL, 'SALESMAN', 30); -- cannot insert NULL into ("SCOTT"."EMP02"."ENAME") ���� �߻�

INSERT INTO EMP02 VALUES(1, 'ȫ�浿', 'SALESMAN', 30); -- �� ���� �ְ� ������ �߰��ϴϱ� �߰��� �ȴ�.

SELECT * FROM EMP02;





-- UNIQUE ���� ������ �����Ͽ� ���̺� �����ϱ�
DROP TABLE EMP03;

CREATE TABLE EMP03(
    EMPNO NUMBER(4) UNIQUE,
    ENAME VARCHAR2(10) NOT NULL,
    JOB VARCHAR2(9),
    DEPTNO NUMBER(2)
);

INSERT INTO EMP03 VALUES(1499, 'ALLEN', 'SALESMAN', 30);

SELECT * FROM EMP03;

INSERT INTO EMP03 VALUES(1499, 'JONES', 'MANAGER', 20); -- unique constraint (SCOTT.SYS_C007006) violated ���� �߻����� ������ �߰� �ȵ�
-- EMPNO�� UNIQUE ������ ���������Ƿ� �����߻���

INSERT INTO EMP03 VALUES(NULL, 'JONES', 'MANAGER', 20); -- ������ �߰� O
INSERT INTO EMP03 VALUES(NULL, 'JONES2', 'MANAGER', 20); -- ������ �߰� O
INSERT INTO EMP03 VALUES(NULL, 'JONES3', 'MANAGER', 20); -- ������ �߰� O
-- UNIQUE ���ǿ����� NULL�� ������ �߰��� �����ϴ�.
-- NULL�� UNIQUE���� ������ �� �� ���� �����̴�.





--- 4. Į�� ������ ���� ���Ǹ��� ����Ͽ� �������� ����   VS  ���̺� ������ �������Ǹ��� ����Ͽ� �������� ����

DROP TABLE EMP03;

CREATE TABLE EMP03(
    EMPNO NUMBER(4) CONSTRAINT EMP03_EMPNO_UQ UNIQUE, -- Į�� ������ ���
    ENAME VARCHAR2(10) NOT NULL,
    JOB VARCHAR2(9),
    DEPTNO NUMBER(2)
);

INSERT INTO EMP03 VALUES(1499, 'ALLEN', 'SALESMAN', 30);

SELECT * FROM EMP03;

INSERT INTO EMP03 VALUES(1499, 'JONES', 'MANAGER', 20); -- unique constraint (SCOTT.EMP03_EMPNO_UQ) violated
-- ������ ���� ���� �߻� �� ��µ� �� ���� ������ ���������� �̸����� ��µȴ�

INSERT INTO EMP03 VALUES(NULL, 'JONES', 'MANAGER', 20); -- ������ �߰� O
INSERT INTO EMP03 VALUES(NULL, 'JONES2', 'MANAGER', 20); -- ������ �߰� O
INSERT INTO EMP03 VALUES(NULL, 'JONES3', 'MANAGER', 20); -- ������ �߰� O


SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME
FROM USER_CONSTRAINTS
WHERE TABLE_NAME='EMP03';


-- PRIMARY KEY(�⺻Ű) �������� �����ϱ�
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
-- �������� EMPNO_PK �� ����Ǿ� ������ �߰��� �ȵȴ�.
INSERT INTO EMP05 VALUES(NULL, 'JONES', 'MANAGER', 20);
-- SQL Error: ORA-01400: cannot insert NULL into ("SCOTT"."EMP05"."EMPNO")



--  EMP, DEPT ���̺��� �������� Ȯ�� (FOREIGN KEY ���� ����)

-- EMP, DEPT ���̺��� �������� Ȯ��
SELECT TABLE_NAME, CONSTRAINT_TYPE, 
CONSTRAINT_NAME, R_CONSTRAINT_NAME
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN ('DEPT', 'EMP');

-- �ַ� Ű(FOREIGN KEY) �������� �����ϱ�
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
-- EMP�� DEPTNO �� DEPT ���̺��� DEPTNO�� �����ϴµ�
-- EMP ���̺� DEPTNO�� ���� DEPT ���̺��� ���� DEPTNO 50�� �߰��Ϸ��� �ؼ�
-- DEPT ���̺��� DEPTNO Į���� 50 ���� �ִ��� �ô��� 50�̶�� ���� ���
-- �����ؾ� �ϴ� ���������� ����Ǿ ������ �� ���̴�.

SELECT * FROM DEPT;

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME, R_CONSTRAINT_NAME
FROM USER_CONSTRAINTS
WHERE TABLE_NAME='EMP06';



-- CHECK ���� ���� �����ϱ�
DROP TABLE EMP07;

CREATE TABLE EMP07(
    EMPNO NUMBER(4) CONSTRAINT EMP07_EMPNO_PK PRIMARY KEY,
    ENAME VARCHAR2(10) CONSTRAINT EMP07_ENAME_NN NOT NULL,
    SAL NUMBER(7, 2) CONSTRAINT EMP07_SAL_CK CHECK(SAL BETWEEN 500 AND 5000), -- SAL �� ���� 500���� 5000���� Ȯ�����ִ� CHECK ��������
    GENDER VARCHAR2(1) CONSTRAINT EMP07_GENDER_CK CHECK(GENDER IN('M', 'F')) -- GENDER �� ���� F �Ǵ� M �� ���Դ��� Ȯ�����ִ� CHECK �������� 
);

INSERT INTO EMP07 VALUES(7499,'ALLEN',500,'M');
INSERT INTO EMP07 VALUES(7499,'ALLEN',7000,'A'); -- ORA-02290: check constraint (SCOTT.EMP07_GENDER_CK) violated

SELECT TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME, SEARCH_CONDITION
FROM USER_CONSTRAINTS
WHERE TABLE_NAME='EMP07';



-- DEFAULT ���� ���� �����ϱ�
DROP TABLE DEPT01;

CREATE TABLE DEPT01(
    DEPTNO NUMBER(2) PRIMARY KEY,
    DNAME VARCHAR2(14),
    LOC VARCHAR2(13) DEFAULT 'SEOUL' -- ������ ���� ���� �����ؼ� ���� �߰������� ������ NULL ���� ����. �׷��� DEFAULT ���������� ���ָ� LOC Į���� ���� ���� �����ؼ� ���� �߰������� ������ SEOUL ���� ����.  
);

INSERT INTO DEPT01(DEPTNO,DNAME) VALUES(10, 'ACCOUNTING');

SELECT * FROM DEPT01;




-- �÷� ������ ���� ������ �����ϴ� ���
DROP TABLE EMP01;

CREATE TABLE EMP01(
    EMPNO NUMBER(4) PRIMARY KEY,
    ENAME VARCHAR2(10) NOT NULL,
    JOB VARCHAR2(9) UNIQUE,
    DEPTNO NUMBER(4) REFERENCES DEPT(DEPTNO)
);

-- ���̺� ������ ���� ������ �����ϴ� ���
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



-- CASCADE �ɼ����� ���� ���� ���������� ��Ȱ��ȭ�ϱ�
--DROP TABLE DEPT01 CASCADE CONSTRAINTS;
DROP TABLE DEPT01;

CREATE TABLE DEPT01
AS
SELECT * FROM DEPT;
-- ���������� ���簡 �ȵȴ�!! �����Ͷ� ���̺� Ʋ�� ���簡 ��,,

DESC DEPT;

SELECT * FROM DEPT01;
DESC DEPT01;
-- DEPT ���̺��� �ִ� NOT NULL ���������� ����. ���� ���� ���������� �߰��������

ALTER TABLE DEPT01
ADD CONSTRAINT DEPT01_DEPTNO_PK PRIMARY KEY (DEPTNO); --  <-- ���̺� ���� ������� �������� �������ִ� ��


DROP TABLE EMP01;

CREATE TABLE EMP01
AS
SELECT * FROM EMP WHERE 1=0;
-- ���̺� Ʋ�� ����

SELECT * FROM EMP01;
DESC EMP01;
-- �������� ����, Ʋ�� �����߱� ����

ALTER TABLE EMP01
ADD CONSTRAINT EMP01_DEPTNO_FK FOREIGN KEY (DEPTNO) REFERENCES DEPT01(DEPTNO);
-- �������� EMP01 ���̺� �߰����� 
--ON DELETE CASCADE;

ALTER TABLE EMP01
ADD CONSTRAINT EMP01_DEPTNO_FK FOREIGN KEY (DEPTNO) REFERENCES DEPT01(DEPTNO)
ON DELETE CASCADE;
-- ON DELETE CASCAD �� �ɼ��� �߰��Ǹ� ��� �Ǵ���?
-- ���� ON DELETE CASCAD �ɼ��� ���� ���������� �߰������� ���� 
-- �θ� ���̺� �ִ� ���� ������� �� �� �ڽ� ���̺��� ���� ����� �״����� �θ� ���̺� ���� 
-- ���������ϴµ�
-- ON DELETE CASCAD �ɼ��� �߰��� ���������� �߰����ָ�
-- �ڽ� ���̺��� ���� ������ �ʰ� �׳� �ٷ� �θ� ���̺��� ���ϴ� ���� ����� ��������!
-- ���� �ڽ� ���̺��� �ִ��� �ڽ� ���̺� ���� ���� �����鼭
-- �θ� ���̺��� DROP �Ҽ��� �θ� ���̺��� ���ϴ� ���� DELETE�� ���� �ִ� ���̴�!! 

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME, R_CONSTRAINT_NAME, STATUS
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN ('DEPT01', 'EMP01');
-- �츮�� ���� DEPT01�� EMP01 ���̺� �ִ� �������� Ȯ���ϴ� �ڵ�

SELECT * FROM DEPT01;
SELECT * FROM EMP01; 
-- �θ� DEPT01 ���̺��� DEPTNO �� �����ϰԵ� DEPTNO Į���� �߰��Ǿ���..?

INSERT INTO EMP01 (DEPTNO) VALUES (10);
-- DEPT01 ���̺��� DEPTNO�� 10 ���� �ֱ� ������ EMP01�� DEPTNO Į���� �� 10�� �߰��ȴ�.

--DEPT ���̺��� DEPTNO�� 10�� ROW�� ��������
DELETE FROM DEPT01
WHERE DEPTNO=10;
-- ORA-02292: integrity constraint (SCOTT.EMP01_DEPTNO_FK) violated - child record found ���� �߻�
-- FOREIGN KEY �� ���� �ڽ� EMP01 ���̺��� DEPT01���̺��� DEPTNO=10�� ���� ����ϰ� �ֱ� ������
-- �Ժη� ���� �� ��� ���Ͱ��� ���� �߻��Ѵ�. DEPT01 ���̺��� DEPTNO=10�� ����� �ʹٸ� �ڽ��� ���� �������Ѵ�.

DELETE FROM EMP01; -- EMP01 ���̺��� ����� ���� �ڵ� DELTE FROM DEPT01 WHERE DEPTNO=10 �ڵ带 �����ϸ� ���� �ߵȴ�.
SELECT * FROM DEPT01; -- ����� DEPT01 ���̺��� ���� �Ǹ� DEPTNO=10�� ROW�� ��������� Ȯ���� �� �ִ�.





--------------------------------------------------------------------------------------------------------------------
-- 14. ���� ���̺� ��

SELECT * FROM EMP;
-- 2���� Į���� �����ͼ� ���̴� ��
SELECT EMPNO, ENAME FROM EMP;

-- Ư�� ROW�� �����͸� �������� ��
SELECT * FROM EMP
WHERE DEPTNO = 10;



-- 14-1-1. ���� �⺻ ���̺� �����ϱ�
DROP TABLE DEPT_COPY;

CREATE TABLE DEPT_COPY
AS
SELECT * FROM DEPT;

SELECT * FROM DEPT_COPY; -- ���� �⺻ ���̺� 1 

DROP TABLE EMP_COPY;

CREATE TABLE EMP_COPY
AS
SELECT * FROM EMP;

SELECT * FROM EMP_COPY; -- ���� �⺻ ���̺� 2


-- �� �����ϱ�
-- ��� ��ġ ���̺�� ���� ����Ѵ�.
-- Į���� �������� ���������� SELECT �������� ������ ������������
-- ��� ���� �����ϰ� ���̺�ó�� ����� �� �ִ�.
DROP VIEW EMP_VIEW30;

CREATE VIEW EMP_VIEW30
AS
SELECT EMPNO, ENAME, SAL, DEPTNO FROM EMP_COPY
WHERE DEPTNO=30;
-- EMP_COPY ���̺��� EMPNO, ENAM, SAL, DEPTNO Į���� �������µ�
-- DEPTNO=30�� �����͸� �����ͼ� �並 ����� ��

SELECT * FROM EMP_VIEW30;




-- 14-2-2. �ܼ� ��� ���� ��
-- �� �μ����� �����ϴ� Į������ �ٸ���.
-- �׷��� �����͸� ���ѽ��Ѽ� Ư�� Į���� �����͸� �����ͼ� ��� �����
-- �ʿ��� ����� �� �� �ֵ��� �ϴ� ��,,

-- �������� ���̺��� �����ؼ� ����� �� : ���� ��
-- �ϳ��� ���̺��� ������ ����� �� : �ܼ� ��

-- �ܼ� ���� Į���� ��Ī �ο��ϱ�
DESC EMP_VIEW30;

CREATE OR REPLACE
VIEW EMP_VIEW (�����ȣ, �����, �μ���ȣ)  -- Į���� ��Ī�� ���� �����ȣ, �����, �μ���ȣ�� ���������.
AS
SELECT EMPNO, ENAME, DEPTNO
FROM EMP_COPY;

SELECT * FROM EMP_VIEW;


-- ���� �� �����
DROP VIEW EMP_VIEW_DEPT;

CREATE VIEW EMP_VIEW_DEPT
AS
SELECT E.EMPNO, E.ENAME, E.SAL, E.DEPTNO, D.DNAME, D.LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
ORDER BY EMPNO DESC;

-- ������ �ڵ�� ��������
SELECT E.EMPNO, E.ENAME, E.SAL, E.DEPTNO, D.DNAME, D.LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
ORDER BY EMPNO DESC;

SELECT * FROM EMP_VIEW_DEPT;
-- EMP�� DEPT ���̺��� �����Ͽ� Ư���� Į���� �����ͼ� �並 ���� ��
-- ������ ���������� ��� ���� �ʿ��� �����͸� ��� ��������,, ���� ����,,?


-- �� �����ϱ�
SELECT VIEW_NAME, TEXT
FROM USER_VIEWS;
-- �� �̸� �� �� ���� ���� �ڵ带 ����Ͽ� ���� �̸� �˾Ƴ���

DROP VIEW EMP_VIEW;
-- DROP �ϰ� �ٽ� SELECT �غ��� ������� Ȯ���� �� �ִ�.



-- 14.3 �� ������ ���Ǵ� �پ��� �ɼ�
-- 14-3-1. �� ���� : OR REPLACE �ɼ�
-- �並 �����Ϸ��� ������ �ִ� �並 DROP �ؼ� ���� ��
-- ������ �並 �ٽ� ���� �������� �Ѵ�. --> �ʹ� ���ŷο�,,
-- OR REPLACE VIEW�� ����ϸ� ������ �ִ� ��� ������ �������ְ�
-- ���� ���̸� ���� ������ִ� ������ �Ѵ�.
CREATE OR REPLACE VIEW EMP_VIEW_DEPT
AS
SELECT EMPNO, ENAME, D.DNAME, D.LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
ORDER BY EMPNO DESC;


-- 14.3.2 �⺻ ���̺� ���� �並 ���� : FORCE �ɼ�

DESC EMPLOYEES;

CREATE OR REPLACE FORCE VIEW EMPLOYEES_VIEW
AS
SELECT EMPNO, ENAME, DEPTNO
FROM EMPLOYEES
WHERE DEPTNO=30;
-- EMPLOYEES ��� �⺻���̺��� ���� ���¿��� EMPLOYEES_VIEW �並 ������� �� --> ������ �� �����ȵ�
-- ������ FORCE Ű���带 ��� �ɼ��� ���ָ� ���� �Բ� �䰡 �����ȴ�,,

SELECT VIEW_NAME, TEXT
FROM USER_VIEWS;
--  EMPLOYEES_VIEW �䰡 �����Ȱ��� �� �� �ִ�.



-- 14-3-3. WITH CHECK OPTION
-- �� ������ �� ���� ���ÿ� ���� �÷� ���� ���� ���ϵ��� �ϴ� ���

CREATE OR REPLACE VIEW VIEW_CHK30
AS
SELECT EMPNO, ENAME, SAL, COMM, DEPTNO
FROM EMP_COPY
WHERE DEPTNO=30 WITH CHECK OPTION;

SELECT * FROM VIEW_CHK30;
-- EMP_COPY ���̺��� DEPTNO=30�� EMPNO, ENAME, SAL, COMM, DEPTNO Į������ �����ͼ� VIEW_CHK30 �並 �����Ѵ�.

SELECT * FROM VIEW_CHK30
WHERE DEPTNO=20;
-- VIEW_CHK30 ��� DEPTNO=30�� �ֵ�ۿ� ��� DEPTNO=20�� �����͸� ã������ �ϸ� �ƹ��͵� �ȳ��´�.

UPDATE VIEW_CHK30
SET DEPTNO=20
WHERE SAL>=1200;
-- �����͸� ������Ʈ �ϴµ� SAL ���� 1200�϶� DEPTNO ���� 20���� �ٲٶ�� ��. 
-- �׷��� ������ VIEW_CHK30�� ���鶧 WITH CHECK OPTION �ɼ��� �����༭
-- DEPTNO=30�� DEPTNO=20���� �����ϴ� ���� �ٲ��� ���ϰ� �����ֱ� ������ ������ �ȵȴ�.




-- WITH CHECK OPTION �ɼ� ��� ���ϴ� ���
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
-- ������Ʈ�� �ȴ�!



-- WITH READ ONLY �ɼ�


CREATE OR REPLACE VIEW VIEW_CHK30
AS
SELECT EMPNO, ENAME, SAL, COMM, DEPTNO
FROM EMP_COPY
WHERE DEPTNO=30;

UPDATE VIEW_CHK30
SET DEPTNO=20;

SELECT * FROM VIEW_CHK30;

SELECT * FROM EMP_COPY;
-- VIEW_CHK30 �並 �ٲ۰ǵ� EMP_COPY���̺��� ������ ���� ���� ������ �Ǿ���.
-- EMP_COPY���� DEPTNO=30�� �� DEPTNO=20���� �ٲ����.
-- �츮�� �̰� ��ġ �ʴ´�!! �並 ���ؼ� ���̺��� ������� �ʵ��� �ϰ� �ʹ�!!

CREATE OR REPLACE VIEW VIEW_READ30
AS
SELECT EMPNO, ENAME, SAL, COMM, DEPTNO
FROM EMP_COPY
WHERE DEPTNO=30 WITH READ ONLY;

SELECT * FROM VIEW_READ30;

UPDATE VIEW_READ30
SET DEPTNO=20;
-- cannot perform a DML operation on a read-only view ���� �߻�


SELECT EMPNO, ENAME, SAL, COMM, DEPTNO
FROM EMP_COPY
WHERE DEPTNO=30;
-- �ƹ��͵� �ȳ��´�.
-- ������ DEPTNO=30�� �� DEPTNO=20���� �ٲ���� ������ �ƹ��͵� �ȳ��´�.



-- 14-4-1. ROWNUM �÷��� ���� �ľ��ϱ�
-- �ش� ���̺� �����Ͱ� �Էµ� ������ ��Ÿ����.
SELECT ROWNUM, EMPNO, ENAME, HIREDATE
FROM EMP;

-- ENAME���� ������ �غ��� ROWNUM ���� ������� �ȳ��´�.
SELECT ROWNUM, EMPNO, ENAME, HIREDATE
FROM EMP
ORDER BY ENAME ASC;
-- SMITH �� ROWNUM 1���̴�.



--14-4-2. �ζ��� ��� ���ϴ� TOP-N �� ����

-- �޿�(SAL)�� ���� �޴� 6~10° ����� ����ϱ�
SELECT * FROM EMP ORDER BY SAL DESC;
-- �긦 ���� ������ ����ؼ� ����Ѵ�!
-- KING �� 1���̴�.


SELECT ROWNUM, ENAME, SAL
FROM (SELECT * FROM EMP ORDER BY SAL DESC);
-- SMITH�� ROWNUM 5���̴�.
-- (SELECT * FROM EMP ORDER BY SAL DESC)�κ��� ���ο� ������ ���̺��� ���� ���̴�.

SELECT RNUM, ENAME, SAL
FROM (SELECT ROWNUM RNUM, ENAME, SAL
FROM (SELECT * FROM EMP ORDER BY SAL DESC))
WHERE RNUM BETWEEN 6 AND 10;
-- RNUM�� ������ Į���� �Ǵ� ���̴�


(SELECT ROWNUM RNUM, ENAME, SAL
FROM (SELECT * FROM EMP ORDER BY SAL DESC));



-- ��� ���̺�(EMP)���� ���� �ֱٿ� �Ի��� ������߿� 3~5��°�� ����� ������� ����ϴ� SQL���� �ۼ��ϼ���
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


