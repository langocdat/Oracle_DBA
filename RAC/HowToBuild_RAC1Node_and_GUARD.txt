Step 1: Configuration hostname
  [bash_root_dc]: hostnamectl set-hostname srvdc.localdomain
  [bash_root_dr]: hostnamectl set-hostname srvdr.localdomain
Step 2: Configuration IP
  [bash_root]: nmcli con show
  [bash_root]: vi /etc/sysconfig/network-scripts/ifcfg-...
  ----------------------------------------------------------------------
  |  STT  |     NAME     |          DC          |          DR          |
  ----------------------------------------------------------------------
  |   1   |   Host Only  |   192.168.58.11      |   192.168.58.12      |
  |   2   |   Internal   |   192.168.59.11      |   192.168.59.12      |
  |   3   |   NAT        |                      |                      |
  ----------------------------------------------------------------------
  
[bash_root]: cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Host-only
192.168.58.11 srvdc.localdomain srvdc
192.168.58.12 srvdr.localdomain srvdr

# Private
192.168.59.11 srvdc-priv.localdomain srvdc-priv
192.168.59.12 srvdr-priv.localdomain srvdr-priv

# Virtual IP
192.168.58.13 srvdc-vip.localdomain srvdc-vip
192.168.58.20 srvdr-vip.localdomain srvdr-vip

# SCAN
192.168.58.15 srvdc-scan.localdomain srvdc-scan
192.168.58.16 srvdc-scan.localdomain srvdc-scan
192.168.58.17 srvdc-scan.localdomain srvdc-scan

192.168.58.21 srvdr-scan.localdomain srvdr-scan
192.168.58.22 srvdr-scan.localdomain srvdr-scan
192.168.58.23 srvdr-scan.localdomain srvdr-scan

# DNS
192.168.58.18 dnsss1.localdomain dnsss1
192.168.58.24 dnsss2.localdomain dnsss2
