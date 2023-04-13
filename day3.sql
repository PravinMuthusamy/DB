SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENTS;
SELECT * FROM JOBS;
SELECT * FROM JOB_HISTROY;
SELECT * FROM LOCATIONS;
SELECT * FROM REGIONS;
SELECT * FROM COUNTRIES;


-- Question 1
-- Write a SQL query to find the total salary of employees who is in Tokyo
-- excluding whose first name is Nancy.

select sum(salary) as Total_Salary
from employee e
join departments d 
on e.department_id = d.department_id
join locations l 
on l.location_id = d.location_id
where lower(city) = 'seattle'
and
lower(e.first_name) <> 'nancy';

-- Question 2
-- Fetch all details of employees who has salary more than the avg salary
-- by each department.
select * from employee e join 
(select emp.department_id ,avg(salary) as salary from employee emp group by emp.department_id) e1
on (e.department_id = e1.department_id and  e.salary > e1.salary ) order by e.salary;

-- Question 3
-- Write a SQL query to find the number of employees and its location whose salary is greater than or equal to 7000 and less than 10000
select loc.city, count(employee.employee_id) as employee_count
from departments as dept 
join locations as loc 
on dept.location_id = loc.location_id 
join employee 
on employee.department_id = dept.department_id 
where employee.salary >= 7000 and employee.salary < 10000 group by city ;

-- Question 4
-- Fetch maxsalary,minsalary and avgsalary by job and department. 
-- Info: grouped by department id and job id ordered by department id
-- and max salary.
select max(employee.salary) as max_sal,min(employee.salary) as min_salary,avg(employee.salary) as average_salary,department_id,job_id
from employee
group by department_id,job_id
order by (department_id,max_sal);

-- Question 5
-- Write a SQL query to find the total salary of employees whose country_id is ‘US’ excluding whose first name is Nancy
select
sum(employee.salary) as total_salary from employee 
join departments dept
on dept.department_id = employee.department_id 
join locations as location
on location.location_id = dept.location_id
where
country_id='US'
and 
not employee.first_name='Nancy';

-- Question 6
-- Fetch max salary,min salary and avg salary by job id and department id but only for folks who worked in more than one role(job) in a department.

select j1.department_id, j1.job_id, MAX(e.salary) as max_sal, MIN(e.salary) as min_sal, AVG(e.salary) as avg_sal 
from job_history j1 
join job_history j2  
on j1.employee_id = j2.employee_id and j1.department_id = j2.department_id and j1.job_id != j2.job_id 
join employee e 
on j1.employee_id = e.employee_id 
group by j1.job_id,j1.department_id;

-- Question 7
-- Display the employee count in each department and also in the same result.
-- Info: * the total employee count categorized as "Total"
-- • the null department count categorized as "-" *
-- SELECT COALESCE(TO_VARCHAR(e.department_id), '-') as department_id,
--        COUNT(*) as employee_count 
-- FROM  employee e
-- GROUP BY e.department_id;
SELECT COALESCE(TO_VARCHAR(e.department_id), '-') as department_id,
       COUNT(*) as employee_count 
FROM  employee e
GROUP BY e.department_id

UNION

SELECT 'Total' as department_id,
       COUNT(*) as employee_count 
FROM employee;


-- Question 8
-- Display the jobs held and the employee count.
-- Hint: every employee is part of at least 1 job Hint: use the previous questions answer Sample
-- JobsHeld EmpCount 
-- 1 100 
-- 2  4
select cnt,count(cnt) as employee_count from
(
(select employee_id,count(employee_id) as cnt from job_history group by employee_id )
union 
(select employee_id,count(employee_id) as cnt from employee group by employee_id order by employee_id)
)
group by cnt;
-- SELECT employee_id, COUNT(*) as employee_count
-- FROM (
--   SELECT employee_id
--   FROM job_history
--   INTERSECT
--   SELECT employee_id
--   FROM employee
-- ) t
-- GROUP BY employee_id;

-- Question 9
-- Display average salary by department and country.
select c.country_name,dept.department_id,avg(emp.salary) as employee_salary
from employee emp 
join departments dept
on emp.department_id = dept.department_id
join locations loc 
on dept.location_id = loc.location_id
join countries c
on c.country_id = loc.country_id
group by c.country_name,dept.department_id order by c.country_name; 

