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

### 9️⃣ Subqueries & Analytics (`09_subqueries_and_analytics.sql`)
* Subqueries: Single-row və Multi-row alt sorğuların tətbiqi.
* Correlated Subqueries: Daxili və xarici sorğuların qarşılıqlı əlaqəsi.
* Inline Views: FROM daxilində dinamik cədvəllərin (Inline View) yaradılması.

### 🔟 CO Schema & Set Operators (`10_co_schema_and_set_operations.sql`)
* CO Schema: Real biznes strukturlarında cədvəllərin istifadəsi.
* Set Operators: `UNION`, `UNION ALL`, `INTERSECT`, `MINUS`.
* Nəticələrin birləşdirilməsi və müqayisəsi.

### 1️⃣1️⃣ Analytical Window Functions (`11_analytical_window_functions.sql`)
* Window Functions: `ROW_NUMBER`, `RANK`, `DENSE_RANK`.
* Analitik hesablamalar: `OVER (PARTITION BY ...)`.
* Running total və moving average hesablamaları.

### 1️⃣2️⃣ Regex & String Aggregation (`12_regex_and_string_aggregation.sql`)
* REGEXP funksiyaları ilə pattern axtarışı və validasiya.
* Localization-aware regex: `[:upper:]`, `[:lower:]` kimi multi-language uyğun pattern-lər.
* String manipulation: `SUBSTR`, `INSTR`, `REPLACE`.
* String aggregation: `LISTAGG` ilə məlumatların birləşdirilməsi.
### 1️⃣3️⃣ DDL, DML & Data Management (`13_ddl_dml_and_data_management.sql`)
* DDL əmrləri: `CREATE`, `ALTER`, `DROP`.
* DML əmrləri: `INSERT`, `UPDATE`, `DELETE`.
* Data idarəetməsi və struktur dəyişiklikləri.

### 1️⃣4️⃣ Schema Creation & Management (`14_schema_creation_and_management.sql`)
* Schema yaradılması və idarə olunması.
* Table constraints: `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`.
* Struktur optimizasiyası.

### 1️⃣5️⃣ Normalization & Localization (`15_normalization_and_localization.sql`)
* Localization-Aware Constraints: `[A-Z]` əvəzinə `[:upper:]` istifadə edilərək multi-language dəstək.
* Multi-Level Data Integrity: `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `CHECK` constraint-lərin tətbiqi.
* Relational Mapping: One-to-Many əlaqələrin idarə olunması (bir student – çox subject).
* Database Normalization: Address kimi məlumatların ayrıca normallaşdırılmış cədvələ ayrılması.
* Data Scrubbing & Updates: Müəyyən subject-lər üzrə score-ların bulk update ilə standartlaşdırılması.

### 1️⃣6️⃣ TCL & View Management (`16_tcl_and_view_management.sql`)
* TCL əmrləri: `COMMIT`, `ROLLBACK`, `SAVEPOINT`.
* Views: Sadə və kompleks view-ların yaradılması.
* Virtual cədvəllərlə işləmə.

### 1️⃣7️⃣ Multi-table Inserts (`17_multi_table_inserts.sql`)
* Multi-table insert əməliyyatları.
* `INSERT ALL` və `INSERT FIRST`.
* Bir sorğu ilə çox cədvələ yazma.

### 1️⃣8️⃣ Advanced Date & Interval (`18_advanced_date_and_interval.sql`)
* Date funksiyaları: `SYSDATE`, `ADD_MONTHS`.
* Interval anlayışı və zaman hesablamaları.
* Tarix üzərindən analitik sorğular.

### 1️⃣9️⃣ Advanced Merge & Upsert (`19_advanced_merge.sql`)
* `MERGE` əmri ilə upsert əməliyyatları.
* Şərtli update və insert.
* Data sinxronizasiyası.

### 2️⃣0️⃣ Performance Tuning (`20_performance_tuning.sql`)
* Query optimizasiya üsulları.
* Index istifadəsi və performans təsiri.
* Execution plan analizi.

### 2️⃣1️⃣ Synonyms & Hierarchies (`21_synonyms_and_hierarchies.sql`)
* Synonyms: obyektlər üçün alias yaradılması.
* Hierarchical queries: `CONNECT BY`, `LEVEL`.
* Tree strukturları ilə işləmə.

### 📊 Biznes Keys-lər
* Real biznes problemlərinin SQL ilə həlli.
* Analitik düşüncə və qərar dəstəyi.
* Kompleks ssenarilərin modelləşdirilməsi.

### 🧩 WITH Clause & CTE (`complex_queries_with_cte.sql`)
* WITH (CTE): Sorğuların daha oxunaqlı və modul şəkildə yazılması.
* Recursive CTE: Hierarchical data və tree strukturlarının qurulması.
* Complex Queries: Bir neçə mərhələli analitik sorğuların sadələşdirilməsi.
* Subquery alternativi kimi performans və struktur üstünlükləri.
*/

---

## 🛠️ Texnologiyalar
* **Database:** Oracle 18c (HR & CO Schemas)
* **Tool:** SQL Developer / Oracle SQL Live


---
⭐ **Bu layihə mənə SQL-in məntiqini dərindən anlamağa və böyük data setləri ilə effektiv işləməyə kömək etdi.**
