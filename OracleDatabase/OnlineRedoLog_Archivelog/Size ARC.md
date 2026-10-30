SELECT ROUND(SUM(blocks * block_size) / 1024 / 1024 / 1024, 2) AS "Total_Archive_Size_GB"
FROM v$archived_log
WHERE deleted = 'NO';

SQL>
```
SQL> 
set lines 200;
SELECT
     arc.total_files AS "Total_Files",
     ROUND(arc.total_size_bytes / 1024 / 1024 / 1024, 2) AS "Archive_Size_GB",
     ROUND(dest.space_limit / 1024 / 1024 / 1024, 2) AS "Dest_Size_GB",
     ROUND((arc.total_size_bytes / dest.space_limit) * 100, 2) AS "Used_Percent_%"
 FROM
(SELECT
             COUNT(name) AS total_files,
         SUM(blocks * block_size) AS total_size_bytes
      FROM v$archived_log
      WHERE deleted = 'NO'
        AND status = 'A'
   AND standby_dest = 'NO' AND name IS NOT NULL) arc, (SELECT space_limit FROM v$recovery_file_dest) dest;
```

<img width="896" height="283" alt="image" src="https://github.com/user-attachments/assets/4741a2bd-efaf-4e09-97fa-1cc3da045f7c" />
