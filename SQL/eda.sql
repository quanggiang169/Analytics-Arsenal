/* 

Exploratory Data Analysis

*/

-------------------------------------------
/* 1. Count the number of rows in each table to see which one has the most data */
SELECT 'employee' AS table_name, COUNT(*) AS row_count FROM dbo.employee
UNION ALL
SELECT 'department', COUNT(*) FROM dbo.department
UNION ALL
SELECT 'department_employee', COUNT(*) FROM dbo.department_employee
UNION ALL
SELECT 'department_manager', COUNT(*) FROM dbo.department_manager
UNION ALL
SELECT 'salary', COUNT(*) FROM dbo.salary
UNION ALL
SELECT 'title', COUNT(*) FROM dbo.title;

-------------------------------------------
/* 2. View the first 20 rows from each table to understand the structure */

SELECT TOP 20 * FROM dbo.employee; 
-- dbo.employee: Each row represents a unique employee's information.

SELECT TOP 20 * FROM dbo.department; 
-- dbo.department: Each row represents a unique department.

SELECT TOP 20 * FROM dbo.department_employee; 
	SELECT TOP 5 employee_id, COUNT(DISTINCT department_id) AS unique_departments
	FROM dbo.department_employee
	GROUP BY employee_id
	ORDER BY unique_departments DESC
		SELECT * FROM dbo.department_employee
		WHERE employee_id = 10010
-- dbo.department_employee: Each row represents a period when an employee worked in a department. 
--                          An employee may belong to multiple departments at different times.

SELECT TOP 20 * FROM dbo.department_manager;
	SELECT *
	FROM dbo.department_manager
	WHERE department_id = 'd001'
	ORDER BY from_date;
-- dbo.department_manager: Each row represents a department manager. 
--                          A department may have different managers over time.

SELECT TOP 20 * FROM dbo.salary;
	SELECT TOP 5 employee_id, COUNT(employee_id) AS id_count
	FROM dbo.salary
	GROUP BY employee_id
	ORDER BY id_count DESC
		SELECT * FROM dbo.salary
		WHERE employee_id = 10009;
-- dbo.salary: Each row represents an employee's salary for a specific time period. 
--             An employee may receive multiple salary adjustments over time.

SELECT TOP 20 * FROM dbo.title;
	SELECT TOP 20 employee_id, COUNT(employee_id) AS id_count
	FROM dbo.title
	GROUP BY employee_id
	ORDER BY id_count DESC
		SELECT * FROM dbo.title
		WHERE employee_id = 10009
		ORDER BY  from_date;
-- dbo.title: Each row represents an employee's job title for a specific time period. 
--            An employee may hold different job titles over time.

-------------------------------------------
/* 3. Check NULL values in tables */

-- Count NULL values in each column of the employee table
SELECT 
    SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS missing_id,
    SUM(CASE WHEN birth_date IS NULL THEN 1 ELSE 0 END) AS missing_birth_date,
    SUM(CASE WHEN first_name IS NULL THEN 1 ELSE 0 END) AS missing_first_name,
    SUM(CASE WHEN last_name IS NULL THEN 1 ELSE 0 END) AS missing_last_name,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS missing_gender,
    SUM(CASE WHEN hire_date IS NULL THEN 1 ELSE 0 END) AS missing_hire_date
FROM dbo.employee;

-- Count NULL values in each column of the department table
SELECT 
    SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS missing_id,
    SUM(CASE WHEN dept_name IS NULL THEN 1 ELSE 0 END) AS missing_dept_name
FROM dbo.department;

-- Count NULL values in each column of the department_employee table
SELECT 
    SUM(CASE WHEN employee_id IS NULL THEN 1 ELSE 0 END) AS missing_employee_id,
    SUM(CASE WHEN department_id IS NULL THEN 1 ELSE 0 END) AS missing_department_id,
    SUM(CASE WHEN from_date IS NULL THEN 1 ELSE 0 END) AS missing_from_date,
    SUM(CASE WHEN to_date IS NULL THEN 1 ELSE 0 END) AS missing_to_date
FROM dbo.department_employee;

-- Count NULL values in each column of the department_manager table
SELECT 
    SUM(CASE WHEN employee_id IS NULL THEN 1 ELSE 0 END) AS missing_employee_id,
    SUM(CASE WHEN department_id IS NULL THEN 1 ELSE 0 END) AS missing_department_id,
    SUM(CASE WHEN from_date IS NULL THEN 1 ELSE 0 END) AS missing_from_date,
    SUM(CASE WHEN to_date IS NULL THEN 1 ELSE 0 END) AS missing_to_date
FROM dbo.department_manager;

-- Count NULL values in each column of the salary table
SELECT 
    SUM(CASE WHEN employee_id IS NULL THEN 1 ELSE 0 END) AS missing_employee_id,
    SUM(CASE WHEN amount IS NULL THEN 1 ELSE 0 END) AS missing_amount,
    SUM(CASE WHEN from_date IS NULL THEN 1 ELSE 0 END) AS missing_from_date,
    SUM(CASE WHEN to_date IS NULL THEN 1 ELSE 0 END) AS missing_to_date
FROM dbo.salary;

