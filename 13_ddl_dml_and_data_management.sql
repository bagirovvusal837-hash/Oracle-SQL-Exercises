/*
  Project: Database Objects Creation & Data Manipulation (DDL/DML)
  Database: Oracle SQL (Custom Schema & HR)
  Author: Vüsal Bağırov
  
  Key Features & Functions Used:
  -----------------------------
  1. DDL (Data Definition Language): CREATE TABLE, ALTER TABLE, RENAME, MODIFY.
  2. DML (Data Manipulation Language): INSERT, UPDATE, DELETE, COMMIT.
  3. Constraints: PRIMARY KEY, FOREIGN KEY, NOT NULL, CHECK, DEFAULT.
  4. Advanced Analytics: Combining Window Functions with DDL/DML logic.
  5. RegEx Refinement: Advanced character filtering in aggregated strings.
*/

-- 1 & 2. Müəllimlər cədvəlinin (TEACHERS) yaradılması və məlumatın daxil edilməsi
CREATE TABLE teachers (
    id NUMBER PRIMARY KEY,
    first_name VARCHAR2(30) NOT NULL,
    last_name VARCHAR2(30),
    subject VARCHAR2(100)
);

INSERT INTO teachers (id, first_name, last_name, subject) VALUES (201, 'Anar', 'Qasimov', 'SQL');
INSERT INTO teachers (id, first_name, last_name, subject) VALUES (202, 'Leyla', 'Eliyeva', 'EXCEL');
INSERT INTO teachers (id, first_name, last_name, subject) VALUES (203, 'Reshad', 'Hesenov', 'POWER BI');
INSERT INTO teachers (id, first_name, last_name, subject) VALUES (204, 'Gunel', 'Memmedova', 'STATISTIKA');
COMMIT;

-- 3 & 4. Əlavə məlumat cədvəlinin yaradılması və Foreign Key əlaqəsi
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
INSERT INTO teachers_add_info (id, full_name, salary, address) VALUES (203, 'Reshad Hesenov', 1000, 'Gence');
INSERT INTO teachers_add_info (id, full_name, salary, address) VALUES (204, 'Gunel Memmedova', 1000, 'Baki');
COMMIT;

-- 5. Cədvəllərin JOIN edilərək birləşdirilmiş hesabatı
SELECT
    t.subject, t.id, a.full_name, a.salary,
    a.start_date, a.end_date, a.address
FROM teachers t 
JOIN teachers_add_info a ON t.id = a.id;

-- 6, 7 & 8. Məlumatların yenilənməsi (UPDATE) və Cədvəl strukturunun dəyişdirilməsi (ALTER)
UPDATE teachers_add_info SET salary = 1200 WHERE id = 202;
UPDATE teachers_add_info SET salary = 1300 WHERE id = 203;

ALTER TABLE teachers_add_info MODIFY address VARCHAR2(200);
COMMIT;

-- 9 & 10. Cədvəl təsviri və CHECK Constraint əlavə edilməsi (Maaşın mənfi olmaması üçün)
DESC teachers_add_info;

ALTER TABLE teachers_add_info 
ADD CONSTRAINT check_sal_positive CHECK (salary >= 0);

-- 11 & 12. Cədvəlin adının dəyişdirilməsi (RENAME)
ALTER TABLE teachers_add_info RENAME TO teachers_info;
ALTER TABLE teachers_info RENAME TO teachers_add_info;

-- 13. Spesifik sətrin silinməsi (DELETE)
DELETE FROM teachers_add_info WHERE id = 202;
COMMIT;

-- 14. Analitik hesabat: Maaş fərqi və departament ortalaması
SELECT
    first_name, last_name, salary, department_id,
    DENSE_RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) as salary_rank,
    ROUND(AVG(salary) OVER(PARTITION BY department_id), 2) as dept_avg_sal,
    salary - ROUND(AVG(salary) OVER(PARTITION BY department_id), 2) as sal_diff
FROM employees;

-- 15. RegEx: Adreslərdən rəqəm və simvolların tam təmizlənməsi
SELECT
    country_id,
    LISTAGG(street_address, '-') WITHIN GROUP (ORDER BY street_address) as combined_address,
    REGEXP_REPLACE(
        LISTAGG(street_address, '-') WITHIN GROUP (ORDER BY street_address),
        '[^a-zA-Z]', ''
    ) as only_letters_address
FROM locations
GROUP BY country_id;
