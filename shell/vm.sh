#!/bin/bash
function Color() {
    echo -e "\033[31m$1\033[0m"
}

Color "Your VM Hostname: "
read VM_NAME

Color "Data Disk Number: "
read DDISK_NUM

MEM=8192
VCPUS=4
SYS_SIZE=40G
DDISK_SIZE=20G
PASSWD=123456

#QCOW2_NUM=$(ls /var/lib/libvirt/images/ | grep CentOS-7 | awk -F[-.] '{print $5}' | sort -n | tail -1)
QCOW2_NUM=$(ls /var/lib/libvirt/images/ | grep OL-7.3 | awk -F[-.] '{print $4}' | sort -n | tail -1)
OL_QCOW2_IMG=/var/lib/libvirt/images/$(ls /var/lib/libvirt/images/ | grep $QCOW2_NUM)
QCOW2_DIR=/var/lib/libvirt/images/$VM_NAME
SYS_IMG=$QCOW2_DIR.qcow2

cp $OL_QCOW2_IMG $SYS_IMG
qemu-img resize $SYS_IMG $SYS_DSIZE &> /dev/null
virt-customize -a $SYS_IMG --root-password password:$PASSWD &> /dev/null

i=1
DDISK=" "
while [ $i -le $DDISK_NUM ] ; do
    qemu-img create -f qcow2 ${QCOW2_DIR}-data$i.qcow2 $DDISK_SIZE &> /dev/null
    DDISK="$DDISK --disk path=${QCOW2_DIR}-data$i.qcow2"
    let i++
done

virt-install --boot hd \
    --name $VM_NAME \
    --memory=$MEM \
    --vcpus=$VCPUS \
    --disk path=$SYS_IMG $DDISK \
    --network network=only-host \
    --network network=nat \
    --graphics=spice,listen='0.0.0.0' \
    --hvm \
    --os-variant=centos7.0 \
    --noautoconsole \
    --import \
    --noreboot &> /dev/null

if [ $? = 0 ] ; then
   echo -e "\033[32mVM $VM_NAME create successful\033[0m"
else
   echo -e "\033[31mVM $VM_NAME create failed\033[0m"
fi
