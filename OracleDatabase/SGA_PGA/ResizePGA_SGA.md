# Oracle Database 10G
1. SGA_target
2. SGA_MAX_SIZE (static parameter -> restart instance)
   <p>SGA_max_size là con số tối đa mà có thể cung cấp cho SGA</p>
   <p>SGA_target <= SGA_max_szie</p>
4. PGA_Aggregate_target
   
# Oracle Database 11G
1. MEMORY_MAX_TARGET
2. MEMORY_TARGET

# RESIZE

SQL> (10G)

```
show parameter sga
show parameter pga
```
```
alter system set pga_aggregate_target=100M scope=both sid='*';
alter system set sga_target=20G scope=both sid='*'; => Note: sga_target <= SGA_max_size
alter system set SGA_max_size=21G scope=spfile sid='*'; => restart instance
```

SQL> (11G)
<p>Set memory theo kiểu 11G không hỗ trợ huge page. Muốn sử dụng huge page cần sử dụng memory theo kiểu 10G </p>

```
show parameter memory;
```

```
alter system set MEMORY_MAX_TARGET = 100G scope=spfile sid='*'; -> restart instance
alter system set MEMORY_TARGET = 90G scope=both sid='*';
Note: MEMORY_TARGET <= MEMORY_MAX_TARGET
```
