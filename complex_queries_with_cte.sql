/*
  Project: Advanced CTEs (Common Table Expressions) & Business Metrics
  Database: Oracle HR Schema
  Author: Vüsal Bağırov
  
  Key Features & Functions Used:
  -----------------------------
  1. CTE (WITH Clause): Breaking down complex logic into readable, modular blocks.
  2. Subqueries in Calculations: Using scalar subqueries for global metrics (Max/Sum).
  3. Career Path Logic: Calculating work experience (Years Worked) using MONTHS_BETWEEN.
  4. Percentage Analysis: Calculating the share of department salaries in the total budget.
  5. Fetch First: Limiting top results for performance-focused reporting.
*/

-- 1. Departament üzrə ortalama maaşdan çox alanlar (Modular CTE approach)
WITH DeptAvg AS (
    SELECT 
        department_id,
        AVG(salary) as avg_salary
    FROM employees
    GROUP BY department_id 
)
SELECT
    e.first_name, e.last_name, e.salary,
    d.department_name,
    ROUND(da.avg_salary, 2) as department_average
FROM employees e 
JOIN departments d ON e.department_id = d.department_id 
JOIN DeptAvg da ON da.department_id = e.department_id
WHERE e.salary > da.avg_salary;

-- 2. Ən çox işçisi olan ilk 3 departament (Top-N Analysis)
WITH DeptCounts AS (
    SELECT
        department_id,
        COUNT(employee_id) as worker_count
    FROM employees
    GROUP BY department_id
)
SELECT
    d.department_name,
    dc.worker_count
FROM DeptCounts dc 
JOIN departments d ON dc.department_id = d.department_id
ORDER BY dc.worker_count DESC
FETCH FIRST 3 ROWS ONLY;

-- 3. Maksimum maaşla müqayisə (Salary Gap Analysis)
WITH MaxSalTable AS ( 
    SELECT MAX(salary) as top_salary FROM employees
)
SELECT 
    e.first_name, e.last_name, e.salary,
    ((SELECT top_salary FROM MaxSalTable) - e.salary) as salary_gap
FROM employees e;

-- 4. Ümumi büdcə və 10% artım simulyasiyası
WITH SalaryInfo AS (
    SELECT
        COUNT(employee_id) as employee_count,
        SUM(salary) as total_salary
    FROM employees 
)
SELECT 
    employee_count,
    total_salary,
    total_salary * 1.10 as total_salary_after_raise,
    total_salary * 0.10 as total_raise_amount
FROM SalaryInfo;

-- 5. Departamentlərin ümumi büdcədəki faiz payı (%)
WITH TotalSalaryPerDept AS (
    SELECT 
        department_id,
        SUM(salary) as dept_total
    FROM employees
    GROUP BY department_id
)
SELECT 
    d.department_id,
    d.department_name,
    ts.dept_total as department_total_salary,
    ROUND((ts.dept_total / (SELECT SUM(salary) FROM employees)) * 100, 2) as percent_of_total_budget
FROM departments d 
JOIN TotalSalaryPerDept ts ON d.department_id = ts.department_id;

-- 6. İş stajına görə vəzifə təyini (Junior/Middle/Senior)
WITH EmpTenure AS (
    SELECT
        employee_id, first_name, last_name, hire_date,
        MONTHS_BETWEEN(SYSDATE, hire_date) / 12 as years_worked
    FROM employees
)
SELECT 
    employee_id, first_name, last_name,
    CASE
        WHEN years_worked < 8 THEN 'Junior'
        WHEN years_worked < 13 THEN 'Middle'
        ELSE 'Senior'
    END as career_level
FROM EmpTenure;
