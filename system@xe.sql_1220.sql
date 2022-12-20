-- �ý��� ���� : CREATE USER
CREATE USER USER10 IDENTIFIED BY USER10;
-- USER10�� �����ϴµ� Password�� USER10 �̴�.
-- USER�� �����ϸ� ������ �ο������ �Ѵ�.

GRANT CREATE SESSION TO USER10;

-- ����� ��й�ȣ ����
ALTER USER USER10 IDENTIFIED BY PWD;
-- ��й�ȣ�� USER10���� PWD�� �����ߴ�.

-- ������ �ο��ϱ� : GRANT
GRANT CREATE SESSION TO USER10; -- USER10�� ���� �ο�
GRANT CREATE TABLE TO USER10;
GRANT unlimited tablespace to USER10; -- ��� ���̺����̽��� �Ҵ緮�� �� �� �ִ� ���� �ο�, ���̺����̽��� ���� ���� �ο�
-- ������ �ο� �޾ƾ� ���̺��� ����� �׿� �ٸ� ��ü���� ���� �� �ֱ� ������ ������ �޾ƾ��Ѵ�,,



-- ���̺� �����̽� Ȯ���ϱ�
SELECT USERNAME, DEFAULT_TABLESPACE
FROM DBA_USERS
WHERE USERNAME IN ('USER10', 'SCOTT');
-- USER ���� �� ���̺����̽��� �����ؼ� ���� �� �ִ�.
-- ���� �ڵ带 �����ϸ� ������ ������ ��� ���̺��� ����ϰ� �ִ� �� �� �ִ�.


-- USER10�� ���� SYSTEM ���̺����̽��� �Ǿ� �ִ�. USERS ���̺����̽��� �����غ���
-- ���̺� �����̽� �����ϱ�
ALTER USER USER10 DEFAULT TABLESPACE USERS;
ALTER USER USER10 TEMPORARY TABLESPACE TEMP;


-- ���̺����̽��� ���� �Ҵ��ϱ�
ALTER USER USER10
QUOTA 1000M ON USERS;
-- USERS���̺��� 1�Ⱑ�� ���� �Ҵ�޾� ����ϰڴ�..?
-- USERS��� ���̺����̽��� SCOTT������ ���� �����͵��� �����Ѵ�..



-- WITH ADMIN OPTION
CREATE USER USER02 IDENTIFIED BY TIGER;
GRANT CREATE SESSION TO USER02 WITH ADMIN OPTION;
-- CREATE SESSION�� �ָ鼭 WITH ADMIN OPTION�� �ذ�,,
-- WITH ADMIN OPTION : CREATE SESSION ������ DBA ������ ������ �ٸ� �������� �ο��� �� �ְԲ� �ϴ� ������ �ο����ش�.

CREATE USER USER03 IDENTIFIED BY TIGER;
GRANT CREATE SESSION TO USER03;
-- USER03�� WITH ADMIN OPTION ���� ���� CREATE SESSION ���Ѹ� �޾Ƽ�
-- �ٸ� �������� CREATE SESSION ������ �� �� ����.

CREATE USER USER01 IDENTIFIED BY TIGER; -- USER01�� ���� ���� ����.


