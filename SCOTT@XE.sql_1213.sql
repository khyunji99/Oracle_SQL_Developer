-- DQL (Data Query Language, 데이터 질의어) : SELECT 문
SELECT * FROM DEPT;
SELECT DEPTNO, DNAME FROM DEPT;

-- DML (Data Manupulation Language, 데이터 조작어) : INSERT, UPDATE, DELETE
INSERT INTO DEPT VALUES(60, '총무부', '인천');
UPDATE DEPT SET LOC='부산' WHERE DNAME='총무부';
DELETE FROM DEPT WHERE DEPTNO=60;

-- DDL (Data Definition Language, 데이터 정의어) : CREATE, ALTER, DROP, RENAME, TRUNCATE
DESC DEPT01;
DROP TABLE DEPT01;

CREATE TABLE DEPT01(
    DEPTNO NUMBER(4),
    DNAME VARCHAR2(10),
    LOC VARCHAR2(9)
);
SELECT * FROM DEPT02;
INSERT INTO DEPT02 VALUES(10, '개발부', '서울');

ALTER TABLE DEPT01
MODIFY(DNAME VARCHAR2(30));

RENAME DEPT01 TO DEPT02;
DESC DEPT02;

-- TRUNCATE : 데이터만 자르고 테이블은 그대로 남아있음
-- TRUNCATE = DELETE + COMMIT
TRUNCATE TABLE DEPT02;

-- 여기까지 1장 복습, 아래부터는 2장 복습

-- ORACLE NULL = 값이 미확정 혹은 모르는 값, NULL 을 연산하려면 변경해줘야 한다.
--3 + ? = ?;
SELECT * FROM EMP;
SELECT SAL, COMM, SAL*12+NVL(COMM,0) AS "연봉" FROM EMP;
-- NVL(COMM,0) : COMM 칼럼에 NULL 값이 있을 수 있으니 그럴땐 0 값으로 바꿔서 연산해라 라는 의미
-- NVL(NULL VALUE) 함수는 NULL은 0 또는 다른 값으로 변환하기 위해 사용한다.

-- || (Concatenation, 연결자)
SELECT ENAME, JOB FROM EMP;
SELECT ENAME || ' IS A ' || JOB FROM EMP;

-- DISTINCT 키워드 : 동일한 값을 한번만 출력해준다.
SELECT * FROM EMP;
SELECT DISTINCT DEPTNO FROM EMP;




-- 12/13 수업내용
-- 1-1. SELECT 문에서 WHERE 조건과 비교 연산자
SELECT * FROM EMP
WHERE SAL >= 3000;

SELECT EMPNO, ENAME, SAL FROM EMP
WHERE SAL != 3000;
--WHERE SAL <> 3000;
--WHERE SAL ^= 3000;
-- !=, <>, ^= 다 똑같이 같지않다 를 의미한다.


-- 1-2.문자 데이터 조회
DESC EMP;
SELECT EMPNO, ENAME "이름", SAL
FROM EMP
WHERE ENAME ='FORD';
--WHERE ENAME ='ford';
-- 문자열은 대소문자를 구별하기 때문에 유의하자!!


-- 1-3. 날짜 데이터 조회
SELECT * FROM EMP
WHERE HIREDATE<='82/01/01';
-- 82년 전에 입사(HIREDATE)한 사람들 조회되어 출력해준다.


-- 2. 논리연산자 : AND, OR, NOT
SELECT * FROM EMP
WHERE DEPTNO=10 AND JOB='MANAGER';

SELECT * FROM EMP
WHERE DEPTNO=10 OR JOB='MANAGER';

SELECT * FROM EMP
--WHERE NOT DEPTNO=10;
WHERE DEPTNO != 10;
--WHERE NOT DEPTNO=10; 와 WHERE DEPTNO != 10; 는 같은 값이 출력된다. --> 같은 의미,,?


-- 3. BETWEEN AND 연산자
SELECT *
FROM EMP
--WHERE SAL>=2000 AND SAL<=3000;
-- 2000 <= SAL <= 3000 이거를 위의 코드처럼 AND 로 안적고 BETWEEN AND 로 다음과 같이적을 수 있다.
WHERE SAL BETWEEN 2000 AND 3000;

SELECT *
FROM EMP
WHERE HIREDATE BETWEEN '1987/01/01' AND '1987/12/31';


