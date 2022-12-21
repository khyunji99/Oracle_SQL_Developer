SHOW USER

SELECT * FROM DUAL;
SELECT * FROM SYS.DUAL;
-- ������ �̷��� ��Ű���̸�.�����Ұ�ü �̷��� �ڵ带 ������ϴµ�
-- ������ó�� �׳� �����Ұ�ü �̸��� ��� ������ �� ���� �ִ�.
-- �� DUAL�� ���� ���Ǿ�� �����Ǿ� �־ ������ DUAL�� ��� �����Ҽ��� �ִ� ���̴�.


SELECT * FROM SYSTBL; -- ��� �ȵ�,,
SELECT * FROM SYSTEM.SYSTBL;  -- ������ �� �ִ� ������ ���� ������ ���� �Ұ����ؼ� �ƹ��͵� �ȳ��´�.. ����������
-- ���� �ο��ް� ���� �ٽ� �����غ��� ��µȴ�.
-- ������ SYSTEM �� �ٿ��� SYSTBL�� ������� ������ �ȴ�! �׳� SYSTBL�� ��� �����Ϸ��� �ϸ� ������ �ȵȴ�!

-- ���Ǿ� �����ϱ�
CREATE SYNONYM SYSTBL FOR SYSTEM.SYSTBL;
-- SYSTEM �������� SCOTT �������� CREATE SYNONYM ������ �ο����ְ� ����
-- ���� �ڵ�ó�� SYSTEM.SYSTBL�� ���� ���Ǿ� SYSTBL�� ���� �� �ְ� �Ǿ���.
-- CREATE SYNONYM �ϰ� �ٽ� SELECT * FROM SYSTBL;�� �ϴ� ������ ������ �ȴ�!






-------------------------------------------------------------------------------------------------------------------------------------
-- 20. PL/SQL : Procedural Language extension to SQL
SET SERVEROUTPUT ON  -- ������ִ� ������ ȭ�鿡 �����ֵ��� �����ϴ� ��
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO WORLD'); -- OUTPUT ��� ��Ű���� ����ǰ� PUT_LINE ��� PRINT �Լ� ������(������ִ� �Լ�)�� �����ϸ� ���� �����ϱ� ����,,,
END;
/

-- 2. ��������� ���Թ�
-- ���� ����ϱ�
SET SERVEROUTPUT ON
DECLARE -- ���� ����
    -- ����ο��� ������ �����Ѵ�.
    VEMPNO NUMBER(4);  -- , �ƴϰ� ; ����ؾ��Ѵ�.
    VENAME VARCHAR2(10);
BEGIN -- ���๮ �ۼ�
    -- ����ο����� ���๮�� �ۼ��Ѵ�.
    VEMPNO := 7788;
    VENAME := 'SCOTT';
    DBMS_OUTPUT.PUT_LINE('��� / �̸�');
    DBMS_OUTPUT.PUT_LINE('-------------');
    DBMS_OUTPUT.PUT_LINE(VEMPNO || ' / ' || VENAME);
END;
/


-- ����� �̸� �˻��ϱ�
DECLARE
    VEMPNO EMP.EMPNO%TYPE;
    VENAME EMP.ENAME%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('��� / �̸�');
    DBMS_OUTPUT.PUT_LINE('--------------');
    
    SELECT EMPNO, ENAME INTO VEMPNO, VENAME  -- INTO �������ָ� �����߻���
    FROM EMP
    WHERE ENAME = 'SCOTT';
    
    DBMS_OUTPUT.PUT_LINE(VEMPNO || ' / ' || VENAME);
END;
/




