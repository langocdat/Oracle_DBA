  <img width="657" height="564" alt="image" src="https://github.com/user-attachments/assets/cb5bdff2-f3cc-481d-99ef-00c61b784117" />

# Tổng quan
## 1. Tablespaces
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
## 2. Segment
  - Segment là tập hợp các Extent (vùng không gian liên tiếp) chứa tất cả dữ liệu cho một cấu trúc logic cụ thể trong 1 TBS.
  - Một table không chứa partition được lưu trữ trong 1 segment duy nhất.
  - Mỗi index là 1 segment.
  - Nếu table có partition, mỗi partition sẽ là 1 segment riêng biệt. Ví dụ: 1 table có 4 partition, bảng có sẽ có 4 segments riêng biệt.

    > Ví dụ: * Partition_2023: Nằm trên Tablespace OLD_DATA (ổ đĩa HDD chậm, rẻ).
    
    > Partition_2024: Nằm trên Tablespace FAST_DATA (ổ đĩa SSD tốc độ cao).
    
    > Tuy nhiên, về mặt logic, người dùng vẫn chỉ thấy đó là một cái tên bảng duy nhất.
    
    > Tiết kiệm tài nguyên: Nếu hệ thống có 10.000 bảng mà tạo 10.000 file thì OS sẽ "sập tiệm" vì không quản lý nổi danh sách mở tệp (File descriptors).
    
    > Linh hoạt: Segment cho phép dữ liệu của một bảng có thể nhảy sang file thứ hai (data02.dbf) nếu file thứ nhất hết chỗ, mà người dùng vẫn thấy nó là một bảng duy nhất.

## 3. How to check Table belong to Tablespace and Segment
  SQL> 
  ```
  set linesize 200;
  col OWNER format a20;
  col segment_name format a30;
  SELECT owner, segment_name, segment_type, tablespace_name, bytes / 1024 / 1024 AS size_mb, extents
  FROM dba_segments WHERE segment_name = 'EMPLOYEE';
  ```
  

  

