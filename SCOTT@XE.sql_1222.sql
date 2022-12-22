-- 4. �����Լ� (stored function)
-- �ǽ� : �����Լ� �ۼ��ϱ�

CREATE OR REPLACE FUNCTION CAL_BONUS(VEMPNO IN EMP.EMPNO%TYPE)
    RETURN NUMBER -- �Ű����� �޾Ƽ� �Լ� �����ϰ� ���ϵǴ� ������Ÿ���� NUMBER�̴�.
IS
    VSAL NUMBER(7, 2);
BEGIN
    SELECT SAL INTO VSAL
    FROM EMP
    WHERE EMPNO = VEMPNO;
    
    RETURN (VSAL * 2);
END;
/

VARIABLE VAR_RES NUMBER;
-- NUMBER Ÿ���� ���� : VAR_RES
EXECUTE :VAR_RES :=CAL_BONUS(7788);
PRINT VAR_RES;


-- ���� : �����Լ� �����ϱ�
CREATE OR REPLACE FUNCTION SEL_EMPNAME02(VENAME IN EMP.ENAME%TYPE)
    RETURN VARCHAR2
IS
    VJOB VARCHAR2(9);
BEGIN
    SELECT JOB INTO VJOB
    FROM EMP
    WHERE ENAME = VENAME;
    
    RETURN VJOB;
END;
/

VARIABLE VAR_JOB VARCHAR2(9);
EXECUTE :VAR_JOB :=SEL_EMPNAME02('SCOTT');

PRINT VAR_JOB




-- 5. Ŀ��
-- CURSOR�� �̿��ؼ� �μ� ���̺��� ��� ������ ��ȸ�ϱ�
-- NOTFOUND : Ŀ�� ������ �ڷᰡ ��� FETCH �Ǹ� TRUE

SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE CURSOR_SAMPLE01
IS
    VDEPT DEPT%ROWTYPE;
    CURSOR C1 IS
        SELECT * FROM DEPT;
BEGIN
    DBMS_OUTPUT.PUT_LINE('�μ���ȣ / �μ��� / ������');
    DBMS_OUTPUT.PUT_LINE('--------------------------------');
    
    OPEN C1; 
    
    LOOP
        FETCH C1 INTO VDEPT.DEPTNO, VDEPT.DNAME, VDEPT.LOC;
        EXIT WHEN C1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(VDEPT.DEPTNO || '  ' || VDEPT.DNAME || '  ' || VDEPT.LOC);
    END LOOP;
    CLOSE C1;
END;
/


EXECUTE CURSOR_SAMPLE01;



-- CURSOR�� FOR LOOP ����ϴ� ���
CREATE OR REPLACE PROCEDURE CURSOR_SAMPLE02
IS
    VDEPT DEPT%ROWTYPE;
    CURSOR C1 IS
        SELECT * FROM DEPT;
BEGIN
    DBMS_OUTPUT.PUT_LINE('�μ���ȣ / �μ��� / ������');
    DBMS_OUTPUT.PUT_LINE('------------------------------');
    FOR VDEPT IN C1 LOOP
        EXIT WHEN C1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(VDEPT.DEPTNO || '  ' || VDEPT.DNAME || '  ' || VDEPT.LOC);
    END LOOP;
END;
/

EXECUTE CURSOR_SAMPLE02;



-- 6. Ʈ����


-- FOR EACH ROW�� ���� ����,,?
-- ���� DEPTNO=20�� ROW�� DEPTNO=10�� UPDATE�ض� ��� �Ŷ��
-- DEPTNO=20�� �ش��ϴ� ROW�� 5���̴�.

UPDATE EMP
SET DEPTNO=10
WHERE DEPRNO=20;

----CREATE TRIGGER T1
----    AFTER UPDATE ON EMP
--    FOR EACH ROW
--BEGIN
--    //���๮;
--END;
-- �������� �ش��ϴ� ROW�� �������� �� ������ ROW���� ��� �� ���๮�� ���� �������
-- ��� �� �ǹ��ϴ°� FOR EACH ROW �̴�.
-- FOR EACH ROW�� ������ �׳� �� 1���� ���๮�� �����Ű�� ���̴�.




-- �ǽ� : �ܼ� �޽����� ����ϴ� Ʈ���� �ۼ��ϱ�

-- 1. ��� ���̺� ����
DROP TABLE EMP01;

CREATE TABLE EMP01(
    EMPNO NUMBER(4) PRIMARY KEY,
    ENAME VARCHAR2(20),
    JOB VARCHAR2(20)
);

-- 2. Ʈ���� �ۼ�
-- EMP01 ���̺� INSERT �� ��(AFTER)�� ���๮�� �ѹ� �����ض�.
CREATE OR REPLACE TRIGGER TRG_01
    AFTER INSERT
    ON EMP01
