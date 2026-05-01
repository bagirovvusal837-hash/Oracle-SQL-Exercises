/*
  Project: Advanced Analytics & Data Engineering (Case Study 2)
  Database: Oracle SQL (HR Schema)
  Author: Vüsal Bağırov
  
  Key Features & Solutions:
  -------------------------
  1. Top-N Analytics: Retrieving the top 20% of earners using 'FETCH FIRST PERCENT'.
  2. String Aggregation: Compiling employee lists per manager into single strings using LISTAGG.
  3. Dynamic Filtering: Implementing parameterized reporting for flexible date and department ranges.
  4. Advanced Logic: Categorizing salary bands and identifying "Vakansiya" (open positions) via Outer Joins.
  5. Workforce Analysis: Correlating departmental averages against the global company average.
  6. Data Sanitization: Bulk salary updates and safe record deletion while preserving table structure.
*/

-- 6. Analitik Seçim: Ortalamadan çox maaş alanların ilk 20%-i
SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC
FETCH FIRST 20 PERCENT ROWS ONLY;

-- 8. Maaş Diapazonları (Salary Bands) üzrə Paylanma Hesabatı
SELECT
  CASE
    WHEN salary <= 5000 THEN '<=5k'
    WHEN salary > 5000 AND salary <= 10000 THEN '5-10k'
    ELSE '>10k'
  END AS salary_band,
  COUNT(*) AS employee_count
FROM employees
GROUP BY
  CASE
    WHEN salary <= 5000 THEN '<=5k'
    WHEN salary > 5000 AND salary <= 10000 THEN '5-10k'
    ELSE '>10k'
  END 
ORDER BY 1;

-- 9. LISTAGG: Menecerlər üzrə işçi siyahılarının aqreqasiyası
SELECT
  manager_id,
  LISTAGG(first_name, ', ') WITHIN GROUP (ORDER BY salary) AS employee_list,
  ROUND(AVG(salary), 2) AS avg_managed_salary
FROM employees
GROUP BY manager_id
ORDER BY manager_id;

-- 10. Departament vs Global Ortalama Analizi
SELECT
  d.department_name,
  ROUND(AVG(e.salary), 2) AS avg_dep_sal
FROM employees e 
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING AVG(e.salary) > (SELECT AVG(salary) FROM employees)
ORDER BY 2 DESC;

-- 11. Dinamik Parametrlərlə (Pancara) İdarə Olunan Hesabat
SELECT
  first_name, last_name, salary, l.city, hire_date, e.department_id
FROM employees e 
JOIN departments d ON e.department_id = d.department_id 
JOIN locations l ON d.location_id = l.location_id
WHERE hire_date BETWEEN :start_date AND :end_date
  AND e.department_id = :dept_id
ORDER BY hire_date;

-- 13-14. Data Maintenance: Maaş artımı və təmizlik
UPDATE emp_dummy SET salary = salary * 1.2 WHERE job_id = 'ST_CLERK';
DELETE FROM emp_dummy; -- Struktur saxlanılır, datalar silinir
