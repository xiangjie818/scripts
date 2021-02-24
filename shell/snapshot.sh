#!/bin/bash
HOST_LIST=$(virsh list --all | awk 'NR!=1&&NR!=2 {print $2}')
echo -e "\033[35mAvaliable Hosts: \033[0m"
echo -e  "\033[36m$HOST_LIST\033[0m"

read -p "Host: " HOST

echo "********************************"
echo "Please select your option."
echo "1) Create Snapshot"
echo "2) Revert Snapshot"
echo "3) Delete Snapshot"
echo "4) Exit"
echo "********************************"
read option

case $option in
    1)
        read -p "Snapshot Name: " NAME
        virsh snapshot-create-as $HOST $NAME
        ;;
    2)
        echo "\033[35mAvailable Snapshot: \033[0m"
        SNAP_LIST=$(virsh snapshot-list $HOST)
        echo -e "\033[36m$SNAP_LIST\033[0m"
        read -p "Snapshot Name: " NAME
        virsh snapshot-revert $HOST $NAME
        ;;
    3)
        echo -e "\033[35mAvailable Snapshot: \033[0m"
        SNAP_LIST=$(virsh snapshot-list $HOST)
        echo -e "\033[36m$SNAP_LIST\033[0m"
        read -p "Snapshot Name: " NAME
        virsh snapshot-delete $HOST $NAME
        ;;
    4)
        break
        ;;
esac

