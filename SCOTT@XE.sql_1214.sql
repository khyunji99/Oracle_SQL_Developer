-- ���� �ð� ����
-- ����ȯ �Լ� : TO_NUMBER, TO_CHAR, TO_DATE
-- 1. ** DATE -> VARCHAR2 (��¥ -> ����)
SELECT SYSDATE FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') FROM DUAL;

-- 2. NUMBER->VARCHAR2 (���� -> ����), �츮�� ���ϴ� �������� ��ȯ���ش�,,
SELECT ENAME, SAL FROM EMP;
SELECT ENAME, TO_CHAR(SAL, 'L999,999') FROM EMP; -- LOCALE (L) : �ý��ۿ� �����Ǿ� �ִ� OS�� ����� ��� ����,,,?

-- 3. ** NUMBER -> DATE (���� -> ��¥)
SELECT ENAME, HIREDATE FROM EMP;
SELECT ENAME, HIREDATE FROM EMP
--WHERE HIREDATE='1981/02/20'; -- ���ڷ� ã��
--WHERE HIREDATE=19810220; -- �̷��� ���ڷ� ã�� �� ����.
WHERE HIREDATE = TO_DATE(19810220, 'YYYYMMDD');

-- 4. VARCHAR2 -> NUMBER (���� -> ����)
SELECT TO_NUMBER('20,000', '99,999') FROM DUAL;
SELECT TO_NUMBER('20,000', '99,999') - TO_NUMBER('10,000', '99,999') FROM DUAL;
-- ���� 20,000 �� ���ڷ� ��ȯ, 10,000 ���ڸ� ���ڷ� ��ȯ�ؼ� ���ڳ��� �� �� ���




--06. �׷� ������ ���� ������

--6-1. �⺻ ���� �Լ�
--6-1-1. SUM �Լ� : �հ� ���ϱ�
SELECT SUM(SAL) FROM EMP;
SELECT SUM(COMM) FROM EMP; -- SUM �Լ��� NULL�� �����ϰ� �հ��Ѵ�.


--6-1-2. AVG �Լ� : ��� ���ϱ�
SELECT AVG(SAL) FROM EMP;
SELECT AVG(COMM) FROM EMP; -- AVG �Լ��� NULL�� �����ϰ� ����Ѵ�.


--6-1-3. MAX, MIN �Լ� : �ִ�, �ּ� ���ϱ�
SELECT MAX(SAL), MIN(SAL) FROM EMP;
SELECT SAL FROM EMP;
SELECT MAX(COMM), MIN(COMM) FROM EMP;

SELECT ENAME, MAX(SAL) FROM EMP;
-- ENAME�� ���� 14���ε� MAX(SAL) ���� �ϳ��� ������ �߻��Ѵ�. ����) ORA-00937: not a single-group group function
-- �̿� ���� �׷� �Լ��� �������� ���� ������ �÷��� ���� ����� �� ����.

--6-1-4.COUNT : �ο�(ROW) ���� ���ϱ�, NULL�� ������ �����ϰ� ����Ѵ�.
SELECT COUNT(*), COUNT(COMM) FROM EMP;
SELECT COUNT(JOB) ������ FROM EMP; -- �ߺ��� �� �����Ͽ� ������ ���ȴ�.
SELECT COUNT(DISTINCT JOB) ������ FROM EMP; -- DISTINCT ���༭ �ߺ��� �� �����ϰ� ������ ���ǰ� �Ѵ�.



-- GROUP BY �� : �׷��� --> ���, �հ�, �ִ밪 ���� ���� �� �ִ�..
SELECT DEPTNO
FROM EMP;

SELECT DEPTNO
FROM EMP
GROUP BY DEPTNO;

SELECT DEPTNO, AVG(SAL)
FROM EMP
GROUP BY DEPTNO;

SELECT DEPTNO, MAX(SAL), MIN(SAL)
FROM EMP
WHERE SAL>=800
GROUP BY DEPTNO
ORDER BY DEPTNO ASC;


