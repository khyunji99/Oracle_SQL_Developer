SHOW USER

SELECT * FROM DUAL;
SELECT * FROM SYS.DUAL;
-- 원래는 이렇게 스키마이름.접근할객체 이렇게 코드를 적어야하는데
-- 위에서처럼 그냥 접근할객체 이름만 적어서 접근을 할 수가 있다.
-- 저 DUAL이 공개 동의어로 지정되어 있어서 저렇게 DUAL만 적어도 접근할수가 있는 것이다.


SELECT * FROM SYSTBL; -- 출력 안됨,,
SELECT * FROM SYSTEM.SYSTBL;  -- 접근할 수 있는 권한이 없기 때문에 접근 불가능해서 아무것도 안나온다.. 오류가나옴
-- 권한 부여받고 나서 다시 실행해보면 출력된다.
-- 하지만 SYSTEM 을 붙여서 SYSTBL을 적어줘야 접근이 된다! 그냥 SYSTBL만 적어서 접근하려고 하면 여전히 안된다!

-- 동의어 생성하기
CREATE SYNONYM SYSTBL FOR SYSTEM.SYSTBL;
-- SYSTEM 계정에서 SCOTT 계정에게 CREATE SYNONYM 권한을 부여해주고 나니
-- 위의 코드처럼 SYSTEM.SYSTBL에 대한 동의어 SYSTBL을 만들 수 있게 되었다.
-- CREATE SYNONYM 하고 다시 SELECT * FROM SYSTBL;을 하니 이제는 실행이 된다!






-------------------------------------------------------------------------------------------------------------------------------------
-- 20. PL/SQL : Procedural Language extension to SQL
SET SERVEROUTPUT ON  -- 출력해주는 내용을 화면에 보여주도록 설정하는 것
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO WORLD'); -- OUTPUT 얘는 패키지로 보면되고 PUT_LINE 얘는 PRINT 함수 같은걸(출력해주는 함수)로 생각하면 조금 이해하기 쉽다,,,
END;
/

-- 2. 변수선언과 대입문
-- 변수 사용하기
SET SERVEROUTPUT ON
DECLARE -- 변수 선언
    -- 선언부에는 변수를 선언한다.
    VEMPNO NUMBER(4);  -- , 아니고 ; 사용해야한다.
    VENAME VARCHAR2(10);
BEGIN -- 실행문 작성
    -- 실행부에서는 실행문을 작성한다.
    VEMPNO := 7788;
    VENAME := 'SCOTT';
    DBMS_OUTPUT.PUT_LINE('사번 / 이름');
    DBMS_OUTPUT.PUT_LINE('-------------');
    DBMS_OUTPUT.PUT_LINE(VEMPNO || ' / ' || VENAME);
END;
/


-- 사번과 이름 검색하기
DECLARE
    VEMPNO EMP.EMPNO%TYPE;
    VENAME EMP.ENAME%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('사번 / 이름');
    DBMS_OUTPUT.PUT_LINE('--------------');
    
    SELECT EMPNO, ENAME INTO VEMPNO, VENAME  -- INTO 안적어주면 오류발생함
    FROM EMP
    WHERE ENAME = 'SCOTT';
    
    DBMS_OUTPUT.PUT_LINE(VEMPNO || ' / ' || VENAME);
END;
/




-- 테이블 TYPE 변수 사용하기
SET SERVEROUTPUT ON
DECLARE
    -- 테이블 타입을 정의
    TYPE ENAME_TABLE_TYPE IS TABLE OF EMP.ENAME%TYPE  -- 테이블 타입 이름은 ENAME_TABLE_TYPE이고 , EMP.ENAME의 데이터타입으로 테이블 타입을 결정한다.
        INDEX BY BINARY_INTEGER; -- 옵션
    TYPE JOB_TABLE_TYPE IS TABLE OF EMP.JOB%TYPE
        INDEX BY BINARY_INTEGER;
        
    -- 테이블 타입으로 변수 선언하기
    ENAME_TABLE ENAME_TABLE_TYPE;  -- ENAME_TABLE은 ENAME_TABLE의 타입으로 데이터타입을 한다.
    JOB_TABLE JOB_TABLE_TYPE;  -- JOB_TABLE은 JOB_TABLE의 타입으로 데이터타입을 가진다.
    
    I BINARY_INTEGER := 0;  -- I 변수는 BINARY_INTEGER(NUMBER타입이랑 다름)타입이고 0을 대입한다(0으로 초기화).
