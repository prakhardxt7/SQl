-- Employee and Project Management System: Data Insights and Analysis.
use Emp_mgmt;
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    DepartmentID INT,
    Salary DECIMAL(10, 2),
    ManagerID INT NULL,
    HireDate DATE
);

-- Create Departments table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100),
    Location VARCHAR(100)
);

-- Create Projects table
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100),
    StartDate DATE,
    EndDate DATE
);

-- Create EmployeeProjects table (many-to-many relationship between Employees and Projects)
CREATE TABLE EmployeeProjects (
    EmployeeID INT,
    ProjectID INT,
    HoursWorked INT,
    PRIMARY KEY (EmployeeID, ProjectID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

-- Insert data into Departments
INSERT INTO Departments (DepartmentID, DepartmentName, Location) VALUES
(1, 'HR', 'New York'),
(2, 'IT', 'San Francisco'),
(3, 'Finance', 'Chicago');

-- Insert data into Employees
INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary, ManagerID, HireDate) VALUES
(101, 'John', 'Doe', 2, 90000, NULL, '2020-01-10'),
(102, 'Anna', 'Smith', 2, 85000, 101, '2021-02-15'),
(103, 'Peter', 'Jones', 1, 75000, 101, '2022-03-20'),
(104, 'Mary', 'Taylor', 3, 95000, NULL, '2019-04-25'),
(105, 'David', 'Wilson', 3, 92000, 104, '2023-05-30');

-- Insert data into Projects
INSERT INTO Projects (ProjectID, ProjectName, StartDate, EndDate) VALUES
(1, 'Website Redesign', '2023-01-15', '2023-06-30'),
(2, 'ERP Implementation', '2023-02-01', '2023-12-31'),
(3, 'Mobile App Development', '2022-05-10', '2022-11-30');

-- Insert data into EmployeeProjects
INSERT INTO EmployeeProjects (EmployeeID, ProjectID, HoursWorked) VALUES
(101, 1, 500),
(102, 1, 300),
(102, 2, 400),
(103, 3, 250),
(104, 2, 550),
(105, 3, 200);

-- Insert more data into Departments
INSERT INTO Departments (DepartmentID, DepartmentName, Location) VALUES
(4, 'Marketing', 'Los Angeles'),
(5, 'Operations', 'New York'),
(6, 'Legal', 'San Francisco'),
(7, 'R&D', 'Boston'),
(8, 'Sales', 'Chicago'),
(9, 'Support', 'Seattle'),
(10, 'Procurement', 'Houston');

-- Insert more data into Employees
INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary, ManagerID, HireDate) VALUES
(106, 'Emily', 'Brown', 4, 65000, NULL, '2022-06-01'),
(107, 'James', 'Johnson', 5, 74000, 104, '2019-07-15'),
(108, 'Oliver', 'Davis', 6, 98000, NULL, '2021-01-20'),
(109, 'Sophia', 'Miller', 7, 85000, 104, '2020-08-05'),
(110, 'William', 'Martinez', 8, 72000, 103, '2020-09-14'),
(111, 'Ava', 'Wilson', 9, 69000, 106, '2021-02-12'),
(112, 'Mason', 'Anderson', 10, 88000, NULL, '2021-04-19'),
(113, 'Isabella', 'Thomas', 2, 91000, 101, '2022-10-30'),
(114, 'Ethan', 'Taylor', 1, 87000, 102, '2020-12-22'),
(115, 'Mia', 'Moore', 3, 90000, 105, '2023-01-18');

-- Insert more data into Projects
INSERT INTO Projects (ProjectID, ProjectName, StartDate, EndDate) VALUES
(4, 'New Product Launch', '2023-03-01', '2023-09-30'),
(5, 'Market Expansion', '2023-04-15', '2023-10-31'),
(6, 'AI Research Initiative', '2022-07-01', '2023-12-31'),
(7, 'Cybersecurity Overhaul', '2023-05-20', '2024-01-15'),
(8, 'Supply Chain Optimization', '2023-02-10', '2023-08-30'),
(9, 'Customer Relationship System', '2023-06-01', '2023-12-15'),
(10, 'Mobile Payment Integration', '2022-11-10', '2023-05-20');