-- ���̺� TYPE ���� ����ϱ�
SET SERVEROUTPUT ON
DECLARE
    -- ���̺� Ÿ���� ����
    TYPE ENAME_TABLE_TYPE IS TABLE OF EMP.ENAME%TYPE  -- ���̺� Ÿ�� �̸��� ENAME_TABLE_TYPE�̰� , EMP.ENAME�� ������Ÿ������ ���̺� Ÿ���� �����Ѵ�.
        INDEX BY BINARY_INTEGER; -- �ɼ�
    TYPE JOB_TABLE_TYPE IS TABLE OF EMP.JOB%TYPE
        INDEX BY BINARY_INTEGER;
        
    -- ���̺� Ÿ������ ���� �����ϱ�
    ENAME_TABLE ENAME_TABLE_TYPE;  -- ENAME_TABLE�� ENAME_TABLE�� Ÿ������ ������Ÿ���� �Ѵ�.
    JOB_TABLE JOB_TABLE_TYPE;  -- JOB_TABLE�� JOB_TABLE�� Ÿ������ ������Ÿ���� ������.
    
    I BINARY_INTEGER := 0;  -- I ������ BINARY_INTEGER(NUMBERŸ���̶� �ٸ�)Ÿ���̰� 0�� �����Ѵ�(0���� �ʱ�ȭ).
BEGIN
    FOR K IN (SELECT ENAME, JOB FROM EMP) LOOP -- SELECT ENAME, JOB FROM EMP�� ����� K ������ ��� ���̴�,,
        I := I + 1; -- I�� 1���� �����Ѵ�
        ENAME_TABLE(I) := K.ENAME; -- ENAME_TABLE�� I �ε����� K�� ENAME ���� �־��.
        JOB_TABLE(I) := K.JOB;
    END LOOP;
        
         FOR J IN 1.. I LOOP -- ... 3�� ������ ��� �ȵȴ�! .. 2���� ��������Ѵ�!
            DBMS_OUTPUT.PUT_LINE(RPAD(ENAME_TABLE(J), 12)  || ' / ' || RPAD(JOB_TABLE(J),9));
    END LOOP;
END;
/



-- ���ڵ� Ÿ�� ����ϱ�
DECLARE
    -- ���ڵ� Ÿ���� �����ϱ� : �ڹ��� Ŭ���� Ÿ��(�ٸ� Ÿ���� �ʵ带 ����)�� ���� ����
    TYPE EMP_RECORD_TYPE IS RECORD(
        V_EMPNO EMP.EMPNO%TYPE,
        V_ENAME  EMP.ENAME%TYPE,
        V_JOB      EMP.JOB%TYPE,
        V_DEPTNO EMP.DEPTNO%TYPE);
        
    -- ���ڵ� Ÿ������ ���� �����ϱ�
    EMP_RECORD EMP_RECORD_TYPE;  -- EMP_RECORD ������ EMP_RECORD Ÿ���̴�.
BEGIN
    SELECT EMPNO, ENAME, JOB, DEPTNO INTO EMP_RECORD -- INTO EMP_RECORD �ڵ忡 ����� ����� ��...
    FROM EMP
    WHERE ENAME = UPPER('SCOTT');
    
    DBMS_OUTPUT.PUT_LINE('�����ȣ : ' || TO_CHAR(EMP_RECORD.V_EMPNO) ); -- V.EMPNO�� EMP.EMPNO�� Ÿ���̴�. ��, NUMBER Ÿ���̶� �װ� TO_CHAR Ÿ������ ��ȯ������ ��
    DBMS_OUTPUT.PUT_LINE('��     �� : ' || EMP_RECORD.V_ENAME);
    DBMS_OUTPUT.PUT_LINE('������ : ' || EMP_RECORD.V_JOB);
    DBMS_OUTPUT.PUT_LINE('�μ���ȣ : ' || EMP_RECORD.V_DEPTNO);
END;
/

-- BEGIN �ȿ� �ִ� ���๮�� ���� �����غ���
SELECT EMPNO, ENAME, JOB, DEPTNO --INTO EMP_RECORD -- INTO EMP_RECORD �ڵ忡 ����� ����� ��...
    FROM EMP
    WHERE ENAME = UPPER('SCOTT');