BEGIN
    DBMS_OUTPUT.PUT_LINE('���Ի���� �Ի��߽��ϴ�.');
END;
/

-- 3. ��� ���̺� ������ �߰�
SET SERVEROUTPUT ON
INSERT INTO EMP01 VALUES(4, 'ȫ�浿', '���Ƿο��');
-- �����Ͱ� INSERT �Ǹ� Ʈ���ŷ� ���� '���Ի���� �Ի��߽��ϴ�', �� �ѹ� ��µȴ�.

SELECT * FROM EMP01;
-- �����Ͱ� �� �߰��� ���� Ȯ���� �� �ִ�.




-- �ǽ� : �޿� ������ �ڵ����� �߰��ϴ� Ʈ���� �ۼ��ϱ�
-- ��� ���̺� �����Ͱ� ������(���ο� ��� �߰�)
-- �޿� ���̺� ���ο� �����͸� �ڵ����� ����(���� �߰��� ����� �޿������� �ڵ� ����)�ϵ���,,
-- ��� ���̺� Ʈ���Ÿ� ������.

-- 1.�޿��� ������ ���̺��� �����Ѵ�.
DROP TABLE SAL01;

CREATE TABLE SAL01 (
    SALNO NUMBER(4) PRIMARY KEY,
    SAL NUMBER(7, 2),
    EMPNO NUMBER(4) REFERENCES EMP01(EMPNO)
);

-- 2. �޿���ȣ�� �ڵ� �����ϴ� �������� �����ϰ� �� �������κ��� �Ϸù�ȣ�� ��� �޿���ȣ�� �ο��Ѵ�.
CREATE SEQUENCE SAL01_SALNO_SEQ;
-- 1���� �����ؼ� 1�� �����ϴ� SEQUENCE�̴�.

-- 3. Ʈ���Ÿ� �����Ѵ�.
CREATE OR REPLACE TRIGGER TRG_02
    AFTER INSERT
    ON EMP01
    FOR EACH ROW
BEGIN
    INSERT INTO SAL01 VALUES ( SAL01_SALNO_SEQ.NEXTVAL, 100, :NEW.EMPNO );
END;
/
-- EMP01�� �����Ͱ� INSERT �� ��(AFTER)��  <-- �츮�� �ۼ��� Ʈ���� ����
-- SAL01���̺� ��(SALNO, �޿� 100, )�� INSERT �ض� ��� �ǹ��� Ʈ�����̴�.
-- :NEW.EMPNO  �� EMP01�� ���� ���� �Էµ� ROW(������) �߿� EMPNO�� �־�� ��� �ǹ�
-- :OLD �� ���� �Էµ� ������ ������ ROW(������)


-- 4. ��� ���̺� �ο츦 �߰��Ѵ�.
INSERT INTO EMP01 VALUES(2, '������', '���α׷���');
SELECT * FROM EMP01;
SELECT * FROM SAL01;
-- Ʈ���ſ� ���� EMP01�� �����͸� �߰��ߴ��� SAL01���̺� �ڵ����� ���� �߰��ȴ�.

INSERT INTO EMP01 VALUES(3, '������', '����');
SELECT * FROM EMP01;
SELECT * FROM SAL01;




-- �ǽ� : �޿� ������ �ڵ����� �����ϴ� Ʈ���� �ۼ��ϱ�
-- ����� ����(EMP01 ���̺��� ������ ����)�Ǹ�
-- �� ����� �޿� ������ �ڵ����� �����ǵ���
-- Ʈ���Ÿ� �ۼ��غ���.

SELECT * FROM EMP01;

-- 1. ��� ���̺��� �ο츦 �����Ѵ�.
DELETE FROM EMP01 WHERE EMPNO=2;
-- SQL Error(ORA-02292: integrity constraint (SCOTT.SYS_C007054) violated - child record found)�� �߻��Ѵ�.
-- SLA01 ���̺��� EMPNO Į���� �� �� EMPNO=2�� ���� EMP01�� EMPNO=2�� �����ϰ� �־
-- EMP01���� EMPNO=2�� ���� ���� ���� ����.
-- SAL01���� EMPNO=2�� �����͸� ����� ���� EMP01���̺��� EMPNO=2 �����͸� ����� �ȴ�.


-- 2. Ʈ���Ÿ� �ۼ��Ѵ�.
CREATE OR REPLACE TRIGGER TRG_03
    AFTER DELETE ON EMP01
    FOR EACH ROW
BEGIN
    DELETE FROM SAL01 WHERE EMPNO=:OLD.EMPNO;
    -- SLA01 ���̺��� EMPNO�� ������� �ϴ� EMPNO �ѹ� (:OLD.EMPNO) �� ������
END;
/


