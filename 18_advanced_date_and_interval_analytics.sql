/*
  Project: Advanced Temporal Analytics & Interval Arithmetic
  Database: Oracle SQL (HR Schema)
  Author: Vüsal Bağırov
  
  Key Features & Concepts Covered:
  -------------------------------
  1. Component Extraction: Isolation of Year, Month, and Day using EXTRACT().
  2. Temporal Filtering: Analyzing hiring trends (2003 & 2006) using dual methods.
  3. Time Zone Awareness: Differentiating between DB, Session, and Local time zones.
  4. Interval Arithmetic: Precise date/time offset operations using INTERVAL literals.
  5. System Metadata: Querying various system-level timestamp and date functions.
*/

-- 1. İşə giriş tarixlərinin komponentlərə (il, ay, gün) parçalanması
SELECT
    first_name,
    hire_date,
    EXTRACT(YEAR FROM hire_date) AS hire_year,
    EXTRACT(MONTH FROM hire_date) AS hire_month,
    EXTRACT(DAY FROM hire_date) AS hire_day
FROM employees;

-- 2. 2003-cü il üzrə kadr hesabatı (Join & Multi-method Filtering)
-- Metod A: EXTRACT funksiyası ilə
SELECT e.*, d.department_name
FROM employees e 
JOIN departments d ON e.department_id = d.department_id
WHERE EXTRACT(YEAR FROM e.hire_date) = 2003;

-- Metod B: Range-based (BETWEEN) filtrasiyası ilə
SELECT e.*, d.department_name
FROM employees e 
JOIN departments d ON e.department_id = d.department_id
WHERE e.hire_date BETWEEN TO_DATE('2003-01-01','YYYY-MM-DD') 
                      AND TO_DATE('2003-12-31','YYYY-MM-DD');

-- 3. 2006-cı il üzrə departament bazlı işə qəbul statistikası
SELECT d.department_name, COUNT(e.employee_id) AS emp_count
FROM employees e 
JOIN departments d ON e.department_id = d.department_id
WHERE EXTRACT(YEAR FROM e.hire_date) = 2006
GROUP BY d.department_name;

-- 4 & 5. Sistem və Sessiya Zaman Metadata Analizi
SELECT
    DBTIMEZONE AS database_tz,
    SESSIONTIMEZONE AS session_tz,
    SYSDATE,
    SYSTIMESTAMP,
    CURRENT_DATE,
    CURRENT_TIMESTAMP,
    LOCALTIMESTAMP
FROM DUAL;

-- 6-9. Tarix və Zaman Aralıqları (Interval Arithmetic)
SELECT
    SYSTIMESTAMP AS current_ts,
    -- 4 il 5 ay əlavə etmək
    SYSDATE + INTERVAL '4-5' YEAR TO MONTH AS future_date_4y_5m,
    -- 1 gün 5 saat əlavə etmək
    SYSTIMESTAMP + INTERVAL '1 05' DAY TO HOUR AS future_ts_1d_5h,
    -- 2 il 3 ay geriyə getmək
    SYSDATE - INTERVAL '2-3' YEAR TO MONTH AS past_date_2y_3m,
    -- 2 saat əlavə etmək
    SYSTIMESTAMP + INTERVAL '2' HOUR AS next_2_hours
FROM DUAL;