-- Count NULL values in each column of the title table
SELECT 
    SUM(CASE WHEN employee_id IS NULL THEN 1 ELSE 0 END) AS missing_employee_id,
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS missing_title,
    SUM(CASE WHEN from_date IS NULL THEN 1 ELSE 0 END) AS missing_from_date,
    SUM(CASE WHEN to_date IS NULL THEN 1 ELSE 0 END) AS missing_to_date
FROM dbo.title;

-- No NULL values found in these tables

-------------------------------------------
/* 4. Check for Duplicate data */

-- Find duplicate employee IDs in dbo.employee
SELECT id, COUNT(*) AS duplicate_count
FROM dbo.employee
GROUP BY id
HAVING COUNT(*) > 1;

-- Find duplicate department IDs in dbo.department
SELECT id, COUNT(*) AS duplicate_count
FROM dbo.department
GROUP BY id
HAVING COUNT(*) > 1;

-- Find duplicate department assignments for employees
SELECT employee_id, department_id, from_date, to_date, COUNT(*) AS duplicate_count
FROM dbo.department_employee
GROUP BY employee_id, department_id, from_date, to_date
HAVING COUNT(*) > 1;

-- Find duplicate department manager assignments
SELECT employee_id, department_id, from_date, to_date, COUNT(*) AS duplicate_count
FROM dbo.department_manager
GROUP BY employee_id, department_id, from_date, to_date
HAVING COUNT(*) > 1;

-- Find duplicate salary records for employees
SELECT employee_id, amount, from_date, to_date, COUNT(*) AS duplicate_count
FROM dbo.salary
GROUP BY employee_id, amount, from_date, to_date
HAVING COUNT(*) > 1;

-- Find duplicate job title records for employees
SELECT employee_id, title, from_date, to_date, COUNT(*) AS duplicate_count
FROM dbo.title
GROUP BY employee_id, title, from_date, to_date
HAVING COUNT(*) > 1;

-------------------------------------------
/* 5. Check for anomalies in time data */

-- Find records where to_date is before from_date
SELECT 'department_employee' AS table_name, employee_id, from_date, to_date 
FROM dbo.department_employee 
WHERE to_date < from_date

UNION ALL

SELECT 'department_manager' AS table_name, employee_id, from_date, to_date
FROM dbo.department_manager 
WHERE to_date < from_date

UNION ALL

SELECT 'salary' AS table_name, employee_id, from_date, to_date
FROM dbo.salary 
WHERE to_date < from_date

UNION ALL

SELECT 'title' AS table_name, employee_id, from_date, to_date
FROM dbo.title 
WHERE to_date < from_date;

-- Find overlapping department assignments
SELECT a.employee_id, a.department_id, a.from_date, a.to_date, 
       b.from_date AS overlapping_from, b.to_date AS overlapping_to
FROM dbo.department_employee a
JOIN dbo.department_employee b
ON a.employee_id = b.employee_id
AND a.department_id = b.department_id
AND a.from_date < b.to_date
AND a.to_date > b.from_date
AND a.from_date <> b.from_date;

-- Find salary records where salary starts before hire date
SELECT s.employee_id, s.from_date, s.to_date, e.hire_date
FROM dbo.salary s
JOIN dbo.employee e
ON s.employee_id = e.id
WHERE s.from_date < e.hire_date;

-- Find title records where an employee gets a new title before the previous one ends
SELECT a.employee_id, a.title AS old_title, a.from_date AS old_from, a.to_date AS old_to, 
       b.title AS new_title, b.from_date AS new_from, b.to_date AS new_to
FROM dbo.title a
JOIN dbo.title b
ON a.employee_id = b.employee_id
AND a.to_date > b.from_date
AND a.title <> b.title
ORDER BY a.employee_id, a.from_date;
-- Many cases of employees getting new titles before the old titles end were discovered.

	SELECT employee_id, title, COUNT(*) as count_records
	FROM dbo.title
	GROUP BY employee_id, title
	HAVING COUNT(*) > 1;
	-- No employee has the same title more than once.

-------------------------------------------
/* 6. Ensure that all the values in the foreign key columns actually exist in the referenced table. */

-- Verify that each employee_id in department_employee exists in employee
SELECT DISTINCT de.employee_id
FROM dbo.department_employee de
LEFT JOIN dbo.employee e ON de.employee_id = e.id
WHERE e.id IS NULL;

-- Verify that each department_id in department_employee exists in department
SELECT DISTINCT de.department_id
FROM dbo.department_employee de
LEFT JOIN dbo.department d ON de.department_id = d.id
WHERE d.id IS NULL;

-- Verify that each employee_id in department_manager exists in employee
SELECT DISTINCT dm.employee_id
FROM dbo.department_manager dm
LEFT JOIN dbo.employee e ON dm.employee_id = e.id
WHERE e.id IS NULL;
-- There are 24 employee_id values in department_manager that do not exist in employee.

-- Verify that each department_id in department_manager exists in department
SELECT DISTINCT dm.department_id
FROM dbo.department_manager dm
LEFT JOIN dbo.department d ON dm.department_id = d.id
WHERE d.id IS NULL;

-- Verify that each employee_id in salary exists in employee
SELECT DISTINCT s.employee_id
FROM dbo.salary s
LEFT JOIN dbo.employee e ON s.employee_id = e.id
WHERE e.id IS NULL;

