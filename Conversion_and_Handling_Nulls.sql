/*
  Project: SQL Data Conversion & Handling Nulls
  Database: Oracle HR Schema
  Author: Vüsal Bağırov
  
  Key Features & Functions Used:
  -----------------------------
  1. Conversion Functions: TO_CHAR (Date & Currency formatting)
  2. Handling Nulls: NVL, NVL2, NULLIF
  3. String & Logical Operations: REPLACE, MOD, UPPER, FETCH FIRST
  4. Financial Calculations: Tax and Net Salary computation
*/

-- 1. İşə giriş tarixlərinin formatlanması (Gün, Ay, İl, Rüb)
SELECT 
    first_name, 
    hire_date,
    TO_CHAR(hire_date, 'DD') AS hire_day,
    TO_CHAR(hire_date, 'MM') AS hire_month,
    TO_CHAR(hire_date, 'YYYY') AS hire_year,
    TO_CHAR(hire_date, 'Q') AS hire_quarter
FROM employees;

-- 2. Ayın 7-də işə girən əməkdaşlar
SELECT first_name, last_name, salary, hire_date, department_id
FROM employees
WHERE TO_CHAR(hire_date, 'DD') = '07';

-- 3. Küçə ünvanındakı boşluqların silinməsi (İlk 10 sətir)
SELECT 
    location_id, 
    REPLACE(street_address, ' ', '') AS compressed_address,
    city, 
    country_id
FROM locations
FETCH FIRST 10 ROWS ONLY;

-- 4. Şəhər və Ölkə ID-sinin kombinasiyası
SELECT city || ' - ' || country_id AS city_country_comb
FROM locations;

-- 5. Maaşın valyuta formatında göstərilməsi ($ işarəsi ilə)
SELECT 
    first_name, 
    TO_CHAR(salary, '$99,999') AS formatted_salary
FROM employees;

-- 6. Manager vəzifəsində olub, maaş limitlərinə uyğun gələn işlər
SELECT * FROM jobs
WHERE LOWER(job_title) LIKE '%manager%'
  AND min_salary > 6000
  AND max_salary <= 16000;

-- 7. Manager_id NULL olanlara 0 yazılması və filtrasiya
-- Qeyd: Tapşırıqda 0 olanlar gəlməsin deyildiyi üçün NVL istifadə edib sonra süzürük
SELECT 
    UPPER(department_name) AS dept_name,
    NVL(manager_id, 0) AS manager_id
FROM departments
WHERE NVL(manager_id, 0) <> 0;

-- 8. Şəhər və Vilayət adları eyni olmayan sətirlər (NULLIF istifadəsi)
-- NULLIF iki dəyər eynidirsə NULL qaytarır, fərqlidirsə birincini qaytarır.
SELECT city, state_province
FROM locations
WHERE NULLIF(city, state_province) IS NOT NULL;

-- 9. State_province sütununda NULL dəyərlərin əvəzlənməsi
SELECT 
    city, 
    NVL(state_province, 'Yoxdur') AS province_status
FROM locations;

-- 10. Komissiya daxil olmaqla ümumi maaşın hesablanması
SELECT 
    first_name, 
    last_name, 
    salary,
    NVL(commission_pct, 0) AS comm_rate,
    salary * NVL(commission_pct, 0) AS commission_amount,
    salary + (salary * NVL(commission_pct, 0)) AS total_compensation
FROM employees;

-- 11. Adının uzunluğu tək olan əməkdaşlar
SELECT first_name, LENGTH(first_name) AS name_len, salary
FROM employees
WHERE MOD(LENGTH(first_name), 2) <> 0;

-- 12. Manager ID-lərin 1 vahid artırılması (NULL = 0 məntiqi ilə)
-- Əgər NULL-dursa 0 olsun, deyilsə üzərinə 1 gəlsin.
SELECT 
    manager_id AS original_id,
    NVL(manager_id, -1) + 1 AS updated_manager_id
FROM departments;

-- 13. Net maaşın hesablanması (Gəlir vergisi 14%, DSMF 3%)
SELECT 
    first_name, 
    last_name, 
    salary,
    salary * 0.14 AS income_tax,
    salary * 0.03 AS dsmf,
    salary - (salary * 0.17) AS net_salary
FROM employees;
