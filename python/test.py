#!/usr/bin/env python
import os,sys
sys.path.append(os.getcwd)
import gzky

gzky.purple("Memory Usage")
gzky.used("top -n 1", 7, 3, "Memory")

gzky.purple("CPU Usage")
gzky.used("top -n 1", 0, 1, "Cpu")

gzky.purple("Disk Space Usage")
gzky.used("df -h", 0, 4)

gzky.purple("Disk Inode Usage")
gzky.used("df -i",0 , 4)

gzky.purple("OSD Space Usage")
gzky.used("ceph osd df tree", 10, 7)

gzky.purple("Cluster Status")
gzky.green(gzky.ceph("health:", 1))

gzky.purple("OSD Status")
gzky.green(gzky.format("UP",gzky.ceph("up,", -1),"IN",gzky.ceph("in", -1)))

gzky.purple("Cluster Space Used")
gzky.green(gzky.format("Total", gzky.ceph("avail", -1), "Used", gzky.ceph("used,",-1)))
