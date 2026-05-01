/*
  Project: Data Normalization, Advanced Case Logic & Subquery Analytics
  Database: Oracle HR Schema
  Author: Vüsal Bağırov
  
  Key Features & Functions Used:
  -----------------------------
  1. Data Scrubbing: Using REGEXP_REPLACE and TRANSLATE for character removal.
  2. Advanced CASE Logic: Custom categorization of job roles and status flags.
  3. Window Functions: Multi-level partitioning for city-based salary analytics.
  4. Existence Logic: Utilizing EXISTS and IN clauses for relational verification.
  5. String Extraction: REGEXP_SUBSTR for precise word isolation in addresses.
*/

-- 1. Telefon nömrələrindən rəqəmlərin təmizlənməsi (Data Scrubbing)
SELECT
  phone_number,
  REGEXP_REPLACE(phone_number, '[0-9]', '') as non_numeric_chars,
  TRANSLATE(phone_number, '0123456789', ' ') as translated_format
FROM employees;

-- 2. RegEx vasitəsilə Postal Code daxilindəki hərflərin sayılması
SELECT
  postal_code,
  NVL(LENGTH(postal_code), 0) - NVL(LENGTH(REGEXP_REPLACE(postal_code, '[A-Za-z]', '')), 0) as letter_count
FROM locations;

-- 3. Adres daxilindəki 2-ci sözün kəsilib çıxarılması
SELECT
  street_address,
  REGEXP_SUBSTR(street_address, '[^ ]+', 1, 2) as second_word
FROM locations;

-- 4. Vəzifə kateqoriyalarına görə işçi sayının hesabatı (CTE & Case)
WITH categorized_jobs AS (
  SELECT
    CASE
      WHEN job_id LIKE '%CLERK%' THEN 'Katibler'
      WHEN job_id LIKE '%ACC%'   THEN 'Muhasibler'
      WHEN job_id LIKE '%PROG%'  THEN 'Proqramcilar'
      ELSE 'Digerleri'
    END as vezife
  FROM employees
)
SELECT vezife, COUNT(*) as say
FROM categorized_jobs
GROUP BY vezife
ORDER BY say DESC;

-- 5. Şəhər bazlı əməkdaş analizi (Say və Ortalama Maaş)
SELECT
  e.first_name, e.last_name, e.salary, l.city,
  COUNT(*) OVER(PARTITION BY l.city) as employees_in_city,
  ROUND(AVG(e.salary) OVER(PARTITION BY l.city), 2) as city_avg_salary
FROM employees e 
JOIN departments d ON e.department_id = d.department_id 
JOIN locations l ON d.location_id = l.location_id;

-- 6. Departamentlərin işçi mövcudluğuna görə flag-lənməsi (EXISTS vs IN)
-- Method A: Using EXISTS (Efficient for large datasets)
SELECT
  d.*,
  CASE
    WHEN EXISTS (SELECT 1 FROM employees e WHERE e.department_id = d.department_id) 
    THEN 'True' ELSE 'False'
  END as is_active
FROM departments d;

-- Method B: Using IN clause
SELECT
  d.*,
  CASE
    WHEN d.department_id IN (SELECT DISTINCT department_id FROM employees WHERE department_id IS NOT NULL)
    THEN 'True' ELSE 'False'
  END as has_employees
FROM departments d;