-- 4. IN 연산자
SELECT *
FROM EMP
WHERE COMM=300 OR COMM=500 OR COMM=1400;
-- 300 이거나 500이거나 1400인 COMM 출력

SELECT *
FROM EMP
WHERE COMM IN(300,500,1400);
-- COMM이 300 또는 500 또는 1400 중에 있는지 확인하고 출력해준다.

-- WHERE COMM=300 OR COMM=500 OR COMM=1400; 반대의 케이스
SELECT *
FROM EMP
--WHERE COMM<>300 AND COMM<>500 AND COMM<>1400;
-- 300도 아니고 500도 아니고 1400도 아닌 COMM 출력을 바로 위 코드와 바로 아래의 코드로 적어서 사용할 수 있다.
WHERE COMM NOT IN(300,500,1400);



-- 5. LIKE 연산자와 와일드카드 사용하기 (%, _)
-- 5.1 % 사용
SELECT *
FROM EMP
WHERE ENAME LIKE 'F%';
-- ENAME 중에서 F로 시작하는 ENAME 을 출력

SELECT *
FROM EMP
WHERE ENAME LIKE '%A%';
-- ENAME 중에서 A 앞과 뒤에 어떤 문자가 와도 상관없이 그냥 A가 들어간 ENAME을 출력

SELECT *
FROM EMP
WHERE ENAME LIKE '%N';
-- ENAME 중에서 N으로 끝나는 ENAME 을 출력
-- 즉, N 앞에는 어떤 문자가 와도 상관없지만 N 뒤엔 문자가 들어가 있으면 안됨


-- 5.2 _ 사용
SELECT *
FROM EMP
WHERE ENAME LIKE '_A%';
-- ENAME 중 A 앞에 무조건 한글자가 있고 A 뒤에는 몇글자가 나오든 상관없는 ENAME 출력
-- 즉, A가 두번째 글자인 ENAME 출력한다.

SELECT *
FROM EMP
WHERE ENAME LIKE '__A%';
-- ENAME 중 A 앞에 무조건 두글자가 있고 A 뒤에는 몇글자가 나오든 상관없는 ENAME 출력
-- 즉, A가 세번째 글자인 ENAME 출력한다.


-- 5.3 NOT LIKE 연산자
SELECT *
FROM EMP
WHERE ENAME NOT LIKE '%A%';
-- ENAME 중 A 글자가 들어가있지 않는 ENAME 출력


-- 6. NULL 위한 연산자
SELECT *
FROM EMP
--WHERE COMM=NULL;
--WHERE COMM IS NULL;
-- COMM 칼럼의 값이 NULL 인지 물어보고 NULL 인 애들 출력
WHERE COMM IS NOT NULL;
-- COMM 칼럼의 값이 NULL 이 아닌지 물어보고 NULL 이 아닌 애들 출력



-- 7. 정렬을 위한 ORDER BY절
-- 하나의 줄을 '절' 이라고 한다.
-- SELECT *  <-- 이건 SELECT 절
-- FROM EMP   <-- 이건 FROM 절
-- WHERE COMM IS NOT NULL  <-- 이건 WHERE 절
-- 이 외에도 '정렬 절' 이란걸 여기에 추가로 적을 수 있다!!
SELECT *
FROM EMP
--ORDER BY SAL ASC;
-- SAL 기준으로 오름차순 정렬을 한 것이 출력
-- ASC 오름차순은 디폴트이기 때문에 ASC를 생략해서 적어도 오름차순 한걸 출력해준다.
ORDER BY SAL;

SELECT *
FROM EMP
ORDER BY SAL DESC;


SELECT *
FROM EMP
ORDER BY ENAME;
-- ENAME 기준으로 오름차순

SELECT *
FROM EMP
ORDER BY HIREDATE DESC;
-- HIREDATE 기준으로 내림차순

SELECT *
FROM EMP
ORDER BY SAL DESC, ENAME ASC;
-- SAL 을 내림차순으로 정렬한 후 ENAME을 오름차순으로 정렬하여 출력




-- 4장 과제제출
-- 1번.
SELECT *
FROM EMP
ORDER BY HIREDATE DESC, EMPNO ASC;

-- 2번.
SELECT *
FROM EMP
WHERE ENAME LIKE 'K%';

--3번.
SELECT *
FROM EMP
WHERE ENAME LIKE '%K%';

