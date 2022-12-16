SELECT * FROM DEPT01;
DESC DEPT01;
INSERT INTO DEPT01 VALUES(10, '�ѹ���', '����');
INSERT INTO DEPT01 (DEPTNO, DNAME) VALUES(20,'���ߺ�');

-- INSERT ������ ���� �߻� �� 1.
INSERT INTO DEPT01
(DEPTNO, DNAME, LOC) VALUES (30, 'ACCOUNTING', '����', 20);

INSERT INTO DEPT01 VALUES (40, '������', NULL);

-- NULL ���� �����ϴ� ���
-- �Ͻ������� NULL ���� ����
INSERT INTO DEPT01 (DEPTNO, DNAME) VALUES(20,'���ߺ�');

-- ��������� NULL ���� ����
INSERT INTO DEPT01 VALUES (40, '������', NULL);


-- 10-01-04. ���������� ������ �����ϱ�
DROP TABLE DEPT02;

CREATE TABLE DEPT02
AS
SELECT * FROM DEPT WHERE 1=0; -- ���̺� Ʋ�� ����

SELECT * FROM DEPT02; -- ������ ���� ���̺� Ʋ�� ����� ���� �� �� �ִ�.

INSERT INTO DEPT02 -- ���� ������ ���� ��
--VALUES( ); -- �̰ɷ� ���ϰ�Ʒ��� �ڵ�� ���� ������ �����Ѵ�.
SELECT * FROM DEPT; -- ���� ������ ���� ��,,




-- ���� ���̺� ������ �Է��ϱ�
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
-- ���̺� EMP_HIR�� EMP_MGR�� �����͸� ���ÿ� �ְ� �ִ�.

SELECT EMPNO, ENAME, HIREDATE, MGR
FROM EMP
WHERE DEPTNO=20;
-- ���� EMP ���̺����� �� �÷����� EMP_HIR�� �ʿ��Ѱ͸�,
-- EMP_MGR�� �ʿ��� �÷��鸸 �����ٰ� �������� ���̴�.

SELECT * FROM EMP_HIR;
SELECT * FROM EMP_MGR;



--- [ �ǽ� : INSERT ALL ��ɿ� ���� (WHEN)���� ���� ���̺� ������ �Է��ϱ� ] ----
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
WHEN HIREDATE > '1982/01/01' THEN -- �� ������ �����ϸ� EMP_HIR02 ���̺� ������ �����ϴ� ��
INTO EMP_HIR02 VALUES(EMPNO, ENAME, HIREDATE)
WHEN SAL > 2000 THEN
INTO EMP_SAL VALUES(EMPNO, ENAME, SAL)
SELECT EMPNO, ENAME, HIREDATE, SAL FROM EMP;
-- EMP ���̺��� EMPNO, ENAME, HIREDATE, SAL �÷����� �����ͼ�
-- HIREDATE > '1982/01/01 ������ �����ϸ� EMP_HIR02 ���̺�
-- (EMPNO, ENAME, HIREDATE) �� �÷����� �����͸� �������ְ�
--  SAL > 2000 ������ �����ϸ� 
-- EMP_SAL  ���̺� (EMPNO, ENAME, SAL) �÷��� �����͸� �������ش�.

SELECT * FROM EMP_HIR02;
SELECT * FROM EMP_SAL;




-- UPDATE��
DROP TABLE EMP01;

CREATE TABLE EMP01
AS
SELECT * FROM EMP;

SELECT * FROM EMP01
ORDER BY SAL ASC;

UPDATE EMP01
SET DEPTNO = 30; -- ���̺� ��� �� ����

UPDATE EMP01
SET SAL = SAL * 1.1;

ROLLBACK; -- �ѹ��ϸ� �� �տ� ������Ʈ �ϱ� ���� ������ ���ư���,,

UPDATE EMP01
SET HIREDATE = SYSDATE;

SELECT * FROM EMP01;

--- 2. ���̺� Ư�� �ุ ���� ---
DROP TABLE EMP01;

CREATE TABLE EMP01
AS
SELECT * FROM EMP;

SELECT * FROM EMP01;

UPDATE EMP01
SET DEPTNO=30
WHERE DEPTNO=10; -- Ư�� �ุ ����


UPDATE EMP01
SET SAL = SAL * 1.1
WHERE SAL < 3000;


UPDATE EMP01
SET HIREDATE = SYSDATE
WHERE SUBSTR(HIREDATE, 1, 2) = '87';
-- HIREDATE���� ù��°���� �ΰ��� �������� �� 87�� ���


--- 3. ���̺��� 2�� �̻��� �÷��� ���� ---
-- �ռ����� ��� �÷� 1���� ���� �������� --
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


-- ���� ������ �̿��� ������ ���� --
SELECT * FROM DEPT01;

UPDATE DEPT01
SET LOC = (SELECT LOC FROM DEPT WHERE DEPTNO=20);



-- DELETE �� --
-- 1. DELETE�� �̿��Ͽ� �� ����
DELETE FROM DEPT01; -- DEPT01 ���̺� �ִ� ������ ��� ����
SELECT * FROM DEPT01;
ROLLBACK; -- DELETE�ϱ� ������ ������ ���� ����

