/*
  Project: Advanced SQL Subqueries & Analytical Filtering
  Database: Oracle HR Schema
  Author: Vüsal Bağırov
  
  Key Features & Functions Used:
  -----------------------------
  1. Scalar Subqueries: Using subqueries in the SELECT clause to fetch related names.
  2. Multi-Row Subqueries: Implementing IN, ANY, and ALL operators for complex filtering.
  3. Aggregated Subqueries: Finding the 2nd lowest salary and max/min earners.
  4. Logical Comparisons: Using Subqueries in the HAVING clause for group-level filtering.
  5. Composite Subqueries: Matching multiple columns (Row Constructors) simultaneously.
*/

-- 1. Əməkdaşların işə girdiyi ilin neçənci günü olduğunu tapmaq
SELECT 
    first_name, 
    hire_date, 
    TO_CHAR(hire_date, 'DDD') AS day_of_year
FROM employees;

-- 2. Ayın sonuna neçə gün qaldığını dinamik hesablamaq
SELECT 
    LAST_DAY(SYSDATE) - SYSDATE AS days_until_month_end
FROM DUAL;

-- 3. "Karen" adını və digər adlardakı oxşar hərfləri şifrələmək (TRANSLATE)
-- Qeyd: K=1, A=2, R=3, E=4, N=5 olaraq bütün adlara tətbiq edilir.
SELECT 
    first_name, 
    TRANSLATE(LOWER(first_name), 'karen', '12345') AS encoded_name
FROM employees;

-- 4. Ortalama maaşdan yüksək alanlar (Single-row subquery)
SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC;

-- 5. Ən az ikinci maaşı alan əməkdaşı tapmaq
-- Məntiq: Ən az maaşdan böyük olanların içində ən kiçiyini tapmaq.
SELECT * FROM employees
WHERE salary = (SELECT MIN(salary) 
                FROM employees 
                WHERE salary > (SELECT MIN(salary) FROM employees));

-- 6. Menecer ID-si 108 olan şəxslə eyni departamentdə olanlar
SELECT * FROM employees
WHERE department_id IN (SELECT department_id 
                        FROM employees 
                        WHERE manager_id = 108);

-- 7. Scalar Subquery: Əməkdaşın departament adını gətirmək
SELECT 
    first_name, last_name, salary,
    (SELECT department_name 
     FROM departments d 
     WHERE d.department_id = e.department_id) AS department_name
FROM employees e;

-- 8. Scalar Subquery: Əməkdaşın vəzifə adını (Job Title) gətirmək
SELECT 
    first_name, last_name, salary,
    (SELECT job_title 
     FROM jobs j 
     WHERE j.job_id = e.job_id) AS job_title
FROM employees e;

-- 9. Dept 100-də ən az maaş alandan daha çox maaş alanlar (ANY operatoru)
SELECT first_name, last_name, salary, department_id
FROM employees 
WHERE salary > ANY (SELECT salary 
                    FROM employees 
                    WHERE department_id = 100);

-- 10. Dept 80-dəki bütün işçilərdən daha az maaş alanlar (ALL operatoru)
SELECT first_name, last_name, salary, department_id
FROM employees
WHERE salary < ALL (SELECT salary 
                    FROM employees 
                    WHERE department_id = 80);

-- 11. Employee_id 110 ilə eyni vəzifədə (job_id) olanlar
SELECT * FROM employees
WHERE job_id = (SELECT job_id 
                FROM employees 
                WHERE employee_id = 110);

-- 12. Employee_id 106-dan daha çox maaş alanlar
SELECT first_name, last_name, salary
FROM employees
WHERE salary > (SELECT salary 
                FROM employees 
                WHERE employee_id = 106);

-- 13. Şirkətdə ən çox maaş alan şəxsin tam məlumatı
SELECT * FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees);

-- 14. "AD_VP" vəzifəsindən daha çox əməkdaşı olan vəzifələri tapmaq
SELECT 
    job_id, 
    COUNT(*) AS emp_count
FROM employees
GROUP BY job_id
HAVING COUNT(*) > (SELECT COUNT(*) 
                   FROM employees 
                   WHERE job_id = 'AD_VP');

-- 15. Composite Subquery: Employee_id 122 ilə həm departamenti, həm də vəzifəsi eyni olanlar
SELECT * FROM employees
WHERE (department_id, job_id) = (SELECT department_id, job_id 
                                 FROM employees 
                                 WHERE employee_id = 122);