-- HAVING �� : GROUP �� ������ �ش�.
SELECT DEPTNO, AVG(SAL)
FROM EMP
WHERE SAL>=800
GROUP BY DEPTNO;

SELECT DEPTNO, AVG(SAL)
FROM EMP
WHERE SAL>=800          -- FROM�� ���� ����
GROUP BY DEPTNO
HAVING AVG(SAL) >= 2000 -- ��ü �׷����� �Ϳ� ���� ������ �ذ��̴�..?
ORDER BY DEPTNO ASC;
-- WHERE, HAVING, ORDER BY ������ ���� �����ϴ�.


------------------------------------------------------------------

-- ���� ������
--1. UNION : ������

DROP TABLE EXP_GOODS_ASIA;

CREATE TABLE EXP_GOODS_ASIA (
    COUNTRY VARCHAR2(10),
    SEQ NUMBER,
    GOODS VARCHAR2(80)
);
DESC EXP_GOODS_ASIA;
 
INSERT INTO EXP_GOODS_ASIA VALUES ('�ѱ�', 1, '�������� ������');
INSERT INTO EXP_GOODS_ASIA VALUES ('�ѱ�', 2, '�ڵ���');
INSERT INTO EXP_GOODS_ASIA VALUES ('�ѱ�', 3, '��������ȸ��');
INSERT INTO EXP_GOODS_ASIA VALUES ('�ѱ�', 4, '����');
INSERT INTO EXP_GOODS_ASIA VALUES ('�ѱ�', 5, 'LCD');
INSERT INTO EXP_GOODS_ASIA VALUES ('�ѱ�', 6, '�ڵ�����ǰ');
INSERT INTO EXP_GOODS_ASIA VALUES ('�ѱ�', 7, '�޴���ȭ');
INSERT INTO EXP_GOODS_ASIA VALUES ('�ѱ�', 8, 'ȯ��źȭ����');
INSERT INTO EXP_GOODS_ASIA VALUES ('�ѱ�', 9, '�����۽ű� ���÷��� �μ�ǰ');
INSERT INTO EXP_GOODS_ASIA VALUES ('�ѱ�', 10, 'ö �Ǵ� ���ձݰ�');
INSERT INTO EXP_GOODS_ASIA VALUES ('�Ϻ�', 1, '�ڵ���');
INSERT INTO EXP_GOODS_ASIA VALUES ('�Ϻ�', 2, '�ڵ�����ǰ');
INSERT INTO EXP_GOODS_ASIA VALUES ('�Ϻ�', 3, '��������ȸ��');
INSERT INTO EXP_GOODS_ASIA VALUES ('�Ϻ�', 4, '����');
INSERT INTO EXP_GOODS_ASIA VALUES ('�Ϻ�', 5, '�ݵ�ü������');
INSERT INTO EXP_GOODS_ASIA VALUES ('�Ϻ�', 6, 'ȭ����');
INSERT INTO EXP_GOODS_ASIA VALUES ('�Ϻ�', 7, '�������� ������');
INSERT INTO EXP_GOODS_ASIA VALUES ('�Ϻ�', 8, '�Ǽ����');
INSERT INTO EXP_GOODS_ASIA VALUES ('�Ϻ�', 9, '���̿���, Ʈ��������');
INSERT INTO EXP_GOODS_ASIA VALUES ('�Ϻ�', 10, '����');

COMMIT;

SELECT COUNT(*) FROM EXP_GOODS_ASIA;

SELECT GOODS
FROM EXP_GOODS_ASIA
WHERE COUNTRY = '�ѱ�'
ORDER BY SEQ;
-- �ѱ��� GOODS �÷� ���� ��µ�

SELECT GOODS
FROM EXP_GOODS_ASIA
WHERE COUNTRY = '�Ϻ�'
ORDER BY SEQ; -- ASC �� �����Ǿ� �־� SEQ �÷��� ��������

-- UNION : �ѱ��� �Ϻ��� GOODS �� 5���� ��ġ�� 5���� �Ȱ�ģ��. ��ġ�� ������ ������ �������� ����Ѵ�.
-- �ѱ� 10��, �Ϻ� 10������ �� 20���� ���;��ϴµ� ��ġ�°� 5���̴� �װ� �� 15���� ��µȴ�.
SELECT GOODS
FROM EXP_GOODS_ASIA
WHERE COUNTRY = '�ѱ�'
UNION
SELECT GOODS
FROM EXP_GOODS_ASIA
WHERE COUNTRY = '�Ϻ�';

-- UNION ALL : ��ġ�°� �����ؼ� �� ��µȴ�. ��� 20���� �� ��µȴ�.
SELECT GOODS
FROM EXP_GOODS_ASIA
WHERE COUNTRY = '�ѱ�'
UNION ALL
SELECT GOODS
FROM EXP_GOODS_ASIA
WHERE COUNTRY = '�Ϻ�';


-- INTERSECT : ������, ��ġ�� �κ��� ��µȴ�.
SELECT GOODS
FROM EXP_GOODS_ASIA
WHERE COUNTRY = '�ѱ�'
INTERSECT
SELECT GOODS
FROM EXP_GOODS_ASIA
WHERE COUNTRY = '�Ϻ�';



-- MINUS : ������ (A-B �� B-A �� �ٸ� ������ �Ʒ��� �� ����� �ٸ���!)
SELECT GOODS
FROM EXP_GOODS_ASIA
WHERE COUNTRY = '�ѱ�'
MINUS
SELECT GOODS
FROM EXP_GOODS_ASIA
WHERE COUNTRY = '�Ϻ�';

-- ���� ����� �ٸ��� ���´� --
SELECT GOODS
FROM EXP_GOODS_ASIA
WHERE COUNTRY = '�Ϻ�'
MINUS
SELECT GOODS
FROM EXP_GOODS_ASIA
WHERE COUNTRY = '�ѱ�';



---------------------------------------------------------------------------
-- 07. ���� (JOIN)
SELECT * FROM EMP; -- �μ���ȣ�� �� �� �ְ� �μ����� DEPT ���̺��� �� �� �ִ�.
SELECT * FROM DEPT;
-- �� ���� ���̺��� �����ϸ� � ����� � �μ������� �� �� �ִ�.

-- JOIN ������ ���ϰ� SMITH�� ��� �μ��� �ִ��� �˷��� �� �� �ι��� �ڵ带 ���ľ� �Ѵ�.
SELECT DEPTNO FROM EMP
WHERE ENAME='SMITH';

SELECT DNAME FROM DEPT
WHERE DEPTNO=20;

-- ������ �ϸ� �ڵ带 �ѹ��� ��� ���� ���ϴ°� �˾Ƴ� �� �ִ�. 
SELECT EMP.ENAME, DEPT.DNAME
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO AND
EMP.ENAME = 'SMITH';


SELECT *
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO AND
EMP.ENAME = 'SMITH';
-- DEPTNO_1, DNAME, LOC �� DEPT ���̺� �ִ� �÷�, �׿� �������� EMP ���̺� �ִ� �͵�

-- ������ ����
--1. ORACLE CROSS JOIN
SELECT *
FROM EMP, DEPT;
-- �ΰ��� ���̺� EMP(14��), DEPT(4��) ���� ��� �÷�(14*4=56���� �÷�)�� �����´�.

--SELECT * FROM DEPT;
--COMMIT;
--DELETE FROM DEPT
--WHERE DEPTNO=50;


--2. ORACLE EQUI JOIN
SELECT *
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO;

SELECT ENAME, DNAME
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO
AND ENAME='SCOTT';

SELECT ENAME, DNAME, DEPTNO
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO
AND ENAME='SCOTT';
-- ���� �߻�) ORA-00918: column ambiguously defined
-- DEPTNO�� EMP ���̺��� DEPT ���̺��� �������� �ִ�.
-- �׷��� DEPTNO �� ��������� �� �ڵ忡�� � ���̺� �ִ� DEPTNO�� �������°���
-- ��ȣ�ؼ� ������ �߻��� ��! --> ��Ȯ�ϰ� ��� ���̺��� ���������� �����ָ� �ذ�

SELECT EMP.ENAME, DEPT.DNAME, DEPT.DEPTNO
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO
AND ENAME='SCOTT';

-- �̷��� ��Ȯ�ϰ� ��� ���̺��� ���������� �� �����ִٺ���
-- ���� ���̺� �̸��� ���,, �ʹ� �����!! �׷��� ������ ��Ī�� �ο����༭ ������ �ξ� �����ϰ� ���� �� �ִ�.
SELECT E.ENAME, D.DNAME, D.DEPTNO
FROM EMP E, DEPT D  -- ��Ī �ο�����
WHERE E.DEPTNO = D.DEPTNO
AND ENAME='SCOTT';





-- ����
-- 07-01 ��������
SELECT * FROM EMP;
SELECT * FROM DEPT;

SELECT *
FROM EMP, DEPT;

--07-01-01
SELECT E.ENAME, E.SAL
FROM EMP E, DEPT D
WHERE D.LOC='NEW YORK';

--07-01-02
SELECT E.ENAME, E.HIREDATE
FROM EMP E, DEPT D
WHERE E.DEPTNO=D.DEPTNO
AND D.DNAME='ACCOUNTING';

--07-01-03
SELECT E.ENAME, D.DNAME
FROM EMP E, DEPT D
WHERE E.DEPTNO=D.DEPTNO
AND E.JOB='MANAGER';



-- 7-4.Non-Equi Join
SELECT * FROM SALGRADE;
-- ������ 1~5���� �ִ�.

SELECT E.ENAME, E.SAL, S.GRADE
FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL;
-- SAL ������ LOSAL�� HISAL�� �ִ� ENAME, SAL, GRADE ���


SELECT E.ENAME, E.SAL, S.GRADE
FROM EMP E, SALGRADE S
WHERE E.SAL >= S.LOSAL AND E.SAL <= S.HISAL;
--WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL; ó�� BETWEEN ��� ��ó�� �񱳿����ڷ� ����� �� �� �ִ�.
-- �� ó�� = ������ ���� >=, <= �� �̷��� �� �����ڵ� ���� �� �ִ�.


-- SELF JOIN
SELECT EMPNO, ENAME, MGR FROM EMP;

SELECT E.ENAME AS "�����", M.ENAME "����"
FROM EMP E, EMP M
WHERE E.MGR = M.EMPNO;
-- MGR = ����ȣ
-- EMPNO = ���

SELECT E.ENAME AS "�����", M.ENAME "����"
FROM EMP E, EMP M
WHERE E.MGR = M.EMPNO;


--07-03 ��������

--07-03-01
SELECT * FROM EMP;
SELECT * FROM DEPT;

SELECT E.ENAME AS "�����", M.ENAME "�Ŵ���", E.JOB "����"
FROM EMP E, EMP M
WHERE E.MGR = M.EMPNO
AND M.ENAME='KING';


SELECT E.ENAME, E.JOB
FROM EMP E, EMP M
WHERE E.MGR = M.EMPNO
AND M.ENAME = 'KING';



-- 07-03-02
SELECT E.ENAME, D.LOC
FROM DEPT D, EMP E
WHERE E.DEPTNO=D.DEPTNO
AND E.DEPTNO=20;

SELECT E.ENAME �̸�, C.ENAME ����
FROM EMP E, EMP C
WHERE E.DEPTNO = C.DEPTNO
AND E.ENAME = 'SCOTT'
AND C.ENAME <> 'SCOTT'
ORDER BY C.ENAME ASC;

SELECT *
FROM EMP E, EMP C
WHERE E.DEPTNO = C.DEPTNO
AND E.ENAME = 'SCOTT';
-- SCOTT�� ���� C ���� �̸� ENAME_1 �����ؼ� �������� ��µ�

