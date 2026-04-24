/*
  Project: Advanced SQL Joins and Relational Data Analysis
  Database: Oracle HR Schema
  Author: Vüsal Bağırov
  
  Key Features & Functions Used:
  -----------------------------
  1. Join Types: INNER JOIN, LEFT/RIGHT OUTER JOIN, FULL OUTER JOIN, SELF JOIN
  2. Multi-Table Joins: Connecting 4+ tables (Employees -> Departments -> Locations -> Countries)
  3. Legacy vs Standard: ANSI SQL Standards vs Oracle Classic (+) Syntax
  4. String & Date Integration: SUBSTR, ADD_MONTHS with Join conditions
  5. Aggregate Analytics with Joins: GROUP BY with multi-table data
*/

-- 1. Müəyyən Job_id-lər üzrə Departament adının hissələrini gətirmək
SELECT 
    e.job_id, 
    d.department_name, 
    SUBSTR(d.department_name, -4, 2) AS dept_name_part
FROM employees e 
JOIN departments d ON e.department_id = d.department_id
WHERE e.job_id IN ('FI_ACCOUNT', 'PU_CLERK') 
  AND e.salary > 5000;

-- 2. Oxford şəhərində yaşayanlar üçün təkmilləşdirilmiş tarix hesablama
-- 3 il 2 ay 10 gün sonranı tapmaq
SELECT 
    e.first_name, e.salary, l.city, e.hire_date,
    ADD_MONTHS(e.hire_date, (3*12) + 2) + 10 AS calculated_date
FROM employees e 
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
WHERE LOWER(l.city) = 'oxford' 
  AND e.salary > 7500;

-- 3. Adın və Soyadın baş hərflərinin birləşməsi 'AB' olanlar
SELECT first_name, last_name
FROM employees
WHERE LOWER(SUBSTR(first_name, 1, 1) || SUBSTR(last_name, 1, 1)) = 'ab';

-- 4. Yüksək maaşlı əməkdaşlar və departament adları
SELECT 
    e.first_name, e.salary, d.department_name
FROM employees e 
JOIN departments d ON e.department_id = d.department_id
WHERE e.salary > 10000
ORDER BY e.salary DESC;

-- 5. Əməkdaşlar və vəzifələrin tam adları (Jobs cədvəli ilə)
SELECT 
    e.first_name, e.last_name, e.salary, j.job_title
FROM employees e 
JOIN jobs j ON e.job_id = j.job_id;

-- 6. Departament üzrə əməkdaş sayı (Say >= 5 olanlar)
SELECT 
    d.department_name, 
    COUNT(e.employee_id) AS emp_count
FROM employees e 
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING COUNT(e.employee_id) >= 5
ORDER BY emp_count DESC;

-- 7. Seattle və ya Oxford-da işləyən yüksək maaşlı əməkdaşların tam ünvanı
SELECT 
    e.first_name || ' ' || e.last_name AS full_name,
    e.salary, d.department_name, l.city, l.street_address
FROM employees e 
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
WHERE LOWER(l.city) IN ('seattle', 'oxford') 
  AND e.salary > 10000;

-- 8. Şəhərlər üzrə əməkdaş bölgüsü (Bütün şəhərlər daxil olmaqla)
SELECT 
    l.city, 
    COUNT(e.employee_id) AS emp_count
FROM locations l
LEFT JOIN departments d ON l.location_id = d.location_id
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY l.city
ORDER BY emp_count DESC;

-- 9. 12000-dən çox maaş alanların ölkə səviyyəsinə qədər detalları
SELECT 
    e.first_name, e.last_name, d.department_name, l.city, c.country_name
FROM employees e 
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
JOIN countries c ON l.country_id = c.country_id
WHERE e.salary > 12000;

-- 10. Ölkələr üzrə əməkdaş sayı və maaş statistikası
SELECT 
    c.country_name,
    COUNT(e.employee_id) AS emp_count,
    SUM(e.salary) AS total_salary,
    ROUND(AVG(e.salary), 2) AS avg_salary
FROM countries c
JOIN locations l ON c.country_id = l.country_id
JOIN departments d ON l.location_id = d.location_id
JOIN employees e ON d.department_id = e.department_id
GROUP BY c.country_name
ORDER BY emp_count DESC;

-- 11. Bütün departamentlərin gəlməsi (Standard vs Classic)
-- ANSI Standart
SELECT e.first_name, d.department_name
FROM employees e 
RIGHT JOIN departments d ON e.department_id = d.department_id;

-- Oracle Classic (+)
SELECT e.first_name, d.department_name
FROM employees e, departments d
WHERE e.department_id(+) = d.department_id;

-- 12. Self Join: Əməkdaşlar və onların menecerləri
SELECT 
    e.first_name AS employee,
    m.first_name AS manager
FROM employees e 
LEFT JOIN employees m ON e.manager_id = m.employee_id;

-- 13. Full Outer Join: Hər iki cədvəldən bütün datalar
SELECT e.first_name, d.department_name
FROM employees e 
FULL OUTER JOIN departments d ON e.department_id = d.department_id;

-- 14. Ölkələr və Regionlar
SELECT c.country_name, r.region_name
FROM countries c 
JOIN regions r ON c.region_id = r.region_id;
