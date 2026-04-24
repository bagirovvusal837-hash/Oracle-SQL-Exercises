# 📊 SQL Learning Journey - From Basics to Advanced

Bu repozitoriya mənim SQL və Verilənlər Bazası üzrə öyrənmə yolçuluğumu əks etdirir. Burada Oracle SQL (HR və CO sxemaları) üzərində yerinə yetirdiyim 100-dən çox praktik tapşırıq və real ssenarilərə əsaslanan sorğular toplanmışdır.

## 👤 Müəllif
**Bağırov Vüsal** - *Data Analytics Enthusiast*

---

## 📂 Layihənin Strukturu

### 1️⃣ Basic Selection (`01_basic_selection.sql`)
* `SELECT *` və spesifik sütunların seçilməsi.
* `WHERE` klauzulası ilə sadə filtrləmə.
* `IS NOT NULL` şərti ilə boş olmayan dataların analizi.

### 2️⃣ Filtering & Sorting (`02_filtering_sorting.sql`)
* `IN`, `BETWEEN`, `LIKE` operatorları.
* `ORDER BY` (ASC/DESC) və `NULLS FIRST/LAST`.
* `OFFSET` və `FETCH NEXT` ilə səhifələmə (Pagination).

### 3️⃣ String Functions (`03_string_functions.sql`)
* Mətn manipulyasiyası: `UPPER`, `LOWER`, `INITCAP`.
* Alt sətirlərlə iş: `SUBSTR`, `INSTR`, `LENGTH`.
* Məlumat təmizləmə: `REPLACE`, `TRIM`, `LPAD/RPAD`.

### 4️⃣ Numeric & Date Functions (`04_numeric_date.sql`)
* Riyazi əməliyyatlar: `ROUND`, `TRUNC`, `MOD`.
* Tarix funksiyaları: `MONTHS_BETWEEN`, `ADD_MONTHS`, `NEXT_DAY`, `LAST_DAY`.
* Dinamik tarix hesablamaları (məs. sınaq müddətinin bitməsi).

### 5️⃣ Conversion & Null Handling (`05_conversion_nulls.sql`)
* Data tipi çevrilmələri: `TO_CHAR`, `TO_DATE`, `TO_NUMBER`.
* NULL dəyərlərlə iş: `NVL`, `NVL2`, `NULLIF`.
* Valyuta və tarix formatlaşdırılması.

### 6️⃣ Conditional Logic (`06_conditional_logic.sql`)
* Şərti məntiq: `CASE WHEN` və `DECODE` funksiyaları.
* Dinamik vergi və bonus hesablamaları.
* Biznes ssenarilərinə uyğun statusların təyini.

### 7️⃣ Aggregate & Grouping (`07_grouping_aggregates.sql`)
* Aqreqat funksiyaları: `SUM`, `AVG`, `MIN`, `MAX`, `COUNT`.
* Qruplaşdırma: `GROUP BY` və `HAVING` filtrasiyası.
* Analitik baxış: `ROLLUP` və `GROUPING SETS`.

### 8️⃣ Advanced Joins & Subqueries (`08_joins_subqueries.sql`)
* Cədvəllərin birləşdirilməsi: `INNER`, `LEFT`, `RIGHT`, `FULL OUTER`, `SELF JOIN`.
* Alt sorğular: `Scalar`, `Single-row`, `Multi-row` (ANY, ALL).
* Çox-cədvəlli (Multi-table) kompleks relasiyalar.

---

## 🛠 Texnologiyalar
* **Database:** Oracle 19c / 21c (HR & CO Schemas)
* **Tool:** SQL Developer / Oracle SQL Live

---
⭐ **Bu layihə mənə SQL-in məntiqini dərindən anlamağa və böyük data setləri ilə effektiv işləməyə kömək etdi.**