SELECT C.ENAME
FROM EMP E, EMP C
WHERE E.DEPTNO = C.DEPTNO
AND E.ENAME = 'SCOTT'
AND C.ENAME <> 'SCOTT'  -- ���� C�� �̸����� SCOTT�� �̸� ����
ORDER BY C.ENAME ASC;
-- SCOTT�� ���� �ٹ������� ���ϴ� ������� �̸��� ������������ �����Ͽ� ��µ�
-- �̶� ������ ���� SCOTT�� ����� �̸��� ����ؾ� �ϴ� ���̹Ƿ� SCOTT�� �̸��� ������Ѵ�!!

SELECT * FROM EMP;

SELECT * FROM DEPT;




-- 7-6. Outer Join : ���� ���ǿ� �������� ���ϴ��� �ش� �ο츦 ��Ÿ������ �� �� ���
SELECT E.ENAME, M.ENAME
FROM EMP E, EMP M
WHERE E.MGR = M.EMPNO;
-- ENAME : ����̸� / ENAME_1 : ����̸�
-- KING �� ���� ���� ���� KING�� ���� ����! ��, NULL�̶�
-- KING�� ������� �ȳ�Ÿ����.
-- �׷� �� KING�� ���⿡ ���� ���ǿ� �������� �������� KING�� ���� ����ϰ� �ͤ���!! -> Outer Join ���

-- Outer Join ���
SELECT E.ENAME, M.ENAME
FROM EMP E, EMP M
WHERE E.MGR = M.EMPNO(+);



-- ANSI CROSS JOIN = ORACLE CROSS JOIN
-- ORACLE CROSS JOIN (����Ŭ������ ��밡��)
SELECT *
FROM EMP, DEPT;

-- ANSI CROSS JOIN (�ٸ� �����ͺ��̽� ex. mysql ��... ������ ��� ����)
SELECT *
FROM EMP CROSS JOIN DEPT;


-- ANSI INNER JOIN = ORACLE EQUI JOIN
-- ORACLE EQUI JOIN
SELECT E.ENAME, D.DNAME
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO;


-- ANSI INNER JOIN : , ��� INNER JOIN ����ϰ� WHERE ��� ON ����� �׷��� ON ��� USING�� ����� ���� ����
SELECT E.ENAME, D.DNAME
FROM EMP E INNER JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;

-- USING ���
SELECT E.ENAME, D.DNAME
FROM EMP E INNER JOIN DEPT D
USING(DEPTNO);


-- ANSI NATURAL JOIN : ���� �̸����� �����ϴ°Ŵϱ� �̸��� ���� �� ���� ���ν��� �ִ� ��
SELECT E.ENAME, D.DNAME
FROM EMP E NATURAL JOIN DEPT D;
-- ������ ��� ���� DEPTNO���� ���ν����ش�! NATURAL ¯ �̱�,,,



-- ANSI OUTER JOIN
DROP TABLE DEPT01;

CREATE TABLE DEPT01(
 DEPTNO NUMBER(2),
 DNAME VARCHAR2(14)
);

INSERT INTO DEPT01 VALUES(10,'ACCOUNTING');
INSERT INTO DEPT01 VALUES(20,'RESEARCH');
SELECT * FROM DEPT01;
-- DEPT01���� DEPTNO=10, 20 �� �ֵ��� ����ִ�

DROP TABLE DEPT02;

CREATE TABLE DEPT02(
 DEPTNO NUMBER(2),
 DNAME VARCHAR2(14)
);

INSERT INTO DEPT02 VALUES(10,'ACCOUNTING');
INSERT INTO DEPT02 VALUES(30,'SALES');
SELECT * FROM DEPT02;
-- DEPT02���� DEPTNO=10, 30 �� �ֵ��� ����ִ�

