
-- 1
SELECT * FROM employee WHERE first_name LIKE '%x';
-- Deleting Employee whose first name ends with "even"
DELETE FROM employee WHERE first_name like'%even';
select * from employee WHERE first_name LIKE '%even';

-- 2
-- Selecting 3 Employees who has minimum salary 
select * from employees order by salary limit 3; 

-- 3
-- Creating employee and coping data from employees
create table employee as select * from employees;
select * from employee;
-- deleting employees 
truncate table employees;
select * from employees;

-- 5
-- Selecting employee's full name , email and hire year whose hire year is before 2000
select (concat_ws(' ', first_name, last_name)) as full_name, email, year(hire_date) as hire_year from employee where hire_year < 2000;

-- 6
select * from job_history;
-- Selecting employee's and job_id whose 
select employee_id, job_id,start_date from job_history where year(start_date) between 1990 and 1999;

-- 7
-- selecting first occurrence of the letter 'A' in each employees Email ID
select employee_id, email, charindex('A',email,1) as letter_position from employee;

-- 8
-- selecting employee whose full name is less than 12
select employee_id, concat(first_name,' ',last_name) as full_name, email from employee where length(full_name)<12;

-- 9
-- adding unq id in employee table
alter table employee add unq_id varchar(100);
describe table employee;
-- hyphenating the first name, last name , and email
SELECT employee_id, first_name, concat_ws(' - ', first_name, last_name, email) AS unq_id from employee;
select unq_id from employee;

-- 10
-- updating the size of email column to 30
alter table employee modify email varchar(30);
describe table employee;
-- 11

update locations set city = 'London' from departments join employee on departments.department_id = employee.department_id
where departments.location_id = locations.location_id and employee.first_name like '%Diana';
 select * from locations ;

-- select * from locations;
-- 12
-- selecting employees with their first name , email , phone and extension
SELECT FIRST_NAME,PHONE_NUMBER,EMAIL,SUBSTR(PHONE_NUMBER,0,(LENGTH(PHONE_NUMBER) - CHARINDEX('.',REVERSE(PHONE_NUMBER)))) AS PHONE, SPLIT_PART
(PHONE_NUMBER,'.','-1') AS EXTENSION FROM employee;

-- 13
-- selecting the employee with second and third maximum salary with and without using top/limit keyword

SELECT * FROM EMPLOYEE ORDER BY SALARY DESC OFFSET 1 ROWS FETCH FIRST 2 ROWS ONLY;

-- 14
-- selecting top 3 highly paid employees who are in department Shipping and IT
select top 3* from employee where department_id in (50,60) order by salary desc;

-- 15
-- selecting employee id and the positions(jobs) held by that employee
select employee.employee_id, jobs.job_title from employee, jobs, job_history 
where employee.employee_id=job_history.employee_id and jobs.job_id=job_history.job_id union
select employee.employee_id, jobs.job_title from employee, jobs where employee.job_id=jobs.job_id
order by employee_id;

-- 16
-- Display Employee first name and date joined as WeekDay, Month Day, Year
select first_name,concat(to_char(hire_date, '%A'),', ',to_char(hire_date, 'MMMM'),' ',day(hire_date),', ',year(hire_date)) as join_date from employee;

--17
--The company holds a new job opening for Data Engineer (DT_ENGG) with a minimum salary of 12,000 and maximum salary of 30,000 . The job position might be removed based on market trends
alter session set autocommit=false;
start transaction;
insert into jobs values('DT_ENGG','Data Engineer',12000,30000);
--saving the changes
commit;
select * from jobs;
--update the maximum salary to 40,000 .
update jobs set max_salary=40000 where job_id='DT_ENGG';
rollback;
select * from jobs;
-- delete from jobs where job_title='Data Engineer';

--18
--to Find the average salary of all the employees who got hired after 8th January 1996 but before 1st January 2000 and round the result to 3 decimals
select round(avg(salary),3) as Average_salary from employee where hire_date between '1998-1-9' and '1999-12-31';

--19
--displaying all the regions
select region_name from regions union all select('Antartica') union all select('Australia') union all select('Asia') union all select('Europe');
--displaying region_name that are unique
select region_name from regions union select('Antartica') union select('Australia') union select('Asia') union select('Europe');

--20
--to remove the employees table from the database
drop table employees;
