/*
  Project: SQL Aggregations and Grouping Analysis
  Database: Oracle HR Schema
  Author: Vüsal Bağırov
  
  Key Features & Functions Used:
  -----------------------------
  1. Aggregate Functions: SUM, AVG, MIN, MAX, COUNT
  2. Grouping Logic: GROUP BY, HAVING, ROLLUP, GROUPING SETS
  3. Advanced Filtering: DISTINCT, CASE WHEN inside Aggregates
  4. Date Calculations: SYSDATE - HIRE_DATE (Day calculations)
*/

-- 1. Şəhərlərə görə Ölkə adlarının təyini (CASE logic)
SELECT 
    location_id, 
    city,
    CASE 
        WHEN LOWER(city) IN ('roma', 'venice') THEN 'Italy'
        WHEN LOWER(city) IN ('tokyo', 'hiroshima') THEN 'Japan'
        WHEN LOWER(city) IN ('london', 'oxford') THEN 'England'
        ELSE 'Unknown'
    END AS country_name
FROM locations;

-- 2. Manager_id-lərə görə maaş statistikası
SELECT 
    manager_id, 
    SUM(salary) AS total_salary, 
    ROUND(AVG(salary), 2) AS avg_salary, 
    MIN(salary) AS min_salary, 
    MAX(salary) AS max_salary
FROM employees
GROUP BY manager_id;

-- 3. Unikal department_id-lərin gətirilməsi (İki üsul)
-- Üsul 1: DISTINCT
SELECT DISTINCT department_id FROM employees;
-- Üsul 2: GROUP BY
SELECT department_id FROM employees GROUP BY department_id;

-- 4. Regionlar üzrə ölkə sayı (Yalnız 3-dən çox olanlar)
SELECT 
    region_id, 
    COUNT(*) AS country_count
FROM countries
GROUP BY region_id
HAVING COUNT(*) > 3
ORDER BY country_count DESC;

-- 5. Job_id üzrə əməkdaş sayı, orta maaş və təcrübə analizi (Say >= 5 olanlar)
SELECT 
    job_id, 
    COUNT(*) AS emp_count, 
    ROUND(AVG(salary), 2) AS avg_salary, 
    MIN(hire_date) AS most_experienced, 
    MAX(hire_date) AS least_experienced
FROM employees 
GROUP BY job_id
HAVING COUNT(*) >= 5;

-- 6. Cədvəl üzrə ümumi sətir və Commission analizi
SELECT 
    COUNT(*) AS total_rows,
    COUNT(commission_pct) AS non_null_commissions,
    COUNT(DISTINCT commission_pct) AS unique_comm_rates
FROM employees;

-- 7. 5-dən çox işçisi olan departamentlər (Kofe maşını layihəsi)
SELECT 
    department_id, 
    COUNT(*) AS emp_count
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 5
ORDER BY emp_count DESC;

-- 8. Ad və soyadın uzunluq statistikası
SELECT 
    SUM(LENGTH(first_name) + LENGTH(last_name)) AS total_len,
    ROUND(AVG(LENGTH(first_name) + LENGTH(last_name)), 2) AS avg_len,
    MIN(LENGTH(first_name) + LENGTH(last_name)) AS min_len,
    MAX(LENGTH(first_name) + LENGTH(last_name)) AS max_len
FROM employees;

-- 9. Maaş və Təcrübə fərqlərinin (Gap) tapılması
SELECT 
    MAX(salary) - MIN(salary) AS salary_gap,
    MAX(hire_date) - MIN(hire_date) AS experience_gap_days
FROM employees;

-- 10. Department və Job bazasında qruplaşdırma
SELECT 
    department_id, 
    job_id, 
    COUNT(*) AS emp_count
FROM employees
GROUP BY department_id, job_id
ORDER BY emp_count DESC;

-- 11. Şirkətdə keçirilən ümumi və orta günlərin sayı
SELECT 
    ROUND(SUM(SYSDATE - hire_date), 2) AS total_days_in_company,
    ROUND(AVG(SYSDATE - hire_date), 2) AS avg_days_per_employee
FROM employees;

-- 12. İllər üzrə işə giriş statistikası (2002, 2003, 2004)
SELECT 
    TO_CHAR(hire_date, 'YYYY') AS hire_year, 
    COUNT(*) AS emp_count
FROM employees
WHERE TO_CHAR(hire_date, 'YYYY') IN ('2002', '2003', '2004')
GROUP BY TO_CHAR(hire_date, 'YYYY')
ORDER BY hire_year;

-- 13. Hər Job_id üzrə 2006-cı ildən əvvəl işə girənlər
SELECT 
    job_id, 
    COUNT(*) AS emp_count
FROM employees
WHERE hire_date < TO_DATE('01.01.2006', 'DD.MM.YYYY')
GROUP BY job_id;

-- 14. Mürəkkəb vergi hesablaması (CASE logic)
SELECT 
    employee_id, 
    salary,
    CASE 
        WHEN salary <= 2500 THEN (salary - 200) * 0.14
        ELSE (salary - 2500) * 0.25 + 350
    END AS calculated_tax
FROM employees;

-- 15. Departament üzrə cəmlər və Ümumi Total (ROLLUP ilə)
SELECT 
    department_id, 
    COUNT(*) AS emp_count, 
    SUM(salary) AS total_dept_salary
FROM employees
GROUP BY ROLLUP(department_id);
