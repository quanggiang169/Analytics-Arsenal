-- Create a temporary table for current employees
SELECT 
    e.id, 
    e.birth_date, 
    e.first_name, 
    e.last_name, 
    e.gender, 
    e.hire_date,
    t.title,  -- Current job title
    s.amount AS latest_salary,  -- Latest salary
    d.dept_name  -- Current department name
INTO #current_employees
FROM employee e
JOIN title t ON e.id = t.employee_id AND t.to_date = '9999-01-01'  -- Active job title
JOIN salary s ON e.id = s.employee_id AND s.to_date = '9999-01-01'  -- Latest salary
JOIN department_employee de ON e.id = de.employee_id AND de.to_date = '9999-01-01'  -- Active department
JOIN department d ON de.department_id = d.id;  -- Get department name

-- Select data to verify
SELECT * FROM #current_employees;

-- Create a temporary table for former employees
SELECT 
    e.id, 
    e.birth_date, 
    e.first_name, 
    e.last_name, 
    e.gender, 
    e.hire_date,
    ISNULL(t.title, 'N/A') AS last_title,  -- Last job title before leaving
    ISNULL(s.amount, 0) AS last_salary,  -- Last recorded salary
    ISNULL(d.dept_name, 'N/A') AS last_department,  -- Last department before leaving
    MAX(ISNULL(NULLIF(t.to_date, '9999-01-01'), NULLIF(s.to_date, '9999-01-01'))) AS exit_date  -- Last recorded working date
INTO #former_employees
FROM employee e
LEFT JOIN title t ON e.id = t.employee_id AND t.to_date <> '9999-01-01'  -- Past job titles
LEFT JOIN salary s ON e.id = s.employee_id AND s.to_date <> '9999-01-01'  -- Past salaries
LEFT JOIN department_employee de ON e.id = de.employee_id AND de.to_date <> '9999-01-01'  -- Past departments
LEFT JOIN department d ON de.department_id = d.id  -- Get department name
WHERE e.id NOT IN (
    -- Exclude employees who still have active job title, salary, or department
    SELECT employee_id FROM title WHERE to_date = '9999-01-01'
    UNION
    SELECT employee_id FROM salary WHERE to_date = '9999-01-01'
    UNION
    SELECT employee_id FROM department_employee WHERE to_date = '9999-01-01'
)
GROUP BY e.id, e.birth_date, e.first_name, e.last_name, e.gender, e.hire_date, t.title, s.amount, d.dept_name;

-- Select data to verify
SELECT * FROM #former_employees;