-- Verify that each employee_id in title exists in employee
SELECT DISTINCT t.employee_id
FROM dbo.title t
LEFT JOIN dbo.employee e ON t.employee_id = e.id
WHERE e.id IS NULL;

-------------------------------------------
/* ============================
   7. Univariate Analysis
   ============================ */

-- Counting employees who are still working vs. those who have resigned
WITH EmployeeStatus AS (
    SELECT 
        employee_id,
        -- If the employee has at least one '9999-01-01' record, they are still working
        CASE 
            WHEN MAX(to_date) = '9999-01-01' THEN 'Currently Working'
            ELSE 'Resigned'
        END AS status
    FROM dbo.title
    GROUP BY employee_id
)
SELECT 
    SUM(CASE WHEN status = 'Currently Working' THEN 1 ELSE 0 END) AS currently_working,
    SUM(CASE WHEN status = 'Resigned' THEN 1 ELSE 0 END) AS resigned
FROM EmployeeStatus;
-- There are 27,162 employees currently working and 6,674 who have resigned.

-- Analyze gender distribution in the employees table
WITH EmployeeStatus AS (
    SELECT 
        e.gender, 
        COUNT(CASE WHEN t.to_date = '9999-01-01' THEN 1 END) AS currently_working,
        COUNT(CASE WHEN t.to_date <> '9999-01-01' THEN 1 END) AS resigned
    FROM dbo.employee e
    JOIN dbo.title t ON e.id = t.employee_id
    GROUP BY e.gender
),
TotalCounts AS (
    SELECT 
        SUM(currently_working) AS total_working, 
        SUM(resigned) AS total_resigned 
    FROM EmployeeStatus
)
SELECT 
    es.gender, 
    es.currently_working, 
    ROUND(es.currently_working * 100.0 / tc.total_working, 2) AS working_percentage,
    es.resigned, 
    ROUND(es.resigned * 100.0 / tc.total_resigned, 2) AS resigned_percentage
FROM EmployeeStatus es
CROSS JOIN TotalCounts tc
UNION ALL
SELECT 
    'Total' AS gender,
    SUM(currently_working), 
    100.00,
    SUM(resigned), 
    100.00
FROM EmployeeStatus;
-- 40.16% of currently working employees are female (10,907), while 59.84% are male (16,255). 
-- Among resigned employees, 40.54% are female (9,258), and 59.46% are male (13,580). 
-- Total: 27,162 employees are still working, and 22,838 have resigned.

-- Analyze birth_date (Age distribution of employees)
	-- Check the oldest, youngest, and average age
	SELECT 
		category,
		MIN(birth_date) AS oldest_birth,
		MAX(birth_date) AS youngest_birth,
		ROUND(AVG(DATEDIFF(YEAR, birth_date, GETDATE())), 2) AS avg_age
	FROM (
		SELECT 
			e.birth_date,
			CASE 
				WHEN t.latest_to_date = '9999-01-01' THEN 'Currently Working'
				ELSE 'Resigned'
			END AS category
		FROM dbo.employee e
		JOIN (
			SELECT employee_id, MAX(to_date) AS latest_to_date
			FROM dbo.title
			GROUP BY employee_id
		) t ON e.id = t.employee_id
		UNION ALL
		SELECT 
			birth_date, 
			'Total' AS category
		FROM dbo.employee
	) AS categorized_data
	GROUP BY category;
	-- The age distribution is consistent across both working and resigned employees, with the oldest born in 1974 and the youngest in 1987. 
	-- The average age remains 44 across all categories.

	-- Age distribution (count employees by age group)
	SELECT 
		category,
		age,
		COUNT(*) AS count_employees
	FROM (
		SELECT 
			YEAR(GETDATE()) - YEAR(e.birth_date) AS age,
			CASE 
				WHEN t.latest_to_date = '9999-01-01' THEN 'Currently Working'
				ELSE 'Resigned'
			END AS category
		FROM dbo.employee e
		JOIN (
			SELECT employee_id, MAX(to_date) AS latest_to_date
			FROM dbo.title
			GROUP BY employee_id
		) t ON e.id = t.employee_id
		UNION ALL
		SELECT 
			YEAR(GETDATE()) - YEAR(birth_date) AS age,
			'Total' AS category
		FROM dbo.employee
	) AS categorized_data
	GROUP BY category, age
	ORDER BY category, age;
	-- The age distribution is fairly balanced, with a gradual increase in mid-age groups and a slight decline toward older ages. 
	-- The pattern remains consistent across both working and resigned employees.

-- Analyze hire_date (Hiring trend over the years)
SELECT YEAR(hire_date) AS hire_year, COUNT(*) AS no_candidates
FROM dbo.employee
GROUP BY YEAR(hire_date)
ORDER BY hire_year;
-- Hiring trends show a peak in 2007, followed by a steady decline in new hires over the years.