BEGIN
    FOR K IN (SELECT ENAME, JOB FROM EMP) LOOP -- SELECT ENAME, JOB FROM EMP의 결과를 K 변수에 담는 것이다,,
        I := I + 1; -- I는 1부터 시작한다
        ENAME_TABLE(I) := K.ENAME; -- ENAME_TABLE의 I 인덱스에 K의 ENAME 값을 넣어라.
        JOB_TABLE(I) := K.JOB;
    END LOOP;
        
         FOR J IN 1.. I LOOP -- ... 3개 적으면 출력 안된다! .. 2개만 적어줘야한다!
            DBMS_OUTPUT.PUT_LINE(RPAD(ENAME_TABLE(J), 12)  || ' / ' || RPAD(JOB_TABLE(J),9));
    END LOOP;
END;
/



-- 레코드 타입 사용하기
DECLARE
    -- 레코드 타입을 정의하기 : 자바의 클래스 타입(다른 타입의 필드를 정의)과 같은 개념
    TYPE EMP_RECORD_TYPE IS RECORD(
        V_EMPNO EMP.EMPNO%TYPE,
        V_ENAME  EMP.ENAME%TYPE,
        V_JOB      EMP.JOB%TYPE,
        V_DEPTNO EMP.DEPTNO%TYPE);
        
    -- 레코드 타입으로 변수 선언하기
    EMP_RECORD EMP_RECORD_TYPE;  -- EMP_RECORD 변수는 EMP_RECORD 타입이다.
BEGIN
    SELECT EMPNO, ENAME, JOB, DEPTNO INTO EMP_RECORD -- INTO EMP_RECORD 코드에 안적어도 출력이 됨...
    FROM EMP
    WHERE ENAME = UPPER('SCOTT');
    
    DBMS_OUTPUT.PUT_LINE('사원번호 : ' || TO_CHAR(EMP_RECORD.V_EMPNO) ); -- V.EMPNO는 EMP.EMPNO의 타입이다. 즉, NUMBER 타입이라서 그걸 TO_CHAR 타입으로 변환시켜준 것
    DBMS_OUTPUT.PUT_LINE('이     름 : ' || EMP_RECORD.V_ENAME);
    DBMS_OUTPUT.PUT_LINE('담당업무 : ' || EMP_RECORD.V_JOB);
    DBMS_OUTPUT.PUT_LINE('부서번호 : ' || EMP_RECORD.V_DEPTNO);
END;
/

-- BEGIN 안에 있는 실행문만 따로 실행해보기
SELECT EMPNO, ENAME, JOB, DEPTNO --INTO EMP_RECORD -- INTO EMP_RECORD 코드에 안적어도 출력이 됨...
    FROM EMP
    WHERE ENAME = UPPER('SCOTT');


-- 부서 번호로 부서명 알아내기
-- IF ~ THEN ~ END IF
DECLARE
       VEMPNO NUMBER(4);
       VENAME VARCHAR2(20);
       VDEPTNO EMP.DEPTNO%TYPE;
       VDNAME VARCHAR2(20) := NULL; -- 변수 선언과 동시에 NULL 값 넣어주기
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
       
       DBMS_OUTPUT.PUT_LINE('사번      이름       부서명');
       DBMS_OUTPUT.PUT_LINE(VEMPNO || '     ' || VENAME || '    ' || VDNAME);
       
END;
/




