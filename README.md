# Oracle SQL Exercises

Bu layihə Oracle HR sxemi üzərində apardığım SQL təcrübələrini və öyrəndiyim əsas sorğu metodlarını əhatə edir.

## 🛠 Texniki Detallar
* **Verilənlər Bazası:** Oracle Database (HR Schema)
* **İstifadə Olunan Mövzular:** Selection, Filtering, Sorting, Pagination.

## 📁 Layihənin Strukturu

### 1. Basic Selection Tasks (`basic_selection_tasks.sql`)
Bu faylda SQL-in təməl seçmə sorğuları yer alır:
* `SELECT *` və spesifik sütunların seçilməsi.
* Sadə filtrləmə (`WHERE` clause).
* `IS NOT NULL` şərti ilə boş olmayan dataların gətirilməsi.

### 2. Filtering & Sorting Tasks (`filtering_sorting_tasks.sql`)
Bu hissədə daha mürəkkəb və funksional sorğular yer alır:
* **Mürəkkəb Filtrləmə:** `IN`, `NOT IN`, `BETWEEN` operatorları.
* **Mətn Axtarışı:** `LIKE` operatoru ilə pattern matching (nümunə: `%a__`).
* **Sıralama:** `ORDER BY` (ASC/DESC) və `NULLS FIRST` funksionallığı.
* **Məhdudlaşdırma:** `OFFSET` və `FETCH NEXT` vasitəsilə səhifələmə (Pagination).
* **Dinamik Sorğular:** Bind variables (`:var`) istifadəsi.

## ✍️ Müəllif
**Bagirov Vusal** - SQL və Verilənlər Bazası öyrəncisi.

