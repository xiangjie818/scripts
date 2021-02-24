#!/usr/bin/env python
import os,sys
sys.path.append(os.getcwd)
import ceph_gzky
color = ceph_gzky.Color()
ceph = ceph_gzky.Ceph()

# Memory
ceph.command('free -m')
ceph.match('Mem:')

color.purple('Memory Usage')
color.green(ceph.usage())

# Cpu
ceph.command('top -n 1')
ceph.match('Cpu')

color.purple('CPU Usage')
color.green(ceph.usage())

# Cluster Status
ceph.command('ceph -s')
ceph.match('health:')
color.purple('Cluster Status')
color.green(ceph.skew(1))

# OSD Status
ceph.match('up,')
osd_up = ceph.skew(-1)
ceph.match('in')
osd_in = ceph.skew(-1)
color.purple('OSD Status')
color.green('UP: ' + osd_up + ' ' * 4 + 'IN:' + osd_in)
                          
# Cluster Space Status
ceph.match('used,')
cluster_used = ceph.skew(-1)
ceph.match('avail')
cluster_avail = ceph.skew(-1)
color.purple('Cluster Space Status')
color.green('Used: ' + cluster_used + ' ' * 4 + 'Total: ' + cluster_avail)
# Disk Space Status
color.purple('Disk Space Usage')
ceph.command('df -h')
ceph.match('osd',0,4)

# Disk Inode Status
color.purple('Disk Inode Usage')
ceph.command('df -i')
ceph.match('osd',0,3,4)

# OSD Space Status
color.purple('OSD Space Usage')
ceph.command('ceph osd df tree')
ceph.match('hdd',10,7)