-- 3. ��� ���̺��� �ο츦 �����Ѵ�.
DELETE FROM EMP01 WHERE EMPNO=2;
SELECT * FROM EMP01;
SELECT * FROM SAL01;



--- ���� 21-02.
-- �μ� ��ȣ�� �����Ͽ� �ش� �μ� �Ҽ� ����� ������ ����ϴ� SEL_EMP ���ν����� Ŀ���� ����Ͽ� �ۼ��϶�.

-- FOR LOOP ����� �ƴҶ�
SELECT * FROM EMP;
-- EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO

CREATE OR REPLACE PROCEDURE SEL_EMP(VDEPTNO EMP.DEPTNO%TYPE)
IS
    VEMP EMP%ROWTYPE;
    CURSOR C1
    IS
    SELECT * FROM EMP
    WHERE DEPTNO = VDEPTNO;
BEGIN
    DBMS_OUTPUT.PUT_LINE('�����ȣ / ����� / ���� / �޿�');
    DBMS_OUTPUT.PUT_LINE('------------------------------------');
    
    OPEN C1;
    
    LOOP
        FETCH C1 INTO VEMP.EMPNO, VEMP.ENAME, VEMP.JOB, VEMP.MGR, VEMP.HIREDATE, VEMP.SAL, VEMP.COMM, VEMP.DEPTNO;
        
        EXIT WHEN C1%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(VEMP.EMPNO || '  ' || VEMP.ENAME || '  ' || VEMP.JOB || '  ' || VEMP.SAL);
    END LOOP;
    
    CLOSE C1;
END;
/


EXECUTE SEL_EMP(20);







-- FOR LOOP�� Ǯ���
SELECT * FROM EMP;
-- EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO

CREATE OR REPLACE PROCEDURE SEL_EMP(VDEPTNO EMP.DEPTNO%TYPE)
IS
    VEMP EMP%ROWTYPE;
    CURSOR C1
    IS
    SELECT * FROM EMP
    WHERE DEPTNO = VDEPTNO;
BEGIN
    DBMS_OUTPUT.PUT_LINE('�����ȣ / ����� / ���� / �޿�');
    DBMS_OUTPUT.PUT_LINE('------------------------------------');
    
    FOR VEMP IN C1 LOOP
        EXIT WHEN C1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(VEMP.EMPNO || '  ' || VEMP.ENAME || '  ' || VEMP.JOB || '  ' || VEMP.SAL);
    END LOOP;
END;
/


EXECUTE SEL_EMP(20);



-----------------------------------------------------------------------------------------------------------------------------------
-- 22. ��Ű��
-- �ǽ� : ��Ű�� �ۼ��ϱ�
CREATE OR REPLACE PACKAGE EXAM_PACK IS
    FUNCTION CAL_BONUS(VEMPNO IN EMP.EMPNO%TYPE)
        RETURN NUMBER;
    PROCEDURE CURSOR_SAMPLE02;
END;
/

CREATE OR REPLACE PACKAGE BODY EXAM_PACK IS
    FUNCTION CAL_BONUS(VEMPNO IN EMP.EMPNO%TYPE)
        RETURN NUMBER
    IS
        VSAL NUMBER(7, 2);
    BEGIN
        SELECT SAL INTO VSAL
        FROM EMP
        WHERE EMPNO=VEMPNO;
        RETURN (VSAL * 200);
    END;

    PROCEDURE CURSOR_SAMPLE02
    IS
        VDEPT DEPT%ROWTYPE;
        CURSOR C1
        IS
        SELECT * FROM DEPT;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('�μ���ȣ / �μ��� / ������');
        DBMS_OUTPUT.PUT_LINE('------------------------------------');
        FOR VDEPT IN C1 LOOP
            EXIT WHEN C1%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(VDEPT.DEPTNO||' '||VDEPT.DNAME||' '||VDEPT.LOC);
        END LOOP;
    END;
END;
/

-- ��Ű�� �����ϱ�
VARIABLE VAR_RES NUMBER;
EXECUTE :VAR_RES := EXAM_PACK.CAL_BONUS(7788);
-- ��Ű�� �̸� EXAM_PACK�� �ִ� CAL_BONUS �Լ��� �����ͼ� 7788�� �Ű����� ���� �Լ� CAL_BONUS�� ����� VAR_RES ������ �־����. 

PRINT VAR_RES;

EXECUTE EXAM_PACK.CURSOR_SAMPLE02;



-- JDBC Statement Ȱ���ϱ� �ǽ�(Insert)
CREATE TABLE CUSTOMER(
    NO NUMBER(4)  PRIMARY KEY, 
    NAME VARCHAR2(20),
    EMAIL VARCHAR2(20),
    TEL VARCHAR2(20)
);

DESC CUSTOMER;
SELECT * FROM CUSTOMER;











