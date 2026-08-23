# Step 1: Check IP in server
[grid@srv1 admin]$ ```ip a```
```
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:e5:47:9a brd ff:ff:ff:ff:ff:ff
    inet 192.168.58.11/24 brd 192.168.58.255 scope global noprefixroute enp0s3
       valid_lft forever preferred_lft forever
    inet 192.168.58.13/24 brd 192.168.58.255 scope global secondary enp0s3:1
       valid_lft forever preferred_lft forever
    inet 192.168.58.15/24 brd 192.168.58.255 scope global secondary enp0s3:2
       valid_lft forever preferred_lft forever
    inet6 fe80::5e9b:a54a:b9be:8b27/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
.....
```
*Attension: chỉ add được các địa chỉ IP đang available từ kết quả của lệnh ip a*

# Step 2: Modify listener.ora file
[grid@srv1 admin]$ ```/u01/app/19c/grid/network/admin/listener.ora```
*- Thêm nội dung dưới đây:*
```
LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.58.11)(PORT = 1521))
      (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.58.13)(PORT = 1521))
      (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.58.15)(PORT = 1521))
    )
  )
```


