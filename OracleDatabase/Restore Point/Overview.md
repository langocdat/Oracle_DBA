# SELECT
SQL>
```
set linesize 200;
col name format a30;
col SCN format 99999999999
col GUARANTEE_FLASHBACK_DATABASE format a10;
col time format a40;
col scn_to_timestamp(scn) format a40;
select name, scn, time, scn_to_timestamp(scn), GUARANTEE_FLASHBACK_DATABASE from v$restore_point;
```

# CREATE
SQL>
```
CREATE RESTORE POINT <name> GUARANTEE FLASHBACK DATABASE;
```

Example: ```create restore point bef_swover guarantee flashback database;```

# DROP
SQL>
```
drop restore point <name>
```
