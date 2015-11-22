-- 1. Using the hr.employees table which has the information about all the employees in our
-- company, see if you can answer the following questions.

-- a. The first date and the last date any employee was hired. Alias the column names as
-- shown in the headings below.

alter session set nls_date_format = 'dd-mon-yyyy hh24:mi:ss';

select min(hire_date) first_employee_hired_on,
       max(hire_date) latest_employee_hired_on
from hr.employees;

FIRST_EMPLOYEE_HIRED_ON	LATEST_EMPLOYEE_HIRED_ON
-------------------------------------------------
17-JUN-1987				21-APR-2000

-- b. Find the minimum, maximum and the average salary of all the employees in the
-- company.

select min(salary) least_salary,
       max(salary) highest_salary,
       avg(salary) average_salary
from hr.employees;

LEAST_SALARY	HIGHEST_SALARY	AVERAGE_SALARY
-------------------------------------------------------
2100			24000			6461.682242990654205607476635514018691589

-- c. Change the query condition in (a) to give the same results by department, instead of the
-- whole company. You can use the department_id column in your query to do this.

select department_id,
       min(hire_date) first_employee_hired_on,
       max(hire_date) latest_employee_hired_on
from   hr.employees
group by department_id;

DEPARTMENT_ID	FIRST_EMPLOYEE_HIRED_ON	LATEST_EMPLOYEE_HIRED_ON
------------------------------------------------------------------
100				16-AUG-1994				07-DEC-1999
30				07-DEC-1994				10-AUG-1999
				24-MAY-1999				24-MAY-1999
90				17-JUN-1987				13-JAN-1993
20				17-FEB-1996				17-AUG-1997
70				07-JUN-1994				07-JUN-1994
110				07-JUN-1994				07-JUN-1994
50				01-MAY-1995				08-MAR-2000
80				30-JAN-1996				21-APR-2000
40				07-JUN-1994				07-JUN-1994
60				03-JAN-1990				07-FEB-1999
10				17-SEP-1987				17-SEP-1987

-- d. Change the query in (b) to get the minimum, maximum and average salary per
-- department.

select department_id,
       min(salary) least_salary,
       max(salary) highest_salary,
       avg(salary) average_salary
from hr.employees
group by department_id;

DEPARTMENT_ID	LEAST_SALARY	HIGHEST_SALARY	AVERAGE_SALARY
100	6900	12000	8600
30	2500	11000	4150
	7000	7000	7000
90	17000	24000	19333.3333333333333333333333333333333333
20	6000	13000	9500
70	10000	10000	10000
110	8300	12000	10150
50	2100	8200	3475.555555555555555555555555555555555556
80	6100	14000	8955.882352941176470588235294117647058824
40	6500	6500	6500
60	4200	9000	5760
10	4400	4400	4400

-- 2. Oracle’s aggregate functions ignore nulls during calculations. Confirm this by running the
-- following queries and making sure they give the same output.

-- select avg(comm) from scott.emp;
-- select avg(comm) from scott.emp where comm is not null;

select avg(comm) from scott.emp;

AVG(COMM)
---------
550

-- select avg(comm) from scott.emp where comm is not null;

AVG(COMM)
---------
550

-- Modify one of the appropriate queries above to get both possible values of averages,
-- ignoring nulls and without ignoring nulls. (Hint: count(*) gives you the count of all the
-- rows in the table)

select sum(comm)/count(comm) oracle_default_ignoring_nulls,
       sum(comm)/count(*)    avg_treating_nulls_as_zeros
from scott.emp;

ORACLE_DEFAULT_IGNORING_NULLS	AVG_TREATING_NULLS_AS_ZEROS
------------------------------------------------------------
550								157.142857142857142857142857142857142857

-- 3. The oe.inventories table has the list of products and the quantity available in each
-- warehouse. Write queries to answer the following questions.

-- a. How many warehouses hold the company products?

