-- ���� �ð� ����
-- ORACLE OUTER JOIN
SELECT E.ENAME, M.ENAME
FROM EMP E, EMP M
WHERE E.MGR = M.EMPNO;
--> ENAME���� KING�� ������ ����

SELECT E.ENAME, M.ENAME
FROM EMP E, EMP M
WHERE E.MGR = M.EMPNO(+); -- LEFT OUTER JOIN �� ���� ���
--> ENAME �� KING�� �����ؼ� ��µ�

SELECT E.ENAME, M.ENAME
FROM EMP E, EMP M
WHERE E.MGR(+) = M.EMPNO; -- RIGHT OUTER JOIN�� ���� ���


-- ANSI OUTER JOIN

-- (1) ANSI LEFT OUTER JOIN
-- ���ι��� ���ʿ� �ִ� ���̺��� ��� ����� ������ ��
-- ������ ���̺��� �����͸� ��Ī�ϰ�, ��Ī�Ǵ� �����Ͱ� ���� ��� NULL�� ǥ���Ѵ�.
SELECT E.ENAME, M.ENAME
FROM EMP E LEFT OUTER JOIN EMP M
ON E.MGR = M.EMPNO;



-- 08. �������� : �������� �� ���� ���������� �ٲ㼭 ���� �� �ִ�.
SELECT DNAME
FROM DEPT
WHERE DEPTNO = (SELECT DEPTNO
                           FROM EMP
                           WHERE ENAME='SCOTT');

-- ���� �ڵ带 JOIN �������� �� ���
SELECT DNAME
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO
AND EMP.ENAME='SCOTT';



-- 08-02. ������ ���� ���� : �񱳿����� ��� ����
SELECT ENAME, SAL
FROM EMP
WHERE SAL > ( SELECT AVG(SAL) FROM EMP);

SELECT AVG(SAL) FROM EMP;



-- 08-03. ������ ���� ���� : �񱳿����� ��� �Ұ�

--03-01. IN ������ : ���� ������ ��� �� �ϳ��� ��ġ�ϸ� ���� ������ WHERE ���� ���� �ȴ�.
SELECT ENAME, SAL, DEPTNO
FROM EMP
WHERE DEPTNO IN ( SELECT DISTINCT DEPTNO
    FROM EMP
    WHERE SAL >= 3000);
-- DEPTNO =10 �϶��� DEPTNO=20�϶� �� ��� �ش��ϴ� �� �� ���

SELECT DISTINCT DEPTNO
    FROM EMP
    WHERE SAL >= 3000;
-- DEPTNO = 10, 20 �ΰ� ���



-- 03-02. ALL ������ : ���� ������ �� ������ ���� ������ �˻� ����� ��� ���� ��ġ�ϸ� ��
SELECT ENAME, SAL
FROM EMP
WHERE SAL > ALL ( SELECT SAL
    FROM EMP
    WHERE DEPTNO = 30);
-- ���� ������ ��� ����� ������ �� �����ؼ� �� ���͵� ���� ū SAL�� ã�°� WHERE��
-- ���� ���� �˻��� ��� ���� ū ���� 2850�̴�. �׷��ϱ� WHERE���� 2850���� ū SAL�� ������ �ȴ�.

SELECT SAL
    FROM EMP
    WHERE DEPTNO = 30;
-- 6���� SAL �� ��� ( ���� ���� ū SAL ���� 2850, ���� ���� SAL ���� 950 �̴�.)



-- 03-03. ANY ������ : ���� ������ �˻� ����� �ϳ��� �̶� ��ġ�ϸ� ���� ������ WHERE���� ��
SELECT ENAME, SAL
FROM EMP
WHERE SAL > ANY ( SELECT SAL
    FROM EMP
    WHERE DEPTNO = 30);
-- ���� ������ ��� �� ���� ���� SAL���� 950 ���ٸ� ���� ������ SAL ���� ũ�� �ϳ� �̻� ��
-- �����ϰ� �Ǹ� WHERE ���� ���� �ȴ�.



