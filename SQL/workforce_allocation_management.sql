/*

Workforce Allocation & Management

*/

/* 
1. Workforce Structure
Analytical Questions:
- How many employees are in each department?
- What is the employee-to-manager ratio?
- Which departments are overstaffed or have too few managers?
*/

SELECT d.dept_name, 
       COUNT(DISTINCT de.employee_id) AS num_employees, 
       COUNT(DISTINCT dm.employee_id) AS num_managers, 
       ROUND(COUNT(DISTINCT de.employee_id) * 1.0 / NULLIF(COUNT(DISTINCT dm.employee_id), 0), 2) AS employee_manager_ratio
FROM department d
LEFT JOIN department_employee de ON d.id = de.department_id
LEFT JOIN department_manager dm ON d.id = dm.department_id
WHERE de.to_date = '9999-01-01'
  AND (dm.to_date = '9999-01-01' OR dm.to_date IS NULL)
GROUP BY d.dept_name
ORDER BY num_employees DESC;

-- How many employees is each manager responsible for on average?
SELECT ROUND(AVG(num_employees * 1.0), 2) AS avg_employees_per_manager
FROM (
    SELECT de.department_id, COUNT(de.employee_id) AS num_employees
    FROM department_employee de
    WHERE de.to_date = '9999-01-01'
    GROUP BY de.department_id
) emp_count;

/*
Data Analysis & Insights
?? Biggest Issue:
- The employee-to-manager ratio is too high, which is impractical in reality.
- A single manager cannot effectively supervise, support, and evaluate thousands of employees.
?? Possible Causes:
Data Inaccuracy – The data in the department_manager table might be incomplete or incorrect.
- Verify by checking the historical number of managers in each department.
- The data might only record the highest-level manager while omitting mid-level managers.
Management Structure Issues – If the data is accurate, the company might be operating under an extremely decentralized management model with very few managers, leading to:
- Lack of supervision and employee support.
- Employees feeling unguided and demotivated.
- Decline in work quality due to insufficient managerial feedback.
Unrecorded Managers – The system might not register mid-level managers, only recognizing a single top-level manager per department.
*/

-- Total number of managers who have held a managerial position in each department (both past & present)
SELECT d.dept_name, 
       COUNT(DISTINCT dm.employee_id) AS total_managers
FROM department d
JOIN department_manager dm ON d.id = dm.department_id
GROUP BY d.dept_name
ORDER BY total_managers DESC;
-- Some departments have more than one manager, but the number is still very small compared to the number of employees.

SELECT d.dept_name, 
       COUNT(DISTINCT dm.employee_id) AS current_managers
FROM department_manager dm
JOIN department d ON dm.department_id = d.id
WHERE dm.to_date = '9999-01-01'
GROUP BY d.dept_name
ORDER BY current_managers DESC;
-- The result returns 1 manager/department, which means the system only maintains one manager at a time.

/* 
Proposed Solutions
?? If this data reflects reality, the company should improve its management model by:

? Adding more mid-level managers – To supervise employees more effectively.
? Implementing multi-level management delegation – Instead of having only one senior manager, introduce team leaders and department heads to distribute the workload.
? Evaluating management performance – If a single manager is truly overseeing more than 1,000 employees, their efficiency may be compromised.
*/

-------------------------------------------
/*
2. Management Performance & Workforce Balance
Analysis Questions:
- What is the average number of years employees work under each manager?
- What is the average number of years each manager has held a managerial position?
- Which department has the highest turnover rate?
*/

-- Average experience of employees in each department
SELECT d.dept_name, 
       ROUND(AVG(DATEDIFF(YEAR, e.hire_date, GETDATE())), 2) AS avg_tenure_years
FROM employee e
JOIN department_employee de ON e.id = de.employee_id
JOIN department d ON de.department_id = d.id
WHERE de.to_date = '9999-01-01'
GROUP BY d.dept_name
ORDER BY avg_tenure_years DESC;
/*
Initial Conclusion:
- Employees have a similar age range across departments, with no clear differences in average experience.
- The company may have been in business for over 13 years, or it may have a stable hiring policy, retaining staff over a long period of time.
- If the data is from several years and there are no issues, this may reflect a stable work environment, with little turnover between departments.
*/

-- Average time in management for each manager
SELECT dm.employee_id, d.dept_name, 
       ROUND(AVG(DATEDIFF(YEAR, dm.from_date, GETDATE())), 2) AS avg_manager_tenure
FROM department_manager dm
JOIN department d ON dm.department_id = d.id
WHERE dm.to_date = '9999-01-01'
GROUP BY dm.employee_id, d.dept_name
ORDER BY avg_manager_tenure DESC;

/*
The data indicates significant differences in the average tenure of managers across departments:
- Finance has the longest-serving managers (14 years), which may reflect stability in managerial positions or a high level of experience required in this field.
- Marketing, Research, and Sales have an average tenure of around 12 years, suggesting long-term commitment but slightly less than in Finance.
- Human Resources and Development managers have an average of 11 years, possibly highlighting the importance of experience in managing personnel and organizational development.
- Quality Management, Customer Service, and Production have the shortest tenure (7-9 years), potentially due to:
Changing role requirements over time.
- High competition and job pressure leading to more frequent managerial turnover.
Promotion policies or internal rotation programs affecting managerial retention.
*/

SELECT d.dept_name, 
       COUNT(DISTINCT CASE WHEN de.to_date != '9999-01-01' THEN de.employee_id END) AS num_left,
       COUNT(DISTINCT de.employee_id) AS total_employees,
       ROUND((COUNT(DISTINCT CASE WHEN de.to_date != '9999-01-01' THEN de.employee_id END) * 100.0) / 
             COUNT(DISTINCT de.employee_id), 2) AS turnover_rate
FROM department_employee de
JOIN department d ON de.department_id = d.id
GROUP BY d.dept_name
ORDER BY turnover_rate DESC;

/*
The data shows a significant disparity in turnover rates across departments, with Finance having the highest turnover rate (28.57%), followed by Development (28.03%), Sales (27.83%), and Production (27.42%). Meanwhile, Customer Service has the lowest turnover rate (25.93%).
Notably, departments with high turnover rates tend to have long-tenured managers (~12-14 years), particularly Finance (14 years). This may indicate that:
- Managerial stability does not guarantee employee retention. Departments with long-serving leaders may face challenges in innovation or career advancement opportunities, leading to higher employee turnover.
- Corporate culture or employee development policies might lack flexibility, especially in departments with high turnover rates.
On the other hand, Customer Service, which has the lowest turnover rate (25.93%), also has the shortest managerial tenure (7 years). This suggests that frequent management changes may not negatively impact employee retention—in fact, they might even contribute to better retention.
*/
/*
Conclusion:
Overall, the data reflects a generally stable work environment, with employees averaging 13 years of tenure. However, workforce fluctuations remain a concern. Some departments could benefit from managerial rotation policies, while others may need to improve workplace culture or employee benefits to reduce turnover.
*/