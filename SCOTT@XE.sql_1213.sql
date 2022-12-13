-- DQL (Data Query Language, ������ ���Ǿ�) : SELECT ��
SELECT * FROM DEPT;
SELECT DEPTNO, DNAME FROM DEPT;

-- DML (Data Manupulation Language, ������ ���۾�) : INSERT, UPDATE, DELETE
INSERT INTO DEPT VALUES(60, '�ѹ���', '��õ');
UPDATE DEPT SET LOC='�λ�' WHERE DNAME='�ѹ���';
DELETE FROM DEPT WHERE DEPTNO=60;

-- DDL (Data Definition Language, ������ ���Ǿ�) : CREATE, ALTER, DROP, RENAME, TRUNCATE
DESC DEPT01;
DROP TABLE DEPT01;

CREATE TABLE DEPT01(
    DEPTNO NUMBER(4),
    DNAME VARCHAR2(10),
    LOC VARCHAR2(9)
);
SELECT * FROM DEPT02;
INSERT INTO DEPT02 VALUES(10, '���ߺ�', '����');

ALTER TABLE DEPT01
MODIFY(DNAME VARCHAR2(30));

RENAME DEPT01 TO DEPT02;
DESC DEPT02;

-- TRUNCATE : �����͸� �ڸ��� ���̺��� �״�� ��������
-- TRUNCATE = DELETE + COMMIT
TRUNCATE TABLE DEPT02;

-- ������� 1�� ����, �Ʒ����ʹ� 2�� ����

-- ORACLE NULL = ���� ��Ȯ�� Ȥ�� �𸣴� ��, NULL �� �����Ϸ��� ��������� �Ѵ�.
--3 + ? = ?;
SELECT * FROM EMP;
SELECT SAL, COMM, SAL*12+NVL(COMM,0) AS "����" FROM EMP;
-- NVL(COMM,0) : COMM Į���� NULL ���� ���� �� ������ �׷��� 0 ������ �ٲ㼭 �����ض� ��� �ǹ�
-- NVL(NULL VALUE) �Լ��� NULL�� 0 �Ǵ� �ٸ� ������ ��ȯ�ϱ� ���� ����Ѵ�.

-- || (Concatenation, ������)
SELECT ENAME, JOB FROM EMP;
SELECT ENAME || ' IS A ' || JOB FROM EMP;

-- DISTINCT Ű���� : ������ ���� �ѹ��� ������ش�.
SELECT * FROM EMP;
SELECT DISTINCT DEPTNO FROM EMP;




-- 12/13 ��������
-- 1-1. SELECT ������ WHERE ���ǰ� �� ������
SELECT * FROM EMP
WHERE SAL >= 3000;

SELECT EMPNO, ENAME, SAL FROM EMP
WHERE SAL != 3000;
--WHERE SAL <> 3000;
--WHERE SAL ^= 3000;
-- !=, <>, ^= �� �Ȱ��� �����ʴ� �� �ǹ��Ѵ�.


-- 1-2.���� ������ ��ȸ
DESC EMP;
SELECT EMPNO, ENAME "�̸�", SAL
FROM EMP
WHERE ENAME ='FORD';
--WHERE ENAME ='ford';
-- ���ڿ��� ��ҹ��ڸ� �����ϱ� ������ ��������!!


-- 1-3. ��¥ ������ ��ȸ
SELECT * FROM EMP
WHERE HIREDATE<='82/01/01';
-- 82�� ���� �Ի�(HIREDATE)�� ����� ��ȸ�Ǿ� ������ش�.


-- 2. �������� : AND, OR, NOT
SELECT * FROM EMP
WHERE DEPTNO=10 AND JOB='MANAGER';

SELECT * FROM EMP
WHERE DEPTNO=10 OR JOB='MANAGER';

SELECT * FROM EMP
--WHERE NOT DEPTNO=10;
WHERE DEPTNO != 10;
--WHERE NOT DEPTNO=10; �� WHERE DEPTNO != 10; �� ���� ���� ��µȴ�. --> ���� �ǹ�,,?