-- Analyze salary distribution
	-- Find minimum, maximum, average, and median salary
	-- Overall
	WITH Median_CTE AS (
		SELECT 
			PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY CAST(amount AS DECIMAL(18,2))) 
			OVER () AS median_salary
		FROM dbo.salary
	)
	SELECT 
		'Total' AS category,
		MIN(CAST(amount AS DECIMAL(18,2))) AS min_salary, 
		MAX(CAST(amount AS DECIMAL(18,2))) AS max_salary, 
		ROUND(AVG(CAST(amount AS DECIMAL(18,2))), 2) AS avg_salary,
		(SELECT DISTINCT median_salary FROM Median_CTE) AS median_salary
	FROM dbo.salary;
	-- Currently_Working
	WITH Salary_CTE AS (
		SELECT 
			CAST(s.amount AS DECIMAL(18,2)) AS salary
		FROM dbo.salary s
		JOIN (
			SELECT employee_id, MAX(to_date) AS latest_to_date
			FROM dbo.title
			GROUP BY employee_id
			HAVING MAX(to_date) = '9999-01-01'
		) t ON s.employee_id = t.employee_id
	),
	Median_CTE AS (
		SELECT 
			PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) 
			OVER () AS median_salary
		FROM Salary_CTE
	)
	SELECT 
		'Currently Working' AS category,
		MIN(salary) AS min_salary, 
		MAX(salary) AS max_salary, 
		ROUND(AVG(salary), 2) AS avg_salary,
		(SELECT DISTINCT median_salary FROM Median_CTE) AS median_salary
	FROM Salary_CTE;
	-- Resigned
	WITH Salary_CTE AS (
		SELECT 
			CAST(s.amount AS DECIMAL(18,2)) AS salary
		FROM dbo.salary s
		JOIN (
			SELECT employee_id, MAX(to_date) AS latest_to_date
			FROM dbo.title
			GROUP BY employee_id
			HAVING MAX(to_date) <> '9999-01-01'
		) t ON s.employee_id = t.employee_id
	),
	Median_CTE AS (
		SELECT 
			PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) 
			OVER () AS median_salary
		FROM Salary_CTE
	)
	SELECT 
		'Resigned' AS category,
		MIN(salary) AS min_salary, 
		MAX(salary) AS max_salary, 
		ROUND(AVG(salary), 2) AS avg_salary,
		(SELECT DISTINCT median_salary FROM Median_CTE) AS median_salary
	FROM Salary_CTE;
	-- The salary distribution indicates that currently working employees have a slightly higher average salary (64,376.47 vs. 61,823.03) and median salary (61,717.5 vs. 58,389.5) compared to resigned employees. 
	-- While the minimum salary is similar (38,874 vs. 39,020), the maximum salary for resigned employees is notably lower (130,417 vs. 145,732). 
	-- This suggests that higher earners are more likely to stay with the company, while those who left had a lower overall earning potential.

	-- Salary range distribution
	WITH Salary_CTE AS (
		SELECT 
			CASE 
				WHEN s.amount < 40000 THEN '<40K'
				WHEN s.amount BETWEEN 40000 AND 60000 THEN '40K-60K'
				WHEN s.amount BETWEEN 60001 AND 80000 THEN '60K-80K'
				WHEN s.amount BETWEEN 80001 AND 100000 THEN '80K-100K'
				ELSE '>100K' 
			END AS salary_range,
			CASE 
				WHEN t.latest_to_date = '9999-01-01' THEN 'Currently Working'
				ELSE 'Resigned'
			END AS category
		FROM dbo.salary s
		JOIN (
			SELECT employee_id, MAX(to_date) AS latest_to_date
			FROM dbo.title
			GROUP BY employee_id
		) t ON s.employee_id = t.employee_id
	)
	SELECT 
		salary_range, 
		SUM(CASE WHEN category = 'Currently Working' THEN 1 ELSE 0 END) AS currently_working,
		SUM(CASE WHEN category = 'Resigned' THEN 1 ELSE 0 END) AS resigned,
		COUNT(*) AS total
	FROM Salary_CTE
	GROUP BY salary_range
	ORDER BY salary_range;
	-- The salary distribution shows that the majority of employees fall within the 40K-60K and 60K-80K salary ranges, with 23,166 and 17,692 employees, respectively. 
	-- Higher salary ranges have fewer employees, but a significant number still earn above 100K (1,746 in total). 
	-- Resigned employees are proportionally more concentrated in lower salary ranges, suggesting that lower earners may have a higher turnover rate, while higher earners are more likely to stay.

-- Analyze job title distribution
WITH Title_CTE AS (
    SELECT 
        t.title,
        CASE 
            WHEN e.latest_to_date = '9999-01-01' THEN 'Currently Working'
            ELSE 'Resigned'
        END AS category
    FROM dbo.title t
    JOIN (
        SELECT employee_id, MAX(to_date) AS latest_to_date
        FROM dbo.title
        GROUP BY employee_id
    ) e ON t.employee_id = e.employee_id
)
SELECT 
    title, 
    SUM(CASE WHEN category = 'Currently Working' THEN 1 ELSE 0 END) AS currently_working,
    SUM(CASE WHEN category = 'Resigned' THEN 1 ELSE 0 END) AS resigned,
    COUNT(*) AS total
FROM Title_CTE
GROUP BY title
ORDER BY total DESC;
-- The data shows that Engineers and Staff make up the largest portion of employees, with over 13,000 and 12,000 total, respectively. 
-- Higher-level positions such as Senior Engineer and Senior Staff have fewer employees but still represent a significant portion of the workforce. 
-- Technique Leaders and Assistant Engineers are the smallest groups. 
-- Resignation rates appear to be relatively consistent across roles, with no extreme variations, suggesting that turnover is not heavily concentrated in any specific position.

