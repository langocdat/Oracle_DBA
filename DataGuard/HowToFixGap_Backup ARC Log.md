# Step 1: Check sequence in DR
SQL>
```
set lines 200;
select thread#, sequence#, archived, applied from v$archived_log;
select process,status,sequence# from v$managed_standby;
select thread#, max(sequence#) from gv$archived_log where applied='YES' group by thread# order by 1;
```
# Step 2: Check error in DC
SQL>
```
set lines 200;
select dest_id, destination,vstatus, error from v$archive_dest where dest_id=5;
```
# Step 3: Check archive log theo sequence còn tồn tại trên DC không
SQL> DC
```
select process,status from v$archive_processes;
select thread#, max(sequence#) from gv$archived_log where archived='YES' group by thread# order by 1;
SELECT thread#, sequence#, name FROM gv$archived_log WHERE thread#=2 AND sequence# BETWEEN 532850 AND 532860 ORDER BY sequence#;
```

# Step 4: Backup Archive log bằng RMAN
RMAN>
```
run {
allocate channel c1 device type disk;
allocate channel c2 device type disk;
allocate channel c3 device type disk;
allocate channel c4 device type disk;
backup as compressed backupset archivelog from sequence 532850 until sequence 532860 thread 2 format '/backup/arch_gap_t2_%d_%T_%U.bkp';
release channel c1;
release channel c2;
release channel c3;
release channel c4;
}
```
-> scp backup file sang DR
# Step 5: catalog backup archive vào DR
RMAN> DR
```
CATALOG START WITH '/backup/dataguard_gap/';
```
# Step 6: Restore archivelog vào ASM
RMAN> DR
```
RUN {
    SET ARCHIVELOG DESTINATION TO '+RECO';
    RESTORE ARCHIVELOG
        FROM SEQUENCE 532736 UNTIL SEQUENCE 532833 THREAD 2;
}
```
# Step 7: Restart MRP
SQL>
```
alter database recover managed standby database cancel;
alter database recover managed standby database nodelay disconnect;
```
