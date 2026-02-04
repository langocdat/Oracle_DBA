  <img width="657" height="564" alt="image" src="https://github.com/user-attachments/assets/cb5bdff2-f3cc-481d-99ef-00c61b784117" />

  # Tổng quan
  ## 1.Tablespaces
  - Tablespace là đơn vị lưu trữ cấp cao chứa các segment (Table, Index).
  - Tablespace là đơn vị trung gian quản lý các datafile (OS tương tác) và các Table, Index (User tương tác).
  - Có 5 tablespace mặc định:
    + SYSTEM/SYSAUX: chứa dữ liệu hệ thống của Oracle
    + USERS: chứa dữ liệu người dùng
    + TEMP: chứa dữ liệu tạm thời
    + UNDOTBS: chứa dữ liệu phục vụ hoàn tác (UNDO)
  - Check tablespace:
    SQL> ```select TABLESPACE_NAME, STATUS from dba_tablespaces;```
    ```
    TABLESPACE_NAME                STATUS
    ------------------------------ ---------
    SYSTEM                         ONLINE
    SYSAUX                         ONLINE
    UNDOTBS1                       ONLINE
    TEMP                           ONLINE
    USERS                          ONLINE
    UNDOTBS2                       ONLINE
    6 rows selected.
    ```
  
  

  

