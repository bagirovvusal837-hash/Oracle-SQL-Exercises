/*
  Project: SQL Data Manipulation & String Functions Practice
  Database: Oracle HR Schema
  Author: Vüsal Bağırov
  
  Key Features & Functions Used:
  -----------------------------
  1. Data Filtering: WHERE, LIKE, BETWEEN, NOT BETWEEN
  2. String Functions: LOWER, UPPER, INITCAP, SUBSTR, INSTR, REPLACE, TRANSLATE
  3. Data Pagination & Selection: OFFSET, FETCH NEXT, FETCH FIRST PERCENT
  4. Logical Operations: || (Concatenation), LENGTH
  5. Interactive Queries: Bind Variables (:variable)
*/



-- 1. Departments cədvəlində tərkibində "sales" olan bütün departamentlər
SELECT department_name
FROM departments
WHERE LOWER(department_name) LIKE '%sales%';

-- 2. Maaşı 7000-15000 arasında olmayan əməkdaşlar (Bind Variable ilə)
SELECT * FROM employees
WHERE salary NOT BETWEEN :min_sal AND :max_sal;

-- 3. İlk 50% sətri gətirmək
SELECT * FROM employees
ORDER BY employee_id
FETCH FIRST 50 PERCENT ROWS ONLY;

-- 4. Sırası 20 və 40 arasında olan əməkdaşlar 
-- Qeyd: OFFSET 19 (ilk 19-u ötür), NEXT 21 (20-ci daxil olmaqla 40-a qədər)
SELECT * FROM employees
ORDER BY employee_id 
OFFSET 19 ROWS FETCH NEXT 21 ROWS ONLY;

-- 5. Ad kiçik, Soyad böyük, Job_id baş hərfi böyük
SELECT 
    LOWER(first_name) AS first_name,
    UPPER(last_name) AS last_name,
    INITCAP(job_id) AS job_id
FROM employees;

-- 6. Soyadında 'a' hərfi olanlar (İki üsul)
-- Üsul 1: INSTR funksiyası ilə
SELECT * FROM employees WHERE INSTR(LOWER(last_name), 'a') > 0;
-- Üsul 2: LIKE ilə
SELECT * FROM employees WHERE LOWER(last_name) LIKE '%a%';

-- 7. Soyaddan 2-ci hərfdən başlayaraq 5 hərf kəsmək
SELECT 
    last_name,
    SUBSTR(last_name, 2, 5) AS extracted_part
FROM employees;

-- 8. Adında sondan 2-ci hərfi 'a' olanlar (SUBSTR ilə)
-- Qeyd: SUBSTR(str, -2, 1) birbaşa sondan ikinci hərfi verir
SELECT * FROM employees
WHERE LOWER(SUBSTR(first_name, -2, 1)) = 'a';

-- 9. Adında 'w' hərfini 'ü' ilə əvəz etmək
SELECT 
    first_name,
    REPLACE(LOWER(first_name), 'w', 'ü') AS modified_name
FROM employees;

-- 10. Soyadda 'w' -> 'ş', 'g' -> 'q' əvəzləməsi və formatlama
SELECT 
    last_name,
    INITCAP(TRANSLATE(LOWER(last_name), 'wg', 'şq')) AS formatted_last_name
FROM employees;

-- 11. City sütununda 'Roma'nı 'Baku' ilə əvəz etmək (Bütün sətirlər üçün)
-- Qeyd: TRANSLATE hərfləri tək-tək dəyişir, sözü bütöv dəyişmək üçün REPLACE daha doğrudur
SELECT 
    city,
    REPLACE(city, 'Roma', 'Baku') AS updated_city
FROM locations;

-- 12. Ad və Soyaddan email hazırlama (Boşluqları silmək və 'a' -> 'e' əvəzləməsi ilə)
-- Həmçinin soyaddakı və addakı mümkün boşluqlar REPLACE(str, ' ', '') ilə təmizlənir
SELECT 
    first_name,
    last_name,
    LOWER(REPLACE(first_name, ' ', '')) || 
    LOWER(REPLACE(REPLACE(last_name, ' ', ''), 'a', 'e')) || 
    '@gmail.com' AS generated_email
FROM employees;
