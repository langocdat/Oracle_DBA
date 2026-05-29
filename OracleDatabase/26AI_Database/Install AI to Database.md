# Tổng quát:
- Cài đặt Python
- Get mô hình AI dạng Text Embedding
- Đóng gói thành file ONNX
- Import file ONNX vào Database

## 1. Chuẩn bị môi trường
SQL> 
  ```
  ALTER SYSTEM SET vector_memory_size=1G SCOPE=SPFILE;
  startup force;
  ```
  ```
  SELECT CON_ID, POOL, ALLOC_BYTES/1024/1024 as ALLOC_BYTES_MB, USED_BYTES/1024/1024 as USED_BYTES_MB
    FROM V$VECTOR_MEMORY_POOL ORDER BY 1,2;
  ```
Attention: Oracle sẽ tự động cắt 1GB từ tổng dung lượng SGA_TARGET hiện tại để chuyển sang cho vector_memory_size

# Giai đoạn 1: Chuẩn bị môi trường
## 1. Cài đặt python 3.13.5
[bash_oracle]$ ```mkdir -p /home/oracle/python``` -> Đường dẫn python home

[bash_oracle]$ ```wget https://www.python.org/ftp/python/3.13.5/Python-3.13.5.tgz```

[bash_oracle]$ ```tar -xvzf Python-3.13.5.tgz --strip-components=1 -C /home/oracle/python```
## 2. Configure biến môi trường
## 3. Tạo liên kết symlink
## 4. 