-- Analyze department distribution
WITH Dept_CTE AS (
    SELECT 
        d.dept_name,
        CASE 
            WHEN e.latest_to_date = '9999-01-01' THEN 'Currently Working'
            ELSE 'Resigned'
        END AS category
    FROM dbo.department_employee de
    JOIN dbo.department d ON de.department_id = d.id
    JOIN (
        SELECT employee_id, MAX(to_date) AS latest_to_date
        FROM dbo.department_employee
        GROUP BY employee_id
    ) e ON de.employee_id = e.employee_id
)
SELECT 
    dept_name, 
    SUM(CASE WHEN category = 'Currently Working' THEN 1 ELSE 0 END) AS currently_working,
    SUM(CASE WHEN category = 'Resigned' THEN 1 ELSE 0 END) AS resigned,
    COUNT(*) AS total
FROM Dept_CTE
GROUP BY dept_name
ORDER BY total DESC;
-- The data shows that the Development and Production departments have the highest number of employees, with 12,934 and 11,137 total, respectively. 
-- Sales follows as the third-largest department. Support functions like Customer Service, Research, Marketing, Quality Management, Human Resources, and Finance have fewer employees but maintain a relatively stable workforce. 
-- Resignation rates appear proportionally similar across departments, suggesting no specific department experiences significantly higher turnover than others.
-------------------------------------------
/* ============================
   8. Bivariate Analysis
   ============================ */

-- Employee Count by Gender in Each Department
WITH DeptGender_CTE AS (
    SELECT 
        d.dept_name,
        e.gender,
        CASE 
            WHEN de.to_date = '9999-01-01' THEN 'Currently Working'
            ELSE 'Resigned'
        END AS category
    FROM employee e
    JOIN department_employee de ON e.id = de.employee_id
    JOIN department d ON de.department_id = d.id
)
SELECT 
    dept_name, 
    gender,
    SUM(CASE WHEN category = 'Currently Working' THEN 1 ELSE 0 END) AS currently_working,
    SUM(CASE WHEN category = 'Resigned' THEN 1 ELSE 0 END) AS resigned,
    COUNT(*) AS total
FROM DeptGender_CTE
GROUP BY dept_name, gender
ORDER BY dept_name, gender;
-- The data indicates that across all departments, male employees outnumber female employees, particularly in Development, Production, and Sales. 
-- Resignation rates appear relatively proportional between genders, though male employees tend to have higher absolute numbers of resignations due to their larger workforce share. 
-- Customer Service, Finance, Human Resources, and Marketing have a more balanced gender distribution compared to technical and production-related departments. This suggests that while some roles attract a more even gender mix, others remain male-dominated.

-- Job Titles by Gender
WITH TitleGender_CTE AS (
    SELECT 
        t.title,
        e.gender,
        CASE 
            WHEN t.to_date = '9999-01-01' THEN 'Currently Working'
            ELSE 'Resigned'
        END AS category
    FROM employee e
    JOIN title t ON e.id = t.employee_id
)
SELECT 
    title, 
    gender,
    SUM(CASE WHEN category = 'Currently Working' THEN 1 ELSE 0 END) AS currently_working,
    SUM(CASE WHEN category = 'Resigned' THEN 1 ELSE 0 END) AS resigned,
    COUNT(*) AS total
FROM TitleGender_CTE
GROUP BY title, gender
ORDER BY title, gender;
-- The data shows that male employees outnumber female employees across all job titles, especially in engineering and technical roles. 
-- Resignation rates are notably higher for lower-level positions like Engineers and Staff, particularly among female employees, suggesting higher turnover in these roles. 
-- In contrast, senior positions such as Senior Engineer, Senior Staff, and Technique Leader have lower resignation rates for both genders, indicating greater stability in higher-ranking roles.

-- Relationship Between Salary and Job Title
WITH SalaryTitle_CTE AS (
    SELECT 
        t.title,
        s.amount AS salary,
        CASE 
            WHEN t.to_date = '9999-01-01' THEN 'Currently Working'
            ELSE 'Resigned'
        END AS category
    FROM salary s
    JOIN title t ON s.employee_id = t.employee_id
)
SELECT 
    title,
    ROUND(AVG(CASE WHEN category = 'Currently Working' THEN salary END), 2) AS avg_salary_working,
    ROUND(AVG(CASE WHEN category = 'Resigned' THEN salary END), 2) AS avg_salary_resigned,
    ROUND(AVG(salary), 2) AS avg_salary_total
FROM SalaryTitle_CTE
GROUP BY title
ORDER BY avg_salary_total DESC;
-- Resigned employees tend to have higher average salaries than currently working employees in lower-ranking positions like Staff, Engineer, and Assistant Engineer, suggesting that salary may be a factor in their decision to leave. 
-- However, for higher-level roles like Senior Engineer and Technique Leader, currently working employees earn more on average than those who resigned, indicating stronger retention among senior positions. 
-- This pattern suggests that salary competitiveness may influence turnover differently across job levels.