-- IF ~ THEN ~ ELSEIF~ ELSE ~ END IF
DECLARE
    VEMP EMP%ROWTYPE;  -- 레코드 타입 (하나의 ROW를 가져와서 그것들의 각각의 칼럼들의 데이터타입들 VEMP의 데이터타입으로 사용하겠다.
    VDNAME VARCHAR2(14);
BEGIN
    DBMS_OUTPUT.PUT_LINE('사번 / 이름 / 부서명');
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



-- BASIC LOOP문 : LOOP ~ END LOOP
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



-- WHILE LOOP문
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

-- 21장.
-- 21-01-01.저장 프로시저(STORED PROCEDURE) 생성하는 방법
DROP TABLE EMP01;

CREATE TABLE EMP01
AS
SELECT * FROM EMP;

SELECT * FROM EMP01;

-- 프로시저 생성
CREATE OR REPLACE PROCEDURE DEL_ALL
IS
BEGIN
    DELETE FROM EMP01;
END;  -- 실행이 아니라 컴파일 되었다고 나온다! DELETE 하긴 했지만 위에 SELECT EMP01 해보면 데이터 아직 있다.
/

-- 아래의 코드를 실행해야 EMP01 테이블이 DELETE 되어서 데이터가 다 사라지게 된다. 이게 실행된것임,,
EXECUTE DEL_ALL;




-- 저장 프로시저 조회하기
SELECT NAME, TEXT FROM USER_SOURCE;
-- 우리가 만든 프로시저들 출력된다.


-- 매개변수 저장 프로시저
DROP TABLE EMP01;

CREATE TABLE EMP01
AS
SELECT * FROM EMP;

SELECT * FROM EMP01;

-- VENAME 이라는 매개변수가 있고 이 매개변수의 데이터타입은 EMP01의 ENAME칼럼의 데이터타입으로 지정했다.
CREATE OR REPLACE PROCEDURE DEL_ENAME(VENAME EMP01.ENAME%TYPE)
IS
BEGIN
    DELETE FROM EMP01
    WHERE ENAME = VENAME;  -- ENAME이 매개변수로 받은 VENAME 에 해당하는 데이터들을 EMP01 테이블에서 지워라 
END;
/

SELECT * FROM EMP01;

EXECUTE DEL_ENAME('SMITH'); -- 이거 실행하고 다시 SELECT * FROM EMP01 해보면 SMITH 사라짐..



-- IN, OUT, INOUT 매개변수
DROP PROCEDURE SEL_EMPNO;

-- 매개변수가 4개 VEMPNO, VENAME, VSAL, VJOB 인 프로시저
-- IN 은 데이터 입력받는 것, OUT은 수행된 결과값을 받아가는 것
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

-- 바인드 변수
-- ' : ' 를 덧붙여주는 변수는 미리 선언되어 있어야 한다.
VARIABLE VAR_ENAME VARCHAR2(15);
VARIABLE VAR_SAL NUMBER;
VARIABLE VAR_JOB VARCHAR2(9);

-- OUT 매개변수에서 값을 받아오기 위해서는 프로시저 호출 시 변수 앞에 ' : ' 를 덧붙인다.
EXECUTE SEL_EMPNO(7788, :VAR_ENAME, :VAR_SAL, :VAR_JOB);
-- :VAR_ENAME 는 실행된 값을 여기에 담겠다는 것이다.

PRINT VAR_ENAME;
-- 위에서 실행한 결과값을 받은 변수 :VAR_ENAME 를 콘솔창에 출력하는 코드 
PRINT VAR_SAL;
PRINT VAR_JOB;

SELECT ENAME, SAL FROM EMP
WHERE EMPNO=7788;





-- 과제 IN, OUT 매개변수
-- SEL_EMPNAME 프로시저 생성하기
-- EMP.ENAME 의 데이터 받는 변수 와 실행 결과에서 JOB값에서 받는 변수
-- 이렇게 두개의 변수 가지는 프로시저 생성 하기
DROP PROCEDURE SEL_EMPNAME;

-- 프로시저 생성
CREATE OR REPLACE PROCEDURE SEL_EMPNAME(
    VENAME IN EMP.ENAME%TYPE,
    VJOB OUT EMP.JOB%TYPE
)
IS
BEGIN --  실행문 작성
    SELECT JOB INTO VJOB
    FROM EMP
    WHERE ENAME=VENAME;
    
END;
/

VARIABLE VAR_JOB VARCHAR2(9);

EXECUTE SEL_EMPNAME('SCOTT', :VAR_JOB);

PRINT VAR_JOB;







