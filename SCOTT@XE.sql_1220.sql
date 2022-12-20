SELECT * FROM EMP;

-- SEQUENCE �����ϱ�
CREATE SEQUENCE DEPT_DEPTNO_SQ
INCREMENT BY 10
START WITH 10;
-- ���� 10���� �����Ͽ� 10�� �����ϴ� SEQUENCE ����

-- SEQUENCE ��ȸ
DESC USER_SEQUENCES;

SELECT SEQUENCE_NAME, MIN_VALUE, MAX_VALUE, INCREMENT_BY, CYCLE_FLAG
FROM USER_SEQUENCES;
-- �� ������ ������ �ִ� SEQUENCE�鿡 ����
-- SEQUENCE_NAME, MIN_VALUE, MAX_VALUE, INCREMENT_BY, CYCLE_FLAG ������ ���


-- SEQUENCE �� Ȯ�� : CURVAL, NEXTVAL
SELECT DEPT_DEPTNO_SQ.NEXTVAL FROM DUAL; -- ��� ������ ������ 10�� �����ϴ� ����� �����Ѵ�
-- ������ ������ �������� ���� ���� �˷��ش�. <-- NEXTVAL
SELECT DEPT_DEPTNO_SQ.CURRVAL FROM DUAL;
-- ������ ���� �˷��ش�. <-- CURRVAL




-- SEQUENCE �ǹ�
CREATE SEQUENCE EMP_SEQ
START WITH 1
INCREMENT BY 1
MAXVALUE 100000;

DROP TABLE EMP01;

CREATE TABLE EMP01(
    EMPNO NUMBER(4) PRIMARY KEY,
--    ENAME VARCHAR2(10),  -- ORACLE ���ڿ� �ڷ���
    ENAME VARCHAR(10),     -- ANSI ���ڿ� �ڷ���
    HIREDATE DATE
);
-- VARCHAR2 = VARCHAR

INSERT INTO EMP01 VALUES (EMP_SEQ.NEXTVAL, 'JULIA', SYSDATE);
-- EMPNO ���� �츮�� ���� EMP_SEQ �������� ���� ���� �־��ش�.

SELECT * FROM EMP01;
-- INSERT INTO EMP01 �� �߰��� 5�� ������� ������ ���� ��µȴ�.



-- SEQUENCE ���ſ� ����
SELECT SEQUENCE_NAME, MAX_VALUE, INCREMENT_BY, CYCLE_FLAG
FROM USER_SEQUENCES;
-- �����ϰ� ���� SEQUENCE�� ã�� ���� ���� SEQUENCE���� ��ȸ�Ѵ�.

-- DEPT_DEPTNO_SQ ����
DROP SEQUENCE DEPT_DEPTNO_SQ;

-- EMP_SEQ �� MAX_VALUE ���� ����
ALTER SEQUENCE EMP_SEQ
MAXVALUE 100;
-- MAXVALUE �� 100000 ���� 100 ���� �����Ѵ�.


-- Q1. �ּҰ� 1, �ִ밪 99999999, 1000���� �����ؼ� 1�� �����ϴ� ORDERS_SEQ ��� �������� ������.
DROP SEQUENCE ORDERS_SEQ;

CREATE SEQUENCE ORDERS_SEQ
START WITH 1000
INCREMENT BY 1
MAXVALUE 99999999
MINVALUE 1;

SELECT ORDERS_SEQ.NEXTVAL FROM DUAL;
SELECT ORDERS_SEQ.CURRVAL FROM DUAL;



-----------------------------------------------------------------------------------------------------------------

-- 16. �ε��� INDEX : ����

-- �ε��� ���� ��ȸ�ϱ�
SELECT INDEX_NAME, TABLE_NAME, COLUMN_NAME
FROM USER_IND_COLUMNS
WHERE TABLE_NAME IN ('EMP',  'DEPT');
-- 'EMP'��  'DEPT' ���̺� �ε����� �ִٸ� �ε����� �̸�, ���̺��� �̸�, Į���� �̸��� ����ϴ� ��
-- PK �� �⺻������ �ε����� �ɸ���,,
-- PK �뵵�� �����͸� ã�� ���� �뵵�̹Ƿ� �ε����� �뵵�� ���⿡ �ɸ���.



