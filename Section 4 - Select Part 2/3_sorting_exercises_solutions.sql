-- 1. Get the details of all the employees in the hr.employee table ordered by
-- the department number first and then sorted by the highest salary first
-- within a department. The first few rows should look like below. Display the
-- department id, employee name and salary

select *
from hr.employees
order by department_id asc, salary desc;

EMPLOYEE_ID	FIRST_NAME	LAST_NAME	EMAIL	PHONE_NUMBER	HIRE_DATE	JOB_ID	SALARY	COMMISSION_PCT	MANAGER_ID	DEPARTMENT_ID
----------------------------------------------------------------------------------------
200	Jennifer	Whalen	JWHALEN	515.123.4444	17-SEP-1987	AD_ASST	4400		101	10
201	Michael	Hartstein	MHARTSTE	515.123.5555	17-FEB-1996	MK_MAN	13000		100	20
202	Pat	Fay	PFAY	603.123.6666	17-AUG-1997	MK_REP	6000		201	20
114	Den	Raphaely	DRAPHEAL	515.127.4561	07-DEC-1994	PU_MAN	11000		100	30
115	Alexander	Khoo	AKHOO	515.127.4562	18-MAY-1995	PU_CLERK	3100		114	30
...

-- 2. See if you can find out the top 5 and bottom 5 products, in terms of sale
-- revenue (amount from the sale) for a given product.

-- Bottom 5

select * from (
  select product_id,
         sum(unit_price*quantity) total_revenue
  from oe.order_items
  group by product_id
  having  sum(unit_price*quantity) > 5000
  order by sum(unit_price*quantity) asc
) where rownum <= 5;

PRODUCT_ID	TOTAL_REVENUE
--------------------------
3064	5085
2467	5179
3091	5282
2536	5370
2394	5480.2

-- top 5:

select * from (
  select product_id,
         sum(unit_price*quantity) total_revenue
  from oe.order_items
  group by product_id
  having  sum(unit_price*quantity) > 5000
  order by sum(unit_price*quantity) desc
) where rownum <= 5;

PRODUCT_ID	TOTAL_REVENUE
---------------------------
2350	922708.6
3127	364351
2359	180872.8
2252	134079
3003	97464.4
