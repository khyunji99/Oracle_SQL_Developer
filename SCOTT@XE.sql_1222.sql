-- 4. 저장함수 (stored function)
-- 실습 : 저장함수 작성하기

CREATE OR REPLACE FUNCTION CAL_BONUS(VEMPNO IN EMP.EMPNO%TYPE)
    RETURN NUMBER -- 매개변수 받아서 함수 실행하고 리턴되는 데이터타입이 NUMBER이다.
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
-- NUMBER 타입의 변수 : VAR_RES
EXECUTE :VAR_RES :=CAL_BONUS(7788);
PRINT VAR_RES;


-- 과제 : 저장함수 생성하기
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




-- 5. 커서
-- CURSOR를 이용해서 부서 테이블의 모든 내용을 조회하기
-- NOTFOUND : 커서 영역의 자료가 모두 FETCH 되면 TRUE

SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE CURSOR_SAMPLE01
IS
    VDEPT DEPT%ROWTYPE;
    CURSOR C1 IS
        SELECT * FROM DEPT;
BEGIN
    DBMS_OUTPUT.PUT_LINE('부서번호 / 부서명 / 지역명');
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



-- CURSOR와 FOR LOOP 사용하는 경우
CREATE OR REPLACE PROCEDURE CURSOR_SAMPLE02
IS
    VDEPT DEPT%ROWTYPE;
    CURSOR C1 IS
        SELECT * FROM DEPT;
BEGIN
    DBMS_OUTPUT.PUT_LINE('부서번호 / 부서명 / 지역명');
    DBMS_OUTPUT.PUT_LINE('------------------------------');
    FOR VDEPT IN C1 LOOP
        EXIT WHEN C1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(VDEPT.DEPTNO || '  ' || VDEPT.DNAME || '  ' || VDEPT.LOC);
    END LOOP;
END;
/

EXECUTE CURSOR_SAMPLE02;



-- 6. 트리거


-- FOR EACH ROW에 대한 설명,,?
-- 만일 DEPTNO=20인 ROW에 DEPTNO=10로 UPDATE해라 라는 거라면
-- DEPTNO=20에 해당하는 ROW는 5개이다.

UPDATE EMP
SET DEPTNO=10
WHERE DEPRNO=20;

----CREATE TRIGGER T1
----    AFTER UPDATE ON EMP
--    FOR EACH ROW
--BEGIN
--    //실행문;
--END;
-- 조건절에 해당하는 ROW가 여러개일 때 각각의 ROW마다 모두 다 실행문을 적용 시켜줘라
-- 라는 걸 의미하는게 FOR EACH ROW 이다.
-- FOR EACH ROW가 없으면 그냥 총 1번만 실행문을 적용시키는 것이다.




-- 실습 : 단순 메시지를 출력하는 트리거 작성하기

-- 1. 사원 테이블 생성
DROP TABLE EMP01;

CREATE TABLE EMP01(
    EMPNO NUMBER(4) PRIMARY KEY,
    ENAME VARCHAR2(20),
    JOB VARCHAR2(20)
);

-- 2. 트리거 작성
-- EMP01 테이블에 INSERT 된 후(AFTER)에 실행문을 한번 적용해라.
CREATE OR REPLACE TRIGGER TRG_01
    AFTER INSERT
    ON EMP01
BEGIN
    DBMS_OUTPUT.PUT_LINE('신입사원이 입사했습니다.');
END;
/

-- 3. 사원 테이블에 데이터 추가
SET SERVEROUTPUT ON
INSERT INTO EMP01 VALUES(4, '홍길동', '정의로운도적');
-- 데이터가 INSERT 되면 트리거로 인해 '신입사원이 입사했습니다', 가 한번 출력된다.

SELECT * FROM EMP01;
-- 데이터가 잘 추가된 것을 확인할 수 있다.




-- 실습 : 급여 정보를 자동으로 추가하는 트리거 작성하기
-- 사원 테이블에 데이터가 들어오면(새로운 사원 추가)
-- 급여 테이블에 새로운 데이터를 자동으로 생성(새로 추가된 사원의 급여정보를 자동 생성)하도록,,
-- 사원 테이블에 트리거를 만들어보자.

-- 1.급여를 저장할 테이블을 생성한다.
DROP TABLE SAL01;

CREATE TABLE SAL01 (
    SALNO NUMBER(4) PRIMARY KEY,
    SAL NUMBER(7, 2),
    EMPNO NUMBER(4) REFERENCES EMP01(EMPNO)
);

-- 2. 급여번호를 자동 생성하는 시퀀스를 정의하고 이 시퀀스로부터 일련번호를 얻어 급여번호를 부여한다.
CREATE SEQUENCE SAL01_SALNO_SEQ;
-- 1부터 시작해서 1씩 증가하는 SEQUENCE이다.

-- 3. 트리거를 생성한다.
CREATE OR REPLACE TRIGGER TRG_02
    AFTER INSERT
    ON EMP01
    FOR EACH ROW
