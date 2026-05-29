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
  SELECT CON_ID, POOL, ALLOC_BYTES/1024/1024 as ALLOC_BYTES_MB, USED_BYTES/1024/1024 as USED_BYTES_MB FROM V$VECTOR_MEMORY_POOL ORDER BY 1,2;
  ```
Attention: Oracle sẽ tự động cắt 1GB từ tổng dung lượng SGA_TARGET hiện tại để chuyển sang cho vector_memory_size
