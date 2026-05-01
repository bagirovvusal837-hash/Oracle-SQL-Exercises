/*
  Project: Advanced String Manipulation, RegEx & Data Pivot
  Database: Oracle HR Schema
  Author: Vüsal Bağırov
  
  Key Features & Functions Used:
  -----------------------------
  1. Regular Expressions: REGEXP_COUNT, REGEXP_LIKE, REGEXP_REPLACE, REGEXP_INSTR.
  2. String Aggregation: LISTAGG for creating comma-separated or delimited lists.
  3. PIVOT: Transforming row-level data into professional column-based reports.
  4. Data Cleaning: Advanced whitespace and character removal techniques.
  5. Hierarchical Join: Manager-Subordinate reporting using Self-Join and ListAgg.
*/

-- 1. Menecerlər və onlara bağlı əməkdaşların siyahısı (LISTAGG)
SELECT
  REPLACE(m.first_name || ' ' || m.last_name, ' ', '') as manager_name,
  COUNT(e.employee_id) as emp_count,
  LISTAGG(e.first_name, ', ') WITHIN GROUP (ORDER BY e.first_name) as subordinates
FROM employees e 
JOIN employees m ON e.manager_id = m.employee_id
GROUP BY m.first_name, m.last_name;

-- 2. Vəzifə üzrə işçi sayının PIVOT hesabatı
SELECT * FROM (
  SELECT job_id FROM employees
  WHERE job_id IN ('AC_MGR', 'FI_ACCOUNT', 'IT_PROG')
)
PIVOT (
  COUNT(job_id)
  FOR job_id IN ('AC_MGR' as manager, 'FI_ACCOUNT' as accountant, 'IT_PROG' as it_programmer)
);

-- 3. Departament üzrə maaşların "list" şəklində göstərilməsi
SELECT
  department_id,
  LISTAGG(salary, ' - ') WITHIN GROUP(ORDER BY salary) as salary_list
FROM employees
GROUP BY department_id;

-- 4 & 5. RegEx ilə Postal Code analizi (Rəqəm və Hərf sayının tapılması)
SELECT
  postal_code,
  REGEXP_COUNT(postal_code, '[0-9]') as digit_count,
  REGEXP_COUNT(postal_code, '[a-zA-Z]') as letter_count
FROM locations;

-- 6. Soyadı 'C' və ya 'D' ilə başlayanların RegEx ilə filtrlənməsi
SELECT first_name, last_name, salary
FROM employees
WHERE REGEXP_LIKE(last_name, '^[CD]', 'i') -- 'i' case-insensitive yoxlayır
  AND salary > 6000;

-- 7. WITH Clause (CTE) ilə departament ortalamasının hesablanması
WITH dept_avg AS (
  SELECT department_id, AVG(salary) as avg_dept_sal
  FROM employees
  GROUP BY department_id
)
SELECT 
  e.first_name, e.last_name, e.salary, e.department_id,
  ROUND(d.avg_dept_sal, 2) as dept_avg
FROM employees e 
JOIN dept_avg d ON e.department_id = d.department_id;

-- 8. Adreslərdən hərflərin təmizlənməsi (Data Scrubbing)
SELECT
  country_id,
  LISTAGG(street_address, ' - ') as original_addresses,
  REGEXP_REPLACE(
    LISTAGG(street_address, ' - ') WITHIN GROUP (ORDER BY street_address), 
    '[a-zA-Z]', ''
  ) as numeric_only_address
FROM locations
GROUP BY country_id;

-- 9. Telefon nömrəsindən prefiksin çıxarılması (SUBSTR vs RegEx)
SELECT
  phone_number,
  REGEXP_SUBSTR(phone_number, '^[^.]+') as first_part -- Nöqtəyə qədər olan hissə
FROM employees;

-- 10. Mətndə ikinci böyük hərfin mövqeyinin tapılması (REGEXP_INSTR)
SELECT
  street_address,
  REGEXP_INSTR(street_address, '[A-Z]', 1, 2) as second_upper_pos
FROM locations
WHERE REGEXP_INSTR(street_address, '[A-Z]', 1, 2) > 0;

-- 11. Mürəkkəb boşluqların təmizlənməsi (Text Normalization)
-- Çoxlu boşluqları tək boşluqla əvəz edir və kənarları kəsir.
SELECT
  '''' || TRIM(REGEXP_REPLACE('    Hello        World    ', '\s+', ' ')) || '''' as cleaned_text
FROM dual;
