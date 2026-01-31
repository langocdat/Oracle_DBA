# **How To Kill Session**
## Step 1: Run Command

  SQL>```ALTER SYSTEM KILL SESSION 'sid,serial#' IMMEDIATE;```
  
  SQL>```select 'alter system kill session '||''''||sid ||','||serial#||',@'||inst_id||''''||' IMMEDIATE ;' from gv$session where username in ('SYS');```
  
  <img width="1041" height="211" alt="image" src="https://github.com/user-attachments/assets/403dddb6-c9ec-437b-9f7e-ee453608aebc" />

## Step 2: Copy results and Run:

  <img width="569" height="498" alt="image" src="https://github.com/user-attachments/assets/71340071-4bf9-4a7b-b603-89e0d77e66b9" />

## Step 3: Check Session:
  `
  set linesize 200;
  col spid format a10;
  col PROGRAM format a50;
  col username format a20;
  SELECT  p.spid, 
          s.sid, 
          s.serial#, 
          s.program, 
          s.username, 
          s.status,
          s.sql_id
  FROM    v$session s
  JOIN    v$process p ON p.addr = s.paddr
  WHERE   s.status = 'ACTIVE' 
  AND     s.username IS NOT NULL;
  `


