# Decribe
- Rac 2 node
- Upgrade version 12C to 19C and apply patch 19.30

# Perform
## Step 1: Prerequire
### 1.1 Shutdown all the database run on the both node.
### 1.2 Get file to the node 1
```
[root@srv1 ~]# cd /u01/software/
[root@srv1 software]# ll
total 6862604
-rw-r--r--. 1 root root 4065210500 Oct 10 21:06 p38629535_190000_Linux-x86-64.zip
-rw-r--r--. 1 root root   72896144 Oct 10 21:05 p6880880_190000_Linux-x86-64.zip
-rw-r--r--. 1 root root 2889184573 Oct 10 21:05 V982068-01_grid.zip
```

## Step 2: Backup in the both node
*Use the root user*
- Backup /u01/app/oraInventory
  
- Backup /u01/app/12c/grid
- Backup /u01/app/grid


