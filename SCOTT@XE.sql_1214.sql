-- 지난 시간 복습
-- 형변환 함수 : TO_NUMBER, TO_CHAR, TO_DATE
-- 1. ** DATE -> VARCHAR2 (날짜 -> 문자)
SELECT SYSDATE FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') FROM DUAL;

-- 2. NUMBER->VARCHAR2 (숫자 -> 문자), 우리가 원하는 포멧으로 변환해준다,,
SELECT ENAME, SAL FROM EMP;
SELECT ENAME, TO_CHAR(SAL, 'L999,999') FROM EMP; -- LOCALE (L) : 시스템에 설정되어 있는 OS에 저장된 언어 버전,,,?

-- 3. ** NUMBER -> DATE (숫자 -> 날짜)
SELECT ENAME, HIREDATE FROM EMP;
SELECT ENAME, HIREDATE FROM EMP
--WHERE HIREDATE='1981/02/20'; -- 문자로 찾는
--WHERE HIREDATE=19810220; -- 이렇게 숫자로 찾을 수 없다.
WHERE HIREDATE = TO_DATE(19810220, 'YYYYMMDD');

-- 4. VARCHAR2 -> NUMBER (문자 -> 숫자)
SELECT TO_NUMBER('20,000', '99,999') FROM DUAL;
SELECT TO_NUMBER('20,000', '99,999') - TO_NUMBER('10,000', '99,999') FROM DUAL;
-- 문자 20,000 를 숫자로 변환, 10,000 문자를 숫자로 변환해서 숫자끼리 뺀 것 출력




--06. 그룹 쿼리와 집합 연산자

--6-1. 기본 집계 함수
--6-1-1. SUM 함수 : 합계 구하기
SELECT SUM(SAL) FROM EMP;
SELECT SUM(COMM) FROM EMP; -- SUM 함수는 NULL을 제외하고 합계한다.


--6-1-2. AVG 함수 : 평균 구하기
SELECT AVG(SAL) FROM EMP;
SELECT AVG(COMM) FROM EMP; -- AVG 함수는 NULL을 제외하고 계산한다.


--6-1-3. MAX, MIN 함수 : 최대, 최소 구하기
SELECT MAX(SAL), MIN(SAL) FROM EMP;
SELECT SAL FROM EMP;
SELECT MAX(COMM), MIN(COMM) FROM EMP;

SELECT ENAME, MAX(SAL) FROM EMP;
-- ENAME의 값은 14개인데 MAX(SAL) 값은 하나라서 오류가 발생한다. 오류) ORA-00937: not a single-group group function
-- 이와 같이 그룹 함수는 여러개의 값이 나오는 컬럼과 같이 사용할 수 없다.

--6-1-4.COUNT : 로우(ROW) 개수 구하기, NULL의 개수는 제외하고 계산한다.
SELECT COUNT(*), COUNT(COMM) FROM EMP;
SELECT COUNT(JOB) 업무수 FROM EMP; -- 중복된 값 포함하여 개수가 계산된다.
SELECT COUNT(DISTINCT JOB) 업무수 FROM EMP; -- DISTINCT 해줘서 중복된 값 제외하고 개수가 계산되게 한다.



-- GROUP BY 절 : 그룹핑 --> 평균, 합계, 최대값 등을 구할 수 있다..
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


-- HAVING 절 : GROUP 의 조건을 준다.
SELECT DEPTNO, AVG(SAL)
FROM EMP
WHERE SAL>=800
GROUP BY DEPTNO;

SELECT DEPTNO, AVG(SAL)
FROM EMP
WHERE SAL>=800          -- FROM에 대한 조건
GROUP BY DEPTNO
HAVING AVG(SAL) >= 2000 -- 전체 그룹핑한 것에 대해 조건을 준것이다..?
ORDER BY DEPTNO ASC;
-- WHERE, HAVING, ORDER BY 절들은 생략 가능하다.


------------------------------------------------------------------

-- 집합 연산자
--1. UNION : 합집합