-- Insert more data into EmployeeProjects
INSERT INTO EmployeeProjects (EmployeeID, ProjectID, HoursWorked) VALUES
(106, 4, 150),
(107, 4, 250),
(108, 5, 300),
(109, 6, 280),
(110, 7, 210),
(111, 8, 120),
(112, 9, 350),
(113, 10, 400),
(114, 1, 200),
(115, 2, 340);

-- Additional data for previously inserted rows
INSERT INTO EmployeeProjects (EmployeeID, ProjectID, HoursWorked) VALUES
(101, 3, 150),
(102, 4, 160),
(103, 5, 140),
(104, 6, 300),
(105, 7, 190),
(106, 8, 200),
(107, 9, 180),
(108, 10, 220),
(109, 1, 230),
(110, 2, 250);

-- Insights
select * from employees;
select * from departments;
select * from projects;
select * from employeeprojects;


-- 1. Find all employees who have worked on more than 1 project.
-- Basic
select employeeid ,count(projectid) as project_involved from employeeprojects group by employeeid having count(projectid)>1 ;
-- Joins
select e.employeeid,concat(e.firstname,' ',e.lastname) as Fullname ,count(ep.projectid) as total_proj 
from employees e join employeeprojects ep on e.employeeid=ep.employeeid 
group by  e.employeeid,concat(e.firstname,' ',e.lastname) having count(ep.projectid)>1;



-- 2. List the highest paid employee in each department along with their department name.
-- Basic
select  firstname,departmentid,salary from employees e where salary in 
(select max(salary) from employees e1 where e.DepartmentID=e1.DepartmentID ) 
group by departmentid,firstname,salary;
-- using joins
select e.firstname,e.departmentid,d.departmentname,e.salary from employees e join Departments d
on e.DepartmentID=d.DepartmentID where e.salary in (select max(salary) from employees e2 where e.DepartmentID=e2.DepartmentID)
group by e.departmentid,d.departmentname,e.firstname,e.salary;


-- cte and windows
with top_earner as(
select firstname,departmentid,salary,DENSE_RANK() over(partition by departmentid order by salary desc) as rnk
from employees)
select * from top_earner where rnk=1;


-- 3. Retrieve the list of employees who have been hired in the last two years and are not assigned to any projects.

select e.employeeid,e.firstname,count(ep.projectid) as num_prj from Employees e 
left join EmployeeProjects ep on ep.EmployeeID=e.EmployeeID
where hiredate>dateadd(year,-2,getdate())
group by e.employeeid,e.firstname having count(ep.projectid)=0;


create procedure emp_not_in_prj_from @x int
as
begin
	select e.employeeid,e.firstname,count(ep.projectid) as num_prj from Employees e 
	left join EmployeeProjects ep on ep.EmployeeID=e.EmployeeID
	where hiredate>dateadd(year,-@x,getdate())
	group by e.employeeid,e.firstname having count(ep.projectid)=0
end;

-- last 2 years
exec emp_not_in_prj_from 2;
-- last 5 years
exec emp_not_in_prj_from 5;

-- 4. Find the total number of hours worked on each project by each department.

select e.departmentid,ep.projectid,sum(ep.hoursworked) as tot_tim from Employees e 
left join EmployeeProjects ep on ep.EmployeeID=e.EmployeeID
group by e.DepartmentID,ep.ProjectID;

select projectid,sum(hoursworked) as tot_tim from EmployeeProjects group by projectid;

-- 5. For each employee, display their manager's name and the number of projects they both have worked on together.

select e.firstname,m.firstname,count(ep.projectid) as tot_prj
from Employees e left join Employees m on e.ManagerID=m.EmployeeID
join EmployeeProjects ep on e.ManagerID=ep.EmployeeID and m.EmployeeID=ep.EmployeeID
group by e.firstname,m.firstname;



-- Corrected one:
SELECT 
    e.firstname AS EmployeeName,
    m.firstname AS ManagerName,
    COUNT(ep.projectid) AS tot_prj
