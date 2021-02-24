#!/usr/bin/env python
# coding=utf-8

import os,sys


# Config network
interface = sys.argv[1]
interfacefile = '/etc/sysconfig/network-scripts/ifcfg-' + interface
ipaddress = raw_input("Interface " + interface + " IPADDR: ")
DEFROUTE = raw_input("DEFROUTE yes or no: ")

TYPE = 'Ethernet'
BOOTPROTO = 'static'
GATEWAY = '1.0.0.2'
ONBOOT = 'yes'

if DEFROUTE == 'yes' :
   PREFIX = '8'
else:
   PREFIX = '24'

DNS1 = '114.114.114.114'
DNS2 = '223.5.5.5'

network_item = ['TYPE', 'BOOTPROTO', 'DEFROUTE', 'ONBOOT', 'NAME', 'DEVICE', 'IPADDR', 'PREFIX', 'DNS1', 'DNS2', 'GATEWAY']
network_val = [TYPE, BOOTPROTO, DEFROUTE, ONBOOT, interface, interface, ipaddress, PREFIX, DNS1, DNS2, GATEWAY]
network_fmt = '{}={}\n'

if DEFROUTE == 'no' :
   del network_item[-3:]
   del network_val[-3:]


# Write Interface file
f = open(interfacefile,'w')
for i in range(len(network_item)):
    f.write(network_fmt.format(network_item[i], network_val[i]))

f.close()
os.system('systemctl restart network')

# Firewall
os.system('systemctl disable firewalld')
