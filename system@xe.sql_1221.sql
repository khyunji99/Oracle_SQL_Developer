-- �����(USER04/PWD) �����ϱ�
CREATE USER USER04 IDENTIFIED BY PWD;

--USER04���� ROLE �ο�
GRANT CONNECT, RESOURCE TO USER04;


-- ����� �� �����ϱ�
CREATE ROLE MROLE; -- �� ����
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW TO MROLE;
-- MROLE�� GRANT �������μ� 3���� �ý��� ������ ������ �ȴ�.

CREATE USER USER05 IDENTIFIED BY PWD; -- USER05 ����� ����
GRANT MROLE TO USER05; -- 3���� �ý��۱����� ����ִ� MROLE ���� �ѹ��� �ο���.
REVOKE MROLE FROM USER05;


-- ���Ǿ� ���� �� ����
DROP TABLE SYSTBL;
CREATE TABLE SYSTBL(
    ENAME VARCHAR2(20)
);

INSERT INTO SYSTBL VALUES('������');

SELECT * FROM SYSTBL;

-- ��ü ���� �ο�
GRANT SELECT ON SYSTBL TO SCOTT; -- SCOTT �������� SYSTBL ������ �� �ִ� ���� �ο�����

GRANT CREATE SYNONYM TO SCOTT;