--4번.
SELECT *
FROM EMP
WHERE ENAME LIKE '%K_';





-- 5-1. DUAL 테이블 : 산술연산의 결과를 한 줄로 얻기 위해 사용한다.
SELECT * FROM DUAL;
SELECT 24*60 FROM EMP;
-- EMP 테이블은 14개의 로우를 가지고 있어서 14개의 24*60의 값이 출력된다.
SELECT 24*60 FROM DEPT;
-- DEPT 테이블은 5개의 로우를 가지고 있어서 5개의 24*60의 값이 출력된다.

SELECT 24*60 FROM DUAL;
-- 24*60 의 값을 하나만 얻으면 되니깐 이럴 때는 DUAL 테이블을 이용해서 값을 얻으면 좋다.

SELECT SYSDATE FROM DUAL;
-- SYSDATE 는 현재의 날짜를 출력해준다. (22/12/13) 출력



-- 5.2 숫자 함수
-- (1) ABS 함수 : 절댓값 구하기
SELECT -10, ABS(-10) FROM DUAL;

-- (2) FLOOR 함수 : 소수점 버려서 실수를 정수로 만들기
SELECT 34.5678, FLOOR(34.5678) FROM DUAL;
--SELECT FLOOR(34.5678, 2), FLOOR(34.5678, -1), FLOOR(34.5678) FROM DUAL;


-- (3) ROUND 함수 : 특정 자리수에서 소수점 반올림하기
SELECT 34.5678, ROUND(34.5678) FROM DUAL;
SELECT 34.5678, ROUND(34.5678, 2) FROM DUAL;
-- ROUND(34.5678, 2) : 반올림해서 소수점 2번째까지만 출력
SELECT 34.5678, ROUND(34.5678, -1) FROM DUAL;


-- (4) TRUNC 함수 : 특정 자리수 잘라내기
SELECT TRUNC(34.5678, 2), TRUNC(34.5678, -1), TRUNC(34.5678) FROM DUAL;


-- (5) MOD 함수 : 나머지 구하기
SELECT MOD(27,2), MOD(27,5), MOD(27,7) FROM DUAL;
-- MOD(27,2) : 27을 2로 나누어서 나오는 나머지 출력 -> 1
-- MOD(27,5) : 27을 5로 나누어서 나오는 나머지 출력 -> 2
-- MOD(27,7) : 27을 7로 나누어서 나오는 나머지 출력 -> 6



-- 5.3 문자 처리 함수
-- (1) UPPER 함수 : 모두 대문자로 변환
SELECT 'Welcome to Oracle', UPPER('Welcome to Oracle') FROM DUAL;

-- (2) LOWER 함수 : 모두 소문자로 변환
SELECT 'Welcome to Oracle', LOWER('Welcome to Oracle') FROM DUAL;

-- (3) INITCAP 함수 : 문자열의 이니셜만 (즉, 각 문자열의 처음을) 대문자로 변환
SELECT 'WELCOME TO SOUTH KOREA', INITCAP('WELCOME TO SOUTH KOREA') FROM DUAL;

-- (4) LENGTH 함수 : 컬럼에 저장된 데이터 값이 몇개의 문자로 구성되어있는지 길이 알려주는 함수 --> 사용할 일 거의 없다!!
--                  공백도 길이에 포함된다.
SELECT LENGTH('SOUTH KOREA'), LENGTH('대한민국') FROM DUAL;


-- (5) LENGTHB 함수 : 바이트 수를 알려주는 함수
-- 한글 1자 = 3바이트
SELECT LENGTHB('Oracle'), LENGTHB('오라클') FROM DUAL;
-- LENGTHB('Oracle') : 6 출력  /  LENGTHB('오라클') : 9 출력
-- 한글 3자로 구성된 '오라클'의 LENGTHB 함수 결과는 9
SELECT LENGTHB('Oracle'), LENGTHB('현지는최고야') FROM DUAL;
-- LENGTHB('현지는최고야') : 18 출력
-- 가변형!! 글자의 수가 3개라도 바이트수가 9개인건 가변형이다!!
-- UTF-8 로 기본 세팅이 되어 있다.