-- Salary Distribution Across Departments
WITH SalaryDept_CTE AS (
    SELECT 
        d.dept_name,
        s.amount AS salary,
        CASE 
            WHEN de.to_date = '9999-01-01' THEN 'Currently Working'
            ELSE 'Resigned'
        END AS category
    FROM salary s
    JOIN department_employee de ON s.employee_id = de.employee_id
    JOIN department d ON de.department_id = d.id
)
SELECT 
    dept_name,
    ROUND(AVG(CASE WHEN category = 'Currently Working' THEN salary END), 2) AS avg_salary_working,
    ROUND(AVG(CASE WHEN category = 'Resigned' THEN salary END), 2) AS avg_salary_resigned,
    ROUND(AVG(salary), 2) AS avg_salary_total
FROM SalaryDept_CTE
GROUP BY dept_name
ORDER BY avg_salary_total DESC;
-- Sales, Marketing, and Finance have the highest salaries, while Customer Service and HR have the lowest. 
-- In most departments, resigned employees earned less, except in Finance and Sales, where they earned slightly more. 
-- This suggests that salary alone is not the main reason for resignation.

-- Salary vs. Gender
WITH SalaryGender_CTE AS (
    SELECT 
        e.gender,
        CAST(s.amount AS DECIMAL(18,2)) AS salary,
        CASE 
            WHEN t.to_date = '9999-01-01' THEN 'Currently Working'
            ELSE 'Resigned'
        END AS category
    FROM salary s
    JOIN employee e ON s.employee_id = e.id
    JOIN title t ON e.id = t.employee_id
)
SELECT 
    gender,
    ROUND(AVG(CAST(CASE WHEN category = 'Currently Working' THEN salary END AS DECIMAL(18,2))), 2) AS avg_salary_working,
    ROUND(AVG(CAST(CASE WHEN category = 'Resigned' THEN salary END AS DECIMAL(18,2))), 2) AS avg_salary_resigned,
    ROUND(AVG(CAST(salary AS DECIMAL(18,2))), 2) AS avg_salary_total
FROM SalaryGender_CTE
GROUP BY gender
ORDER BY avg_salary_total DESC;
-- Both male and female employees have similar average salaries, with resigned employees earning slightly more than those still working. 
-- This suggests that factors beyond salary, such as career growth or work environment, may influence resignations rather than just pay differences.

-- Relationship Between Salary and Age
WITH AgeGroup AS (
    SELECT 
        CASE 
            WHEN YEAR(GETDATE()) - YEAR(e.birth_date) < 30 THEN '<30'
            WHEN YEAR(GETDATE()) - YEAR(e.birth_date) BETWEEN 30 AND 40 THEN '30-40'
            WHEN YEAR(GETDATE()) - YEAR(e.birth_date) BETWEEN 41 AND 50 THEN '41-50'
            ELSE '50+' 
        END AS age_group, 
        CAST(s.amount AS DECIMAL(18,2)) AS salary_amount,
        CASE 
            WHEN t.to_date = '9999-01-01' THEN 'Currently Working'
            ELSE 'Resigned'
        END AS category
    FROM employee e
    JOIN salary s ON e.id = s.employee_id
    JOIN title t ON e.id = t.employee_id
)
SELECT 
    age_group,
    category,
    ROUND(AVG(salary_amount), 2) AS avg_salary
FROM AgeGroup
GROUP BY age_group, category
ORDER BY age_group, avg_salary DESC;
-- Older resigned employees (50+) had the highest average salary, significantly higher than those still working, suggesting that senior employees may leave for better opportunities or retirement rather than low pay. 
-- Across all age groups, resigned employees consistently earned more, reinforcing the idea that salary alone is not the main driver of resignations—other factors like career progression or job satisfaction may play a larger role.

-- Compare salary ranges with employee tenure (in months)
WITH Salary_Tenure AS (
    SELECT 
        CASE 
            WHEN s.amount < 50000 THEN 'Low'  
            WHEN s.amount BETWEEN 50000 AND 100000 THEN 'Medium'
            ELSE 'High'
        END AS salary_range, 
        DATEDIFF(MONTH, de.from_date, 
            CASE 
                WHEN de.to_date = '9999-01-01' THEN GETDATE() 
                ELSE de.to_date 
            END) AS tenure_months,
        CASE 
            WHEN de.to_date = '9999-01-01' THEN 'Currently Working'
            ELSE 'Resigned'
        END AS category
    FROM salary s
    JOIN department_employee de ON s.employee_id = de.employee_id
)
SELECT 
    salary_range,
    category,
    ROUND(AVG(CAST(tenure_months AS DECIMAL(18,2))), 2) AS avg_tenure_months
FROM Salary_Tenure
GROUP BY salary_range, category
ORDER BY avg_tenure_months DESC;
-- Employees with higher salaries tend to stay longer, with those in the high salary range having the longest tenure. 
-- Resigned employees across all salary levels had shorter tenures, especially in the low salary range, indicating that lower pay may contribute to higher turnover, while higher salaries are linked to longer retention.

-- Relationship Between Hire Year and Average Salary
WITH Salary_Hire AS (
    SELECT 
        YEAR(e.hire_date) AS hire_year,
        s.amount AS salary,
        CASE 
            WHEN de.to_date = '9999-01-01' THEN 'Currently Working'
            ELSE 'Resigned'
        END AS category
    FROM employee e
    JOIN salary s ON e.id = s.employee_id
    JOIN department_employee de ON e.id = de.employee_id
)
SELECT 
    hire_year,
    category,
    ROUND(AVG(CAST(salary AS DECIMAL(18,2))), 2) AS avg_salary