FROM 
    Employees e 
LEFT JOIN 
    Employees m ON e.ManagerID = m.EmployeeID
JOIN 
    EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
JOIN 
    EmployeeProjects mp ON m.EmployeeID = mp.EmployeeID AND ep.projectid = mp.projectid
GROUP BY 
    e.firstname, m.firstname;


-- 6. Identify employees who have worked more than 1000 hours in total across all projects and display their department.

create procedure total_hr_worked @x int as
begin
select e.firstname,d.departmentname ,sum(ep.hoursworked) as tot_hrs
from employees e join EmployeeProjects ep on ep.EmployeeID=e.EmployeeID
join Departments d on d.DepartmentID = e.DepartmentID 
group by e.firstname,d.departmentname having sum(ep.hoursworked)>@x
end;
-- more than 500 hours
exec total_hr_worked 500;
-- more than 1000 hours
exec total_hr_worked 1000;

-- 7. Find all projects that have ended, and for each project, list all the employees who worked on it along with their total hours.

select p.projectid,e.firstname,sum(hoursworked) as tot_hr from projects p 
join EmployeeProjects ep on ep.ProjectID=p.ProjectID
join employees e on ep.EmployeeID=e.EmployeeID
where p.enddate<getdate()
group by p.projectid,e.firstname;



-- 8. Write a query to find all employees whose salary is above the department average salary.
-- basic
select departmentid,firstname,salary from employees e
where salary>(select avg(salary) from Employees e1 where e.departmentid=e1.DepartmentID);

-- with cte and window
with cte as(
select departmentid,firstname,salary,avg(salary) over(partition by departmentid) as aver_sal from employees e)
select departmentid,firstname,salary from cte where salary>aver_sal;


-- 9. Display the name of employees who directly or indirectly report to a specific manager (for example, EmployeeID = 101).

select e.employeeid as employee,m.managerid as manager from employees e ;
select * from Employees;
-- 10. List all departments that have no employees assigned to them.
select d.departmentid,count(e.employeeid) from Departments d left join employees e on d.DepartmentID=e.DepartmentID
group by d.departmentid having count(e.employeeid)=0

-- 11. Calculate the difference between the current salary of each employee and the average salary in their department.

with cte as(
select departmentid,firstname,salary,avg(salary) over(partition by departmentid) as aver_sal from employees e)
select departmentid,firstname,salary-aver_sal from cte;

-- 12. For each project, find the employee who worked the most hours on it.
with cte as(
select e.firstname as fname,ep.projectid as pid,sum(ep.hoursworked) as tot_work,
DENSE_RANK() over(partition by ep.projectid order by sum(ep.hoursworked) desc) as rnk
from EmployeeProjects ep join Employees e on e.EmployeeID=ep.EmployeeID
group by e.firstname,ep.ProjectID)
select fname,pid from cte where rnk=1;

-- 13. Generate a report showing the number of employees working under each manager, and sort by the highest number.
select m.firstname,count(e.employeeid) as total_emp from Employees e join Employees m 
on e.ManagerID=m.EmployeeID group by m.firstname order by 2 desc;

-- 14. Find employees who haven't received a salary increase in the last 2 years.
-- select firstname from employees where prev_sal>=curr_sal and HireDate<=dateadd(year,-2,getdate());
-- Not in question(Data not available in tables)

-- 15. List all projects that are behind schedule (i.e., current date is past the project’s EndDate), and display the employees still working on them.

select e.firstname,p.projectname from projects p
join EmployeeProjects ep on ep.ProjectID=p.ProjectID
join employees e on ep.EmployeeID=e.EmployeeID
where p.enddate<getdate();

-- 16. Identify employees who are in the top 5 highest earners in the company.
-- basic
select top 5 firstname,salary from employees order by salary desc;
-- using procedure
create procedure top_earner @x int
as
begin
	select top (@x) firstname,salary from employees order by salary desc;
end
exec top_earner 5;
exec top_earner 2;