-- 03-04. EXISTS ������ : ���� ������ ������� �ϳ����̶� �����Ѵٸ�
--                               ���� ������ ���ǽ��� ��� TRUE, �������� ������ ���ǽ��� FALSE

SELECT *
FROM EMP
WHERE 1=1;
-- 1=1 �� ������ ���̴�. -> WHERE ������ ���̴� ��� �÷� �� ��µ�

SELECT *
FROM EMP
WHERE EXISTS ( SELECT DNAME
    FROM DEPT
    WHERE DEPTNO=10 );
-- SELECT DNAME FROM DEPT WHERE DEPTNO=10 �� ���� ACCOUNTING ���� �ϳ� �����Ѵ�.
-- ���� ���� ������ ��� ���� ACCOUNTING ���� �ϳ� �����ϹǷ� ���� ������ ��� �ȴ�.


SELECT DNAME
    FROM DEPT
    WHERE DEPTNO=60;

SELECT *
FROM EMP
WHERE EXISTS ( SELECT DNAME
    FROM DEPT
    WHERE DEPTNO=60 );
-- SELECT DNAME FROM DEPT WHERE DEPTNO=60 �� ���� �ϳ��� �������� �ʴ´�.
-- ���� ���� ������ ������� �ϳ��� �������� �ʾ� WHERE�� ���ǽ��� FALSE�� �Ǿ�
-- ���� ������ �ƹ��͵� ����� �ȵȴ�. 


-- 8�� 08-02-02�� ���� ����
-- IN�����ڸ� �̿��Ͽ� �μ����� ���� ���� �޿��� �޴� ����� ����
-- (�����ȣ,�����,�޿�,�μ���ȣ)�� ����ϴ� SQL���� �ۼ� �ϼ���.

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
-- DEPTNO �� SAL �� ���� ������� �ϴ� ����!
-- SMITH�� DEPTNO = 20�ε� DEPTNO=30�� MAX(SAL) = 2850�� SAL���� ������ �ִ�.
-- �׷��� DEPTNO �� ���� �� �����ָ� DETPNO=20������ MAX(SAL)=3000�ε�
-- SMITH�� 2850�̶� ��µǸ� �ȵǴµ� SAL�� ���ϸ� ����̵ȴ�..!
-- �׷��� DEPTNO�� SAL�� ���� ������� �� DEPTNO������ MAX(SAL)���� ������
-- �� DEPTNO���� ���� �޴� ����鸸 ����̵ȴ�!!


SELECT EMPNO, ENAME, SAL, DEPTNO
FROM EMP
WHERE SAL IN (SELECT MAX(SAL)
FROM EMP
GROUP BY DEPTNO
);



-- 09. DDL : CREATE, ALTER, RENAME, TRUNCATE, DROP
--      --> �����ͺ��̽� ���� �ÿ� ��� ���,, �� �Ŀ��� �� ��� ����
-- DML : INSERT, UPDATE, DELETE, SELECT

-- 01. CREATE TABLE
CREATE TABLE EX2_1 (
    COLUMN1 CHAR(10),
    COLUMN2 VARCHAR2(10),
    COLUMN3 VARCHAR2(10),
    COLUMN4 NUMBER
);

DESC EX2_1;

-- CREATE TABLE [�ǽ� 1 : ���ο� ���̺� �����ϱ�]
SELECT * FROM EMP01;

CREATE TABLE EMP01 (
    EMPNO NUMBER(4),
    ENAME VARCHAR2(20),
    SAL NUMBER(7, 2)
);

DESC EMP01;
SELECT * FROM EMP01;


-- CREATE TABLE [�ǽ� 2 : ���� ������ ���̺� �����ϱ�, �÷��� ���� ���� �����ְ� �̹� �ִ� ���̺��� ������ �ͼ� �״�� ���ο� ���̺� ����� ��(�̶�, ���鵵 �� �Ȱ��� �������� �ȴ�.) , �� ������ ���̶�� �����ϸ� �ȴ�..! ]
CREATE TABLE EMP02
AS
SELECT * FROM EMP;
-- EMP ���̺��� ������ �ͼ� EMP02 ���̺��� ������

DESC EMP02;


-- CREATE TABLE [ �ǽ� 3 : Ư���� �÷����� ������ ���� ���̺� �����ϱ�]
CREATE TABLE EMP03
AS
SELECT EMPNO, ENAME FROM EMP;

SELECT * FROM EMP03;


-- CREATE TABLE [ �ǽ� 4 : ���ϴ� ��(ROW)���� ������ ���� ���̺� �����ϱ�]
CREATE TABLE EMP05
AS
SELECT * FROM EMP
WHERE DEPTNO=10;

SELECT * FROM EMP05;



-- ���̺��� ������ �����ϱ� ( ������ ���� ���� Ʋ�� �ִ� �� )
CREATE TABLE EMP06
AS
SELECT * FROM EMP
WHERE 1=0;

SELECT * FROM EMP06;
DESC EMP06;



-- 9-2. ���̺� ���� �����ϴ� ALTER TABLE

-- ���ο� ���̺� �߰� [ �ǽ� : EMP01 ���̺� JOB �÷� �߰��ϱ� ]
DESC EMP01;
-- EMPNO, ENAME, SAL �÷� ������ �ִ�.
ALTER TABLE EMP01
ADD (JOB VARCHAR2(9));
-- JOB �÷� �߰���
-- �ٽ� EMP01 DESC �غ��� JOB �÷��� �߰��� ���� �� �� �ִ�.


-- ���� ���̺� �Ӽ� ����
ALTER TABLE EMP01
MODIFY (JOB VARCHAR2(30));
-- JOB �÷��� ���� 9���� 30���� �ø���
DESC EMP01;



-- ���� �÷� ����
ALTER TABLE EMP01
DROP COLUMN JOB;

DESC EMP01;




-- SET UNUSED
SELECT * FROM EMP02;

ALTER TABLE EMP02
SET UNUSED(JOB);
-- JOB �÷� �� �ɾ �Ⱥ��̰� ��



-- DROP TABLE : ���̺� ����
DROP TABLE EMP01;
SELECT * FROM EMP01;

DROP TABLE EMP02;
SELECT * FROM EMP02;


-- TRUNCATE : ��� �ο� ����
SELECT * FROM EMP03;
DELETE FROM EMP03;  -- DML : DELETE, INSERT, UPDATE , SELECT  --> DML �� �ȯ�濡�� �Ժη�,, �ϸ� �ȵȴ�.
ROLLBACK;
TRUNCATE TABLE EMP03; -- DDL : TRUNCATE = DELETE + COMMIT, CREATE, ALTER, RENAME, DROP
-- DELETE �� �޸𸮿� �ִ� ���� ����� ��! ��ũ�� �ִ� �� �޸𸮿� ������ �� ����� ��
-- �׷��� DELETE �ϰ� ROLLBACK  �ص� ��ũ���� �ٽ� �����͸� �����ͼ� ������ ������ �ȴ�..
-- COMMIT �� �޸𸮿� �ִ� ���� ����� ��ũ�� �ݿ��� �ϴ°�
-- ���� TRUNCATE�� COMMIT�� ���Ե� �� �ǹ��ϴµ� ��ũ���� ������ ������ �޸𸮿� ������
-- �޸𸮿� �ִ� �����͸� ����� �� �޸𸮿��� ������� ��ũ�� �ݿ��� ���Ѽ� ��ũ������ �������� �ȴ�.
-- �׷��� TRUNCATE �� ROLLBACK �� �ص� ������ �����Ͱ� �ٽ� ���ƿ��� ���Ѵ�,,,

-- ��ũ���� �����͸� �޸𸮿� �����´�.
-- DELETE �� �� �޸𸮿� �ִ� �����͸� ����� ��!
-- �׷��� DELTE�� ROLLBACK�� �ϸ� ��ũ���� �ٽ� �����͸� �������� �Ǿ ������ ������ �����ϴ�.
-- ������ TRUNCATE �� DELTE �� COMMIT ���� ������ �����̶� ROLLBACK�ص� ������ ������ �ȵȴ�.