FROM Salary_Hire
GROUP BY hire_year, category
ORDER BY hire_year, category;
-- Salaries for currently working employees tend to be higher than those who resigned, especially for older hire years. 
-- However, for some recent years (e.g., 2013-2015, 2017), resigned employees had slightly higher salaries, suggesting that other factors beyond salary influenced their departure. 
-- Additionally, salaries for more recent hires (2019 onward) are generally lower, reflecting possible changes in company pay structures or hiring trends.

-- Promotion Trends - Time Between Hires and First Title Change
WITH Promotion_CTE AS (
    SELECT 
        e.id,
        DATEDIFF(MONTH, e.hire_date, t.from_date) AS months_to_promotion,
        CASE 
            WHEN de.to_date = '9999-01-01' THEN 'Currently Working'
            ELSE 'Resigned'
        END AS category
    FROM employee e
    JOIN title t ON e.id = t.employee_id
    JOIN department_employee de ON e.id = de.employee_id
    WHERE t.from_date > e.hire_date
)
SELECT 
    category,
    ROUND(AVG(CAST(months_to_promotion AS DECIMAL(18,2))), 2) AS avg_months_to_promotion
FROM Promotion_CTE
GROUP BY category;
-- Currently working employees, on average, take about 8 months longer to receive a promotion compared to those who resigned (80.19 vs. 72.29 months). 
-- This suggests that faster promotions do not necessarily lead to higher retention, and other factors may contribute to employee turnover.

-- Calculate the average tenure (in months) of employees in each department
WITH Tenure_CTE AS (
    SELECT 
        d.dept_name,
        DATEDIFF(MONTH, de.from_date, 
                 CASE 
                     WHEN de.to_date = '9999-01-01' THEN GETDATE() 
                     ELSE de.to_date 
                 END) AS tenure_months,
        CASE 
            WHEN de.to_date = '9999-01-01' THEN 'Currently Working'
            ELSE 'Resigned'
        END AS category
    FROM department_employee de
    JOIN department d ON de.department_id = d.id
)
SELECT 
    dept_name,
    category,
    ROUND(AVG(CAST(tenure_months AS DECIMAL(18,2))), 2) AS avg_tenure_months
FROM Tenure_CTE
GROUP BY dept_name, category
ORDER BY avg_tenure_months DESC;
-- Employees who resigned had significantly shorter tenures across all departments, averaging around 50-57 months, compared to 107-125 months for those still working. 
-- Development, Sales, and HR had the longest tenures among current employees, while Customer Service had the shortest for both groups, indicating higher turnover in customer-facing roles.

-- Count how many times an employee has been promoted and calculate their average working years
WITH Promotion_CTE AS (
    SELECT 
        e.id,
        COUNT(t.title) AS num_promotions,
        ROUND(AVG(CAST(DATEDIFF(MONTH, e.hire_date, t.from_date) AS DECIMAL(18,2))), 2) AS avg_months,
        CASE 
            WHEN MAX(de.to_date) = '9999-01-01' THEN 'Currently Working'
            ELSE 'Resigned'
        END AS category
    FROM employee e
    JOIN title t ON e.id = t.employee_id
    JOIN department_employee de ON e.id = de.employee_id  -- Ki?m tra ngày r?i ði trong b?ng department_employee
    WHERE t.from_date > e.hire_date
    GROUP BY e.id
)
SELECT category, 
       ROUND(AVG(num_promotions), 2) AS avg_promotions,
       ROUND(AVG(avg_months), 2) AS avg_months_to_promotion
FROM Promotion_CTE
GROUP BY category;
-- Both resigned and currently working employees received an average of one promotion, but those who resigned achieved it faster (67.17 months vs. 78.98 months). 
-- This suggests that quicker promotions may not necessarily lead to longer retention, possibly due to other factors like job satisfaction or external opportunities.

-------------------------------------------
/* ============================
   9. Multivariate Analysis
   ============================ */

-- Calculate the average salary per job title within each department
WITH Salary_CTE AS (
    SELECT 
        d.dept_name, 
        t.title, 
        ROUND(AVG(CAST(s.amount AS DECIMAL(18,2))), 2) AS avg_salary, 
        COUNT(*) AS num_employees,
        CASE 
            WHEN de.to_date = '9999-01-01' THEN 'Currently Working'
            ELSE 'Resigned'
        END AS category
    FROM salary s
    JOIN title t ON s.employee_id = t.employee_id
    JOIN department_employee de ON s.employee_id = de.employee_id
    JOIN department d ON de.department_id = d.id
    GROUP BY d.dept_name, t.title, 
             CASE 
                 WHEN de.to_date = '9999-01-01' THEN 'Currently Working'
                 ELSE 'Resigned'
             END
)
SELECT dept_name, title, category, avg_salary, num_employees
FROM Salary_CTE
ORDER BY avg_salary DESC;
-- Sales roles tend to have the highest salaries, with Senior Staff (Resigned) earning the most (83,921 USD), followed by Assistant Engineers in Customer Service (82,978 USD). However, Sales Staff who resigned also earned higher than those currently working.
-- Finance and Marketing Senior Staff see a noticeable salary drop between resigned and current employees, suggesting that those who left may have had more experience or better negotiating power before departure.
-- Technical roles in Research, Development, and Production have lower salaries compared to business-oriented roles like Sales and Finance, reflecting industry-wide trends.
-- Customer Service and Production roles have the lowest-paid positions, with some roles below 50,000 USD, which could contribute to higher turnover in these departments.
-- Across multiple departments, resigned employees often had slightly higher salaries than currently working employees, indicating that salary may not be the primary reason for resignation—other factors like job satisfaction, work environment, or career growth may play a role.

