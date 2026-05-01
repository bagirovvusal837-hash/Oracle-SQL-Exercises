/*
  Project: Strategic Data Merging (Upsert) & Temporal Data Recovery
  Database: Oracle SQL (HR Schema & Custom Tables)
  Author: Vüsal Bağırov
  
  Key Features & Solutions:
  -------------------------
  1. MERGE (Upsert) Logic: Synchronizing data between source and target tables with conditional logic.
  2. Temporal Querying: Using 'AS OF TIMESTAMP' to retrieve historical data states without backups.
  3. Flashback Operations: Recovering dropped tables from the RECYCLEBIN.
  4. Advanced DML within MERGE: Implementing conditional DELETE within a MERGE statement.
  5. Multi-table Synchronization: Managing salary and commission structures across independent schemas.
*/

-- 1. MERGE: Maaş və Bonus məlumatlarının sinxronizasiyası
CREATE TABLE emp_salary_info AS 
SELECT employee_id, salary, commission_pct AS bonus FROM employees;

MERGE INTO emp_salary_info target 
USING (SELECT employee_id, salary, commission_pct FROM employees) source
ON (target.employee_id = source.employee_id)
WHEN NOT MATCHED THEN
    INSERT (employee_id, salary, bonus)
    VALUES (source.employee_id, source.salary, source.commission_pct);

-- 2. MERGE: NULL dəyərlərin 0-lanması və yeni dataların daxil edilməsi
CREATE TABLE emp_commission AS
SELECT employee_id, commission_pct FROM employees WHERE commission_pct IS NULL;

MERGE INTO emp_commission e
USING employees em
ON (e.employee_id = em.employee_id)
WHEN MATCHED THEN
    UPDATE SET e.commission_pct = 0
WHEN NOT MATCHED THEN
    INSERT (employee_id, commission_pct) VALUES (em.employee_id, em.commission_pct);

-- 3. Kompleks MERGE: Yeniləmə, Daxiletmə və Silmə (Condition-based)
-- Qeyd: MERGE daxilində DELETE yalnız MATCHED hissəsində işləyir.
MERGE INTO emp_high_sal ehs
USING emp_dummy ed
ON (ehs.employee_id = ed.employee_id)
WHEN MATCHED THEN
    UPDATE SET ehs.salary = ed.salary
    DELETE WHERE (ehs.salary < 6000) -- Yenilənmədən sonra şərtə uymayanları silir
WHEN NOT MATCHED THEN
    INSERT (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
    VALUES (ed.employee_id, ed.first_name, ed.last_name, ed.email, ed.phone_number, ed.hire_date, ed.job_id, ed.salary, ed.commission_pct, ed.manager_id, ed.department_id);

-- 4. Flashback Query: Keçmiş zaman diliminə səyahət
-- Ssenari: Səhvən edilən maaş dəyişikliyini 10 dəqiqə əvvəlki halına qaytarmaq
UPDATE employment e
SET salary = (
  SELECT salary
  FROM employment AS OF TIMESTAMP (SYSTIMESTAMP - INTERVAL '10' MINUTE) old
  WHERE e.employee_id = old.employee_id
)
WHERE employee_id = 120;
COMMIT;

-- Alternativ olaraq bütün cədvəli geri çəkmək:
-- FLASHBACK TABLE employment TO TIMESTAMP (SYSTIMESTAMP - INTERVAL '10' MINUTE);

-- 5. Recyclebin & Flashback Drop
DROP TABLE students;
-- Cədvəli zibil qutusundan (Recyclebin) geri qaytarmaq
FLASHBACK TABLE students TO BEFORE DROP;