DROP TABLE EXP_GOODS_ASIA;

CREATE TABLE EXP_GOODS_ASIA (
    COUNTRY VARCHAR2(10),
    SEQ NUMBER,
    GOODS VARCHAR2(80)
);
DESC EXP_GOODS_ASIA;
 
INSERT INTO EXP_GOODS_ASIA VALUES ('한국', 1, '원유제외 석유류');
INSERT INTO EXP_GOODS_ASIA VALUES ('한국', 2, '자동차');
INSERT INTO EXP_GOODS_ASIA VALUES ('한국', 3, '전자집적회로');
INSERT INTO EXP_GOODS_ASIA VALUES ('한국', 4, '선박');
INSERT INTO EXP_GOODS_ASIA VALUES ('한국', 5, 'LCD');
INSERT INTO EXP_GOODS_ASIA VALUES ('한국', 6, '자동차부품');
INSERT INTO EXP_GOODS_ASIA VALUES ('한국', 7, '휴대전화');
INSERT INTO EXP_GOODS_ASIA VALUES ('한국', 8, '환식탄화수소');
INSERT INTO EXP_GOODS_ASIA VALUES ('한국', 9, '무선송신기 디스플레이 부속품');
INSERT INTO EXP_GOODS_ASIA VALUES ('한국', 10, '철 또는 비합금강');
INSERT INTO EXP_GOODS_ASIA VALUES ('일본', 1, '자동차');
INSERT INTO EXP_GOODS_ASIA VALUES ('일본', 2, '자동차부품');
INSERT INTO EXP_GOODS_ASIA VALUES ('일본', 3, '전자집적회로');
INSERT INTO EXP_GOODS_ASIA VALUES ('일본', 4, '선박');
INSERT INTO EXP_GOODS_ASIA VALUES ('일본', 5, '반도체웨이퍼');
INSERT INTO EXP_GOODS_ASIA VALUES ('일본', 6, '화물차');
INSERT INTO EXP_GOODS_ASIA VALUES ('일본', 7, '원유제외 석유류');
INSERT INTO EXP_GOODS_ASIA VALUES ('일본', 8, '건설기계');
INSERT INTO EXP_GOODS_ASIA VALUES ('일본', 9, '다이오드, 트랜지스터');
INSERT INTO EXP_GOODS_ASIA VALUES ('일본', 10, '기계류');

COMMIT;

SELECT COUNT(*) FROM EXP_GOODS_ASIA;

SELECT GOODS
FROM EXP_GOODS_ASIA
WHERE COUNTRY = '한국'
ORDER BY SEQ;
-- 한국의 GOODS 컬럼 값들 출력됨

SELECT GOODS
FROM EXP_GOODS_ASIA
WHERE COUNTRY = '일본'
ORDER BY SEQ; -- ASC 가 생략되어 있어 SEQ 컬럼을 기준으로

-- UNION : 한국과 일본의 GOODS 중 5개는 겹치고 5개는 안겹친다. 겹치는 값들을 제외한 합집합을 출력한다.
-- 한국 10개, 일본 10개여서 총 20개가 나와야하는데 겹치는게 5개이니 그걸 뺀 15개가 출력된다.
SELECT GOODS
FROM EXP_GOODS_ASIA
WHERE COUNTRY = '한국'
UNION
SELECT GOODS
FROM EXP_GOODS_ASIA
WHERE COUNTRY = '일본';

-- UNION ALL : 겹치는것 포함해서 다 출력된다. 얘는 20개가 다 출력된다.
SELECT GOODS
FROM EXP_GOODS_ASIA
WHERE COUNTRY = '한국'
UNION ALL
SELECT GOODS
FROM EXP_GOODS_ASIA
WHERE COUNTRY = '일본';


-- INTERSECT : 교집합, 겹치는 부분이 출력된다.
SELECT GOODS
FROM EXP_GOODS_ASIA
WHERE COUNTRY = '한국'
INTERSECT
SELECT GOODS
FROM EXP_GOODS_ASIA
WHERE COUNTRY = '일본';



