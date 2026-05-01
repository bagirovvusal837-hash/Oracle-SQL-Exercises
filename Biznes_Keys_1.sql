/*
  Project: Business Logic & Data Transformation (Case Study 1)
  Database: Oracle SQL (HR Schema)
  Author: Vüsal Bağırov
  
  Key Features & Solutions:
  -------------------------
  1. String Engineering: Dynamic Full_name generation and character length analysis.
  2. Workforce Analytics: Identifying hiring trends by Year and Quarter (Q1-Q4).
  3. Pattern Matching: Complex filtering using LIKE and Logical Operators.
  4. Financial Integrity: Handling NULL values in commissions and calculating seniority-based bonuses.
  5. Conditional logic: Salary increments based on ID parity (Odd/Even) and Mobile Operator mapping.
  6. Email Automation: Generating corporate emails with character translation (w->ü, s->ş).
*/

-- 1. Dinamik Ad Yaradılması və Uzunluq Hesablanması
SELECT
    SUBSTR(first_name, 1, 5) || '-' || SUBSTR(last_name, 1, 5) AS full_name,
    LENGTH(SUBSTR(first_name, 1, 5) || '-' || SUBSTR(last_name, 1, 5)) AS name_length
FROM employees;

-- 2. Kadr Tarixçəsi: 12 aydan az işləyən departamentlərin analizi
SELECT 
    TRUNC(MONTHS_BETWEEN(jh.end_date, jh.start_date)) AS month_diff, 
    d.department_name
FROM job_history jh 
JOIN departments d ON jh.department_id = d.department_id 
WHERE MONTHS_BETWEEN(jh.end_date, jh.start_date) < 12;

-- 7. Coğrafi Maaş Analizi (Joins & Grouping)
SELECT
    l.city, 
    COUNT(e.employee_id) AS employee_count, 
    ROUND(AVG(e.salary), 2) AS avg_salary
FROM employees e 
JOIN departments d ON e.department_id = d.department_id 
RIGHT JOIN locations l ON d.location_id = l.location_id
GROUP BY l.city
ORDER BY employee_count DESC;

-- 9. Şərti Maaş Artımı və Operator Təyini (Business Rules)
SELECT
    first_name, last_name, salary,
    CASE
        WHEN MOD(employee_id, 2) = 1 THEN salary + 400
        ELSE salary + 500
    END AS new_salary,
    phone_number,
    CASE SUBSTR(phone_number, 1, 3)
        WHEN '590' THEN 'Azercell'
        WHEN '515' THEN 'Bakcell'
        WHEN '650' THEN 'Nar Mobile'
        ELSE 'Diger'
    END AS operator
FROM employees;

-- 10. Rüblük Analiz və Avtomatlaşdırılmış Email Generasiyası
SELECT
    first_name, last_name,
    CASE
        WHEN TO_CHAR(hire_date, 'Q') = '1' THEN '1-ci rub'
        WHEN TO_CHAR(hire_date, 'Q') = '2' THEN '2-ci rub'
        WHEN TO_CHAR(hire_date, 'Q') = '3' THEN '3-cu rub'
        ELSE '4-cu rub'
    END AS quarter,
    REPLACE(LOWER(TRANSLATE(first_name || last_name, 'ws', 'üş') || '@company.com'), ' ', '') AS email
FROM employees;
