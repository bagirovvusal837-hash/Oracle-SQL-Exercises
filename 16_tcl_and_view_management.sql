/*
  Project: Transaction Control (TCL), History Tracking & View Architecture
  Database: Oracle SQL (Custom Schema & HR)
  Author: Vüsal Bağırov
  
  Key Features & Concepts:
  -----------------------
  1. DDL Refactoring: Column removal and historical tracking table design.
  2. TCL Mastery: Strategic use of COMMIT, ROLLBACK, and SAVEPOINT for data safety.
  3. Transactional Integrity: Simulating multi-step data entry with rollback scenarios.
  4. Abstraction Layer: Creating VIEWs for complex, repetitive reporting.
  5. Backup Strategies: Utilizing CTAS (Create Table As Select) for data snapshots.
*/

-- 1 & 2. Struktur dəyişikliyi və Müəllimlərin Tarixçə cədvəlinin yaradılması
ALTER TABLE teachers_add_info DROP COLUMN end_date;

CREATE TABLE teachers_history (
    id NUMBER PRIMARY KEY,
    first_name VARCHAR2(30),
    last_name VARCHAR2(30),
    subject VARCHAR2(100),
    start_date DATE,
    end_date DATE,
    reason VARCHAR2(250)
);

-- 3. Tarixçə məlumatlarının daxil edilməsi
INSERT INTO teachers_history(id, first_name, last_name, start_date, end_date, reason)
VALUES(202, 'Leyla', 'Eliyeva', DATE '2026-03-19', DATE '2026-03-26', 'Muqavile bitdi');

INSERT INTO teachers_history(id, first_name, last_name, start_date, end_date, reason)
VALUES(203, 'Reshad', 'Hesenov', DATE '2026-02-23', DATE '2026-03-25', 'Oz isteyi ile');
COMMIT;

-- 4. TCL (Transaction Control) Simulyasiyası: Təhlükəsiz Data Girişi
-- Students cədvəlinə məlumat daxil edilməsi və Savepoint tətbiqi
INSERT INTO students(id, first_name, last_name, email, start_date)
VALUES(11, 'Samir', 'Ismayilov', 'samir.i@gmail.com', DATE '2017-09-07');

SAVEPOINT sp_students_batch1;

INSERT INTO students(id, first_name, last_name, email, start_date)
VALUES(16, 'Nigar', 'Quliyeva', 'nigar.q@yahoo.com', DATE '2019-12-14');

-- Səhv və ya sınaq məlumatını geri qaytarmaq
ROLLBACK TO SAVEPOINT sp_students_batch1;
COMMIT; -- Qalan datanı yadda saxla

-- 5 & 6. Məlumatın Silinməsi və Yenilənməsində TCL-in rolu
DELETE FROM students WHERE id = 20;
SAVEPOINT sp_after_delete;

-- Ehtiyatsızlıqdan bütün cədvəli silmək riski
DELETE FROM students;

-- Səhvi düzəltmək üçün geri qayıtmaq
ROLLBACK TO SAVEPOINT sp_after_delete;
COMMIT;

-- 7. View Yaradılması: Seattle-da yüksək maaşlı əməkdaşlar üçün virtual qat
CREATE OR REPLACE VIEW v_seattle_high_paid AS 
SELECT
    e.first_name, e.last_name, e.salary,
    l.city, c.country_name
FROM employees e 
JOIN departments d ON e.department_id = d.department_id 
JOIN locations l ON d.location_id = l.location_id 
JOIN countries c ON l.country_id = c.country_id
WHERE l.city = 'Seattle' AND e.salary > 5000;

-- Sorğunu sadələşdirmək üçün View-dan istifadə
SELECT * FROM v_seattle_high_paid;

-- Backup məqsədilə fiziki cədvəl yaradılması (CTAS)
CREATE TABLE seattle_emp_backup AS SELECT * FROM v_seattle_high_paid;