-- MINUS : 차집합 (A-B 와 B-A 는 다른 나오듯 아래의 두 결과도 다르다!)
SELECT GOODS
FROM EXP_GOODS_ASIA
WHERE COUNTRY = '한국'
MINUS
SELECT GOODS
FROM EXP_GOODS_ASIA
WHERE COUNTRY = '일본';

-- 위의 결과와 다르게 나온다 --
SELECT GOODS
FROM EXP_GOODS_ASIA
WHERE COUNTRY = '일본'
MINUS
SELECT GOODS
FROM EXP_GOODS_ASIA
WHERE COUNTRY = '한국';



---------------------------------------------------------------------------
-- 07. 조인 (JOIN)
SELECT * FROM EMP; -- 부서번호만 알 수 있고 부서명은 DEPT 테이블에서 볼 수 있다.
SELECT * FROM DEPT;
-- 이 둘의 테이블을 연결하면 어떤 사람이 어떤 부서명인지 알 수 있다.

-- JOIN 조인을 안하고 SMITH가 어느 부서에 있는지 알려고 할 때 두번의 코드를 거쳐야 한다.
SELECT DEPTNO FROM EMP
WHERE ENAME='SMITH';

SELECT DNAME FROM DEPT
WHERE DEPTNO=20;

-- 조인을 하면 코드를 한번만 적어서 내가 원하는걸 알아낼 수 있다. 
SELECT EMP.ENAME, DEPT.DNAME
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO AND
EMP.ENAME = 'SMITH';


SELECT *
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO AND
EMP.ENAME = 'SMITH';
-- DEPTNO_1, DNAME, LOC 는 DEPT 테이블에 있는 컬럼, 그외 나머지는 EMP 테이블에 있는 것들

-- 조인의 종류
--1. ORACLE CROSS JOIN
SELECT *
FROM EMP, DEPT;
-- 두개의 테이블 EMP(14개), DEPT(4개) 에서 모든 컬럼(14*4=56개의 컬럼)을 가져온다.

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
-- 오류 발생) ORA-00918: column ambiguously defined
-- DEPTNO가 EMP 테이블에도 DEPT 테이블에도 공통으로 있다.
-- 그래서 DEPTNO 를 가져오라고 한 코드에서 어떤 테이블에 있는 DEPTNO를 가져오는건지
-- 모호해서 오류가 발생한 것! --> 명확하게 어느 테이블에서 가져오는지 고쳐주면 해결

SELECT EMP.ENAME, DEPT.DNAME, DEPT.DEPTNO
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO
AND ENAME='SCOTT';

-- 이렇게 명확하게 어느 테이블에서 가져오는지 다 적어주다보니
-- 만일 테이블 이름이 길면,, 너무 힘들다!! 그럴땐 가명을 별칭을 부여해줘서 적으면 훨씬 간결하게 적을 수 있다.
SELECT E.ENAME, D.DNAME, D.DEPTNO
FROM EMP E, DEPT D  -- 별칭 부여해줌
WHERE E.DEPTNO = D.DEPTNO
AND ENAME='SCOTT';





-- 과제
-- 07-01 과제문제
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
-- 레벨이 1~5까지 있다.

SELECT E.ENAME, E.SAL, S.GRADE
FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL;
-- SAL 범위가 LOSAL과 HISAL에 있는 ENAME, SAL, GRADE 출력


SELECT E.ENAME, E.SAL, S.GRADE
FROM EMP E, SALGRADE S
WHERE E.SAL >= S.LOSAL AND E.SAL <= S.HISAL;
--WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL; 처럼 BETWEEN 대신 위처럼 비교연산자로 사용할 수 도 있다.
-- 위 처럼 = 연산자 말고도 >=, <= 등 이러한 비교 연산자도 적을 수 있다.


-- SELF JOIN
SELECT EMPNO, ENAME, MGR FROM EMP;

SELECT E.ENAME AS "사원명", M.ENAME "상사명"
FROM EMP E, EMP M
WHERE E.MGR = M.EMPNO;
-- MGR = 상사번호
-- EMPNO = 사번

