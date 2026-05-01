/*
  Project: Advanced Analytical Window Functions & Data Ranking
  Database: Oracle HR Schema
  Author: Vüsal Bağırov
  
  Key Features & Functions Used:
  -----------------------------
  1. Window Functions: ROW_NUMBER(), RANK(), DENSE_RANK() for precise ordering.
  2. Partitoning: Segmenting data by Department and Job ID for granular analysis.
  3. Running Totals: Calculating cumulative sums using 'ORDER BY' within OVER().
  4. CTE (Common Table Expressions): Using WITH clause for cleaner subquery logic.
  5. Conditional Logic in Analytics: Merging CASE WHEN with Aggregate Window functions.
*/

-- 1. Maaşın bölünməsinə görə bonus təyini (MOD funksiyası ilə)
SELECT
  first_name, last_name, salary,
  CASE
    WHEN MOD(salary, 1000) = 0 THEN 1000
    WHEN MOD(salary, 500) = 0 THEN 500
    WHEN MOD(salary, 200) = 0 THEN 200
    ELSE 0
  END AS bonus_salary
FROM employees
ORDER BY salary DESC;

-- 2. Orta maaşdan az alanlara 10% artım (Alternative: WITH clause & OVER())
WITH average_calc AS (
  SELECT AVG(salary) AS avg_sal FROM employees
)
SELECT
  e.first_name, e.last_name, e.salary AS old_salary,
  CASE
    WHEN e.salary < a.avg_sal THEN e.salary * 1.1
    ELSE e.salary
  END AS new_salary
FROM employees e CROSS JOIN average_calc a;

-- 3. Hər departament üzrə ən yüksək maaş alanlar (RANK())
SELECT * FROM (
  SELECT
    first_name, last_name, department_id, salary,
    RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) as salary_rank
  FROM employees 
) WHERE salary_rank = 1;

-- 4 & 5. Unikal ardıcıl nömrələmə (ROW_NUMBER)
SELECT
  first_name, last_name, salary,
  ROW_NUMBER() OVER(ORDER BY salary) AS salary_order
FROM employees;

-- 6. Maaşına görə ən çox alan 15-ci adamın tapılması
SELECT * FROM (
  SELECT
    first_name, last_name, salary,
    ROW_NUMBER() OVER(ORDER BY salary DESC) as salary_numb
  FROM employees 
) WHERE salary_numb = 15;

-- 7. Maaş sırasına görə 5-10 arası (Bərabər maaşlara eyni sıra - DENSE_RANK)
SELECT * FROM (
  SELECT
    first_name, last_name, salary,
    DENSE_RANK() OVER(ORDER BY salary DESC) as salary_rank
  FROM employees 
) WHERE salary_rank BETWEEN 5 AND 10;

-- 8. Employee_ID-yə görə 20-40 arası sətirlər (Pagination məntiqi)
SELECT * FROM (
  SELECT
    employee_id, first_name, last_name,
    ROW_NUMBER() OVER(ORDER BY employee_id) as row_num
  FROM employees 
) WHERE row_num BETWEEN 20 AND 40;

-- 9 & 10. Departament və Vəzifə daxili sıralama
SELECT
  first_name, last_name, salary, department_id,
  DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) as rank_in_dept
FROM employees;

-- 11. Kumulyativ Maaş Cəmi (Running Total)
SELECT
  first_name, last_name, salary,
  SUM(salary) OVER (ORDER BY salary, employee_id) as cumulative_salary
FROM employees;

-- 12. Departament üzrə ortalama maaşın və ümumi sıranın bir sorğuda gətirilməsi
SELECT
  first_name, last_name, salary, department_id,
  DENSE_RANK() OVER (ORDER BY salary DESC) as overall_salary_rank,
  ROUND(AVG(salary) OVER (PARTITION BY department_id), 2) as dept_avg_salary
FROM employees;

-- 13. Departament daxili Max/Min/Sum analizi (Cəm > 100,000 olanlar)
SELECT * FROM (
  SELECT
    first_name, last_name, salary, department_id,
    MAX(salary) OVER(PARTITION BY department_id) as dept_max_salary,
    MIN(salary) OVER(PARTITION BY department_id) as dept_min_salary,
    SUM(salary) OVER(PARTITION BY department_id) as dept_total_sal
  FROM employees
) WHERE dept_total_sal >= 100000;
