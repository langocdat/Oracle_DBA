=============================================
Chuẩn bị:
  - Cài đặt oracle database trên cả 2 node
  - Primary Databae cần có database

=============================================
Step 1: Đặt hostname cho 2 node
  - (bash): hostnamectl set-hostname srv1.localdomain
  - (bash): hostnamectl set-hostname srv2.localdomain
Step 2: Sửa file /etc/hosts trên 2 node
  - (bash): vi /etc/hosts
    192.168.68.11 srv1.localdomain srv1
    192.168.68.12 srv2.localdomain srv2

=============================================
|             PRIMARY DATABASE              |
=============================================
Step 3: Archive log mode
  - (Sql): alter system set log_archive_dest_1='LOCATION=USE_DB_RECOVERY_FILE_DEST' scope=both;
  - (Sql): Select log_mode from v$database;
  - (Sql): archive log list;
-->> Set đường dẫn USE_DB_RECOVERY_FILE_DEST: [Config parameter FRA] (https://github.com/langocdat/Oracle_DBA/blob/main/OracleDatabase/Parameter_FRA)
    
