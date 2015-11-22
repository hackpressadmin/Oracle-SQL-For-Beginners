-- Almost all examples in real life involve more than one function in SQL. Also, as we have seen in the course,
-- there is usually more than one way to arrive at the same result. Using Oracle 11gr2 functions reference and
-- the examples from the course videos, write SQL queries for the below problems. The table which has the
-- data for the problem is provided at the beginning of each question.

-- 1) [scott.emp] -> Get the employee id, employee name, salary, commission and the final payout of each
-- employee. Final payout is calculated as (salary + commission) and a blank/null commission value can be
-- treated as zero. Try solving the problem using nvl, then nvl2 and then coalesce. (3 different queries, same
-- expected output). Here is the data for the first few employees. Format employee name as shown below
-- (first letter capitalized).

-- please note that is is purely for exercise sake. 
-- Using nvl2 and coalesce in this case doesn't give good understandable code, although it solves the problem

--nvl
select empno, 
       initcap(ename) ename,
       sal, 
       comm, 
       sal + nvl(comm,0) final_payout
from scott.emp;

--nvl2
select empno, 
       initcap(ename) ename,
       sal, 
       comm, 
       nvl2(comm,sal+comm,sal) final_payout
from scott.emp;

--coalesce
select empno, 
       initcap(ename) ename,
       sal, 
       comm, 
       coalesce(sal+comm, sal) final_payout
from scott.emp;

-- 2) [scott.emp] Modify the query in (1) to add the following columns and attributes. Note that the format of
-- dates and salaries have changed. Make sure your output matches the exact format shown below. 

select empno, 
       initcap(ename) ename,
       to_char(hiredate,'dd-mon-yyyy') hiredate, 
       to_char(sal + nvl(comm,0),'$9,999.99') final_payout
from scott.emp;

EMPNO	ENAME	HIREDATE	FINAL_PAYOUT
------------------------------------------
7839	King	17-nov-1981	 $5,000.00
7566	Jones	02-apr-1981	 $2,975.00
7788	Scott	09-dec-1982	 $3,000.00

-- 3) [hr.employees] Each month, our company sends out (work) anniversary cards to employees whose hire
-- dates fall in that month. Write a query which will give the details of all the employees celebrating work
-- anniversaries that month. When I run the query in January, these are the results. Change formatting, so
-- that output matches the format below.

The trick here is to understand that you could extract month component of a date using to_char(date_column,'month').
Usually, we use it to char of a date to get all the date parts (date, month and year), but we can get individual parts too.

**Please note the final answer depends on the month you are running.**

select employee_id, hire_date
from hr.employees
where to_char(hire_date,'month') = to_char(sysdate,'month');

-- 4) [hr.employees] The company also awards people when they complete 10, 20 and 30 years in the
-- company. For each employee, display the hire date and other details in the format below .Show the dates
-- on which they would complete 10, 20 and 30 years of service.

There are multiple functions you can use for this, depending on your database version and what is available.
I have used 2 of the possible functions here.

select employee_id, 
       first_name, 
       hire_date, 
       hire_date + interval '10' year "10 Year Anniversary",
       hire_date + interval '20' year "20 Year Anniversary",
       add_months(hire_date, 30*12)   "30 Year Anniversary"
from hr.employees;

EMPLOYEE_ID	FIRST_NAME	HIRE_DATE	10 Year Anniversary	20 Year Anniversary	30 Year Anniversary
------------------------------------------------------------------------------------------------
100			Steven		17-JUN-1987	17-JUN-1997			17-JUN-2007			17-JUN-2017
101			Neena		21-SEP-1989	21-SEP-1999			21-SEP-2009			21-SEP-2019
102			Lex			13-JAN-1993	13-JAN-2003			13-JAN-2013			13-JAN-2023
103			Alexander	03-JAN-1990	03-JAN-2000			03-JAN-2010			03-JAN-2020
104			Bruce		21-MAY-1991	21-MAY-2001			21-MAY-2011			21-MAY-2021
.....................

-- 5) [oe.orders] : The holiday months (November and December) usually have the highest sale
-- in a given year. Can you verify if this is correct for the sales data that we have in our database? (The data
-- grouped below if for all years)

The highest revenue months are June and July.

select to_char(order_date,'Month') order_month, sum(order_total)
from oe.orders
group by to_char(order_date,'Month')
order by sum(order_total) desc;

