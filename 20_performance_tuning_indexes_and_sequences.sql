/*
  Project: Database Performance Tuning & Sequence Automation
  Database: Oracle SQL (HR Schema)
  Author: Vüsal Bağırov
  
  Key Features & Solutions:
  -------------------------
  1. Performance Analysis: Utilizing EXPLAIN PLAN to analyze query execution costs.
  2. Indexing Strategies: Implementing Bitmap Indexes for low-cardinality data (gender) 
     and Function-Based Indexes (UPPER) for optimized searches.
  3. Data Dictionary Mastery: Querying USER_INDEXES and USER_IND_COLUMNS for schema auditing.
  4. Sequence Automation: Designing complex sequences with CYCLE, MIN/MAX, and custom increments.
  5. Practical Implementation: Automating ID generation for students' data entry.
*/

-- 1. Optimallaşdırılmış Axtarış: 2005-ci il üzrə kadr hesabatı
SELECT e.*, l.city, c.country_name
FROM employees e 
JOIN departments d ON e.department_id = d.department_id 
JOIN locations l ON d.location_id = l.location_id 
JOIN countries c ON l.country_id = c.country_id
WHERE e.hire_date BETWEEN TO_DATE('2005-01-01','YYYY-MM-DD') 
                      AND TO_DATE('2005-12-31','YYYY-MM-DD');

-- 2. Bitmap Index: Az sayda unikal dəyəri olan sütunlar üçün optimallaşdırma
ALTER TABLE students_info ADD gender VARCHAR2(15);
CREATE BITMAP INDEX idx_students_gender ON students_info(gender);

-- 3. İndekslərin Auditi və Performans Analizi
-- Mövcud indekslərin siyahısı və statusu
SELECT index_name, uniqueness, status FROM user_indexes WHERE table_name = 'EMPLOYEES';

-- Sorğu planının (Execution Plan) çıxarılması
EXPLAIN PLAN FOR SELECT * FROM employees WHERE employee_id = 138;
SELECT * FROM TABLE(dbms_xplan.display);

-- 7. Function-Based Index: Böyük/Kiçik hərfə həssas axtarışların sürətləndirilməsi
CREATE INDEX idx_upper_last_name ON employees (UPPER(last_name));

-- 8-10. Sequences: ID-lərin avtomatik və nizamlı yaradılması
CREATE SEQUENCE sq_hr START WITH 100 INCREMENT BY 1;

-- Azalan ardıcıllıq və limitlərin təyini
CREATE SEQUENCE sq_test_cycle
    START WITH 1000 
    INCREMENT BY -10 
    MAXVALUE 1000 
    MINVALUE 0 
    CYCLE;

-- 11. Sequence-in praktiki tətbiqi (Data Entry)
INSERT INTO students(id, first_name, last_name, email, start_date)
VALUES(sq_hr.NEXTVAL, 'Elvin', 'Hesenov', 'elvin.h@mail.com', DATE '2021-04-10');
COMMIT;

-- 13. Sequence haqqında vacib qeydlər (Tezislər):
-- A) Sequence-lər tranzaksiyalardan (Rollback) asılı deyil.
-- C) Unikal dəyərlər yaradır.
-- D) Bir neçə istifadəçi eyni ardıcıllığı eyni anda istifadə edə bilər.
