/*
  Project: Advanced Schema Design & Character-Set Aware Constraints
  Database: Oracle SQL (Custom Schema: Students & Logistics)
  Author: Vüsal Bağırov
  
  Key Features & Solutions:
  -------------------------
  1. Localization-Aware Constraints: Using [:upper:] instead of [A-Z] for multi-language support.
  2. Multi-Level Data Integrity: Implementing Primary Key, Foreign Key, Unique, and Check constraints.
  3. Relational Mapping: Handling One-to-Many relationships (one student taking multiple subjects).
  4. Database Normalization: Decoupling address data into a standalone normalized table.
  5. Data Scrubbing & Updates: Bulk updates for score normalization across specific subjects.
*/

-- 1-6. Tələbələr cədvəli və Dilə-həssas (Localization) məhdudiyyətlər
CREATE TABLE students (
    id NUMBER PRIMARY KEY,
    first_name VARCHAR2(20) NOT NULL,
    last_name VARCHAR2(25),
    email VARCHAR2(100),
    start_date DATE,
    address VARCHAR2(100)
);

-- Email tamlığı və formatı üçün məhdudiyyətlər
ALTER TABLE students ADD CONSTRAINT email_unq UNIQUE(email);
ALTER TABLE students ADD CONSTRAINT email_chk CHECK(email LIKE '%@%');

-- Adın ilk hərfinin böyüklə başlaması (Azərbaycan şriftlərini dəstəkləyən [:upper:] class-ı ilə)
ALTER TABLE students ADD CONSTRAINT fname_upper_chk CHECK(REGEXP_LIKE(first_name, '^[[:upper:]]'));

-- 8-10. Tələbə Məlumat Analitikası (Students_Info) və Balların idarə edilməsi
CREATE TABLE students_info (
    id NUMBER NOT NULL,
    full_name VARCHAR2(70),
    subject VARCHAR2(40) NOT NULL,
    teacher_id NUMBER,
    score NUMBER(3),
    mobile_phone VARCHAR2(20),
    CONSTRAINT fk_student_id FOREIGN KEY (id) REFERENCES students(id)
);

-- Balın 0-100 aralığında olmasını təmin edən Check constraint
ALTER TABLE students_info ADD CONSTRAINT score_range_chk CHECK(score BETWEEN 0 AND 100);

-- 11. Məlumatların yenilənməsi (Xüsusi fənn və id-lər üzrə)
-- Müəyyən tələbənin SQL balının artırılması
UPDATE students_info SET score = 98 WHERE id = 1 AND subject = 'SQL';

-- Logistika fənni üzrə ümumi balların (limit daxilində) kütləvi artırılması
UPDATE students_info SET score = score + 5 
WHERE subject = 'Logistika' AND score <= 95;
COMMIT;

-- 12-14. Verilənlər Bazasının Normallaşdırılması (Address Normalization)
-- Mövcud cədvəllərdən köhnə address sütunlarının silinməsi
ALTER TABLE students DROP COLUMN address;
ALTER TABLE teachers_add_info DROP COLUMN address;

-- Yeni unifikasiya edilmiş Address cədvəlinin yaradılması
CREATE TABLE address ( 
    id NUMBER PRIMARY KEY,
    address1 VARCHAR2(100),
    address2 VARCHAR2(100),
    address3 VARCHAR2(100)
);

-- Məlumatların (Students və Teachers əsasında) yeni Address cədvəlinə köçürülməsi
INSERT INTO address (id, address1, address2, address3) VALUES (1, 'Baki', 'Yasamal r-nu', NULL);
INSERT INTO address (id, address1, address2, address3) VALUES (201, 'Baki', 'Nizami kuc.', 'm.45');
-- ... digər daxiletmələr
COMMIT;