-- 17. Write a query to list all managers who are earning less than their subordinates.
select m.firstname as mngr,m.salary as mgr_slry,e.firstname as emp,e.Salary as emp_sal from Employees e 
join employees m on e.ManagerID=m.EmployeeID where m.Salary<e.Salary;


-- 18. Find the department with the most total hours worked across all projects.
select top 1 d.departmentname,sum(ep.hoursworked) as hour_worked from Departments d 
join employees e on e.DepartmentID=d.DepartmentID
join EmployeeProjects ep on e.EmployeeID=ep.EmployeeID
group by d.DepartmentName order by 2 desc;

-- 19. Retrieve the list of employees who worked on the most projects, along with the count of projects they worked on.
select e.firstname,count(ep.projectid) as tot_proj from employees e join EmployeeProjects ep
on ep.EmployeeID=e.EmployeeID group by e.firstname order by 2 desc;

-- 20. Write a query to retrieve all employees who were hired before their manager was hired.
select e.firstname as emp_name,e.hiredate as emp_hire,m.firstname as mgr_name,m.hiredate as mgr_date
from Employees e join Employees m on e.ManagerID=m.EmployeeID
where e.HireDate<m.HireDate;


-- 21. Write a query to rank employees within each department based on their salary. Display the employee's name, department name, and their rank.

select firstname,salary,departmentid,DENSE_RANK() over(partition by departmentid order by salary desc) as rnk from employees;

-- 22. For each project, find the top N employees who have worked the most hours on it. (N could be a parameter you pass to the query).
-- Overall
create procedure top_hardworking_emp @n int  = 1
as
begin
	select top (@n) e.firstname,ep.projectid,ep.hoursworked from Employees e 
	join EmployeeProjects ep on ep.EmployeeID=e.EmployeeID
	order by ep.HoursWorked desc;
end
exec top_hardworking_emp;
exec top_hardworking_emp 5;

-- Project wise
alter procedure top_hardworking_emp_per_proj @n int=1
as
begin
with cte as(
	select e.firstname,ep.projectid,DENSE_RANK() over(partition by ep.projectid order by ep.hoursworked desc) as rnk
	from EmployeeProjects ep join Employees e on e.EmployeeID=ep.EmployeeID)

	select * from cte where rnk between 1 and @n
end

exec top_hardworking_emp_per_proj
exec top_hardworking_emp_per_proj 5
exec top_hardworking_emp_per_proj 2
-- 23. Retrieve a list of employees who have never worked on a project, along with their department name.
select e.firstname,d.departmentname from Employees e join Departments d on d.DepartmentID=e.DepartmentID
left join EmployeeProjects ep on e.EmployeeID=ep.EmployeeID
where ep.ProjectID is null;

-- 24. Write a query to calculate the average salary increase for each employee based on their previous and current salary.
-- select firstname,round(((current_salary-previous_salary)/previous_salary)*100.0,2) as avg_sal_inc from employees;

-- 25. Write a query to find departments that have more than N employees, where N is a parameter.
-- overall
select d.departmentname,count(e.employeeid)as cnt_emp from employees e join Departments d
on e.DepartmentID=d.DepartmentID group by d.Departmentname;

-- parameter n
alter procedure dep_capacity @n int =0
as
begin
	select d.departmentname,count(e.employeeid)as cnt_emp from employees e join Departments d
	on e.DepartmentID=d.DepartmentID group by d.Departmentname
	having count(e.employeeid)>(@n)
end
exec dep_capacity 1



-- 26. Create a report showing each employee's name along with their manager's name, filtering only those who have managers.
select e.firstname as emp,m.firstname as mgr from employees e join Employees m 
on e.ManagerID=m.EmployeeID;


-- 27. List all employees and the count of projects they are currently working on. Include employees with zero projects.
select e.firstname,count(ep.projectid) as proj_cnt from employees e left join EmployeeProjects ep
on ep.EmployeeID=e.EmployeeID
group by e.FirstName;

-- 28. Find all employees who were hired after the start date of a project they worked on. Show their name, project name, and hire date.

