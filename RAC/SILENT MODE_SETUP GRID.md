# Step 1: Tạo ASM DISKGROUP
[root]$
  ```
  udevadm info --query=all --name=/dev/vdb
  udevadm info --query=all --name=/dev/vdc
  lsblk
  ```
[root]$ vi /etc/udev/rules.d/99-oracle-asm.rules
  ```
  SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", ENV{ID_PATH_TAG}=="pci-0000_05_00_0", \
      SYMLINK+="ASM_DATA", OWNER="grid", GROUP="asmadmin", MODE="0660"
  
  SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", ENV{ID_PATH_TAG}=="pci-0000_06_00_0", \
      SYMLINK+="ASM_FRA", OWNER="grid", GROUP="asmadmin", MODE="0660"
  ```
[root]$
  ```
  udevadm control --reload-rules
  udevadm trigger
  ls -ln /dev/ASM*
  ```