-- Question 10
-- Display manager names and the number of employees reporting to them by countries (each employee works for only one department, and each department belongs to a country)
select concat(e2.first_name,' ',e2.last_name) as manager_name , count(e1.manager_id) as Employees_Reporting,c.country_name
from employee e1
join departments dept
on e1.department_id = dept.department_id
join locations loc
on dept.location_id = loc.location_id
join countries c 
on c.country_id = loc.country_id
join employee e2 
on e2.employee_id = e1.manager_id
group by e1.manager_id, c.country_id, manager_name, c.country_name;
    
-- select count(employee_id) from employee where manager_id = 101;
-- select * from 
-- select * from DEPARTMENTS;
-- select * from countries ;
-- select * from locations;
-- select * from departments;
-- select * from employee where first_name = 'Neena';


-- Question 11
 -- Group salaries of employees in 4 buckets eg: 0-10000, 10000-20000,.. (Like the previous question) but now group by department and categorize it like below.
--  DEPT ID 0-10000 10000-20000 
--  50         2     10
-- 60          6      5
-- SELECT department_id,
--        count(case when salary >= 0 and salary <= 10000 then 1 end) AS "0-10000",
--        count(case when salary > 10000 and salary <= 20000 then 1 end) AS "10000-20000",
--        count(case when salary > 20000 and salary <= 30000 then 1 end) AS "20000-30000",
--        count(case when salary > 30000 then 1 end ) AS "Above 30000"
-- FROM employee
-- GROUP BY department_id;

SELECT department_id,
       SUM(case when salary >= 0 and salary <= 10000 then 1 else 0 end) AS "0-10000",
       SUM(case when salary > 10000 and salary <= 20000 then 1 else 0 end) AS "10000-20000",
       SUM(case when salary > 20000 and salary <= 30000 then 1 else 0 end) AS "20000-30000",
       SUM(case when salary > 30000 then 1 else 0 end) AS "Above 30000"
FROM employee
GROUP BY department_id;

-- Question 12
-- Display employee count by country and the avg salary


select c.country_name,count(*) as employee_count,round(avg(salary),2) as average_sal
from  employee emp 
join departments dept
on emp.department_id = dept.department_id 
join locations loc
on dept.location_id = loc.location_id
join countries c
on c.country_id = loc.country_id 
group by c.country_id,c.country_name;


-- Question 13
-- Display region and the number off employees by department
-- select * from regions;
-- select * from job_history;
-- select * from locations;
-- select * from departments;
-- select * from countries;
-- select * from employee;
-- select r1.region_name,r.department_id,r.num_employees 
-- from regions r1 
-- join (
-- select r.region_id,dept.department_id,count(*) as num_employees 
-- from employee emp 
-- join departments dept
-- on emp.department_id = dept.department_id
-- join locations loc
-- on loc.location_id = dept.location_id
-- join countries c on loc.country_id = c.country_id 
-- join regions r
-- on r.region_id = c.region_id 
-- group by r.region_id,dept.department_id 
-- order by r.region_id,dept.department_id
-- ) r on r1.region_id = r.region_id;

select e.department_id as "Dept ID",
       (case when region_name = 'Americas' then count_of else 0 end) as America,
       sum(case when region_name = 'Europe' then  count_of else 0 end) as Europe,
       sum(case when region_name = 'Asia' then 1 else 0 end) as Asia
from (
select employee.department_id,regions.region_name, count(countries.region_id) as count_of from EMPLOYEE
 join departments on EMPLOYEE.DEPARTMENT_ID=departments.department_id
 join locations on locations.location_id=departments.location_id
 join countries on countries.country_id=locations.country_id
 join regions on regions.region_id=countries.region_id
group by employee.department_id , regions.region_name) as e
group by e.region_name,e.department_id,e.count_of ;

-- Question 14
 -- Select the list of all employees who work either for one or more departments or have not yet joined / allocated to any department
 -- select emp.employee_id,iff(count(emp.department_id)=0, 'Not Yet Joined','Allocated') as status from employee emp group by emp.employee_id,emp.department_id;
 select concat(e.first_name,' ',e.last_name) as full_name from employee e
left join departments d on e.department_id = d.department_id
where d.department_id is null or e.department_id is not null;


 
 -- Question 15
 -- write a SQL query to find the employees and their respective managers. Return the first name, last name of the employees and their managers
 -- select concat(e1.first_name,' ',e1.last_name) as Employee_name,concat(e2.first_name,' ',e2.last_name) as Manager_name from employee e1 join employee e2 on e1.manager_id = e2.employee_id;
 SELECT CONCAT(e1.first_name, ' ', e1.last_name) AS Employee_name,
