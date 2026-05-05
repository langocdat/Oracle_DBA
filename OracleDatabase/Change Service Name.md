# Cơ chế của Oracle Database 19c

Oracle tạo global service name theo công thức:

```service_name = service_names + db_domain```

- Check SQL> ```show parameter db_domain```
- Nếu có dữ liệu, cần update SQL>
  ```
  alter system set db_domain='' scope=spfile;
  restart database
  ```
# Change service name
SQL>
```
alter system set service_names='<new name>' scope=both sid='*';
alter system register;
```

# Check
[oracle]$ lsnrctl status | grep 'newname' 
