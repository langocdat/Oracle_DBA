Step 1: Configure and Install
  - RAM: 4096 MB
  - Process: 3
  - Network: Hostonly and Bridged Adapter 
Step 2: Configure Virtual machine
  - Hostname:
      (bash): hostnamectl set-hostname srv1.localdomain
      (bash): hostname
  - Configure IP Address
      (bash): vi /etc/sysconfig/network-scripts/ifcfg-enp0s3

      (bash): systemctl restart network    ->> Apply change
