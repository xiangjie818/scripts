#!/usr/bin/env python
import os,sys
sys.path.append(os.getcwd)
import ceph_gzky

ceph = ceph_gzky.Ceph()
ceph.command("ceph -s")
ceph.match('in')
print "IN:" + ceph.skew(-1)
