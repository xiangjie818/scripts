#!/bin/bash
# System Information
# Functions
function purple() {
    echo -e "\033[35m$1\033[0m"
}

function green() {
    echo -e "\033[32m$1\033[0m"
}

function red() {
    echo -e "\033[36m$1\033[0m"
}

REDHAT_RELEASE=$(cat /etc/redhat-release)
CORE_RELEASE=$(uname -r)
HOSTNAME=$(hostname)

# CPU Information
CPU_ALL=0
for x in {1..5} ; do
    CPU_USE=$(top -n 1  | awk 'NR==3 {print $2}')
    CPU_ALL=$(awk "BEGIN{print $CPU_ALL+$CPU_USE}")
done
CPU_USE_AVG=$(awk "BEGIN{print $CPU_ALL/5}")
purple "CPU使用率"
green  "$CPU_USE_AVG%"
# Memory Information
MEM_ALL=0
for x in {1..5} ; do
    MEM_USE=$(top -n 1 | awk 'NR==4 {print $8/$4*100}')
    MEM_ALL=$(awk "BEGIN{print $MEM_ALL+$MEM_USE}")
done
MEM_USE_AVG=$(awk "BEGIN{print $MEM_ALL/5}")
purple "内存使用率"
green "$MEM_USE_AVG%"

# Disk
DISK_USE=$(df -h | grep ceph | awk '{print $1 "  "$5}')
purple "磁盘空间使用率"
red "Disk       Used"
green "$DISK_USE"
# Inode
INODE_USE=$(df -i | grep ceph | awk '{print $1 "  "$4 "  "$5}')
purple "磁盘Inode使用率"
red "Disk       IFree    Used"
green "$INODE_USE"

# Ceph Health
CEPH_HEALTH=$(ceph -s | grep health | awk '{print $2}')
purple "Ceph集群状态"
green "$CEPH_HEALTH"

# OSD Status
OSD_STATUS=$(ceph -s | grep osd | awk '{print "UP:"$4 "    " "IN:"$6}')
purple "OSD状态"
green "$OSD_STATUS"

# OSD Usage
OSD_USE=$(ceph osd df tree | grep -v host | grep -v MIN | grep -v TOTAL |  ceph osd df tree | grep -v host | grep -v MIN | grep -v TOTAL | awk 'NR!=1&&NR!=2{print $11 "   " $8}')
purple "OSD空间使用率"
green "$OSD_USE"

# Cluster Space Utilization
CLUSTER_SPACE=$(ceph -s | grep usage | awk '{print "Total:"$6 "   " "Used:"$2}')
purple "集群空间使用量"
green "$CLUSTER_SPACE"