-- �μ� ��ȣ�� �μ��� �˾Ƴ���
-- IF ~ THEN ~ END IF
DECLARE
       VEMPNO NUMBER(4);
       VENAME VARCHAR2(20);
       VDEPTNO EMP.DEPTNO%TYPE;
       VDNAME VARCHAR2(20) := NULL; -- ���� ����� ���ÿ� NULL �� �־��ֱ�
BEGIN
       SELECT EMPNO, ENAME, DEPTNO INTO VEMPNO, VENAME, VDEPTNO
       FROM EMP
       WHERE EMPNO=7788;
       
       IF (VDEPTNO = 10) THEN
           VDNAME := 'ACCOUNTING';
       END IF;
       IF (VDEPTNO = 20) THEN
           VDNAME := 'RESEARCH';
       END IF;
       IF (VDEPTNO = 30) THEN
           VDNAME := 'SALES';
       END IF;
       IF (VDEPTNO = 40) THEN
           VDNAME := 'OPERATIONS';
       END IF;
       
       DBMS_OUTPUT.PUT_LINE('���      �̸�       �μ���');
       DBMS_OUTPUT.PUT_LINE(VEMPNO || '     ' || VENAME || '    ' || VDNAME);
       
END;
/




-- IF ~ THEN ~ ELSEIF~ ELSE ~ END IF
DECLARE
    VEMP EMP%ROWTYPE;  -- ���ڵ� Ÿ�� (�ϳ��� ROW�� �����ͼ� �װ͵��� ������ Į������ ������Ÿ�Ե� VEMP�� ������Ÿ������ ����ϰڴ�.
    VDNAME VARCHAR2(14);
BEGIN
    DBMS_OUTPUT.PUT_LINE('��� / �̸� / �μ���');
    DBMS_OUTPUT.PUT_LINE('------------------------------');
    
    SELECT * INTO VEMP
    FROM EMP
    WHERE ENAME='SCOTT';
    
    IF (VEMP.DEPTNO = 10) THEN
        VDNAME := 'ACCOUNTING';
    ELSIF (VEMP.DEPTNO = 20) THEN
        VDNAME := 'RESEARCH';
    ELSIF (VEMP.DEPTNO = 30) THEN
        VDNAME := 'SALES';
    ELSE
        VDNAME := 'OPERATIONS';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(VEMP.EMPNO || ' / ' || VEMP.ENAME || ' / ' || VDNAME);
    
END;
/



-- BASIC LOOP�� : LOOP ~ END LOOP
DECLARE
    N NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N + 1;
        IF N > 5 THEN
            EXIT;
        END IF;
    END LOOP;
END;
/


-- FOR LOOP
DECLARE
BEGIN
    FOR N IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE(N);
    END LOOP;
END;
/



-- WHILE LOOP��
DECLARE
    N NUMBER := 1;
BEGIN
    WHILE N <= 5 LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N + 1;
    END LOOP;
END;
/


----------------------------------------------------------------------------------------------

-- 21��.
-- 21-01-01.���� ���ν���(STORED PROCEDURE) �����ϴ� ���
DROP TABLE EMP01;

CREATE TABLE EMP01
AS
SELECT * FROM EMP;

SELECT * FROM EMP01;

-- ���ν��� ����
CREATE OR REPLACE PROCEDURE DEL_ALL
IS
BEGIN
    DELETE FROM EMP01;
END;  -- ������ �ƴ϶� ������ �Ǿ��ٰ� ���´�! DELETE �ϱ� ������ ���� SELECT EMP01 �غ��� ������ ���� �ִ�.
/

-- �Ʒ��� �ڵ带 �����ؾ� EMP01 ���̺��� DELETE �Ǿ �����Ͱ� �� ������� �ȴ�. �̰� ����Ȱ���,,
EXECUTE DEL_ALL;




-- ���� ���ν��� ��ȸ�ϱ�
SELECT NAME, TEXT FROM USER_SOURCE;
-- �츮�� ���� ���ν����� ��µȴ�.


-- �Ű����� ���� ���ν���
DROP TABLE EMP01;

CREATE TABLE EMP01
AS
SELECT * FROM EMP;

SELECT * FROM EMP01;

-- VENAME �̶�� �Ű������� �ְ� �� �Ű������� ������Ÿ���� EMP01�� ENAMEĮ���� ������Ÿ������ �����ߴ�.
CREATE OR REPLACE PROCEDURE DEL_ENAME(VENAME EMP01.ENAME%TYPE)
IS
BEGIN
    DELETE FROM EMP01
    WHERE ENAME = VENAME;  -- ENAME�� �Ű������� ���� VENAME �� �ش��ϴ� �����͵��� EMP01 ���̺��� ������ 
END;
/

SELECT * FROM EMP01;

EXECUTE DEL_ENAME('SMITH'); -- �̰� �����ϰ� �ٽ� SELECT * FROM EMP01 �غ��� SMITH �����..



-- IN, OUT, INOUT �Ű�����
DROP PROCEDURE SEL_EMPNO;

-- �Ű������� 4�� VEMPNO, VENAME, VSAL, VJOB �� ���ν���
-- IN �� ������ �Է¹޴� ��, OUT�� ����� ������� �޾ư��� ��
CREATE OR REPLACE PROCEDURE SEL_EMPNO (
    VEMPNO IN EMP.EMPNO%TYPE,
    VENAME OUT EMP.ENAME%TYPE,
    VSAL OUT EMP.SAL%TYPE,
    VJOB OUT EMP.JOB%TYPE
)
IS
BEGIN
    SELECT ENAME, SAL, JOB INTO VENAME, VSAL, VJOB
    FROM EMP
    WHERE EMPNO=VEMPNO;
END;
/

-- ���ε� ����
-- ' : ' �� ���ٿ��ִ� ������ �̸� ����Ǿ� �־�� �Ѵ�.
VARIABLE VAR_ENAME VARCHAR2(15);
VARIABLE VAR_SAL NUMBER;
VARIABLE VAR_JOB VARCHAR2(9);

-- OUT �Ű��������� ���� �޾ƿ��� ���ؼ��� ���ν��� ȣ�� �� ���� �տ� ' : ' �� �����δ�.
EXECUTE SEL_EMPNO(7788, :VAR_ENAME, :VAR_SAL, :VAR_JOB);
-- :VAR_ENAME �� ����� ���� ���⿡ ��ڴٴ� ���̴�.

PRINT VAR_ENAME;
-- ������ ������ ������� ���� ���� :VAR_ENAME �� �ܼ�â�� ����ϴ� �ڵ� 
PRINT VAR_SAL;
PRINT VAR_JOB;

SELECT ENAME, SAL FROM EMP
WHERE EMPNO=7788;





-- ���� IN, OUT �Ű�����
-- SEL_EMPNAME ���ν��� �����ϱ�
-- EMP.ENAME �� ������ �޴� ���� �� ���� ������� JOB������ �޴� ����
-- �̷��� �ΰ��� ���� ������ ���ν��� ���� �ϱ�
DROP PROCEDURE SEL_EMPNAME;

-- ���ν��� ����
CREATE OR REPLACE PROCEDURE SEL_EMPNAME(
    VENAME IN EMP.ENAME%TYPE,
    VJOB OUT EMP.JOB%TYPE
)
IS
BEGIN --  ���๮ �ۼ�
    SELECT JOB INTO VJOB
    FROM EMP
    WHERE ENAME=VENAME;
    
END;
/

VARIABLE VAR_JOB VARCHAR2(9);

EXECUTE SEL_EMPNAME('SCOTT', :VAR_JOB);

PRINT VAR_JOB;







