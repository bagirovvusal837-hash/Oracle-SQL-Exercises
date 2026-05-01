/*
  Project: Strategic Workforce Analytics & Analytic Functions (Case Study 3)
  Database: Oracle SQL (HR Schema)
  Author: Vüsal Bağırov
  
  Key Features & Solutions:
  -------------------------
  1. Window Functions: Using DENSE_RANK() and AVG() OVER(PARTITION BY...) for granular department analysis.
  2. Data Parsing: Advanced String manipulation using REGEXP_REPLACE for character counting and INSTR/SUBSTR for dynamic email parsing.
  3. Pattern Logic: Identifying even-numbered Employee IDs with long-term seniority (>20 years).
  4. Global Aggregation: Correlating workforce metrics (count, avg salary) across multi-national entities (Countries/Locations).
  5. CTE Implementation: Utilizing 'WITH' clauses for multi-stage ranking and filtering.
  6. Dynamic Substitution: Implementing prompt-based (&department_id) SQL reporting for end-users.
*/

-- 1. Dinamik Hesabat: Prompt vasitəsilə departament üzrə maaş və komissiya analizi
SELECT
  first_name || ' ' || last_name AS full_name,
  TO_CHAR(hire_date, 'dd Month, yyyy') AS hire_date,
  NVL(commission_pct, 0) AS com_pct,
  TO_CHAR(salary, '999,999.00') AS salary
FROM employees
WHERE department_id = &department_id;

-- 5. Departament daxili maaş rütbəsi və ortalama müqayisəsi (Analytic Functions)
SELECT
  first_name, last_name, salary, department_id,
  DENSE_RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) AS salary_rank,
  ROUND(AVG(salary) OVER(PARTITION BY department_id), 2) AS dept_avg_sal,
  CASE
    WHEN salary > AVG(salary) OVER(PARTITION BY department_id) THEN 'Above Avg'
    WHEN salary < AVG(salary) OVER(PARTITION BY department_id) THEN 'Below Avg'
    ELSE 'Equal Avg'
  END AS sal_comparison
FROM employees;

-- 8. Dinamik Email Generator və Ad/Soyadın ayrılması (Parsing Logic)
SELECT
  first_name, last_name,
  REPLACE(LOWER(first_name || '.' || last_name || '@gmail.com'), ' ', '') AS email,
  SUBSTR(LOWER(first_name || '.' || last_name || '@gmail.com'), 1, 
         INSTR(LOWER(first_name || '.' || last_name || '@gmail.com'), '.') - 1) AS parsed_first_name,
  SUBSTR(LOWER(first_name || '.' || last_name || '@gmail.com'), 
         INSTR(LOWER(first_name || '.' || last_name || '@gmail.com'), '.') + 1,
         INSTR(LOWER(first_name || '.' || last_name || '@gmail.com'), '@') - 
         INSTR(LOWER(first_name || '.' || last_name || '@gmail.com'), '.') - 1) AS parsed_last_name
FROM employees;

-- 10. CTE ilə Spesifik Maaş Rütbəsinin (22-ci yer) tapılması
WITH ranked_emp AS (
  SELECT
    e.first_name, e.last_name, e.salary, e.department_id,
    DENSE_RANK() OVER (ORDER BY e.salary DESC) AS sal_rank
  FROM employees e 
)
SELECT
  r.first_name, r.last_name, r.salary, d.department_name
FROM ranked_emp r 
JOIN departments d ON r.department_id = d.department_id
WHERE r.sal_rank = 22;
