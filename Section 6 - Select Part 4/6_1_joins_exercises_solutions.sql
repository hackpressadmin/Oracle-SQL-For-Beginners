-- 1. Write a query to display the employee and department details from the SCOTT schema. [ Hint: You’ll
-- need to join the scott.emp and scott.dept table]. Change the column headers so that the results
-- displayed match the screenshot below.

select emp.ename "Employee Name",
       emp.job "Title",
       dept.dname "Department",
       dept.loc "Location"
from   scott.emp,
       scott.dept
where  emp.deptno = dept.deptno;

-- 2. Using the tables in the HR schema, write a query to get the following employee details. To keep it
-- simple, the column names from the result set below are the column names form the database. (Build
-- your query incrementally and verify the counts and the details at each step. Take a look at the table
-- descriptions in sql developer and determine the correct join columns. Click anywhere on the result grid
-- and do a “ctrl+a” to see the entire result set).

select emp.first_name,
       dept.department_name,
       cnt.country_name,
       reg.region_name
from   hr.employees emp,
       hr.departments dept,
       hr.locations loc,
       hr.countries cnt,
       hr.regions reg
where  emp.department_id = dept.department_id
  and  dept.location_id = loc.location_id
  and  loc.country_id = cnt.country_id
  and  cnt.region_id = reg.region_id
order by emp.first_name  ;

-- 3. When you check the count in the hr.employees table, you see that there are 107 rows.

-- But the result from question-2 above only shows 106 rows. Why is one row missing? Can you change the
-- query to use outer joins, so that all 107 rows are displayed? [Bonus] Can you use a filter condition on
-- null columns to see which row was filtered out earlier and why?

--a. to get all rows (107) from the driving table, use left outer join.

select emp.first_name,
       dept.department_name,
       cnt.country_name,
       reg.region_name
from   hr.employees emp,
       hr.departments dept,
       hr.locations loc,
       hr.countries cnt,
       hr.regions reg
where  emp.department_id = dept.department_id (+)
  and  dept.location_id = loc.location_id (+)
  and  loc.country_id = cnt.country_id (+)
  and  cnt.region_id = reg.region_id (+)
order by emp.first_name  ;

-- b. to see which row is being filtered out in the join..
-- we are going to check which joined column is null

select emp.employee_id, /*always useful to add primary key, to avoid confusion with duplicate names, addresses etc */
       emp.first_name, 
       dept.department_name,
       cnt.country_name,
       reg.region_name
from   hr.employees emp,
       hr.departments dept,
       hr.locations loc,
       hr.countries cnt,
       hr.regions reg
where  emp.department_id = dept.department_id (+)
  and  dept.location_id = loc.location_id (+)
  and  loc.country_id = cnt.country_id (+)
  and  cnt.region_id = reg.region_id (+)
  and  (dept.department_id is null or 
  	    loc.location_id is null    or
  	    cnt.country_id  is null    or
  	    reg.region_id   is null
  	   )
order by emp.first_name  ;

EMPLOYEE_ID	FIRST_NAME	DEPARTMENT_NAME	COUNTRY_NAME	REGION_NAME
---------------------------------------------------------------------
178			Kimberely	(null)			(null)			(null)

-- Let's see where the join is breaking...

select department_id from hr.employees where employee_id = 178;

DEPARTMENT_ID
---------------
(null)

-- Kimberly's department id wasn't set, hence her details were missing in out results.

-- 4.From the hr schema, get the following employee and manager details. Verify the counts and details.

-- This kind of join is a self-join (or self-referential join) since we are joining the table to itself, although on different columns.
-- in this case a given employee's manager id is usd to look up the manager's details. (manager is also an employee himself)

select emp.first_name || ' ' || emp.last_name "Employee Name",
       emp.hire_date "Employee Hire date",
       mgr.first_name || ' ' || mgr.last_name "Manager Name",
       mgr.hire_date "Manager Hire Date"