SELECT E.ENAME AS "사원명", M.ENAME "상사명"
FROM EMP E, EMP M
WHERE E.MGR = M.EMPNO;


--07-03 과제문제

--07-03-01
SELECT * FROM EMP;
SELECT * FROM DEPT;

SELECT E.ENAME AS "사원명", M.ENAME "매니저", E.JOB "직급"
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

SELECT E.ENAME 이름, C.ENAME 동료
FROM EMP E, EMP C
WHERE E.DEPTNO = C.DEPTNO
AND E.ENAME = 'SCOTT'
AND C.ENAME <> 'SCOTT'
ORDER BY C.ENAME ASC;

SELECT *
FROM EMP E, EMP C
WHERE E.DEPTNO = C.DEPTNO
AND E.ENAME = 'SCOTT';
-- SCOTT의 동료 C 들의 이름 ENAME_1 포함해서 정보들이 출력됨

SELECT C.ENAME
FROM EMP E, EMP C
WHERE E.DEPTNO = C.DEPTNO
AND E.ENAME = 'SCOTT'
AND C.ENAME <> 'SCOTT'  -- 동료 C의 이름에서 SCOTT의 이름 제외
ORDER BY C.ENAME ASC;
-- SCOTT과 같은 근무지에서 일하는 동료들의 이름을 오름차순으로 정렬하여 출력됨
-- 이때 주의할 것은 SCOTT의 동료들 이름을 출력해야 하는 것이므로 SCOTT의 이름은 빼줘야한다!!

SELECT * FROM EMP;

SELECT * FROM DEPT;




-- 7-6. Outer Join : 조인 조건에 만족하지 못하더라도 해당 로우를 나타내려고 할 때 사용
SELECT E.ENAME, M.ENAME
FROM EMP E, EMP M
WHERE E.MGR = M.EMPNO;
-- ENAME : 사원이름 / ENAME_1 : 상사이름
-- KING 은 가장 높은 상사라서 KING의 상사는 없다! 즉, NULL이라서
-- KING이 사원에는 안나타난다.
-- 그럴 때 KING은 저기에 조인 조건에 만족하지 못하지만 KING도 같이 출력하고 싶ㄷ다!! -> Outer Join 사용

-- Outer Join 사용
SELECT E.ENAME, M.ENAME
FROM EMP E, EMP M
WHERE E.MGR = M.EMPNO(+);



-- ANSI CROSS JOIN = ORACLE CROSS JOIN
-- ORACLE CROSS JOIN (오라클에서만 사용가능)
SELECT *
FROM EMP, DEPT;

-- ANSI CROSS JOIN (다른 데이터베이스 ex. mysql 등... 에서도 사용 가능)
SELECT *
FROM EMP CROSS JOIN DEPT;


-- ANSI INNER JOIN = ORACLE EQUI JOIN
-- ORACLE EQUI JOIN
SELECT E.ENAME, D.DNAME
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO;


-- ANSI INNER JOIN : , 대신 INNER JOIN 사용하고 WHERE 대신 ON 사용함 그런데 ON 대신 USING을 사용할 수도 있음
SELECT E.ENAME, D.DNAME
FROM EMP E INNER JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;

-- USING 사용
SELECT E.ENAME, D.DNAME
FROM EMP E INNER JOIN DEPT D
USING(DEPTNO);


-- ANSI NATURAL JOIN : 같은 이름으로 조인하는거니까 이름이 같은 것 끼리 조인시켜 주는 것
SELECT E.ENAME, D.DNAME
FROM EMP E NATURAL JOIN DEPT D;
-- 조건이 없어도 같은 DEPTNO끼리 조인시켜준다! NATURAL 짱 싱기,,,



-- ANSI OUTER JOIN
DROP TABLE DEPT01;

CREATE TABLE DEPT01(
 DEPTNO NUMBER(2),
 DNAME VARCHAR2(14)
);

