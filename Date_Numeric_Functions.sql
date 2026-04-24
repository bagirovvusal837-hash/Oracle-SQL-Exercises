/*
  Project: SQL Data Calculation & Date Operations
  Database: Oracle HR Schema
  Author: Vüsal Bağırov
  
  Key Features & Functions Used:
  -----------------------------
  1. Arithmetic & Rounding: ROUND, TRUNC, MOD
  2. Date Manipulation: MONTHS_BETWEEN, ADD_MONTHS, NEXT_DAY, LAST_DAY
  3. String Analytics: LENGTH, CONCATENATION (||)
  4. Date Rounding: ROUND(date, 'month'/'year')
*/

-- 1. Maaşın 0.33667 misli və yuvarlaqlaşdırılması
SELECT 
    first_name, 
    salary, 
    ROUND(salary * 0.33667, 2) AS calculated_tax
FROM employees;

-- 2. Employee_id cüt olan, Job_id-də 'clerk' olan və maaşı 2000+ olanlar
SELECT * FROM employees
WHERE MOD(employee_id, 2) = 0
  AND LOWER(job_id) LIKE '%clerk%'
  AND salary > 2000;

-- 3. Ad və soyadın cəmi uzunluğu 10-dan çox olanlar
SELECT 
    first_name, 
    last_name, 
    LENGTH(first_name || last_name) AS full_name_length
FROM employees
WHERE LENGTH(first_name || last_name) > 10;

-- 4. Maaşın 500-lük əskinazlarla verilməsindən sonra qalan qalıq (MOD funksiyası)
SELECT 
    first_name, 
    salary, 
    MOD(salary, 500) AS change_amount
FROM employees;

-- 5. İş stajı 20 ili keçən əməkdaşlara 1.5 qat mükafat
SELECT 
    first_name, 
    last_name, 
    hire_date, 
    TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date) / 12) AS years_of_service,
    salary * 1.5 AS bonus_amount
FROM employees
WHERE MONTHS_BETWEEN(SYSDATE, hire_date) / 12 > 20;

-- 6. İlk maaş kartının bitmə tarixi (3 il = 36 ay sonra)
SELECT 
    first_name, 
    last_name, 
    hire_date, 
    ADD_MONTHS(hire_date, 36) AS card_expiry_date
FROM employees;

-- 7. Əməkdaşların neçə ay işlədiyini tapmaq (TRUNC ilə)
SELECT 
    first_name, 
    TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date)) AS total_months_worked
FROM employees;

-- 8. 100 günlük sınaq müddətinin bitmə tarixi
SELECT 
    first_name, 
    last_name, 
    salary, 
    hire_date, 
    hire_date + 100 AS probation_end_date
FROM employees;

-- 9. Gün, ay və il fərqlərinin hesablanması
SELECT 
    first_name, 
    last_name, 
    hire_date, 
    TRUNC(SYSDATE - hire_date) AS days_worked,
    TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date)) AS months_worked,
    TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date) / 12) AS years_worked
FROM employees;

-- 10. Gələn həftənin Bazar gününü tapmaq
-- Qeyd: NEXT_DAY(SYSDATE, 'SUNDAY') cari həftənin bazarını verə bilər, 
-- gələn həftə üçün SYSDATE + 7-dən başlamaq doğrudur.
SELECT NEXT_DAY(SYSDATE + 7, 'SUNDAY') AS next_sunday FROM DUAL;

-- 11. İşə başladıqdan sonrakı ilk Cümə günü
SELECT 
    first_name, 
    hire_date, 
    NEXT_DAY(hire_date, 'FRIDAY') AS first_friday
FROM employees;

-- 12. İşə başladığı ayın son günündən 1 gün əvvəlki tarix
SELECT 
    first_name, 
    hire_date, 
    LAST_DAY(hire_date) - 1 AS day_before_last_day
FROM employees;

-- 13. Cari tarixi aya görə yuvarlaqlaşdırmaq
SELECT 
    SYSDATE, 
    ROUND(SYSDATE, 'MONTH') AS rounded_to_month
FROM DUAL;

-- 14. İşə giriş tarixini ilə görə yuvarlaqlaşdırmaq
SELECT 
    first_name, 
    hire_date, 
    ROUND(hire_date, 'YEAR') AS rounded_to_year
FROM employees;

-- 15. Dinamik Email Yaradılması (Boşluqların təmizlənməsi və 'a' -> 'e' dəyişimi ilə)
SELECT 
    first_name, 
    last_name,
    LOWER(REPLACE(first_name, ' ', '')) || 
    LOWER(REPLACE(REPLACE(last_name, ' ', ''), 'a', 'e')) || 
    '@gmail.com' AS generated_email
FROM employees;
