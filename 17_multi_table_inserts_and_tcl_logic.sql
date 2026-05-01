/*
  Project: Advanced DML Operations & Transaction Lifecycle Management
  Database: Oracle SQL (HR Schema & Custom Tables)
  Author: Vüsal Bağırov
  
  Key Features & Concepts Covered:
  -------------------------------
  1. Transaction Isolation: Analyzing ROLLBACK behavior with multiple SAVEPOINTs.
  2. DDL vs DML Lifecycle: Understanding why TRUNCATE cannot be rolled back.
  3. Multi-Table INSERT ALL: Conditional routing of data into specialized tables (SQL vs Logistics).
  4. Conditional INSERT FIRST: Implementing hierarchical logic (Seniority-based data routing).
  5. Analytical Date Math: Calculating work experience (Staj) on the fly during insertion.
*/

-- 1-3. Transaction Control (TCL) Analizi və Məntiqi Nəticələr
-- Ssenari: SAVEPOINT və ROLLBACK-in qarşılıqlı əlaqəsi
-- Nəticə: ROLLBACK TO s1 əmri s1-dən sonra gələn bütün datanı (2,'B' və 3,'C') ləğv edir. 
-- Yalnız (1,'A') cədvəldə qalır.

-- Ssenari: TRUNCATE və ROLLBACK
-- Nəticə: TRUNCATE DDL əmri olduğu üçün avtomatik COMMIT edir. 
-- Ondan sonra gələn ROLLBACK heç bir datanı geri qaytara bilmir.

-- 4-6. Mürəkkəb Data Marşrutlaşdırılması (INSERT ALL)
-- Tələbə məlumatlarını fənlərinə görə müvafiq cədvəllərə paylayırıq.
CREATE TABLE sql_course (
    id NUMBER,
    subject VARCHAR2(100),
    teacher_id NUMBER
);

CREATE TABLE logistics_course (
    id NUMBER,
    subject VARCHAR2(100),
    teacher_id NUMBER
);

INSERT ALL 
    WHEN subject = 'SQL' THEN 
        INTO sql_course (id, subject, teacher_id) VALUES (id, subject, teacher_id)
    WHEN subject = 'Logistika' THEN 
        INTO logistics_course (id, subject, teacher_id) VALUES (id, subject, teacher_id)
SELECT id, subject, teacher_id FROM students_info;
COMMIT;

-- 7-8. İyerarxik Məlumat Daxiletmə (INSERT FIRST)
-- Əməkdaşları stajlarına görə kateqoriyalaşdırıb fərqli cədvəllərə daxil edirik.
-- Qeyd: INSERT FIRST ilk uyğun gələn şərt üzrə daxil edir və növbəti şərtləri yoxlamır.
CREATE TABLE staj_10 (
    employee_id NUMBER,
    staj NUMBER
);

CREATE TABLE staj_20 (
    employee_id NUMBER,
    staj NUMBER
);

INSERT FIRST
    WHEN (MONTHS_BETWEEN(SYSDATE, hire_date)/12) > 20 THEN 
        INTO staj_20 (employee_id, staj) 
        VALUES (employee_id, FLOOR(MONTHS_BETWEEN(SYSDATE, hire_date)/12))
    WHEN (MONTHS_BETWEEN(SYSDATE, hire_date)/12) > 10 THEN 
        INTO staj_10 (employee_id, staj) 
        VALUES (employee_id, FLOOR(MONTHS_BETWEEN(SYSDATE, hire_date)/12))
SELECT employee_id, hire_date FROM employees;
COMMIT;

-- Yoxlama sorğuları
SELECT 'SQL Courses' as Source, count(*) FROM sql_course
UNION ALL
SELECT 'Logistics Courses', count(*) FROM logistics_course;
