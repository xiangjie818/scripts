#!/bin/bash
HOSTNAME=$(hostname)
SYS_DISK=sda
DISK=$(lsblk | grep disk | awk '{print $1}')
JOURNAL_TYPE=45b0969e-9b03-4f30-b4c6-b4b80ceff106
DATA_TYPE=4fbd7e29-9d25-41b8-afd0-062c0ceff05d
function Sgdisk() {
   sgdisk -n 2:0:+5G -c 2:"ceph journal" -t 2:$JOURNAL_TYPE /dev/$1 &> /dev/null
   sgdisk -n 1:0:0 -c 1:"ceph data" -t 1:$DATA_TYPE /dev/$1 &> /dev/null
   mkfs.xfs -f -i size=2048 /dev/${1}1 &> /dev/null
}

function Crushmap() {
   ceph osd crush add-bucket $1 host &> /dev/null
   ceph osd crush move $1 root=default &> /dev/null
}

function CreateOSD() {
   OSD_URL=/var/lib/ceph/osd/ceph-$1
   DATA_PARTITION=/dev/${i}1
   JOURNAL_UUID=$(ls -l /dev/disk/by-partuuid/ | grep ${i}2 | awk '{print $9}')
   mkdir -p $OSD_URL
   mount $DATA_PARTITION $OSD_URL
   ceph-osd -i $1 --mkfs --mkkey &> /dev/null
   rm -rf $OSD_URL/journal
   ln -s /dev/disk/by-partuuid/$JOURNAL_UUID $OSD_URL/journal
   echo $JOURNAL_UUID > $OSD_URL/journal_uuid
   ceph-osd -i $1 --mkjournal &> /dev/null
   ceph auth add osd.$1 mon 'allow profile osd' mgr 'allow profile osd' osd 'allow *' rgw 'allow *' -i $OSD_URL/keyring &> /dev/null
   ceph osd crush add osd.$1 0.01459 host=$HOSTNAME &> /dev/null
   chown -R ceph:ceph $OSD_URL
   ceph-disk activate --mark-init systemd --mount $DATA_PARTITION &> /dev/null
   if [ $? = 0 ] ; then
   echo -e "\033[32mosd.$1 was created successfully\033[0m"
   fi
}

ceph osd tree | grep mon1 &> /dev/null
if [ $? != 0 ] ; then
   Crushmap $HOSTNAME
fi

for i in $DISK ; do
   blkid | grep ceph | grep $i &> /dev/null
   if [ $? != 0 ] && [ $i != $SYS_DISK ] ; then
      Sgdisk $i
      ID=$(ceph osd create)
      CreateOSD $ID
   else
      continue
   fi
done
