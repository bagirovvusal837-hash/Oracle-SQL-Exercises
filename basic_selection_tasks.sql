/* PROJECT: Oracle SQL Basic Exercises
   AUTHOR: Bagirov Vusal
   DESCRIPTION: Practice queries on HR schema covering SELECT, WHERE, Aliases, and Concatenation.
*/

-- 1. Employees cədvəlində Department_id-i 80 olan əməkdaşların soyadını, adını, department_id-i və maaşını gətirən sorğu.
SELECT 
    last_name, 
    first_name, 
    department_id, 
    salary
FROM hr.employees
WHERE department_id = 80;

-- 2. Departments cədvəlində Location_id-i 1700 olan bütün dataları gətirin.
SELECT * FROM hr.departments
WHERE location_id = 1700;

-- 3. Employees cədvəlində commission_pct-i NULL olmayan bütün dataları gətirin.
SELECT * FROM hr.employees
WHERE commission_pct IS NOT NULL;

-- 4. Əməkdaşların adını, soyadını, maaşını və üzərinə 1000 əlavə olunmuş yeni maaşını gətirin. 
-- Yalnız yeni maaşı 15000-dən yüksək olanlar gəlsin.
SELECT 
    first_name,
    last_name,
    salary,
    (salary + 1000) AS "Yeni maaş"
FROM hr.employees
WHERE (salary + 1000) > 15000;

-- 5. Əməkdaşların adını, soyadını, maaşını və maaşına 20% əlavə olunmuş sütunu gətirən sorğu.
SELECT 
    first_name,
    last_name,
    salary,
    salary * 1.2 AS "maas artimi"
FROM hr.employees;

-- 6. "First_name 's last name is Last_name" formatında bütün sətrləri yazdırın.
-- Nümunə: Ellen 's last name is Abel
SELECT 
   first_name || q'['s last name is ]' || last_name AS full_info
FROM hr.employees;

-- 7. Employees cədvəlində department_id və salary-i unikal (təkrarlanmayan) olaraq gətirin.
SELECT DISTINCT 
    department_id, 
    salary
FROM hr.employees;

-- 8. Departments cədvəlində Location_id-i unikal olaraq gətirin.
SELECT DISTINCT 
    location_id
FROM hr.departments;

-- 9. Regions cədvəlinin strukturunu və bütün məlumatlarını gətirin.
DESC hr.regions;
SELECT * FROM hr.regions;

-- 10. Employees cədvəlində manager_id-i 103 olan əməkdaşları gətirin.
SELECT * FROM hr.employees
WHERE manager_id = 103;

-- 11. Maaşı 12000 və daha çox olan əməkdaşların ad və soyadını bitişik (boşluqla) gətirin.
SELECT  
   first_name || ' ' || last_name AS "Full Name",
   salary
FROM hr.employees
WHERE salary >= 12000;
