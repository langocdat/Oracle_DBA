# Step 1: Check IP in server
[grid@srv1 admin]$ ```ip a```
```
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
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
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:bc:17:b0 brd ff:ff:ff:ff:ff:ff
    inet 192.168.59.11/24 brd 192.168.59.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
    inet 169.254.1.171/19 brd 169.254.31.255 scope global enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::df09:735e:388c:aa44/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
4: enp0s9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:24:6a:d5 brd ff:ff:ff:ff:ff:ff
    inet 10.0.4.15/24 brd 10.0.4.255 scope global dynamic noprefixroute enp0s9
       valid_lft 83557sec preferred_lft 83557sec
    inet6 fd17:625c:f037:4:d8d4:6081:217a:8f7/64 scope global dynamic noprefixroute
       valid_lft 86266sec preferred_lft 14266sec
    inet6 fe80::fe1f:4ac7:4fc4:8f69/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
```
