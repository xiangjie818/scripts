#!/bin/bash
# Install Packages
HOSTNAME=`hostname`
rpm -qa | grep ceph-radosgw &> /dev/null
if [ $? != 0 ] ; then
   yum -y install ceph-radosgw &> /dev/null
   if [ $? = 0 ] ; then
      echo "ceph-radosgw install successfull"
   else
      break
   fi
fi

# Create key
RGW_DIR=/var/lib/ceph/radosgw/ceph-rgw.$HOSTNAME/
RGW_KEY=$RGW_DIR/keyring
CEPH_KEY=/etc/ceph/ceph.client.admin.keyring
RGW_NAME=client.rgw.$HOSTNAME
RGW_SERVICE=ceph-radosgw@rgw.$HOSTNAME

if [ ! -d $RGW_DIR ] ; then
   mkdir -p $RGW_DIR
fi

sudo ceph-authtool --create-keyring $RGW_KEY &> /dev/null
sudo chown -R ceph:ceph $RGW_DIR &> /dev/null
sudo ceph-authtool $RGW_KEY -n $RGW_NAME --gen-key &> /dev/null
sudo ceph-authtool -n $RGW_NAME --cap osd 'allow rwx' --cap mon 'allow rwx' --cap mgr 'allow rwx' $RGW_KEY &> /dev/null
sudo ceph -k $CEPH_KEY auth add $RGW_NAME -i $RGW_KEY &> /dev/null

echo """
[$RGW_NAME]
host = $HOSTNAME
keyring = $RGW_KEY
rgw_frontends = civetweb port=8080""" >> /etc/ceph/ceph.conf

systemctl enable $RGW_SERVICE &> /dev/null
systemctl start $RGW_SERVICE &> /dev/null

if [ $? = 0 ] ; then
   echo -e "\033[32mrgw.$HOSTNAME was created successfully\033[0m"
fi
