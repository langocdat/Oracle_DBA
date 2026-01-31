# **How To Kill Session**
## Step 1: Run Command

  SQL>`select 'alter system kill session '||''''||sid ||','||serial#||',@'||inst_id||''''||' IMMEDIATE ;' from gv$session where username in ('SYS');`