-- 3. BETWEEN AND ������
SELECT *
FROM EMP
--WHERE SAL>=2000 AND SAL<=3000;
-- 2000 <= SAL <= 3000 �̰Ÿ� ���� �ڵ�ó�� AND �� ������ BETWEEN AND �� ������ �������� �� �ִ�.
WHERE SAL BETWEEN 2000 AND 3000;

SELECT *
FROM EMP
WHERE HIREDATE BETWEEN '1987/01/01' AND '1987/12/31';


-- 4. IN ������
SELECT *
FROM EMP
WHERE COMM=300 OR COMM=500 OR COMM=1400;
-- 300 �̰ų� 500�̰ų� 1400�� COMM ���

SELECT *
FROM EMP
WHERE COMM IN(300,500,1400);
-- COMM�� 300 �Ǵ� 500 �Ǵ� 1400 �߿� �ִ��� Ȯ���ϰ� ������ش�.

-- WHERE COMM=300 OR COMM=500 OR COMM=1400; �ݴ��� ���̽�
SELECT *
FROM EMP
--WHERE COMM<>300 AND COMM<>500 AND COMM<>1400;
-- 300�� �ƴϰ� 500�� �ƴϰ� 1400�� �ƴ� COMM ����� �ٷ� �� �ڵ�� �ٷ� �Ʒ��� �ڵ�� ��� ����� �� �ִ�.
WHERE COMM NOT IN(300,500,1400);



-- 5. LIKE �����ڿ� ���ϵ�ī�� ����ϱ� (%, _)
-- 5.1 % ���
SELECT *
FROM EMP
WHERE ENAME LIKE 'F%';
-- ENAME �߿��� F�� �����ϴ� ENAME �� ���

SELECT *
FROM EMP
WHERE ENAME LIKE '%A%';
-- ENAME �߿��� A �հ� �ڿ� � ���ڰ� �͵� ������� �׳� A�� �� ENAME�� ���

SELECT *
FROM EMP
WHERE ENAME LIKE '%N';
-- ENAME �߿��� N���� ������ ENAME �� ���
-- ��, N �տ��� � ���ڰ� �͵� ��������� N �ڿ� ���ڰ� �� ������ �ȵ�


-- 5.2 _ ���
SELECT *
FROM EMP
WHERE ENAME LIKE '_A%';
-- ENAME �� A �տ� ������ �ѱ��ڰ� �ְ� A �ڿ��� ����ڰ� ������ ������� ENAME ���
-- ��, A�� �ι�° ������ ENAME ����Ѵ�.

SELECT *
FROM EMP
WHERE ENAME LIKE '__A%';
-- ENAME �� A �տ� ������ �α��ڰ� �ְ� A �ڿ��� ����ڰ� ������ ������� ENAME ���
-- ��, A�� ����° ������ ENAME ����Ѵ�.


-- 5.3 NOT LIKE ������
SELECT *
FROM EMP
WHERE ENAME NOT LIKE '%A%';
-- ENAME �� A ���ڰ� ������ �ʴ� ENAME ���


-- 6. NULL ���� ������
SELECT *
FROM EMP
--WHERE COMM=NULL;
--WHERE COMM IS NULL;
-- COMM Į���� ���� NULL ���� ����� NULL �� �ֵ� ���
WHERE COMM IS NOT NULL;
-- COMM Į���� ���� NULL �� �ƴ��� ����� NULL �� �ƴ� �ֵ� ���



-- 7. ������ ���� ORDER BY��
-- �ϳ��� ���� '��' �̶�� �Ѵ�.
-- SELECT *  <-- �̰� SELECT ��
-- FROM EMP   <-- �̰� FROM ��
-- WHERE COMM IS NOT NULL  <-- �̰� WHERE ��
-- �� �ܿ��� '���� ��' �̶��� ���⿡ �߰��� ���� �� �ִ�!!
SELECT *
FROM EMP
--ORDER BY SAL ASC;
-- SAL �������� �������� ������ �� ���� ���
-- ASC ���������� ����Ʈ�̱� ������ ASC�� �����ؼ� ��� �������� �Ѱ� ������ش�.
ORDER BY SAL;

