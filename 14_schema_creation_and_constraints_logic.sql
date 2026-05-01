/*
  Project: Advanced Table Schema, Constraints & Logic Validation
  Database: Oracle SQL (Custom Schema & HR)
  Author: Vüsal Bağırov
  
  Key Features & Concepts Covered:
  -------------------------------
  1. DDL Operations: CREATE TABLE, CTAS (Create Table As Select).
  2. Data Integrity: Primary Key, Foreign Key, NOT NULL, and UNIQUE constraints.
  3. DML Execution: Precise INSERT operations with COMMIT management.
  4. Logical Validation: Analyzing INSERT failures based on column constraints.
  5. Relational Reporting: Joining custom-built tables for comprehensive views.
*/

-- 1 & 2. Müəllimlər (TEACHERS) cədvəlinin və ilkin datanın yaradılması
CREATE TABLE teachers (
    id NUMBER PRIMARY KEY,
    first_name VARCHAR2(30) NOT NULL,
    last_name VARCHAR2(30),
    subject VARCHAR2(40)
);

INSERT INTO teachers (id, first_name, last_name, subject) VALUES (201, 'Anar', 'Qasimov', 'SQL');
INSERT INTO teachers (id, first_name, last_name, subject) VALUES (202, 'Leyla', 'Eliyeva', 'Excel');
INSERT INTO teachers (id, first_name, last_name, subject) VALUES (203, 'Vuqar', 'Hesenov', 'Power BI');
INSERT INTO teachers (id, first_name, last_name, subject) VALUES (204, 'Gunel', 'Memmedova', 'Statistika');
COMMIT;

-- 3 & 4. Relyasiyalı cədvəlin (TEACHERS_ADD_INFO) yaradılması və Default dəyərlər
CREATE TABLE teachers_add_info (
    id NUMBER PRIMARY KEY,
    full_name VARCHAR2(70) NOT NULL,
    salary NUMBER(8,2),
    start_date DATE DEFAULT SYSDATE,
    end_date DATE,
    address VARCHAR2(100),
    CONSTRAINT fk_teacher_id FOREIGN KEY (id) REFERENCES teachers(id)
);

INSERT INTO teachers_add_info (id, full_name, salary, address) VALUES (201, 'Anar Qasimov', 1000, 'Baki');
INSERT INTO teachers_add_info (id, full_name, salary, address) VALUES (202, 'Leyla Eliyeva', 1000, 'Sumqayit');
INSERT INTO teachers_add_info (id, full_name, salary, address) VALUES (203, 'Vuqar Hesenov', 1000, 'Gence');
INSERT INTO teachers_add_info (id, first_name, last_name, subject) VALUES (204, 'Gunel Memmedova', 1000, 'Baki');
COMMIT;

-- 5. Cədvəllərin JOIN vasitəsilə birləşdirilməsi
SELECT
    t.subject, t.id, a.salary, a.start_date, a.end_date, a.address
FROM teachers t 
JOIN teachers_add_info a ON t.id = a.id;

-- 6. CTAS: Mövcud data əsasında yeni cədvəlin sürətli yaradılması
CREATE TABLE it_prog_emp AS
SELECT * FROM employees
WHERE job_id = 'IT_PROG';

-- 7. Məntiqi Analiz: NOT NULL Məhdudiyyəti
-- Sual: First_name sütunu NOT NULL olduğu halda ora dəyər göndərilməsə nə olar?
-- Cavab: Sistem xəta verəcək, çünki icbari sütun boş qala bilməz.

-- 8. Məntiqi Analiz: Primary Key və NULL
-- Sual: Primary Key olan sütuna NULL daxil etmək olarmı?
-- Cavab: Xeyr, Primary Key həm UNIQUE olmalı, həm də NULL dəyər almamalıdır.

-- 9. Məntiqi Analiz: UNIQUE Məhdudiyyəti və NULL
-- Sual: Unique sütuna birdən çox NULL daxil etmək olarmı?
-- Cavab: Bəli, olar. Oracle-da NULL dəyərlər bir-birinə bərabər sayılmadığı üçün UNIQUE məhdudiyyəti NULL-lara şamil edilmir.
