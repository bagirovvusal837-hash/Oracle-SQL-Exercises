/*
  Project: SQL Conditional Logic and Data Analysis
  Database: Oracle HR Schema
  Author: Vüsal Bağırov
  
  Key Features & Functions Used:
  -----------------------------
  1. Conditional Logic: CASE WHEN, DECODE
  2. Advanced Filtering: IN, BETWEEN, IS NOT NULL
  3. Formatting & Padding: RPAD, SUBSTR
  4. Pagination: OFFSET, FETCH NEXT
  5. Date Logic: MONTHS_BETWEEN, TO_DATE
*/

-- 1. ST_MAN və ya ST_CLERK olub maaşı 6000-dən çox olanlar
SELECT first_name, last_name, salary, job_id
FROM employees
WHERE job_id IN ('ST_MAN', 'ST_CLERK')
  AND salary > 6000;

-- 2. Commission_pct NULL olmayanlar (İlk 10 nəfərdən sonrakılar)
-- OFFSET 10 yazmaqla ilk 10 sətri ötürüb qalanlarını gətiririk.
SELECT * FROM employees
WHERE commission_pct IS NOT NULL
ORDER BY employee_id
OFFSET 10 ROWS;

-- 3. Sonu 'a' ilə bitən ölkə adları (Alternativ yollarla)
-- Üsul 1: LIKE
SELECT country_name FROM countries WHERE country_name LIKE '%a';
-- Üsul 2: SUBSTR
SELECT country_name FROM countries WHERE SUBSTR(country_name, -1) = 'a';

-- 4. Postal_code-u sağ tərəfdən 0-larla 20 simvola tamamlamaq
SELECT 
    postal_code, 
    RPAD(postal_code, 20, '0') AS padded_postal_code
FROM locations;

-- 5. İki tarix arasındakı ay fərqi
SELECT 
    MONTHS_BETWEEN(TO_DATE('01.08.2000','DD.MM.YYYY'), 
                   TO_DATE('01.01.1999','DD.MM.YYYY')) AS month_diff
FROM DUAL;

-- 6. Region ID-lərin adlandırılması (DECODE ilə)
SELECT 
    country_name, 
    region_id,
    DECODE(region_id,
           10, 'Europe',
           20, 'Americas',
           30, 'Asia',
           40, 'Middle East and Africa', 'Unknown') AS region_name
FROM countries;

-- 7. Departamentə görə maaş artımı (DECODE ilə)
SELECT 
    first_name, last_name, department_id, salary,
    DECODE(department_id, 
           40, salary * 1.30, 
           60, salary * 1.40, 
           salary * 1.20) AS increased_salary
FROM employees;

-- 8. Manager_id-yə görə bonusun hesablanması (DECODE ilə)
SELECT 
    first_name, last_name, manager_id, salary,
    salary + DECODE(manager_id, 145, 500, 146, 400, 148, 600, 300) AS total_with_bonus
FROM employees;

-- 9. Maaş səviyyələrinin təyini (CASE WHEN)
SELECT 
    first_name, last_name, salary,
    CASE 
        WHEN salary < 10000 THEN 'Az'
        WHEN salary BETWEEN 10000 AND 20000 THEN 'Orta'
        ELSE 'Yuksek'
    END AS salary_level
FROM employees;

-- 10. Vəzifə artımı statusu (Job Title-a görə)
SELECT 
    job_title,
    CASE 
        WHEN LOWER(job_title) LIKE '%clerk%' THEN 'Vezife artimi planlanilir'
        WHEN LOWER(job_title) LIKE '%manager%' THEN 'Vezife artimi mumkundur'
        WHEN LOWER(job_title) LIKE '%representative%' THEN 'Vezife artirildi'
        ELSE 'Baxilmayib'
    END AS promotion_status
FROM jobs;

-- 11. Manager ID-yə görə konkret artımların tətbiqi (CASE ilə birbaşa hesablama)
-- Burada "Digərləri" üçün maaş dəyişməz qalır (ELSE salary)
SELECT 
    first_name, last_name, manager_id, salary,
    CASE 
        WHEN manager_id IN (100, 102) THEN salary + 500
        WHEN manager_id IN (103, 104) THEN salary + 550
        WHEN manager_id IN (108, 110) THEN salary + 600
        ELSE salary 
    END AS new_salary,
    CASE 
        WHEN manager_id IN (100, 102, 103, 104, 108, 110) THEN 'Artim edildi'
        ELSE 'Baxilacaq'
    END AS note
FROM employees;

-- 12. Departament adlarına görə masa bölgüsü
SELECT 
    department_name,
    CASE 
        WHEN LOWER(department_name) LIKE '%marketing%' THEN '1-ci ve 2-ci masa'
        WHEN LOWER(department_name) LIKE '%shipping%' THEN '3-cu masa'
        WHEN LOWER(department_name) LIKE '%sales%' THEN '4-cu ve 5-ci masa'
        ELSE 'Diger zal'
    END AS table_assignment
FROM departments;
