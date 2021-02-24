#!/bin/bash
HOSTNAME=`hostname`
MGR_DIR=/var/lib/ceph/mgr/ceph-$HOSTNAME
MGR_NAME=mgr.$HOSTNAME
MGR_SERVICE=ceph-mgr@$HOSTNAME

ceph auth get-or-create $MGR_NAME mon 'allow *' osd 'allow *' &> /dev/null

if [ ! -d $MGR_DIR ] ; then
   mkdir -p $MGR_DIR
fi

ceph auth get $MGR_NAME -o $MGR_DIR/keyring &> /dev/null
chown -R ceph:ceph $MGR_DIR &> /dev/null
systemctl enable $MGR_SERVICE &> /dev/null
systemctl start $MGR_SERVICE &> /dev/null

if [ $? = 0 ] ; then
   echo -e "\033[32mmgr.$HOSTNAME was created successfully\033[0m"
fi
