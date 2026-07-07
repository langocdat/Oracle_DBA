# 1. Check time remaining
SQL>
  ```
  SELECT ROUND(MAX(time_remaining)/3600,2) remaining_hours FROM v$session_longops WHERE opname LIKE 'RMAN%' AND sofar < totalwork;
  ```

Example:
```
REMAINING_HOURS
---------------
            .95
```

# 2. Check count datafile restore
SQL>
  ```
  SELECT COUNT(*) total_files, SUM(CASE WHEN c.file# IS NOT NULL THEN 1 ELSE 0 END) restored_files FROM v$datafile d
  LEFT JOIN (SELECT DISTINCT file# FROM v$datafile_copy WHERE status='A'AND deleted='NO') c ON d.file#=c.file#;
  ```

Example:
```
TOTAL_FILES RESTORED_FILES
----------- --------------
        300            299
```

# 3. Show datafile need to restore
SQL>
  ```
  set lines 200;
  set pages 999;
  col file_name format a90
  col con_name   format a25
  SELECT d.file#, d.name AS file_name FROM   v$datafile d WHERE  NOT EXISTS ( SELECT 1 FROM v$datafile_copy c WHERE c.file# = d.file# AND c.status = 'A' AND c.deleted = 'NO') ORDER BY d.file#;
  ```

Example:
```
     FILE# FILE_NAME
---------- ------------------------------------------------------------------------------------------
        17 +DATA/FNCRIBL/DATAFILE/fi_general.343.1230108461
```
