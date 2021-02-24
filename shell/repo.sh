#!/bin/bash
# Remove duplication
function duple() {
    cd $1
    DUPLE_FILES=$(ls $1 | grep -v repodata)
    for i in $DUPLE_FILES ; do
        if [ -f /repo/os/$i ] ; then
            rm -rf $i
        fi
    done
}

function epel() {
    cd $1
    EPEL_FILES=$(ls $1 | grep -v repodata)
    for i in $EPEL_FILES ; do
        if [ -f /repo/ceph/rhel/$i ] ; then
            mv -f $i /repo/epel
        fi
    done
}
CEPH_DIR=$(ls /repo/ceph | grep -v repodata | grep -v rhel)
for i in $CEPH_DIR ; do
      duple /repo/ceph/$i
done

for i in $CEPH_DIR ; do
      epel /repo/ceph/$i
done

for i in /repo/ansible/ /repo/grafana/ ; do
      duple $i
done
