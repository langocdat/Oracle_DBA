# Step 1: Check sequence in DR
SQL>
```
set lines 200;
select thread#, sequence#, archived, applied from v$archived_log;
```
