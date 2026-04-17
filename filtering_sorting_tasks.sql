-- 1. Manager ID-si 100 olan və komissiyası olmayan əməkdaşların adı və maaşı.
select first_name, salary from employees where manager_id = 100 and commission_pct is null;

-- 2. Department ID-si 60 və 30 olmayan, maaşı 5000-18000 arası olanlar.
select * from employees where department_id not in (60,30) and salary between 5000 and 18000 order by salary;

-- 3. Emailləri BMILLER, AJAMES, JCHEN olanları gətirin.
select * from employees where email in ('BMILLER' , 'AJAMES' , 'JCHEN');

-- 4. Soyadların sondan üçüncü hərfi 'a' olan və maaşları 7500-dən yuxarı olanlar.
select * from employees where last_name like '%a__' and salary > 7500;

-- 5. Adında həm 'a', həm də 't' hərfi olan əməkdaşlar.
select * from employees where first_name like '%a%' and first_name like '%t%';

-- 6. Job ID-si FI_ACCOUNT və ya SA_REP olan və maaşı 7000-dən yuxarı olanlar.
select * from employees where (job_id = 'FI_ACCOUNT' or job_id = 'SA_REP') and salary > 7000;

-- 7. Maaşları ən çoxdan aza doğru sıralayın və yanına 'AZN' yazın.
select first_name, last_name, salary || ' AZN' as salary_azn from employees order by salary desc;

-- 8. Maaşı 7000-dən yüksək, Job ID-si (AD_VP, IT_PROG, FI_ACCOUNT) və Department (100, 60) olanlar (IN istifadə etmədən).
select * from employees where salary > 7000 
and (job_id = 'AD_VP' or job_id = 'IT_PROG' or job_id ='FI_ACCOUNT')
and(department_id = 100 or department_id = 60);

-- 9. Maaşa görə DESC, Department ID-yə görə ASC sıralama.
select * from employees order by salary desc, department_id;

-- 10. "Ellen's email is EABEL" formatında çap edin.
select first_name || q'['s email is ]' || email as info from employees;

-- 11. Ən çox maaş alan ilk 20 əməkdaşdan başqa digərləri.
select * from employees order by salary desc offset 20 rows;

-- 12. Son 10 əməkdaşı gətirin.
select * from employees order by employee_id desc fetch first 10 rows only;

-- 13. Commission_pct-ə görə sıralayın, Null-lar birinci gəlsin.
select * from employees order by commission_pct nulls first;

-- 14. Maaşı 5000-15000 arası olanları Bind Variable ilə gətirin.
select * from employees where salary between :sal1 and :sal2 order by salary;