SELECT *
FROM EMP
ORDER BY SAL DESC;


SELECT *
FROM EMP
ORDER BY ENAME;
-- ENAME �������� ��������

SELECT *
FROM EMP
ORDER BY HIREDATE DESC;
-- HIREDATE �������� ��������

SELECT *
FROM EMP
ORDER BY SAL DESC, ENAME ASC;
-- SAL �� ������������ ������ �� ENAME�� ������������ �����Ͽ� ���




-- 4�� ��������
-- 1��.
SELECT *
FROM EMP
ORDER BY HIREDATE DESC, EMPNO ASC;

-- 2��.
SELECT *
FROM EMP
WHERE ENAME LIKE 'K%';

--3��.
SELECT *
FROM EMP
WHERE ENAME LIKE '%K%';

--4��.
SELECT *
FROM EMP
WHERE ENAME LIKE '%K_';





-- 5-1. DUAL ���̺� : ��������� ����� �� �ٷ� ��� ���� ����Ѵ�.
SELECT * FROM DUAL;
SELECT 24*60 FROM EMP;
-- EMP ���̺��� 14���� �ο츦 ������ �־ 14���� 24*60�� ���� ��µȴ�.
SELECT 24*60 FROM DEPT;
-- DEPT ���̺��� 5���� �ο츦 ������ �־ 5���� 24*60�� ���� ��µȴ�.

SELECT 24*60 FROM DUAL;
-- 24*60 �� ���� �ϳ��� ������ �Ǵϱ� �̷� ���� DUAL ���̺��� �̿��ؼ� ���� ������ ����.

SELECT SYSDATE FROM DUAL;
-- SYSDATE �� ������ ��¥�� ������ش�. (22/12/13) ���



-- 5.2 ���� �Լ�
-- (1) ABS �Լ� : ���� ���ϱ�
SELECT -10, ABS(-10) FROM DUAL;

-- (2) FLOOR �Լ� : �Ҽ��� ������ �Ǽ��� ������ �����
SELECT 34.5678, FLOOR(34.5678) FROM DUAL;
--SELECT FLOOR(34.5678, 2), FLOOR(34.5678, -1), FLOOR(34.5678) FROM DUAL;


-- (3) ROUND �Լ� : Ư�� �ڸ������� �Ҽ��� �ݿø��ϱ�
SELECT 34.5678, ROUND(34.5678) FROM DUAL;
SELECT 34.5678, ROUND(34.5678, 2) FROM DUAL;
-- ROUND(34.5678, 2) : �ݿø��ؼ� �Ҽ��� 2��°������ ���
SELECT 34.5678, ROUND(34.5678, -1) FROM DUAL;


-- (4) TRUNC �Լ� : Ư�� �ڸ��� �߶󳻱�
SELECT TRUNC(34.5678, 2), TRUNC(34.5678, -1), TRUNC(34.5678) FROM DUAL;


-- (5) MOD �Լ� : ������ ���ϱ�
SELECT MOD(27,2), MOD(27,5), MOD(27,7) FROM DUAL;
-- MOD(27,2) : 27�� 2�� ����� ������ ������ ��� -> 1
-- MOD(27,5) : 27�� 5�� ����� ������ ������ ��� -> 2
-- MOD(27,7) : 27�� 7�� ����� ������ ������ ��� -> 6



-- 5.3 ���� ó�� �Լ�
-- (1) UPPER �Լ� : ��� �빮�ڷ� ��ȯ
SELECT 'Welcome to Oracle', UPPER('Welcome to Oracle') FROM DUAL;

-- (2) LOWER �Լ� : ��� �ҹ��ڷ� ��ȯ
SELECT 'Welcome to Oracle', LOWER('Welcome to Oracle') FROM DUAL;