DELETE FROM DEPT01
WHERE DEPTNO=30; -- 2. ���� �����Ͽ� Ư�� �ุ ����

DELETE FROM DEPT01
WHERE DEPTNO = ( SELECT DEPTNO FROM DEPT WHERE DNAME = 'RESEARCH' ); -- 3. ���� ������ �̿��� ������ ����

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

-- ������ ���� ������ ���Ӱ� �߰� --
INSERT INTO EMP02
VALUES(8000, 'SYJ', 'TOP', 7566, '2009/01/12', 1200, 10, 20);


-- EMP02�� ������ EMP01�� MERGE �պ� �Ϸ��� �� --
-- EMP02 -- MERGE --> EMP01
-- MERGE �� �Ҷ� UPDATE�� ������ϴµ� EMP02�� ������ �ִ��� UPDATE�� MERGE���ְ�
-- EMP02�� ���Ӱ� �߰��� �����ʹ� INSERT�ؼ� EMP01�� MERGE������Ѵ�.
MERGE INTO EMP01
USING EMP02
ON(EMP01.EMPNO=EMP02.EMPNO) -- EMPNO�� ������ �����Ͱ� ������ �ƴ��� Ȯ���ϰڴ�.
WHEN MATCHED THEN
UPDATE SET
EMP01.ENAME=EMP02.ENAME,
EMP01.JOB=EMP02.JOB,
EMP01.MGR=EMP02.MGR,
EMP01.HIREDATE=EMP02.HIREDATE,
EMP01.SAL=EMP02.SAL,
EMP01.COMM=EMP02.COMM,
EMP01.DEPTNO=EMP02.DEPTNO
WHEN NOT MATCHED THEN -- ��ġ�� �ȵȴٴ� �� EMP01.EMPNO != EMP02.EMPNO �̶�� �Ű� �װ� EMP01���� ���� EMP02�� �ִٴ� �Ŵϱ� ���� �߰��� �����Ͷ�� ��
INSERT VALUES(EMP02.EMPNO, EMP02.ENAME, EMP02.JOB, 
EMP02.MGR, EMP02.HIREDATE, EMP02.SAL, 
EMP02.COMM, EMP02.DEPTNO);
-- JOB�� MANAGER ���� ������� UPDATE �Ǿ MERGE �Ǿ���
-- ENAME 'SYJ' �� �ִ� ������ ���� �����Ϳ��� INSERT �Ǿ MERGE �Ǿ���.

SELECT * FROM EMP01;
INSERT INTO EMP01 (EMPNO, ENAME) VALUES (7369, 'ȫ�浿');
-- �̹� EMPNO�� 7369�� ����� ���������� ���� �����Ͱ� �� �߰��� �ȴ�.

DESC EMP;
-- ���⼭ ���� EMPNO �� NOT NULL�̴�.
-- EMPNO : ��������(PRIMARY KEY = NOT NULL + UNIQUE, �⺻Ű) <-- ���� �� �־�����Ѵ�. ���� �ȳ־��ָ� �ȵȴ�.
INSERT INTO EMP (EMPNO, ENAME) VALUES (7369, 'ȫ�浿'); --  ORA-00001: unique constraint (SCOTT.PK_EMP) violated ���� �߻�
-- �̹� EMPNO�� 7369�� �ֱ� ������ �� EMPNO�� 7369�� �����͸� �߰��� ���� ����. ��? �ߺ��Ǵϱ�
-- EMPNO�� NOT NULL + UNIQUE�� ���������� �ֱ� ������ �ߺ��� ������ �� �� ����.
-- �׷��� ������ �ߺ��� �� �߰��Ϸ��� �ϴ� ������ �߻��Ѱ��̴�.




----------------------------------------------------------------------------------------------------------------------------------------------------

-- 11. Ʈ�����

DROP TABLE DEPT01;

CREATE TABLE DEPT01
AS
SELECT * FROM DEPT;

SELECT * FROM DEPT01;



---- 3. �ڵ� Ŀ�� --
-- �ǽ� : CREATE���� ���� �ڵ� Ŀ��
DROP TABLE DEPT02;

CREATE TABLE DEPT02
AS
SELECT * FROM DEPT;

SELECT * FROM DEPT02;

DELETE FROM DEPT02
WHERE DEPTNO=40; -- ���� COMMIT ����, �׷��� ROLLBACK �ϸ� ������ ���� ��
ROLLBACK;

-- DDL ���� AUTO COMMIT�� ����ȴ�.
-- ���� CREATE DEPT03 �ϰ��� ROLLBACK�� �ؼ� DEPT02 ���� ������ ���ư����� ROLLBACK�� �ص�
-- ROLLBACK�� �ȵȴ�,, CREATE�� DDL! DDL�� �ڵ����� COMMIT�� �Ǳ� ������ ROLLBACK�� �ȵ�,,
CREATE TABLE DEPT03
AS
SELECT * FROM DEPT;



-- �ǽ� : DDL�� ���п� ���� �ڵ� Ŀ��
DROP TABLE DEPT03;

