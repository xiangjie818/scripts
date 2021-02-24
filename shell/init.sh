#!/bin/bash
read -p "Address ens33: " ENS33
read -p "Address ens34: " ENS34
read -p "Hostname: " HOSTNAME
echo """TYPE=Ethernet
BOOTPROTO=static
NAME=ens33
DEVICE=ens33
ONBOOT=yes
IPADDR=$ENS33
PREFIX=24""" > /etc/sysconfig/network-scripts/ifcfg-ens33

echo """TYPE=Ethernet
BOOTPROTO=static
DEFROUTE=yes
NAME=ens34
DEVICE=ens34
ONBOOT=yes
IPADDR=$ENS34
PREFIX=24
GATEWAY=172.10.10.254""" > /etc/sysconfig/network-scripts/ifcfg-ens34

echo "$HOSTNAME" > /etc/hostname

SELINUX=$(getenforce)
if [ $SELINUX != Disabled ] ; then
   sed -i s/SELINUX=enforcing/SELINUX=disabled/ /etc/selinux/config
fi

systemctl disable firewalld

USEDNS=$(cat /etc/ssh/sshd_config  | grep UseDNS | awk '{print $2}')
if [ $USEDNS != no ] ; then
   sed -i  s/"#UseDNS yes"/"UseDNS no"/ /etc/ssh/sshd_config
fi

for i in {5..1} ; do
    clear
    echo "System will reboot later $i s"
    if [ $i = 1 ] ; then
       reboot
    else 
       let i--
       sleep 1
    fi
done