from   hr.employees emp,
       hr.employees mgr
where  emp.manager_id = mgr.employee_id(+)
;

-------------------------------------
-- 5.ANSI version of the same queries
--------------------------------------

-- 1. Write a query to display the employee and department details from the SCOTT schema. [ Hint: You’ll
-- need to join the scott.emp and scott.dept table]. Change the column headers so that the results
-- displayed match the screenshot below.

select emp.ename "Employee Name",
       emp.job "Title",
       dept.dname "Department",
       dept.loc "Location"
from   scott.emp
	   join scott.dept on (emp.deptno = dept.deptno);

-- 2. Using the tables in the HR schema, write a query to get the following employee details. To keep it
-- simple, the column names from the result set below are the column names form the database. (Build
-- your query incrementally and verify the counts and the details at each step. Take a look at the table
-- descriptions in sql developer and determine the correct join columns. Click anywhere on the result grid
-- and do a “ctrl+a” to see the entire result set).

select emp.first_name,
       dept.department_name,
       cnt.country_name,
       reg.region_name
from   hr.employees emp
	   join hr.departments dept on (emp.department_id = dept.department_id)
       join hr.locations loc    on (dept.location_id = loc.location_id)
       join hr.countries cnt    on (loc.country_id = cnt.country_id)
       join hr.regions reg 		on (cnt.region_id = reg.region_id)
order by emp.first_name  ;

-- 3. When you check the count in the hr.employees table, you see that there are 107 rows.

-- But the result from question-2 above only shows 106 rows. Why is one row missing? Can you change the
-- query to use outer joins, so that all 107 rows are displayed? [Bonus] Can you use a filter condition on
-- null columns to see which row was filtered out earlier and why?

--a. to get all rows (107) from the driving table, use left outer join.

select emp.first_name,
       dept.department_name,
       cnt.country_name,
       reg.region_name
from   hr.employees emp
	   left outer join hr.departments dept 		on (emp.department_id = dept.department_id)
       left outer join hr.locations loc    on (dept.location_id = loc.location_id)
       left outer join hr.countries cnt    on (loc.country_id = cnt.country_id)
       left outer join hr.regions reg 		on (cnt.region_id = reg.region_id)
order by emp.first_name  ;

-- b. to see which row is being filtered out in the join..
-- we are going to check which joined column is null

select emp.first_name,
       dept.department_name,
       cnt.country_name,
       reg.region_name
from   hr.employees emp
      left join hr.departments dept  on (emp.department_id = dept.department_id)
      left join hr.locations loc     on (dept.location_id = loc.location_id)
      left join hr.countries cnt     on (loc.country_id = cnt.country_id)
      left join hr.regions reg 		  on (cnt.region_id = reg.region_id)
where  (dept.department_id is null or 
  	    loc.location_id is null    or
  	    cnt.country_id  is null    or
  	    reg.region_id   is null
  	   )
order by emp.first_name  ;

FIRST_NAME	DEPARTMENT_NAME	COUNTRY_NAME	REGION_NAME
--------------------------------------------------------
Kimberely	(null)			(null)			(null)		

-- Let's see where the join is breaking...

select department_id from hr.employees where employee_id = 178;

DEPARTMENT_ID
---------------
(null)

-- Kimberly's department id wasn't set, hence her details were missing in out results.

-- 4.From the hr schema, get the following employee and manager details. Verify the counts and details.

-- This kind of join is a self-join (or self-referential join) since we are joining the table to itself, although on different columns.
-- in this case a given employee's manager id is usd to look up the manager's details. (manager is also an employee himself)

select emp.first_name || ' ' || emp.last_name "Employee Name",
       emp.hire_date "Employee Hire date",
       mgr.first_name || ' ' || mgr.last_name "Manager Name",
       mgr.hire_date "Manager Hire Date"
from   hr.employees emp
       left join hr.employees mgr on (emp.manager_id = mgr.employee_id)
;