ORDER_MONTH	SUM(ORDER_TOTAL)
-----------------------------
June     	571885.7
July     	422663.4
November 	406868.4
September	386649.7
May      	370844.6
December 	338672
February 	322291.1
March    	321248.7
August   	247356.5
January  	197228.8
October  	80709.8
April    	1636

-- 6) [oe.customers] : Oracle SUBSTR function lets you extract a part of a string based on the input
-- parameters. Read through the documentation and understand how it works. Then using substr and the
-- logical function CASE, try to answer the query below.

-- As part of profiling customers, we want to divide them into various groups based on their income levels, so
-- that we can market the right kind of products. Here’s is the profiling given by the business user. Can you
-- write a query to divide customers based on the following rules.

-- Income_level : (Based on the first letter in the income_level column)

--  A->D : high volume customers,
--  E->H : high income customers,
--  I->L : ultra high income customers

select customer_id,
       cust_first_name,
       income_level,
       case when substr(income_level,'1') between 'A' and 'D'
            then 'high volume customers'
            when substr(income_level,'1') between 'E' and 'H'
            then 'high income customers'
            when substr(income_level,'1') between 'I' and 'L'
            then 'ultra high income customers'
       end customer_segment
from oe.customers;

CUSTOMER_ID	CUST_FIRST_NAME	INCOME_LEVEL		CUSTOMER_SEGMENT
-------------------------------------------------------------
262			Fred			B:30,000 - 49,999	high volume customers
348			Kelly			J:190,000 - 249,999	ultra high income customers
496			Scott			K:250,000 - 299,999	ultra high income customers
152			Dieter			J:190,000 - 249,999	ultra high income customers
..........

-- 7) Using only oracle functions (no hard-coded dates ), get the current date (sysdate), current year, month,
-- day of the week in the format below. Refer to the Oracle documentation for help.

As you would expect, your actual results might vary based on your sysdate

select to_char(sysdate,'dd-mon-yyyy') just_the_date,
       to_char(sysdate,'dd-mon-yyy HH24:MI:SS') date_and_time,
       to_char(sysdate,'dd') day,
       to_char(sysdate,'mm') month,
       to_char(sysdate,'MON') month_abbr,
       to_char(sysdate,'month') month_in_words,
       to_char(sysdate,'yyyy')  year,
       to_char(sysdate,'w') week_of_year
from   dual;

-- 8) [hr.employees] : Using the concat function or the pipe operator (||) get the full name of each of the employee in the company. 
-- Using date and number functions also get the tenure of each employee in years and months. 
-- Your data for tenure will vary based on the date on which you are running the query. 
-- Check the difference between sysdate and hire_date to validate the results.

**Please note that your answer would be different based on when you are running the query.**

select employee_id, 
       first_name || ' ' || last_name full_name,
       to_char(hire_date,'dd-mon-yyyy') hire_date,
       to_char(sysdate,'dd-mon-yyyy') today,
       trunc(months_between(sysdate,hire_date)/12) years,
       trunc(mod(months_between(sysdate,hire_date),12)) months
from hr.employees;

-- 9) Get the value for sale price using each of the following functions. (Nvl, coalesce, decode, case). Logic:
-- If list_price is available, then 90% of list price. If list_price is not available and min_price is available, the use
-- min_price. If list_price and min_price are null, use 5 as the sale_price. Here’s the example using nvl and
-- coalesce. The below customer ids below cover all possible scenarios.

-- *As you can expect, this is a very contrived example. 
-- In real-life, problems like this one are solved using case, which is equivalent of if-then-else in SQL.

select 	product_id,
		list_price,
		min_price,
		nvl( 
      		nvl(list_price*0.9, min_price)
    	,5) sale_price_nvl,
		nvl2( 
      		nvl2(list_price, list_price*0.9, min_price),
      		nvl2(list_price, list_price*0.9, min_price)
    	, 5) sale_price_nvl2,
		coalesce(list_price*0.9, min_price, 5) sale_price_coalesce
from    product_information
where product_id in (1769, 3355, 1770, 3091, 1787);

PRODUCT_ID	LIST_PRICE	MIN_PRICE	SALE_PRICE_NVL	SALE_PRICE_NVL2	SALE_PRICE_COALESCE
---------------------------------------------------------------------------------------
1769		48						43.2			43.2			43.2
1770					73			73				73				73
1787		101			90			90.9			90.9			90.9
3091		279			243			251.1			251.1			251.1
3355								5				5				5