-- ANSI Left Outer Join
SELECT *
FROM DEPT01 LEFT OUTER JOIN DEPT02
ON DEPT01.DEPTNO = DEPT02.DEPTNO;
-- ���ʿ� �ִ� DEPT01�� �߽����� DEPT02�� ������ �͵��� ���´�,,?
-- DEPT01�� �߽����� DEPT01���� DEPTNO=10,20�� �ֵ��� �ִ�
-- �׷��� DEPT02���� DEPTNO=10�� ������ DEPTNO = 20�� ���
-- DEPTNO=20�� �Ϳ� ���ؼ��� �׳� NULL ������ ���´�.

-- ANSI Right Outer Join
SELECT *
FROM DEPT01 RIGHT OUTER JOIN DEPT02
USING(DEPTNO);
-- �����ʿ� �ִ� DEPT02�� �߽����� ���� DEPT01�� ���� ���� ���´�,,?
-- DEPT02���� DEPTNO=10,30�� �ֵ��� �ִ�.
-- �׷��� ������ DEPT02�� ���� DEPTNO =10, 30�� ���ؼ� ��µɰ��̴�.
-- �׷��� DEPT01���� DETPNO=10�� ������ DEPTNO=30�� ����
-- �׷��� DEPTNO=30 �� ���ؼ��� DNAME�� NULL�� ���� ���̴�.
-- DEPTNO �� DEPT02�� �����̹Ƿ� 10�� 30�� ���
-- DNAME �� DEPT01�� ���� �� ���
-- DNAME_1 �� DEPT02�� ���� �� ���
-- DEPT02�� DEPTNO 10�� 30�� ���� DNAME ���� �����Ƿ� �� �ش��ϴ� �� ���
-- DEPT01�� DEPTNO 10�� ���� �� ACCOUNTING �� ������ DEPTNO 30�� ���� DNAME ���� �����Ƿ� NULL�� ����


-- Full Outer Join
SELECT *
FROM DEPT01 FULL OUTER JOIN DEPT02
USING(DEPTNO);
-- ���ΰ��� ������ �͵��� �� ������!!
-- DEPT01���� DEPTNO= 30 �� �ְ� ����, DEPT02���� DEPTNO=20�� �ְ� ����
-- ��� �� �����ؼ� �����




-- 07-02 ��������
-- 07-02-01.������ MANAGER�� ����� �̸�, �μ��� ���
-- ORACLE EQUI JOIN, ANSI INNER JOIN, ANSI NATURAL JOIN ���
-- ORACLE EQUI JOIN : ���������� �����ϴ� �÷� ���
-- SELECT * FROM EMP, DEPT WHERE EMP.DEPTNO = DEPT.DEPTNO;
-- ANSI INNER JOIN : , ��� INNER JOIN ����ؼ�
-- SELECT ENAME, DNAME FROM EMP, DEPT WHERE EMP.DEPTNO=DEPT.DEPTNO;
-- ANSI NATURAL JOIN : �ڵ������� ��� �÷��� ������� ���� �÷��� �����Ͽ� ���������� ���ι� ����
-- SELECT EMP.ENAME, DEPT.DNAME FROM EMP NATURAL JOIN DEPT;

-- ORACLE EQUI JOIN
SELECT E.ENAME, D.DNAME
FROM EMP E, DEPT D
WHERE E.DEPTNO=D.DEPTNO
AND E.JOB='MANAGER';

-- ANSI INNER JOIN
SELECT E.ENAME, D.DNAME
FROM EMP E INNER JOIN DEPT D
ON E.DEPTNO=D.DEPTNO
AND E.JOB='MANAGER';

-- ANSI NATURAL JOIN
SELECT E.ENAME, D.DNAME
FROM EMP E NATURAL JOIN DEPT D
WHERE E.JOB='MANAGER';


SELECT * FROM EMP;

--07-02-02. SMITH�� ������ ����(JOB�÷�)�� ���� ����� �̸��� ������ ����ϴ� SQL��
SELECT C.ENAME, C.JOB
FROM EMP E, EMP C
WHERE E.ENAME='SMITH'
AND E.JOB=C.JOB
AND C.ENAME<>'SMITH';