-- Analyze how salary varies across age groups and job titles
WITH Salary_CTE AS (
    SELECT 
        CASE 
            WHEN DATEDIFF(YEAR, e.birth_date, GETDATE()) < 30 THEN '<30'  
            WHEN DATEDIFF(YEAR, e.birth_date, GETDATE()) BETWEEN 30 AND 40 THEN '30-40'
            WHEN DATEDIFF(YEAR, e.birth_date, GETDATE()) BETWEEN 41 AND 50 THEN '41-50'
            ELSE '50+' 
        END AS age_group,
        t.title,
        CASE 
            WHEN de.to_date = '9999-01-01' THEN 'Currently Working'
            ELSE 'Resigned'
        END AS employment_status,
        ROUND(AVG(CAST(s.amount AS DECIMAL(18,2))), 2) AS avg_salary,
        COUNT(*) AS num_employees
    FROM employee e
    JOIN salary s ON e.id = s.employee_id
    JOIN title t ON e.id = t.employee_id
    JOIN department_employee de ON e.id = de.employee_id
    GROUP BY 
        CASE 
            WHEN DATEDIFF(YEAR, e.birth_date, GETDATE()) < 30 THEN '<30'  
            WHEN DATEDIFF(YEAR, e.birth_date, GETDATE()) BETWEEN 30 AND 40 THEN '30-40'
            WHEN DATEDIFF(YEAR, e.birth_date, GETDATE()) BETWEEN 41 AND 50 THEN '41-50'
            ELSE '50+' 
        END,
        t.title,
        CASE 
            WHEN de.to_date = '9999-01-01' THEN 'Currently Working'
            ELSE 'Resigned'
        END
)
SELECT age_group, title, employment_status, avg_salary, num_employees
FROM Salary_CTE
ORDER BY avg_salary DESC;
-- Employees aged 50+ generally have higher average salaries than younger age groups, especially in senior roles. For example, Senior Staff (Resigned) in this age group earn 76,992 USD, higher than other age groups in the same role.
-- Resigned employees in most age groups tend to have slightly higher salaries than those currently working, reinforcing the trend that salary might not be the only factor influencing resignations.
-- The 30-40 age group has a significant workforce in senior and technical roles, suggesting this is a critical career development phase. However, resignations in this group occur more frequently in high-skill roles like Senior Engineer (61,142 USD) and Technique Leader (59,646 USD).
-- The 41-50 age group dominates employment, especially in technical roles, with a large number of Senior Engineers (14,099 employees) and Engineers (13,881 employees) currently working.
-- Technique Leader and Assistant Engineer roles in all age groups tend to have lower salaries, which may contribute to higher turnover rates in these positions.
-- The salary gap between currently working and resigned employees is most noticeable in Senior Staff and Senior Engineer roles, which might indicate that higher-paid individuals leave for better opportunities or early retirement.

-- Calculate the average time taken for promotion in each department
WITH Promotion_CTE AS (
    SELECT 
        d.dept_name,
        CASE 
            WHEN de.to_date = '9999-01-01' THEN 'Currently Working'
            ELSE 'Resigned'
        END AS employment_status,
        ROUND(AVG(DATEDIFF(MONTH, e.hire_date, t.from_date)), 2) AS avg_months_to_promotion 
    FROM employee e
    JOIN title t ON e.id = t.employee_id
    JOIN department_employee de ON e.id = de.employee_id
    JOIN department d ON de.department_id = d.id
    WHERE t.from_date > e.hire_date
    GROUP BY d.dept_name, 
             CASE 
                 WHEN de.to_date = '9999-01-01' THEN 'Currently Working'
                 ELSE 'Resigned'
             END
)
SELECT dept_name, employment_status, avg_months_to_promotion
FROM Promotion_CTE
ORDER BY avg_months_to_promotion ASC;
-- Employees who resigned generally experienced faster promotions across all departments, with an average of 70-73 months to promotion compared to 79-80 months for those currently working. This suggests that employees who advance faster might also seek better opportunities elsewhere.
-- Research, Sales, and Customer Service have the longest promotion times for currently working employees (79 months), indicating potential slower career progression in these departments.
-- Departments like Development, Finance, HR, Marketing, Production, and Quality Management take around 80 months for promotions for employees who stayed, suggesting a consistent promotion timeline in most non-sales roles.
-- The gap in promotion speed between resigned and currently working employees is small (7-9 months), implying that promotion speed alone may not be the main factor behind resignations. Other reasons, such as job satisfaction, salary, or work-life balance, might contribute to turnover.