CONCAT(e2.first_name, ' ', e2.last_name) AS Manager_name
FROM employee e1
LEFT OUTER JOIN employee e2 ON e1.manager_id = e2.employee_id;
 
 -- Question 16
 -- write a SQL query to display the department name, city, and state province for each department.
 -- select dept.department_name,loc.city,loc.state_province from departments dept join locations loc on dept.location_id = loc.location_id;
 SELECT dept.department_name, loc.city, loc.state_province
FROM departments dept
LEFT OUTER JOIN locations loc ON dept.location_id = loc.location_id;

  -- Question 17
  -- write a SQL query to list the employees (first_name , last_name, department_name) who belong to a department or don't
SELECT emp.first_name, emp.last_name, dept.department_name
FROM employee emp 
LEFT JOIN departments dept ON emp.department_id = dept.department_id
WHERE dept.department_name IS NULL OR dept.department_name IS NOT NULL;
  
 -- Question 18
  -- The HR decides to make an analysis of the employees working in every department.
  -- Help him to determine the salary given in average per department and the total number of employees working in a department.
  -- List the above along with the department id, department name
  -- select e1.department_id,dept.department_name,e1.cnt,e1.avg_sal from (select emp.department_id,avg(emp.salary) as avg_sal,count(*) as cnt from employee emp group by emp.department_id) e1
  -- join departments dept on dept.department_id = e1.department_id;
SELECT dept.department_id, dept.department_name, AVG(emp.salary) AS avg_salary, COUNT(emp.employee_id) AS total_employees
FROM departments dept 
JOIN employee emp ON dept.department_id = emp.department_id
GROUP BY dept.department_id, dept.department_name;
  
-- Question 19
-- Write a SQL query to combine each row of the employees with each row of the jobs to obtain a consolidated results. 
-- (i.e.) Obtain every possible combination of rows from the employees and the jobs relation.
select * from employee cross join jobs order by employee_id;

-- Question 20
-- Write a query to display first_name, last_name, and email of employees who are from Europe and Asia
select emp.first_name,emp.last_name,emp.email,c.country_name
from employee emp 
join departments dept 
on emp.department_id = dept.department_id 
join locations loc 
on loc.location_id = dept.location_id 
join countries c 
on c.country_id = loc.country_id
join regions r 
on r.region_id = c.region_id
where lower(region_name in ('europe','asia');

-- Question 21
-- Write a query to display full name with alias as FULL_NAME (Eg: first_name = 'John' and last_name='Henry' - full_name = "John Henry") who are from oxford city and their second last character of their last name is 'e' and are not from finance and shipping department.
select * from locations;
select concat(emp.first_name,' ',emp.last_name) as Full_name from employee emp 
join departments dept
on emp.department_id = dept.department_id 
join locations loc 
on dept.location_id = loc.location_id
where loc.city = 'Oxford' and dept.department_name not in ('Shipping','Finance') and emp.last_name like '%e_';

-- Question 22
-- . Display the first name and phone number of employees who have less than 50 months of experience
select first_name,last_name,phone_number from employee where DATEDIFF(month,hire_date,CURRENT_DATE) < 50;


-- Question 23
-- Display Employee id, first_name, last name, hire_date and salary for employees 
-- who has the highest salary for each hiring year. 
-- (For eg: John and Deepika joined on year 2023, and john has a salary of 5000, and Deepika has a salary of 6500. Output should show Deepika’s details only).
SELECT emp.employee_id, emp.first_name, emp.last_name, emp.hire_date, e.salary
FROM (
SELECT employee_id, first_name, last_name, hire_date, salary,
ROW_NUMBER() OVER (PARTITION BY YEAR(hire_date) ORDER BY salary DESC) AS salary_rank
FROM employee
) emp
JOIN (
SELECT employee_id, salary, YEAR(hire_date) AS yr,
ROW_NUMBER() OVER (PARTITION BY YEAR(hire_date) ORDER BY salary DESC) AS salary_rank
FROM employee
) e ON emp.employee_id = e.employee_id AND YEAR(emp.hire_date) = e.yr
WHERE emp.salary_rank = 1 AND e.salary_rank = 1;