BEGIN
    INSERT INTO SAL01 VALUES ( SAL01_SALNO_SEQ.NEXTVAL, 100, :NEW.EMPNO );
END;
/
-- EMP01에 데이터가 INSERT 된 후(AFTER)에  <-- 우리가 작성한 트리거 내용
-- SAL01테이블에 값(SALNO, 급여 100, )을 INSERT 해라 라는 의미의 트리거이다.
-- :NEW.EMPNO  는 EMP01에 들어온 새로 입력된 ROW(데이터) 중에 EMPNO를 넣어라 라는 의미
-- :OLD 는 새로 입력된 데이터 이전의 ROW(데이터)


-- 4. 사원 테이블에 로우를 추가한다.
INSERT INTO EMP01 VALUES(2, '전수빈', '프로그래머');
SELECT * FROM EMP01;
SELECT * FROM SAL01;
-- 트리거에 의해 EMP01에 데이터를 추가했더니 SAL01테이블에 자동으로 값이 추가된다.

INSERT INTO EMP01 VALUES(3, '김종현', '교수');
SELECT * FROM EMP01;
SELECT * FROM SAL01;




-- 실습 : 급여 정보를 자동으로 삭제하는 트리거 작성하기
-- 사원이 삭제(EMP01 테이블에서 데이터 삭제)되면
-- 그 사원의 급여 정보도 자동으로 삭제되도록
-- 트리거를 작성해보자.

SELECT * FROM EMP01;

-- 1. 사원 테이블의 로우를 삭제한다.
DELETE FROM EMP01 WHERE EMPNO=2;
-- SQL Error(ORA-02292: integrity constraint (SCOTT.SYS_C007054) violated - child record found)가 발생한다.
-- SLA01 테이블에서 EMPNO 칼럼의 값 중 EMPNO=2의 값이 EMP01의 EMPNO=2를 참조하고 있어서
-- EMP01에서 EMPNO=2의 값을 지울 수가 없다.
-- SAL01에서 EMPNO=2의 데이터를 지우고 나서 EMP01테이블에서 EMPNO=2 데이터를 지우면 된다.


-- 2. 트리거를 작성한다.
CREATE OR REPLACE TRIGGER TRG_03
    AFTER DELETE ON EMP01
    FOR EACH ROW
BEGIN
    DELETE FROM SAL01 WHERE EMPNO=:OLD.EMPNO;
    -- SLA01 테이블의 EMPNO가 지우려고 하는 EMPNO 넘버 (:OLD.EMPNO) 를 지워라
END;
/


-- 3. 사원 테이블의 로우를 삭제한다.
DELETE FROM EMP01 WHERE EMPNO=2;
SELECT * FROM EMP01;
SELECT * FROM SAL01;



--- 과제 21-02.
-- 부서 번호를 전달하여 해당 부서 소속 사원의 정보를 출력하는 SEL_EMP 프로시저를 커서를 사용하여 작성하라.

-- FOR LOOP 방식이 아닐때
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
    DBMS_OUTPUT.PUT_LINE('사원번호 / 사원명 / 직급 / 급여');
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







-- FOR LOOP로 풀어보기
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
    DBMS_OUTPUT.PUT_LINE('사원번호 / 사원명 / 직급 / 급여');
    DBMS_OUTPUT.PUT_LINE('------------------------------------');
    
    FOR VEMP IN C1 LOOP
        EXIT WHEN C1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(VEMP.EMPNO || '  ' || VEMP.ENAME || '  ' || VEMP.JOB || '  ' || VEMP.SAL);
    END LOOP;
END;
/


EXECUTE SEL_EMP(20);



-----------------------------------------------------------------------------------------------------------------------------------
-- 22. 패키지
-- 실습 : 패키지 작성하기
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
        DBMS_OUTPUT.PUT_LINE('부서번호 / 부서명 / 지역명');
        DBMS_OUTPUT.PUT_LINE('------------------------------------');
        FOR VDEPT IN C1 LOOP
            EXIT WHEN C1%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(VDEPT.DEPTNO||' '||VDEPT.DNAME||' '||VDEPT.LOC);
        END LOOP;
    END;
END;
/

-- 패키지 실행하기
VARIABLE VAR_RES NUMBER;
EXECUTE :VAR_RES := EXAM_PACK.CAL_BONUS(7788);
-- 패키지 이름 EXAM_PACK에 있는 CAL_BONUS 함수를 가져와서 7788의 매개값을 넣은 함수 CAL_BONUS의 결과값 VAR_RES 변수에 넣어줘라. 

PRINT VAR_RES;

EXECUTE EXAM_PACK.CURSOR_SAMPLE02;



-- JDBC Statement 활용하기 실습(Insert)
CREATE TABLE CUSTOMER(
    NO NUMBER(4)  PRIMARY KEY, 
    NAME VARCHAR2(20),
    EMAIL VARCHAR2(20),
    TEL VARCHAR2(20)
);

DESC CUSTOMER;
SELECT * FROM CUSTOMER;