select count( distinct warehouse_id)  num_of_warehouses
from oe.inventories;

NUM_OF_WAREHOUSES
-----------------
9

-- b. Get the total quantity on hand for products (1734, 1737, 1738, 1739) in all the
-- warehouses combined.

select product_id, 
       sum(quantity_on_hand) total_quantity_on_hand
from oe.inventories
group by product_id
;

-- 4. The oe.orders table aggregated information at the order level. The column
-- orders.order_total has the total order amount of all the items purchased in that order.
-- The order_items table has individual item level details. There are two types of orders.
-- “Direct” and “Online”

-- a. Get the total order amount for each of the order types, using only the oe.orders
-- table.

select order_mode,
       sum(order_total) total_order_amount,
       count(*) total_orders
from  oe.orders
group by order_mode;

ORDER_MODE	TOTAL_ORDER_AMOUNT	TOTAL_ORDERS
---------------------------------------------
direct		1903629.2			73
online		1764425.5			32

-- b. Get the number of orders and the total order amount for all the items purchased
-- using the oe.order_items table. (unit_price * quantity gives you the amount paid
-- for a given order item).

select count(distinct order_id) total_orders,
       sum(unit_price*quantity) total_order_amount
from oe.order_items;

TOTAL_ORDERS	TOTAL_ORDER_AMOUNT
----------------------------------
105	3668054.7

-- 5. Get the details (product_id and revenue) of our top revenue products. Top revenue
-- products are defined as products that have generated more than 100,000 in revenue.

-- Get the details (product_id and revenue) of our top revenue products. Top revenue
-- products are defined as products that have generated more than 100,000 in revenue.

select product_id,
       sum(unit_price*quantity) total_revenue
from oe.order_items
group by product_id
having  sum(unit_price*quantity) > 100000;

PRODUCT_ID	TOTAL_REVENUE
2350	922708.6
3127	364351
2359	180872.8
2252	134079

-- 6. In the given list of products below, get the product_id and revenue for products which
-- have more then $50,000 in sales.
-- Product_ids : 2289, 2264, 2211, 1781, 2337, 2058, 2289

select product_id,
       sum(unit_price*quantity) total_revenue
from oe.order_items
where product_id in (2289, 2264, 2211, 1781, 2337, 2058, 2289)
group by product_id
having  sum(unit_price*quantity) > 5000;

PRODUCT_ID	TOTAL_REVENUE
--------------------------
2289	78099
2264	21901
2337	15424.2

-- 7. A very common question in SQL is how to identify duplicates. In the hr.employee
-- table, how do you identify records where an employee ID is present more than once?
-- (Hint: Count gives you number of records per grouping column). See if you can answer
-- the following questions (no peeking at the answer )
-- http://stackoverflow.com/questions/59232/how-do-i-find-duplicate-values-in-a-table-in-oracle
-- http://www.oratable.com/duplicate-rows-query/

One of the possible queries to to identify duplicates is usually in the following format. 
You could take a look at the stackoverflow answer to see the answer to that question.

select columns-to-group,
	   count(*)
from   table-name
group by columns-to-group
having count(*) > 1;


-- 8. In a sql statement involving group by (aggregation), each column in the select list
-- must either be an aggregate column or must be included in the group by. Otherwise,
-- you’ll see the following error.
-- ORA-00979: not a GROUP BY expression
--  Do the following queries give that error? If they do, can you fix them?

-- Select count(*),
-- Sum(quantity)
-- from oe.order_items;

No, this query does not throw an error, as all the displayed columnns are aggregate columns.

-- select order_id,
-- count(*)
-- from oe.order_items
-- group by product_id;

No, this query does not throw an error, as order_id is in group by and count(*) is an aggregate function. 

-- select order_id,
-- count(*)
-- from oe.order_items;

This query throws an error, since order_id is not an aggregated column/expression, but is missing from group by clause