-- (3) INITCAP �Լ� : ���ڿ��� �̴ϼȸ� (��, �� ���ڿ��� ó����) �빮�ڷ� ��ȯ
SELECT 'WELCOME TO SOUTH KOREA', INITCAP('WELCOME TO SOUTH KOREA') FROM DUAL;

-- (4) LENGTH �Լ� : �÷��� ����� ������ ���� ��� ���ڷ� �����Ǿ��ִ��� ���� �˷��ִ� �Լ� --> ����� �� ���� ����!!
--                  ���鵵 ���̿� ���Եȴ�.
SELECT LENGTH('SOUTH KOREA'), LENGTH('���ѹα�') FROM DUAL;


-- (5) LENGTHB �Լ� : ����Ʈ ���� �˷��ִ� �Լ�
-- �ѱ� 1�� = 3����Ʈ
SELECT LENGTHB('Oracle'), LENGTHB('����Ŭ') FROM DUAL;
-- LENGTHB('Oracle') : 6 ���  /  LENGTHB('����Ŭ') : 9 ���
-- �ѱ� 3�ڷ� ������ '����Ŭ'�� LENGTHB �Լ� ����� 9
SELECT LENGTHB('Oracle'), LENGTHB('�������ְ��') FROM DUAL;
-- LENGTHB('�������ְ��') : 18 ���
-- ������!! ������ ���� 3���� ����Ʈ���� 9���ΰ� �������̴�!!
-- UTF-8 �� �⺻ ������ �Ǿ� �ִ�.


-- (6) SUBSTR, SUBSTRB �Լ� : �߿�!
-- SUBSTR �Լ� : ��� ���ڿ��̳� Į���� �ڷῡ�� ������ġ���� ���� ������ŭ�� ���ڸ� ����
-- SUBSTRB �Լ� : ��� ���ڿ��̳� Į���� �ڷῡ�� ������ġ���� ���� ������ŭ�� ����Ʈ ���� ���� 
SELECT SUBSTR('Welcome to Oracle', 4, 3) FROM DUAL;
-- ���ڿ����� W�� 1�̰� �������� �ϳ��� �����Ѵ�. �׷��� ���ڿ� 4��°���� 3�� �����ؼ� ������ش�.


-- (7) INSTR �Լ� : ��� ���ڿ��̳� Į������ Ư�� ���ڰ� ��Ÿ���� ��ġ ��ȯ
SELECT INSTR('WELCOME TO ORACLE', 'O') FROM DUAL;
-- WELCOME TO ORACLE ���� ���ڿ� O �� ���°�� �ִ��� �˷���
-- �� ó������ �ִ� ���ڿ� O�� 5��°�� �ִ� -> 5��µ�
SELECT INSTR('WELCOME TO ORACLE', 'ORACLE') FROM DUAL;  -- 12 ���


-- (8) INSTRB �Լ�
SELECT INSTR('�����ͺ��̽�', '��', 3, 1), INSTRB('�����ͺ��̽�', '��', 3, 1) FROM DUAL;
-- INSTR('�����ͺ��̽�', '��', 3, 1) : ���ڿ����� 3��°���� �����ؼ� '��' ���ڿ��� �� ó������ ������ ��°��
-- INSTRB('�����ͺ��̽�', '��', 3, 1) : ???
SELECT INSTR('�����ͺ��̽�', '��'), INSTRB('�����ͺ��̽�', '��', 3, 1) FROM DUAL;
SELECT INSTR('�����ͺ��̽�', '��'), INSTRB('�����ͺ��̽�', '��', 4, 1) FROM DUAL;
SELECT INSTR('�����ͺ��̽�', '��'), INSTRB('�����ͺ��̽�', '��', 5, 1) FROM DUAL;