-- ��ȸ �ӵ� ��

-- Į������ �˻��ϱ�
-- ��� ���̺� �����ϱ�
DROP TABLE EMP01;

CREATE TABLE EMP01
AS 
SELECT * FROM EMP;

SELECT TABLE_NAME, INDEX_NAME, COLUMN_NAME
FROM USER_IND_COLUMNS
WHERE TABLE_NAME IN ('EMP', 'EMP01');
-- EMP ���̺��� ������ EMP01 ���̺��� ���� �ε����� ������??
-- ���̺� ��ü�� �����ص� �����Ϳ� ���̺� Ʋ�� ���簡 ���� �ε����� ������� �ʴ´�. 

-- �ε����� �ƴ� Į������ �˻��ϱ�
-- ���̺� ��ü ���縦 ������ �ݺ��ؼ� ����� ���� ���� ���� �����Ѵ�.
INSERT INTO EMP01
SELECT * FROM EMP01;
-- �ڱ� �ڽ��� SELECT �ؼ� �ִ´�..
-- ���� ������ 2���� ���� ������ �ȴ�.
-- �̷��� Į���� ���� ��� ������ϰ� �߰��ϰ� �� �Ŀ� ���� ���ϴ� �����͸� �˻��ؼ� ã������ �ϸ�
-- �ð��� �󸶳� �ɸ���,,, �ƹ����� �� ���� �ɸ� ���̴�,,

SELECT COUNT(*) FROM EMP01;

INSERT INTO EMP01 (EMPNO, ENAME) VALUES(1111, 'SES');

SET TIMING ON
SELECT DISTINCT EMPNO, ENAME
FROM EMP01
WHERE ENAME='SES';



-- 4. �ε����� ��ȸ�ϱ� --
-- �ε��� �����ϱ�
CREATE INDEX IDX_EMP01_ENAME
ON EMP01(ENAME);

-- �ε��� ���� �� ������ �˻�
SET TIMING ON
SELECT DISTINCT EMPNO, ENAME
FROM EMP01
WHERE ENAME='SES';


-- �ε��� �����ϱ�
DROP INDEX IDX_EMP01_ENAME;

-- �ε��� �����ϰ� ������ ã��
SET TIMING ON
SELECT DISTINCT EMPNO, ENAME
FROM EMP01
WHERE ENAME='SES';
-- �ε����� �����߱� ������ �ٽ� Į������ ������ ��ȸ�� �Ǿ� ã�µ� �ð��� �ɸ���.



-----------------------------------------------------------------------------------------------------------
-- 17. ����� ����

--�ý��� ���� : CREATE USER
CREATE USER USER10 IDENTIFIED BY USER10;
-- ������ ��� �ȸ������




SHOW USER;
-- ��ü ���� �ο�
GRANT SELECT ON EMP TO USER01;

SELECT * FROM SCOTT.EMP; -- ��Ģ�����δ� �̷��� ǥ���ؼ� �ڵ带 ��������Ѵ�. ������ �Ʒ��� �ڵ�ó�� ��� ����� �ȴ�.
SELECT * FROM EMP;

-- �ο��ϰ� �ο��� ���� ��ȸ
SELECT * FROM USER_TAB_PRIVS_MADE;  -- �ڽ��� �ο��� ��ü����
SELECT * FROM USER_TAB_PRIVS_RECD;  -- �ڽ��� ���� ��ü����


-- ��ü ���� �����ϱ�
REVOKE SELECT ON EMP FROM USER01;


-- WITH GRANT OPTION
GRANT SELECT ON SCOTT.EMP TO USER02
WITH GRANT OPTION;
-- SCOTT�� ������ �ִ� EMP ��ü�� ������ �� �ִ� ������ USER02���� �ο���
-- WITH GRANT OPTION ������ �޾ұ� ������ USER02������ ���� �ٸ� �������� ������ �ο��� �� �ְ� �Ǿ���.











