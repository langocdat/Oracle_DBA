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
  ```
  OWNER                SEGMENT_NAME                   SEGMENT_TYPE       TABLESPACE_NAME                   SIZE_MB    EXTENTS
  -------------------- ------------------------------ ------------------ ------------------------------ ---------- ----------
  SYS                  EMPLOYEE                       TABLE              SYSTEM                              .0625          1
  ```

## 4. Max size of datafile in Tablespace

- Max size của datafile phụ thuộc vào 2 yếu tố chính

  > Loại tablespace (smallfile hay bigfile)
  
  > Kích htước block của datafile

  | Block size | Max size datafile |
  | :- | :- |
  | 2KB | 8GB |
  | 4KB | 16GB |
  | 8KB | 32GB |
  | 16KB | 64 GB |
  | 32KB | 128GB |

## 5. How to check overview space
SQL>
```
SELECT A.TABLESPACE_NAME,ROUND (100 * (A.BYTES_ALLOC - NVL (B.BYTES_FREE,0)) / A.BYTES_ALLOC,0) USAGE,ROUND (A.BYTES_ALLOC / 1024 / 1024) SIZEMB,ROUND (NVL (B.BYTES_FREE,0) / 1024 / 1024) FREEMB,ROUND ( (A.BYTES_ALLOC - NVL (B.BYTES_FREE,0)) / 1024 / 1024) USEDMB,ROUND (MAXBYTES / 1048576) MAX,ROUND (100 * (A.BYTES_ALLOC - NVL (B.BYTES_FREE,0)) / A.MAXBYTES,0) USED_PCT_OF_MAX
FROM (
        SELECT F.TABLESPACE_NAME,SUM (F.BYTES) BYTES_ALLOC,SUM ( DECODE (F.AUTOEXTENSIBLE,'YES',F.MAXBYTES,'NO',F.BYTES)) MAXBYTES
        FROM DBA_DATA_FILES F
        GROUP BY TABLESPACE_NAME
    )                        A,(
        SELECT F.TABLESPACE_NAME,SUM (F.BYTES) BYTES_FREE
        FROM DBA_FREE_SPACE F
        GROUP BY TABLESPACE_NAME
    )                        B
WHERE A.TABLESPACE_NAME = B.TABLESPACE_NAME(+) UNION ALL
    SELECT H.TABLESPACE_NAME,ROUND ( SUM (NVL (P.BYTES_USED,0)) / SUM (H.BYTES_FREE + H.BYTES_USED),0) USAGE,ROUND (SUM (H.BYTES_FREE + H.BYTES_USED) / 1048576) MEGS_ALLOC,ROUND ( SUM ( (H.BYTES_FREE + H.BYTES_USED) - NVL (P.BYTES_USED,0)) / 1048576) MEGS_FREE,ROUND (SUM (NVL (P.BYTES_USED,0)) / 1048576) MEGS_USED,ROUND ( SUM (DECODE (F.AUTOEXTENSIBLE,'YES',F.MAXBYTES,F.BYTES)) / 1048576,0) MAX,ROUND ( 100 * SUM (NVL (P.BYTES_USED,0)) / SUM (DECODE (F.AUTOEXTENSIBLE,'YES',F.MAXBYTES,F.BYTES)),0) USED_PCT_OF_MAX
    FROM SYS.V_$TEMP_SPACE_HEADER H,SYS.V_$TEMP_EXTENT_POOL P,DBA_TEMP_FILES F
    WHERE P.FILE_ID(+) = H.FILE_ID AND P.TABLESPACE_NAME(+) = H.TABLESPACE_NAME AND F.FILE_ID = H.FILE_ID AND F.TABLESPACE_NAME = H.TABLESPACE_NAME
    GROUP BY H.TABLESPACE_NAME
    ORDER BY USED_PCT_OF_MAX DESC;
```

<img width="1034" height="228" alt="image" src="https://github.com/user-attachments/assets/dc81b34d-cd7e-4b10-94b0-da76593ef4a4" />

> Tablespaces được cấu thành từ các datafile, do vậy từ đây, nếu muốn thay đổi kích thước của tablespace, ta cần resize của những datafile thuộc tablespaces đó

SQL>
```
set pagesize 300;
set linesize 200;
col TABLESPACE_NAME format a30;
col FILE_NAME format a50;
select TABLESPACE_NAME, FILE_NAME, bytes/1024/1024 AS size_mb, autoextensible, STATUS from dba_data_files ORDER BY tablespace_name;
```

<img width="1076" height="153" alt="image" src="https://github.com/user-attachments/assets/94dd28ef-bf6e-47f6-bf93-c8579530a71a" />