-- (9) �����߰� �Լ� : LPAD(LEFT PADDING) �Լ� : ���ʿ� �Լ��� �ֶ� / RPAD �Լ� : �����ʿ� ������ �ֶ�
SELECT LPAD('Oracle', 20, '#') FROM DUAL;
-- ���ʿ� ������ �δµ� ��ü ���̴� 20�� �ǰ� ���� ������ #�� ä����
SELECT RPAD('Oracle', 20, '#') FROM DUAL;
-- �����ʿ� ������ �δµ� ��ü ���̴� 20�� �ǰ� ������ ������ #�� ä����
SELECT LPAD('Oracle', 20, ' ') FROM DUAL;
-- ���ʿ� ������ �δµ� ��ü ���̴� 20�� �ǰ� ���� ������ ����� ' '�� ä����


-- (10) ������� �Լ� : LTRIM�� RTRIM �Լ�
SELECT LTRIM('     Oracle  ') FROM DUAL;
-- ���� ������ ����� ������ ������ ���� ä ���
SELECT RTRIM('     Oracle  ') FROM DUAL;
-- ������ ������ ����� ���� ������ ���� ä ���

-- (11) TREIM �Լ�
SELECT TRIM('A' FROM 'AAAAAAORACLEAAA') FROM DUAL;
-- A ���ڴ� ��� �� ���� ���ڿ� ��� -> ORACLE �� ��µȴ�.



--5.4 ��¥ �Լ� --> ���� ����Ѵ�!! �߿�,,?!
-- (1) SYSDATE �Լ�
SELECT SYSDATE FROM DUAL;

-- (2) ��¥ ����
--SELECT SYSDATE-1 ����, SYSDATE ����, SYSDATE+1 ���� FROM DUAL;
SELECT SYSDATE-1 "����", SYSDATE "����", SYSDATE+1 "����" FROM DUAL;
-- " " ������ �׳� ����, ����, ���Ϸ� ��� �����ص� �Ȱ��� ��µȴ�.


-- (3) �ݿø� �Լ� : ROUND �Լ�
SELECT HIREDATE, ROUND(HIREDATE, 'MONTH') FROM EMP;
-- ���� 15�� ������ �ݿø� �Ǿ 2���̴��� 3���� �ݿø� �ȴ�
-- ex) 02/ 19  --> 03/01 �� �ȴ�.


-- (4, 5, 6, 7, 8) ��ŵ!!


-- 5.5 �� ��ȯ �Լ� !!! �߿� �� �߿�!!!

-- 1. ���������� ��ȯ�ϴ� TO_CHAR �Լ�
-- (1-1) ��¥�� -> ������ ��ȯ�ϱ� : TO_CHAR �Լ�
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS') FROM DUAL;
-- ���� SYSDATE ��ü���� ��, ��, �� ���� �� ������ �ִ�.



-- (1-2) ������ -> ������ ��ȯ : TO_CHAR �Լ�
SELECT TO_CHAR(123456, '0000000000'), TO_CHAR(123456, '999,999,999') FROM DUAL;
-- TO_CHAR(123456, '0000000000') : 123456�� 10�ڸ� ���������� -->  0000123456
-- TO_CHAR(123456, '999,999,999') :                         -->      123,456



-- 2. ��¥������ ��ȯ�ϴ� TO_DATE �Լ�
-- (1) ������ -> ��¥�� (NUMBER -> DATE)
SELECT ENAME, HIREDATE FROM EMP
WHERE HIREDATE=TO_DATE(19810220,'YYYYMMDD');
-- ���� 19810220 �� ��¥�� YYYYMMDD ���� ��ȯ�� HIREDATE �� �׿� �ش��ϴ� ����� ENAME ���� ���

-- (2) ������ -> ��¥�� (CHAR -> DATE)
SELECT TRUNC(SYSDATE - TO_DATE('2022/11/02', 'YYYY/MM/DD'))FROM DUAL;
-- '2022/11/02' ���ڸ� YYYY/MM/DD ��¥������ �ٲ㼭 SYSDATE�� ���� ��¥�κ��� �� �� �� ���
--SELECT TRUNC(SYSDATE - TO_DATE('2022-11-02', 'YYYY-MM-DD'))FROM DUAL;
-- ���� ���� ��� ���������� ��¥������ ��ȯ�� �ȴ�.


