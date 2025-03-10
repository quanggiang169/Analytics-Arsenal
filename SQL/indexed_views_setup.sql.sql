/* 
This dataset was recorded in the past, so all dates are outdated.  
To analyze employee ages correctly in today's context, we need to add 22 years.  
Otherwise, the data would show employees as much older than they actually are.  

Example:  
Suppose an employee's birth_date in the dataset is '1980-06-10'.  
If we don’t update it, an age calculation in 2025 would show:
   2025 - 1980 = 45 years old (which is incorrect).  
But after adding 22 years, the birth_date becomes '2002-06-10'.  
   2025 - 2002 = 23 years old (which is more accurate for the analysis).  
*/
-- Update the department_employee table: add 22 years to dates
UPDATE dbo.department_employee
SET from_date = DATEADD(YEAR, 22, from_date),
    to_date = CASE 
                 WHEN to_date = '9999-01-01' THEN to_date  
                 ELSE DATEADD(YEAR, 22, to_date)          
              END;

-- Update the department_manager table
UPDATE dbo.department_manager
SET from_date = DATEADD(YEAR, 22, from_date),
    to_date = CASE 
                 WHEN to_date = '9999-01-01' THEN to_date  
                 ELSE DATEADD(YEAR, 22, to_date)          
              END;

-- Update the employee table: add 22 years to birth_date and hire_date
UPDATE dbo.employee
SET birth_date = DATEADD(YEAR, 22, birth_date),
    hire_date = DATEADD(YEAR, 22, hire_date);

-- Update the salary table
UPDATE dbo.salary
SET from_date = DATEADD(YEAR, 22, from_date),
    to_date = CASE 
                 WHEN to_date = '9999-01-01' THEN to_date  
                 ELSE DATEADD(YEAR, 22, to_date)          
              END;

-- Update the title table
UPDATE dbo.title
SET from_date = DATEADD(YEAR, 22, from_date),
    to_date = CASE 
                 WHEN to_date = '9999-01-01' THEN to_date  
                 ELSE DATEADD(YEAR, 22, to_date)          
              END;

/* ============================
     CREATE INDEXED VIEWS
============================ */

-- Drop schema if it exists and create a new one
DROP SCHEMA IF EXISTS mv_employees;
CREATE SCHEMA mv_employees;

-- Department View
DROP VIEW IF EXISTS mv_employees.department;
CREATE VIEW mv_employees.department
WITH SCHEMABINDING
AS
SELECT id, dept_name
FROM dbo.department;

-- Department Employee View
DROP VIEW IF EXISTS mv_employees.department_employee;
CREATE VIEW mv_employees.department_employee
WITH SCHEMABINDING
AS
SELECT
  employee_id,
  department_id,
  from_date,
  to_date
FROM dbo.department_employee;

-- Department Manager View
DROP VIEW IF EXISTS mv_employees.department_manager;
CREATE VIEW mv_employees.department_manager
WITH SCHEMABINDING
AS
SELECT
  employee_id,
  department_id,
  from_date,
  to_date
FROM dbo.department_manager;

-- Employee View
DROP VIEW IF EXISTS mv_employees.employee;
CREATE VIEW mv_employees.employee
WITH SCHEMABINDING
AS
SELECT
  id,
  birth_date,
  first_name,
  last_name,
  gender,
  hire_date
FROM dbo.employee;

-- Salary View
DROP VIEW IF EXISTS mv_employees.salary;
CREATE VIEW mv_employees.salary
WITH SCHEMABINDING
AS
SELECT
  employee_id,
  amount,
  from_date,
  to_date
FROM dbo.salary;

-- Title View
DROP VIEW IF EXISTS mv_employees.title;
CREATE VIEW mv_employees.title
WITH SCHEMABINDING
AS
SELECT
  employee_id,
  title,
  from_date,
  to_date
FROM dbo.title;

/* ============================
     CREATE INDEXES
============================ */

-- Employee
CREATE UNIQUE CLUSTERED INDEX IX_employee_id 
ON mv_employees.employee (id);

-- Department Employee
CREATE UNIQUE CLUSTERED INDEX IX_department_employee 
ON mv_employees.department_employee (employee_id, department_id);

CREATE INDEX IX_department_employee_dept 
ON mv_employees.department_employee (department_id);

-- Department
CREATE UNIQUE CLUSTERED INDEX IX_department_id 
ON mv_employees.department (id);

CREATE UNIQUE INDEX IX_department_name 
ON mv_employees.department (dept_name);

-- Department Manager
CREATE UNIQUE CLUSTERED INDEX IX_department_manager 
ON mv_employees.department_manager (employee_id, department_id);

CREATE INDEX IX_department_manager_dept 
ON mv_employees.department_manager (department_id);

-- Salary
CREATE UNIQUE CLUSTERED INDEX IX_salary 
ON mv_employees.salary (employee_id, from_date);

-- Title
CREATE UNIQUE CLUSTERED INDEX IX_title 
ON mv_employees.title (employee_id, title, from_date);

