#!/bin/bash
LANG=en_US.UTF-8
yum -y install cloud-utils-growpart
growpart /dev/vda 2

VG=$(vgs)
pvresize -v /dev/vda2
lvextend -l +100%FREE /dev/mapper/$VG-root
xfs_growfs /
