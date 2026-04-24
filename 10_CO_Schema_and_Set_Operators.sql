/*
  Project: Customer Orders (CO) Schema Analysis & Set Operations
  Database: Oracle CO Schema (Customer Orders)
  Author: Vüsal Bağırov
  
  Key Features & Functions Used:
  -----------------------------
  1. Set Operators: UNION (Unique combine), INTERSECT (Shared data), MINUS (Difference)
  2. Multi-Table Relational Analysis: JOINs across Customers, Orders, Items, and Stores
  3. Advanced String Manipulation: TRANSLATE & REPLACE for custom ID generation
  4. Time-Series Filtering: Filtering data by specific years (2021)
  5. Multi-Query Combination: Using UNION to merge regional reports
*/

-- 1. Sxema ilə tanışlıq (Bütün cədvəllər)
SELECT * FROM co.customers;
SELECT * FROM co.orders;
SELECT * FROM co.stores;
-- ... digər cədvəllər də eyni qaydada nəzərdən keçirilir.

-- 2. "CANCELLED" statuslu sifarişlərin mağaza üzrə statistikası
SELECT 
    store_id, 
    order_status, 
    COUNT(*) AS total_cancelled
FROM co.orders
WHERE order_status = 'CANCELLED'
GROUP BY store_id, order_status
ORDER BY total_cancelled DESC;

-- 3. 2021-ci ilə aid sifarişlərin tapılması
SELECT * FROM co.orders
WHERE order_tms >= TIMESTAMP '2021-01-01 00:00:00'
  AND order_tms < TIMESTAMP '2022-01-01 00:00:00';

-- 4. "REFUNDED" statuslu sifarişlər və müştəri adları
SELECT 
    c.full_name, 
    o.order_tms, 
    o.order_status
FROM co.customers c 
JOIN co.orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'REFUNDED';

-- 5. Qiyməti > 30 və Miqdarı >= 5 olan sifariş detalları
SELECT 
    c.full_name, 
    o.order_status, 
    oi.unit_price, 
    oi.quantity
FROM co.customers c 
JOIN co.orders o ON c.customer_id = o.customer_id 
JOIN co.order_items oi ON o.order_id = oi.order_id
WHERE oi.unit_price > 30 
  AND oi.quantity >= 5
ORDER BY oi.unit_price DESC;

-- 6. Çatdırılma statusuna görə müştəri qruplaşdırması (Say > 2 olanlar)
SELECT 
    c.full_name, 
    s.shipment_status, 
    COUNT(s.shipment_id) AS shipment_count
FROM co.customers c 
JOIN co.shipments s ON c.customer_id = s.customer_id 
GROUP BY c.full_name, s.shipment_status
HAVING COUNT(s.shipment_id) > 2
ORDER BY shipment_count DESC;

-- 7. Customers və Orders cədvəllərindəki unikal müştəri ID-ləri (UNION)
SELECT customer_id FROM co.customers
UNION
SELECT customer_id FROM co.orders;

-- 8. Müştəri olub, lakin heç vaxt sifariş etməyənlərin tapılması (MINUS)
SELECT customer_id, full_name FROM co.customers
MINUS
SELECT c.customer_id, c.full_name 
FROM co.customers c 
JOIN co.orders o ON c.customer_id = o.customer_id;

-- 9. Həm müştəri bazasında olan, həm də sifarişi olanlar (INTERSECT)
SELECT customer_id FROM co.customers
INTERSECT
SELECT customer_id FROM co.orders;

-- 10. Mağazalar üzrə sifariş sayları
SELECT 
    s.store_name, 
    COUNT(o.order_id) AS total_orders
FROM co.orders o 
JOIN co.stores s ON o.store_id = s.store_id
GROUP BY s.store_name
ORDER BY total_orders DESC;

-- 11. "CANCELLED" sifarişlərin məhsul detalları ilə hesabatı
SELECT 
    c.full_name, o.order_status, oi.unit_price, oi.quantity, p.product_name
FROM co.customers c 
JOIN co.orders o ON c.customer_id = o.customer_id 
JOIN co.order_items oi ON o.order_id = oi.order_id 
JOIN co.products p ON oi.product_id = p.product_id
WHERE o.order_status = 'CANCELLED';

-- 12. Regional Hesabat: Austria və Argentina (UNION ilə birləşmə)
SELECT s.store_id, o.customer_id, COUNT(*) AS total_orders, 'Austria' AS country
FROM co.orders o JOIN co.stores s ON o.store_id = s.store_id
WHERE s.physical_address LIKE '%Austria%'
GROUP BY s.store_id, o.customer_id
UNION
SELECT s.store_id, o.customer_id, COUNT(*) AS total_orders, 'Argentina' AS country
FROM co.orders o JOIN co.stores s ON o.store_id = s.store_id
WHERE s.physical_address LIKE '%Argentina%'
GROUP BY s.store_id, o.customer_id
ORDER BY 3 DESC;

-- 13. Saitlərin çıxarılması ilə unikal işçi kodu yaradılması
-- TRANSLATE ilə saitləri boşluğa çevirib, REPLACE ilə həmin boşluqları silirik.
SELECT 
    employee_id,
    UPPER(REPLACE(TRANSLATE(LOWER(first_name || last_name), 'aeiouəiöüı', '          '), ' ', '')) 
    || employee_id AS unique_code
FROM hr.employees;
