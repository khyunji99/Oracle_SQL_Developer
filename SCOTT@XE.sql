SELECT * FROM EMP;
SELECT * FROM DEPT;
SELECT DEPTNO, DNAME FROM DEPT;
SELECT * FROM DEPT;
INSERT INTO DEPT VALUES(50, '�ѹ���', '����');
UPDATE DEPT SET LOC='�λ�' WHERE DNAME='�ѹ���';
DELETE FROM DEPT WHERE DEPTNO=50;

-- DDL(Data Definition Language)
-- DROP
DROP TABLE DEPT01;
DROP TABLE DEPTO1;

-- Create
CREATE TABLE DEPT01(
  DEPTNO NUMBER(4),   -- ���� 4�ڸ�
  DNAME VARCHAR2(10), -- ���ڿ� 10�ڸ�
  LOC VARCHAR2(9)     -- ���ڿ� 9�ڸ�
);

DESC DEPT01;
-- DEPT01 �� ǥ�����ִ� ���� (DESCRIBE ���� : DESC)
-- DESC DEPT01; �ϰ� �ڿ� �ּ� �޾Ƴ��� �����Ű�� �����߻��Ѵ�..!!

-- ALTER
ALTER TABLE DEPT01
MODIFY(DNAME VARCHAR2(30));

-- RENAME : �̸� ����
RENAME DEPT01 TO DEPT02;
DESC DEPT02;

SELECT * FROM DEPT02;
INSERT INTO DEPT02 VALUES(10,'���ߺ�','����');
--DELETE FROM DEPT02;
-- DEPT02�� �ִ� ��� ������ ����
--ROLLBACK;
-- ROLLBACK �ѹ� : ������ �����ϰ� �� �� �ѹ��� �ϸ� �ٽ� �� ������ ���ư���.

-- TRUNCATE : ������ ������ ����, ���̺��� ������ �ȵǰ� �����͸� ���� (DELETE�� �ٸ�,,)
TRUNCATE TABLE DEPT02;

-- DROP : ���̺� ��ü�� �� ���󰣴�.
DROP TABLE DEPT02;


-- DCL(DATA CONTROL DANGUAGE) : GRANT, REVOKE
-- GRANT : ���� �ο�
-- REVOKE : ���� ���



SELECT * FROM TAB;

SELECT * FROM DEPT01;
DESC DEPT01;
INSERT INTO DEPT01 VALUES(NULL,'���ߺ�','����');

SELECT * FROM DEPT;
--INSERT INTO DEPT VALUES(NULL,'���ߺ�','����');
-- ���� ���� ) ORA-01400: cannot insert NULL into ("SCOTT"."DEPT"."DEPTNO")
-- DEPTNO Į���� NULL�� ���� �� ����.
INSERT INTO DEPT VALUES(50,'���ߺ�','����');
DESC DEPT;



-- ������Ÿ�� : NUMBER, DATE, VARCHAR2
-- BOOLEAN Ÿ���� ������ ����ϰ� CHAR������ ���� �� �ִ�.
CREATE TABLE ITEMS(
  ITEM_NO NUMBER(3),
  ISACTIVE CHAR(1) CHECK(ISACTIVE IN ('Y', 'N'))
  -- ���������� �־��ش�. �������� : NOT NULL, PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK
  -- ISACTIVE�� Y �Ǵ� N ���ڿ��� �������� Ȯ���ϴ� �������� ����
);

SELECT * FROM ITEMS;
INSERT INTO ITEMS VALUES(101, 'Y');
INSERT INTO ITEMS VALUES(101, 'N');
INSERT INTO ITEMS VALUES(102, 'F'); -- ���� �߻��Ѵ�! Y �Ǵ� N ���ڿ��� �;��ϴ� ���������� ����־��� ������ F���ڿ� �������� �ϴ� �����߻�



-- 2.4 ������ ��ȸ�� ���� SELECT ��
-- ���� : SELECT * (COLUM_NAME) FROM TABLE_NAME
SELECT * FROM DEPT;
SELECT * FROM EMP;
DESC EMP;
SELECT EMPNO, ENAME FROM EMP;



-- ��� ������
SELECT ENAME, SAL, SAL*12, COMM, SAL*12+COMM FROM EMP;

-- NVL(NULL VALUE) �Լ��� NULL�� 0 �Ǵ� �ٸ� ������ ��ȯ�� �� �ִ�.
SELECT ENAME, SAL, SAL*12, COMM, SAL*12+NVL(COMM,0) FROM EMP;

SELECT ENAME, SAL, SAL*12, COMM, SAL*12+NVL(COMM,0) AS ANNSAL FROM EMP;

SELECT ENAME, SAL, SAL*12, COMM, SAL*12+NVL(COMM,0) "A N N S A L" FROM EMP;

SELECT ENAME, SAL, SAL*12, COMM, SAL*12+NVL(COMM,0) "����" FROM EMP;



-- Concatenation ������
SELECT ENAME, JOB FROM EMP;
SELECT ENAME || ' IS A ' || JOB FROM EMP;


-- DISTINCT Ű����
SELECT * FROM EMP;
SELECT DEPTNO FROM EMP;
-- DEPNO �÷��� �ߺ��� ���� �����Ѵ�.
SELECT DISTINCT DEPTNO FROM EMP;
-- DEPNO �÷����� ���� �ߺ����� �ʰ� �ѹ����� �� ��µȴ�.
