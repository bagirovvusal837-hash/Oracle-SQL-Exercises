/*
  Project: Database Object Abstraction & Organizational Hierarchy Mapping
  Database: Oracle SQL (HR Schema)
  Author: Vüsal Bağırov
  
  Key Features & Solutions:
  -------------------------
  1. Object Abstraction: Creating and managing Private and Public Synonyms for schema security.
  2. Recursive Logic: Implementing Hierarchical Queries to map parent-child relationships.
  3. Visual Tree Structuring: Using LPAD and LEVEL to create human-readable organizational charts.
  4. Path Tracing: Utilizing SYS_CONNECT_BY_PATH to track reporting chains from CEO to staff.
  5. Level Control: Filtering depth-specific data (e.g., up to 3rd level management).
*/

-- 1-3. Sinonimlərin yaradılması (Data Abstraction)
-- Şəxsi sinonim: hr.employees cədvəlinə qısa yol
CREATE OR REPLACE SYNONYM emp FOR hr.employees;

-- Public sinonim: Bütün istifadəçilər üçün əlçatan (Admin yetkisi tələb edir)
CREATE OR REPLACE PUBLIC SYNONYM emp FOR hr.employees;

-- Locations cədvəli üçün sinonim
CREATE OR REPLACE SYNONYM loc FOR hr.locations;

-- 4-5. Sinonimlərin Auditi
-- İstifadəçiyə aid olan sinonimlər
SELECT synonym_name, table_owner, table_name FROM user_synonyms;

-- Sistemdəki bütün sinonimlər
SELECT * FROM all_synonyms;

-- 6-8. Sinonimlərin silinməsi
DROP SYNONYM emp;
DROP SYNONYM loc;
DROP PUBLIC SYNONYM emp;

-- 9-10. İyerarxik Sorğular: Təşkilati Strukturun vizuallaşdırılması
-- LPAD vasitəsilə ağac strukturunun (Tree view) qurulması
[attachment_0](attachment)
SELECT 
    LEVEL,
    LPAD(' ', (LEVEL-1)*3) || first_name AS worker_tree,
    manager_id,
    SYS_CONNECT_BY_PATH(first_name, ' -> ') AS reporting_chain
FROM hr.employees
START WITH manager_id IS NULL -- CEO-dan başlayaraq
CONNECT BY PRIOR employee_id = manager_id; -- Ata-bala (Müdir-İşçi) əlaqəsi

-- 11. Dərinlik üzrə filtrasiya (Yalnız ilk 3 səviyyə)
SELECT
    LEVEL,
    LPAD(' ', (LEVEL-1)*3) || first_name AS isci_tree,
    manager_id
FROM hr.employees
WHERE LEVEL <= 3
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id;