-- RENAME TABLE : ���̺�� ����
RENAME EMP03 TO TEST;
SELECT * FROM EMP03;
SELECT * FROM TEST;
-- �̸��� TEST �� �ٲٸ� EMP03�� ã������ �ص� ��ã������,,



-- USER_ ������ ��ųʸ�
SHOW USER;  -- 'SCOTT' 

DESC USER_TABLES;

SELECT TABLE_NAME FROM USER_TABLES
ORDER BY TABLE_NAME ASC;
--�� USER �� SCOTT�� ���� ���̺��� �̸����� ������������ �����ؼ� ��µȴ�.
-- USER_ �� �����ϴ� ���̺��� ���� ���̺��� �̸��� ���,,?


-- ALL_ ������ ��ųʸ� 
-- ����Ŭ�� ����� ������� ���̺��� �����. 
-- ������ ���� ������ �� �ȿ� ���̺���� �ڵ����� ���������.
-- ���̺��� ��ü��� �����ϸ� �Ǵµ�,,
-- ��Ű�� (SCHEMA) = USER(�� ��ü��) = ������

SELECT * FROM DEPT;
SELECT * FROM SYSTEM.HELP; -- �ٸ� ���������� �� �� �ֵ��� ������ �ذ�,, (SCOTT �������� SYSTEM ������ ���� ����)
-- ������ �ٸ� ������ �ִ� �͵��� ������ ���� ����? �� �־�� �Ѵ�.
-- ������ ALL_ ������  ��ųʸ��� Ÿ ���������� ������ �� �ִ� �����͵��� ������ִ� ���̴�.


-- ALL_ ������ ��ųʸ� : ���� �ִ� �������� ���� ���� �ٸ� ������ �ٸ� ��ü��(��ü �� �ϳ��� ���̺�,,)�� ����� �� �ֵ��� ������ �������ִ� �͵��� ������ �ִ� ��,,
DESC ALL_TABLES;
SELECT OWNER, TABLE_NAME FROM ALL_TABLES; -- SCOTT���� ������ ������ ���̺��̸��� �� ���̺��� �ִ� �����̸�



-- SYS (SUPER),
-- SYSTEM (DBA),
-- SCOTT (USER)


SHOW USER;
SELECT TABLE_NAME, OWNER FROM DBA_TABLES;
-- SCOTT ���������� DBA_ ������ ��ųʸ��� ���� �Ұ�
--> �Ƹ���,, SCOTT ������ DBA_ ������ ��ųʸ��� ������ �� �ִ� ���� ������ ���� ����,,?
--> SYSTEM ���������� DBA_TABLES �� ���� �����ؼ� ��µȴ�.




-- 10. DML ( Data Manipulation Language, ������ ���۾�) : INSERT, UPDATE, DELETE, SELECT
--     ������ ������ CRUD(CREATE / READ / UPDATE / DATE) ��� �� �� �ִ�.
--     CRUD = DB �������� ????


-- 1. INSERT��
DESC DEPT01;

ALTER TABLE DEPT01
ADD(LOC VARCHAR2(10)); 

INSERT INTO DEPT01 VALUES(10, 'ACCOUNTING', 'NEW YORK');
SELECT * FROM DEPT01;

INSERT INTO DEPT01 VALUES(30, 'DEVELOPMENT', 'NULL');

-- INSERT INTO DEPT01 VALUES(30, 'DEVELOPMENT');
-- �̷��� �÷��� ���� ������ �ʰ� INSERT �Ϸ��� �ϸ� �ȵ���.

INSERT INTO DEPT01 (DEPTNO, DNAME) VALUES (40, 'SALES');
-- Ư�� �÷����� ���� INSERT �ϰ� �ʹٸ� ������ ���� �������� INSERT ����� �Ѵ�.





