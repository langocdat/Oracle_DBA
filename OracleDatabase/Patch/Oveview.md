# 1. How to Search and Download Patch

<img width="702" height="552" alt="image" src="https://github.com/user-attachments/assets/a5fb0181-89c0-4936-8121-aabeb72e320a" />

<img width="568" height="940" alt="image" src="https://github.com/user-attachments/assets/1f96167d-ecf2-4ca2-9ea8-5b8130fa1bf6" />

# 2. Phân loại
## GIRU (Grid Infrastructure Release Update)
  -  Áp dụng cho GRID
## DBRU (Database Release Update)
  - Áp dụng cho DB

# 3. Các loại Patch chính
## 3.1. RU (Release Update)
  - Patch định kỳ hàng quý
## 3.2. RUR (Release Update Revision)
  - Patch nhỏ hơn RU
  - Chỉ fix thêm bug trên RU trước đó
## 3.4. OJVM Patch
  - Patch cho Oracle Java Virtual Machine
    
# 4. Check Patch SQL
SQL> 
    ```col ACTION_TIME format a30;
       col ACTION format a10;
       col status format a10;
       set linesize 200;
       select action_time, action, status, description from dba_registry_sqlpatch order by action_time;```