-- (6) SUBSTR, SUBSTRB 함수 : 중요!
-- SUBSTR 함수 : 대상 문자열이나 칼럼의 자료에서 시작위치부터 선택 개수만큼의 문자를 추출
-- SUBSTRB 함수 : 대상 문자열이나 칼럼의 자료에서 시작위치부터 선택 개수만큼의 바이트 수를 추출 
SELECT SUBSTR('Welcome to Oracle', 4, 3) FROM DUAL;
-- 문자열에서 W은 1이고 공백포함 하나씩 증가한다. 그래서 문자열 4번째부터 3개 추출해서 출력해준다.


-- (7) INSTR 함수 : 대상 문자열이나 칼럼에서 특정 문자가 나타나는 위치 반환
SELECT INSTR('WELCOME TO ORACLE', 'O') FROM DUAL;
-- WELCOME TO ORACLE 에서 문자열 O 가 몇번째에 있는지 알려줌
-- 맨 처음으로 있는 문자열 O는 5번째에 있다 -> 5출력됨
SELECT INSTR('WELCOME TO ORACLE', 'ORACLE') FROM DUAL;  -- 12 출력


-- (8) INSTRB 함수
SELECT INSTR('데이터베이스', '이', 3, 1), INSTRB('데이터베이스', '이', 3, 1) FROM DUAL;
-- INSTR('데이터베이스', '이', 3, 1) : 문자열에서 3번째부터 시작해서 '이' 문자열이 맨 처음으로 나오는 번째수
-- INSTRB('데이터베이스', '이', 3, 1) : ???
SELECT INSTR('데이터베이스', '이'), INSTRB('데이터베이스', '이', 3, 1) FROM DUAL;
SELECT INSTR('데이터베이스', '이'), INSTRB('데이터베이스', '이', 4, 1) FROM DUAL;
SELECT INSTR('데이터베이스', '이'), INSTRB('데이터베이스', '이', 5, 1) FROM DUAL;



-- (9) 여백추가 함수 : LPAD(LEFT PADDING) 함수 : 왼쪽에 함수를 둬라 / RPAD 함수 : 오른쪽에 여백을 둬라
SELECT LPAD('Oracle', 20, '#') FROM DUAL;
-- 왼쪽에 여백을 두는데 전체 길이는 20이 되고 왼쪽 여백을 #로 채워라
SELECT RPAD('Oracle', 20, '#') FROM DUAL;
-- 오른쪽에 여백을 두는데 전체 길이는 20이 되고 오른쪽 여백을 #로 채워라
SELECT LPAD('Oracle', 20, ' ') FROM DUAL;
-- 왼쪽에 여백을 두는데 전체 길이는 20이 되고 왼쪽 여백을 빈공간 ' '로 채워라


-- (10) 여백삭제 함수 : LTRIM와 RTRIM 함수
SELECT LTRIM('     Oracle  ') FROM DUAL;
-- 왼쪽 여백은 지우고 오른쪽 여백은 남은 채 출력
SELECT RTRIM('     Oracle  ') FROM DUAL;
-- 오른쪽 여백은 지우고 왼쪽 여백은 남은 채 출력

-- (11) TREIM 함수
SELECT TRIM('A' FROM 'AAAAAAORACLEAAA') FROM DUAL;
-- A 문자는 모두 다 지운 문자열 출력 -> ORACLE 만 출력된다.



--5.4 날짜 함수 --> 자주 사용한다!! 중요,,?!
-- (1) SYSDATE 함수
SELECT SYSDATE FROM DUAL;

-- (2) 날짜 연산
--SELECT SYSDATE-1 어제, SYSDATE 오늘, SYSDATE+1 내일 FROM DUAL;
SELECT SYSDATE-1 "어제", SYSDATE "오늘", SYSDATE+1 "내일" FROM DUAL;
-- " " 안적고 그냥 어제, 오늘, 내일로 적어서 실행해도 똑같이 출력된다.


-- (3) 반올림 함수 : ROUND 함수
SELECT HIREDATE, ROUND(HIREDATE, 'MONTH') FROM EMP;
-- 일이 15일 지나면 반올림 되어서 2월이던게 3월로 반올림 된다
-- ex) 02/ 19  --> 03/01 이 된다.


-- (4, 5, 6, 7, 8) 스킵!!


-- 5.5 형 변환 함수 !!! 중요 또 중요!!!

-- 1. 문자형으로 변환하는 TO_CHAR 함수
-- (1-1) 날짜형 -> 문자형 변환하기 : TO_CHAR 함수
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS') FROM DUAL;
-- 원래 SYSDATE 객체에는 시, 분, 초 까지 다 가지고 있다.