INSERT INTO DEPT01 VALUES(10,'ACCOUNTING');
INSERT INTO DEPT01 VALUES(20,'RESEARCH');
SELECT * FROM DEPT01;
-- DEPT01에는 DEPTNO=10, 20 인 애들이 들어있다

DROP TABLE DEPT02;

CREATE TABLE DEPT02(
 DEPTNO NUMBER(2),
 DNAME VARCHAR2(14)
);

INSERT INTO DEPT02 VALUES(10,'ACCOUNTING');
INSERT INTO DEPT02 VALUES(30,'SALES');
SELECT * FROM DEPT02;
-- DEPT02에는 DEPTNO=10, 30 인 애들이 들어있다

-- ANSI Left Outer Join
SELECT *
FROM DEPT01 LEFT OUTER JOIN DEPT02
ON DEPT01.DEPTNO = DEPT02.DEPTNO;
-- 왼쪽에 있는 DEPT01을 중심으로 DEPT02의 부족한 것들이 나온다,,?
-- DEPT01을 중심으로 DEPT01에는 DEPTNO=10,20인 애들이 있다
-- 그런데 DEPT02에는 DEPTNO=10은 있지만 DEPTNO = 20이 없어서
-- DEPTNO=20인 것에 대해서는 그냥 NULL 값으로 나온다.

-- ANSI Right Outer Join
SELECT *
FROM DEPT01 RIGHT OUTER JOIN DEPT02
USING(DEPTNO);
-- 오른쪽에 있는 DEPT02를 중심으로 왼쪽 DEPT01에 없는 것이 나온다,,?
-- DEPT02에는 DEPTNO=10,30인 애들이 있다.
-- 그래서 기준인 DEPT02에 대한 DEPTNO =10, 30에 대해서 출력될것이다.
-- 그런데 DEPT01에는 DETPNO=10은 있지만 DEPTNO=30는 없다
-- 그래서 DEPTNO=30 에 대해서는 DNAME이 NULL로 나온 것이다.
-- DEPTNO 은 DEPT02이 기준이므로 10과 30이 출력
-- DNAME 은 DEPT01에 대한 값 출력
-- DNAME_1 은 DEPT02에 대한 값 출력
-- DEPT02는 DEPTNO 10과 30에 대한 DNAME 값이 있으므로 그 해당하는 값 출력
-- DEPT01은 DEPTNO 10에 대한 값 ACCOUNTING 은 있지만 DEPTNO 30에 대한 DNAME 값은 없으므로 NULL로 나옴


-- Full Outer Join
SELECT *
FROM DEPT01 FULL OUTER JOIN DEPT02
USING(DEPTNO);
-- 서로간에 부족한 것들을 다 보여줘!!
-- DEPT01에는 DEPTNO= 30 인 애가 없고, DEPT02에는 DEPTNO=20인 애가 없다
-- 얘네 다 포함해서 출력함




-- 07-02 과제문제
-- 07-02-01.직급이 MANAGER인 사원의 이름, 부서명 출력
-- ORACLE EQUI JOIN, ANSI INNER JOIN, ANSI NATURAL JOIN 사용
-- ORACLE EQUI JOIN : 공통적으로 존재하는 컬럼 출력
-- SELECT * FROM EMP, DEPT WHERE EMP.DEPTNO = DEPT.DEPTNO;
-- ANSI INNER JOIN : , 대신 INNER JOIN 사용해서
-- SELECT ENAME, DNAME FROM EMP, DEPT WHERE EMP.DEPTNO=DEPT.DEPTNO;
-- ANSI NATURAL JOIN : 자동적으로 모든 컬럼을 대상으로 공통 컬럼을 조사하여 내부적으로 조인문 생성
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

--07-02-02. SMITH와 동일한 직급(JOB컬럼)을 가진 사원의 이름과 직급을 출력하는 SQL문
SELECT C.ENAME, C.JOB
FROM EMP E, EMP C
WHERE E.ENAME='SMITH'
AND E.JOB=C.JOB
AND C.ENAME<>'SMITH';