CREATE TABLE DEPT03
AS
SELECT * FROM DEPT;

SELECT * FROM DEPT03;

DELETE FROM DEPT03
WHERE DEPTNO=20;

ROLLBACK; -- ROLLBACK�ϸ� DEPTNO=20 ���� ������ ���ư� �� ����


TRUNCATE TABLE DEPTPPP;  -- DEPTPPP �̸��� ���̺��� �����Ƿ� �� ������ ���� ���а� �ȴ�.
-- �� ���� ���еǴ� TRUNCATE ���� ���� ��Ų ���Ŀ� �ٽ� ������ ���� ROLLBACK �ؼ�
-- DEPT03 ���̺� ���� ������ ���ư����� ������ TRUNCATE���� ����Ǹ鼭 �ڵ� Ŀ�ԵǾ�
-- ROLLBACK �� �ȵȴ�.



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

ROLLBACK TO C2; -- C2�� ���� 20���� �����ߴ� ���� ���ư� -> DEPTNO = 10 ��µ�
ROLLBACK TO C1; -- C1�� ���� 30���� �����ߴ� ���� ���ư� -> DEPTNO = 10, 20 ��µ�
ROLLBACK; -- Ŀ�Ե� ���� ���ư�,,? -> DEPTNO = 10, 20, 30 ��µ�




SELECT * FROM EMP01
WHERE ENAME = 'SCOTT';

DELETE FROM EMP01
WHERE ENAME = 'SCOTT';
-- ���⼭ DELETE ���༭ ���⼭�� �Ⱥ��̴µ� cmd â������ �߸� ���δ�.

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
SET UNUSED (COMM); -- COMM �÷��� UNUSED �ϰ� EMP02�� ���ԵǸ� �����Ȱ�ó�� �Ⱥ��̰� �ȴ�! ������ �����Ȱ� �ƴ�!!

--  �÷��� ����� ������ �ٸ� ����� �� �÷��� ������ �� �����ϰ� ������ ���� �ɸ��� �ȴ�,,


-- DDL ����� �ѹ�
DROP TABLE EMP01;

CREATE TABLE EMP01
AS
SELECT * FROM EMP;

SELECT * FROM EMP01; -- EMP01 �� ���� ���̺�

DROP TABLE EMP02;

CREATE TABLE EMP02 -- EMP02�� EMP01 ������ ���̺�
AS
SELECT * FROM EMP01;

SELECT * FROM EMP02;

ALTER TABLE EMP01
DROP COLUMN JOB; -- �� �ڵ�,, ���� �ȵ�,, �տ��� JOB �÷��� UNUSED �ؼ� ���� �ɷȴ�..!
                             -- �׷��� DROP �Ϸ��� �ϴϱ� ���� �߻�,, �����,,?
                             
                             
ROLLBACK;

DROP TABLE EMP01;
SELECT * FROM EMP02;




--- TRUNCATE �� DELETE ������
-- �Ѵ� ���̺��� ��� ���� �����Ѵ�. TRUNCATE = DELETE + COMMIT
-- �۾� �� TRUNCATE ���ٴ� DELETE �� �������!!
-- DELTET�� ROLLBACK�� �����ϴϱ�,,, Ȥ,,�ó� �ϴ� ������ ������ �� �ִ�.
DROP TABLE EMP01;
CREATE TABLE EMP01
AS
SELECT * FROM EMP;
SELECT * FROM EMP01;

TRUNCATE TABLE EMP01; -- DDL ��ɾ�μ� �ڵ� Ŀ���� �߻��ϱ� ������ �������� �ǵ��� �� ����.

SELECT * FROM EMP01;
ROLLBACK; -- ROLLBACK�� �ص� ������ ���� �ȵȴ�.
SELECT * FROM EMP01;

DROP TABLE EMP02;
CREATE TABLE EMP02
AS
SELECT * FROM EMP;

SELECT * FROM EMP02;

DELETE FROM EMP02; -- DML ��ɾ��̱� ������ �ѹ��� �����ϸ� ���� �������� �ǵ��� �� �ִ�.
SELECT * FROM EMP02;
ROLLBACK; -- ROLLBACK �ϸ� ������ ���� �ȴ�.
SELECT * FROM EMP02;

DROP TABLE EMP03;
CREATE TABLE EMP03
AS
SELECT * FROM EMP;
SELECT * FROM EMP03;

DELETE FROM EMP03
WHERE DEPTNO =10 OR DEPTNO=20;

SELECT * FROM EMP03;
COMMIT; -- Ŀ�� �Ŀ��� Ʈ������� ����� ���̹Ƿ� �ѹ� �̹����� ���ŵȴ�.
ROLLBACK; -- ���� ���� ���� ���·� ���ư� �� ����.

SELECT * FROM EMP03;




--13��
SELECT * FROM EMP;
DESC EMP; -- EMPNO �÷��� NOT NULL ���������� ������ �ִ�. --> EMPNO �÷����� �����Ͱ� ���� �� �� ����. NULL�� ���� ���� ����.
-- �׸��� EMPNO �÷��� NOT NULL �̸鼭 UNIQUE �� PRIMARY KEY ���������� �ִ�.



