-- (1-2) 숫자형 -> 문자형 변환 : TO_CHAR 함수
SELECT TO_CHAR(123456, '0000000000'), TO_CHAR(123456, '999,999,999') FROM DUAL;
-- TO_CHAR(123456, '0000000000') : 123456을 10자리 문자형으로 -->  0000123456
-- TO_CHAR(123456, '999,999,999') :                         -->      123,456



-- 2. 날짜형으로 변환하는 TO_DATE 함수
-- (1) 숫자형 -> 날짜형 (NUMBER -> DATE)
SELECT ENAME, HIREDATE FROM EMP
WHERE HIREDATE=TO_DATE(19810220,'YYYYMMDD');
-- 숫자 19810220 를 날짜형 YYYYMMDD 으로 변환한 HIREDATE 와 그에 해당하는 사람의 ENAME 같이 출력

-- (2) 문자형 -> 날짜형 (CHAR -> DATE)
SELECT TRUNC(SYSDATE - TO_DATE('2022/11/02', 'YYYY/MM/DD'))FROM DUAL;
-- '2022/11/02' 문자를 YYYY/MM/DD 날짜형으로 바꿔서 SYSDATE인 오늘 날짜로부터 뺀 수 를 출력
--SELECT TRUNC(SYSDATE - TO_DATE('2022-11-02', 'YYYY-MM-DD'))FROM DUAL;
-- 위와 같이 적어도 문자형에서 날짜형으로 변환이 된다.


-- 3. 숫자형으로 변환하는 TO_NUMBER 함수
-- (1) 문자형 -> 숫자형 (CHAR -> NUMBER)
SELECT TO_NUMBER('20,000', '99,999') - TO_NUMBER('10,000', '99,999') FROM DUAL;
-- '20,000' 문자열을 99,999 숫자형으로 바꾸고 '10,000' 문자를 99,999 숫자형으로 바꿔서 뺀 수를 출력
--SELECT TO_NUMBRT('2022/12/13', '999,999,999') FROM DUAL;



-- 여기부분은 잊어라.,,---------------------------------------------------------------
CREATE TABLE TESTTIME(
    REGDATE DATE
);
-- 칼럼 REGDATE 에는 DATE 타입만 들어간다.

SELECT * FROM TESTTIME;
DESC TESTTIME;
INSERT INTO TESTTIME VALUES('2022/12/13');
INSERT INTO TESTTIME VALUES(20221213); -- 숫자 20221213 은 삽입이 안된다.
INSERT INTO TESTTIME VALUES(SYSDATE); -- SYSDATE는 오늘 날짜 이므로 들어간다

SELECT * FROM TESTTIME;
SELECT TO_CHAR(REGDATE, 'YYYY-MM-DD HH24:MI:SS') FROM TESTTIME;
-- 우리가 원하는 포멧 'YYYY-MM-DD HH24:MI:SS' 으로 출력하게 만든것
-------------------------------------------------------------------------------------

-- 5.6 NULL을 다른 값으로 변환하는 NVL 함수
SELECT ENAME, SAL, COMM, SAL*12+COMM, NVL(COMM,0), SAL*12+NVL(COMM,0)
FROM EMP;


-- 5.7 선택을 위한 DECODE 함수 : 자바의 switch 문과 같은 역할
SELECT * FROM EMP;
SELECT * FROM DEPT;
SELECT ENAME, DEPTNO, DECODE(DEPTNO, 10, 'ACCOUNT',
                                     20, 'RESEARCH',
                                     30, 'SALES',
                                     40, 'OPERATIONS') AS DNAME
FROM EMP;                                  
-- DEPTNO 이 10이면 ACCOUNT로, 20이면 RESEARCH로 30이면 SALES로, 40이면 OPERATIONS로 출력해라


-- 5.8 CASE WHEN 함수 : 자바에서의 if-else 문과 같은 역할
SELECT ENAME, DEPTNO, CASE WHEN DEPTNO=10 THEN 'ACCOUNTING'
                           WHEN DEPTNO=20 THEN 'RESEARCH'
                           WHEN DEPTNO=30 THEN 'SALES'
                           WHEN DEPTNO=40 THEN 'OPERATIONS'
                           END AS DNAME
FROM EMP;






-- 5장 과제 (05-01 에서 1~4번)

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