-- 3. ���������� ��ȯ�ϴ� TO_NUMBER �Լ�
-- (1) ������ -> ������ (CHAR -> NUMBER)
SELECT TO_NUMBER('20,000', '99,999') - TO_NUMBER('10,000', '99,999') FROM DUAL;
-- '20,000' ���ڿ��� 99,999 ���������� �ٲٰ� '10,000' ���ڸ� 99,999 ���������� �ٲ㼭 �� ���� ���
--SELECT TO_NUMBRT('2022/12/13', '999,999,999') FROM DUAL;



-- ����κ��� �ؾ��.,,---------------------------------------------------------------
CREATE TABLE TESTTIME(
    REGDATE DATE
);
-- Į�� REGDATE ���� DATE Ÿ�Ը� ����.

SELECT * FROM TESTTIME;
DESC TESTTIME;
INSERT INTO TESTTIME VALUES('2022/12/13');
INSERT INTO TESTTIME VALUES(20221213); -- ���� 20221213 �� ������ �ȵȴ�.
INSERT INTO TESTTIME VALUES(SYSDATE); -- SYSDATE�� ���� ��¥ �̹Ƿ� ����

SELECT * FROM TESTTIME;
SELECT TO_CHAR(REGDATE, 'YYYY-MM-DD HH24:MI:SS') FROM TESTTIME;
-- �츮�� ���ϴ� ���� 'YYYY-MM-DD HH24:MI:SS' ���� ����ϰ� �����
-------------------------------------------------------------------------------------

-- 5.6 NULL�� �ٸ� ������ ��ȯ�ϴ� NVL �Լ�
SELECT ENAME, SAL, COMM, SAL*12+COMM, NVL(COMM,0), SAL*12+NVL(COMM,0)
FROM EMP;


-- 5.7 ������ ���� DECODE �Լ� : �ڹ��� switch ���� ���� ����
SELECT * FROM EMP;
SELECT * FROM DEPT;
SELECT ENAME, DEPTNO, DECODE(DEPTNO, 10, 'ACCOUNT',
                                     20, 'RESEARCH',
                                     30, 'SALES',
                                     40, 'OPERATIONS') AS DNAME
FROM EMP;                                  
-- DEPTNO �� 10�̸� ACCOUNT��, 20�̸� RESEARCH�� 30�̸� SALES��, 40�̸� OPERATIONS�� ����ض�


-- 5.8 CASE WHEN �Լ� : �ڹٿ����� if-else ���� ���� ����
SELECT ENAME, DEPTNO, CASE WHEN DEPTNO=10 THEN 'ACCOUNTING'
                           WHEN DEPTNO=20 THEN 'RESEARCH'
                           WHEN DEPTNO=30 THEN 'SALES'
                           WHEN DEPTNO=40 THEN 'OPERATIONS'
                           END AS DNAME
FROM EMP;






-- 5�� ���� (05-01 ���� 1~4��)

--1.
SELECT HIREDATE, TO_CHAR(HIREDATE, 'YYYY/MM/DD') FROM EMP;

--2.
SELECT MGR, CASE WHEN MRG=NULL THEN 'CEO' END AS DNAME FROM EMP;

SELECT MGR, DECODE(MGR, NULL, 'CEO') AS DNAME
FROM EMP;

--SELECT * FROM EMP WHERE MGR IS NULL, CASE THEN 'CEO' END FROM DUAL;
SELECT ENAME, MGR, DECODE(MGR, NULL, 'CEO') AS DNAME FROM EMP;
INSERT INTO EMP VALUES(7839, 'KING', 'PRESIDENT', NULL, '81/11/17',5000, NULL, 10); 
SELECT ENAME, NVL(TO_CHAR(MGR), 'CEO') AS MGR FROM EMP;
SELECT * FROM EMP;