select e.firstname,p.projectid,e.hiredate,p.startdate from Employees e join EmployeeProjects ep
on ep.EmployeeID=e.EmployeeID
join projects p on p.ProjectID=ep.ProjectID
where e.HireDate>p.StartDate;

-- 29. Write a query to calculate the total hours worked on projects by each manager’s subordinates.

select m.firstname as mgr,ep.projectid,sum(ep.hoursworked) as sub_hrs from Employees e join Employees m on e.ManagerID=m.EmployeeID
join EmployeeProjects ep on e.EmployeeID=ep.EmployeeID group by m.firstname,ep.ProjectID order by m.firstname;


-- 30. Find employees who have participated in more than one project, displaying their names and project counts.
select e.firstname,count(ep.projectid) as prj_cnt from Employees e join EmployeeProjects ep on e.EmployeeID=ep.EmployeeID
group by e.FirstName having count(ep.projectid)>1;


-- 31. Write a query to identify the department with the highest average salary among its employees.
-- Employee wise
select e.firstname,salary from employees e where salary>(select avg(salary) from Employees e1 where e1.DepartmentID=e.DepartmentID);

SELECT 
    d.DepartmentID, 
    d.DepartmentName,
    AVG(e.salary) AS AvgSalary
FROM 
    Employees e 
JOIN 
    Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY 
    d.DepartmentID, d.DepartmentName
ORDER BY 
    AvgSalary DESC


-- 32. Create a recursive CTE to list all employees and their respective managers up to the top-level manager.


-- 33. Find the top 5 employees who have been with the company the longest. Show their names and hire dates.
select top 5 firstname,hiredate from employees order by hiredate;

-- 34. List all projects that currently have no employees assigned to them.

select p.projectid,count(ep.employeeid) as cnt_emp_assign from EmployeeProjects ep 
right join projects p on p.ProjectID=ep.ProjectID
group by p.ProjectID having count(ep.employeeid) =0;

-- 35. Write a query to find departments that have less than N employees, where N is a parameter.
create procedure dep_capacity_less @n int =1
as
begin
	select d.departmentname,count(e.employeeid)as cnt_emp from employees e join Departments d
	on e.DepartmentID=d.DepartmentID group by d.Departmentname
	having count(e.employeeid)<(@n)
end
exec dep_capacity_less 1
exec dep_capacity_less 2
exec dep_capacity_less 5


-- 36. Create a histogram of employee salaries grouped by salary ranges (e.g., 0-50k, 50k-100k, etc.).
SELECT 
    CASE 
        WHEN Salary <= 50000 THEN '0 - 50,000'
        WHEN Salary > 50000 AND Salary <= 100000 THEN '50,001 - 100,000'
        WHEN Salary > 100000 AND Salary <= 150000 THEN '100,001 - 150,000'
        ELSE 'Above 150,000'
    END AS SalaryRange,
    COUNT(*) AS EmployeeCount
FROM 
    Employees
GROUP BY 
    CASE 
        WHEN Salary <= 50000 THEN '0 - 50,000'
        WHEN Salary > 50000 AND Salary <= 100000 THEN '50,001 - 100,000'
        WHEN Salary > 100000 AND Salary <= 150000 THEN '100,001 - 150,000'
        ELSE 'Above 150,000'
    END
ORDER BY 
    SalaryRange;

-- 37. Find employees who participated in the latest project, displaying their names and the project name.
select e.firstname,p.projectid,p.startdate from Employees e join EmployeeProjects ep on e.EmployeeID=ep.EmployeeID
join projects p on p.ProjectID=ep.ProjectID  where p.StartDate = (SELECT MAX(StartDate) FROM Projects)

-- 38. List all departments along with their respective locations and the number of employees in each department.
select d.departmentid,d.departmentname,d.location,count(e.employeeid) as emp_cnt from employees e right join Departments d 
on e.DepartmentID=d.DepartmentID
group by d.departmentid,d.departmentname,d.location;


-- 39. Retrieve employees hired in the last 6 months and their corresponding department names.
select e.firstname,d.departmentname,e.hiredate from Employees e join Departments d on e.DepartmentID=d.DepartmentID
where hiredate>=dateadd(month,-6,getdate());
